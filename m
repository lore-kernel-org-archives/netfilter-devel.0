Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749E1194C84
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2024 13:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723208868; cv=none; b=dsxBZI002xeZ37IpdHpzTmiOnKwdJLZZSjmzjBVRy6UFzacaC9sf+p8w204NtgZMuuluI2Nd7i4v23eIYUNKIcAG8mK2n8rPa8xB7lATdt4E7/uMDw93DRchjcOz3YNZooUDxk1kt8DjqM7QHLi5IRfQYMjo5F3FYcr/jxt4ppg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723208868; c=relaxed/simple;
	bh=FGA6tCOhq/MX/C06oJZLzS4atBjmRYW/5yvtbpdX7W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJayufs2LltyJv7vvQovCTp2L6LaakqgbngKMQ2pOFzO+grUVKrgC1XJWXMGUc82OYZpSMCIskQdfT3xukwEL7v7RlX95ZedN5X0CNEbcqukbQLNtc4D0TXSS7NQ2f1+1uCUkejEBuoCtWhhD3pvZMvYQ/xEChI3Ef8Y3kmK1V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=AIpgQ9iB; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="AIpgQ9iB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=u3+O6Ivl/rt4lLpZyJnObXGo/UGQgdNb4RVImCGH4uw=; b=AIpgQ9iBcmAAPP+AJD344cvqU+
	cawFyqHYao1LsuORLEYq0F7WtWzedipBZ5zXWcZsx+yIBqswOUk42OC516NDQgN2Fgi4OxUaqYRz8
	XlwQ+8rav0trKX4OujME+esHas0sWb6LFyzdw5jLGz8fStWlChwmEjZRXxTw8ESE73n5CUbgbQFp9
	7WmBNkPc8hFCoLzHl106vnEMbG/VKVABK2swyk19BRJrrXxNtQwhwYh7uwrNX+dulJ+6vybOSaY8z
	VcKs9TP/tE8GTtPXoN0TUvfRn6TdxONN1BQyLclxU1JPwuTiUC/h7DWPl/r9M/dzeveCLv4UAoZ+i
	s8qRORUA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1scPLF-000000000Dh-09TO;
	Fri, 09 Aug 2024 15:07:37 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf PATCH v4 1/3] netfilter: nf_tables: Audit log dump reset after the fact
Date: Fri,  9 Aug 2024 15:07:30 +0200
Message-ID: <20240809130732.13128-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240809130732.13128-1-phil@nwl.cc>
References: <20240809130732.13128-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In theory, dumpreset may fail and invalidate the preceeding log message.
Fix this and use the occasion to prepare for object reset locking, which
benefits from a few unrelated changes:

* Add an early call to nfnetlink_unicast if not resetting which
  effectively skips the audit logging but also unindents it.
* Extract the table's name from the netlink attribute (which is verified
  via earlier table lookup) to not rely upon validity of the looked up
  table pointer.
* Do not use local variable family, it will vanish.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 481ee78e77bc..4fa132715fcc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8055,6 +8055,7 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
+	const struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
@@ -8064,6 +8065,7 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 	struct sk_buff *skb2;
 	bool reset = false;
 	u32 objtype;
+	char *buf;
 	int err;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
@@ -8102,27 +8104,23 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
 		reset = true;
 
-	if (reset) {
-		const struct nftables_pernet *nft_net;
-		char *buf;
-
-		nft_net = nft_pernet(net);
-		buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, nft_net->base_seq);
-
-		audit_log_nfcfg(buf,
-				family,
-				1,
-				AUDIT_NFT_OP_OBJ_RESET,
-				GFP_ATOMIC);
-		kfree(buf);
-	}
-
 	err = nf_tables_fill_obj_info(skb2, net, NETLINK_CB(skb).portid,
 				      info->nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
 				      family, table, obj, reset);
 	if (err < 0)
 		goto err_fill_obj_info;
 
+	if (!reset)
+		return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+
+	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
+			nla_len(nla[NFTA_OBJ_TABLE]),
+			(char *)nla_data(nla[NFTA_OBJ_TABLE]),
+			nft_net->base_seq);
+	audit_log_nfcfg(buf, info->nfmsg->nfgen_family, 1,
+			AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
+	kfree(buf);
+
 	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
 
 err_fill_obj_info:
-- 
2.43.0

