From: Matt Zagrabelny <mzagrabe@d.umn.edu>
Subject: Re: iptables execution with sudo fails
Date: Mon, 06 Oct 2008 08:19:50 -0500
Message-ID: <1223299190.4745.316.camel@grateful.d.umn.edu>
References: <548BC174642DC44AB25D749C28840FD308C72D7F@ZMY16EXM66.ds.mot.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8ZnHfybpP8+WXuLpif3F"
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Tanneeru Muralidhar Babu-A19589 <muralidharbabu@motorola.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <548BC174642DC44AB25D749C28840FD308C72D7F@ZMY16EXM66.ds.mot.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--=-8ZnHfybpP8+WXuLpif3F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 12:56 +0800, Tanneeru Muralidhar Babu-A19589
wrote:
> Hi,
> =20
> While executing iptables command using sudo on my system (running MV
> 2.6.10), I see following errors. Could someone please help me understand
> this error ?
> =20
> sudo:        0 : uid 0 does not exist in the passwd file! ; TTY=3Dunknown
> ; PWD=3Dunknown ; USER=3Droot ; COMMAND=3D/sbin/iptables
> =20
> Is this a problem with passwd file ? Under what circumstances do we see
> this error ?

Do other commands work with sudo?

What is the exact syntax of the command you are trying to run?

What is the contents of /etc/sudoers?

--=20
Matt Zagrabelny - mzagrabe@d.umn.edu - (218) 726 8844
University of Minnesota Duluth
Information Technology Systems & Services
PGP key 1024D/84E22DA2 2005-11-07
Fingerprint: 78F9 18B3 EF58 56F5 FC85  C5CA 53E7 887F 84E2 2DA2

He is not a fool who gives up what he cannot keep to gain what he cannot
lose.
-Jim Elliot

--=-8ZnHfybpP8+WXuLpif3F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjqEHUACgkQU+eIf4TiLaKTrQCghiSQwjpuzBRtuockVSR5O90u
YwIAoJ15Dl9nqI3cuR+Qzt+Xw8M1MeyJ
=0XYJ
-----END PGP SIGNATURE-----

--=-8ZnHfybpP8+WXuLpif3F--

