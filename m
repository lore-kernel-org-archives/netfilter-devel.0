Received: from smtp-out.freemail.hu (fmfe34.freemail.hu [46.107.16.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8F41F37C0;
	Tue,  7 Jan 2025 18:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736275669; cv=none; b=bhX3+GFn2N+Tuv9w99MrO6CyfUXsHUTFYe9t2IZEaoZtEItsX2YttBPRQw042/lxrM8it34ob0PfgsjvTCwfB8/aJx26GuliPL19oBmSmM21H9H3JhPlwjZhbgH82kDMsSx9xxFUmrHrOgS5m0yHP8s95JfWQHNrGZABlkpxZL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736275669; c=relaxed/simple;
	bh=QtZykaW6f1yhllS+f4ktOrrhEiAJHcuH4HkLqdZd/g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L/vTw/8jK6pahbSoB3zLZyQkrA01IKv65zw+cRydUDMnJFJKQbVrzjvjngo3TUlNx7JwXnLloPiCpnHbVmzdhRks9IPgS+6wesBEt65umWHoV4LPfuMN0W+iozBSK+yaqOyTuJKFEYOoeLHhx6i8MenBMvoEWtA9tTbb6+020ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=Ue7eZAk9 reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="Ue7eZAk9"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YSKmZ5Tk4zyj4;
	Tue, 07 Jan 2025 19:47:42 +0100 (CET)
From: egyszeregy@freemail.hu
To: fw@strlen.de,
	pablo@netfilter.org,
	lorenzo@kernel.org,
	daniel@iogearbox.net,
	leitao@debian.org,
	amiculas@cisco.com,
	kadlec@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: =?UTF-8?q?Benjamin=20Sz=C5=91ke?= <egyszeregy@freemail.hu>
Subject: [PATCH 1/6] netfilter: x_tables: Format code of xt_*.c files.
Date: Tue,  7 Jan 2025 19:47:19 +0100
Message-ID: <20250107184724.56223-2-egyszeregy@freemail.hu>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250107184724.56223-1-egyszeregy@freemail.hu>
References: <20250107184724.56223-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736275663;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=5682; bh=aZ5a6+8Lu2K6ZE5CeZeSpS6BAvHMB6jITlIYidHZ0gs=;
	b=Ue7eZAk9ULF3DgVcqOPapTIaIGCErkudwLrnSjpg4f4I0K3X3IIt1KOcuLc11Q/n
	LqYyjPvSwa3pXha9u6i6IqPEormVWcQHFuovMGnCeR7449ugf9S8IV1bVn5uGIcg2ZQ
	10lYdXaJ2fVSSiBoD8cIDeS4+b0bxUCNWS6eO8XUQVa43aZgWX/1WtgLimiLfgA36oT
	dAH7iSHpaO4zULfOoaxNa1/SnR51JIlX2UhFOnfRn+aYZFt75kqQ/t66hQ9rjwwv7Pf
	psbMbDj778YVCsQ2+zFA1EQsH1S5yLGyIQgIlTE7pdRGYG1gOs68oOPwslYvPeMlWan
	TwaasAvA3Q==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Adjuste code style to be compatbile with checkpatch.pl checks in
the following files: xt_DSCP.c, xt_HL.c, xt_RATEEST.c, xt_TCPMSS.c

- Change to use u8, u16 and u32 types.
- Fix coding style of math operations and brackets.

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 net/netfilter/xt_DSCP.c    |  9 ++++-----
 net/netfilter/xt_HL.c      |  3 +--
 net/netfilter/xt_RATEEST.c |  1 +
 net/netfilter/xt_TCPMSS.c  | 26 ++++++++++++++------------
 4 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 90f24a6a26c5..a76701fd31ab 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -30,7 +30,7 @@ static unsigned int
 dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_DSCP_info *dinfo = par->targinfo;
-	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
+	u8 dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	if (dscp != dinfo->dscp) {
 		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
@@ -38,7 +38,6 @@ dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
 
 		ipv4_change_dsfield(ip_hdr(skb), XT_DSCP_ECN_MASK,
 				    dinfo->dscp << XT_DSCP_SHIFT);
-
 	}
 	return XT_CONTINUE;
 }
@@ -47,7 +46,7 @@ static unsigned int
 dscp_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_DSCP_info *dinfo = par->targinfo;
-	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
+	u8 dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	if (dscp != dinfo->dscp) {
 		if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
@@ -73,7 +72,7 @@ tos_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tos_target_info *info = par->targinfo;
 	struct iphdr *iph = ip_hdr(skb);
-	u_int8_t orig, nv;
+	u8 orig, nv;
 
 	orig = ipv4_get_dsfield(iph);
 	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
@@ -93,7 +92,7 @@ tos_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tos_target_info *info = par->targinfo;
 	struct ipv6hdr *iph = ipv6_hdr(skb);
-	u_int8_t orig, nv;
+	u8 orig, nv;
 
 	orig = ipv6_get_dsfield(iph);
 	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_HL.c
index a847d7a7eacd..1e1b30b27fef 100644
--- a/net/netfilter/xt_HL.c
+++ b/net/netfilter/xt_HL.c
@@ -54,8 +54,7 @@ ttl_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	}
 
 	if (new_ttl != iph->ttl) {
-		csum_replace2(&iph->check, htons(iph->ttl << 8),
-					   htons(new_ttl << 8));
+		csum_replace2(&iph->check, htons(iph->ttl << 8), htons(new_ttl << 8));
 		iph->ttl = new_ttl;
 	}
 
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index a86bb0e4bb42..d56276b965fa 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -20,6 +20,7 @@
 #define RATEEST_HSIZE	16
 
 struct xt_rateest_net {
+	/* To synchronize concurrent synchronous rate estimator operations. */
 	struct mutex hash_lock;
 	struct hlist_head hash[RATEEST_HSIZE];
 };
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 3dc1320237c2..9944ca1eb950 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -31,13 +31,13 @@ MODULE_ALIAS("ipt_TCPMSS");
 MODULE_ALIAS("ip6t_TCPMSS");
 
 static inline unsigned int
-optlen(const u_int8_t *opt, unsigned int offset)
+optlen(const u8 *opt, unsigned int offset)
 {
 	/* Beware zero-length options: make finite progress */
-	if (opt[offset] <= TCPOPT_NOP || opt[offset+1] == 0)
+	if (opt[offset] <= TCPOPT_NOP || opt[offset + 1] == 0)
 		return 1;
 	else
-		return opt[offset+1];
+		return opt[offset + 1];
 }
 
 static u_int32_t tcpmss_reverse_mtu(struct net *net,
@@ -46,10 +46,11 @@ static u_int32_t tcpmss_reverse_mtu(struct net *net,
 {
 	struct flowi fl;
 	struct rtable *rt = NULL;
-	u_int32_t mtu     = ~0U;
+	u32 mtu     = ~0U;
 
 	if (family == PF_INET) {
 		struct flowi4 *fl4 = &fl.u.ip4;
+
 		memset(fl4, 0, sizeof(*fl4));
 		fl4->daddr = ip_hdr(skb)->saddr;
 	} else {
@@ -60,7 +61,7 @@ static u_int32_t tcpmss_reverse_mtu(struct net *net,
 	}
 
 	nf_route(net, (struct dst_entry **)&rt, &fl, false, family);
-	if (rt != NULL) {
+	if (rt) {
 		mtu = dst_mtu(&rt->dst);
 		dst_release(&rt->dst);
 	}
@@ -110,15 +111,16 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 			return -1;
 		}
 		newmss = min_mtu - minlen;
-	} else
+	} else {
 		newmss = info->mss;
+	}
 
 	opt = (u_int8_t *)tcph;
 	for (i = sizeof(struct tcphdr); i <= tcp_hdrlen - TCPOLEN_MSS; i += optlen(opt, i)) {
-		if (opt[i] == TCPOPT_MSS && opt[i+1] == TCPOLEN_MSS) {
-			u_int16_t oldmss;
+		if (opt[i] == TCPOPT_MSS && opt[i + 1] == TCPOLEN_MSS) {
+			u16 oldmss;
 
-			oldmss = (opt[i+2] << 8) | opt[i+3];
+			oldmss = (opt[i + 2] << 8) | opt[i + 3];
 
 			/* Never increase MSS, even when setting it, as
 			 * doing so results in problems for hosts that rely
@@ -127,8 +129,8 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 			if (oldmss <= newmss)
 				return 0;
 
-			opt[i+2] = (newmss & 0xff00) >> 8;
-			opt[i+3] = newmss & 0x00ff;
+			opt[i + 2] = (newmss & 0xff00) >> 8;
+			opt[i + 3] = newmss & 0x00ff;
 
 			inet_proto_csum_replace2(&tcph->check, skb,
 						 htons(oldmss), htons(newmss),
@@ -186,7 +188,7 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	inet_proto_csum_replace4(&tcph->check, skb, 0, *((__be32 *)opt), false);
 
 	oldval = ((__be16 *)tcph)[6];
-	tcph->doff += TCPOLEN_MSS/4;
+	tcph->doff += TCPOLEN_MSS / 4;
 	inet_proto_csum_replace2(&tcph->check, skb,
 				 oldval, ((__be16 *)tcph)[6], false);
 	return TCPOLEN_MSS;
-- 
2.43.5

