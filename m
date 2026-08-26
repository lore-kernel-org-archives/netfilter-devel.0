Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C3014EC73
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 13:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787751152; cv=none; b=pfLnZ+9HbQlzeIOuE2Yg5KjulB6zsm6Jm4hfAhVE4TWEIl5xP9sOvpx9RQ1UaZ1bjNMeD+WP48U+4bPB6tiDKTHlnys85J2wpbH3xekxcRwUVOaQ+6XlCnLK/sbsgaS3A9qajGUdJFmyzcDjX7LUL7/j/qDcqYs/GyREIUjGfcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787751152; c=relaxed/simple;
	bh=utwpCYTK1Y1HiT3/QXvUShCuy6okSb7/5kZsIWhcWVw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SgLiXERu5o7F+7F+9UbJoKHIPfBz2t2qiLDrHUrxLMkijrQ+TceB2fJ2Xz0QT7zoE73cA5B4vzI0k7lcqD1InQGYMwHAQ1NTGP6ZpLcCmGHmU2inSohDeab+WESEEkCqFUCx9hx6ZPTuPi81OaMQSdbIHzfWtcoHn6HEgAcgfhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lpxVxcLr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=s35f+IvT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=b4lueGKf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=chMJDVhm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lpxVxcLr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="s35f+IvT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b4lueGKf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="chMJDVhm"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A33FD87356;
	Wed, 26 Aug 2026 13:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787751144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yCwmAxXnCOpAcm6e5JIOMrUZJnaLNp/gvrieCZIp+oM=;
	b=lpxVxcLrslzfdTWd80vjv2eqrJ51aK+LxXaPn11nOsmCCDGLZDSWILitdKDvDpDJ9griSJ
	aCGGlFLPhMf92qcmJ0TXvxLcvCiu2Dma2QlCadQ3c/B6hSXZc1MfUaWYrhpapipZjf56eS
	V0BJxga4e9CYMYNMXPtc5N0vyJhvCwI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787751144;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yCwmAxXnCOpAcm6e5JIOMrUZJnaLNp/gvrieCZIp+oM=;
	b=s35f+IvTTueWc9CpIChgsPkpMa5vn+vDOPFqwe01SegoxqNn7NsI3UBzxlwDsjISuWUstt
	xF+lS4q1DbLPDVBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787751140; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yCwmAxXnCOpAcm6e5JIOMrUZJnaLNp/gvrieCZIp+oM=;
	b=b4lueGKfAs/vNOhrSCOoqftmFEijuNNuMURoU+Yz6qf4LJIGcbUjgXJ0rDqjzg7HuE2y1c
	1BgRcMCh4VZRPEtODfU7WJE4yB/km04eT1RBoY/MyRiyp2yHWFD6xKT/rlwfi+M4LYixIS
	fXzhYCGZcBcDIX5JlcpRGYH4EpdD+2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787751140;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yCwmAxXnCOpAcm6e5JIOMrUZJnaLNp/gvrieCZIp+oM=;
	b=chMJDVhmuDJ92Wpi1biXst/kdPH65/2WptIz3YJy4u6tTNzur8fbIA5rBKATsttINKi+ZV
	TjX9kR8bLGZXmDAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3846E1361C;
	Wed, 26 Aug 2026 13:32:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pg7WCuTqjmqBagAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 26 Aug 2026 13:32:20 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Wei Fang <void0red@gmail.com>
Subject: [PATCH nf v3] netfilter: nf_tables: fix device name and prefix match in hook lookup
Date: Wed, 26 Aug 2026 15:32:08 +0200
Message-ID: <20260826133208.4550-1-fmancera@suse.de>
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
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[netfilter.org,strlen.de,nwl.cc,suse.de,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Currently, a netdev chain or flowtable hooked to a device prefix can be
unintentionally deleted by a control-plane request targeting an exact
device name or even a shorter one due to the usage of min() to calculate
the length to match.

Fix this by making sure an exact device match never matches a prefix and
that both the target and the candidate have the same length during
delete operation. The add and update paths retain the existing overlap
matching to prevent a single device from matching multiple hooks.

Reported-by: Wei Fang <void0red@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/
Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_tables_api.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c112ecc4fca3..9ef12feec1ac 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1978,7 +1978,7 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 	return -ENOSPC;
 }
 
