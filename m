From: Matthias Schiffer <mschiffer@universe-factory.net>
Subject: Re: [PATCH xtables-addons] build: fix configure compatiblity with
 POSIX shells
Date: Sun, 3 Apr 2016 13:57:29 +0200
Message-ID: <57010529.3030404@universe-factory.net>
References: <080ce332d72f144b21b5d63986b6e8ebd9bc3095.1459542934.git.mschiffer@universe-factory.net>
 <alpine.LSU.2.20.1604031202380.31323@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="t01WhD8F4kMR5ijt51Vo3fdnIm0VcL1Qx"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from chaos.universe-factory.net ([37.72.148.22]:39416 "EHLO
	chaos.universe-factory.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676AbcDCL5e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Apr 2016 07:57:34 -0400
In-Reply-To: <alpine.LSU.2.20.1604031202380.31323@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--t01WhD8F4kMR5ijt51Vo3fdnIm0VcL1Qx
Content-Type: multipart/mixed; boundary="2wFuqSwUjbwaeOLX8ub8tCkWVFwOf79XA"
From: Matthias Schiffer <mschiffer@universe-factory.net>
To: Jan Engelhardt <jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
Message-ID: <57010529.3030404@universe-factory.net>
Subject: Re: [PATCH xtables-addons] build: fix configure compatiblity with
 POSIX shells
References: <080ce332d72f144b21b5d63986b6e8ebd9bc3095.1459542934.git.mschiffer@universe-factory.net>
 <alpine.LSU.2.20.1604031202380.31323@nerf40.vanv.qr>
In-Reply-To: <alpine.LSU.2.20.1604031202380.31323@nerf40.vanv.qr>

--2wFuqSwUjbwaeOLX8ub8tCkWVFwOf79XA
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/03/2016 12:11 PM, Jan Engelhardt wrote:
> On Friday 2016-04-01 22:35, Matthias Schiffer wrote:
>=20
>> The kernel version detection code uses some bashisms, which makes the =
build
>> fail on Debian systems where /bin/sh links to dash. Replace with POSIX=
-
>> conforming commands at the cost of requiring awk.
>> +	krel=3D"$(make -sC "$kbuilddir" M=3D$PWD kernelrelease | $AWK -v 'FS=
=3D[[^0-9.]]' '{print $1; exit}')";
>> +	save_IFS=3D$IFS;
>> +	IFS=3D'.';
>> +	set x $krel;
>> +	kmajor=3D"$(($2+0))";
>> +	kminorb=3D"$(($3+0))";
>> +	kmicro=3D"$(($4+0))";
>> +	kstable=3D"$(($5+0))";
>> +	IFS=3D$save_IFS;
>> 	if test -z "$kmajor" -o -z "$kminor" -o -z "$kmicro"; then
>=20
> To test its resilience against silly krel strings (not exactly unheard =
of),
> let's pretend that
>=20
> 	krel=3D"4x.6.0"
>=20
> The previous code would conclude (albeit with a silly broken-up version=
 like
> 4.0.6.0 or 0.0.0.0). However, your change makes the script totally fall=
s over:
>=20
> checking kernel version that we will build against... ./configure: line=

> 11957: 4x: value too great for base (error toke
> n is "4x")
> ./configure: line 8: printf %s\n: command not found
> ./configure: line 14: AMDEPBACKSLASH: command not found
> ./configure: line 15: AMDEP_FALSE: command not found
> ./configure: line 16: AMDEP_TRUE: command not found
> ./configure: line 17: AMTAR: command not found
> [...]
>=20
> (and who knows what other commands - rm? - it tries to execute by sheer=

> chance).
> Is it possible to harden the dash-compatible variant?
>=20

Weird, what version/variant of awk are you using (or were you just changi=
ng
the value of krel in an artificial test and dropped the awk call
altogether)? krel should be cut off at the first character not in the set=

[0-9.], so krel would be "4" and version 4.0.0.0 should result.

If found out though that configure really doesn't like failures while IFS=

is modified, as it sets up a cleanup trap that will break completely in
this case (resulting in the tons of "command not found").

I'll send a v2 which resets IFS to its old value directly after the set
line, so even on systems with broken awk (which should not exist), the
script will just fail with "4x: value too great for base" or similar, and=

nothing worse.

Matthias


--2wFuqSwUjbwaeOLX8ub8tCkWVFwOf79XA--

--t01WhD8F4kMR5ijt51Vo3fdnIm0VcL1Qx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJXAQUpAAoJEBbvP2TLIB2cU78QAKV9YIdUZT8RyB86cTrIAXE2
TKSpSOCoTUu3qKB4ObM7RqAqkQ2SyYj7GiUSQKlDZbzoN+Qe6uTl+hkK4i72frCa
G/AmsZUpA90rseXzQUA6x656H3usAUDXgqzAZRqnHn2dRTVa4uoBVkFNVxNT0jgv
hRqJITxdl6sh91eYky2RzV4PuRBdbjuymdR2LpL8M2eL6p+pocESQddevf0DCznB
l9foCJcIRTfMcKqPPMZZguda6xb/YxiGspFHm0y94q5bB1Gg/Ig8F5nxjjjgj80c
oM6uVLIgDL9XZOtkVW4k93dUwOt1a8AkERMmMyKkbXr7W4GgUvkI/RPLCqhW/ojO
P7/O1EhuT4WxWYFQr515BnDEvEE7ERDEyXunPfh01K4sAdhs/OZKh38Dufp8Af8S
dOMOPTq+ZupK7MY82ylauSV2mqYnBJSK2cMv5tHmF9/XkebqJIqdvVu1Qh1O01eP
k8LdjFWoDLLBmXfMvWd8wrQye6tnBw6o/DO7wed7+2PeeLm66bbPOfbPADdyVj02
U3v36EzwSOBxu4g8wSbU/qsKMnURBUG6l8AtGOzqdu0LG/53Z4Z+c+LbCv0oP3Hq
S7BF6+Y+H9GaacPuWGyct7HOddBMixv4ePxOi4TK1NX+ig0nNDTapTjo529bgB9c
7Yy+v+4uwaXjKePNgIOH
=Y4Vn
-----END PGP SIGNATURE-----

--t01WhD8F4kMR5ijt51Vo3fdnIm0VcL1Qx--
