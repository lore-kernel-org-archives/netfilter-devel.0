Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AEF426427;
	Fri, 24 Jul 2026 10:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890189; cv=none; b=ndRx4maAFxn/R5buyKCunI0jYBSYSRGcNF4pcWuIEYyeoClBKVE8QoKYXmaBcSqt67FosmBn/Gvsgh3LMPUrVvVm77zBu0lrdmoFY5lWa6+IwTnkN9ZAY5k5xOlkvp5605I84oJKk0Zg5N7qJ7FxDdbRJ2I4W0dYOgMyjiNm+kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890189; c=relaxed/simple;
	bh=B3DjGrUCBGm3DtmCSpKwITvfxzUyRoYPYcFAITvF4AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucRWBeVsMr2JLjSZi88uC1Yf3msLwUr5NpBiH06+nKSRKGdEHESMfIYzfPfDkm9BjzJFVoCY1/OOQ860UTBPODANRcrgUXg5c173JtY2nE6xosiFOLMdn+F/QINaHAtyzCDzoFOiY68M803mqXsMVcejOXrsUo+bgxt+j/a4OG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QKGzq8Go; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QKGzq8Go"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3EA2F601A3;
	Fri, 24 Jul 2026 12:49:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784890186;
	bh=LfdLQSwItm3nUOoZzvY6LiZdiJoxkirnAlTpIYBuGbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKGzq8GoubX4w34n4r373ETlctq8FSNMC7q4KmdN+wAbuloJciKfH22vcqyXmGFz7
	 JX/UnTLhW9NP+jZ30sXEUI+5PFaqEDfB3XcG41xdm+Pxyu+IJZ48UnMvH9/Y2W1ZFS
	 KG9QeMgmEgj83iU2QANM0LoAT6UdPJGDnMCByrkvIzjliuaG+PoClfH+KNUXJu04ns
	 r6uBol8yuhLLXqJ6uxhboIVd5m7SlQTup57xnO1gkDAyq4vrotb1OOorp6RU/g54pD
	 E3H3QdPXTWSWLU3NhTYC7roWcI36LvgeRbWbM6viuDf5qjV5wLg/9YDWkdq65IUp48
	 CO8wnDgmaiHWA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 4/7] netfilter: flowtable: tear down flow entries with stale dst from GC
Date: Fri, 24 Jul 2026 12:49:29 +0200
Message-ID: <20260724104932.437729-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724104932.437729-1-pablo@netfilter.org>
References: <20260724104932.437729-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case of route updates, tear down flow entries with stale dst to give
them a chance to obtain a fresh route.

This is specifically useful for hardware offloaded entries, where the
flowtable software dataplane sees no packet, where the existing check
for stale dst entries does not help.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 8 ++++++++
 net/netfilter/nf_flow_table_core.c    | 2 ++
 net/netfilter/nf_flow_table_ip.c      | 8 --------
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index ce414118962f..a090ec3ffef2 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -310,6 +310,14 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 void flow_offload_refresh(struct nf_flowtable *flow_table,
 			  struct flow_offload *flow, bool force);
 
+static inline bool nf_flow_dst_check(struct flow_offload_tuple *tuple)
+{
+	if (!tuple->dst_cache)
+		return true;
+
+	return dst_check(tuple->dst_cache, tuple->dst_cookie);
+}
+
 struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
 						     struct flow_offload_tuple *tuple);
 void nf_flow_table_gc_run(struct nf_flowtable *flow_table);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b66e65439341..58e6a675332d 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -571,6 +571,8 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
+	    !nf_flow_dst_check(&flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple) ||
+	    !nf_flow_dst_check(&flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple) ||
 	    nf_flow_custom_gc(flow_table, flow)) {
 		flow_offload_teardown(flow);
 		teardown = true;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 0b78decce8a9..0b314b10e705 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -297,14 +297,6 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	return true;
 }
 
-static inline bool nf_flow_dst_check(struct flow_offload_tuple *tuple)
-{
-	if (!tuple->dst_cache)
-		return true;
-
-	return dst_check(tuple->dst_cache, tuple->dst_cookie);
-}
-
 static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 				      const struct nf_hook_state *state,
 				      struct dst_entry *dst)
-- 
2.47.3

