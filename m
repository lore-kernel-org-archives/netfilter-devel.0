From: Harald Welte <laforge@gnumonks.org>
Subject: Re: problem with iplimit - proposed solution
Date: Thu, 28 Nov 2002 09:35:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021128083513.GD7297@naboo.club.berlin.ccc.de>
References: <4D618F6493CE064A844A5D496733D6670314C2@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IDYEmSnFhs3mNXr+"
Cc: wojtektm@poczta.onet.pl, romp@siil.net, sumit@elitecore.com,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Bene <martin.bene@icomedias.com>
Content-Disposition: inline
In-Reply-To: <4D618F6493CE064A844A5D496733D6670314C2@freedom.icomedias.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--IDYEmSnFhs3mNXr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2002 at 02:30:55PM +0100, Martin Bene wrote:
> [same Mail to netfilter-devel@lists.netfilter.org doesn't seem to get
> through, so resending to personal addressess]

yup, unfortunately the mailinglist software (mailman) was blocked, and I
still don't have a phoneline (and thus IP-connectivity) after moving to
Berlin.

But now the list should work again.

> Looking at ipt_iplimit.c it's pretty obvious what happens: if a connectio=
n is
> found in the table, adding it as new is disabled, regardless of the state=
 of
> the found connection. The new connection mustn't be ignored unless it's i=
n a
> valid state in the table (neither gone nor TCP_CONNTRACK_TIME_WAIT state).

well spotted.

> The attached patch fixes the problem for me. Warning: when touching kernel
> source I definitely DON'T know what I'm doing.

I'll apply your patch as soon as I have IP connectivity again [doing
UUCP every two days from a friend's place right now].

> Hope this helps someone,

Thanks.

> Martin

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--IDYEmSnFhs3mNXr+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE95dVBXaXGVTD0i/8RAt4GAJoDUbu0I/uEbePWE8G+14Fv/DMNogCgrgni
vfCxU+ue9ZfcPzZHZ+v4ZQI=
=7cmH
-----END PGP SIGNATURE-----

--IDYEmSnFhs3mNXr+--
