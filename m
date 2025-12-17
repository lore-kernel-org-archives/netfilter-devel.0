Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B4C35A922
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Dec 2025 14:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765982821; cv=none; b=X+hjSHjYIrDLEPWQkuP9ryjCNrmQdYt6zF527UKL+Ho50TsW7S/OtSDmo2QxEN+MmcxtP+5TPp5L94Fc6zlJyujthD7jlALBH6uIOQrgylv7hWrdn5zFZslSO5FVFpvrzA58EFTRbMAu32otUSCyC49YJ+qJtMK9e2gpQulgIvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765982821; c=relaxed/simple;
	bh=N5kypyRdHDrmTIuPMkT4S3Jk5YRv1Dj1dZCHQzAmyoo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tEIw/ABGXpmls+bC8k4AHG+Yu6FKFuFFRAVYrB7z67aad+BSAynmaRk6rnoKNu/uXoeekrSfq1NRj2S54iN0SHj5k3CxIhpXJMUQWWwkyUChB/+myiBqiU6IEkmJ/Ak9dPuVjYUMpNnfBWmff438Z3UA8bqLrF0dZAtd2gEQzzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xnPpHP5x; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BDoPROMR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xnPpHP5x; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BDoPROMR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xnPpHP5x";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BDoPROMR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xnPpHP5x";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BDoPROMR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3EB015BD00;
	Wed, 17 Dec 2025 14:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765982817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=++4TAQ/FCeRsCgSvyxowhN2Z84iIRyeLQeHjb1E1OFE=;
	b=xnPpHP5xhB3k96okSCQ7txDO8WOlx1K7pccwA+ZKGAg8MRTYbF/J6IvTDzmjqQBH8i/0d8
	6NDudnoMrHebYH75tihsvJiKm+yVMY3dDpGt8Aas9TJoDXSkyLjVE55ApL/ciIcU689W4P
	Xg6kOmBi4xEQ/QqGvEDANTnXDtvfbCs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765982817;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=++4TAQ/FCeRsCgSvyxowhN2Z84iIRyeLQeHjb1E1OFE=;
	b=BDoPROMRY/uqpf7B1/2xk+7J6gYr1BrrjslaDzxYgjc5wpeftrPyDbx9WiRcFli6LHXwO3
	FHWUTRhCvp/nzXAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xnPpHP5x;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BDoPROMR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765982817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=++4TAQ/FCeRsCgSvyxowhN2Z84iIRyeLQeHjb1E1OFE=;
	b=xnPpHP5xhB3k96okSCQ7txDO8WOlx1K7pccwA+ZKGAg8MRTYbF/J6IvTDzmjqQBH8i/0d8
	6NDudnoMrHebYH75tihsvJiKm+yVMY3dDpGt8Aas9TJoDXSkyLjVE55ApL/ciIcU689W4P
	Xg6kOmBi4xEQ/QqGvEDANTnXDtvfbCs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765982817;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=++4TAQ/FCeRsCgSvyxowhN2Z84iIRyeLQeHjb1E1OFE=;
	b=BDoPROMRY/uqpf7B1/2xk+7J6gYr1BrrjslaDzxYgjc5wpeftrPyDbx9WiRcFli6LHXwO3
	FHWUTRhCvp/nzXAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EFE893EA63;
	Wed, 17 Dec 2025 14:46:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3S+IN2DCQmnAHQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 17 Dec 2025 14:46:56 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 1/2 nf v2] netfilter: nf_conncount: update last_gc only when GC has been performed
Date: Wed, 17 Dec 2025 15:46:40 +0100
Message-ID: <20251217144641.4122-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: 3EB015BD00
X-Spam-Flag: NO
X-Spam-Score: -3.01

Currently last_gc is being updated everytime a new connection is
tracked, that means that it is updated even if a GC wasn't performed.
With a sufficiently high packet rate, it is possible to always bypass
the GC, causing the list to grow infinitely.

Update the last_gc value only when a GC has been actually performed.

Fixes: d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: introduced this patch to the series
---
 net/netfilter/nf_conncount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 3654f1e8976c..8487808c8761 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -229,6 +229,7 @@ static int __nf_conncount_add(struct net *net,
 
 		nf_ct_put(found_ct);
 	}
+	list->last_gc = (u32)jiffies;
 
 add_new_node:
 	if (WARN_ON_ONCE(list->count > INT_MAX)) {
@@ -248,7 +249,6 @@ static int __nf_conncount_add(struct net *net,
 	conn->jiffies32 = (u32)jiffies;
 	list_add_tail(&conn->node, &list->head);
 	list->count++;
-	list->last_gc = (u32)jiffies;
 
 out_put:
 	if (refcounted)
-- 
2.51.1

