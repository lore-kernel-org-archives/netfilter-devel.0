Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CB629D289
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Nov 2025 16:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764002245; cv=none; b=Ly4pez7gFOJNktITTCkSxsYKn9x0M9iYPAlgVogN0FsMhg9a8kON3B1hs/pw9Hd0erRQ8c6Womya+jCn3U24UXsc9nHAw7fB4/7Dwzseqju1zJ3DgI6va8IOzIdeudQXaHrc/4vUcVvjJr+qh8OgKtZGltunF+Q0ExUWxXHHHX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764002245; c=relaxed/simple;
	bh=mPkLJ1vUXZvCh53B0J5fuJphnmGdjrW3qEMrXQeBPQk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iTj6+KdkBQLNBxX3VPzEKXgeCz0DDi2RUlJ0hVZd8Fdf7Rm0bJCS73q435+IfIYoq3Pa64En5JA4eIz5O5q6HZlII0rQy0KTzmfxxGtvpDQ1qMmLSEEAjemiQSWiGJa11MRe/p+5ZGvP8+JIpTZewdhVFzmi6+nsjPs2zzxv9tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Yua8fasQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MAloqvKb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Yua8fasQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MAloqvKb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Yua8fasQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MAloqvKb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Yua8fasQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MAloqvKb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1A828221DB;
	Mon, 24 Nov 2025 16:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764002241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uFKghpvLUEuOp8sJmrDVTf13HBr5e1Wf6PG08ozLCrU=;
	b=Yua8fasQKjZQttxXzn+b4GKd5awiGdCCeJSQpM45ifHxlo02V9U8/K4iO7DhzM9QVyTwU5
	Mt0vSeq/r8Q5Got9wxyYbKWYqFVyzYbk4UlBb0DKm77YRotm/1n3sUydi+c5BlK8bNUVmj
	kxNP56BeAIlgycoF1bRU4I244ld8CvY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764002241;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uFKghpvLUEuOp8sJmrDVTf13HBr5e1Wf6PG08ozLCrU=;
	b=MAloqvKb6YAiriO8HHDBORmOs6Kto40TymnOHBYCKsEzB3ecdk1SQArZvIvhJ1t+s6mGPk
	6DDRTY/wdNTZ9cDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Yua8fasQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MAloqvKb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764002241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uFKghpvLUEuOp8sJmrDVTf13HBr5e1Wf6PG08ozLCrU=;
	b=Yua8fasQKjZQttxXzn+b4GKd5awiGdCCeJSQpM45ifHxlo02V9U8/K4iO7DhzM9QVyTwU5
	Mt0vSeq/r8Q5Got9wxyYbKWYqFVyzYbk4UlBb0DKm77YRotm/1n3sUydi+c5BlK8bNUVmj
	kxNP56BeAIlgycoF1bRU4I244ld8CvY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764002241;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uFKghpvLUEuOp8sJmrDVTf13HBr5e1Wf6PG08ozLCrU=;
	b=MAloqvKb6YAiriO8HHDBORmOs6Kto40TymnOHBYCKsEzB3ecdk1SQArZvIvhJ1t+s6mGPk
	6DDRTY/wdNTZ9cDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC92F3EA63;
	Mon, 24 Nov 2025 16:37:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TwPoLsCJJGnLDQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 24 Nov 2025 16:37:20 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next v2] netfilter: nft_connlimit: add support to object update operation
Date: Mon, 24 Nov 2025 17:36:58 +0100
Message-ID: <20251124163658.8001-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1A828221DB
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

This is useful to update the limit or flags without clearing the
connections tracked. Use READ_ONCE() on packetpath as it can be modified
on controlplane.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: rebased in top of nf-next branch, use READ_ONCE() annotation as
discussed with Pablo offlist.
---
 net/netfilter/nft_connlimit.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 714a59485935..4a7aef1674bc 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -44,7 +44,7 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 
 	count = READ_ONCE(priv->list->count);
 
-	if ((count > priv->limit) ^ priv->invert) {
+	if ((count > READ_ONCE(priv->limit)) ^ READ_ONCE(priv->invert)) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
@@ -131,6 +131,16 @@ static int nft_connlimit_obj_init(const struct nft_ctx *ctx,
 	return nft_connlimit_do_init(ctx, tb, priv);
 }
 
+static void nft_connlimit_obj_update(struct nft_object *obj,
+				     struct nft_object *newobj)
+{
+	struct nft_connlimit *newpriv = nft_obj_data(newobj);
+	struct nft_connlimit *priv = nft_obj_data(obj);
+
+	priv->limit = newpriv->limit;
+	priv->invert = newpriv->invert;
+}
+
 static void nft_connlimit_obj_destroy(const struct nft_ctx *ctx,
 				      struct nft_object *obj)
 {
@@ -160,6 +170,7 @@ static const struct nft_object_ops nft_connlimit_obj_ops = {
 	.init		= nft_connlimit_obj_init,
 	.destroy	= nft_connlimit_obj_destroy,
 	.dump		= nft_connlimit_obj_dump,
+	.update		= nft_connlimit_obj_update,
 };
 
 static struct nft_object_type nft_connlimit_obj_type __read_mostly = {
-- 
2.51.1

