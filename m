From: Harald Welte <laforge@gnumonks.org>
Subject: Re: really fix iplimit 'second try' bug
Date: Thu, 28 Nov 2002 09:04:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021128080413.GI7047@naboo.de.gnumonks.org>
References: <4D618F6493CE064A844A5D496733D6670314EC@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OWHXb1mYLuhj1Ox"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Bene <martin.bene@icomedias.com>
Content-Disposition: inline
In-Reply-To: <4D618F6493CE064A844A5D496733D6670314EC@freedom.icomedias.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--0OWHXb1mYLuhj1Ox
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 23, 2002 at 02:00:48PM +0100, Martin Bene wrote:
> There's still a problem in the iplimit module: when trying to connect usi=
ng
> the same source port twice, the second connection succeeds.
> The patch proposed by Sumit Pandya sumit@elitecore.com for fixing this
> doesn't work - it doesn't address the actual problem.

Thanks for pointing this out.

> Please remove the non-working fix from cvs; I've posted a working patch to
> the list (see
> http://lists.netfilter.org/pipermail/netfilter-devel/2002-November/009849=
.htm
> l)

I'll apply your patch as soon as I have some IP connection...

> Bye, Martin

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

--0OWHXb1mYLuhj1Ox
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE95c39XaXGVTD0i/8RAqhqAJ4qJOWh0/CXkpyXLZr92kA7BfosIwCfTcSp
p5Z1nySqGVDwE53/C3Rl3hs=
=UEBR
-----END PGP SIGNATURE-----

--0OWHXb1mYLuhj1Ox--
