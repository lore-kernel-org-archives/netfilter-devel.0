Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4F12153EA
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Sep 2025 12:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758285677; cv=none; b=EBGOcy4R2VcAH2dmrPxvl046iP7Gy7bCyZxZ5XXQpY5XoE4ew+yPQvBk3X+/5s+iQUkDmGMmBlTAF34cd4y99SDba4Bel4vhRC3UXixdWyB9WeHETPwzt3ZXVlmCpeF4AHxEggOn+V67cvEbPGYJ4JXxdbmueFoB/vQ2Fl+3K2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758285677; c=relaxed/simple;
	bh=sMuBMgsQDsUZVR/6l+Fo4a0xLYop1eFcSm4g05qqYug=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pv69xRDfrmVUVRrTM0aBJceqabJ/hJY2kAzH5sIsUX41HV4SryoV5CVevBjY7IHeZLeXMilfZV3deVF3ixqDDyTZ+qYN6BFS5iMsra7cutTjzuc3aiCTzoSO5W8JpjdSxhNyk4JJTMVxmDMV57ncDo9DQoh/VosF6/4lCoxvqgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MqGo2qpZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kEyZ/HF4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MqGo2qpZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kEyZ/HF4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MqGo2qpZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kEyZ/HF4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MqGo2qpZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kEyZ/HF4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 249FC336B6;
	Fri, 19 Sep 2025 12:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758285674; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=AQ3VKdk5xDGOA+RczIZ6a3QZglMva0tGYAlnkazTX/4=;
	b=MqGo2qpZST1+3gnj6q/EicejFj+w44RGYwjEGxQFIZeGwbW+02g4o4coU/PUV5wRpuv5I4
	4Pao0ZXImeBhGmYAtALaiQ2jo03W5nXw9F6aSsyo9hCG8v8kGJ1M9YGZAHia6YpfXKku0t
	c9OlExld2hcgZVdtydnKuQPhE/JAKFE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758285674;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=AQ3VKdk5xDGOA+RczIZ6a3QZglMva0tGYAlnkazTX/4=;
	b=kEyZ/HF4ckasB9/k69Y2jEDozvGN1dgXEwBlKNhECxlxJARX7fJwzzF/2JRbYBPbqwhK1k
	+IwKAaEAupAVQ2DA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MqGo2qpZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="kEyZ/HF4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758285674; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=AQ3VKdk5xDGOA+RczIZ6a3QZglMva0tGYAlnkazTX/4=;
	b=MqGo2qpZST1+3gnj6q/EicejFj+w44RGYwjEGxQFIZeGwbW+02g4o4coU/PUV5wRpuv5I4
	4Pao0ZXImeBhGmYAtALaiQ2jo03W5nXw9F6aSsyo9hCG8v8kGJ1M9YGZAHia6YpfXKku0t
	c9OlExld2hcgZVdtydnKuQPhE/JAKFE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758285674;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=AQ3VKdk5xDGOA+RczIZ6a3QZglMva0tGYAlnkazTX/4=;
	b=kEyZ/HF4ckasB9/k69Y2jEDozvGN1dgXEwBlKNhECxlxJARX7fJwzzF/2JRbYBPbqwhK1k
	+IwKAaEAupAVQ2DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C0FF313A39;
	Fri, 19 Sep 2025 12:41:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id z0xOLGlPzWhTfwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 19 Sep 2025 12:41:13 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	donald.hunter@gmail.com,
	kuba@kernel.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf] netfilter: nfnetlink: reset nlh pointer during batch replay
Date: Fri, 19 Sep 2025 14:40:43 +0200
Message-ID: <20250919124043.18452-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[netfilter.org,gmail.com,kernel.org,suse.de];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email];
	TAGGED_RCPT(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 249FC336B6
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -1.51

During a batch replay, the nlh pointer is not reset until the parsing of
the commands. Since commit bf2ac490d28c ("netfilter: nfnetlink: Handle
ACK flags for batch messages") that is problematic as the condition to
add an ACK for batch begin will evaluate to true even if NLM_F_ACK
wasn't used for batch begin message.

If there is an error during the command processing, netlink is sending
an ACK despite that. This misleads userspace tools which think that the
return code was 0. Reset the nlh pointer to the original one when a
replay is triggered.

Fixes: bf2ac490d28c ("netfilter: nfnetlink: Handle ACK flags for batch messages")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nfnetlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index e598a2a252b0..811d02b4c4f7 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -376,6 +376,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	const struct nfnetlink_subsystem *ss;
 	const struct nfnl_callback *nc;
 	struct netlink_ext_ack extack;
+	struct nlmsghdr *onlh = nlh;
 	LIST_HEAD(err_list);
 	u32 status;
 	int err;
@@ -386,6 +387,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	status = 0;
 replay_abort:
 	skb = netlink_skb_clone(oskb, GFP_KERNEL);
+	nlh = onlh;
 	if (!skb)
 		return netlink_ack(oskb, nlh, -ENOMEM, NULL);
 
-- 
2.51.0

