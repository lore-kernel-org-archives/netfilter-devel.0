Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D8B1F5437
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 13:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782740773; cv=none; b=dfFn2x7kqCBM4i+ZTkRm8DSbwWUMUqlYJEHzBndFhcl2xS5+NQX2GjIAWfuXQtNWcJw/L16nqlbWB3HpZqUUV3xaGVdmKdyo/5zu9/2VsRU2wz9hCuc0S59nxxinQ/8/c9m9cp38oxMAA+/IwAVlC7eEEf5q+vHwApExBG94hiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782740773; c=relaxed/simple;
	bh=e3NVy6Xxf8kOM3ura81z6CBcOMsCNvpetvza+83rnfY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kxqEVb6ulTpRnMwwbFf9TcHpDkColu0BWmI8x09jfR35hC8yq6uOhvpr1tm/HxF3xEdFZehbV16m+rH3RKI9TlfjlzYjHDwtnHuz97ivKuSybNeCeUTk0XpAplSYyhAPVZNAT7ZRjp9RzEWELmXqNgX9WQKYa3Olqc1qHhZANSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A81226032C; Mon, 29 Jun 2026 15:46:09 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nft_ct: support expectation creation for natted flows
Date: Mon, 29 Jun 2026 15:46:01 +0200
Message-ID: <20260629134604.9379-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This feature only works for connections originating from the host
and only if there is no active source address rewrite.

Add the needed nat glue to have the expectation follow the original
nat binding.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_ct.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 03a88c77e0f0..09a9e663749a 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1297,6 +1297,15 @@ static int nft_ct_expect_obj_dump(struct sk_buff *skb,
 	return 0;
 }
 
+static void nft_ct_nat_follow_master(struct nf_conn *ct, struct nf_conntrack_expect *this)
+{
+	const struct nf_ct_helper_expectfn *expfn;
+
+	expfn = nf_ct_helper_expectfn_find_by_name("nat-follow-master");
+	if (expfn)
+		expfn->expectfn(ct, this);
+}
+
 static void nft_ct_expect_obj_eval(struct nft_object *obj,
 				   struct nft_regs *regs,
 				   const struct nft_pktinfo *pkt)
@@ -1342,6 +1351,12 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 		          priv->l4proto, NULL, &priv->dport);
 	exp->timeout += priv->timeout;
 
+	if (ct->status & IPS_NAT_MASK) {
+		exp->saved_proto.tcp.port = priv->dport;
+		exp->dir = !dir;
+		exp->expectfn = nft_ct_nat_follow_master;
+	}
+
 	if (nf_ct_expect_related(exp, 0) != 0)
 		regs->verdict.code = NF_DROP;
 
-- 
2.53.0

