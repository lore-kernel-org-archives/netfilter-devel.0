Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5165F30E821
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 09:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787563714; cv=none; b=IGbFDReUcyuvVoa8wZ0i/9s5Z/OISMiDDCtseFoXFkf/97EGHwxgsOgfQEnA1kxuynN/h9yCaTX/+Mi+4tTfrCx584r3n1nn7I89VDvdfWSE0pwZUQLbtJywhBsuNmzrfBssbOpYH1Zwys22+Kx9A4+pFEuhmWBGlUMHBKB1EAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787563714; c=relaxed/simple;
	bh=3ryfcmwwVhQjb4DFMpe2ryTChSGN2DZ+yVDU4XYuKh4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NOmuH8m9Y3ZzHvTpDURQdDygazFEGKWpFpbpeC3WpqF8jojFdf4rxY/mH/uIZ6ryPoZQxaLB5X/12M+n8UBGWCGSAuojdipysRFVnfqHd7gTAO6xL3ojKiSe8Y47uoP49G0Z1XjG4PaTXy0EXU7I3pVXcavpPuQRbovskOMdgLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZZ4K0sVi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=n8yOF1EX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Le5K69z1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=s7b66dpX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZZ4K0sVi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="n8yOF1EX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Le5K69z1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="s7b66dpX"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6D3D186730;
	Mon, 24 Aug 2026 09:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787563700; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=m8iyOUi5M3YBZQBfrKiGjJh8x1FFCAkdZudipAfZeiU=;
	b=ZZ4K0sVitTOvYbYSu1bkOlJf72QjbVLjTFzpW070Ju+zz8ixkSm95unzD6nNlDMo+RIet4
	SyHfUlqy1vZ5EDguyk5IXvQaP/rqpfGA05SGoT6NQshXFw9anIEYN+REb2GG7lF0TYmLI0
	x0NogTGvbYZxfP5TqTPBJI/6akURHOo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787563700;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=m8iyOUi5M3YBZQBfrKiGjJh8x1FFCAkdZudipAfZeiU=;
	b=n8yOF1EXJ7ulQOS4vnCYG90JJy0hXNQ5uYZ51W7bjvAXiDaDtKeaQY39KFfG23D0pyWSHv
	1YD+j5gq1f4LMOAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787563696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=m8iyOUi5M3YBZQBfrKiGjJh8x1FFCAkdZudipAfZeiU=;
	b=Le5K69z1j12qmtqnIEeRwwlo4gmxvErE3GczEB92BuTSUnEuBnOCnKsr6OYY+dQB7apqmB
	PEE9gCCE3MyN26wi/Ook1b1hHy4MsN+0TSuBEFSGPucly5ZCj2+D3/2PNHJq0/bG0BFIkQ
	+whNlBwXEYEp/272bGqEvYoS3ttzlis=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787563696;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=m8iyOUi5M3YBZQBfrKiGjJh8x1FFCAkdZudipAfZeiU=;
	b=s7b66dpX6wwBjPqtNdjQ7XyoMpbqLxADQGol7IauJn9iet0JcQKfd3I6HsBR7mwevg5c0J
	aJbXU+XJCpWPPNCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 01CC913335;
	Mon, 24 Aug 2026 09:28:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HPs9Oa8OjGpSZwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 24 Aug 2026 09:28:15 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Wei Fang <void0red@gmail.com>
Subject: [PATCH nf v2] netfilter: nf_tables: fix device name and prefix match in hook lookup
Date: Mon, 24 Aug 2026 11:28:05 +0200
Message-ID: <20260824092805.4940-1-fmancera@suse.de>
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
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
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
 net/netfilter/nf_tables_api.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c112ecc4fca3..3ad9a5e88c5b 100644
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
@@ -2457,6 +2457,27 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 	return NULL;
 }
 
+static struct nft_hook *nft_hook_list_find_strict(struct list_head *hook_list,
+						  const struct nft_hook *this)
+{
+	struct nft_hook *hook;
+
+	list_for_each_entry(hook, hook_list, list) {
+		if (hook_is_prefix(hook) != hook_is_prefix(this))
+			continue;
+		if (hook->ifnamelen != this->ifnamelen)
+			continue;
+		if (!strncmp(hook->ifname, this->ifname, hook->ifnamelen)) {
+			if (hook->flags & NFT_HOOK_REMOVE)
+				continue;
+
+			return hook;
+		}
+	}
+
+	return NULL;
+}
+
 static int nf_tables_parse_netdev_hooks(struct net *net,
 					const struct nlattr *attr,
 					struct list_head *hook_list,
@@ -3257,7 +3278,7 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 		return err;
 
 	list_for_each_entry(this, &chain_hook.list, list) {
-		hook = nft_hook_list_find(&basechain->hook_list, this);
+		hook = nft_hook_list_find_strict(&basechain->hook_list, this);
 		if (!hook) {
 			err = -ENOENT;
 			goto err_chain_del_hook;
@@ -9383,7 +9404,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 		return err;
 
 	list_for_each_entry(this, &flowtable_hook.list, list) {
-		hook = nft_hook_list_find(&flowtable->hook_list, this);
+		hook = nft_hook_list_find_strict(&flowtable->hook_list, this);
 		if (!hook) {
 			err = -ENOENT;
 			goto err_flowtable_del_hook;
-- 
2.55.0

