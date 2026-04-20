Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B052BE05E
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 10:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776682113; cv=none; b=pPuj/9ioPRvFUNB/h6hXbFtOCFHXTipIlRHmTD16H/5sWL3qI4WApGWDS3bILLjShxdbJbEYHTOUZnwubtbI4Nrk/gpI1nk5/0r4DJDsVTFX+QQzP+30OgiBut1f6tEPW20o0bmqteP8pGIk2ZrO8UdiDk465DVsqdA6OSF3D10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776682113; c=relaxed/simple;
	bh=X/c0obyNrbVn7G7S5slyftSuNDPhRrsRw+Nd0q1D+OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IPUO7Lv9Wx01TC8vygRRgGxwP26Cy6jZvEesvAwiPcDeRVkRIA5g5AOedHcuaPJnrmCLaJfbPaQlFop5Y3bPwItXzpu/7tx/Dvgvx7NGI8oF503NHTCbVpIVNib3sd/s9WACf9tJ6EtXIGBH4+ey6fGoZrV8thwIdzzqFwtdvpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HPM4WtGr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DojKClWt; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HPM4WtGr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DojKClWt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HPM4WtGr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DojKClWt";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HPM4WtGr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DojKClWt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 267B36A7D8;
	Mon, 20 Apr 2026 10:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776682110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PDCDbjRv+gNlD/TTYbzyUgAf3VbhGIk9vPchwPZI/Z8=;
	b=HPM4WtGrBJrbpGyJVVdA4m+ztDiLLbCMt0BTPbzx6Zi6iO/LZrN/koMIxqbvID0MgOA38m
	EGWGnI9zulvhUobPA1L54cGR7EJuuX1u/70Dsq95fxZ+pY6YY7tLL0MUlZEP7+BqnE2E6S
	kF1wmc22+XsES3b6vjHVJuAEggQ9plo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776682110;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PDCDbjRv+gNlD/TTYbzyUgAf3VbhGIk9vPchwPZI/Z8=;
	b=DojKClWtcM5jFsbZTaGYu+f/X8s86i2Hq3tJg0cCmCLpNWdZ5NM07yOIm6QrW5JK7h7+OW
	plUkFvStfjG0MEDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776682110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PDCDbjRv+gNlD/TTYbzyUgAf3VbhGIk9vPchwPZI/Z8=;
	b=HPM4WtGrBJrbpGyJVVdA4m+ztDiLLbCMt0BTPbzx6Zi6iO/LZrN/koMIxqbvID0MgOA38m
	EGWGnI9zulvhUobPA1L54cGR7EJuuX1u/70Dsq95fxZ+pY6YY7tLL0MUlZEP7+BqnE2E6S
	kF1wmc22+XsES3b6vjHVJuAEggQ9plo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776682110;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PDCDbjRv+gNlD/TTYbzyUgAf3VbhGIk9vPchwPZI/Z8=;
	b=DojKClWtcM5jFsbZTaGYu+f/X8s86i2Hq3tJg0cCmCLpNWdZ5NM07yOIm6QrW5JK7h7+OW
	plUkFvStfjG0MEDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 71787593AE;
	Mon, 20 Apr 2026 10:48:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KgO9GH0E5mkFFgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 20 Apr 2026 10:48:29 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	ecklm94@gmail.com,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 1/2 nf v2] netfilter: nf_tables: skip L4 header parsing for non-first fragments
Date: Mon, 20 Apr 2026 12:47:44 +0200
Message-ID: <20260420104745.10338-1-fmancera@suse.de>
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[netfilter.org,gmail.com,nwl.cc,strlen.de,suse.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

The tproxy, osf, socket and exthdr (SCTP) expressions rely on the
presence of transport layer headers to perform socket lookups,
fingerprint matching, or chunk extraction. For fragmented packets, while
the IP protocol remains constant across all fragments, only the first
fragment contains the actual L4 header.

The expressions could be attached to a chain with a priority lower than
-400, bypassing defragmentation. Or could be used in stateless
environments where defragmentation is not happening at all.  This could
result in garbage data being used for the matching.

Add a check for pkt->fragoff so only unfragmented packets or the first
fragment is processed.

Fixes: 133dc203d77d ("netfilter: nft_exthdr: Support SCTP chunks")
Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Fixes: 554ced0a6e29 ("netfilter: nf_tables: add support for native socket matching")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: handled fragmented packets for socket expression too,
squashed nftables expression commits into this one.
---
 net/netfilter/nft_exthdr.c | 2 +-
 net/netfilter/nft_osf.c    | 2 +-
 net/netfilter/nft_socket.c | 7 ++++++-
 net/netfilter/nft_tproxy.c | 8 ++++----
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 7eedf4e3ae9c..8eb708bb8cff 100644
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
index 1c0b493ef0a9..ceca87e405eb 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -28,7 +28,7 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct nf_osf_data data;
 	struct tcphdr _tcph;
 
-	if (pkt->tprot != IPPROTO_TCP) {
+	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 36affbb697c2..52c9a9291486 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -116,8 +116,13 @@ static void nft_socket_eval(const struct nft_expr *expr,
 	if (sk && !net_eq(nft_net(pkt), sock_net(sk)))
 		sk = NULL;
 
-	if (!sk)
+	if (!sk) {
+		if (pkt->fragoff) {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
 		sk = nft_socket_do_lookup(pkt);
+	}
 
 	if (!sk) {
 		regs->verdict.code = NFT_BREAK;
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index 50481280abd2..8080cbd878cd 100644
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

