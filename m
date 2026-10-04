Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C078C223DFF;
	Sun,  4 Oct 2026 01:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791078137; cv=none; b=jvfKW4FZCKJpla2vUs08NrHSadTDPqLfPrT8ckvyWb0cpV6tiZ/jI88kLnp18WO7AeA8QNjbVU+bolJ3At/YJ+c0Ka4JR/V4wbgCn1KhqMJv8edjHHzMZTx2P1DOlsy2N3HsyiiawHuqKD7mWyUtX2Zat19PvFNa87k5Za9OcxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791078137; c=relaxed/simple;
	bh=9N+2eWbTOHqbqaVDuPJRHZN2V/OgbiPpyNBcplH4KtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E11Yci+nacPA+QWPahd9DDoUDCD8NLLAmaO+NWqXWYKuQbq2O0Dr5xerLrcls6ymCgm4BV/NHbs0Zdv+1mn9CkABspLcbyJgSZwFB6hXp8TXW5pmMPbnZeVHb91F6e1NqoC3KO67Vce7D7cC30pqcG0H/s2QRjLKk/ZWgPWTzdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UAoNICME; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uPMAe7uN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UAoNICME; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uPMAe7uN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UAoNICME";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uPMAe7uN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UAoNICME";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uPMAe7uN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 36AC61FF20;
	Sun,  4 Oct 2026 01:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791078128; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6a2aMukQHkDeYh+eEepXB2zCYb/RsKgbpWFD27bPbjs=;
	b=UAoNICME/r3MRFt1Qdv4YDWL8FEIchrXmU0/mr30p163m8MVPsgZVYVGxE3g1eCvZZdJvx
	Eoj+cKuqfUWRP+2BikM1fLYbJr5iwKACrTF9gIps5nFPHBC+6Cv4FC0phEfqzPmEiFSMJd
	GTIBCLvNy5M1019Xiah4JswysMjYeMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791078128;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6a2aMukQHkDeYh+eEepXB2zCYb/RsKgbpWFD27bPbjs=;
	b=uPMAe7uNaFkxqJjXPjtZhFmrTFnc4MiN4w55XDfQgeHYL8rMwspWlDyxDtbxJXl6T+Xevy
	G9DZc9JKY3D9KwAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UAoNICME;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=uPMAe7uN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791078128; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6a2aMukQHkDeYh+eEepXB2zCYb/RsKgbpWFD27bPbjs=;
	b=UAoNICME/r3MRFt1Qdv4YDWL8FEIchrXmU0/mr30p163m8MVPsgZVYVGxE3g1eCvZZdJvx
	Eoj+cKuqfUWRP+2BikM1fLYbJr5iwKACrTF9gIps5nFPHBC+6Cv4FC0phEfqzPmEiFSMJd
	GTIBCLvNy5M1019Xiah4JswysMjYeMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791078128;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6a2aMukQHkDeYh+eEepXB2zCYb/RsKgbpWFD27bPbjs=;
	b=uPMAe7uNaFkxqJjXPjtZhFmrTFnc4MiN4w55XDfQgeHYL8rMwspWlDyxDtbxJXl6T+Xevy
	G9DZc9JKY3D9KwAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A333813278;
	Sun,  4 Oct 2026 01:42:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CzJhDO6uwWo2bgAAD6G6ig:T2
	(envelope-from <fmancera@suse.de>); Sun, 04 Oct 2026 01:42:07 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 2/2 nf-next] netfilter: nft_exthdr: avoid 60 bytes stack buffer in TCP option mangling
Date: Sun,  4 Oct 2026 03:41:44 +0200
Message-ID: <20261004014144.4330-2-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261004014144.4330-1-fmancera@suse.de>
References: <20261004014144.4330-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 36AC61FF20
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,suse.de:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

