Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B42825A65B
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 13:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744222; cv=none; b=fFPF9FZxyklOlvfSsnmzicuAI2QZ8uTOpQk1Nhk/i3LDjvqBaUS5x3UpzAOFFsUJ0M9ruZaxIpXyY9JBcgRiPmUUAD7dqc6JXz0NmpgAc1ORs1SQnHIczLaHkPdwsG0iiNdBUSmzNAU7HuX+AJUTlAL2dSa/mgP7l4cLMYZ2u7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744222; c=relaxed/simple;
	bh=qfxmFRI2icOsE/CzpUu18MjepVHTyXc9zu39q4Yru9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cBj3/afVV5yRnqHm9Nlsri0IGGXuB8N4Hkd4Zu4ztZjLtOF5f/HDJ8zwWFX3q/RqTx+MeEVrERy/bRtqya0IKwL9zseofuOVLCPC4IJe4IRbz1tnUJwW2bU5OW7KNBLdSykSMWx1r7Pmel+t2PKKSjrluJBj0LWj4WrNNDRe3Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nk2HuHvF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=O89Ssxmn; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DE8+Fkn0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=148labF0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nk2HuHvF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="O89Ssxmn";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DE8+Fkn0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="148labF0"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9CA5920B36;
	Wed, 29 Oct 2025 13:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761744211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=27u9lmA95bX36AUp9d7HrOy6bfh9zIlb0ZF6A/DGkmo=;
	b=nk2HuHvFHrSOskH3tXyQQhNIjtlrPJQYDO2M6hI8ou+m60e6elhlTLwnhC2Spt0ZuthXdW
	IWSNCOQEkXFWDIOcyF7fKGj6vztO454F4qutX6oZIc3t5T0YlKOKVNAnn5DWqI9mqIRoSi
	Jy1+Lo2RxuT3UAgzLk+rNkE1nPpOJpQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761744211;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=27u9lmA95bX36AUp9d7HrOy6bfh9zIlb0ZF6A/DGkmo=;
	b=O89SsxmneGZGnKaltfwoO1fouj4cjTHeBGZ5muN8HKxKwh6aq4e6gM7WeGsFvZskxDn1dG
	Q0WMzASjHHTBj5Dg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761744210; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=27u9lmA95bX36AUp9d7HrOy6bfh9zIlb0ZF6A/DGkmo=;
	b=DE8+Fkn0w7AFkYYSkyVHbLMv7YvFuvQTPqogCVaIuYJQmqpYZbKCxxwGd1msvnL/zjXvQs
	I2DVwfvR3o+8lCq02TbeXdXW562LbtkRGLOqC8zMLuPKBALdk0CA9JBBF+Cqpav76lCNHd
	4zdmyuiioLme9CjEZcELn3/zqrzQyKU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761744210;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=27u9lmA95bX36AUp9d7HrOy6bfh9zIlb0ZF6A/DGkmo=;
	b=148labF0cCAncbKS7nh8zFmTjWIUIp455r2s89PDUBcvYjZqmmXYTgYnk5qrsKLTpw3gOV
	1eIJgkw7Xrh9tCAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 45EF21349D;
	Wed, 29 Oct 2025 13:23:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wJDlDVIVAmm2cQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 29 Oct 2025 13:23:30 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf v2] netfilter: nft_connlimit: fix duplicated tracking of a connection
Date: Wed, 29 Oct 2025 14:23:18 +0100
Message-ID: <20251029132318.5628-1-fmancera@suse.de>
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
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

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
---
 net/netfilter/nft_connlimit.c | 17 ++++++++++++++---
 net/netfilter/xt_connlimit.c  | 14 ++++++++++++--
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index fc35a11cdca2..dedea1681e73 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -43,9 +43,20 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
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
+	} else {
+		/* Call gc to update the list count if any connection has been
+		 * closed already. This is useful to softlimit connections
+		 * like limiting bandwidth based on a number of open
+		 * connections.
+		 */
+		local_bh_disable();
+		nf_conncount_gc_list(nft_net(pkt), priv->list);
+		local_bh_enable();
 	}
 
 	count = READ_ONCE(priv->list->count);
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

