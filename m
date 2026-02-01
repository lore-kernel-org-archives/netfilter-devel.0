Received: from wilbur.contactoffice.com (wilbur.contactoffice.com [212.3.242.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA889126C02
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Feb 2026 19:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.3.242.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769975616; cv=none; b=awGTypJ9dHhpQOY61D4PAb/B72xIXQFd6QewQpV2iZEALOnqXtfA8uZri2w3ijwY44c9deAbnFwenk4qaIxEDGOwT9p1Kq3XNBUw/8uQhGuj7rwnCZDyHPhsCRMAg1zDFMUBrCHmH8ctMdcY1J9SC+WW+czIeDPxgPCLQ0zznRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769975616; c=relaxed/simple;
	bh=hOmJan+YKdcoPg8HAbqmbxOUfcukETWqi2DSBO8Gh3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neOcMRzzrcm7Sdh350/6suyq+hlJHiuMrKsp4/Y4SitFeG9wBTWKLW0abUgWhBzvOQoYEvB1A/w/o7USCj+QgMpJ0KVG2l7REbno8QskDLEImQISYHlbr64K0zzgmPcea6fX9yWpbhIXpF66xof5dGNDPQsVtGyLn02xkHEluMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com; spf=pass smtp.mailfrom=mailfence.com; dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b=GDiWHy9x; arc=none smtp.client-ip=212.3.242.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailfence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b="GDiWHy9x"
Received: from smtpauth2.co-bxl (smtpauth2.co-bxl [10.2.0.24])
	by wilbur.contactoffice.com (Postfix) with ESMTP id 454B413D5;
	Sun,  1 Feb 2026 20:53:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769975613;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=XrSgvsyz5tIjzVS5s2LwCUUdwYA8FOQzONQ6i7INNg8=;
	b=GDiWHy9xCVHfrmt1qVTpGxth0fCm5nJy+16Kw91eD/Irf4Ny22hCAxJKYl9nCmJb
	HmgO5ToB8hELlvJrUpL2ZzliTrpfNlwlKYJV5M5hng1jCYiWoHPvfPJHgrKWq8G8Qn4
	KfQDjDJ4nnuV7R1RD2YziIBug1s3SWOdvwpx+TuA68soolPCbUNEcEQ3lOJ9v/1JAin
	OFqk4yn1grvm/kCoiarmnPyE3RrbzCrp04ZJrvJNrP3ZxyvI1nUE5bCnEgZ/udwJzlw
	ZNOr8OaAQ06fZNDWNL1B0P+5vJXZCYMOK+jj3kU8LpGwaE0AnuOd0OCZ1rJaAN+iho2
	6JtjJiWejQ==
Received: by smtp.mailfence.com with ESMTPSA ; Sun, 1 Feb 2026 20:53:31 +0100 (CET)
From: Brian Witte <brianwitte@mailfence.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@blackhole.kfki.hu,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com,
	Brian Witte <brianwitte@mailfence.com>
Subject: [PATCH v3 2/2] netfilter: nf_tables: use spinlock for reset serialization
Date: Sun,  1 Feb 2026 13:52:55 -0600
Message-ID: <20260201195255.532559-3-brianwitte@mailfence.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260201195255.532559-1-brianwitte@mailfence.com>
References: <20260201195255.532559-1-brianwitte@mailfence.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ContactOffice-Account: com:441463380

Serialize reset requests with a dedicated spinlock. A spinlock
suffices since the reset path does not sleep, and contention is
expected to be rare.

Reported-by: syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ff16b505ec9152e5f448
Fixes: bd662c4218f9 ("netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests")
Fixes: 3d483faa6663 ("netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET requests")
Fixes: 3cb03edb4de3 ("netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests")
Signed-off-by: Brian Witte <brianwitte@mailfence.com>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 41 +++++++++++++++++++++++++++++--
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 31906f90706e..42533273c61e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1931,6 +1931,7 @@ struct nftables_pernet {
 	struct list_head	module_list;
 	struct list_head	notify_list;
 	struct mutex		commit_mutex;
+	spinlock_t		reset_lock;
 	u64			table_handle;
 	u64			tstamp;
 	unsigned int		gc_seq;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5b6c7acf5781..11765fc3ac67 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3860,6 +3860,9 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	nft_net = nft_pernet(net);
 	cb->seq = nft_base_seq(net);
 
+	if (ctx->reset)
+		spin_lock(&nft_net->reset_lock);
+
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
 			continue;
@@ -3895,6 +3898,9 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 			break;
 	}
 done:
+	if (ctx->reset)
+		spin_unlock(&nft_net->reset_lock);
+
 	rcu_read_unlock();
 
 	ctx->s_idx = idx;
@@ -4008,7 +4014,12 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
 		reset = true;
 
+	if (reset)
+		spin_lock(&nft_net->reset_lock);
 	skb2 = nf_tables_getrule_single(portid, info, nla, reset);
+	if (reset)
+		spin_unlock(&nft_net->reset_lock);
+
 	if (IS_ERR(skb2))
 		return PTR_ERR(skb2);
 
@@ -6265,11 +6276,18 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	if (nest == NULL)
 		goto nla_put_failure;
 
+	if (dump_ctx->reset)
+		spin_lock(&nft_net->reset_lock);
+
 	set->ops->walk(&dump_ctx->ctx, set, &args.iter);
 
 	if (!args.iter.err && args.iter.count == cb->args[0])
 		args.iter.err = nft_set_catchall_dump(net, skb, set,
 						      dump_ctx->reset, cb->seq);
+
+	if (dump_ctx->reset)
+		spin_unlock(&nft_net->reset_lock);
+
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
 
@@ -6533,10 +6551,10 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 				const struct nfnl_info *info,
 				const struct nlattr * const nla[])
 {
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	struct nft_set_dump_ctx dump_ctx;
 	int rem, err = 0, nelems = 0;
-	struct net *net = info->net;
 	struct nlattr *attr;
 	bool reset = false;
 
@@ -6566,6 +6584,9 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	if (err)
 		return err;
 
+	if (reset)
+		spin_lock(&nft_net->reset_lock);
+
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, reset);
 		if (err < 0) {
@@ -6574,9 +6595,12 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 		}
 		nelems++;
 	}
