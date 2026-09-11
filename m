Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAC4364940
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 14:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789137801; cv=none; b=l8RYnBg9/MkxFNxJpmWW1tRXH2ybepcJ3I3nvarp1pBUoIJVc2p+nw7390SRBJ+A5u1Qhn7koj4UehBJNSNz8pCpExEYr9VzLvnY9Gq0IsRcXvwF+nrTfoPBQAhA2j3OezCvByqXeZZm3QgzGw/zsH0w6Srakh0cuxbWmcGyKAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789137801; c=relaxed/simple;
	bh=ktgZrY/nHGePdsQPbZ7EV7nBq6cM3xMgEMfbkQL+PSk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DB+ApG3DJyMR8ineRendLVvlac52Yyu5EpWP9h0SQ+tLxb01+xhgMB6iL1I/o7Ehe32TvPAFcsihtlV0VFjRdX4ibEK/7CsKGh14W7rGMt1fp/vZ8E5gHziMs8X1zmXIOHLeku5yL6TvXKT9AHIn8ZB5ttIXPaPt9Up5hyzt28c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wIoRNVPQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=k4BlAGef; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lt23tjB3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qFL3n1cw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wIoRNVPQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="k4BlAGef";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lt23tjB3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qFL3n1cw"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A44A31FEF6;
	Fri, 11 Sep 2026 14:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789137792; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=d50VCDE7WV/v+z7r4NeMw2l0iZnX1FScJUUlpoZuHHQ=;
	b=wIoRNVPQVougeGi0WDxKzkVND9OhHg8BfqrNxiUIhy3pDnUZJnKNIVVX52RPk1bJP35bcc
	QEtHqxQWa/Noef4dp7xziurHLuGN+fptYPXm7aJv2kDu9eEgQZoOsnuI1EygC8Qtfa23zn
	u+b5YyvTURP/0X/paI9gc9fmCVZBrF4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789137792;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=d50VCDE7WV/v+z7r4NeMw2l0iZnX1FScJUUlpoZuHHQ=;
	b=k4BlAGefIQKsCBx4rfBXMoKPUn8kyOoH0FSDJvD3IO6cmO6ZjcMv5Jox6lK9BbUNeeToNg
	dYeccFkHTku+NVCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lt23tjB3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qFL3n1cw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789137788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=d50VCDE7WV/v+z7r4NeMw2l0iZnX1FScJUUlpoZuHHQ=;
	b=lt23tjB3lw6jHNou8qYzQRiGCfPtlwBMp3r9mLbK6ItNJt5vuQ/BTKVWjlk4rsQIw/66j4
	j5mNeVD7mliEesYr2aWB3KRY7WRW8KWuaJk7q1GxDQBX8lQCKBif/be8G2q/2D8SgJ02tn
	a8AXyMFmMZBIdABpwujzPkDw8nKd5xE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789137788;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=d50VCDE7WV/v+z7r4NeMw2l0iZnX1FScJUUlpoZuHHQ=;
	b=qFL3n1cw7ZEA2MF4jrVE+0uNdmftLIpntBhETR3hrPmgug2DA/cs2xlHCUFd1lSQtDpAKG
	GMuhFZYNI78eKICg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 18B75132D3;
	Fri, 11 Sep 2026 14:43:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SS01A3wTpGq8CAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 11 Sep 2026 14:43:08 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	VEGA <vega@nebusec.ai>
Subject: [PATCH nf-next] netfilter: conntrack: prevent nf_conntrack_buckets race condition
Date: Fri, 11 Sep 2026 16:42:55 +0200
Message-ID: <20260911144255.4900-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: A44A31FEF6
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email,suse.de:mid];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

There is a race condition in the nf_conntrack_buckets sysctl handler.
The implementation uses a single global variable as a temporary buffer
to parse user input. Because sysctl handlers are not locked, a
concurrent read or write can overwrite this shared variable after a
writer has parsed its input but before the actual resize occurs.

While this sysctl is only writable from the initial network namespace,
the race can trigger if a monitoring daemon reads the sysctl while an
administrator or orchestrator is writing to it.

Fix this by removing the unnecessary global state by using a local-stack
table instead and delegating the locking/serialization to
nf_conntrack_hash_resize() function.

Fixes: 3183ab8997a4 ("netfilter: conntrack: allow increasing bucket size via sysctl too")
Reported-by: VEGA <vega@nebusec.ai>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
Note: this isn't relevant enough to land in nf tree in my opinion, let's
aim for nf-next so we avoid a false sense of urgency
---
 net/netfilter/nf_conntrack_standalone.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index f4f2d82192d5..4b692a184e94 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -533,27 +533,22 @@ EXPORT_SYMBOL_GPL(nf_conntrack_count);
 /* Sysctl support */
 
 #ifdef CONFIG_SYSCTL
-/* size the user *wants to set */
-static unsigned int nf_conntrack_htable_size_user __read_mostly;
-
 static int
 nf_conntrack_hash_sysctl(const struct ctl_table *table, int write,
 			 void *buffer, size_t *lenp, loff_t *ppos)
 {
+	unsigned int htable_size = READ_ONCE(nf_conntrack_htable_size);
+	struct ctl_table tmp = *table;
 	int ret;
 
-	/* module_param hashsize could have changed value */
-	nf_conntrack_htable_size_user = nf_conntrack_htable_size;
+	tmp.data = &htable_size;
 
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	ret = proc_dointvec(&tmp, write, buffer, lenp, ppos);
 	if (ret < 0 || !write)
 		return ret;
 
 	/* update ret, we might not be able to satisfy request */
-	ret = nf_conntrack_hash_resize(nf_conntrack_htable_size_user);
-
-	/* update it to the actual value used by conntrack */
-	nf_conntrack_htable_size_user = nf_conntrack_htable_size;
+	ret = nf_conntrack_hash_resize(htable_size);
 	return ret;
 }
 
@@ -657,7 +652,6 @@ static const struct ctl_table nf_ct_sysctl_table[] = {
 	},
 	[NF_SYSCTL_CT_BUCKETS] = {
 		.procname       = "nf_conntrack_buckets",
-		.data           = &nf_conntrack_htable_size_user,
 		.maxlen         = sizeof(unsigned int),
 		.mode           = 0644,
 		.proc_handler   = nf_conntrack_hash_sysctl,
@@ -1153,8 +1147,6 @@ static int __init nf_conntrack_standalone_init(void)
 		ret = -ENOMEM;
 		goto out_sysctl;
 	}
-
-	nf_conntrack_htable_size_user = nf_conntrack_htable_size;
 #endif
 
 	nf_conntrack_init_end();
-- 
2.55.0

