From: Harald Welte <laforge@gnumonks.org>
Subject: Re: fuzzy match pseudo-bug
Date: Sat, 7 Sep 2002 17:29:09 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020907172909.F9675@sunbeam.de.gnumonks.org>
References: <20020903132238.76697.qmail@mail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WN2ELtqJJ9aZ3yHj"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Hime Junior" <hime@engineer.com>
Content-Disposition: inline
In-Reply-To: <20020903132238.76697.qmail@mail.com>; from hime@engineer.com on Tue, Sep 03, 2002 at 08:22:38AM -0500
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--WN2ELtqJJ9aZ3yHj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 03, 2002 at 08:22:38AM -0500, Hime Junior wrote:
>=20
>  Dear Harald:
>=20
>  I don=B4t think it=B4s worth to apply a patch to eliminate a space chara=
cter in
>  the source code .  After all , the compiler has to cope with this (that =
is
>  not a bug in the code) and if it doesn=B4t , somebody has to correct its
>  scanner (lexical analyser) .

You are misunderstanding the problem...
the '\' _has_ to be at the end of a line, since it is an escape-character
for the following newline at the end of the line.  If you add a space betwe=
en
the \ and the end of line, you are escaping this space character and not=20
the end of line character (\n).

>  But , if you think it=B4s worth to eliminate the space character , it=B4=
ll be a
>  pleasure to send a new file ( ipt_fuzzy.c ) .

I have modified the ipt_fuzzy.c file by myself. =20

>   Thanks a lot...
>                     Hime

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--WN2ELtqJJ9aZ3yHj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9ehtEXaXGVTD0i/8RAp/fAJ9HCS8IbXT68wDXBAp5/Pz3SSgUqACeISgc
Szz6rmakXivFcMIi68VFO1s=
=ROvl
-----END PGP SIGNATURE-----

--WN2ELtqJJ9aZ3yHj--
