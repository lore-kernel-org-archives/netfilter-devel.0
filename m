Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C2D3D6472
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 10:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787048351; cv=none; b=CyHA9en55sHMCoF9pWbBGklir9T6ndCM/6AeCnp1T63xNYBL2n2uXACMfUKdK/ZNyUKQdeygN8BygcaIdIy0jU7S8sNRiYFZVJ95+Ek6duID47vPRP+NJk0CmvY1g6Zx4qBP5bopq0X32pM6K+hMpbxsoQKncMsr1PdiNpQlazI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787048351; c=relaxed/simple;
	bh=kN7KPYQ9GFNAPh+ujItxvk/zgrzJoNW8swO6gJxvAJc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mBFmr26BPXWasQSCaGy94MrRyF2bFdY9YmEPMnY03tz884iRp3x+Y/g7v9aRf581wcNM+5ZisG9vrwAQHyoVLQ1IB5U5X/uQMy3wCl3dfj628lADisirxHSay7Wd9FI+dI68odurmENKUWmvynPj9ZEJh0pYx0AHFKe/8aWLNa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pdxrJX7B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/tlg9R6C; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wePz4UY+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3sT38L3M; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pdxrJX7B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/tlg9R6C";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wePz4UY+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3sT38L3M"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B8E0F3E26;
	Tue, 18 Aug 2026 10:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787048343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mkaotQsSHJ7Tqy8h96Gc4y8EBlUeCHepdDUL2f5/g+4=;
	b=pdxrJX7BxkJ8ndOdsOI53DzV5wZj6RgFIAUaX6KYNz7QV2IEajKsZhX3TQzoD4uzXXSCP7
	+V6bMETyFfozExcqRVH1x9AenEbZDjw1+wG9++Da4PVC8VcAjfkALa54nCjV6/sCGbuIc9
	yHS2AExgKe9MMqfY2sx1iDV5gfuKrn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787048343;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mkaotQsSHJ7Tqy8h96Gc4y8EBlUeCHepdDUL2f5/g+4=;
	b=/tlg9R6C2J7UoDcAbVXCrt/rwVRd8onkGcDUHWblsMLuUpdHUNq8QnkUhsZnhThGvdLlyg
	RbXG6SdtsIRv0jDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787048339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mkaotQsSHJ7Tqy8h96Gc4y8EBlUeCHepdDUL2f5/g+4=;
	b=wePz4UY+enUgjEJXYuTHjyuurgMA7W6Umn9He1kii2HV61QHLy8MNgYn2y9Gk8rGBEMUvq
	qS3Z/kQfYPygyqenN44p8HthEv5EUARrT3RWFdTslKYyLNbZH9GtOf/+yRfx8tmEFGE3Y7
	8+bz2BhdX9dIyG0SVhKuTG/lkn3cALA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787048339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mkaotQsSHJ7Tqy8h96Gc4y8EBlUeCHepdDUL2f5/g+4=;
	b=3sT38L3M+7qL0p0NB30p19m+6XI7kwHn9agREWut3uVNZfAxc6N4+KkrF+bLOCRP+C0S6f
	jAIkKjT+LhLjAyBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B7AE22BA;
	Tue, 18 Aug 2026 10:18:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qYSbD5MxhGpNDAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 18 Aug 2026 10:18:59 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Wei Fang <void0red@gmail.com>
Subject: [PATCH nf] netfilter: nf_tables: fix device name and prefix match in hook lookup
Date: Tue, 18 Aug 2026 12:18:25 +0200
Message-ID: <20260818101825.8213-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.19)[-0.966];
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
X-Spam-Score: -2.79
X-Spam-Level: 

Currently, a netdev chain or flowtable hooked to a device prefix can be
unintentionally deleted or updated by a control-plane request targeting
an exact device name or even a shorter one due to the usage of min() to
calculate the length to match.

Fix this by making sure an exact device match never matches a prefix and
that both the target and the candidate have the same length.

Reported-by: Wei Fang <void0red@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/
Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_tables_api.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index af357f6c5070..e2b18c4722fc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1973,7 +1973,7 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 	return -ENOSPC;
 }
 
-static bool hook_is_prefix(struct nft_hook *hook)
+static bool hook_is_prefix(const struct nft_hook *hook)
 {
 	return strlen(hook->ifname) >= hook->ifnamelen;
 }
@@ -2440,8 +2440,11 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, hook_list, list) {
-		if (!strncmp(hook->ifname, this->ifname,
-			     min(hook->ifnamelen, this->ifnamelen))) {
+		if (hook_is_prefix(hook) != hook_is_prefix(this))
+			continue;
+		if (hook->ifnamelen != this->ifnamelen)
+			continue;
+		if (!strncmp(hook->ifname, this->ifname, hook->ifnamelen)) {
 			if (hook->flags & NFT_HOOK_REMOVE)
 				continue;
 
-- 
2.55.0

