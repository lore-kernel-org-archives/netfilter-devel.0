Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA81D2A1CF
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Oct 2025 23:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759619102; cv=none; b=sEHv3VMmjl3y4wW0Kmlf5DSiA/cPMiVSeEeK7s5sBuUk/TK3RSha/BkQ1CZNQF8C0kJYdoYZaAyk/HMQZaVH1gFkSiE6ZyY8pIgqfjnLMTTo3N7Lqc06jMENT/aGr0I8hZ41Tt95VPcwz3aEEp6bXsv87/ahi7eF6aPUOquCmkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759619102; c=relaxed/simple;
	bh=93CEiKtEiKV/HMkcJ1wOf9UL7RyfxMZU/E03fld49g4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZjYqfzi9C67b9zcOZvoJb37bhZ5jKJbtGmxQRDeNRFYUarbKuVyJBWW95dLuZuve7zDSm4D8COnt8eWLZV6tzUlx2NXgPxKSnZVHD9XEzcsl0VQMt8NZ4V1J1HFJ00X3l+Vb46RiKoiP6RYSoDSGm5j0m5R7ZOkr15XnchzSN0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NFgRyYof; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NS3ZQDdl; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NFgRyYof; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NS3ZQDdl; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NFgRyYof";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NS3ZQDdl";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NFgRyYof";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NS3ZQDdl"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 681F81F38E;
	Sat,  4 Oct 2025 23:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759619091; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=w9FEPKxC+Txi9m5GtXSF/g4nCdmZHs1ZvzJmpdbvb3g=;
	b=NFgRyYoftFe5WQdWmOUaQjozUE1Q8cuJnxNTTabsl7vhlnQzwansNvY1VLvWoiZkbOA8AE
	Je7tRTIWNBFsz27NZdy82tRr112rFcp25eglZLrJPNaLbKUHUmzXG1KCVgnA0hGwswT9mA
	x0Fw0qK4NgAndxyENX2xyBCWY/BS2iQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759619091;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=w9FEPKxC+Txi9m5GtXSF/g4nCdmZHs1ZvzJmpdbvb3g=;
	b=NS3ZQDdlVEkw/hV38OELSw/YcfeR65mMOKYvoKUeQrjyHa0bjxsUmBdGV8EN13oTs0G2nY
	VWCBA7RWImeNq7CA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NFgRyYof;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NS3ZQDdl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759619091; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=w9FEPKxC+Txi9m5GtXSF/g4nCdmZHs1ZvzJmpdbvb3g=;
	b=NFgRyYoftFe5WQdWmOUaQjozUE1Q8cuJnxNTTabsl7vhlnQzwansNvY1VLvWoiZkbOA8AE
	Je7tRTIWNBFsz27NZdy82tRr112rFcp25eglZLrJPNaLbKUHUmzXG1KCVgnA0hGwswT9mA
	x0Fw0qK4NgAndxyENX2xyBCWY/BS2iQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759619091;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=w9FEPKxC+Txi9m5GtXSF/g4nCdmZHs1ZvzJmpdbvb3g=;
	b=NS3ZQDdlVEkw/hV38OELSw/YcfeR65mMOKYvoKUeQrjyHa0bjxsUmBdGV8EN13oTs0G2nY
	VWCBA7RWImeNq7CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F29FB1386E;
	Sat,  4 Oct 2025 23:04:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jorlNxKo4WjjQQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sat, 04 Oct 2025 23:04:50 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
Subject: [PATCH nf] netfilter: nf_tables: validate objref and objrefmap expressions
Date: Sun,  5 Oct 2025 01:04:24 +0200
Message-ID: <20251004230424.3611-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url,suse.com:email,suse.de:mid,suse.de:dkim,suse.de:email];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 681F81F38E
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01

Referencing a synproxy stateful object can cause a kernel crash due to
its usage on the OUTPUT hook. See the following trace:

