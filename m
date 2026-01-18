Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991E814D29B
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Jan 2026 11:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768734840; cv=none; b=kDOqObM8KsrIR3qtF8kl1pGs6ItJSGDsnGgAqOx0zF2r6aaNyAmcZikvBnvufGVi39I1vRTrYQXkSE7NkG822xbNx0sAyprIqewyN4B5vqlVBAf2a6eVBx47smxOSEwoLviy63Ebz2oMeXNK4OBUdNnEWShBpBptkYGZbZh0VOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768734840; c=relaxed/simple;
	bh=27yUj8qpm/RRASgIpelFmXToRKO2L4Yf7SNz0e6ESTY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QnXLuUuvxNvts3CEJDbCify95Ng6/xElm9rSNSl9tt+7ZZv+NfrlYCR96ee2tnPnabp6xyJzhy5pWHZjqb/mGWVXzciCQsdXIM6Eg1/P7MlSG/uiXllYl6njH44mkIm62wtAll9dxEv017KMeSuQfZXGRCumWeevuE+07JfvcQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nlfLU7p6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AOe+8aE1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nlfLU7p6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AOe+8aE1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nlfLU7p6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AOe+8aE1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nlfLU7p6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AOe+8aE1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A88E55BCEB;
	Sun, 18 Jan 2026 11:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768734836; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Vfzm0XPOHjOtIfM4pMDw8DhDcak8AnJpmIQCGJeM74Y=;
	b=nlfLU7p60/C9J5ZiW8+8aSHYGp1yVviYrfCWHY8NNyUKDspEQJUgzL6TRT4EEmZ8lCvF6U
	IqbuazTKfAm7e1P+081eb1/kSjbjOF9yfcAG7oHJG+iRXInLC2UE2DiHWXEedxST0ak4QS
	XLqZwgMbxBKgFvY+y67UkV2WRlXzaMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768734836;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Vfzm0XPOHjOtIfM4pMDw8DhDcak8AnJpmIQCGJeM74Y=;
	b=AOe+8aE1ItpLqalxBFnYzMZAn0Jd9WLk990lgwSctXSf4Xj62XH74DYc0jWYl93TyUnsLp
	VsMuUOeicWWY5oCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768734836; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Vfzm0XPOHjOtIfM4pMDw8DhDcak8AnJpmIQCGJeM74Y=;
	b=nlfLU7p60/C9J5ZiW8+8aSHYGp1yVviYrfCWHY8NNyUKDspEQJUgzL6TRT4EEmZ8lCvF6U
	IqbuazTKfAm7e1P+081eb1/kSjbjOF9yfcAG7oHJG+iRXInLC2UE2DiHWXEedxST0ak4QS
	XLqZwgMbxBKgFvY+y67UkV2WRlXzaMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768734836;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Vfzm0XPOHjOtIfM4pMDw8DhDcak8AnJpmIQCGJeM74Y=;
	b=AOe+8aE1ItpLqalxBFnYzMZAn0Jd9WLk990lgwSctXSf4Xj62XH74DYc0jWYl93TyUnsLp
	VsMuUOeicWWY5oCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C6F93EA63;
	Sun, 18 Jan 2026 11:13:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ankCDHTAbGlTLgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sun, 18 Jan 2026 11:13:56 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Michal Slabihoudek <michal.slabihoudek@gooddata.com>
Subject: [PATCH nf-next] netfilter: nf_conncount: fix tracking of connections from localhost
Date: Sun, 18 Jan 2026 12:13:16 +0100
Message-ID: <20260118111316.4643-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

Since commit be102eb6a0e7 ("netfilter: nf_conncount: rework API to use
sk_buff directly"), we skip the adding and trigger a GC when the ct is
confirmed. For connections originated from local to local it doesn't
work because the connection is confirmed from a early stage, therefore
tracking is always skipped.

In order to fix this, we check whether IPS_SEEN_REPLY_BIT is set to
understand if it is really confirmed. If it isn't then we fallback on a
GC plus track operation skipping the optimization. This fallback is
necessary to avoid duplicated tracking of a packet train e.g 10 UDP
datagrams sent on a burst when initiating the connection.

Tested with xt_connlimit/nft_connlimit and OVS limit and with a HTTP
server and iperf3 on UDP mode.

Fixes: be102eb6a0e7 ("netfilter: nf_conncount: rework API to use sk_buff directly")
Reported-by: Michal Slabihoudek <michal.slabihoudek@gooddata.com>
Closes: https://lore.kernel.org/netfilter/6989BD9F-8C24-4397-9AD7-4613B28BF0DB@gooddata.com/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
Note: rebased in top of nf-next/testing tree
 net/netfilter/nf_conncount.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 288936f5c1bf..5588cd0fcd9a 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -179,14 +179,25 @@ static int __nf_conncount_add(struct net *net,
 		return -ENOENT;
 
 	if (ct && nf_ct_is_confirmed(ct)) {
-		err = -EEXIST;
-		goto out_put;
+		/* connections from localhost are confirmed almost instantly,
+		 * check if there has been a reply
+		 */
+		if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+			err = -EEXIST;
+			goto out_put;
+		}
+
+		/* this is likely a local connection, skip optimization to avoid
+		 * adding duplicates from a 'packet train'
+		 */
+		goto check_connections;
 	}
 
 	if ((u32)jiffies == list->last_gc &&
 	    (list->count - list->last_gc_count) < CONNCOUNT_GC_MAX_COLLECT)
 		goto add_new_node;
 
+check_connections:
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
 		if (collect > CONNCOUNT_GC_MAX_COLLECT)
-- 
2.52.0

