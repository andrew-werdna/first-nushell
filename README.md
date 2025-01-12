# Description

I've been wanting to learn Nushell and just for funzies created this
to demonstrate an example for a friend

## Usage

What this is intended to do is to:  
- read a file (VERSION) and parse the SemVer
- read the change notes from a folder (changes | other)
- conditionally update the SemVer using incorrect logic, or valid SemVer logic
- write the updated version to a file (NEWVERSION)

## Examples

If you've installed nushell, you can do:  
- `nu versions.nu ascent VERSION changes`
- `nu versions.nu ascent VERSION other`
- `nu versions.nu semver VERSION changes`
- `nu versions.nu semver VERSION other`