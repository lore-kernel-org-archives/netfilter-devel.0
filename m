Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D131A4457CC;
	Fri, 31 Jul 2026 15:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512068; cv=none; b=b3G1hJPepJYwgUvQ+VqHojVR80I9pp/vunrGZ1+PzR+PlPdF2Syez/ERJpU/AVfc2Y28/f+cci7pBu9akit8YMx1aIjzBXd9YwzNU4N+qZr/i04TLer/UXDWF09lIW1W+FMBpgZu6eg4vJ3MGu0iuFwLsVrSD/HlApV39DNY3W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512068; c=relaxed/simple;
	bh=6UAkyeqLG/pUvQeYF5nENqd9rWPQ9EdB5n+OBYbqYV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2L8X466KYbIjfG6V5x/i3N/aLjIFbAzSzHB0DBOoYpEEv6/sGAIBzpwpt7juOEj70mhBPJDBtLRjMmDkFqGwU/BL3dzSFgsYHFEdUBTxqq/aCXPWwSVukNVkRxRkl/df1wnUlgEi3cB9wi9s6DgT5pQCAyG76tM120A2483J9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ys1tSDVQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ys1tSDVQ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 956BB602B2;
	Fri, 31 Jul 2026 17:34:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785512063;
	bh=u2gYTemH8+8jknshS8ldSGm8lRlbRYzKNuqnNRDryQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ys1tSDVQkMlfzPeqcROavkoOb/C+safG6a+bX0CY6HnjDJUrIStQj+tLFeqYfQOiJ
	 FfaDygrmdZ8dADxWuDA+dLunmQLMcZSf14bFmZf0VXazv26Js4EcK6QZEH0+mT0oue
	 j41wtpgdnqQyQvFx4rVKyV+5/4BFOrfHswDFeW83EBeLrurSGONC06a7mPneH6UZ0P
	 8FuK+GEe+Qo3nzN+kDFDibm/d2SHZffGQKUEY49ItbFf3Md3Zbpoy0i6OBlnlSqIv8
	 ITFN9LqtHFJTaHbGDj5ifJPfHBrJYdBCr6mhNtJCCtH0H5BbBBNdPxdKnIdBwMyfRh
	 0evOwI+TifTwQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 8/9] netfilter: nf_tables: call skb_valid_dst() before skb_dst()
Date: Fri, 31 Jul 2026 17:34:01 +0200
Message-ID: <20260731153402.851224-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260731153402.851224-1-pablo@netfilter.org>
References: <20260731153402.851224-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When fetching the dst_entry from the skb, check if it valid, ie. this is
not a template dst, for extensions that can be used from the netdev
ingress and egress chains.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 6 ++++--
 net/ipv6/netfilter/nf_reject_ipv6.c | 8 ++++++--
 net/netfilter/nft_meta.c            | 6 ++++--
 net/netfilter/nft_rt.c              | 6 ++++--
 net/netfilter/nft_xfrm.c            | 9 ++++++++-
 5 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 4626dc46808f..59ec465a9df9 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -8,6 +8,7 @@
 #include <net/tcp.h>
 #include <net/route.h>
 #include <net/dst.h>
+#include <net/dst_metadata.h>
 #include <net/netfilter/ipv4/nf_reject.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_bridge.h>
@@ -263,6 +264,7 @@ static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
 	if (!dst)
 		return -1;
 
+	skb_dst_drop(skb_in);
 	skb_dst_set(skb_in, dst);
 	return 0;
 }
@@ -279,7 +281,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	if (!oth)
 		return;
 
-	if (!skb_dst(oldskb) && nf_reject_fill_skb_dst(oldskb) < 0)
+	if (!skb_valid_dst(oldskb) && nf_reject_fill_skb_dst(oldskb) < 0)
 		return;
 
 	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
@@ -352,7 +354,7 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (iph->frag_off & htons(IP_OFFSET))
 		return;
 
-	if (!skb_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
+	if (!skb_valid_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
 		return;
 
 	if (skb_csum_unnecessary(skb_in) ||
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index ef5b7e85cffa..07cdaa10da0d 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -8,6 +8,7 @@
 #include <net/ip6_route.h>
 #include <net/ip6_fib.h>
 #include <net/ip6_checksum.h>
+#include <net/dst_metadata.h>
 #include <net/netfilter/ipv6/nf_reject.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_bridge.h>
@@ -304,6 +305,7 @@ static int nf_reject6_fill_skb_dst(struct sk_buff *skb_in)
 	if (!dst)
 		return -1;
 
+	skb_dst_drop(skb_in);
 	skb_dst_set(skb_in, dst);
 	return 0;
 }
@@ -336,10 +338,12 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	fl6.fl6_sport = otcph->dest;
 	fl6.fl6_dport = otcph->source;
 
-	if (!skb_dst(oldskb)) {
+	if (!skb_valid_dst(oldskb)) {
 		nf_ip6_route(net, &dst, flowi6_to_flowi(&fl6), false);
 		if (!dst)
 			return;
+
+		skb_dst_drop(oldskb);
 		skb_dst_set(oldskb, dst);
 	}
 
@@ -440,7 +444,7 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
-	if (!skb_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
+	if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
 		return;
 
 	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 0a43e0787a68..01cfbaa36525 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -20,6 +20,7 @@
 #include <net/dst.h>
 #include <net/ip.h>
 #include <net/sock.h>
+#include <net/dst_metadata.h>
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
@@ -279,11 +280,12 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
 static noinline bool
 nft_meta_get_eval_rtclassid(const struct sk_buff *skb, u32 *dest)
 {
-	const struct dst_entry *dst = skb_dst(skb);
+	const struct dst_entry *dst;
 
-	if (!dst)
+	if (!skb_valid_dst(skb))
 		return false;
 
+	dst = skb_dst(skb);
 	*dest = dst->tclassid;
 	return true;
 }
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index aeb0094eafd8..841c863a08db 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -8,6 +8,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/dst.h>
+#include <net/dst_metadata.h>
 #include <net/ip6_route.h>
 #include <net/route.h>
 #include <net/netfilter/nf_tables.h>
@@ -59,10 +60,11 @@ void nft_rt_get_eval(const struct nft_expr *expr,
 	u32 *dest = &regs->data[priv->dreg];
 	const struct dst_entry *dst;
 
-	dst = skb_dst(skb);
-	if (!dst)
+	if (!skb_valid_dst(skb))
 		goto err;
 
+	dst = skb_dst(skb);
+
 	switch (priv->key) {
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	case NFT_RT_CLASSID:
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 8cec43064319..c8bba697f993 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -12,6 +12,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/dst_metadata.h>
 #include <linux/in.h>
 #include <net/xfrm.h>
 
@@ -177,9 +178,15 @@ static void nft_xfrm_get_eval_out(const struct nft_xfrm *priv,
 				  struct nft_regs *regs,
 				  const struct nft_pktinfo *pkt)
 {
-	const struct dst_entry *dst = skb_dst(pkt->skb);
+	const struct dst_entry *dst;
 	int i;
 
+	if (!skb_valid_dst(pkt->skb)) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
+	dst = skb_dst(pkt->skb);
 	for (i = 0; dst && dst->xfrm;
 	     dst = ((const struct xfrm_dst *)dst)->child, i++) {
 		if (i < priv->spnum)
-- 
2.47.3

