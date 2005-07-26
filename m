From: Harald Welte <laforge@netfilter.org>
Subject: Re: Netlink connector
Date: Tue, 26 Jul 2005 04:42:14 -0400
Message-ID: <20050726084214.GG7925@rama>
References: <20050723125427.GA11177@rama> <20050723091455.GA12015@2ka.mipt.ru>
	<20050724.191756.105797967.davem@davemloft.net>
	<Lynx.SEL.4.62.0507250154000.21934@thoron.boston.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Il7n/DHsA0sMLmDu"
Cc: johnpol@2ka.mipt.ru, Andrew Morton <akpm@osdl.org>,
	netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, netdev@redhat.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: James Morris <jmorris@redhat.com>
Content-Disposition: inline
In-Reply-To: <Lynx.SEL.4.62.0507250154000.21934@thoron.boston.redhat.com>
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


--Il7n/DHsA0sMLmDu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 25, 2005 at 02:02:10AM -0400, James Morris wrote:
> On Sun, 24 Jul 2005, David S. Miller wrote:
> >From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> >Date: Sat, 23 Jul 2005 13:14:55 +0400
> >>Andrew has no objection against connector and it lives in -mm
> >A patch sitting in -mm has zero significance.
>=20
> The significance I think is that Andrew is trying to gently encourage som=
e=20
> further progress in the area.

Patrick McHardy is currently working on some ideas on how to extend
netlink.

The fundamental problem that the connector is trying to solve:

1) provide more 'groups' (to transport more different kinds of events)
2) provide an abstract API for other kernel code, so it doesn't have to
   know anything about skb's or networking.

IMHO issue number '1' should (and can) be adressed within netlink.  Wait
for Patrick's work on this to show up on netdev.  We can then think
whether the connctor API (or something similar) can be put on top of it.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Il7n/DHsA0sMLmDu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC5fdmXaXGVTD0i/8RAl1WAKCQAD4+NFRr1MxqhTpWwluzmWTmUQCeO7r0
Ag/KZSUDLX7PLT/eDmXsOIE=
=kYAe
-----END PGP SIGNATURE-----

--Il7n/DHsA0sMLmDu--
