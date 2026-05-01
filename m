Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADF13A1E67;
	Fri,  1 May 2026 12:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777638183; cv=none; b=q8kCc3B/mBckfi6koXcBmBtnla7OFYbR6tPqVCoYRVVpnF2oVFayRCtfnqZPSCqoaJLv8glcDUsIHzXriUXPj8joII3CsgURHaOP7krY/ySiBYzXuzIGNGoim9LO69EbiCM/NCbCyapjt9D4KapPgB4TbdU5d9HLt2iwvGOOzp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777638183; c=relaxed/simple;
	bh=oqqTWfGnPyLAtneYKuVaq1SsjDyTKX3QVfdWOIBC5qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AifHXP0clDzbZ33c0gGUV+J5miohkcjAlibZe+7BnyaThLEh+xRo61pM9P7iB7dFO6UtXXjDMSkNSjNhq3ZcXQVr4Hb69cGZfMsXucJwezbSmTyAQCJnAEz/8/ZTGOYUxwbnjhWh0Tk4MvwCECuUN65zcN2y0V8mKW4ig+RsbfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lXq6RYmy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lXq6RYmy"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E1F1F6017E;
	Fri,  1 May 2026 14:22:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777638174;
	bh=Mp/JXNuUBdeI9ihtX9QNuyNpx7fuho/7XkOS4owfwW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXq6RYmyW9lydJFM/mXDGNkXsxjedmWgkXAz0nJAojDelrFMlFNRn+0yVHhJdH35h
	 qZp5BUGj3Vp9s1zsXP+3wCsc71YjCEhqSdbg3dYTgVO2PhEQlT8FEb9s+LZRlzQSeA
	 MXEvXYCJpz2yd2i16cfkApApXJ+YDL+kcj1FoCWvNZYxPJlzE70cV/z19eYBhSo6Kp
	 zG/jIcG7wnQQoA5625Fz1ARGo0P7ih+vLzb1VGtv5qIi8ZC/yke94yBz+7rcNB6tc4
	 VaaRb2T9qQUO/9xsZgHKdmeZlfjibImR3nZjet4dsv+phLgVQAU9jnup9WcKVPM56J
	 edQvJSC5XHWWg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 09/14] netfilter: nf_tables: skip L4 header parsing for non-first fragments
Date: Fri,  1 May 2026 14:22:32 +0200
Message-ID: <20260501122237.296262-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260501122237.296262-1-pablo@netfilter.org>
References: <20260501122237.296262-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

The tproxy, osf and exthdr (SCTP) expressions rely on the presence of
transport layer headers to perform socket lookups, fingerprint matching,
or chunk extraction. For fragmented packets, while the IP protocol
remains constant across all fragments, only the first fragment contains
the actual L4 header.

The expressions could be attached to a chain with a priority lower than
-400, bypassing defragmentation. Or could be used in stateless
environments where defragmentation is not happening at all.  This could
result in garbage data being used for the matching.

Add a check for pkt->fragoff so only unfragmented packets or the first
fragment is processed.

Fixes: 133dc203d77d ("netfilter: nft_exthdr: Support SCTP chunks")
Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c | 2 +-
 net/netfilter/nft_exthdr.c     | 2 +-
 net/netfilter/nft_osf.c        | 2 +-
 net/netfilter/nft_tproxy.c     | 8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 5ddd5b6e135f..8ab186f86dd4 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -153,7 +153,7 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	if (priv->base == NFT_PAYLOAD_NETWORK_HEADER)
 		ptr = skb_network_header(skb) + pkt->nhoff;
 	else {
-		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
 			return false;
 		ptr = skb->data + nft_thoff(pkt);
 	}
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 0407d6f708ae..e6a07c0df207 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -376,7 +376,7 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
 	const struct sctp_chunkhdr *sch;
 	struct sctp_chunkhdr _sch;
 
-	if (pkt->tprot != IPPROTO_SCTP)
+	if (pkt->tprot != IPPROTO_SCTP || pkt->fragoff)
 		goto err;
 
 	do {
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index c02d5cb52143..45fe56da5044 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -33,7 +33,7 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		return;
 	}
 
-	if (pkt->tprot != IPPROTO_TCP) {
+	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index f2101af8c867..89be443734f6 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -30,8 +30,8 @@ static void nft_tproxy_eval_v4(const struct nft_expr *expr,
 	__be16 tport = 0;
 	struct sock *sk;
 
-	if (pkt->tprot != IPPROTO_TCP &&
-	    pkt->tprot != IPPROTO_UDP) {
+	if ((pkt->tprot != IPPROTO_TCP &&
+	     pkt->tprot != IPPROTO_UDP) || pkt->fragoff) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
@@ -97,8 +97,8 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 
 	memset(&taddr, 0, sizeof(taddr));
 
-	if (pkt->tprot != IPPROTO_TCP &&
-	    pkt->tprot != IPPROTO_UDP) {
+	if ((pkt->tprot != IPPROTO_TCP &&
+	     pkt->tprot != IPPROTO_UDP) || pkt->fragoff) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-- 
2.47.3

