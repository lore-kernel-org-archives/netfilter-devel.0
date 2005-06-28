From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2.6] ipt_CLUSTERIP: fix ARP mangling
Date: Tue, 28 Jun 2005 13:43:31 +0200
Message-ID: <20050628114330.GA16681@sunbeam.de.gnumonks.org>
References: <20050622122902.GI4551@obroa-skai.de.gnumonks.org>
	<20050622.124341.95064256.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20050622.124341.95064256.davem@davemloft.net>
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


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2005 at 12:43:41PM -0700, David S. Miller wrote:
> 2) Patch does not apply, because of the patches that went into
>    2.6.x yesterday from Patrick McHardy which removed all the
>    lockhelp stuff.

please aplly the following fix, now merged with current net-2.6:



This patch adds mangling of ARP requests (in addition to replies),
since ARP caches are made from snooping both requests and replies.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 9d80d2e403d13cde5172a3eeb5169cec1e4f32e8
tree 4e45931847acb879f71942628132224f86dd5703
parent c38fe815dfba73749ecd94f855883018dfccc6b6
author Harald Welte <laforge@netfilter.org> Tue, 28 Jun 2005 12:41:45
committer Harald Welte <laforge@netfilter.org> Tue, 28 Jun 2005 12:41:45

 net/ipv4/netfilter/ipt_CLUSTERIP.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CL=
USTERIP.c
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -31,7 +31,7 @@
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/lockhelp.h>
=20
-#define CLUSTERIP_VERSION "0.6"
+#define CLUSTERIP_VERSION "0.7"
=20
 #define DEBUG_CLUSTERIP
=20
@@ -523,8 +523,9 @@ arp_mangle(unsigned int hook,
 	    || arp->ar_pln !=3D 4 || arp->ar_hln !=3D ETH_ALEN)
 		return NF_ACCEPT;
=20
-	/* we only want to mangle arp replies */
-	if (arp->ar_op !=3D htons(ARPOP_REPLY))
+	/* we only want to mangle arp requests and replies */
+	if (arp->ar_op !=3D htons(ARPOP_REPLY)
+	    && arp->ar_op !=3D htons(ARPOP_REQUEST))
 		return NF_ACCEPT;
=20
 	payload =3D (void *)(arp+1);
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCwTfiXaXGVTD0i/8RAnHKAKCJRGWLuLHM6QgP0ZyaCDgqcDMLcgCfaFJu
DcpNoqN3IK5eMrkJt2vu+p8=
=ZBv6
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
