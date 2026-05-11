Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35233FF899
	for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2026 14:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778510294; cv=none; b=gdjDbXiewBGyc2WP7dxpoMzpVtwipRX1QowwH7G9xHykj4Mi6OcHYI1txOb/gUk4Ow0aYTWJJGZk1Uga/bA6BXxknWxXOhngQvK4YJF87dchBvFuE4kGOoUoIeNtVLVvPhprEQ7Gp0X95CZ+CIhIb9qYRzibfxVtf7vGr3bNKaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778510294; c=relaxed/simple;
	bh=uYH1wsW5f43MjCazGCSXGrXE5ZSVKCl8KLBfdZvK4nM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VBAx7wpu3kNwWB+Bd6FQHWXc8lDopBkunovl4DNQ058XigFulyvOCo6ojIAvEsUkj9cyzNCXu1YngLNSPfyPfNiv2AtBkpubFrnhaaBJoip8HwY11uWcdYD5fa0l4pD8Ol65XtK0zEgVteRbcVYYPmhph7nHDt/pw6iOdhqGUVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XBV7WJ7H; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kWdmASm4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OoEvfHDd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bA5RlW84; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XBV7WJ7H";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kWdmASm4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OoEvfHDd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bA5RlW84"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 079536B59C;
	Mon, 11 May 2026 14:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778510290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uZ/7uxkVnPv/UEI/wx8KMIWyOjWD/XpIsgDjUVmdlBQ=;
	b=XBV7WJ7HLARm/AD7CB+O9d2GwmFtmXX0Q+3Q04YNnFNZuzGnuhpgrKVHEl0h3DI7ChfBeD
	hVDRF7qresDjp2lCR8n8O4/wUjp7cx661GKDvljzXl5Wi29iM+cg50U02VNdgRvQEFKIDE
	Fz1KtBmigOAD0FJuW9fCm59qqGgakmA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778510290;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uZ/7uxkVnPv/UEI/wx8KMIWyOjWD/XpIsgDjUVmdlBQ=;
	b=kWdmASm4bEcdoOvJisadTyp17ik4Xa090eblcmLSnnUbpZbC3HBCnjChts8QtOjDp8fE5H
	BY6vLRKbJQPflGBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OoEvfHDd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bA5RlW84
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778510289; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uZ/7uxkVnPv/UEI/wx8KMIWyOjWD/XpIsgDjUVmdlBQ=;
	b=OoEvfHDdpNynxUXOEYZhU4CaEnP6cLHtcu+R+AX81cTi0J+3ZKaMZ3wAsnLXt91FHodyMb
	/cQgAAnUm/609rpEUD+63vqybUxyNY9sJoKEivHReSJqELqQwzPGMz8DsdI4OHD8W2/0iB
	CPOREqnDuzqbonWUji5TT3w8TCun0VE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778510289;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uZ/7uxkVnPv/UEI/wx8KMIWyOjWD/XpIsgDjUVmdlBQ=;
	b=bA5RlW84MdF1i+FgatMUASga88+Omt578W4QG4b2YPacv/ZQGbCkakw0PISIOVeRLhBFgt
	cRqjb39zakuZebCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 84F79593A3;
	Mon, 11 May 2026 14:38:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id u9N5HdDpAWo5bAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 11 May 2026 14:38:08 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	jeremy@azazel.net,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf v4] netfilter: nf_tables: fix dst corruption in same register operation
Date: Mon, 11 May 2026 16:37:56 +0200
Message-ID: <20260511143756.7220-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim,suse.de:mid]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 079536B59C
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
all kind of operations including byteorder. This was tested with the
following bytecode:

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
Acked-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: handled partially register overlap
v3: reject partially overlap from control plane, added back Acked-by
from Jeremy Snowden as he provided it for v1
v4: move the check to a helper and use it for sreg2 and also byteorder
operations as suggested by Pablo
---
 include/net/netfilter/nf_tables.h |  7 +++++++
 net/netfilter/nft_bitwise.c       | 18 ++++++++++++++----
 net/netfilter/nft_byteorder.c     | 13 ++++++++++---
 3 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index cff7b773e972..9d844354c4d9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -180,6 +180,13 @@ static inline u64 nft_reg_load64(const u32 *sreg)
 	return get_unaligned((u64 *)sreg);
 }
 
+static inline bool nft_reg_overlap(u8 src, u8 dst, u32 len)
+{
+	unsigned int n = DIV_ROUND_UP(len, sizeof(u32));
+
+	return src != dst && src < dst + n && dst < src + n;
+}
+
 static inline void nft_data_copy(u32 *dst, const struct nft_data *src,
 				 unsigned int len)
 {
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 94dccdcfa06b..785b8e9731d1 100644
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
 
@@ -235,6 +239,9 @@ static int nft_bitwise_init_bool(const struct nft_ctx *ctx,
 					      &priv->sreg2, priv->len);
 		if (err < 0)
 			return err;
+
+		if (nft_reg_overlap(priv->sreg2, priv->dreg, priv->len))
+			return -EINVAL;
 	}
 
 	return 0;
@@ -265,6 +272,9 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	if (nft_reg_overlap(priv->sreg, priv->dreg, priv->len))
+		return -EINVAL;
+
 	if (tb[NFTA_BITWISE_OP]) {
 		priv->op = ntohl(nla_get_be32(tb[NFTA_BITWISE_OP]));
 		switch (priv->op) {
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index e00dddfa2fc0..2316c77f4228 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -144,9 +144,16 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	return nft_parse_register_store(ctx, tb[NFTA_BYTEORDER_DREG],
-					&priv->dreg, NULL, NFT_DATA_VALUE,
-					priv->len);
+	err = nft_parse_register_store(ctx, tb[NFTA_BYTEORDER_DREG],
+				       &priv->dreg, NULL, NFT_DATA_VALUE,
+				       priv->len);
+	if (err < 0)
+		return err;
+
+	if (nft_reg_overlap(priv->sreg, priv->dreg, priv->len))
+		return -EINVAL;
+
+	return 0;
 }
 
 static int nft_byteorder_dump(struct sk_buff *skb,
-- 
2.53.0

