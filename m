From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/*] nfnetlink updates
Date: Sun, 17 Jul 2005 22:38:22 +0000 (UTC)
Message-ID: <20050719094842.GA3768@rama>
References: <42D42975.8070303@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Date: Tue, 19 Jul 2005 11:48:42 +0200
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <42D42975.8070303@eurodev.net>
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


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pablo, thanks for your patches.

On Tue, Jul 12, 2005 at 10:35:01PM +0200, Pablo Neira wrote:

> a) nfnetlink groups: Up to 32 maximum.
>=20
> +#define NF_NETLINK_CONNTRACK_NEW       0x1
> +#define NF_NETLINK_CONNTRACK_UPDATE    0x2
> +#define NF_NETLINK_CONNTRACK_DESTROY   0x4
> +#define NF_NETLINK_CONNTRACK_EXPECT    0x8
>=20
> I think that those four groups are enough to group events.
>
> d) NFNL_SUBSYS_CTNETLINK_EXP has been killed. This is superseded by the g=
roup=20
> NF_NETLINK_CONNTRACK_EXPECT.
>=20

Patrick and me have just discussed this subject, and we thought it would
be better to only have the first three groups and keep the expectations
in their own subsys.  This seems more orthogonal, so the group tells you
the kind of event (new/update/destroy), and the subsystem indicates
conntrack/expect.

> e) nfnetlink_subsystem internal list isn't used, the array is enough.

great.

Ok, so with the minor change above, I think all of the changes are fine.

I've just reworked the conntrack event cache to work without requiring
skb->nfcache.  I'll try to merge all the code and produce some working
version which I'll put in svn.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC3Mx5XaXGVTD0i/8RArujAKCbs1Ng34VDKm1t5H60e9RUKWEnqgCfUZlK
NmBeW1Tl2dBkq6qM1/Fkk08=
=p02v
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
