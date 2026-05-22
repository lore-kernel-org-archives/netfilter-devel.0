Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1F03559F5
	for <netfilter-devel@vger.kernel.org>; Fri, 22 May 2026 05:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779426127; cv=none; b=XXeGGLQkvcw/oltyoE3/S81HgdCkqUV4/g5rsZmseTEzIdYz0LZOC3bf+QrjluglIhSbca7FNJrU2mEeCNzxuha79gcSuBgCheqVdaontsvPqwjEOp2I7jMMwcx85dXHi7aaydMXi1TQPtnd2Q86mM615q/6FjfkLNsxCy+4GHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779426127; c=relaxed/simple;
	bh=Z/4LKr38Pk08XZieE1ktVhueRYEs2mxVYAmISUUlPiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzKcclecfNFXw4tg4kPaeKJuaG6BPYhdlMRIX5o/2MjCWa/7fWEyHN3dpJcnzB/Pq/Z1dlNNQkYmB2aeisTJ0sF3aE3rkxVOwixyCxbshwR5yO00d4SIDbPgeC+qEiuWRKRf7EuMhStofJbyj9PN5AI+e0w1j2/mvjJPb+QSc1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 54CA860345; Fri, 22 May 2026 07:02:04 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/5] netfilter: remove obsolete nf_ct_helper_init api
Date: Fri, 22 May 2026 07:01:33 +0200
Message-ID: <20260522050140.4838-5-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522050140.4838-1-fw@strlen.de>
References: <20260522050140.4838-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No more in-tree users.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_helper.h | 12 ---------
 net/netfilter/nf_conntrack_helper.c         | 29 ---------------------
 2 files changed, 41 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index ab41ff60e9d1..2e1fea8b0a8d 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -91,18 +91,6 @@ struct nf_conntrack_helper *nf_conntrack_helper_try_module_get(const char *name,
 							       u8 protonum);
 void nf_conntrack_helper_put(struct nf_conntrack_helper *helper);
 
-void nf_ct_helper_init(struct nf_conntrack_helper *helper,
-		       u16 l3num, u16 protonum, const char *name,
-		       u16 default_port, u16 spec_port, u32 id,
-		       const struct nf_conntrack_expect_policy *exp_pol,
-		       u32 expect_class_max,
-		       int (*help)(struct sk_buff *skb, unsigned int protoff,
-				   struct nf_conn *ct,
-				   enum ip_conntrack_info ctinfo),
-		       int (*from_nlattr)(struct nlattr *attr,
-					  struct nf_conn *ct),
-		       struct module *module);
-
 int nf_conntrack_helper_register(struct nf_conntrack_helper *);
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 8bf283613c8c..44345d9e834e 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -416,35 +416,6 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
-void nf_ct_helper_init(struct nf_conntrack_helper *helper,
-		       u16 l3num, u16 protonum, const char *name,
-		       u16 default_port, u16 spec_port, u32 id,
-		       const struct nf_conntrack_expect_policy *exp_pol,
-		       u32 expect_class_max,
-		       int (*help)(struct sk_buff *skb, unsigned int protoff,
-				   struct nf_conn *ct,
-				   enum ip_conntrack_info ctinfo),
-		       int (*from_nlattr)(struct nlattr *attr,
-					  struct nf_conn *ct),
-		       struct module *module)
-{
-	helper->nfproto = l3num;
-	helper->l4proto = protonum;
-	helper->expect_policy = exp_pol;
-	helper->expect_class_max = expect_class_max;
-	helper->help = help;
-	helper->from_nlattr = from_nlattr;
-	helper->me = module;
-	snprintf(helper->nat_mod_name, sizeof(helper->nat_mod_name),
-		 NF_NAT_HELPER_PREFIX "%s", name);
-
-	if (spec_port == default_port)
-		snprintf(helper->name, sizeof(helper->name), "%s", name);
-	else
-		snprintf(helper->name, sizeof(helper->name), "%s-%u", name, id);
-}
-EXPORT_SYMBOL_GPL(nf_ct_helper_init);
-
 int nf_conntrack_helpers_register(struct nf_conntrack_helper *helper,
 				  unsigned int n)
 {
-- 
2.53.0

