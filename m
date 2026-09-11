Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F5C46983B
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 09:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789118205; cv=none; b=GG6JD6gloxGe+lLpFD2eSe65XV4+iBfdeR8XwlcFxs+KkTigDST/TtI2jscGspqdHl3X4XNzv8s8fjmb1x3di7pef+uOadBrTNdYD8iSMDosCw0v6wu6HDPrMNFk2ymB49bwTWLBViKH6S7YvqJ6NxQuzUyXemuEMImqQ8tYN+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789118205; c=relaxed/simple;
	bh=/iddznms36HXZFJtrYFUiurnQN5RhT5DXJT9ufNZjvc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=svGGtxGxlmOCNsXGWlYqsMLE7pzudVM0RGM5SMVRTuSd754B8c6//9dsrcxyT31ajAOSvg0BXLW0UbG02jTeYf+Vx7SJ2c5OmddqHEcgB+vie0OI/ueq8KZdLN1Jf/xBDLCtdu7kbivdK3C2NIsEeHyoNx7d9GvqOGlnkreMh2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lEMKoowj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lEMKoowj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789118201;
	bh=VX6sBGK9R16yzx8cRdhS460qkBIHmEnXCCfYC4NPIqE=;
	h=From:To:Subject:Date:From;
	b=lEMKoowj9iBVOpahLY3Wh7C5R4hrjgDYL/pdm8Dv8R+mAwtMbVgc49e/JYbMw3C3L
	 JFLGOx817XXUJYquvXuxA0bRm1GD4iJk5tlYFpo8bIGjTl+sTnqklVJrPcp1gsXh8l
	 hcv2jiAKF/FbFmF7pP5dLmaoCp1xGPgRmcmJw3J9+6R4Qe2ZeoBpU3HVWTYCtUIHch
	 EBWUkygHPEVS2TwZ54fhR/s9wggvpf7rQjWz03fWJ7HRuVcn96vsHRjY1zZhhA3p/8
	 p78GUFe6qsQP+M6CXZkTuImEEKCeSMYAwE5ASdcPnQ/MpFxg+By5MyCLfes7GUmeW1
	 ijXK0GDzZeeFw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CBAAB603D3
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 11:16:41 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2] netfilter: flowtable: hold reference on ct until flow is released
Date: Fri, 11 Sep 2026 11:16:38 +0200
Message-ID: <20260911091638.1840562-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_ct_put() releases the ct->ext area inmediately, the rcu typesafe
semantics also allow to refer to the wrong conntrack from the flowtable
datapath. Hold reference on ct until flow is released after rcu grace
period.

Add rcu_barrier() on module exit path, to ensure pending flow entries
are release before module goes away.

Fixes: 0ff90b6c2034 ("netfilter: nf_flow_offload: fix use-after-free and a resource leak")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 03241d4bfd5e..934c6151f558 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -258,6 +258,14 @@ static void flow_offload_route_release(struct flow_offload *flow)
 	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_REPLY);
 }
 
+static void flow_offload_free_rcu(struct rcu_head *rcu_head)
+{
+	struct flow_offload *flow = container_of(rcu_head, struct flow_offload, rcu_head);
+
+	nf_ct_put(flow->ct);
+	kfree(flow);
+}
+
 void flow_offload_free(struct flow_offload *flow)
 {
 	switch (flow->type) {
@@ -267,8 +275,7 @@ void flow_offload_free(struct flow_offload *flow)
 	default:
 		break;
 	}
-	nf_ct_put(flow->ct);
-	kfree_rcu(flow, rcu_head);
+	call_rcu(&flow->rcu_head, flow_offload_free_rcu);
 }
 EXPORT_SYMBOL_GPL(flow_offload_free);
 
@@ -854,6 +861,7 @@ static int __init nf_flow_table_module_init(void)
 
 static void __exit nf_flow_table_module_exit(void)
 {
+	rcu_barrier();
 	nf_flow_table_offload_exit();
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
 	kmem_cache_destroy(flow_offload_cachep);
-- 
2.47.3

