From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] multiple devices with ranges match support
Date: Thu, 19 Sep 2002 08:47:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020919084757.K3810@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44L.0209172347190.10390-102000@hunger.screamingdaemon.com> <20020918220257.GF10465@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2KJW3tE6NdndVjxo"
Cc: Jay Schulist <jschlst@linux-sna.org>,
	netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20020918220257.GF10465@oknodo.bof.de>; from bof@bof.de on Thu, Sep 19, 2002 at 12:02:57AM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--2KJW3tE6NdndVjxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 19, 2002 at 12:02:57AM +0200, Patrick Schaaf wrote:
> On Tue, Sep 17, 2002 at 11:47:42PM -0700, Jay Schulist wrote:
> > Hello Harald,
> > Here is a new match which allows the user to match by using multiple co=
mma
> > seperated devices each with range support.
> >=20
> > Iptables userspace patch is against a clean iptables-1.2.7a
> > Kernel patch is against a clean linux-2.4.19
> >=20
> > mdev v1.2.7a options:
> >  --i dev[,dev:dev,dev...]       match inbound device(s)
> >  --o dev[,dev:dev,dev...]       match outbound device(s)
>=20
> Wishlist item:
>=20
> In the future, I wish the indev/outdev were gone from the generic
> iptables rule, replaced with exactly such a match as Jay is presenting.

yes. This is what I have in mind with pkt_tables.  I am going to post a
first, preliminary patch today.

> best regards
>   Patrick

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

--2KJW3tE6NdndVjxo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9iXMdXaXGVTD0i/8RAmRJAJ4octO0ZuolvYv/yCW2L2G1Rqka5QCeLN7Z
cGf25yUp1dNu5kPcRgsLfuc=
=8G0+
-----END PGP SIGNATURE-----

--2KJW3tE6NdndVjxo--