BUG: TASK stack guard page was hit at 000000008bda5b8c (stack is 000000003ab1c4a5..00000000494d8b12)
[...]
Call Trace:
 <TASK>
 __find_rr_leaf+0x99/0x230
 fib6_table_lookup+0x13b/0x2d0
 ip6_pol_route+0xa4/0x400
 fib6_rule_lookup+0x156/0x240
 ip6_route_output_flags+0xc6/0x150
 __nf_ip6_route+0x23/0x50
 synproxy_send_tcp_ipv6+0x106/0x200 [nf_synproxy_core 2531b21bd6e9569ffd76f28a949f7f2922fec65d]
 synproxy_send_client_synack_ipv6+0x1aa/0x1f0 [nf_synproxy_core 2531b21bd6e9569ffd76f28a949f7f2922fec65d]
 nft_synproxy_do_eval+0x263/0x310 [nft_synproxy 1dcf907d37286d566a63aee8e263fccf6aba22d5]
 nft_do_chain+0x5a8/0x5f0 [nf_tables 5137ebab9ca1fa5980eb27e6394e4f7bf139224e]
 nft_do_chain_inet+0x98/0x110 [nf_tables 5137ebab9ca1fa5980eb27e6394e4f7bf139224e]
 nf_hook_slow+0x43/0xc0
 __ip6_local_out+0xf0/0x170
 ip6_local_out+0x17/0x70
 synproxy_send_tcp_ipv6+0x1a2/0x200 [nf_synproxy_core 2531b21bd6e9569ffd76f28a949f7f2922fec65d]
 synproxy_send_client_synack_ipv6+0x1aa/0x1f0 [nf_synproxy_core 2531b21bd6e9569ffd76f28a949f7f2922fec65d]
[...]

To avoid such situations, implement objref and objrefmap expression
validate function. Currently, only NFT_OBJECT_SYNPROXY object type
requires validation. This will also handle a jump to a chain using a
synproxy object from the OUTPUT hook.

Now when trying to reference a synproxy object in the OUTPUT hook, nft
will produce the following error:

synproxy_crash.nft:11:3-26: Error: Could not process rule: Operation not supported
		synproxy name mysynproxy
		^^^^^^^^^^^^^^^^^^^^^^^^

Fixes: ee394f96ad75 ("netfilter: nft_synproxy: add synproxy stateful object support")
Reported-by: Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
Closes: https://bugzilla.suse.com/1250237
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/net/netfilter/nf_tables.h      |  5 +++
 include/net/netfilter/nf_tables_core.h |  2 +
 net/netfilter/nf_tables_api.c          | 43 +++++++++++++++++++++
 net/netfilter/nft_objref.c             | 52 ++++++++++++++++++++++++++
 4 files changed, 102 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index fab7dc73f738..5994f465cbdc 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1135,6 +1135,11 @@ int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 			 const struct nft_set_iter *iter,
 			 struct nft_elem_priv *elem_priv);
 int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
+int nft_setelem_obj_validate(const struct nft_ctx *ctx, struct nft_set *set,
+			     const struct nft_set_iter *iter,
+			     struct nft_elem_priv *elem_priv);
+int nft_set_catchall_obj_validate(const struct nft_ctx *ctx,
+				  struct nft_set *set);
 int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index b8df5acbb723..097564ec998d 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -180,6 +180,8 @@ void nft_payload_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 void nft_objref_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		     const struct nft_pktinfo *pkt);
+int nft_objref_validate_obj(const struct nft_ctx *ctx,
+			    const struct nft_object *obj);
 void nft_objref_map_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			 const struct nft_pktinfo *pkt);
 struct nft_elem_priv *nft_dynset_new(struct nft_set *set,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eed434e0a970..470fe57ae6fb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4145,6 +4145,49 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 	return 0;
 }
 
