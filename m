From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: xt_connlimit: pick right dstaddr in NAT scenario
Date: Wed, 26 Jan 2011 13:07:10 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101261304310.4561@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jan Rovner <jan.rovner@diadema.cz>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57340 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab1AZMHL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:07:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



The following changes since commit 4b3fd57138c969dd940651fadf90db627254=
edbf:

  IPVS: Change sock_create_kernel() to __sock_create() (2011-01-22 13:4=
8:01 +1100)

are available in the git repository at:
  git://dev.medozas.de/linux connlimit

Jan Engelhardt (1):
      netfilter: xt_connlimit: pick right dstaddr in NAT scenario

 net/netfilter/xt_connlimit.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

=3D=3D=3D

parent 4b3fd57138c969dd940651fadf90db627254edbf (v2.6.38-rc1-151-g4b3fd=
57)
commit ad86e1f27a9a97a9e50810b10bca678407b1d6fd
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Jan 26 11:50:03 2011 +0100

netfilter: xt_connlimit: pick right dstaddr in NAT scenario

xt_connlimit normally records the "original" tuples in a hashlist
(such as "1.2.3.4 -> 5.6.7.8"), and looks in this list for iph->daddr
when counting.

When the user however uses DNAT in PREROUTING, looking for
iph->daddr=C2=A0-- which is now 192.168.9.10 -- will not match. Thus in
daddr mode, we need to record the reverse direction tuple
("192.168.9.10 -> 1.2.3.4") instead. In the reverse tuple, the dst
addr is on the src side, which is convenient, as count_them still uses
&conn->tuple.src.u3.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_connlimit.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.=
c
index 7fd3fd5..e029c48 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -185,11 +185,15 @@ connlimit_mt(const struct sk_buff *skb, struct xt=
_action_param *par)
 	int connections;
=20
 	ct =3D nf_ct_get(skb, &ctinfo);
-	if (ct !=3D NULL)
-		tuple_ptr =3D &ct->tuplehash[0].tuple;
-	else if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
-				    par->family, &tuple))
+	if (ct !=3D NULL) {
+		if (info->flags & XT_CONNLIMIT_DADDR)
+			tuple_ptr =3D &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+		else
+			tuple_ptr =3D &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+	} else if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
+				    par->family, &tuple)) {
 		goto hotdrop;
+	}
=20
 	if (par->family =3D=3D NFPROTO_IPV6) {
 		const struct ipv6hdr *iph =3D ipv6_hdr(skb);
--=20
# Created with git-export-patch

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
