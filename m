Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACBE40802E;
	Wed,  8 Jul 2026 14:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783519449; cv=none; b=auww1F8VicITf67xa/CDjTSfGVOxk97pIJhbf2E82j6dyzLh0nXFgkdHHd78tViu/B1WhbkxOaytdFcMNn4pN04UqDQbLL9+hH7hlCj6+YjVvgC498cwrdxu8YrsRaJEUrD2oy2X0aFGj95KAceOTmQQeKqrElr5SlbHODY2Nf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783519449; c=relaxed/simple;
	bh=U95iGkz+gp3lGjf/pPeXBqJ+KlX7IcNeq6AXPcuItao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOvrM5XGHi3aWjm9aU/6V24OXSc4SJDMh55ejKNbXj4Z/JopfCansxcHP7XbIgMoWeleFvPM7QcPMFPa0gQXuGfytW2UmHfQqtl+3BJSTNB5FHHFuRKu9OwyM7bZhhK3S1KINQ5RlkxFUNHJy7Ixk7/BllrMCA4YVCXof2654KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2421560CD2; Wed, 08 Jul 2026 16:04:06 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 11/17] netfilter: flowtable: IPIP tunnel hardware offload is not yet support
Date: Wed,  8 Jul 2026 16:03:03 +0200
Message-ID: <20260708140309.19633-12-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708140309.19633-1-fw@strlen.de>
References: <20260708140309.19633-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

No driver supports for IPIP tunnels yet, give up early on setting up the
hardware offload for this scenario.

This patch adds a stub that can be enhanced to add more configuration
that are currently not supported. As of now, the offload work is
enqueued to the worker, then ignored if the hardware offload
configuration is not supported.

Check the NF_FLOW_HW flag to know if this entry was already tried once
to be offloaded so this is not retried on refresh when unsupported. Move
NF_FLOW_HW flag check to nf_flow_offload_add(). If this NF_FLOW_HW flag
is unset the _del and _stats variants are never called.

This can be updated later on to skip hardware offload work to be queued
in case hardware offload does not support it.

Fixes: d98103575dcd ("netfilter: flowtable: Add IP6IP6 rx sw acceleration")
Fixes: ab427db17885 ("netfilter: flowtable: Add IPIP rx sw acceleration")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Reported-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_flow_table.h |  2 ++
 net/netfilter/nf_flow_table_core.c    |  7 +++----
 net/netfilter/nf_flow_table_offload.c | 22 ++++++++++++++++++++--
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 7b23b245a5a8..dc5c9b48e65a 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -357,6 +357,8 @@ static inline int nf_flow_register_bpf(void)
 
 void nf_flow_offload_add(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow);
+void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
+			     struct flow_offload *flow);
 void nf_flow_offload_del(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow);
 void nf_flow_offload_stats(struct nf_flowtable *flowtable,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 99c5b9d671a0..d06ce0848b68 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -345,10 +345,8 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 
 	nf_ct_refresh(flow->ct, NF_CT_DAY);
 
-	if (nf_flowtable_hw_offload(flow_table)) {
-		__set_bit(NF_FLOW_HW, &flow->flags);
+	if (nf_flowtable_hw_offload(flow_table))
 		nf_flow_offload_add(flow_table, flow);
-	}
 
 	return 0;
 }
@@ -369,7 +367,8 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 	    test_bit(NF_FLOW_CLOSING, &flow->flags))
 		return;
 
-	nf_flow_offload_add(flow_table, flow);
+	if (test_bit(NF_FLOW_HW, &flow->flags))
+		nf_flow_offload_refresh(flow_table, flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_refresh);
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 002ec15d988b..801a3dd9ceea 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1101,9 +1101,17 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 	return offload;
 }
 
+static bool nf_flow_offload_unsupported(struct flow_offload *flow)
+{
+	if (flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.tun_num ||
+	    flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.tun_num)
+		return true;
 
-void nf_flow_offload_add(struct nf_flowtable *flowtable,
-			 struct flow_offload *flow)
+	return false;
+}
+
+void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
+			     struct flow_offload *flow)
 {
 	struct flow_offload_work *offload;
 
@@ -1114,6 +1122,16 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
 	flow_offload_queue_work(offload);
 }
 
+void nf_flow_offload_add(struct nf_flowtable *flowtable,
+			 struct flow_offload *flow)
+{
+	if (nf_flow_offload_unsupported(flow))
+		return;
+
+	set_bit(NF_FLOW_HW, &flow->flags);
+	nf_flow_offload_refresh(flowtable, flow);
+}
+
 void nf_flow_offload_del(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow)
 {
-- 
2.54.0

