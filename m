From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH net-next] netfilter: only compile nf_nat_ipv4_nlattr_to_range/nf_nat_ipv6_nlattr_to_range
Date: Fri, 27 Jun 2014 13:51:47 +0800
Message-ID: <53AD0673.3000500@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23318 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750729AbaF0FzJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2014 01:55:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


When CONFIG_NF_CT_NETLINK is configed.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c | 4 ++++
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index d8b2e14..14f5ccd 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -154,6 +154,7 @@ static void nf_nat_ipv4_csum_recalc(struct sk_buff *skb,
 					 htons(oldlen), htons(datalen), 1);
 }
 
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 static int nf_nat_ipv4_nlattr_to_range(struct nlattr *tb[],
 				       struct nf_nat_range *range)
 {
@@ -169,6 +170,7 @@ static int nf_nat_ipv4_nlattr_to_range(struct nlattr *tb[],
 
 	return 0;
 }
+#endif
 
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv4 = {
 	.l3proto		= NFPROTO_IPV4,
@@ -177,7 +179,9 @@ static const struct nf_nat_l3proto nf_nat_l3proto_ipv4 = {
 	.manip_pkt		= nf_nat_ipv4_manip_pkt,
 	.csum_update		= nf_nat_ipv4_csum_update,
 	.csum_recalc		= nf_nat_ipv4_csum_recalc,
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_ipv4_nlattr_to_range,
+#endif
 #ifdef CONFIG_XFRM
 	.decode_session		= nf_nat_ipv4_decode_session,
 #endif
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index abfe75a..fc8e49b 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -158,6 +158,7 @@ static void nf_nat_ipv6_csum_recalc(struct sk_buff *skb,
 					 htons(oldlen), htons(datalen), 1);
 }
 
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 static int nf_nat_ipv6_nlattr_to_range(struct nlattr *tb[],
 				       struct nf_nat_range *range)
 {
@@ -175,6 +176,7 @@ static int nf_nat_ipv6_nlattr_to_range(struct nlattr *tb[],
 
 	return 0;
 }
+#endif
 
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv6 = {
 	.l3proto		= NFPROTO_IPV6,
@@ -183,7 +185,9 @@ static const struct nf_nat_l3proto nf_nat_l3proto_ipv6 = {
 	.manip_pkt		= nf_nat_ipv6_manip_pkt,
 	.csum_update		= nf_nat_ipv6_csum_update,
 	.csum_recalc		= nf_nat_ipv6_csum_recalc,
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_to_range	= nf_nat_ipv6_nlattr_to_range,
+#endif
 #ifdef CONFIG_XFRM
 	.decode_session	= nf_nat_ipv6_decode_session,
 #endif
-- 
1.8.3.1
