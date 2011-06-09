From: Bertrand Jacquin <beber@meleeweb.net>
Subject: ebtables-2.0.9-2 libebetc PHONY
Date: Fri, 10 Jun 2011 01:11:31 +0200
Message-ID: <20110609231131.GA6508@lemonhead.scabb>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from toothrot.meleeweb.net ([88.191.120.102]:58256 "EHLO
	toothrot.meleeweb.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab1FIXXn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:23:43 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--nVMJ2NtxeReIH9PS
Content-Type: multipart/mixed; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

ebtables-v2.0.9-2 declare libebetc.so as PHONY. I'm wondering why. In my
case I'm cross-compiling it and define CC only for compilation. So when
running "make install" libebtc.so is one more time builded without CC
defined, so it failed :

# make
=2E.
i586-geode-linux-gnu-gcc -Os -pipe -march=3Dk6-2 -fomit-frame-pointer -I/us=
r/i586-geode-linux-gnu/usr/include/ -I/usr/i586-geode-linux-gnu/include/ -L=
/usr/i586-geode-linux-gnu/lib -L/usr/i586-geode-linux-gnu/usr/lib -Wl,--no-=
as-needed -o ebtables-restore ebtables-restore.o -Iinclude/ -L. -Lextension=
s -lebtc  -lebt_802_3  -lebt_nat  -lebt_arp  -lebt_arpreply  -lebt_ip  -leb=
t_ip6  -lebt_standard  -lebt_log  -lebt_redirect  -lebt_vlan  -lebt_mark_m =
 -lebt_mark  -lebt_pkttype  -lebt_stp  -lebt_among  -lebt_limit  -lebt_ulog=
  -lebt_nflog  -lebtable_filter  -lebtable_nat  -lebtable_broute \

# make install
mkdir -p /usr/i586-geode-linux-gnu/tmp/portage/net-firewall/ebtables-2.0.9.=
2-r1/image//etc
install -m 0644 -o root -g root ethertypes /usr/i586-geode-linux-gnu/tmp/po=
rtage/net-firewall/ebtables-2.0.9.2-r1/image//etc/ethertypes
gcc -shared -L/usr/i586-geode-linux-gnu/lib -L/usr/i586-geode-linux-gnu/usr=
/lib -Wl,--no-as-needed -Wl,-soname,libebtc.so -o libebtc.so -lc getetherty=
pe.o communication.o libebtc.o useful_functions.o ebtables.o
/usr/lib/gcc/x86_64-pc-linux-gnu/4.5.2/../../../../x86_64-pc-linux-gnu/bin/=
ld: skipping incompatible /usr/i586-geode-linux-gnu/usr/lib/libc.so when se=
arching for -lc
/usr/lib/gcc/x86_64-pc-linux-gnu/4.5.2/../../../../x86_64-pc-linux-gnu/bin/=
ld: skipping incompatible /usr/i586-geode-linux-gnu/usr/lib/libc.a when sea=
rching for -lc
/usr/lib/gcc/x86_64-pc-linux-gnu/4.5.2/../../../../x86_64-pc-linux-gnu/bin/=
ld: skipping incompatible /usr/i586-geode-linux-gnu/usr/lib/libc.so when se=
arching for -lc
/usr/lib/gcc/x86_64-pc-linux-gnu/4.5.2/../../../../x86_64-pc-linux-gnu/bin/=
ld: skipping incompatible /usr/i586-geode-linux-gnu/usr/lib/libc.a when sea=
rching for -lc
/usr/lib/gcc/x86_64-pc-linux-gnu/4.5.2/../../../../x86_64-pc-linux-gnu/bin/=
ld: i386 architecture of input file `getethertype.o' is incompatible with i=
386:x86-64 output
/usr/lib/gcc/x86_64-pc-linux-gnu/4.5.2/../../../../x86_64-pc-linux-gnu/bin/=
ld: i386 architecture of input file `communication.o' is incompatible with =
i386:x86-64 output
/usr/lib/gcc/x86_64-pc-linux-gnu/4.5.2/../../../../x86_64-pc-linux-gnu/bin/=
ld: i386 architecture of input file `libebtc.o' is incompatible with i386:x=
86-64 output
/usr/lib/gcc/x86_64-pc-linux-gnu/4.5.2/../../../../x86_64-pc-linux-gnu/bin/=
ld: i386 architecture of input file `useful_functions.o' is incompatible wi=
th i386:x86-64 output
/usr/lib/gcc/x86_64-pc-linux-gnu/4.5.2/../../../../x86_64-pc-linux-gnu/bin/=
ld: i386 architecture of input file `ebtables.o' is incompatible with i386:=
x86-64 output
collect2: ld returned 1 exit status

Attached a patch to not PHONY libebtc.so

--=20
Beber

--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="ebtables-2.0.9-2-libebtc.so-PHONY.diff"
Content-Transfer-Encoding: quoted-printable

--- Makefile.ori	2011-06-10 00:57:34.000000000 +0200
+++ Makefile	2011-06-10 01:06:27.000000000 +0200
@@ -82,7 +82,6 @@
 ebtables-standalone.o: ebtables-standalone.c include/ebtables_u.h
 	$(CC) $(CFLAGS) $(CFLAGS_SH_LIB) $(PROGSPECS) -c $< -o $@ -I$(KERNEL_INCL=
UDES)
=20
-.PHONY: libebtc
 libebtc: $(OBJECTS2)
 	$(CC) -shared $(LDFLAGS) -Wl,-soname,libebtc.so -o libebtc.so -lc $(OBJEC=
TS2)
=20

--SUOF0GtieIMvvwua--

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk3xUyMACgkQibjJUzm7jPRhiACfToIN21wWqcTsX2qfJsNYWHKd
tmwAoKtZ86+zCCJR0vrJYJodx3eT2+K4
=1Uiz
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--
