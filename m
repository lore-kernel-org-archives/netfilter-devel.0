Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB863B6362
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 11:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777289271; cv=none; b=CNuekuNxjexsrrYcE2SYy3FA5aZsm7U74SO4Rlt5noyY2eWpEPX85qeXJgZj+TX1U1X2i1ehaB2/Td4B3r4NdoH+NX7lK6t8KaDSInN0JCo2EVhRoQ18faM9mUbGA7fpzmscgHIkhZmmm5kvj+YsNmfejvHbmzzPOFitvswwIg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777289271; c=relaxed/simple;
	bh=tWb4oRI1J8bHuO/d1QhsEHnpdk2IL04us3Qf0wao0N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UctfA40mB8KWuGWpjZk63BJOYLELW6jxD0Osu2ILllFoLZbNSOwXPZCgPyUx3CaJxw0dUBNpGgTzOkYpa0263jh0I4AI5hHSORQayvJBx5NG/bGbmzlgSgYQsI7wM0efpUCoucAIGmJq9oA15QC11a3BBBqqwn9rvPuldc7wIgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nPpjS3qM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UhBpTpm8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nPpjS3qM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UhBpTpm8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nPpjS3qM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UhBpTpm8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nPpjS3qM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UhBpTpm8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5639B6A8F4;
	Mon, 27 Apr 2026 11:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777289265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P4sfyHVGVCWugPgqsQnJeFB9wh9im86EzMZDt51M5PY=;
	b=nPpjS3qM2PKJh4kO/Rsu3w0Dor/XDPOvsfd4T3Ilnekpig74iZ0TELI+AfsYsWw0ZXxuOJ
	7tGm9LtDubgZBqbvmcMjeoWRrTJ2NE1ItggYlxTbO1L9M/GB4XI8TFRrkOSRLxKjRPo/g8
	M3Lmq5qBhmX0NGvk/qkzoZdwDXCQvyM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777289265;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P4sfyHVGVCWugPgqsQnJeFB9wh9im86EzMZDt51M5PY=;
	b=UhBpTpm8clxkGLzSx+BDetkRVlItpjiNuM/5NfEgDRvIVbSqiiqaZkDM3LV7EWJdGZaLr8
	WKbyPvLK/TSObCBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777289265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P4sfyHVGVCWugPgqsQnJeFB9wh9im86EzMZDt51M5PY=;
	b=nPpjS3qM2PKJh4kO/Rsu3w0Dor/XDPOvsfd4T3Ilnekpig74iZ0TELI+AfsYsWw0ZXxuOJ
	7tGm9LtDubgZBqbvmcMjeoWRrTJ2NE1ItggYlxTbO1L9M/GB4XI8TFRrkOSRLxKjRPo/g8
	M3Lmq5qBhmX0NGvk/qkzoZdwDXCQvyM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777289265;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P4sfyHVGVCWugPgqsQnJeFB9wh9im86EzMZDt51M5PY=;
	b=UhBpTpm8clxkGLzSx+BDetkRVlItpjiNuM/5NfEgDRvIVbSqiiqaZkDM3LV7EWJdGZaLr8
	WKbyPvLK/TSObCBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E710A593B0;
	Mon, 27 Apr 2026 11:27:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yAqTNTBI72kaWgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 27 Apr 2026 11:27:44 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 2/3 nf v4] netfilter: nf_tables: skip L4 header parsing for non-first fragments
Date: Mon, 27 Apr 2026 13:27:19 +0200
Message-ID: <20260427112720.5128-2-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260427112720.5128-1-fmancera@suse.de>
References: <20260427112720.5128-1-fmancera@suse.de>
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
	NEURAL_HAM_SHORT(-0.20)[-0.984];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 

The tproxy, osf and exthdr (SCTP) expressions rely on the presence of
transport layer headers to perform socket lookups, fingerprint matching,
or chunk extraction. For fragmented packets, while the IP protocol
remains constant across all fragments, only the first fragment contains
the actual L4 header.

The expressions could be attached to a chain with a priority lower than
-400, bypassing defragmentation. Or could be used in stateless
environments where defragmentation is not happening at all.  This could
result in garbage data being used for the matching.

Add a check for pkt->fragoff so only unfragmented packets or the first
fragment is processed.

Fixes: 133dc203d77d ("netfilter: nft_exthdr: Support SCTP chunks")
Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: handled fragmented packets for socket expression too,
squashed nftables expression commits into this one.
v3: removed changes to nft_socket and created a generic solution for
xt/nft
v4: no changes
---
 net/netfilter/nft_exthdr.c | 2 +-
 net/netfilter/nft_osf.c    | 2 +-
 net/netfilter/nft_tproxy.c | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 0407d6f708ae..e6a07c0df207 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -376,7 +376,7 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
 	const struct sctp_chunkhdr *sch;
 	struct sctp_chunkhdr _sch;
 
-	if (pkt->tprot != IPPROTO_SCTP)
+	if (pkt->tprot != IPPROTO_SCTP || pkt->fragoff)
 		goto err;
 
 	do {
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index c02d5cb52143..45fe56da5044 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -33,7 +33,7 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		return;
 	}
 
-	if (pkt->tprot != IPPROTO_TCP) {
+	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index f2101af8c867..89be443734f6 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -30,8 +30,8 @@ static void nft_tproxy_eval_v4(const struct nft_expr *expr,
 	__be16 tport = 0;
 	struct sock *sk;
 
-	if (pkt->tprot != IPPROTO_TCP &&
-	    pkt->tprot != IPPROTO_UDP) {
+	if ((pkt->tprot != IPPROTO_TCP &&
+	     pkt->tprot != IPPROTO_UDP) || pkt->fragoff) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
@@ -97,8 +97,8 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 
 	memset(&taddr, 0, sizeof(taddr));
 
-	if (pkt->tprot != IPPROTO_TCP &&
-	    pkt->tprot != IPPROTO_UDP) {
+	if ((pkt->tprot != IPPROTO_TCP &&
+	     pkt->tprot != IPPROTO_UDP) || pkt->fragoff) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-- 
2.53.0

