Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6621E4499B6
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 19:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783626387; cv=none; b=eCc+8tnZQqNj5J18vjTVgAjZ/jy1m5M65tFHQTu0X58Dj2Hqau1zqoUBl4w7YzYO9bJITsvsRs9yhkp8424kvjl5s6uM+2GIHXfhIJzkGJe2wMwik1w9Lcveueirkh01EGR/PhG+omlduh16XGeto3fklFbnCOc7w8cx47xcWwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783626387; c=relaxed/simple;
	bh=IiI4gr94OIfpZv9Gc0w/4m31RgjCRNbYrsUnixwcF6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fxdk+DUYx0C7EfN2r3CSSEbmv61D5YCoeHwEyWIMEP9oKeWBoCrI+sGSI1vZksowOSg+sKCQ17f0G+yDZGuUMEUarm+Yzk6OgdjajAAce/M4Mb0m4xKhCsvDpkbIf9H+Kveg9PCBF5JvYcepul3roW4sSESCdikWYqR53uK9QpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UQgh7FO0; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UQgh7FO0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EQMWG8W8jHnz8Z7dMqkRI3HOSHk6UBXEMpEtdPllqgI=; b=UQgh7FO0NTTyKdIr1iI93mcVBd
	+fRLE9fIKBX+UoG28Pnb6qpWZ8HwN8dl9oU/dx4yOX//1eo/coGXVhMViKfvm/ONFbqP+IU6tjmZV
	xG0m0SQLG4kkj5LHjgBvCPGXAAASImlbFTMVEexbudTtEhgaCdEpIRKEVStfRYSGKMFV4sERMSvG0
	Hq2jx2ihwRAJ1XSQe/+aXVkEz/DNj7h4RwhEMrePhvZ3bfv/gZQRefhQ7903sPk/uySiqF7NxAIo/
	V0LYKLxnO8IaCVLHrRidF6BBXgqvDmi72Lsy3XMr5RyDwmsFPvY9PwKRmVUKjkt2jLc95HHs6o0qj
	5ml2cjjg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1whuhN-000000002ip-3Jyl;
	Thu, 09 Jul 2026 21:46:17 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH v2 2/5] netfilter: nfnetlink_hook: Pass cb object to nfnl_hook_dump_nat()
Date: Thu,  9 Jul 2026 21:46:09 +0200
Message-ID: <20260709194612.1995795-3-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709194612.1995795-1-phil@nwl.cc>
References: <20260709194612.1995795-1-phil@nwl.cc>
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
index 755d8f148db3..b0cf0ec41bc5 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -345,12 +345,12 @@ nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *de
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
 
@@ -361,7 +361,8 @@ static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
 
 	for (i = 0; i < e->num_hook_entries; i++) {
 		err = nfnl_hook_dump_one(nlskb, ctx, nat_ops[i],
-					 ops->priority, family, seq);
+					 ops->priority, family,
+					 cb->nlh->nlmsg_seq);
 		if (err)
 			return err;
 	}
@@ -397,8 +398,7 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
 
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

