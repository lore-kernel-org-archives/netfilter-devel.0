Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7274739AD32
	for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2026 12:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778674568; cv=none; b=qdLZUsbtHHVIW+AyyJBM+8Tuz+E7S7zR8/3bafMSKWZF2Rxrjs4hGgSL4TI/l9mnHOHJMKFRL2yJpiSRRq4c/cto9uWbWOko/Ipp/HqePm9NZOgxEd6fy3zKd+PG6X0x7BPaqHCzi5Np7kCZFECLgh43QzOp0HxJ5kaa9vGPqsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778674568; c=relaxed/simple;
	bh=k9rGKoNO3mVcagU/350JFQphQbvCbqMoVhffwcXIBBc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MMzUjlmfGyqYABVy4uWDKE4V36eN49y5pDw3w4QPrPnCbfymJB0yMPhydNLn0MQbk3b0wR4vIfT/9iygyDMKNmSdx0pKI/wTY/fXgAg/a2eWl9aR9tejtt/mfFgR89UL4pi9ZiXoiWbXDXVTocVpZxeD3x3mKUIZk/Yhr1Gj2WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xttFlP6a; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YqDohOte; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=v0CIiL5E; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IDXOGlcO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xttFlP6a";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YqDohOte";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="v0CIiL5E";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IDXOGlcO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B68DA5D2A8;
	Wed, 13 May 2026 12:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778674564; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=DkzwQ3Ybw17MLzGliWCeLtzqBCiFuSeYlrx7rDVtx1I=;
	b=xttFlP6afuBxQiR+TMBLbfPmZ6G6X/yTYe+UeVNxKDbHe7w4yU2lcY+DilCb66F2MQkkzv
	c7K3iYL8MRKsUdfxrLdID/HK+Nucf6S7oArUimUYrzDZvgg/S+GvKdHFrgFU1rAasssOTH
	CgDj/VOy4q9HrJ8hpymKiHy4a/xeP10=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778674564;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=DkzwQ3Ybw17MLzGliWCeLtzqBCiFuSeYlrx7rDVtx1I=;
	b=YqDohOtekkdVp18o6iy9z5WO5dot7Phgjknb8GI1U2qSLG2X79zuj9OUuDdILymZbzqUsC
	2gw46cYQbhlQHsAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v0CIiL5E;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IDXOGlcO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778674563; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=DkzwQ3Ybw17MLzGliWCeLtzqBCiFuSeYlrx7rDVtx1I=;
	b=v0CIiL5EqfPoH2FLvsY3f/vD9yJbsClEK6tXCjs4DrtPWzaFDMVAz8K0sS5PNobf1EeP1i
	lR3ud6+Ca4ry4c1jypugQcIrFYDDUxVEPOK7Y4cXxuArAMBDn4IxRxDu8sKYULOzYh56q7
	xO3gniEAim2OwULVjK0iWmH0t/mOyNM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778674563;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=DkzwQ3Ybw17MLzGliWCeLtzqBCiFuSeYlrx7rDVtx1I=;
	b=IDXOGlcOTRllgG/TqCwyRWPI0qwmmywq8zLYnj0RNQYWwT9KuPbt0kPX0L4z4xeGrxMTfG
	Rzqnd7tqzwm/m4Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C01F593A9;
	Wed, 13 May 2026 12:16:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d++wD4NrBGo0FQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 13 May 2026 12:16:03 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>
