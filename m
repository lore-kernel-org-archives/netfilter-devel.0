Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A0B221FBB
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 10:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759918144; cv=none; b=YfwfX4us9uvaiIUHhSllZshDPH9SC9Z/yaBKzy/99GLxE6Us4WINMbCFsnYqgDPiwprAhKV47OqRj8HMvcSNdFgSFv5s89fw2ruAin4R/yMCPHTDphAOA3sAVgdJxAUZR4T/4r7MZMcLCjXGIj5XN2xl9gDjgbMsbbepaSEDsRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759918144; c=relaxed/simple;
	bh=aHgDrnu+UrbKbLJ0owzYjxDPFf55RYbXiAlXDVkEyw0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ynz73wCCfD4UnhshXcoJ2LcS6QjwBkqVl/hOXjFxTLSQnEqsCeBdsBzsrtElkeFbY6MEB/st5aCzPPmJGGxdn7Ib8JLG7JSn5Uf6tgAtaGTudc5/OEDpUtr1gKcQ3Jn3R0f1eJZiRMyjaHuaxeXgNbtjz5Rwxtave9WF+RnhYIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xH1Xxz1w; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IDmNhcpL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xH1Xxz1w; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IDmNhcpL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xH1Xxz1w";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IDmNhcpL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xH1Xxz1w";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IDmNhcpL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 365AC22746;
	Wed,  8 Oct 2025 10:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759918140; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4BKNe0KiIEEbeqPmKa41BBHrygWrH777iUxrzrpJ4iI=;
	b=xH1Xxz1wyV6zN/GQddIzAsKAV86ysVyAZ0vX29V8q2eV5HTlHSQpfA+2cxmeZVmJhq6BSZ
	6yIJcM0z6wbEiHfxNhFT4+7tP4veTZulOXrpzkY95xm8p//8VE9TlKw9QVlDk2djKDv1Zz
	rLXATnLBN+zyxAbevtQa5NI/h2F2oC4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759918140;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4BKNe0KiIEEbeqPmKa41BBHrygWrH777iUxrzrpJ4iI=;
	b=IDmNhcpL5xFRbSfN0QZ9UEdiv24gZuS+OEaSvf5sIqmoGDvFq1v2eTYFdCsLW9lgTVhSvJ
	zHYUgbvlbUOY/iDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759918140; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4BKNe0KiIEEbeqPmKa41BBHrygWrH777iUxrzrpJ4iI=;
	b=xH1Xxz1wyV6zN/GQddIzAsKAV86ysVyAZ0vX29V8q2eV5HTlHSQpfA+2cxmeZVmJhq6BSZ
	6yIJcM0z6wbEiHfxNhFT4+7tP4veTZulOXrpzkY95xm8p//8VE9TlKw9QVlDk2djKDv1Zz
	rLXATnLBN+zyxAbevtQa5NI/h2F2oC4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759918140;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4BKNe0KiIEEbeqPmKa41BBHrygWrH777iUxrzrpJ4iI=;
	b=IDmNhcpL5xFRbSfN0QZ9UEdiv24gZuS+OEaSvf5sIqmoGDvFq1v2eTYFdCsLW9lgTVhSvJ
	zHYUgbvlbUOY/iDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CFA4413A3D;
	Wed,  8 Oct 2025 10:08:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +l4xMDs45mhWDgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 08 Oct 2025 10:08:59 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
Subject: [PATCH nf v2] netfilter: nft_objref: validate objref and objrefmap expressions
Date: Wed,  8 Oct 2025 12:08:16 +0200
Message-ID: <20251008100816.8526-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:url];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

Referencing a synproxy stateful object from OUTPUT hook causes kernel
crash due to infinite recursive calls:

BUG: TASK stack guard page was hit at 000000008bda5b8c (stack is 000000003ab1c4a5..00000000494d8b12)
[...]
Call Trace:
 __find_rr_leaf+0x99/0x230
 fib6_table_lookup+0x13b/0x2d0
 ip6_pol_route+0xa4/0x400
 fib6_rule_lookup+0x156/0x240
 ip6_route_output_flags+0xc6/0x150
 __nf_ip6_route+0x23/0x50
 synproxy_send_tcp_ipv6+0x106/0x200
 synproxy_send_client_synack_ipv6+0x1aa/0x1f0
 nft_synproxy_do_eval+0x263/0x310
 nft_do_chain+0x5a8/0x5f0 [nf_tables
 nft_do_chain_inet+0x98/0x110
 nf_hook_slow+0x43/0xc0
 __ip6_local_out+0xf0/0x170
 ip6_local_out+0x17/0x70
 synproxy_send_tcp_ipv6+0x1a2/0x200
 synproxy_send_client_synack_ipv6+0x1aa/0x1f0
[...]

Implement objref and objrefmap expression validate functions.

Currently, only NFT_OBJECT_SYNPROXY object type requires validation.
This will also handle a jump to a chain using a synproxy object from the
OUTPUT hook.

Now when trying to reference a synproxy object in the OUTPUT hook, nft
will produce the following error:

synproxy_crash.nft: Error: Could not process rule: Operation not supported
  synproxy name mysynproxy
  ^^^^^^^^^^^^^^^^^^^^^^^^

Fixes: ee394f96ad75 ("netfilter: nft_synproxy: add synproxy stateful object support")
Reported-by: Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
Closes: https://bugzilla.suse.com/1250237
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nft_objref.c | 39 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 8ee66a86c3bc..1a62e384766a 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -22,6 +22,35 @@ void nft_objref_eval(const struct nft_expr *expr,
 	obj->ops->eval(obj, regs, pkt);
 }
 
+static int nft_objref_validate_obj_type(const struct nft_ctx *ctx, u32 type)
+{
+	unsigned int hooks;
+
+	switch (type) {
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
+	return nft_objref_validate_obj_type(ctx, obj->ops->type->type);
+}
+
 static int nft_objref_init(const struct nft_ctx *ctx,
 			   const struct nft_expr *expr,
 			   const struct nlattr * const tb[])
@@ -93,6 +122,7 @@ static const struct nft_expr_ops nft_objref_ops = {
 	.activate	= nft_objref_activate,
 	.deactivate	= nft_objref_deactivate,
 	.dump		= nft_objref_dump,
+	.validate	= nft_objref_validate,
 	.reduce		= NFT_REDUCE_READONLY,
 };
 
@@ -197,6 +227,14 @@ static void nft_objref_map_destroy(const struct nft_ctx *ctx,
 	nf_tables_destroy_set(ctx, priv->set);
 }
 
+static int nft_objref_map_validate(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr)
+{
+	const struct nft_objref_map *priv = nft_expr_priv(expr);
+
+	return nft_objref_validate_obj_type(ctx, priv->set->objtype);
+}
+
 static const struct nft_expr_ops nft_objref_map_ops = {
 	.type		= &nft_objref_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_objref_map)),
@@ -206,6 +244,7 @@ static const struct nft_expr_ops nft_objref_map_ops = {
 	.deactivate	= nft_objref_map_deactivate,
 	.destroy	= nft_objref_map_destroy,
 	.dump		= nft_objref_map_dump,
+	.validate	= nft_objref_map_validate,
 	.reduce		= NFT_REDUCE_READONLY,
 };
 
-- 
2.51.0

