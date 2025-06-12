Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887B1248897
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 18:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749753042; cv=none; b=RpjcepGy/JJwLbNBfY28H52hpq/FnAfEdgdGZ+RI7lo4HXyxrfXW5fiLekPjWpmy6nZxDefzJaJO9tRPOmFIGlexH4Cme2kwtQSk37YolFLfhIvdOnLScfBbuFvl8o4yve3ZTZ8JvCN71WPJEKKu7ZdNlkTVAREw2BiG4ooL/Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749753042; c=relaxed/simple;
	bh=QmZUMkakphMfxdjv1gwyja+WtGB8/VXLDCOVojpKI9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pDUEaivwZmfscDCTYuIYcbcRvi4GOh7d6qo0atrA5H5xp04/orgRTOLDiqS+5xYJgYTYe91Uy3fVfQi8w1LRq1/PFxY6BIBlwV5RPXVRiB5Bsi7/lImARBDHTzyk83So0u8qu7+Y+qgZZgQ4LRhpzvH3+uXP6H37fY2y4lSLxNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Dwh66RHp; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Dwh66RHp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zjxQRL9ZyR/6h3p19hA2cUGtGk2b9b/vd4VuyYNb+kU=; b=Dwh66RHptCRfJ/Oq6yyS/Xtunn
	y2RV8MddPWfSQ4d3XdpAilblAgtt6IKWl7iZWixOPpbuEZihdyQyZtswm/3DVRY/Gbhb6CLkEHz0h
	zKKYIJqkHYrVke2wQfUzN3hbpktbnjmJPSSxpqWFqZZ79D2VQrp8qIQ4UI0lWZYx65Oa2S9/SKUk7
	qX8/Y3/wmorExBASM0UtkPK+sv66WWtfKB2LuRLOUp+0VOWNCyZcGdgG+yJRrAT93gWvrYa1+UeWT
	EkqFbinShuTbvQ1v4u4Es+1i7ZPGdekQuyxk00tUimsskkTnPP1vKXBnyoOfrO+Guqqh38TYuO9f4
	mV3isv+w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPmh4-000000006Xy-0M02;
	Thu, 12 Jun 2025 20:30:30 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v2] netfilter: nf_tables: Fix for extra data in delete notifications
Date: Thu, 12 Jun 2025 20:30:24 +0200
Message-ID: <20250612183024.1867-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All routines modified in this patch conditionally return early depending
on event value (and other criteria, i.e., chain/flowtable updates).
These checks were defeated by an upfront modification of that variable
for use in nfnl_msg_put(). Restore functionality by avoiding the
modification.

This change is particularly important for user space to distinguish
between a chain/flowtable update removing a hook and full deletion.

Fixes: 28339b21a365 ("netfilter: nf_tables: do not send complete notification of deletions")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Channeling this through -next despite it being a fix since unpatched
nft monitor chokes on the shortened delete flowtable notifications.

Changes since v1:
- User space depends on NFTA_OBJ_TYPE for proper deserialization, do not
  skip that attribute.
---
 net/netfilter/nf_tables_api.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8952b50b0224..9bf003797355 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1153,9 +1153,9 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 {
 	struct nlmsghdr *nlh;
 
-	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
-			   NFNETLINK_V0, nft_base_seq(net));
+	nlh = nfnl_msg_put(skb, portid, seq,
+			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
+			   flags, family, NFNETLINK_V0, nft_base_seq(net));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -2020,9 +2020,9 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 {
 	struct nlmsghdr *nlh;
 
-	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
-			   NFNETLINK_V0, nft_base_seq(net));
+	nlh = nfnl_msg_put(skb, portid, seq,
+			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
+			   flags, family, NFNETLINK_V0, nft_base_seq(net));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -4851,9 +4851,10 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	u32 seq = ctx->seq;
 	int i;
 
-	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, ctx->family,
-			   NFNETLINK_V0, nft_base_seq(ctx->net));
+	nlh = nfnl_msg_put(skb, portid, seq,
+			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
+			   flags, ctx->family, NFNETLINK_V0,
+			   nft_base_seq(ctx->net));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -8346,14 +8347,15 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 {
 	struct nlmsghdr *nlh;
 
-	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
-			   NFNETLINK_V0, nft_base_seq(net));
+	nlh = nfnl_msg_put(skb, portid, seq,
+			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
+			   flags, family, NFNETLINK_V0, nft_base_seq(net));
 	if (!nlh)
 		goto nla_put_failure;
 
 	if (nla_put_string(skb, NFTA_OBJ_TABLE, table->name) ||
 	    nla_put_string(skb, NFTA_OBJ_NAME, obj->key.name) ||
+	    nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
 	    nla_put_be64(skb, NFTA_OBJ_HANDLE, cpu_to_be64(obj->handle),
 			 NFTA_OBJ_PAD))
 		goto nla_put_failure;
@@ -8363,8 +8365,7 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 		return 0;
 	}
 
-	if (nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
-	    nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
+	if (nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
 	    nft_object_dump(skb, NFTA_OBJ_DATA, obj, reset))
 		goto nla_put_failure;
 
@@ -9391,9 +9392,9 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 	struct nft_hook *hook;
 	struct nlmsghdr *nlh;
 
-	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
-			   NFNETLINK_V0, nft_base_seq(net));
+	nlh = nfnl_msg_put(skb, portid, seq,
+			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
+			   flags, family, NFNETLINK_V0, nft_base_seq(net));
 	if (!nlh)
 		goto nla_put_failure;
 
-- 
2.49.0

