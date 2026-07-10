Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A051D286D70
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jul 2026 15:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783696461; cv=none; b=YKeE/5f86zWJp8X2TycsKLYRBb5VptcUbXcqm+zmB8kCa/B/cKJEA2GunPJncMwxmktBPXXtMq5LmiTYZPV6D2bou/IHCs/LOqsVn9Z7Hs9f7zHnT7E4OCsxo3u5f/VszxTer+n6Ij9U+PJBrpC590osI0Q9Mh66e+W7eS80p50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783696461; c=relaxed/simple;
	bh=ZghHyk9IaISOmoY3/Xc3bFwq8o6XVqOkCQtmgfWHf3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRNAt60s7B8aL/F3HrGQ4ndhCDF24Arl4JhBiIRVllaGdxLMRrKWF+k7vdgRmeJgakgtYYQ67QyZw/ywn3SNTibv68gGJK729eYU3xITL57uPl78MRDlqS8pa436VySnzIq+hRbc55MdMbFSarVkGzIONr5Q26trW1lETbmRod4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cDZRV8EP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cDZRV8EP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TNiJSE7nC9Maln19T9a0POBQoEi7HGIH2hECVx25LTs=; b=cDZRV8EPN94L4KhDhr9s6wITq/
	3lAc/RiCExCMdmeYwN2kBubjs/+iKPq6QWAzb72iosFJtO6CqZ1FhZHXYBKrTEPNrMVo91ZjDg0Ic
	MYdwSyV2K2HeyX6Khznqfs1uh8S87lWJ1h7L8weaxLVGVUGUJRje2nYP1g7+D7GObwmLn+Binw4Ge
	Jx2bSMLVXvbXKGJcwm+vDzIWU0Y6jtLWRzSBesAFCoZnuDGZJadWKvIuGIp9EGCuBfo5V+WIcn7/2
	RQr4e/iGcn/BSiYaAY4oMK3HIoOo12dKovH+aqnJdi9T3TavsIsqSb10DhYRbduBkAW7yagB3qCHU
	Y/AUomjQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wiCvg-000000001tk-3NZB;
	Fri, 10 Jul 2026 17:14:16 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH v3 1/4] netfilter: nfnetlink_hook: Pass cb object to nfnl_hook_dump_nat()
Date: Fri, 10 Jul 2026 17:14:08 +0200
Message-ID: <20260710151411.2358773-2-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710151411.2358773-1-phil@nwl.cc>
References: <20260710151411.2358773-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Preparing for proper multipart dump handling, pass the object reference
directly instead of individual fields. Keep passing the 'family' field
though so caller does not have to extract that value from netlink header
again.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nfnetlink_hook.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 95005e9a6066..e47a2add4d5b 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -338,12 +338,12 @@ nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *de
 }
 
 static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
-			      const struct nfnl_dump_hook_data *ctx,
-			      const struct nf_hook_ops *ops,
-			      int family, unsigned int seq)
+			      struct netlink_callback *cb,
+			      const struct nf_hook_ops *ops, int family)
 {
 	struct nf_nat_lookup_hook_priv *priv = ops->priv;
 	struct nf_hook_entries *e = rcu_dereference(priv->entries);
+	struct nfnl_dump_hook_data *ctx = cb->data;
 	struct nf_hook_ops **nat_ops;
 	int i, err;
 
@@ -354,7 +354,8 @@ static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
 
 	for (i = 0; i < e->num_hook_entries; i++) {
 		err = nfnl_hook_dump_one(nlskb, ctx, nat_ops[i],
-					 ops->priority, family, seq);
+					 ops->priority, family,
+					 cb->nlh->nlmsg_seq);
 		if (err)
 			return err;
 	}
@@ -390,8 +391,7 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
 
 	for (; i < e->num_hook_entries; i++) {
 		if (ops[i]->hook_ops_type == NF_HOOK_OP_NAT)
-			err = nfnl_hook_dump_nat(nlskb, ctx, ops[i], family,
-						 cb->nlh->nlmsg_seq);
+			err = nfnl_hook_dump_nat(nlskb, cb, ops[i], family);
 		else
 			err = nfnl_hook_dump_one(nlskb, ctx, ops[i],
 						 ops[i]->priority, family,
-- 
2.54.0

