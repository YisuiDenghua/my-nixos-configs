final: prev: {
  gnome = prev.gnome.overrideScope'
    (final': prev': {
      mutter = prev'.mutter.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
          (final.fetchpatch {
	    url = "https://raw.githubusercontent.com/puxplaying/mutter-x11-scaling/68b8b2c467f9c8451ffaf44fe9101d6508f56d06/Support-Dynamic-triple-double-buffering.patch";
	    sha256 = "sha256-/GRXOhrrIhB05VBX50+VesIsnUUn/0csSY3DO4RgJu0=";
	  })
	  (final.fetchpatch {
	    url = "https://salsa.debian.org/gnome-team/mutter/-/raw/fef244c14c8ef6c98a5355d901b34f9e2ea2fd4e/debian/patches/ubuntu/x11-Add-support-for-fractional-scaling-using-Randr.patch";
	    sha256 = "sha256-D6ODtlQxSYGQZoIeHvRZw/gR9HKHCrLvjd9jWJK7Rwc=";
	  })
        ];
      });
    });
}

