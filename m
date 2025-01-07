Received: from smtp-out.freemail.hu (fmfe34.freemail.hu [46.107.16.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FB01F471C;
	Tue,  7 Jan 2025 18:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736275737; cv=none; b=qyiuNZg58rR6g3qX/LBCi4FsG/m3ZU6i6EgpeaLHWJam62xYMKigp2ih6p/A+Q61GeaKueWHlMAFrVUi07xMyHJRxSxF65S3ddUaUzL3Fg1818Sjc745fqpxxtGJXXHf+t5nXWQ3SWR0MB8DZoCDkuE59mKU/YesUGaEXC73/VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736275737; c=relaxed/simple;
	bh=sJtP5k+9B7FVuJ4FQ+xEmKEnmP48sajydm44qewhoYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m20XEII2V4JxvSMpwv8mQWC2q9MpHERqRwauekJXb/mESowBIimyNA1pbfdf6NGRrT+H1JsVXsm2n/1LJCZ7CImUnomhkpPxa/zIEaewFpvXJQOib9EU4qX4YkVhHsqctsa9JBFWwkEoCTsa2Y6TTHp/5MtezBakKguzXbX18Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=HX8Vq4zt reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="HX8Vq4zt"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YSKnw3Xzvz10mN;
	Tue, 07 Jan 2025 19:48:52 +0100 (CET)
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
Subject: [PATCH 6/6] netfilter: x_tables: Adjust code style of xt_*.c files.
Date: Tue,  7 Jan 2025 19:47:24 +0100
Message-ID: <20250107184724.56223-7-egyszeregy@freemail.hu>
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
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736275732;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=3557; bh=Yd4xrnhdsyrfeeJt8qwnkIqtaiGci73CHdk/SD5WDPE=;
	b=HX8Vq4ztcZAeB3FdBALnbViGgZ3pueHSAHX9Y7MXHydWapFsSlfDCilMk319+CJv
	5niSxNOu4a9ZJkQ2Tc/80otILu8+BG+ncP0n/iNGHBoXzOFBkU1uc2wztqLVB1C7XiS
	T+c4K0LKbuJZFtwbyQzOWSYa2r3H8NuNDzsgPh1Z+XsqY+BPU85oyNBRgD8fXqdfV1J
	xZZYTXO/sn54/I3Vc+acktPddPQPg9MNA2KrKJixf8ORtU74RA8ve7i/yencgjayjI1
	GzfYWK43qa7S4AXIyECig676s8qptW5hdTJh2ZMRmvDUQP89/V7T6lgDyMVBFoEsNSJ
	BmJ86BtqaQ==

From: Benjamin Szőke <egyszeregy@freemail.hu>

- Change to use u8, u16 and u32 types.
- Fix format of #define macros

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 net/netfilter/xt_dscp.c    |  6 +++---
 net/netfilter/xt_rateest.c |  4 ++--
 net/netfilter/xt_tcpmss.c  | 10 ++++------
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index bdd67b0458ab..2d09a66c131e 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -29,13 +29,13 @@ MODULE_ALIAS("ipt_TOS");
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
@@ -44,7 +44,7 @@ static bool
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
index 9cf627e96226..b0312a085d9e 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -40,7 +40,7 @@ tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct tcphdr *th;
 	struct tcphdr _tcph;
 	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
-	const u_int8_t *op;
+	const u8 *op;
 	u8 _opt[15 * 4 - sizeof(_tcph)];
 	unsigned int i, optlen;
 
@@ -115,9 +115,7 @@ optlen(const u8 *opt, unsigned int offset)
 		return opt[offset + 1];
 }
 
-static u_int32_t tcpmss_reverse_mtu(struct net *net,
-				    const struct sk_buff *skb,
-				    unsigned int family)
+static u32 tcpmss_reverse_mtu(struct net *net, const struct sk_buff *skb, unsigned int family)
 {
 	struct flowi fl;
 	struct rtable *rt = NULL;
@@ -190,7 +188,7 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 		newmss = info->mss;
 	}
 
-	opt = (u_int8_t *)tcph;
+	opt = (u8 *)tcph;
 	for (i = sizeof(struct tcphdr); i <= tcp_hdrlen - TCPOLEN_MSS; i += optlen(opt, i)) {
 		if (opt[i] == TCPOPT_MSS && opt[i + 1] == TCPOLEN_MSS) {
 			u16 oldmss;
@@ -250,7 +248,7 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	else
 		newmss = min(newmss, (u16)1220);
 
-	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
+	opt = (u8 *)tcph + sizeof(struct tcphdr);
 	memmove(opt + TCPOLEN_MSS, opt, len - sizeof(struct tcphdr));
 
 	inet_proto_csum_replace2(&tcph->check, skb,
-- 
2.43.5

