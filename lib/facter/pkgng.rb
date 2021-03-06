
Facter.add("pkgng_supported") do
  confine :kernel => ["FreeBSD", "DragonFly"]

  setcode do
    os = Facter.value('kernel')
    kernel = Facter.value('kernelversion')
    if os == "FreeBSD"
      if kernel =~ /^(8|9|10|11)(\.[0-9])?/
        "true"
      end
    elsif os == "DragonFly"
      maj, min = kernel.split('.').map { |s| s.to_i }
      if maj > 3 or (maj == 3 and min >= 4)
        "true"
      end
    end
  end

end

Facter.add("pkgng_enabled") do
  confine :kernel => ["FreeBSD", "DragonFly"]

  setcode do
    if system("TMPDIR=/dev/null ASSUME_ALWAYS_YES=1 PACKAGESITE=file:///nonexistent pkg info pkg >/dev/null 2>&1")
      "true"
    end
  end

end

Facter.add("pkgng_version") do
  confine :kernel => ["FreeBSD", "DragonFly"]

  setcode do
    if Facter.value('pkgng_enabled') == "true"
      Facter::Util::Resolution.exec("pkg query %v pkg 2>/dev/null")
    end
  end

end