nft_exthdr_tcp_set_eval() and nft_exthdr_tcp_strip_eval() fetched the
TCP header and options through nft_tcp_header_pointer(), which calls
skb_header_pointer() a second time for the full tcphdr_len into a 60
bytes stack buffer. Since commit 28427f368f0e ("netfilter: nft_exthdr:
Fix non-linear header modification") both functions then call
skb_ensure_writable() and re-read the header from skb->data, so the
buffer was never used.

Only the 20 bytes fixed header is needed to learn tcphdr_len, so fetch
just that, validate the length as before, and let skb_ensure_writable()
pull the rest. This also drops the 60 bytes stack buffer from both
functions.

Comparison of performance in mpps:

  op       linear/non-linear     before    after    delta
==================================================================
   set,         non-linear       4.193     4.348    +3.7% mpps
   strip,       non-linear       4.184     4.434    +6.0% mpps
   set,         linear           5.302     5.427    +2.4% mpps
   strip,       linear           5.452     5.527    +1.4% mpss

Comparison of performance in ns/expression:

  op       linear/non-linear     before    after    delta
==================================================================
   set,         non-linear       34.6      25.3     -9.4  ns
   strip,       non-linear       35.2      20.8     -14.3 ns
   set,         linear           23.6      19.7     -3.9  ns
   strip,       linear           22.9      19.8     -3.1  ns

./scripts/bloat-o-meter exthdr_before.o exthdr_after.o
add/remove: 0/1 grow/shrink: 3/0 up/down: 233/-207 (26)
Function                                     old     new   delta
nft_exthdr_tcp_eval                          792     946    +154
nft_exthdr_tcp_strip_eval                    825     891     +66
nft_exthdr_tcp_set_eval                      602     615     +13
nft_tcp_header_pointer.part.constprop        207       -    -207
Total: Before=6527, After=6553, chg +0.40%

This also allow the compiler to inline nft_tcp_header_pointer inside
nft_exthdr_tcp_eval() which could yield some minimal performance gain.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nft_exthdr.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 3492426dccf7..861bab93f435 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -233,16 +233,23 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 				    struct nft_regs *regs,
 				    const struct nft_pktinfo *pkt)
 {
-	u8 buff[sizeof(struct tcphdr) + MAX_TCP_OPTION_SPACE];
 	struct nft_exthdr *priv = nft_expr_priv(expr);
 	unsigned int i, optl, tcphdr_len, offset;
-	struct tcphdr *tcph;
+	struct tcphdr *tcph, _tcph;
 	u8 *opt;
 
-	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
+	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff)
+		goto err;
+
+	tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(_tcph), &_tcph);
 	if (!tcph)
 		goto err;
 
+	tcphdr_len = __tcp_hdrlen(tcph);
+	if (tcphdr_len < sizeof(*tcph) ||
+	    tcphdr_len > sizeof(*tcph) + MAX_TCP_OPTION_SPACE)
+		goto err;
+
 	if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))
 		goto err;
 
@@ -313,16 +320,23 @@ static void nft_exthdr_tcp_strip_eval(const struct nft_expr *expr,
 				      struct nft_regs *regs,
 				      const struct nft_pktinfo *pkt)
 {
-	u8 buff[sizeof(struct tcphdr) + MAX_TCP_OPTION_SPACE];
 	struct nft_exthdr *priv = nft_expr_priv(expr);
 	unsigned int i, tcphdr_len, optl;
-	struct tcphdr *tcph;
+	struct tcphdr *tcph, _tcph;
 	u8 *opt;
 
-	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
+	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff)
+		goto err;
+
+	tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(_tcph), &_tcph);
 	if (!tcph)
 		goto err;
 
+	tcphdr_len = __tcp_hdrlen(tcph);
+	if (tcphdr_len < sizeof(*tcph) ||
+	    tcphdr_len > sizeof(*tcph) + MAX_TCP_OPTION_SPACE)
+		goto err;
+
 	if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))
 		goto drop;
 
-- 
2.55.0

