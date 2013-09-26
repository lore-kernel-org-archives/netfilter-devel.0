From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 1/2] =?UTF-8?q?xt=5FTCPMSS=EF=BC=9AGet=20reserve=20mtu=20o?= =?UTF-8?q?nly=20when=20specifing=20option=20clamp-mss-to-pmtu?=
Date: Thu, 26 Sep 2013 15:00:30 +0800
Message-ID: <1380178831-20360-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26068 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab3IZG7Y convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:59:24 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8Q6xLrl027656
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2013 14:59:21 +0800
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't get reserve mtu when user sepcifies the mss through
set-mss.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/netfilter/xt_TCPMSS.c | 70 ++++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index cd24290..62776de 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -43,10 +43,41 @@ optlen(const u_int8_t *opt, unsigned int offset)
 		return opt[offset+1];
 }
 
+static u_int32_t tcpmss_reverse_mtu(const struct sk_buff *skb,
+				    unsigned int family)
+{
+	struct flowi fl;
+	const struct nf_afinfo *ai;
+	struct rtable *rt = NULL;
+	u_int32_t mtu     = ~0U;
+
+	if (family == PF_INET) {
+		struct flowi4 *fl4 = &fl.u.ip4;
+		memset(fl4, 0, sizeof(*fl4));
+		fl4->daddr = ip_hdr(skb)->saddr;
+	} else {
+		struct flowi6 *fl6 = &fl.u.ip6;
+
+		memset(fl6, 0, sizeof(*fl6));
+		fl6->daddr = ipv6_hdr(skb)->saddr;
+	}
+	rcu_read_lock();
+	ai = nf_get_afinfo(family);
+	if (ai != NULL)
+		ai->route(&init_net, (struct dst_entry **)&rt, &fl, false);
+	rcu_read_unlock();
+
+	if (rt != NULL) {
+		mtu = dst_mtu(&rt->dst);
+		dst_release(&rt->dst);
+	}
+	return mtu;
+}
+
 static int
 tcpmss_mangle_packet(struct sk_buff *skb,
 		     const struct xt_action_param *par,
-		     unsigned int in_mtu,
+		     unsigned int family,
 		     unsigned int tcphoff,
 		     unsigned int minlen)
 {
@@ -76,6 +107,8 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 		return -1;
 
 	if (info->mss == XT_TCPMSS_CLAMP_PMTU) {
+		unsigned int in_mtu = tcpmss_reverse_mtu(skb, family);
+
 		if (dst_mtu(skb_dst(skb)) <= minlen) {
 			net_err_ratelimited("unknown or invalid path-MTU (%u)\n",
 					    dst_mtu(skb_dst(skb)));
@@ -165,37 +198,6 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	return TCPOLEN_MSS;
 }
 
-static u_int32_t tcpmss_reverse_mtu(const struct sk_buff *skb,
-				    unsigned int family)
-{
-	struct flowi fl;
-	const struct nf_afinfo *ai;
-	struct rtable *rt = NULL;
-	u_int32_t mtu     = ~0U;
-
-	if (family == PF_INET) {
-		struct flowi4 *fl4 = &fl.u.ip4;
-		memset(fl4, 0, sizeof(*fl4));
-		fl4->daddr = ip_hdr(skb)->saddr;
-	} else {
-		struct flowi6 *fl6 = &fl.u.ip6;
-
-		memset(fl6, 0, sizeof(*fl6));
-		fl6->daddr = ipv6_hdr(skb)->saddr;
-	}
-	rcu_read_lock();
-	ai = nf_get_afinfo(family);
-	if (ai != NULL)
-		ai->route(&init_net, (struct dst_entry **)&rt, &fl, false);
-	rcu_read_unlock();
-
-	if (rt != NULL) {
-		mtu = dst_mtu(&rt->dst);
-		dst_release(&rt->dst);
-	}
-	return mtu;
-}
-
 static unsigned int
 tcpmss_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -204,7 +206,7 @@ tcpmss_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	int ret;
 
 	ret = tcpmss_mangle_packet(skb, par,
-				   tcpmss_reverse_mtu(skb, PF_INET),
+				   PF_INET,
 				   iph->ihl * 4,
 				   sizeof(*iph) + sizeof(struct tcphdr));
 	if (ret < 0)
@@ -233,7 +235,7 @@ tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	if (tcphoff < 0)
 		return NF_DROP;
 	ret = tcpmss_mangle_packet(skb, par,
-				   tcpmss_reverse_mtu(skb, PF_INET6),
+				   PF_INET6,
 				   tcphoff,
 				   sizeof(*ipv6h) + sizeof(struct tcphdr));
 	if (ret < 0)
-- 
1.8.3.1

