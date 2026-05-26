Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF95337E302
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 14:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779805144; cv=none; b=AR6Z/CL73DRzRnMD/pKHGtSFzPNpBQYutbRnWu+wWRQ7YVSOQ3eohrOHe/k7KNBKp7FUJlFIFIGy9OJ+FoBncyiGbEUdc4jR8bpbV3Ysdy9KvHxGEAl7DZU5tKwYNHI2oCA1DZBwEqkfWldXwUeb3MSzXuxODG+KTCCW6ouKf3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779805144; c=relaxed/simple;
	bh=ZYIphicvblmGkG70Qfi+Yulqc3S5qSAjMXNu5D0NOMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APXbLrCXs0HmhYbMi2aSdKEmMzluY7w2jrcSouWZb/DJgmPmjVu/i+3stKBaNcBTi7AKLQD4tAOe9RgU2t62WfrGcNiUab1yhXxuMUD6ISStg2UH5wqWt4LtS1YlCtdl7OkeJFaEFKt4bCysaDLO/b6ziXKzk+CQIXMm4+d0vac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qqBFUpf0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7a+h7yCo; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qqBFUpf0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7a+h7yCo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qqBFUpf0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7a+h7yCo";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qqBFUpf0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7a+h7yCo"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3C7B25CEBD;
	Tue, 26 May 2026 14:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779805141; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g9Z8pv6SZKfW8NNpXKczlflnAHLcQRG68a0cZ/I8MoQ=;
	b=qqBFUpf0KR/th7oLTFV5wpMjIilnaGXj1hHLH45PbsEWuEsg8C27pjRDsAy7cB+cF5pdom
	LefYoWCvpdJIY4cgxtVrHAyT618KrpBAsK2okT85vmTUPlToMKigvtDucxty+bZFGiVKno
	/wbBFWovpqcva/OW3W7AX6arbcVhCUE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779805141;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g9Z8pv6SZKfW8NNpXKczlflnAHLcQRG68a0cZ/I8MoQ=;
	b=7a+h7yCoYuYnRe3JT4jaVbto4X7MXlJSxvbNjvFJDLphi2lEDccgHHa47LqMA2bfgILBCf
	daSamvhXGrU51jAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779805141; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g9Z8pv6SZKfW8NNpXKczlflnAHLcQRG68a0cZ/I8MoQ=;
	b=qqBFUpf0KR/th7oLTFV5wpMjIilnaGXj1hHLH45PbsEWuEsg8C27pjRDsAy7cB+cF5pdom
	LefYoWCvpdJIY4cgxtVrHAyT618KrpBAsK2okT85vmTUPlToMKigvtDucxty+bZFGiVKno
	/wbBFWovpqcva/OW3W7AX6arbcVhCUE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779805141;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g9Z8pv6SZKfW8NNpXKczlflnAHLcQRG68a0cZ/I8MoQ=;
	b=7a+h7yCoYuYnRe3JT4jaVbto4X7MXlJSxvbNjvFJDLphi2lEDccgHHa47LqMA2bfgILBCf
	daSamvhXGrU51jAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB9825A24D;
	Tue, 26 May 2026 14:19:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UDvNLtSrFWqbJQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 26 May 2026 14:19:00 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 4/5 nf-next v3] netfilter: synproxy: protect nf_ct_seqadj_init() with conntrack lock
Date: Tue, 26 May 2026 16:18:37 +0200
Message-ID: <20260526141838.4191-5-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260526141838.4191-1-fmancera@suse.de>
References: <20260526141838.4191-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.988];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]

nf_ct_seqadj_init() is called without holding the ct lock. This can race
with nf_ct_seq_adjust() when a connection is in CLOSE state due to an
RST or connection reopening. In addition for SYN_RECV state, concurrent
processing of packets can trigger nf_ct_seq_adjust() too. These
situations create a read/write data race.

Fix this by wrapping the nf_ct_seqadj_init() calls in the synproxy hooks
with locking.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_synproxy_core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 5413133a42fa..3e02e252eecc 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -669,8 +669,10 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 	switch (state->state) {
 	case TCP_CONNTRACK_CLOSE:
 		if (th->rst && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
+			spin_lock_bh(&ct->lock);
 			nf_ct_seqadj_init(ct, ctinfo, synproxy->isn -
 						      ntohl(th->seq) + 1);
+			spin_unlock_bh(&ct->lock);
 			break;
 		}
 
@@ -682,7 +684,9 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 		 * adjustments, they will get initialized once the connection is
 		 * reestablished.
 		 */
+		spin_lock_bh(&ct->lock);
 		nf_ct_seqadj_init(ct, ctinfo, 0);
+		spin_unlock_bh(&ct->lock);
 		synproxy->tsoff = 0;
 		this_cpu_inc(snet->stats->conn_reopened);
 		fallthrough;
@@ -731,7 +735,9 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 		swap(opts.tsval, opts.tsecr);
 		synproxy_send_server_ack(net, state, skb, th, &opts);
 
+		spin_lock_bh(&ct->lock);
 		nf_ct_seqadj_init(ct, ctinfo, synproxy->isn - ntohl(th->seq));
+		spin_unlock_bh(&ct->lock);
 		nf_conntrack_event_cache(IPCT_SEQADJ, ct);
 
 		swap(opts.tsval, opts.tsecr);
@@ -1094,8 +1100,10 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 	switch (state->state) {
 	case TCP_CONNTRACK_CLOSE:
 		if (th->rst && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
+			spin_lock_bh(&ct->lock);
 			nf_ct_seqadj_init(ct, ctinfo, synproxy->isn -
 						      ntohl(th->seq) + 1);
+			spin_unlock_bh(&ct->lock);
 			break;
 		}
 
@@ -1107,7 +1115,9 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 		 * adjustments, they will get initialized once the connection is
 		 * reestablished.
 		 */
+		spin_lock_bh(&ct->lock);
 		nf_ct_seqadj_init(ct, ctinfo, 0);
+		spin_unlock_bh(&ct->lock);
 		synproxy->tsoff = 0;
 		this_cpu_inc(snet->stats->conn_reopened);
 		fallthrough;
@@ -1156,7 +1166,9 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 		swap(opts.tsval, opts.tsecr);
 		synproxy_send_server_ack_ipv6(net, state, skb, th, &opts);
 
+		spin_lock_bh(&ct->lock);
 		nf_ct_seqadj_init(ct, ctinfo, synproxy->isn - ntohl(th->seq));
+		spin_unlock_bh(&ct->lock);
 		nf_conntrack_event_cache(IPCT_SEQADJ, ct);
 
 		swap(opts.tsval, opts.tsecr);
-- 
2.53.0

