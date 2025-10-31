Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117A132AACC
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Oct 2025 13:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761916149; cv=none; b=RRoLv1Cuo+RSOjsf3L/hFbxckmLUK6XyTjXoBM0k5ggvqeX0HMaqZokh7tk+fLYwemxMKysaxi79PHy+PpZGFV80IKNEcAeofvwu6jlI/FOt/ZY6tCRq7F5e/3sO4/WeqGXEUwxErm2wH5a4vFer8vxA5Ax+w1/gauAQ8N6AlyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761916149; c=relaxed/simple;
	bh=jkymoXiD7iUcChqXO8mi3WoDCeTBHgddTLi2xGOIKAI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V2wNQGHJsPx+y5l/wPSF5CKeKPPqmeuO82FuVa/+Q83+twAgMzTwJ5KwygQlndJgkAHsztAmYcZN0DMpIFClbbBLgbMGQCpGPI0PV8Pg344m7fpgcWgmA32c39CA1DY3Uis/tXvzx85sPPQ2bYVu5imr8hxJnIpDpv4tA0j3I20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UD9ZrFTU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KtdUu5zv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UD9ZrFTU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KtdUu5zv; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UD9ZrFTU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KtdUu5zv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UD9ZrFTU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KtdUu5zv"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3C4D51F792;
	Fri, 31 Oct 2025 13:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761916145; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=C+rKro8LzMULy+cNDfjvgiZ7mr4izQH6nKs8tyQ8oQk=;
	b=UD9ZrFTUWCnHzaYOetzyMwGk4wpSpATIBfkJi71Y4/p9eMy+CPegRnlh4Ijt7ZsugFJHga
	OmWNP3nKJY5UUHgiCE3gQ1B75/UDRgp6+LLcQRHUDNuQ5HZ6l6q2MKYeo6+60V7hnuIj+1
	vGa37B0464BthkrN0HrJtHR6Gq7dbbE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761916145;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=C+rKro8LzMULy+cNDfjvgiZ7mr4izQH6nKs8tyQ8oQk=;
	b=KtdUu5zvXISfuepdfFFSDP/TzdgZRfvOUyS1U3h7+m2J2rTPLhdPaiiNwdXtE0YEqW98+y
	+VAniuUI93RdU+BA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761916145; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=C+rKro8LzMULy+cNDfjvgiZ7mr4izQH6nKs8tyQ8oQk=;
	b=UD9ZrFTUWCnHzaYOetzyMwGk4wpSpATIBfkJi71Y4/p9eMy+CPegRnlh4Ijt7ZsugFJHga
	OmWNP3nKJY5UUHgiCE3gQ1B75/UDRgp6+LLcQRHUDNuQ5HZ6l6q2MKYeo6+60V7hnuIj+1
	vGa37B0464BthkrN0HrJtHR6Gq7dbbE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761916145;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=C+rKro8LzMULy+cNDfjvgiZ7mr4izQH6nKs8tyQ8oQk=;
	b=KtdUu5zvXISfuepdfFFSDP/TzdgZRfvOUyS1U3h7+m2J2rTPLhdPaiiNwdXtE0YEqW98+y
	+VAniuUI93RdU+BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DA0B613393;
	Fri, 31 Oct 2025 13:09:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id y1tqMvC0BGkwNgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 31 Oct 2025 13:09:04 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf v3] netfilter: nft_connlimit: fix duplicated tracking of a connection
Date: Fri, 31 Oct 2025 14:08:37 +0100
Message-ID: <20251031130837.8806-1-fmancera@suse.de>
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

Connlimit expression can be used for all kind of packets and not only
for packets with connection state new. See this ruleset as example:

table ip filter {
        chain input {
                type filter hook input priority filter; policy accept;
                tcp dport 22 ct count over 4 counter
        }
}

Currently, if the connection count goes over the limit the counter will
count the packets. When a connection is closed, the connection count
won't decrement as it should because it is only updated for new
connections due to an optimization on __nf_conncount_add() that prevents
updating the list if the connection is duplicated.

In addition, since commit d265929930e2 ("netfilter: nf_conncount: reduce
unnecessary GC") there can be situations where a duplicated connection
is added to the list. This is caused by two packets from the same
connection being processed during the same jiffy.

To solve these problems, check whether this is a new connection and only
add the connection to the list if that is the case during connlimit
evaluation. Otherwise run a GC to update the count. This doesn't yield a
performance degradation.

Fixed in xt_connlimit too.

Fixes: d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC")
Fixes: 976afca1ceba ("netfilter: nf_conncount: Early exit in nf_conncount_lookup() and cleanup")
Closes: https://lore.kernel.org/netfilter/trinity-85c72a88-d762-46c3-be97-36f10e5d9796-1761173693813@3c-app-mailcom-bs12/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: use nf_ct_is_confirmed(), add comment about why the gc call is
needed and fix this in xt_connlimit too.

v3: call gc only if the condition is not met and we are not certain that
the list is updated
---
 net/netfilter/nft_connlimit.c | 22 +++++++++++++++++++---
 net/netfilter/xt_connlimit.c  | 14 ++++++++++++--
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index fc35a11cdca2..d4a132e38199 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -29,6 +29,7 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 	struct nf_conntrack_tuple tuple;
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn *ct;
+	bool updated = false;
 	unsigned int count;
 
 	tuple_ptr = &tuple;
@@ -43,16 +44,31 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 		return;
 	}
 
-	if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
-		regs->verdict.code = NF_DROP;
-		return;
+	if (!ct || !nf_ct_is_confirmed(ct)) {
+		if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
+			regs->verdict.code = NF_DROP;
+			return;
+		}
+		updated = true;
 	}
 
+check:
 	count = READ_ONCE(priv->list->count);
 
 	if ((count > priv->limit) ^ priv->invert) {
 		regs->verdict.code = NFT_BREAK;
 		return;
+	} else if (!updated) {
+		/* Call gc to update the list count if any connection has been
+		 * closed already. This is useful to softlimit connections
+		 * like limiting bandwidth based on a number of open
+		 * connections.
+		 */
+		local_bh_disable();
+		nf_conncount_gc_list(nft_net(pkt), priv->list);
+		local_bh_enable();
+		updated = true;
+		goto check;
 	}
 }
 
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 0189f8b6b0bd..5c90e1929d86 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -69,8 +69,18 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		key[1] = zone->id;
 	}
 
-	connections = nf_conncount_count(net, info->data, key, tuple_ptr,
-					 zone);
+	if (!ct || !nf_ct_is_confirmed(ct)) {
+		connections = nf_conncount_count(net, info->data, key, tuple_ptr,
+						 zone);
+	} else {
+		/* Call nf_conncount_count() with NULL tuple and zone to update
+		 * the list if any connection has been closed already. This is
+		 * useful to softlimit connections like limiting bandwidth based
+		 * on a number of open connections.
+		 */
+		connections = nf_conncount_count(net, info->data, key, NULL, NULL);
+	}
+
 	if (connections == 0)
 		/* kmalloc failed, drop it entirely */
 		goto hotdrop;
-- 
2.51.0

