Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951332D9EE4;
	Sun, 13 Sep 2026 20:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789332905; cv=none; b=FwOs4+x41oth/19RdQ0oNyYa29EgU28Y7BAV60eE/NuijuYtzccqaIkZiZrn99EXCkzwOWGlftAn52IpeaN6QRGMMCr5ybz2UwWroEeKTgennAtI99FAgAnhUhBvV+eZzBarO25Qjs8TreGoJhb0kfL9lhC7gTIXrbJwekhnTpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789332905; c=relaxed/simple;
	bh=/iddznms36HXZFJtrYFUiurnQN5RhT5DXJT9ufNZjvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ci5Beo9dAxGZajwWDZO83w4AMcCS3MV3/+iPysIuLXeZEcs21TJLQEh8SAxfo/9NoQKEXBaQ1vwtakmw3Bze8Awxrh/I/fhC7xSpXPODL2VYhVZ8znNUY7q76aCTUgqTM+moRPbMCyukNaeSMLUxDyURqVexmY6DfAtO+7EwBo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ty6LNAct; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ty6LNAct"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789332901;
	bh=VX6sBGK9R16yzx8cRdhS460qkBIHmEnXCCfYC4NPIqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ty6LNActpCUCVgJIu5UmdaMFaWKN/AteHLNIknZaOur8ebUT8HD4bVI7/KmqvYvfj
	 6ItXgkFs0jqTu1zoxm4J7icgw0m0IU9xmouioXenkruYBH9LSQejHydCQORvf7dfO1
	 fDFG02uixC2hKe6Q5S6/45NZTNYcyY2dXP1zwMBkLlE01kmAUvfv2nX9nIxogHuHJ/
	 iJVpGH4xhWXRzLP5w+FERBnVCHuZa5gmRcNBuHnyMFGeKWb4+81Dg/OEfeE8S93Ysy
	 S+GT1EgwfSYU184lwf3z01rE2vI8gYlyLDigbX/gOJD7B+xbhNSMQJKAbKUh8tTKNE
	 gmvx82xOTMgQA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 04F496005C;
	Sun, 13 Sep 2026 22:55:00 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 4/4] netfilter: flowtable: hold reference on ct until flow is released
Date: Sun, 13 Sep 2026 22:54:47 +0200
Message-ID: <20260913205447.1889203-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913205447.1889203-1-pablo@netfilter.org>
References: <20260913205447.1889203-1-pablo@netfilter.org>
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

