Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9543E3B19BA
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 09:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777281722; cv=none; b=fuwlU/1Uj3Ua7FBoSrH5plSV2fNCq4pXQWVBcVcs5vuqo1DSvYeir0fs50Pde/2jDBa/3COSExr9iE3bQUqrtbNt5W1Cg1eqJvPX/r9t22ZGiQlYAz7pt+r1hTIiqjbH/mzMOfA4Ak6IqHB3QqNMxQPBfQV9aJIPYyGDryLHhSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777281722; c=relaxed/simple;
	bh=eCn3k8u/63/LHwU0IpVlIKdIDI/o5V1LiBuq5/heX5M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=miB6wHRw1K+MrqFCww7fIelxe+kxTczZ9SEE//RX/kpWyRZO5KDWIcqdMA32MZAxvMUB8itkbMgwUjKo+l3df/HkGW/zjBCFWqDzxNUmh/wieKz0MbXg3CRUEbB4XsFedmgR9Bc0CwrFcKBcrfelqsQG6toahBgVBZr3jbdY1BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cOW3K+Jw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=t7pWqeIV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cOW3K+Jw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=t7pWqeIV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cOW3K+Jw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="t7pWqeIV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cOW3K+Jw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="t7pWqeIV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3F4985BCCD;
	Mon, 27 Apr 2026 09:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777281717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=k5y3pjY1aXRQOQV4DE2hjR7vsDXg5H9bmpiES3KwAB8=;
	b=cOW3K+JwboD0xyIqMjgKHowG4D0LPbTuZaf82PgEpus14FwbQApj9WpwN8niKQvHgi+lO2
	8g/7+fk7z1lyzgVrZXLo8cnIIlm9gFu3bGDNLeC9Ng/dJ366rn+HpnphxKKqdDIAgtPJgV
	O6cseuYCCBYxAzk6PCSNg+ddpntK8K8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777281717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=k5y3pjY1aXRQOQV4DE2hjR7vsDXg5H9bmpiES3KwAB8=;
	b=t7pWqeIVhkDPme/j4RSV3IDo1Ez3M31UBRgJnrPdeY3Lz7O5au389dDmAKPAKMfb4b4q51
	myoKhEysxzTsjHBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cOW3K+Jw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t7pWqeIV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777281717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=k5y3pjY1aXRQOQV4DE2hjR7vsDXg5H9bmpiES3KwAB8=;
	b=cOW3K+JwboD0xyIqMjgKHowG4D0LPbTuZaf82PgEpus14FwbQApj9WpwN8niKQvHgi+lO2
	8g/7+fk7z1lyzgVrZXLo8cnIIlm9gFu3bGDNLeC9Ng/dJ366rn+HpnphxKKqdDIAgtPJgV
	O6cseuYCCBYxAzk6PCSNg+ddpntK8K8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777281717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=k5y3pjY1aXRQOQV4DE2hjR7vsDXg5H9bmpiES3KwAB8=;
	b=t7pWqeIVhkDPme/j4RSV3IDo1Ez3M31UBRgJnrPdeY3Lz7O5au389dDmAKPAKMfb4b4q51
	myoKhEysxzTsjHBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C4701593B0;
	Mon, 27 Apr 2026 09:21:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TcAVLbQq72l2UAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 27 Apr 2026 09:21:56 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	jeremy@azazel.net,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf v4] netfilter: nft_bitwise: fix dst corruption in same register shifts
Date: Mon, 27 Apr 2026 11:21:18 +0200
Message-ID: <20260427092117.4160-2-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid,suse.de:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 3F4985BCCD
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

For lshift and rshift, the shift operations are performed in a loop over
32-bit words. The loop calculates the shifted value and write it to dst,
and then immediately reads from src to calculate the carry for the next
iteration. Because src and dst could point to the same memory location,
the carry is incorrectly calculated using the newly modified dst value
instead of the original src value.

Adding a temporary local variable to cache the original value before
writing to dst and using it for the carry calculation solves the
problem. In addition, partial overlap is rejected from control plane for
all kind of operations. This was tested with the following bytecode:

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
---
v2: handled partially register overlap
v3: reject partially overlap from control plane
v4: applied the partial overlap check to all operations
---
 net/netfilter/nft_bitwise.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 13808e9cd999..76e7ae96429d 100644
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
 
@@ -244,6 +248,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 			    const struct nlattr * const tb[])
 {
 	struct nft_bitwise *priv = nft_expr_priv(expr);
+	unsigned int n;
 	u32 len;
 	int err;
 
@@ -264,6 +269,12 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	n = DIV_ROUND_UP(priv->len, sizeof(u32));
+	if (priv->sreg != priv->dreg &&
+	    priv->dreg < priv->sreg + n &&
+	    priv->sreg < priv->dreg + n)
+		return -EINVAL;
+
 	if (tb[NFTA_BITWISE_OP]) {
 		priv->op = ntohl(nla_get_be32(tb[NFTA_BITWISE_OP]));
 		switch (priv->op) {
-- 
2.53.0

