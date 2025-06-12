Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374467DA73
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 13:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749735507; cv=none; b=rxpwQc80Eli1t4TRxIJhhMsP6RAAJu3Z2BRhZE6Q/cUrAEPRwvI65ID897gvnYkzZmz3TArbJixPtOiXIyaadk/4qKawNplgJKP/iQXMM7t0H4hZ5Ae7wzrVUfFNdUZ1+5OTMBlG2dz4fwjKwh/IJlGnYxTcuwh44tD3CYZXdS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749735507; c=relaxed/simple;
	bh=asmqhGEILWozMq2q5vQedNBxDBZMeoFqmgfC+5DDDHo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cCvhFhKSJ6ncsKPcHJLzj5JgO4hsF0dYTy2KUV/SdozP30kypNZKkxsWI5hC/hL1N7qvQbWB/N8yybk9UeiAtO7q/7iXrLZRMgoawqhfGGyOwFCU3L48Ai+ShJ3NnjJccTRiYIy1oXZIilqMMU2MCFWPZFmQtHXKFGcSlgiRPdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DqO1b7Xu; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DqO1b7Xu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=q7yImd7gbBzbIDauZW+p6VCsFz9Wb7Mr/AF41s+HhZA=; b=DqO1b7XudOG+6W/F0VOs0N0APs
	tb3rAb//Rh8Ci2axf4En46O7m8Q0kMzolcyAMgTxl45SIFNLqHjKDhTd1/vwnBKO8mfFnxDDHBq8r
	6/RrNtVq+FJKElZGcO2JPQxXwM+MW51eEkOE5F7fMrzTZ2+wJ/0fNngLv+SfOcWGjFLSXVGx9H6rr
	lWZQMGiUVU81XBwKIxra/HmcZT6yxXPlmQPRzKvMk4oK5QL78fVoOm2fN6ZXMV+Znl/NggdOVFbPV
	DPHJk1KkoLbaej2K+mZjynlujhb/P1gcWK1mslM31FvO6BE/RuQiiUH7lxk96eG1GxQsNbRV6RpfL
	gibrOFCA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPi8O-000000000yH-2Ekc;
	Thu, 12 Jun 2025 15:38:24 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH] netfilter: nf_tables: Fix for extra data in delete notifications
Date: Thu, 12 Jun 2025 15:38:19 +0200
Message-ID: <20250612133819.19188-1-phil@nwl.cc>
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
---
 net/netfilter/nf_tables_api.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8952b50b0224..94fd39450672 100644
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
 
@@ -8346,9 +8347,9 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
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

