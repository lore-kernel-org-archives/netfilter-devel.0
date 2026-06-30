Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F875282F3A
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2026 06:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782799400; cv=none; b=Y+2QoAmEQ9nRSp+a0w41u6OyloxNg+gMAtFvzKfg12KS/AEnE1aUBoqgu3y2WeQPfqnfceofpVluzql328qasLVezETG0qG9YB6u7sT6K8Sm2v5rP0HVceczVAludH4S1yWAC31eDVCZSIN2H8cpwkx7sg3TXnfWq1dCiXYRKms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782799400; c=relaxed/simple;
	bh=IlAGXaK+2zZ/FnEHllnjWDGcXADxcVKygxFH7E4yA18=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qinn1Tgx/OA85kVvOc4M31ybeX0DekHD7txGNUkTcg9i/S/Hm636gpfMsVgtAiaNvKtPSqf3l2F12gn04Kb2saExDRWXbfTmwSmNwassZ9CTUx4eneezn5Fgef+4JZA96Lh35bAMsUj774I05wNWJXiCQAujydfC3KPXVvkVWYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F0B7960D0F; Tue, 30 Jun 2026 08:03:16 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2] netfilter: nft_ct: support expectation creation for natted flows
Date: Tue, 30 Jun 2026 08:03:08 +0200
Message-ID: <20260630060311.2504-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This feature only works for connections originating from the host
and only if there no source address rewrite.

Add the needed nat glue to have the expectation follow the original
nat binding.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2:
 add missing nf_ct_expect_iterate_destroy() in exit handler
 fix buld with CONFIG_NF_NAT=n

 net/netfilter/nft_ct.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 03a88c77e0f0..95fc3d7c1edb 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1297,6 +1297,17 @@ static int nft_ct_expect_obj_dump(struct sk_buff *skb,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+static void nft_ct_nat_follow_master(struct nf_conn *ct, struct nf_conntrack_expect *this)
+{
+	const struct nf_ct_helper_expectfn *expfn;
+
+	expfn = nf_ct_helper_expectfn_find_by_name("nat-follow-master");
+	if (expfn)
+		expfn->expectfn(ct, this);
+}
+#endif
+
 static void nft_ct_expect_obj_eval(struct nft_object *obj,
 				   struct nft_regs *regs,
 				   const struct nft_pktinfo *pkt)
@@ -1342,6 +1353,13 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 		          priv->l4proto, NULL, &priv->dport);
 	exp->timeout += priv->timeout;
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+	if (ct->status & IPS_NAT_MASK) {
+		exp->saved_proto.tcp.port = priv->dport;
+		exp->dir = !dir;
+		exp->expectfn = nft_ct_nat_follow_master;
+	}
+#endif
 	if (nf_ct_expect_related(exp, 0) != 0)
 		regs->verdict.code = NF_DROP;
 
@@ -1416,6 +1434,13 @@ static int __init nft_ct_module_init(void)
 	return err;
 }
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+static bool __exit expect_iter_nat(struct nf_conntrack_expect *exp, void *data)
+{
+	return exp->expectfn == nft_ct_nat_follow_master;
+}
+#endif
+
 static void __exit nft_ct_module_exit(void)
 {
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
@@ -1425,6 +1450,11 @@ static void __exit nft_ct_module_exit(void)
 	nft_unregister_obj(&nft_ct_helper_obj_type);
 	nft_unregister_expr(&nft_notrack_type);
 	nft_unregister_expr(&nft_ct_type);
+
+#if IS_ENABLED(CONFIG_NF_NAT)
+	nf_ct_expect_iterate_destroy(expect_iter_nat, NULL);
+	synchronize_rcu();
+#endif
 }
 
 module_init(nft_ct_module_init);
-- 
2.53.0

