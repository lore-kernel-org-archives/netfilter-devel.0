From: Harald Welte <laforge@gnumonks.org>
Subject: Re: MIME Patches (was [PATCH] ROUTE target : bug fixes)
Date: Sat, 22 Jun 2002 18:41:17 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020622184117.A31606@sunbeam.de.gnumonks.org>
References: <1024582362.2418.30.camel@descartes> <20020621191526.G2543@sunbeam.de.gnumonks.org> <20020621175624.GF2355@titanium.brain.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Ben Reser <ben@reser.org>
Content-Disposition: inline
In-Reply-To: <20020621175624.GF2355@titanium.brain.org>; from ben@reser.org on Fri, Jun 21, 2002 at 10:56:24AM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2002 at 10:56:24AM -0700, Ben Reser wrote:
> On Fri, Jun 21, 2002 at 07:15:26PM +0200, Harald Welte wrote:
> > Please try to send patches as mime attachment to ensure no corruption=
=20
> > occurs.
>=20
> Okay this is confusing.  Your scoreboard guidelines
> (http://www.netfilter.org/scoreboard/) say that you should include
> patches "straight in the body of the message, not MIME'd."  Honestly
> I've always found this policy bizzare.

This is because Rusty wrote it, and he wants to have it this way [like
many other kernel hackers incl. David Miller] because emacs doesn't
handle mime mail.

> Either way we should pick a standard and follow it.  Frankly MIME is a
> common standard and attaching patch is intuitive.  So I think we should
> go that route. =20

yes. The core team agreed on that long time ago, since I'm handling
most patches these days I am the one to set the rules ;)

I'm updating the scoreboard/index.html now.

> Ben Reser <ben@reser.org>

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

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9FKisXaXGVTD0i/8RAmFqAJ9REcI5P92GUKXOfEDFuOR2Bq8szACdHRJ9
SBWx6UKIqhqW/aXD6PP7fN0=
=bftm
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
