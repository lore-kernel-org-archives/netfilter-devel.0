Received: from smtp-out.freemail.hu (fmfe28.freemail.hu [46.107.16.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D1F136358;
	Sun,  5 Jan 2025 23:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736119205; cv=none; b=ZlVpLXhKzXZJMJ6ggxl8mmXGatJbUtyyUbz69aPBsoOVNca4455IlLmcGdjFcOgIW++i/AOjC7I3dLVAmdO05N8fQOXyZpGq/9dL2sQvrHe8wt962DiEDi49kjdINWrWrR+WeGhjgV9sBaqgj27EeJEjxqkkAz9Uia73vC9MLy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736119205; c=relaxed/simple;
	bh=Bv5DGVPyc7bS+AFeQ8WpRRx4SqNq5DzctRcDg6kl3wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U8hO8Nt/Lcyo62F7hbMnIPZGFqB7BaoOV0aqz9RCDuhow9YT9FjkA6AKsNg8kYxHyZQsF1BF4jwLKoI1WUuH5HuNgMn+UoOXaRiRyPixSkmTnwTF+B0BoVrKcy5KxZ8zF5552quRhIihF7ypvtSdxc7fCtY9xh5MJf8NVA209Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=ml3ibc9R reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="ml3ibc9R"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRCvj0y67z16Hk;
	Mon, 06 Jan 2025 00:20:01 +0100 (CET)
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
Subject: [PATCH v6 3/3] netfilter: x_tables: Adjust code style for xt_*.h/c and ipt_*.h files.
Date: Mon,  6 Jan 2025 00:19:00 +0100
Message-ID: <20250105231900.6222-4-egyszeregy@freemail.hu>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250105231900.6222-1-egyszeregy@freemail.hu>
References: <20250105231900.6222-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736119201;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=7313; bh=jufs+jCAKEAQ/rzKcJB68J90zxsblXoMPGmMVnCX9cs=;
	b=ml3ibc9Rbzz92S/NqIcsG/Guxk0W+ArLbHCUoeQR5Vi8w7l9RAR1twTr48a/kr73
	V4mXhZB5j037kSD6rx9UpaNw+O7LEXpLID9/FBVTNyEutsr2Cliay4TSm5ZLLQZ4Joc
	lNDpEopwAk4RGQIZNYnvpDvC3Wuy8y4XgeyUO5Mw4tjvQsB+ydDYe5aCw73aI1OnKjb
	VWYZkzI0A66aGHNJuKxY1ViE/WxCmRJ6MV9u/K/7hb4moBFAo+7e7rT6Sy6Snw3VAgA
	yM2Wmm/NYDmKYnTgTmr8NlAPmJULtB1EveIcsRdZxFM3Sbdxe6s8QHoOjLr73A6ndch
	izEwHBcAzQ==

From: Benjamin Szőke <egyszeregy@freemail.hu>

- Change to use u8, u16 and u32 types.
- Adjust tab indents
- Fix #define macros format

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 include/uapi/linux/netfilter/xt_dscp.h      |  6 +++---
 include/uapi/linux/netfilter/xt_rateest.h   |  4 ++--
 include/uapi/linux/netfilter/xt_tcpmss.h    |  6 +++---
 include/uapi/linux/netfilter_ipv4/ipt_ecn.h |  8 ++++----
 include/uapi/linux/netfilter_ipv4/ipt_ttl.h |  3 +--
 include/uapi/linux/netfilter_ipv6/ip6t_hl.h |  3 +--
 net/netfilter/xt_dscp.c                     |  6 +++---
 net/netfilter/xt_rateest.c                  |  4 ++--
 net/netfilter/xt_tcpmss.c                   | 10 ++++------
 9 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_dscp.h b/include/uapi/linux/netfilter/xt_dscp.h
index 01e8611cd26e..70d724612485 100644
--- a/include/uapi/linux/netfilter/xt_dscp.h
+++ b/include/uapi/linux/netfilter/xt_dscp.h
@@ -15,9 +15,9 @@
 
 #include <linux/types.h>
 
-#define XT_DSCP_MASK	0xfc	/* 11111100 */
-#define XT_DSCP_SHIFT	2
-#define XT_DSCP_MAX	0x3f	/* 00111111 */
+#define XT_DSCP_MASK	(0xfc)	/* 11111100 */
+#define XT_DSCP_SHIFT	(2)
+#define XT_DSCP_MAX		(0x3f)	/* 00111111 */
 
 /* match info */
 struct xt_dscp_info {
diff --git a/include/uapi/linux/netfilter/xt_rateest.h b/include/uapi/linux/netfilter/xt_rateest.h
index da9727fa527b..f719bd501d1a 100644
--- a/include/uapi/linux/netfilter/xt_rateest.h
+++ b/include/uapi/linux/netfilter/xt_rateest.h
@@ -22,8 +22,8 @@ enum xt_rateest_match_mode {
 };
 
 struct xt_rateest_match_info {
-	char			name1[IFNAMSIZ];
-	char			name2[IFNAMSIZ];
+	char		name1[IFNAMSIZ];
+	char		name2[IFNAMSIZ];
 	__u16		flags;
 	__u16		mode;
 	__u32		bps1;
diff --git a/include/uapi/linux/netfilter/xt_tcpmss.h b/include/uapi/linux/netfilter/xt_tcpmss.h
index 3ee4acaa6e03..ad858ae93e6a 100644
--- a/include/uapi/linux/netfilter/xt_tcpmss.h
+++ b/include/uapi/linux/netfilter/xt_tcpmss.h
@@ -4,11 +4,11 @@
 
 #include <linux/types.h>
 
-#define XT_TCPMSS_CLAMP_PMTU	0xffff
+#define XT_TCPMSS_CLAMP_PMTU	(0xffff)
 
 struct xt_tcpmss_match_info {
-    __u16 mss_min, mss_max;
-    __u8 invert;
+	__u16 mss_min, mss_max;
+	__u8 invert;
 };
 
 struct xt_tcpmss_info {
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
index a6d479aece21..0594dd49d13f 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
@@ -16,10 +16,10 @@
 
 #define ipt_ecn_info xt_ecn_info
 
-#define IPT_ECN_OP_SET_IP	0x01	/* set ECN bits of IPv4 header */
-#define IPT_ECN_OP_SET_ECE	0x10	/* set ECE bit of TCP header */
-#define IPT_ECN_OP_SET_CWR	0x20	/* set CWR bit of TCP header */
-#define IPT_ECN_OP_MASK		0xce
+#define IPT_ECN_OP_SET_IP	(0x01)	/* set ECN bits of IPv4 header */
+#define IPT_ECN_OP_SET_ECE	(0x10)	/* set ECE bit of TCP header */
+#define IPT_ECN_OP_SET_CWR	(0x20)	/* set CWR bit of TCP header */
+#define IPT_ECN_OP_MASK		(0xce)
 
 enum {
 	IPT_ECN_IP_MASK       = XT_ECN_IP_MASK,
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ttl.h b/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
index e7b8d6c58264..fda5296f3e10 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
@@ -11,13 +11,12 @@
 #include <linux/types.h>
 
 enum {
-	IPT_TTL_EQ = 0,		/* equals */
+	IPT_TTL_EQ = 0,	/* equals */
 	IPT_TTL_NE,		/* not equals */
 	IPT_TTL_LT,		/* less than */
 	IPT_TTL_GT,		/* greater than */
 };
 
-
 struct ipt_ttl_info {
 	__u8	mode;
 	__u8	ttl;
diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_hl.h b/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
index cace0c7b649f..a5db7c630674 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
@@ -11,13 +11,12 @@
 #include <linux/types.h>
 
 enum {
-	IP6T_HL_EQ = 0,		/* equals */
+	IP6T_HL_EQ = 0,	/* equals */
 	IP6T_HL_NE,		/* not equals */
 	IP6T_HL_LT,		/* less than */
 	IP6T_HL_GT,		/* greater than */
 };
 
-
 struct ip6t_hl_info {
 	__u8	mode;
 	__u8	hop_limit;
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index 232ecc82ec28..2f0e51a836e7 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -30,13 +30,13 @@ MODULE_ALIAS("ipt_TOS");
 MODULE_ALIAS("ip6t_TOS");
 MODULE_ALIAS("xt_DSCP");
 
-#define XT_DSCP_ECN_MASK	3u
+#define XT_DSCP_ECN_MASK	(3u)
 
 static bool
 dscp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_dscp_info *info = par->matchinfo;
-	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
+	u8 dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	return (dscp == info->dscp) ^ !!info->invert;
 }
@@ -45,7 +45,7 @@ static bool
 dscp_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_dscp_info *info = par->matchinfo;
-	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
+	u8 dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	return (dscp == info->dscp) ^ !!info->invert;
 }
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index c0153b5b47a0..b31458079c3e 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -17,7 +17,7 @@
 #include <linux/netfilter/xt_rateest.h>
 #include <net/netfilter/xt_rateest.h>
 
-#define RATEEST_HSIZE	16
+#define RATEEST_HSIZE	(16)
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_LICENSE("GPL");
@@ -33,7 +33,7 @@ xt_rateest_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_rateest_match_info *info = par->matchinfo;
 	struct gnet_stats_rate_est64 sample = {0};
-	u_int32_t bps1, bps2, pps1, pps2;
+	u32 bps1, bps2, pps1, pps2;
 	bool ret = true;
 
 	gen_estimator_read(&info->est1->rate_est, &sample);
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index b33c13b7bc01..3bf8e6387af9 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -41,7 +41,7 @@ tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct tcphdr *th;
 	struct tcphdr _tcph;
 	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
-	const u_int8_t *op;
+	const u8 *op;
 	u8 _opt[15 * 4 - sizeof(_tcph)];
 	unsigned int i, optlen;
 
@@ -116,9 +116,7 @@ optlen(const u8 *opt, unsigned int offset)
 		return opt[offset + 1];
 }
 
-static u_int32_t tcpmss_reverse_mtu(struct net *net,
-				    const struct sk_buff *skb,
-				    unsigned int family)
+static u32 tcpmss_reverse_mtu(struct net *net, const struct sk_buff *skb, unsigned int family)
 {
 	struct flowi fl;
 	struct rtable *rt = NULL;
@@ -191,7 +189,7 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 		newmss = info->mss;
 	}
 
-	opt = (u_int8_t *)tcph;
+	opt = (u8 *)tcph;
 	for (i = sizeof(struct tcphdr); i <= tcp_hdrlen - TCPOLEN_MSS; i += optlen(opt, i)) {
 		if (opt[i] == TCPOPT_MSS && opt[i + 1] == TCPOLEN_MSS) {
 			u16 oldmss;
@@ -251,7 +249,7 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	else
 		newmss = min(newmss, (u16)1220);
 
-	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
+	opt = (u8 *)tcph + sizeof(struct tcphdr);
 	memmove(opt + TCPOLEN_MSS, opt, len - sizeof(struct tcphdr));
 
 	inet_proto_csum_replace2(&tcph->check, skb,
-- 
2.43.5

