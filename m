From: Harald Welte <laforge@netfilter.org>
Subject: Re: conntrack event cache deadlock
Date: Thu, 22 Sep 2005 12:27:04 +0200
Message-ID: <20050922102704.GT6516@sunbeam.de.gnumonks.org>
References: <20050921.203350.72192577.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NwG7NuG0/W8LcLh"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20050921.203350.72192577.davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--/NwG7NuG0/W8LcLh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 21, 2005 at 08:33:50PM -0700, David S. Miller wrote:
>=20
> We can try to take the ip_conntrack_lock as a writer twice, and thus
> deadlock, via this code path:

Thanks, this has been pending on our TODO list for quite some time.   We
can also sleep while holding a lock.  The fundamental problem is that
updating the event cache can trigger a previous event to be delivered
(via a notifier chain), and we don't really know what hangs off the
notifier.  Therefore, we have to change the code to only call the event
cache functions outside any locks held.

I'm terribly busy today, but I'll try to look into it asap.

This needs to be fixed before 2.6.14 becomes final.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/NwG7NuG0/W8LcLh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDMob4XaXGVTD0i/8RAi0wAJ9U28Mopx7Fdp75zly7yIeLEIkPdgCdGqMZ
VfK7bll1cKeEwse/Zo/1NeI=
=pdOa
-----END PGP SIGNATURE-----

--/NwG7NuG0/W8LcLh--
