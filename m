From: Nigel Cunningham <ncunningham@cyclades.com>
Subject: Compilation warnings in the current git tree.
Date: Sat, 1 Apr 2006 22:24:23 +1000
Message-ID: <200604012224.29745.ncunningham@cyclades.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4561905.qC5FpIaXsU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
Return-path: <linux-scsi-owner@vger.kernel.org>
To: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org,
	netfilter-devel@lists.netfilter.org
Sender: linux-scsi-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--nextPart4561905.qC5FpIaXsU
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all.

Previous comment not-withstanding, there are some issues I found with current git. Apologies to anyone wrongly cc'd :)

Hope this helps.

Regards,

Nigel

WARNING: vmlinux: 'strlen' exported twice. Previous export was in vmlinux
WARNING: drivers/acpi/processor.o - Section mismatch: reference to .init.data: from .text between 'acpi_processor_power_init' (at offset 0x2449) and 'acpi_processor_power_exit'
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x0)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x8)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x10)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x18)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x20)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x28)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x30)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x38)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x40)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x48)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x50)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x58)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x60)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x68)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x70)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x78)
WARNING: net/ipv4/netfilter/ip_conntrack.o - Section mismatch: reference to .init.text:ip_conntrack_init from .text between 'init_or_cleanup' (at offset 0x6ad) and '__hash_conntrack'


--nextPart4561905.qC5FpIaXsU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBELnD9N0y+n1M3mo0RAjBEAJ9nSvRzaPrY0cO02fKlJzjD3hHEaACgwKOd
5/K54Skguy8K3tKENGLl8MM=
=IdMR
-----END PGP SIGNATURE-----

--nextPart4561905.qC5FpIaXsU--
