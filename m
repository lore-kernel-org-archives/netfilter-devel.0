From: Harald Welte <laforge@netfilter.org>
Subject: Re: endian issue in conntrack_netlink
Date: Fri, 26 Aug 2005 10:39:16 +0200
Message-ID: <20050826083916.GE4226@rama.de.gnumonks.org>
References: <430E3384.6000305@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lkTb+7nhmha7W+c3"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <430E3384.6000305@eurodev.net>
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


--lkTb+7nhmha7W+c3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 25, 2005 at 11:09:24PM +0200, Pablo Neira wrote:
> Hi Harald,
>=20
> while working on the conntrack tool I've observed that conntrack_netlink =
 uses cpu_to_be64,=20
> htonl... to flip bits depending on the architecture. Is this some kind of=
 portability issue?

yes, it means that all the payload of any nfattr will always be in
network byte order.  This would allow easy transport over a real network
in the future (e.g. jamal's netlink2).

The nlmsghdr and the nfattr headers (type and length) are still host
byte order.  But some easy program (e.g. the deamon that receives from
netlink and send sover real network) can just iterate over them and
convert them to network byte order - without understanding anything
about the payload.

> BTW, what is the equivalence of be64_to_cpu in userspace? Thanks!

Good question.  I don't think there's a standard way [yet?], so I'd
suggest manually implementing it by "#if little endian" bitshift
operations in C (at least for now).

Cheers,

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--lkTb+7nhmha7W+c3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDDtU0XaXGVTD0i/8RAhlQAKCpQ+aya/UV33pHB1KJiOJBoCKWwACgpVLc
F/FHpxaG60Me2qMtXuFs+MU=
=pC8d
-----END PGP SIGNATURE-----

--lkTb+7nhmha7W+c3--
