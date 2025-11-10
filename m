Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9AE1487F6
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 15:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789417; cv=none; b=WUojjv3cFLxr5kKWcK+bnUBi4psL3bhDRtPGV22GdHY4QRpenzOPTCXerx/E+pCw7BAVz6VzEQCICoSKhaCj9F0L8bNgpxDLOCpn2FnBpe//LGfvKoqa0vCF/iiD4q4qzsicHf/4tPRvLxoDyfx+h0wknPnILZqZkO7nmdE9FGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789417; c=relaxed/simple;
	bh=meR83v0Qd/1l0AqixpEFsH8fe4InOi+nuEGXXeCrhGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fc1tSHM6wr1j9FQ7TK5BeoGzusBSVnb4gCXyl8ZWJwO/JTpO7HXW40C/z2Dyx/Pm1Y1KiZNk+4CEzAznzpn4oXFP8kLF8Y7JLKY98txR+SMjq8FhRK/c4NWSuVIE2/f2q7ux0sdfHtI/PS0gLp8Wm41qhKVa8DZOCurGhWFZeDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kBYYSgCX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UdGqMgOo; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kBYYSgCX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UdGqMgOo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kBYYSgCX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UdGqMgOo";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kBYYSgCX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UdGqMgOo"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 614031F397;
	Mon, 10 Nov 2025 15:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762789414; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=USzVRD3n/W5Y13XD3L3aDPXqQZNg9/m0l/1HWD+JDnM=;
	b=kBYYSgCXbvZNr6Jds1gJBDTcToeDlOjj/fTAbaky1EJ4eGKDSPrPKPTJtFOEZjVx2l44eB
	v69W4/tOmUOdvo/BTDtAsiqBnEGKQ6Wc33SrksqZwwy3BUCPf1FntmgfTDYEp++4EYN4qq
	DSSFPYSK1aFiG2weURqJmJe+QTfLsRs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762789414;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=USzVRD3n/W5Y13XD3L3aDPXqQZNg9/m0l/1HWD+JDnM=;
	b=UdGqMgOopOR1jv5AQm3CY+D+z+GEgo4uDYB6CpBHQvPXw9nofAYOv52E0XU9T15WI3qXp6
	HZayShwOuAvdepAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762789414; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=USzVRD3n/W5Y13XD3L3aDPXqQZNg9/m0l/1HWD+JDnM=;
	b=kBYYSgCXbvZNr6Jds1gJBDTcToeDlOjj/fTAbaky1EJ4eGKDSPrPKPTJtFOEZjVx2l44eB
	v69W4/tOmUOdvo/BTDtAsiqBnEGKQ6Wc33SrksqZwwy3BUCPf1FntmgfTDYEp++4EYN4qq
	DSSFPYSK1aFiG2weURqJmJe+QTfLsRs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762789414;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=USzVRD3n/W5Y13XD3L3aDPXqQZNg9/m0l/1HWD+JDnM=;
	b=UdGqMgOopOR1jv5AQm3CY+D+z+GEgo4uDYB6CpBHQvPXw9nofAYOv52E0XU9T15WI3qXp6
	HZayShwOuAvdepAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D2AD214480;
	Mon, 10 Nov 2025 15:43:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IOaRMCUIEmkWWgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 10 Nov 2025 15:43:33 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	aconole@redhat.com,
	echaudro@redhat.com,
	i.maximets@ovn.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 3/4 nf-next v2] netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
Date: Mon, 10 Nov 2025 16:42:48 +0100
Message-ID: <20251110154249.3586-4-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110154249.3586-1-fmancera@suse.de>
References: <20251110154249.3586-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 

For convenience when performing GC over the connection list, make
nf_conncount_gc_list() to disable BH. This unifies the behavior with
nf_conncount_add() and nf_conncount_count().

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: no changes done
---
 net/netfilter/nf_conncount.c  | 24 +++++++++++++++++-------
 net/netfilter/nft_connlimit.c |  7 +------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 803589f4eaa1..cb52fe928a77 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -227,8 +227,8 @@ void nf_conncount_list_init(struct nf_conncount_list *list)
 EXPORT_SYMBOL_GPL(nf_conncount_list_init);
 
 /* Return true if the list is empty. Must be called with BH disabled. */
-bool nf_conncount_gc_list(struct net *net,
-			  struct nf_conncount_list *list)
+static bool __nf_conncount_gc_list(struct net *net,
+				   struct nf_conncount_list *list)
 {
 	const struct nf_conntrack_tuple_hash *found;
 	struct nf_conncount_tuple *conn, *conn_n;
@@ -240,10 +240,6 @@ bool nf_conncount_gc_list(struct net *net,
 	if ((u32)jiffies == READ_ONCE(list->last_gc))
 		return false;
 
-	/* don't bother if other cpu is already doing GC */
-	if (!spin_trylock(&list->list_lock))
-		return false;
-
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
 		found = find_or_evict(net, list, conn);
 		if (IS_ERR(found)) {
@@ -272,7 +268,21 @@ bool nf_conncount_gc_list(struct net *net,
 	if (!list->count)
 		ret = true;
 	list->last_gc = (u32)jiffies;
-	spin_unlock(&list->list_lock);
+
+	return ret;
+};
+
+bool nf_conncount_gc_list(struct net *net,
+			  struct nf_conncount_list *list)
+{
+	bool ret;
+
+	/* don't bother if other cpu is already doing GC */
+	if (!spin_trylock_bh(&list->list_lock))
+		return false;
+
+	ret = __nf_conncount_gc_list(net, list);
+	spin_unlock_bh(&list->list_lock);
 
 	return ret;
 }
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 102c2ed3de41..ecb65da113d6 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -237,13 +237,8 @@ static void nft_connlimit_destroy_clone(const struct nft_ctx *ctx,
 static bool nft_connlimit_gc(struct net *net, const struct nft_expr *expr)
 {
 	struct nft_connlimit *priv = nft_expr_priv(expr);
-	bool ret;
 
-	local_bh_disable();
-	ret = nf_conncount_gc_list(net, priv->list);
-	local_bh_enable();
-
-	return ret;
+	return nf_conncount_gc_list(net, priv->list);
 }
 
 static struct nft_expr_type nft_connlimit_type;
-- 
2.51.0

