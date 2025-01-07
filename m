Received: from smtp-out.freemail.hu (fmfe19.freemail.hu [46.107.16.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801CE13AD22;
	Tue,  7 Jan 2025 02:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736217801; cv=none; b=nwj7gAnEq7AOrZs1ahtH89eJ8FdPPGgzTWZ+zvduGLIhR6AiHM22cqjwZPjl/D9U8ptTkcCG3/xZV66R84YhdsQhMqHqq5gh4USp2JL+an8VIOe6Oto7MlLGpZ6toY9wPERfWhsPF8iIu+BxGkYNAnJFV4qCj/Lr9Kx/suknBfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736217801; c=relaxed/simple;
	bh=7Etbu6S87a+ncslqk3S8CPfpDz8RBLG+Eq2nEskQqfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KNKJ8cfm4T0npDj8728+vrWHGG00Q9lVpupOrPjOy4FfTsAwxQhM2LHsWJ8LBb+hYoCYIA7Eh1GMXlAWCUcbs6z36bFz+n11a6YSsCmlNIZXD/0fOFbSNB5QYhobgieSTvFTY473gaNXVcY7wRK1Aa2GIHRa6XjEFmOBRqccTvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=nZRlTOUI reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="nZRlTOUI"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRwMm1yW3zX5R;
	Tue, 07 Jan 2025 03:43:16 +0100 (CET)
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
Subject: [PATCH 08/10] netfilter: Adjust code style of xt_*.h, ipt_*.h files.
Date: Tue,  7 Jan 2025 03:41:18 +0100
Message-ID: <20250107024120.98288-9-egyszeregy@freemail.hu>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250107024120.98288-1-egyszeregy@freemail.hu>
References: <20250107024120.98288-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736217796;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=3965; bh=h0kpqcWPMTO54IYy9T0CRv0i8rvpud+3ZIGDNgCfsys=;
	b=nZRlTOUIBwSSMOJywAcptknzk5C27mlWdFFgrRP6m2Y8ctzYarhyJu+fFxjqYOWh
	gOyNLhP53oOE2CIL4cC+G7nQF2+NspdH6i/Il2raUlUlMNVRxCD3Sa22dzJnKSH0q3j
	/HTSRssmHz3Shd8jcv/jtbjpCTdFE6g5cHk5Gl3ZSWowLTKxkcAG48der4WI2eoKnnZ
	fr4luObWx8h/76bSjxjpOtnNMmBoJkTSRvBAnOFoabRPu1/W6LuhNbpXHD/W9od/0kr
	Lomd3ylvpRZwPUejF7K6A4cVfKQyeewBevP872z3pEoY2xkYKKj3RdXSeHmdty2ra4s
	06utK9v9Ww==

From: Benjamin Szőke <egyszeregy@freemail.hu>

- Adjust tab indents
- Fix format of #define macros

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 include/uapi/linux/netfilter/xt_dscp.h      | 6 +++---
 include/uapi/linux/netfilter/xt_rateest.h   | 4 ++--
 include/uapi/linux/netfilter/xt_tcpmss.h    | 6 +++---
 include/uapi/linux/netfilter_ipv4/ipt_ecn.h | 8 ++++----
 include/uapi/linux/netfilter_ipv4/ipt_ttl.h | 3 +--
 include/uapi/linux/netfilter_ipv6/ip6t_hl.h | 3 +--
 6 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_dscp.h b/include/uapi/linux/netfilter/xt_dscp.h
index bcfe4afa6351..22b6488ef2e7 100644
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
index c21eb6651353..15c75a4ba355 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
@@ -9,13 +9,12 @@
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
index caef38a63b8f..4af05c86dcd5 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
@@ -9,13 +9,12 @@
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
-- 
2.43.5

