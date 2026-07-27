Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E8E3E47B
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 19:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785181311; cv=none; b=uJM2hTrUThaKbUbVvml/uIu4gMYRxde7LMyvfRzp5xYcklvYN04QaQUoOtyPsZLC8oVTTZC1YYuBGwufseCxyr2N8yD4QFgAF1RZIeTSR0iUL68cKnceU9fMIF4FW1fKKKCkexyPEYgGfof68LoQkZJNlXGDeApD9LtaIOpNoLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785181311; c=relaxed/simple;
	bh=h3kKV91z0GcHfF4cTcKe19LkPuT+5XcF8NxKSKqBgvs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OGpRxZobyJFeTxrbaBZZ939jiMqXb5Oo6/m+oKMB5gelizPDVdcPDRtfYx3KvSEA1FX7ewvrf8CWHX6lCbqohqp+n20eoToz1rB+rtrmYBO8lSIsjqqNYKqINnMVgJ4Du55khUK0iygt51MCOF1zHNUhrGMX3HfZwp/vV22VtXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LtgFANlM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gueC2FTV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HnukP7OR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FHGQYE56; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LtgFANlM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gueC2FTV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HnukP7OR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FHGQYE56"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0F97E3EA0;
	Mon, 27 Jul 2026 19:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785181303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PVe/3FKIrTrPOiXBNg9FXwersubM3rwmJDUXscYTPCE=;
	b=LtgFANlMnwXnbSUcwH+1tkQrhTXWY4CxR0uGvs93fJ/x/YpqSrh1aOnOotx5RzY0C26oTA
	tUl9Ea2uYahR8JHGIv40MN1fLVhrAUw8PpHszYjmBXvGpju+Lzodyjeguz8ErCAtGcJVx/
	ToKSj2jVjMyB7DGEYBcXwWKxGLKtMVM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785181303;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PVe/3FKIrTrPOiXBNg9FXwersubM3rwmJDUXscYTPCE=;
	b=gueC2FTVnWK9qEKBJ147H92hPH536oKiiAZa7R2RPWT6TFZ/VyhCqNbkhf36ZsV/5OURvg
	G/i2W7+MCaqO6wBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HnukP7OR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FHGQYE56
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785181299; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PVe/3FKIrTrPOiXBNg9FXwersubM3rwmJDUXscYTPCE=;
	b=HnukP7ORQNpX7tcevkJ1JeLmk0fBe3WtoaR5r/gyE1Q5/ktZt53yPlgI4ZCK/38odBqx2j
	UjB7PrOsmdX0kU6y2R8LPVW8JlPllxXUQPaGyU8AfUQ1wH6sRHTgJzdAZVhPoG0bwKgq/s
	L7gIV2LvA43DQbz2TTACUKPpG0V+wpE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785181299;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PVe/3FKIrTrPOiXBNg9FXwersubM3rwmJDUXscYTPCE=;
	b=FHGQYE56j+dT6JEJXANvAP8+2b/ytgkFkoKYi+jq9As6Io6j57i0kdeZ/tY91tqHFBQ9q8
	oKD/PfO4iuEwQsBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4B23779B9;
	Mon, 27 Jul 2026 19:41:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BvVvJXK0Z2pJawAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 27 Jul 2026 19:41:38 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next] netfilter: conncount: normalize tuple and zone on successful ct lookup
Date: Mon, 27 Jul 2026 21:41:29 +0200
Message-ID: <20260727194129.4034-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim,strlen.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 0F97E3EA0
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

When get_ct_or_tuple_from_skb() falls back to looking u a connection via
nf_conntrack_find_get(), a successful lookup sets ct but leaves tuple
and zone unupdated.

If the packet belongs to a reply flow, tuple will remain in the reply
direction. As conncount relies on the original direction tuple to count
the connections consistenly, passing an unnormalized reply tuple could
lead to problems.

Fix this by making sure that tuple and zone are normalized.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
Note: I am sending it to nf-next because I couldn't reproduce this issue
pointed out by Sashiko. Having said that, I still think the change
should be done because it makes sense and for consistency reasons
(aboved we are using the original direction too).
---
 net/netfilter/nf_conncount.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 91582069f6d2..4a62d3bef711 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -158,6 +158,8 @@ static bool get_ct_or_tuple_from_skb(struct net *net,
 		return true;
 
 	found_ct = nf_ct_tuplehash_to_ctrack(h);
+	*tuple = found_ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+	*zone = nf_ct_zone(found_ct);
 	*refcounted = true;
 	*ct = found_ct;
 
-- 
2.55.0

