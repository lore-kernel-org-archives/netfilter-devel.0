Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC8E1F4613
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Dec 2025 14:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764856914; cv=none; b=Hsn5G7S1y40/Z41HhYusHaBTXheDd6mL8rrhEryMWOAYWm+KcMVJ2WFMfkmVQf3DJ2jJ1W7slpugaKScEAj+ZAyrN0Edr2LqxOR7Yu6Zhwt6HC54DGAJJtgJ4J83HeeFlzyHxMGA191x17BiJhbu2nqKJcjw+R2nJMVJsft3QWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764856914; c=relaxed/simple;
	bh=eFKlceIFqkdw2hXEslxXfiYGdqHhuQZsIrYMd7AXlTE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=odxoYL+C0KHCPFRoBd6Ftl/HnUZuCuW+0XiYqG/UQ//7h1vMbeLusD56g8V5Grv/VAYAIwJ3o3jcAwaw03FzK1ZNtH+IzypY7SWtaKy24xXxHQqUL4vdLnG9xX7RFhcxc4hwxnEmKm3YO8cyVuNc3uj57gTkNOH/CCgNASF5vdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=y7gCiWep; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6qYaWrcU; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=s7tdlYa5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LFdGXsmM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="y7gCiWep";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6qYaWrcU";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="s7tdlYa5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LFdGXsmM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C4D3C33737;
	Thu,  4 Dec 2025 14:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764856904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ALQUPFZoJmo1emvoDet1Nf0VB3Fo0FxDoqAa1tnzaow=;
	b=y7gCiWepRwTdiFauaPS7SRs77z4rYIe+Q8bAcdq7BZsywdluUYA7JRTbaWErvUwTF/gNTa
	vsgWvIIBFWx9xh7Pl71yeuxpNcP4gPRFnlSAaS21OB4Tpd/5HlNTGvjOM561skpw2gUet8
	fX3gRvgXL0ueQbvoqL41KWaz+nndaFE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764856904;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ALQUPFZoJmo1emvoDet1Nf0VB3Fo0FxDoqAa1tnzaow=;
	b=6qYaWrcUylYOw5QvUk2vLpJZr3F4m2u/Gb5UcqWBJFMeMDXr//ffrMbXpf00d9dT4suGjM
	QrCZfyX0W3jmYcDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764856901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ALQUPFZoJmo1emvoDet1Nf0VB3Fo0FxDoqAa1tnzaow=;
	b=s7tdlYa56ohWImJiIfjjSzhAEJDUrb33og/8tGi8gLvmRwGdWG8v64R5TlWwkaw4N+hvYs
	al+CAV3NKGYlUp5ph/SSCY0n5kp+cFZJs777EtCn9zLQhls0MNZdnHp08ci6BxQpWg3yCu
	8GiwINIyDVJqjxwooJn7lhBoypu98nM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764856901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ALQUPFZoJmo1emvoDet1Nf0VB3Fo0FxDoqAa1tnzaow=;
	b=LFdGXsmM1WD4k1IrUuykPK4mzHExvy850loWv7e3egHxxXVMxFQiZk+AIr/0vJlA9Bh+H3
	r/rcOMU0FqtitKCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A9893EA63;
	Thu,  4 Dec 2025 14:01:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cUqUGkWUMWnVTAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 04 Dec 2025 14:01:41 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf] netfilter: nf_conncount: fix leaked ct in error paths
Date: Thu,  4 Dec 2025 15:01:24 +0100
Message-ID: <20251204140124.4376-1-fmancera@suse.de>
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.984];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -2.80

There are some situations where ct might be leaked as error paths are
skipping the refcounted check and return immediately. In order to solve
it, call nf_ct_put() as soon as possible or make sure that the check is
always called.

Fixes: be102eb6a0e7 ("netfilter: nf_conncount: rework API to use sk_buff directly")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
Note: this is actually rebased in top of net.git
---
 net/netfilter/nf_conncount.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index f1be4dd5cf85..09b534fb1b4b 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -181,6 +181,8 @@ static int __nf_conncount_add(struct net *net,
 			nf_ct_put(ct);
 		return -EEXIST;
 	}
+	if (refcounted)
+		nf_ct_put(ct);
 
 	if ((u32)jiffies == list->last_gc)
 		goto add_new_node;
@@ -197,7 +199,7 @@ static int __nf_conncount_add(struct net *net,
 				if (nf_ct_tuple_equal(&conn->tuple, &tuple) &&
 				    nf_ct_zone_id(&conn->zone, conn->zone.dir) ==
 				    nf_ct_zone_id(zone, zone->dir))
-					goto out_put; /* already exists */
+					return 0; /* already exists */
 			} else {
 				collect++;
 			}
@@ -215,7 +217,7 @@ static int __nf_conncount_add(struct net *net,
 			 * Attempt to avoid a re-add in this case.
 			 */
 			nf_ct_put(found_ct);
-			goto out_put;
+			return 0;
 		} else if (already_closed(found_ct)) {
 			/*
 			 * we do not care about connections which are
@@ -246,9 +248,6 @@ static int __nf_conncount_add(struct net *net,
 	list->count++;
 	list->last_gc = (u32)jiffies;
 
-out_put:
-	if (refcounted)
-		nf_ct_put(ct);
 	return 0;
 }
 
@@ -456,11 +455,10 @@ insert_tree(struct net *net,
 
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