+int nft_setelem_obj_validate(const struct nft_ctx *ctx, struct nft_set *set,
+			     const struct nft_set_iter *iter,
+			     struct nft_elem_priv *elem_priv)
+{
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
+	struct nft_object *obj;
+
+	if (!nft_set_elem_active(ext, iter->genmask))
+		return 0;
+
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
+	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
+		return 0;
+
+	obj = *nft_set_ext_obj(ext);
+
+	return nft_objref_validate_obj(ctx, obj);
+}
+
+int nft_set_catchall_obj_validate(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	struct nft_set_iter dummy_iter = {
+		.genmask	= nft_genmask_next(ctx->net),
+	};
+	struct nft_set_elem_catchall *catchall;
+
+	struct nft_set_ext *ext;
+	int ret = 0;
+
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list,
+				lockdep_commit_lock_is_held(ctx->net)) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (!nft_set_elem_active(ext, dummy_iter.genmask))
+			continue;
+
+		ret = nft_setelem_obj_validate(ctx, set, &dummy_iter, catchall->elem);
+		if (ret < 0)
+			return ret;
+	}
+
+	return ret;
+}
+
 int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 			 const struct nft_set_iter *iter,
 			 struct nft_elem_priv *elem_priv)
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 8ee66a86c3bc..2dd5dbd0354d 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -22,6 +22,36 @@ void nft_objref_eval(const struct nft_expr *expr,
 	obj->ops->eval(obj, regs, pkt);
 }
 
+int nft_objref_validate_obj(const struct nft_ctx *ctx,
+			    const struct nft_object *obj)
+{
+	unsigned int hooks;
+
+	switch (obj->ops->type->type) {
+	case NFT_OBJECT_SYNPROXY:
+		if (ctx->family != NFPROTO_IPV4 &&
+		    ctx->family != NFPROTO_IPV6 &&
+		    ctx->family != NFPROTO_INET)
+			return -EOPNOTSUPP;
+
+		hooks = (1 << NF_INET_LOCAL_IN) | (1 << NF_INET_FORWARD);
+
+		return nft_chain_validate_hooks(ctx->chain, hooks);
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int nft_objref_validate(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr)
+{
+	struct nft_object *obj = nft_objref_priv(expr);
+
+	return nft_objref_validate_obj(ctx, obj);
+}
+
 static int nft_objref_init(const struct nft_ctx *ctx,
 			   const struct nft_expr *expr,
 			   const struct nlattr * const tb[])
@@ -93,6 +123,7 @@ static const struct nft_expr_ops nft_objref_ops = {
 	.activate	= nft_objref_activate,
 	.deactivate	= nft_objref_deactivate,
 	.dump		= nft_objref_dump,
+	.validate	= nft_objref_validate,
 	.reduce		= NFT_REDUCE_READONLY,
 };
 
@@ -197,6 +228,26 @@ static void nft_objref_map_destroy(const struct nft_ctx *ctx,
 	nf_tables_destroy_set(ctx, priv->set);
 }
 
+static int nft_objref_map_validate(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr)
+{
+	const struct nft_objref_map *priv = nft_expr_priv(expr);
+	struct nft_set_iter iter = {
+		.genmask	= nft_genmask_next(ctx->net),
+		.type		= NFT_ITER_UPDATE,
+		.fn		= nft_setelem_obj_validate,
+	};
+
+	priv->set->ops->walk(ctx, priv->set, &iter);
+	if (!iter.err)
+		iter.err = nft_set_catchall_obj_validate(ctx, priv->set);
+
+	if (iter.err < 0)
+		return iter.err;
+
+	return 0;
+}
+
 static const struct nft_expr_ops nft_objref_map_ops = {
 	.type		= &nft_objref_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_objref_map)),
@@ -206,6 +257,7 @@ static const struct nft_expr_ops nft_objref_map_ops = {
 	.deactivate	= nft_objref_map_deactivate,
 	.destroy	= nft_objref_map_destroy,
 	.dump		= nft_objref_map_dump,
+	.validate	= nft_objref_map_validate,
 	.reduce		= NFT_REDUCE_READONLY,
 };
 
-- 
2.51.0

