From: Harald Welte <laforge@netfilter.org>
Subject: Re: Ctnetlink?
Date: Mon, 3 Nov 2003 08:50:30 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031103075030.GO1536@sunbeam.de.gnumonks.org>
References: <661F9268BBA8CB4EB92CC12B8C42F06901F6AE@pluto.rovingplanet.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aEJuoWUqNbltyjQQ"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Paul Albert <palbert@rovingplanet.com>
Content-Disposition: inline
In-Reply-To: <661F9268BBA8CB4EB92CC12B8C42F06901F6AE@pluto.rovingplanet.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--aEJuoWUqNbltyjQQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2003 at 06:10:15PM -0700, Paul Albert wrote:
> Hi all -=20
>=20
> I'm quite interested in removing some or all of the connection tracking
> entries at various times while iptables is in operation.  My searching
> around the archives had led me to a mysterious piece of code, ctnetlink.
> I can see it listed in the POM, however, the patch link isn't valid.

patch-o-matic is a set of specially-formated patches and the according
software.  just downloading a .patch file wouldn't help anyway.  you
need to download the patch-o-matic suite (either the latest release, or
via anonymous cvs).

> Will this provide me a command-line interface to remove connections from
> ip_conntrack?

no, but you can easily write one that sends the respective netlink
messages to the ctnetlink core.

> Is there more documentation on this?

no.
>=20

> From looking through the code, it appears that I could call
> ip_conntrack_cleanup in ip_conntrack_core.c to remove all of the
> entries.  Would this work or is there a better way?

this is inside the kernel.  I suppose you were looking for a way to do
this from a userspace app?

> Thanks much,
> Paul

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--aEJuoWUqNbltyjQQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/pgjGXaXGVTD0i/8RAslsAJ9/9xRHhBhE97Zq0/z8pAviNBKFMQCfTRlh
RCqRv/mBlAqIOmUddlrr4L8=
=Z0Eq
-----END PGP SIGNATURE-----

--aEJuoWUqNbltyjQQ--