-	if (reset)
+
+	if (reset) {
+		spin_unlock(&nft_net->reset_lock);
 		audit_log_nft_set_reset(dump_ctx.ctx.table, nft_base_seq(info->net),
 					nelems);
+	}
 
 	return err;
 }
@@ -8388,6 +8412,9 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	nft_net = nft_pernet(net);
 	cb->seq = nft_base_seq(net);
 
+	if (ctx->reset)
+		spin_lock(&nft_net->reset_lock);
+
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
 			continue;
@@ -8424,6 +8451,10 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 		if (rc < 0)
 			break;
 	}
+
+	if (ctx->reset)
+		spin_unlock(&nft_net->reset_lock);
+
 	rcu_read_unlock();
 
 	ctx->s_idx = idx;
@@ -8533,7 +8564,12 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
 		reset = true;
 
+	if (reset)
+		spin_lock(&nft_net->reset_lock);
 	skb2 = nf_tables_getobj_single(portid, info, nla, reset);
+	if (reset)
+		spin_unlock(&nft_net->reset_lock);
+
 	if (IS_ERR(skb2))
 		return PTR_ERR(skb2);
 
@@ -12032,6 +12068,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&nft_net->module_list);
 	INIT_LIST_HEAD(&nft_net->notify_list);
 	mutex_init(&nft_net->commit_mutex);
+	spin_lock_init(&nft_net->reset_lock);
 	net->nft.base_seq = 1;
 	nft_net->gc_seq = 0;
 	nft_net->validate_state = NFT_VALIDATE_SKIP;
-- 
2.47.3

