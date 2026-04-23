Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6745C26738D
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 15:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776959709; cv=none; b=VLtkWtcUhz1Jgveqj99YTIpp+GFxONw6kMriigzOSKKhxXDeVd9GbTOxsL//VZD0hJSY7BGAdUe/+bRNJM5xZ0o4e8RWhjSSBUnud047dszezNIQWCQ0pEgyv1ThSzWPHpBlZMlHqS5wNTRnvlPY0w12gZf/0AtWrSNmh306Vok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776959709; c=relaxed/simple;
	bh=2VF/N28Sc6OmVKvS1jHYF42AAcYQw/5oGBJoyuO9OYw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IDZyiNBbYbKTkuttumAOjALjur5DyLU1JwAIQEAeWVY6RAqKrLP8VuY6m862yYx+vMbZQWNFYHlBkj8o/IlLhorFx0AA7QwskVm0rRtmieAGJKKC4hNjb3VVFf1Ol7vLGXOY3MM3ROiZu6wggaLuuwN3EsL5zVZCSFBQ+P2IvzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=diNSikBq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=neyORW8b; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=diNSikBq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=neyORW8b; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="diNSikBq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="neyORW8b";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="diNSikBq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="neyORW8b"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9762B6A882;
	Thu, 23 Apr 2026 15:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776959705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=YlZVZ+d4uNyokqlcnGcDE3g52q6N182GVtkbAYIj2PU=;
	b=diNSikBqyGf50RvrTVZOJ1yrRZ7VfbTEpbuhgvUkaZbdyo0bcKod31QavJCYuL3csmwqoS
	bBV82M3k98KTX9+Mt6XVmVPTzSodr5ccMTXKKBOStjFYLPiUONrXmLpmbjGuuhymYYUz1r
	Xk2Pe3TB1h+rgBr5oLHqjdOZFQC9IJk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776959705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=YlZVZ+d4uNyokqlcnGcDE3g52q6N182GVtkbAYIj2PU=;
	b=neyORW8bt38oYbidfBRePaRm5iUOkkxy+QaZxHwt8OMP9aCMJAjUVIddxrgzBGWM1kYZEw
	zNcU5GzpAMnSTaAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776959705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=YlZVZ+d4uNyokqlcnGcDE3g52q6N182GVtkbAYIj2PU=;
	b=diNSikBqyGf50RvrTVZOJ1yrRZ7VfbTEpbuhgvUkaZbdyo0bcKod31QavJCYuL3csmwqoS
	bBV82M3k98KTX9+Mt6XVmVPTzSodr5ccMTXKKBOStjFYLPiUONrXmLpmbjGuuhymYYUz1r
	Xk2Pe3TB1h+rgBr5oLHqjdOZFQC9IJk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776959705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=YlZVZ+d4uNyokqlcnGcDE3g52q6N182GVtkbAYIj2PU=;
	b=neyORW8bt38oYbidfBRePaRm5iUOkkxy+QaZxHwt8OMP9aCMJAjUVIddxrgzBGWM1kYZEw
	zNcU5GzpAMnSTaAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2E12C593A3;
	Thu, 23 Apr 2026 15:55:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GayFCNlA6mkKQwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 23 Apr 2026 15:55:05 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	jeremy@azazel.net,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf v3] netfilter: nft_bitwise: fix dst corruption in same register shifts
Date: Thu, 23 Apr 2026 17:54:53 +0200
Message-ID: <20260423155453.7499-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.988];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

For lshift and rshift, the shift operations are performed in a loop over
32-bit words. The loop calculates the shifted value and write it to dst,
and then immediately reads from src to calculate the carry for the next
iteration. Because src and dst could point to the same memory location,
the carry is incorrectly calculated using the newly modified dst value
instead of the original src value.

Adding a temporary local variable to cache the original value before
writing to dst and using it for the carry calculation solves the
problem. In addition, partial overlap is rejected from control plane.
This was tested with the following bytecode:

table test_table ip flags 0 use 1 handle 1
ip test_table test_chain use 3 type filter hook input prio 0 policy accept packets 0 bytes 0 flags 1
ip test_table test_chain 2
  [ immediate reg 1 0x44332211 0x88776655 ]
  [ bitwise reg 1 = ( reg 1 << 0x08000000 ) ]
  [ cmp eq reg 1 0x66443322 0x00887766 ]
  [ counter pkts 0 bytes 0 ]
ip test_table test_chain 4 3
  [ immediate reg 1 0x44332211 0x88776655 ]
  [ bitwise reg 1 = ( reg 1 << 0x08000000 ) ]
  [ cmp eq reg 1 0x55443322 0x00887766 ]
  [ counter pkts 21794 bytes 1917798 ]

Fixes: 567d746b55bc ("netfilter: bitwise: add support for shifts.")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Acked-by: Jeremy Sowden <jeremy@azazel.net>
---
v2: handled partially register overlap
v3: reject partially overlap from control plane, added back Acked-by
from Jeremy Snowden as he provided it for v1
---
 net/netfilter/nft_bitwise.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 13808e9cd999..c1a3e690f4a4 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -43,8 +43,10 @@ static void nft_bitwise_eval_lshift(u32 *dst, const u32 *src,
 	u32 carry = 0;
 
 	for (i = DIV_ROUND_UP(priv->len, sizeof(u32)); i > 0; i--) {
-		dst[i - 1] = (src[i - 1] << shift) | carry;
-		carry = src[i - 1] >> (BITS_PER_TYPE(u32) - shift);
+		u32 tmp_src = src[i - 1];
+
+		dst[i - 1] = (tmp_src << shift) | carry;
+		carry = tmp_src >> (BITS_PER_TYPE(u32) - shift);
 	}
 }
 
@@ -56,8 +58,10 @@ static void nft_bitwise_eval_rshift(u32 *dst, const u32 *src,
 	u32 carry = 0;
 
 	for (i = 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++) {
-		dst[i] = carry | (src[i] >> shift);
-		carry = src[i] << (BITS_PER_TYPE(u32) - shift);
+		u32 tmp_src = src[i];
+
+		dst[i] = carry | (tmp_src >> shift);
+		carry = tmp_src << (BITS_PER_TYPE(u32) - shift);
 	}
 }
 
@@ -177,6 +181,7 @@ static int nft_bitwise_init_mask_xor(struct nft_bitwise *priv,
 static int nft_bitwise_init_shift(struct nft_bitwise *priv,
 				  const struct nlattr *const tb[])
 {
+	unsigned int n = DIV_ROUND_UP(priv->len, sizeof(u32));
 	struct nft_data_desc desc = {
 		.type	= NFT_DATA_VALUE,
 		.size	= sizeof(priv->data),
@@ -201,6 +206,11 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
 		return -EINVAL;
 	}
 
+	if (priv->sreg != priv->dreg &&
+	    priv->dreg < priv->sreg + n &&
+	    priv->sreg < priv->dreg + n)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.53.0

