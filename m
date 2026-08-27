Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7CC3DCD80
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2026 10:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787826805; cv=none; b=hyuqZt2mpfUiPjqs86Shq9FosbknuHoMLMb3SDh2E17mhW6RUDWYtb+GXFE8BU21nX7FSVnVaf34odMAeQP4ZhVD8VAYJY7Ek2QaNmk9fwR5eFA4MwfZoDphadtJ8ajPUbhWx9SnHEyrVnxfzUIcMIQFfjhALVzaQ9pGYzM5VDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787826805; c=relaxed/simple;
	bh=qB4WwXHJCup9XUhm2LuCdfYf9EaIWWe7j+6FmFrzONM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HuIWL/fe5RlEI6O5kCzDbUxsmi+MJJceKSK3Dkq/XkCB/n9Lp93naqDCd2cnr0KmJX89YElgdlLBHbmpUFCmBfZB0H2QpORTqOem3jSl8RHe8D5LJCSNct+Qs6/4RNGJJ06U09lGt6BPpwVzC2r5hMNsXi36uS8i79mIuTKk54w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mJZlInQj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gDAWXGPu; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DAmaqy8M; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FFdi2IX+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mJZlInQj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gDAWXGPu";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DAmaqy8M";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FFdi2IX+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4FDA71F841;
	Thu, 27 Aug 2026 10:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787826788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=E604Md/sWXtLZxEs29lr/DiOoC4LpZLobMTFlXYj6lU=;
	b=mJZlInQjEO0P1buej+Il294FFHSxBs25g4SzqvwIVjdS5zfmh5DNE5sTBdj1II8ZnzMNCl
	sskdgTbrtKa+X8mdv9JICL5iFhxrIIABbsrqrhpSuEV/8TUcl8pDDaA8TLxdThTSMrDOq5
	3s3q9KssPdWZwJ7tO7xvGF5JA/JOYTQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787826788;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=E604Md/sWXtLZxEs29lr/DiOoC4LpZLobMTFlXYj6lU=;
	b=gDAWXGPuhVE2TGHYjWvm4LpwQJGiVR54B3rrN0ZLlysk3qil3xoUtX4ai+/CghVM+nS3zP
	V2l8Z8OB2FtwJCDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DAmaqy8M;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FFdi2IX+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787826784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=E604Md/sWXtLZxEs29lr/DiOoC4LpZLobMTFlXYj6lU=;
	b=DAmaqy8MZukWiUXZUmzjZVyrMhXtjr00FW5goDmohynsKIYxyKTN6ZePZJAV09AVbzvK7m
	YhYsQQjdlSIouwaY9UaXZhBb81eO4LusMJzRRP5w/MIOwCYFRyWrDTKrD/IHJQPcPaaUo2
	aTG5e/sh/j4TIbebxQxNPpbkxoSOzh0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787826784;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=E604Md/sWXtLZxEs29lr/DiOoC4LpZLobMTFlXYj6lU=;
	b=FFdi2IX+hm1+g20e8tRat5fNuPkco364QiPCpaZOcPvDlmSCKLRgzzPm7K9L15NWyhA2aU
	veGyL/qw28xbNmAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D371D13354;
	Thu, 27 Aug 2026 10:33:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Vj5oMF8SkGqfOQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 27 Aug 2026 10:33:03 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Wei Fang <void0red@gmail.com>
Subject: [PATCH nf v4] netfilter: nf_tables: fix device name and prefix match in hook lookup
Date: Thu, 27 Aug 2026 12:32:56 +0200
Message-ID: <20260827103256.19096-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 4FDA71F841
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[netfilter.org,strlen.de,nwl.cc,suse.de,gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

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
Note: the inconsistency between hook and flowtables detection for
duplicate/overlapping devices will be handled in a separated patch in
nf-next
---
 net/netfilter/nf_tables_api.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c112ecc4fca3..77c96b1d4217 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
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

