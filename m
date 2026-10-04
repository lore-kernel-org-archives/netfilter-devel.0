Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7762A223DFF;
	Sun,  4 Oct 2026 01:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791078130; cv=none; b=awzyY0f4rcG9uKIfSrz3QeeYJMkCvPmkYpzgSXi7RvLMCJyMoJQg9S76y+g4uRwi1UzieaAxhQH2jhZ8leDCOOiwBt3PV+s6SwDcB2et+Hph4BP/cfcCJbcewhs/e/GkK5gou0c9nzxTzMqsXSkBHH1tVcUxmBOO8AJdu1Ld0vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791078130; c=relaxed/simple;
	bh=SkmL4H2+mE2w8hWZn9dPC8p+xt3LtTDMKO5gKPJCT8w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NHL4zLX1A08n2h4WxLT4b98JSKvH5RieT4GUcW35X9vCYVKr6w+zv5psKFGMmumpz0M7B+YkNgbTilQknfUyvwcQFQW3YhG76XLu4JnC9P4s8t53AW4j4euc40KL7sEWF052mYVKqNHh/NU+5iaugtyYlYF6Ofm/iHvaHfL3FD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nilRwMde; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+hAwygwt; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nilRwMde; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+hAwygwt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nilRwMde";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+hAwygwt";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nilRwMde";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+hAwygwt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2123A21DC5;
	Sun,  4 Oct 2026 01:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791078127; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/uxbj1zYJKXk/v6NsOO/onVjnoOHdrVakatx0Be/ji8=;
	b=nilRwMdeJ01FGJMRQkINZCEhBD2dNaOEJx3/JwW4uVOAN5TeUTVnpE7o2dwp4cxcNEKs79
	JEi6Keqwfmf+WtLWAGsqZ0A9utwwQZVMbfZLC3SZqk9SqNAWw/KLc1SM7k14wBh6WXCG9L
	D3sBYnq5hxh/CaTum/F4pgr/N9wFHs8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791078127;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/uxbj1zYJKXk/v6NsOO/onVjnoOHdrVakatx0Be/ji8=;
	b=+hAwygwteqFT+kFanD3xPFEVDxLYcQnaVAH9IQBlpft5Y/3T8lMB7eZqxE4ngBUuNi4Zbj
	GbLmHpePsA8TuJAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nilRwMde;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+hAwygwt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791078127; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/uxbj1zYJKXk/v6NsOO/onVjnoOHdrVakatx0Be/ji8=;
	b=nilRwMdeJ01FGJMRQkINZCEhBD2dNaOEJx3/JwW4uVOAN5TeUTVnpE7o2dwp4cxcNEKs79
	JEi6Keqwfmf+WtLWAGsqZ0A9utwwQZVMbfZLC3SZqk9SqNAWw/KLc1SM7k14wBh6WXCG9L
	D3sBYnq5hxh/CaTum/F4pgr/N9wFHs8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791078127;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/uxbj1zYJKXk/v6NsOO/onVjnoOHdrVakatx0Be/ji8=;
	b=+hAwygwteqFT+kFanD3xPFEVDxLYcQnaVAH9IQBlpft5Y/3T8lMB7eZqxE4ngBUuNi4Zbj
	GbLmHpePsA8TuJAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63BE713278;
	Sun,  4 Oct 2026 01:42:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CzJhDO6uwWo2bgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sun, 04 Oct 2026 01:42:06 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 1/2 nf-next] netfilter: nft_exthdr: remove redundant op parsing in tcp_set_init
Date: Sun,  4 Oct 2026 03:41:43 +0200
Message-ID: <20261004014144.4330-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 2123A21DC5
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

The nft_exthdr_tcp_set_init() function is exclusively used for TCP
options. Therefore, parsing the NFTA_EXTHDR_OP attribute from user
space is redundant, as the operation type must always be
NFT_EXTHDR_OP_TCPOPT.

Remove the unnecessary netlink attribute parsing and hardcode priv->op
to NFT_EXTHDR_OP_TCPOPT, which simplifies the code and reduces the
object size.

./scripts/bloat-o-meter exthdr_before.o exthdr_after.o
add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-54 (-54)
Function                                     old     new   delta
nft_exthdr_tcp_set_init                      412     358     -54
Total: Before=6581, After=6527, chg -0.82%

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nft_exthdr.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 8abf8e8145ce..3492426dccf7 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -551,7 +551,7 @@ static int nft_exthdr_tcp_set_init(const struct nft_ctx *ctx,
 				   const struct nlattr * const tb[])
 {
 	struct nft_exthdr *priv = nft_expr_priv(expr);
-	u32 offset, len, flags = 0, op = NFT_EXTHDR_OP_IPV6;
+	u32 offset, len, flags = 0;
 	int err;
 
 	if (!tb[NFTA_EXTHDR_SREG] ||
@@ -581,15 +581,11 @@ static int nft_exthdr_tcp_set_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	err = nft_parse_u32_check(tb[NFTA_EXTHDR_OP], U8_MAX, &op);
-	if (err < 0)
-		return err;
-
 	priv->type   = nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
 	priv->offset = offset;
 	priv->len    = len;
 	priv->flags  = flags;
-	priv->op     = op;
+	priv->op     = NFT_EXTHDR_OP_TCPOPT;
 
 	return nft_parse_register_load(ctx, tb[NFTA_EXTHDR_SREG], &priv->sreg,
 				       priv->len);
-- 
2.55.0

