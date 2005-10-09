From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 5/5] NETFILTER: fix ctnetlink endian problem
Date: Mon, 10 Oct 2005 00:16:48 +0200
Message-ID: <20051009221648.GE6493@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N1GIdlSm9i+YlY4t"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
Content-Disposition: inline
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


--N1GIdlSm9i+YlY4t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,=20

please apply this fix to you 2.6.14 tree.

[NETFILTER] conntrack_netlink: Fix endian issue with status from userspace

When we send "status" from userspace, we forget to convert the endianness.
This patch adds the reqired conversion.  Thanks to Pablo Neira for
discovering this.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit b5564cb94ad4e209fdf12c60485cec467104105c
tree e65164509692d9caa87bf248c10f6d730141bd18
parent 5382af42cb3fed0aa6658b8de20a966f8498ac28
author Harald Welte <laforge@netfilter.org> Sun, 09 Oct 2005 23:30:59 +0200
committer Harald Welte <laforge@netfilter.org> Sun, 09 Oct 2005 23:30:59 +0=
200

 net/ipv4/netfilter/ip_conntrack_netlink.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter=
/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -833,7 +833,8 @@ out:
 static inline int
 ctnetlink_change_status(struct ip_conntrack *ct, struct nfattr *cda[])
 {
-	unsigned long d, status =3D *(u_int32_t *)NFA_DATA(cda[CTA_STATUS-1]);
+	unsigned long d;
+	unsigned status =3D ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_STATUS-1]));
 	d =3D ct->status ^ status;
=20
 	if (d & (IPS_EXPECTED|IPS_CONFIRMED|IPS_DYING))

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--N1GIdlSm9i+YlY4t
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDSZbQXaXGVTD0i/8RAnteAJ4mmHYm8kib1OrOryhZfP9I7zvGDwCdGKuG
iO1yQr28mZofQZcF0lHGsBA=
=dxqg
-----END PGP SIGNATURE-----

--N1GIdlSm9i+YlY4t--
