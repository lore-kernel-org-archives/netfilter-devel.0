From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] User defined udp and tcp conntrack state timeouts
Date: Thu, 19 Sep 2002 08:46:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020919084658.J3810@sunbeam.de.gnumonks.org>
References: <20020918214534.GC10465@oknodo.bof.de> <Pine.LNX.4.33.0209181518150.5702-100000@beavis.networkrobots.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gj0lynkWKwPe+BJK"
Cc: Patrick Schaaf <bof@bof.de>, Jay Schulist <jschlst@linux-sna.org>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jay Schulist <jschulist@bivio.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0209181518150.5702-100000@beavis.networkrobots.com>; from jschulist@bivio.net on Wed, Sep 18, 2002 at 03:19:03PM -0700
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--gj0lynkWKwPe+BJK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2002 at 03:19:03PM -0700, Jay Schulist wrote:
> On Wed, 18 Sep 2002, Patrick Schaaf wrote:
>=20
> > Better avoid it in the first place, and convert internally, if it's
> > not too much hassle. Isn't there a suitable sysctl helper for this
> > situation? I vaguely remember something like that. Show seconds to
> > the user, convert to internal format (eg. HZ) upon modification.
> >=20
>=20
> good idea, there is a sysctl function to handle the jiffies conversion so=
=20
> it is quite easy to change.

This sounds excellent.  I once had problems with a different interface expo=
sing
HZ-derived values to userspace... the old icmp rate limiting.  This way it
was impossible to have an architecture-independent /etc/sysctl.conf for icmp
rate limiting - even user mode linux has a differrent HZ...

I'm postponing this patch until the change was made.

> jay-s.

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

--gj0lynkWKwPe+BJK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9iXLiXaXGVTD0i/8RAvtbAKCn9ch/RPglLiXvP/Xd7Ajni64TVQCfWuWd
XSCwo/sKNy0sS6yn+Vihu7w=
=dRkl
-----END PGP SIGNATURE-----

--gj0lynkWKwPe+BJK--
