Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793368697;
	b=y50+aHqknFkoPtBUZmgzEfEli1+5b+SR87/pN/SKbRhBBnNLhgdXONPNPRJ3eiHOT9+x
	 Ige9E4r5ahPsCoqVN+4Dp3frJg1LXZOayrVUz7ZV2iGU72f6rwF55xiymEMbRb+a2P9Qi
	 Mc4JPlX5tSjDUMndE+rh4I0mCV3R5c/s3xMuM2EJx1RthVEq9110ma7sI42S+DH6E0dHw
	 xKNEIUCkozR87NrY+Q0ko2kXE1k+tZWkoStNMqHSS44J6lZLSS3CzRHA+tHPnpIkOLMl5
	 q2t3zOt8Nv88R2zed9s0e+dPvKFBQXR9eigVNiWkQsu2fraS3t3xAmwTdRda4F4VrQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793368697;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=eLbe6tUqI3rVZO91v4t0j9V6uXtdR0OCF0fXl9VLvHs=;
	b=U+u6XpeHkDicifnjWAkLQQyBArCTwjB6y16zbm47ChTi4CSEUMdCUlBJuz8uFUCdmmYH
	 iADeUSc3fg7DylHpTCa7/4QwHTkPF5i62iWc5qV4PzXK3dxeVaG7LdcR8DslLROj0kv/h
	 EYX84QXfZtn4uBQgVH5V6D5AwcnNIV4GbEUXKTPKKYrj5+mwo3wK7Kpmp+cNIBGs2Vxoi
	 6E0KGGto/yvUoG1G60gW6YlSasCBAOdtKg/d1ajNmsi4b+/QQr+cDj5nN6xByIq8hF+54
	 sPHHi2ZTcXvuZLyGC23HNnyNoQQbqYzHpbJkx6ZBmtHHovAe/6fzG3JrCgHeXgOy7dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=olRhV2+x;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fBWFLULM;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="UVzgP/PM";
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Y7+t1QMr;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C02606A31C
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 13:58:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66C02606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=olRhV2+x;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fBWFLULM;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=UVzgP/PM;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Y7+t1QMr
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7C51822235;
	Fri, 30 Oct 2026 13:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793368689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eLbe6tUqI3rVZO91v4t0j9V6uXtdR0OCF0fXl9VLvHs=;
	b=olRhV2+xVow5HwgCm7Y8kZCjSwGAyR86F6kRUf9i4krgkoj12WpdYc1FU2o5tjK27P+sGF
	GPqs2ODeyr2kfDVh4bsOPXhZxrzyyFJgN2FCJmCSOFpH/lrikcu0HQ38lke1kN4p3JiLra
	zSCkQTDuDe8EdsrZA6eRT/3N2BH3+8M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793368689;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eLbe6tUqI3rVZO91v4t0j9V6uXtdR0OCF0fXl9VLvHs=;
	b=fBWFLULMyDb6teJJHdVKYWh3BIYW1EO2fp+Eh0tm387/JzaO4oo+fTM2AmqqIsGwRjRAZT
	T+C9kpfBM1xlamAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="UVzgP/PM";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Y7+t1QMr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793368688; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eLbe6tUqI3rVZO91v4t0j9V6uXtdR0OCF0fXl9VLvHs=;
	b=UVzgP/PMY5j2Y7WRHr80BT///+Yb1HdFSjweheWWVivRLrPlPsi34D6VZ0mquDSwZ7wjpz
	yBubojcaUDdBMAghoq0W55RWFJL5Jm4kJn/Q7MHIZhgMjj3qByftav3JRIeDqCNaYs5oaV
	NFcCESXBuFeW8h0Zs82w5BxhOArdkVA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793368688;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eLbe6tUqI3rVZO91v4t0j9V6uXtdR0OCF0fXl9VLvHs=;
	b=Y7+t1QMr/d3ekEPA5ucJPhavUWufBE9XOq9+9FIGK7gB50wq6FpZifVGBxmRAQjob7Pzf9
	6y2+Lhpvk2Il5ZCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9E94F13419;
	Fri, 30 Oct 2026 13:58:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Cr4MG2+i5GpUdwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 30 Oct 2026 13:58:07 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	VEGA <vega@nebusec.ai>
Subject: [PATCH nf] netfilter: nfnetlink_queue: keep socket ownership when expanding skb
Date: Fri, 30 Oct 2026 14:57:50 +0100
Message-ID: <20261030135750.4452-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7C51822235
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,nebusec.ai:email];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -12.01

nfqnl_mangle() replaces the skb with skb_copy_expand() when a verdict
grows a packet beyond its tailroom. skb_copy_expand() does not copy
skb->sk, so the replacement is unowned and freeing the original drops
its socket memory charge.

The expanded packet is no longer associated with the process that sent
it. Therefore xt_owner or xt_cgroup and other socket based matches in
later rules no longer matches and a later NFQUEUE reports no uid/gid. In
addition, the expanded packet's memory is not counted towards the
sender's SO_SNDBUF limit, so the sender can keep producing them while
they sit in a queue.

Fix this by transferring ownership before freeing the original as
skb_cow_data() an skb_expand_head() do.

Fixes: e2b58a67b91d ("[NETFILTER]: {ip,ip6,nfnetlink}_queue: fix SKB_LINEAR_ASSERT when mangling packet data")
Reported-by: VEGA <vega@nebusec.ai>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nfnetlink_queue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 90d887546f7d..fe3b9ce7acb0 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1459,6 +1459,8 @@ nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int di
 					       diff, GFP_ATOMIC);
 			if (!nskb)
 				return -ENOMEM;
+			if (e->skb->sk)
+				skb_set_owner_w(nskb, e->skb->sk);
 			kfree_skb(e->skb);
 			e->skb = nskb;
 		}
-- 
2.56.0