-static bool hook_is_prefix(struct nft_hook *hook)
+static bool hook_is_prefix(const struct nft_hook *hook)
 {
 	return strlen(hook->ifname) >= hook->ifnamelen;
 }
@@ -2440,11 +2440,14 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 }
 
 static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
-					   const struct nft_hook *this)
+					   const struct nft_hook *this,
+					   bool strict)
 {
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, hook_list, list) {
+		if (strict && hook->ifnamelen != this->ifnamelen)
+			continue;
 		if (!strncmp(hook->ifname, this->ifname,
 			     min(hook->ifnamelen, this->ifnamelen))) {
 			if (hook->flags & NFT_HOOK_REMOVE)
@@ -2486,7 +2489,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 			err = PTR_ERR(hook);
 			goto err_hook;
 		}
-		if (nft_hook_list_find(hook_list, hook)) {
+		if (nft_hook_list_find(hook_list, hook, false)) {
 			NL_SET_BAD_ATTR(extack, tmp);
 			nft_netdev_hook_free(hook);
 			err = -EEXIST;
@@ -2943,7 +2946,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 					ops->hook	= basechain->ops.hook;
 				}
 
-				if (nft_hook_list_find(&basechain->hook_list, h)) {
+				if (nft_hook_list_find(&basechain->hook_list, h, false)) {
 					list_del(&h->list);
 					nft_netdev_hook_free(h);
 					continue;
@@ -2956,7 +2959,8 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 					    !nft_trans_chain_update(trans))
 						continue;
 
-					if (nft_hook_list_find(&nft_trans_chain_hooks(trans), h)) {
+					if (nft_hook_list_find(&nft_trans_chain_hooks(trans),
+							       h, false)) {
 						nft_chain_release_hook(&hook);
 						return -EEXIST;
 					}
@@ -3257,7 +3261,7 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 		return err;
 
 	list_for_each_entry(this, &chain_hook.list, list) {
-		hook = nft_hook_list_find(&basechain->hook_list, this);
+		hook = nft_hook_list_find(&basechain->hook_list, this, true);
 		if (!hook) {
 			err = -ENOENT;
 			goto err_chain_del_hook;
@@ -9073,7 +9077,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			if (!nft_is_active_next(net, ft))
 				continue;
 
-			if (nft_hook_list_find(&ft->hook_list, hook)) {
+			if (nft_hook_list_find(&ft->hook_list, hook, false)) {
 				err = -EEXIST;
 				goto err_unregister_net_hooks;
 			}
@@ -9150,7 +9154,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		return err;
 
 	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
-		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
+		if (nft_hook_list_find(&flowtable->hook_list, hook, false)) {
 			list_del(&hook->list);
 			nft_netdev_hook_free(hook);
 			continue;
@@ -9163,7 +9167,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 			    !nft_trans_flowtable_update(trans))
 				continue;
 
-			if (nft_hook_list_find(&nft_trans_flowtable_hooks(trans), hook)) {
+			if (nft_hook_list_find(&nft_trans_flowtable_hooks(trans), hook, false)) {
 				err = -EEXIST;
 				goto err_flowtable_update_hook;
 			}
@@ -9383,7 +9387,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 		return err;
 
 	list_for_each_entry(this, &flowtable_hook.list, list) {
-		hook = nft_hook_list_find(&flowtable->hook_list, this);
+		hook = nft_hook_list_find(&flowtable->hook_list, this, true);
 		if (!hook) {
 			err = -ENOENT;
 			goto err_flowtable_del_hook;
-- 
2.55.0

