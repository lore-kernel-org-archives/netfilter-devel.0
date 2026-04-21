Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6403B4C6C
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2026 17:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776793208; cv=none; b=avZTR2mhq/994PyIB5lXtveB3fbG1JQ7QjAIaiXOqUjDuB316YLCpOkeiu7F7KapTGhRW0EPo6xScm5stnrqAyaKmLunDk1/qsNOKUw9zmcpI9jS0xZeFARs/MvKzw4YMo1Yk54FI7PUDnnkg9VEnIFJ95nR7bm0K2gDwsM4Bsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776793208; c=relaxed/simple;
	bh=fmN9ec2CXR4G9rQPY7wmdZcKYopNT2zCLuG9WqhWtNk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SADQhSc29yDqNoSSY+xQVXMwoLw4/igOpN540pdHtsVnQiMrtmh6HNnAq9IhMuhN7dh+zioMz9/KHUlEOz80Dyc2Bkbl+5rAfj4bG7tdwVjSeXT8mmp1G90xVkop4e4ob/s2YJB9ounR9T+K8iai1LrJ2BNdyNqJwU/SnoF3Vys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OGIKaAdu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VTQloidW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iJhc4o06; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eUVvNSEO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OGIKaAdu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VTQloidW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iJhc4o06";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eUVvNSEO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 63F945BD2A;
	Tue, 21 Apr 2026 17:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776793205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=CPp2KyLd/ovGUTDUkDRpkTGGS1w+vXatZrC2mHHUqPM=;
	b=OGIKaAduFIyHA97wBBI6JyCVscOlNN7UXmUHjZqgYlLIAQpAR2szrOQt2gc2jWHUQDmAEq
	UdwrGBWGxS/tEG3UIAc7PqtCQG4dJaH+YNyxP2hNjm63JFniv0BqPXGQNg08kj1RZDeSxD
	FMEpDD5ZcXZIzgtv4tU1C3XRqPyQh7Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776793205;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=CPp2KyLd/ovGUTDUkDRpkTGGS1w+vXatZrC2mHHUqPM=;
	b=VTQloidWpyQam6glY5WG9L5jODwgyNA5nq/kUl92aI7plUbl4exHHShRb0fmFW98HHPIzn
	glrWgG4K0BBEByCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iJhc4o06;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eUVvNSEO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776793204; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=CPp2KyLd/ovGUTDUkDRpkTGGS1w+vXatZrC2mHHUqPM=;
	b=iJhc4o06/fRoIBjTRkuAvCa5dlYcCTWVwcdXPRwJ4akDDDiFmOusfoidkV+VxlDNq8HeyQ
	C2t3W/s2EDP0uHFbm5wVrxmnZRGXq/DAhj7diT4hJS7fhSsNYsPtyUcmhuYr1OgnOSDRkf
	cmvK8oaG6Xb/KGYNgbARdjiJF5A15fI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776793204;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=CPp2KyLd/ovGUTDUkDRpkTGGS1w+vXatZrC2mHHUqPM=;
	b=eUVvNSEOczJ3j5MwIKjkiM+jfooafxRGrIyiH5dq4dTiyWi6PahU19MJQ/ENSNsWLXc/fp
	M6eXmJbtQgwY9hAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D6895593AF;
	Tue, 21 Apr 2026 17:40:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AZaTMHO252lxBQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 21 Apr 2026 17:40:03 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	jeremy@azazel.net,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf] netfilter: nft_bitwise: fix dst corruption in same register shifts
Date: Tue, 21 Apr 2026 19:38:52 +0200
Message-ID: <20260421173851.7945-2-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 63F945BD2A

For lshift and rshift, the shift operations are performed in a loop over
32-bit words. The loop calculates the shifted value and write it to dst,
and then immediately reads from src to calculate the carry for the next
iteration. Because src and dst could point to the same memory location,
the carry is incorrectly calculated using the newly modified dst value
instead of the original src value.

Adding a temporal local variable to cache the original value before
writing to dst and using it for the carry calculation solves the
problem. This was tested with the following payload:

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
Note: I found this issue while digging into the lshift/rshift operation
---
 net/netfilter/nft_bitwise.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 13808e9cd999..136e8f3a71c5 100644
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
 
-- 
2.53.0

