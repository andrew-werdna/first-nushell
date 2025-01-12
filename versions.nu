def main [logic: string, version_file: string, directory: string] {

    # define valid suffixes
    let valid = {
        major: "break" 
        minor: "feat"
        patch: "fix"
    }

    # parse the version file into a semantic version table
    let cv = (
        open $version_file 
        | parse "{major}.{minor}.{patch}"
        | update major {|| into int}
        | update minor {|| into int}
        | update patch {|| into int}
        | first
    )

    print $"current version is"; print $cv;

    # get the files from the directory
    let changefiles = (ls $directory | get name)

    # count major, minor, patch
    let vd = {
        major: ($changefiles | where ($it =~ $valid.major) | length)
        minor: ($changefiles | where ($it =~ $valid.minor) | length)
        patch: ($changefiles | where ($it =~ $valid.patch) | length)
    }

    print $"version difference is"; print $vd;

    mut nv = $cv

    # create new version with "ascent" logic OR SemVer logic
    if $logic == "ascent" {
        $nv = $cv
        | update major { ($cv.major + $vd.major) }
        | update minor { ($cv.minor + $vd.minor) }
        | update patch { ($cv.patch + $vd.patch) }
    } else if $logic == "semver" {
        if ($vd.major > 0) {
            $nv = $cv
            | update major { ($cv.major + 1) }
            | update minor { 0 }
            | update patch { 0 }
        } else if ($vd.minor > 0) {
            $nv = $cv
            | update minor { ($cv.minor + 1) }
            | update patch { 0 }
        } else if ($vd.patch > 0) {
            $nv = $cv | update patch { ($cv.patch + 1) }
        }
                
    } else {
        error make {
            msg: "logic can be: 'ascent' | 'semver'"
        }
    }

    print "new version is"; print $nv;

    $"($nv.major).($nv.minor).($nv.patch)" | save -f NEWVERSION
    
}