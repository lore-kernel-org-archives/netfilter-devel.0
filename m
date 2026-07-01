Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8E13672B3
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2026 04:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782880658; cv=none; b=s63CScBDXVn1n5Jul6TP+TWdoA7e8yEaHHKPfjcF5KXIL910BAwAAZ6yetniUQSNY+C0Zxd9tYeBC4uHz3FadOL2uAMK4stIGwMJ2CxD3olctlJMHDU3DbIgfjuxKai9Vtn49Oa1o4X7N03GfKeFD8g2TEFMZ/FcwMHVl4GpzhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782880658; c=relaxed/simple;
	bh=mZbX0ppyiWdHh7bFp7sMlR+aquWJUqXIqMET75mBIHM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=THmRJmz7/IEDAHfKO0S5htlHzoLJKXd18XcZY3W/yd1Ql8gG/PCCWgcEK+CVE26njgXarTXMnMBDH2qx/qd8eVpb/wO1tbPEPPkZcwL+mHvqH4qdH1rXADqD8x3YwnpIqA2Ae2b71Jsauz8sQn9C+SnCh2t6y5TpccCzfzh2fsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 04D1A6038C; Wed, 01 Jul 2026 06:37:33 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4] netfilter: nft_ct: support expectation creation for natted flows
Date: Wed,  1 Jul 2026 06:37:27 +0200
Message-ID: <20260701043727.26493-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
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
 v4: yet another NF_NAT=n build failure aka missing ifdef, no other change.
 v3: switch to nf_ct_helper_expectfn_(un)register
 v2: zap stale expectations on rmmod

 net/netfilter/nft_ct.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 03a88c77e0f0..358b9287e12e 100644
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
 
@@ -1375,6 +1393,13 @@ static struct nft_object_type nft_ct_expect_obj_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+static struct nf_ct_helper_expectfn nft_ct_nat __read_mostly = {
+	.name = "nft_ct-follow-master",
+	.expectfn = nft_ct_nat_follow_master,
+};
+#endif
+
 static int __init nft_ct_module_init(void)
 {
 	int err;
@@ -1400,6 +1425,9 @@ static int __init nft_ct_module_init(void)
 	err = nft_register_obj(&nft_ct_timeout_obj_type);
 	if (err < 0)
 		goto err4;
+#endif
+#if IS_ENABLED(CONFIG_NF_NAT)
+	nf_ct_helper_expectfn_register(&nft_ct_nat);
 #endif
 	return 0;
 
@@ -1425,6 +1453,13 @@ static void __exit nft_ct_module_exit(void)
 	nft_unregister_obj(&nft_ct_helper_obj_type);
 	nft_unregister_expr(&nft_notrack_type);
 	nft_unregister_expr(&nft_ct_type);
+
+#if IS_ENABLED(CONFIG_NF_NAT)
+	nf_ct_helper_expectfn_unregister(&nft_ct_nat);
+	synchronize_rcu();
+	nf_ct_helper_expectfn_destroy(&nft_ct_nat);
+	synchronize_rcu();
+#endif
 }
 
 module_init(nft_ct_module_init);
-- 
2.54.0

