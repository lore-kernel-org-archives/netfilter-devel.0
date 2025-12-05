Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24CF25EFAE
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Dec 2025 11:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764935914; cv=none; b=IwNHZLxUSXrKkt0LrICZ4qzIcauay0s0NglcwU5V5c7SVw5XRoZ72wGsciR1vzE5rmJxF7wWDpG0LgAJoDwStblRoPEIJ+1PeRZUACbLY90IU84SB6U0TlL6XJVvfg9nslpgzSo+/2SZzhDVNAXu3oGjN9wbs+QKnM8HGr8HMps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764935914; c=relaxed/simple;
	bh=6VTmnCcq5mqAOSv8YQuG8Cx5lWJH8Ppb99niipYjKFg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mo/gRawpJbP4wa3NGG4EXpmcsRR8lSQ8gPn7lz6DD+vKlgo9FroyGihGCldi3vczzueVM9Um27QNbUhkZivI7pT+eH4k16mwM3LxGeZEV0j+k2tshx+eiVwIxeO8yVGhofeCcwHul9ft0QsMSxmCyjZpv1NvwNDb3QkxkXr7mPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1l1bJMtt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4k0LLH2y; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1l1bJMtt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4k0LLH2y; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1l1bJMtt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4k0LLH2y";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1l1bJMtt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4k0LLH2y"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5A67A336E7;
	Fri,  5 Dec 2025 11:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764935908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GqMRlo7rulLiVfgXrDu2gUnnQY4uTmI0JL2titqYC+A=;
	b=1l1bJMtt3Z9yUhK29Wd+cQ8e/aoo5PPB2UMwChmHGupLKxPB6dGTWILtuQ/mJk2od+DGff
	XwaHRnMQ+FItzNmxWSN3I4vyz8J0ysmXVGDOWxFKgMfmPbik1zAKOkIDyhOt3Dijl3zQs5
	MxQErpvxo0OA6Jifz1jdxAhp4DJ4dsg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764935908;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GqMRlo7rulLiVfgXrDu2gUnnQY4uTmI0JL2titqYC+A=;
	b=4k0LLH2yP0v2BAn8EcCC4AnQwrrLMQK2IizD1MhCXHfNf4QGDNcuZx9Gyh0mcsvrhIz3Ng
	AiAHeDytOzqdSzAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764935908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GqMRlo7rulLiVfgXrDu2gUnnQY4uTmI0JL2titqYC+A=;
	b=1l1bJMtt3Z9yUhK29Wd+cQ8e/aoo5PPB2UMwChmHGupLKxPB6dGTWILtuQ/mJk2od+DGff
	XwaHRnMQ+FItzNmxWSN3I4vyz8J0ysmXVGDOWxFKgMfmPbik1zAKOkIDyhOt3Dijl3zQs5
	MxQErpvxo0OA6Jifz1jdxAhp4DJ4dsg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764935908;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GqMRlo7rulLiVfgXrDu2gUnnQY4uTmI0JL2titqYC+A=;
	b=4k0LLH2yP0v2BAn8EcCC4AnQwrrLMQK2IizD1MhCXHfNf4QGDNcuZx9Gyh0mcsvrhIz3Ng
	AiAHeDytOzqdSzAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 187C43EA63;
	Fri,  5 Dec 2025 11:58:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mJzwAuTIMmmhegAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 05 Dec 2025 11:58:28 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf v2] netfilter: nf_conncount: fix leaked ct in error paths
Date: Fri,  5 Dec 2025 12:58:01 +0100
Message-ID: <20251205115801.5818-1-fmancera@suse.de>
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
	NEURAL_HAM_SHORT(-0.20)[-0.983];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -2.80

There are some situations where ct might be leaked as error paths are
skipping the refcounted check and return immediately. In order to solve
it make sure that the check is always called.

Fixes: be102eb6a0e7 ("netfilter: nf_conncount: rework API to use sk_buff directly")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: deferred nf_ct_put() on __nf_conncount_add until we don't needed
anymore.
---
 net/netfilter/nf_conncount.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index f1be4dd5cf85..3654f1e8976c 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -172,14 +172,14 @@ static int __nf_conncount_add(struct net *net,
 	struct nf_conn *found_ct;
 	unsigned int collect = 0;
 	bool refcounted = false;
+	int err = 0;
 
 	if (!get_ct_or_tuple_from_skb(net, skb, l3num, &ct, &tuple, &zone, &refcounted))
 		return -ENOENT;
 
 	if (ct && nf_ct_is_confirmed(ct)) {
-		if (refcounted)
-			nf_ct_put(ct);
-		return -EEXIST;
+		err = -EEXIST;
+		goto out_put;
 	}
 
 	if ((u32)jiffies == list->last_gc)
@@ -231,12 +231,16 @@ static int __nf_conncount_add(struct net *net,
 	}
 
 add_new_node:
-	if (WARN_ON_ONCE(list->count > INT_MAX))
-		return -EOVERFLOW;
+	if (WARN_ON_ONCE(list->count > INT_MAX)) {
+		err = -EOVERFLOW;
+		goto out_put;
+	}
 
 	conn = kmem_cache_alloc(conncount_conn_cachep, GFP_ATOMIC);
-	if (conn == NULL)
-		return -ENOMEM;
+	if (conn == NULL) {
+		err = -ENOMEM;
+		goto out_put;
+	}
 
 	conn->tuple = tuple;
 	conn->zone = *zone;
@@ -249,7 +253,7 @@ static int __nf_conncount_add(struct net *net,
 out_put:
 	if (refcounted)
 		nf_ct_put(ct);
-	return 0;
+	return err;
 }
 
 int nf_conncount_add_skb(struct net *net,
@@ -456,11 +460,10 @@ insert_tree(struct net *net,
 
 		rb_link_node_rcu(&rbconn->node, parent, rbnode);
 		rb_insert_color(&rbconn->node, root);
-
-		if (refcounted)
-			nf_ct_put(ct);
 	}
 out_unlock:
+	if (refcounted)
+		nf_ct_put(ct);
 	spin_unlock_bh(&nf_conncount_locks[hash]);
 	return count;
 }
-- 
2.51.1

