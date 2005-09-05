From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 3/3] Implement private protocol info changing
Date: Mon, 5 Sep 2005 12:04:12 +0200
Message-ID: <20050905100412.GF20386@sunbeam.de.gnumonks.org>
References: <430E2DE3.3020700@eurodev.net> <431B36AE.2080505@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tmoQ0UElFV5VgXgH"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <431B36AE.2080505@trash.net>
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


--tmoQ0UElFV5VgXgH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 04, 2005 at 08:02:22PM +0200, Patrick McHardy wrote:
> Pablo Neira wrote:
> >This patch add support to change the state of the private protocol=20
> >information via conntrack_netlink.
>=20
> The patches look fine to me, besides the two issues mentioned below.
> I have a couple of fixes which conflict with them though, please
> resend after they hit Linus's tree.

I also wasn't yet sure whether the current nesting is the best possible
solution.  Sorry, was too busy with non-netfilter stuff recently so I
couldn't comment on that.  I'll try to comment on it later today.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--tmoQ0UElFV5VgXgH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDHBgcXaXGVTD0i/8RAl6DAJ4wPhroXJmuPBYbNx+MmytPCWEVhQCggKTs
23VvymhwrU24o3KsyF2as1E=
=MgTW
-----END PGP SIGNATURE-----

--tmoQ0UElFV5VgXgH--
