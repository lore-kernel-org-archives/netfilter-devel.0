Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAA62222C0
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 09:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760346002; cv=none; b=k3CeuQ174cOIM6nuUtGKMOnuGyq6JbW0sdrRt5N/GjzkvH1zpuLTkv4gZN5B2SEFB76NaiO+B5GrCdQyJhIoQ00KWjBniSYJPTgtwTKJ2/5YhzAQGmWvISdjH06tkr245lRQyiCaoeyF+4jI3LkKcN2kRbV7/R0evtf18jbbXUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760346002; c=relaxed/simple;
	bh=0xFyC4Im5BUjh/dU4cyXbEGjA5JT3o/8V4nEZpetllM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XYse5y/fI3FkxKxWf4txNDLBvyGSuMZ0J3h6fMQQ1jejvcDUFUK7i73jvWSz1B6X4A4E2nHorshXr4HHklGX+sGXmhVaKzxTzW/eySK9eow1n/Lp3rFR3OMrW3r36EmLw0slBtnLRIcFfVmpiATlbHOoXkkD79fygqvJ9Sot8r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hxbzbufd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KlDaJzvI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hxbzbufd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KlDaJzvI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hxbzbufd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KlDaJzvI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hxbzbufd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KlDaJzvI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8AC601F7C6;
	Mon, 13 Oct 2025 08:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760345998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jDyAGkYnp4m1bh1MUYzlvYkLmGxgJmYw3JQ5ntXVCR4=;
	b=hxbzbufdSpbGf343IuOaIjTWqdjQ0HHmSVTJwHVo9+82io3qs3vNtf1ji1cUPlziWFlwf2
	0wwF5nhwUdBrl4vcsmJ1itLvjnVuGhcxQwByVsPtuXPI7y7/F5AJ8bgKKTWPLAFf7h44+j
	oeL3sKRwqkc3vyK6cKUx0IOfzxZIjjI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760345998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jDyAGkYnp4m1bh1MUYzlvYkLmGxgJmYw3JQ5ntXVCR4=;
	b=KlDaJzvIFhMEGqRCkao5m2fTqExacshisLGs4BW7Bqh5KJusIORY90/Hl989yJrbDr7f5A
	u3Jh9JvzdHAPNoCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760345998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jDyAGkYnp4m1bh1MUYzlvYkLmGxgJmYw3JQ5ntXVCR4=;
	b=hxbzbufdSpbGf343IuOaIjTWqdjQ0HHmSVTJwHVo9+82io3qs3vNtf1ji1cUPlziWFlwf2
	0wwF5nhwUdBrl4vcsmJ1itLvjnVuGhcxQwByVsPtuXPI7y7/F5AJ8bgKKTWPLAFf7h44+j
	oeL3sKRwqkc3vyK6cKUx0IOfzxZIjjI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760345998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jDyAGkYnp4m1bh1MUYzlvYkLmGxgJmYw3JQ5ntXVCR4=;
	b=KlDaJzvIFhMEGqRCkao5m2fTqExacshisLGs4BW7Bqh5KJusIORY90/Hl989yJrbDr7f5A
	u3Jh9JvzdHAPNoCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4DC581374A;
	Mon, 13 Oct 2025 08:59:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CGNBEI6/7GhYTgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 13 Oct 2025 08:59:58 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next] netfilter: nf_tables: use C99 struct initializer for nft_set_iter
Date: Mon, 13 Oct 2025 10:59:48 +0200
Message-ID: <20251013085948.4763-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Use C99 struct initializer for nft_set_iter, simplifying the code and
preventing future errors due to uninitialized fields if new fields are
added to the struct.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_tables_api.c | 34 ++++++++++++++++------------------
 net/netfilter/nft_lookup.c    | 13 +++++--------
 2 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eed434e0a970..f3de2f9bbebf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5770,7 +5770,11 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		       struct nft_set_binding *binding)
 {
 	struct nft_set_binding *i;
-	struct nft_set_iter iter;
+	struct nft_set_iter iter = {
+		.genmask	= nft_genmask_next(ctx->net),
+		.type		= NFT_ITER_UPDATE,
+		.fn		= nf_tables_bind_check_setelem,
+	};
 
 	if (!list_empty(&set->bindings) && nft_set_is_anonymous(set))
 		return -EBUSY;
@@ -5785,13 +5789,6 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 				goto bind;
 		}
 
-		iter.genmask	= nft_genmask_next(ctx->net);
-		iter.type	= NFT_ITER_UPDATE;
-		iter.skip 	= 0;
-		iter.count	= 0;
-		iter.err	= 0;
-		iter.fn		= nf_tables_bind_check_setelem;
-
 		set->ops->walk(ctx, set, &iter);
 		if (!iter.err)
 			iter.err = nft_set_catchall_bind_check(ctx, set);
@@ -6195,7 +6192,17 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	struct nftables_pernet *nft_net;
 	struct nft_table *table;
 	struct nft_set *set;
-	struct nft_set_dump_args args;
+	struct nft_set_dump_args args = {
+		.cb = cb,
+		.skb = skb,
+		.reset = dump_ctx->reset,
+		.iter = {
+			.genmask = nft_genmask_cur(net),
+			.type = NFT_ITER_READ,
+			.skip = cb->args[0],
+			.fn = nf_tables_dump_setelem,
+		},
+	};
 	bool set_found = false;
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
@@ -6246,15 +6253,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	if (nest == NULL)
 		goto nla_put_failure;
 
-	args.cb			= cb;
-	args.skb		= skb;
-	args.reset		= dump_ctx->reset;
-	args.iter.genmask	= nft_genmask_cur(net);
-	args.iter.type		= NFT_ITER_READ;
-	args.iter.skip		= cb->args[0];
-	args.iter.count		= 0;
-	args.iter.err		= 0;
-	args.iter.fn		= nf_tables_dump_setelem;
 	set->ops->walk(&dump_ctx->ctx, set, &args.iter);
 
 	if (!args.iter.err && args.iter.count == cb->args[0])
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 58c5b14889c4..fc2d7c5d83c8 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -246,19 +246,16 @@ static int nft_lookup_validate(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
 	const struct nft_lookup *priv = nft_expr_priv(expr);
-	struct nft_set_iter iter;
+	struct nft_set_iter iter = {
+		.genmask	= nft_genmask_next(ctx->net),
+		.type		= NFT_ITER_UPDATE,
+		.fn		= nft_setelem_validate,
+	};
 
 	if (!(priv->set->flags & NFT_SET_MAP) ||
 	    priv->set->dtype != NFT_DATA_VERDICT)
 		return 0;
 
-	iter.genmask	= nft_genmask_next(ctx->net);
-	iter.type	= NFT_ITER_UPDATE;
-	iter.skip	= 0;
-	iter.count	= 0;
-	iter.err	= 0;
-	iter.fn		= nft_setelem_validate;
-
 	priv->set->ops->walk(ctx, priv->set, &iter);
 	if (!iter.err)
 		iter.err = nft_set_catchall_validate(ctx, priv->set);
-- 
2.51.0

