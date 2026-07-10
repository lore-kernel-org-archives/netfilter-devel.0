Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6762D2F362B
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jul 2026 07:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783670057; cv=none; b=Hv2gFxpW0zAduvRqL93xbURwYSM6yGwVHwcOrPd8o7o2RvdiQHLJwnw9f7pCA8LNXZE1yFCeD5Vn0AZGlXDHQ+VMMBZojb2Wzd6w5gn/qebBTrdm9Gsz38n1ncs3oF0agntBOaGbwLgibziXA9u3xZaz+CuMNWHJXHOBVSWO5BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783670057; c=relaxed/simple;
	bh=GNNxGv3mAnO4ZOpKayseRheWzsnEbK5XRTYD77xd7r8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P1SjihYh3D/2HY8vVDxGWgvbmwezuh5/eDsYtXVHErMhDvl6xpr6SVNGLeCUAgFaiqZ7UuFx/OmG9uj44KljB+UWgknh2HzRG7tR3bftYjVyIZZ0nEq6up2a9ouUgtg85uvqdvd1b3E2OIYW8gZEYfUUImzNuw3YVVdNUesdr7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XzLImhaA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XzLImhaA"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 263E46057F;
	Fri, 10 Jul 2026 09:54:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783670053;
	bh=lzZBUWFcLpOLTDR/bzU/zzZneWiV51oOZ7Fqy5H87nk=;
	h=From:To:Cc:Subject:Date:From;
	b=XzLImhaAXShkLSJvqVD1jJgjnezQIzGDsl76tu2A//8f01FLN9Q1Sobxg+0GFa2+8
	 L+KksmnLX8w/UmqfmRM+e4N7JhR7cFxEkKdEeV4saarEu5SVWUL9r/XrwmqpS5ayaS
	 /++P9Ckr/hQjvvU0x4T18XWQkljY7JhXU3jbZpkZg749lny+NNgK1dB8tV+sSGFZvG
	 gJ+OHtqQKblu7LkiqI9YZ0wOLb96SvH11i+oOkV13EFgVHAxXSsbmFgz83uf6cCsgy
	 pjr7a99SIVW3l+U61Kwq96h0eXebyQmq1duw5OVpMO3HgxemerUsLGO+m1izxOA3oe
	 R+WiwM6Ouxmew==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: anzaki@gmail.com
Subject: [PATCH nf,v2] netfilter: flowtable: tear down flow entries with stale dst from GC
Date: Fri, 10 Jul 2026 09:54:09 +0200
Message-ID: <20260710075409.1360085-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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
v2: - reuse nf_flow_dst_check(), move it to .h file
    - use correct logic in nf_flow_dst_check() from GC step

This patch has been repurposed to the nf.git tree, because net-next.git is
still missing a recent fix and I would like sashiko kicks it for review.
So I am still leaning towards including this in nf-next.

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
index 2a829b5e8240..fe655e5e3b06 100644
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
index 44f4d74f2982..55f6a0dedb03 100644
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