Subject: [PATCH nf] netfilter: nf_conncount: prevent connlimit drops for early confirmed ct
Date: Wed, 13 May 2026 14:15:47 +0200
Message-ID: <20260513121547.6434-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_CC(0.00)[netfilter.org,nwl.cc,strlen.de,suse.de,gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B68DA5D2A8
X-Spam-Level: 

Commit 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add
was skipped") introduced a regression where packets for valid
connections are dropped when using connlimit for soft-limiting
scenarios.

The issue occurs when a new connection reuses a socket currently in
the TIME_WAIT state. In this scenario, the connection tracking entry
is evaluated as already confirmed. Previously, __nf_conncount_add()
assumed that if a connection was confirmed and did not originate from
the loopback interface, it should skip the addition and return -EEXIST.

Skipping the addition triggers a garbage collection run that cleans up
the TIME_WAIT connection. Consequently, the active connection count
drops to 0, which xt_connlimit mishandles, leading to the false rejection
of the perfectly valid new connection.

Fix this by replacing the interface check with protocol-agnostic state
checks. We now skip the tree insertion and preserve the lockless garbage
collection optimization only if the connection is IPS_ASSURED or
IP_CT_ESTABLISHED. This allows early-confirmed setup packets (such as
reused TIME_WAIT sockets or locally generated SYN-ACKs) to be properly
evaluated and counted without falsely dropping. The goto
check_connections path is maintained to ensure these setup packets are
deduplicated correctly.

This has been tested with slowhttptest and HTTP server configured
locally to ensure we are not breaking soft-limiting scenarios for local
or external connections. In addition, it was tested with a OVS zone
limit too.

Fixes: 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add was skipped")
Reported-by: Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/177349610461.3071718.4083978280323144323@eldamar.lan/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_conncount.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 00eed5b4d1b1..bf718d26acda 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -129,13 +129,13 @@ static bool get_ct_or_tuple_from_skb(struct net *net,
 				     struct nf_conn **ct,
 				     struct nf_conntrack_tuple *tuple,
 				     const struct nf_conntrack_zone **zone,
+				     enum ip_conntrack_info *ctinfo,
 				     bool *refcounted)
 {
 	const struct nf_conntrack_tuple_hash *h;
-	enum ip_conntrack_info ctinfo;
 	struct nf_conn *found_ct;
 
-	found_ct = nf_ct_get(skb, &ctinfo);
+	found_ct = nf_ct_get(skb, ctinfo);
 	if (found_ct && !nf_ct_is_template(found_ct)) {
 		*tuple = found_ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
 		*zone = nf_ct_zone(found_ct);
@@ -169,27 +169,22 @@ static int __nf_conncount_add(struct net *net,
 	const struct nf_conntrack_tuple_hash *found;
 	struct nf_conncount_tuple *conn, *conn_n;
 	struct nf_conntrack_tuple tuple;
+	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = NULL;
 	struct nf_conn *found_ct;
 	unsigned int collect = 0;
 	bool refcounted = false;
 	int err = 0;
 
-	if (!get_ct_or_tuple_from_skb(net, skb, l3num, &ct, &tuple, &zone, &refcounted))
+	if (!get_ct_or_tuple_from_skb(net, skb, l3num, &ct, &tuple, &zone, &ctinfo, &refcounted))
 		return -ENOENT;
 
 	if (ct && nf_ct_is_confirmed(ct)) {
-		/* local connections are confirmed in postrouting so confirmation
-		 * might have happened before hitting connlimit
-		 */
-		if (skb->skb_iif != LOOPBACK_IFINDEX) {
+		if (test_bit(IPS_ASSURED_BIT, &ct->status) || ctinfo == IP_CT_ESTABLISHED) {
 			err = -EEXIST;
 			goto out_put;
 		}
 
-		/* this is likely a local connection, skip optimization to avoid
-		 * adding duplicates from a 'packet train'
-		 */
 		goto check_connections;
 	}
 
@@ -408,6 +403,7 @@ insert_tree(struct net *net,
 	struct nf_conntrack_tuple tuple;
 	struct nf_conncount_tuple *conn;
 	struct nf_conncount_rb *rbconn;
+	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = NULL;
 
 	spin_lock_bh(&nf_conncount_locks[hash]);
@@ -451,7 +447,7 @@ insert_tree(struct net *net,
 		goto restart;
 	}
 
-	if (get_ct_or_tuple_from_skb(net, skb, l3num, &ct, &tuple, &zone, &refcounted)) {
+	if (get_ct_or_tuple_from_skb(net, skb, l3num, &ct, &tuple, &zone, &ctinfo, &refcounted)) {
 		/* expected case: match, insert new node */
 		rbconn = kmem_cache_alloc(conncount_rb_cachep, GFP_ATOMIC);
 		if (rbconn == NULL)
-- 
2.53.0

