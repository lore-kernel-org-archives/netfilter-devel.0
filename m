Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7068A44E04A
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2026 19:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782846584; cv=none; b=EYPJvQFZmApe+aeUG5lKen374FdJ75n7B/UYCyj7O4DnRPavHnhY9J2xTwNyaFN8XK5ebjbX3kUYoItkbXas/fvvhNwsyGIptulGsE5jhBtVfbPE/ZVTguRD7CWlNMKB2bcqjPLTRwCyS/xZz/JJM310GyPu0h+5JWktE9lYgjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782846584; c=relaxed/simple;
	bh=hAsvvU0TUaGZkKazda+54mXX61Kg0Q8IF7Bp5NuepDI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HfTq1ca+RKUX7Z+xqQqVaIH+MSXhK5kj//KWGq4GmAFW+J2k2AmSblJplmQa2gT1hHf4h090Jm9d6ifCE3Q9waZLXO/GdOs6loS6+B4KrCp6GGr0IUv90jZ0IGYa7MP+xCvqdgHekuRGj1V3MBt+fZDZQSl3g67OF4yZ1JRFAQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4D50C6064B; Tue, 30 Jun 2026 21:09:35 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf] netfilter: nft_ct: support expectation creation for natted flows
Date: Tue, 30 Jun 2026 21:09:29 +0200
Message-ID: <20260630190929.14735-1-fw@strlen.de>
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
 v3: use struct nf_ct_helper_expectfn for this.
 Compared to v2 this means dumping and restoring the
 expfn via ctnetlink will work.
 nf_ct_helper_expectfn_destroy() will zap any
 expectations that use nft_ct_nat_follow_master, so no need
 to call the iterator directly as in v2.

 net/netfilter/nft_ct.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 03a88c77e0f0..b9dc47b6ca93 100644
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
 
@@ -1375,6 +1393,11 @@ static struct nft_object_type nft_ct_expect_obj_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
+static struct nf_ct_helper_expectfn nft_ct_nat __read_mostly = {
+	.name = "nft_ct-follow-master",
+	.expectfn = nft_ct_nat_follow_master,
+};
+
 static int __init nft_ct_module_init(void)
 {
 	int err;
@@ -1400,6 +1423,9 @@ static int __init nft_ct_module_init(void)
 	err = nft_register_obj(&nft_ct_timeout_obj_type);
 	if (err < 0)
 		goto err4;
+#endif
+#if IS_ENABLED(CONFIG_NF_NAT)
+	nf_ct_helper_expectfn_register(&nft_ct_nat);
 #endif
 	return 0;
 
@@ -1425,6 +1451,13 @@ static void __exit nft_ct_module_exit(void)
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
2.53.0

