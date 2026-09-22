Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794A5560AB0
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 16:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790095291; cv=none; b=LkGHTBbmMu945HEzcLU2fhbeMMrIZSZ1rLvPM6l/zfdif8uXB+uewxpxPGZeXEe8qcsKPIVsNwBXyoPTIboFg3iPGYKa9b6i2XCaj6vBEAXxgAeo6JAY+vxwJtkXFQAnj3M6J7G2yKGUG7fZrcrPTDVEPdABH5m7/kPlB7OHFU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790095291; c=relaxed/simple;
	bh=CxK7kAIlmhVrpy13Tgf/+rDMLYhuJ/fcNHwVLNLSqZs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A379M+1LCgR+oTmQOB1RG6uVadZTsRf7TBMK4yAOXbnqVlA8jhhmiAznXTlQ9ZJlHBHTEDaOKTaKMg00ILsqYz59RejqT9ZEWfPru5xHW9RDBqMq1uPXBl5Go+7z8JcvKgrAexZNgmqrqsveVSoqM96sBfqM9okki4CtQzc2gZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=s9JTh/+1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ol3fcHWJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cE7+Usws; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zywDZ65S; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="s9JTh/+1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ol3fcHWJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cE7+Usws";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zywDZ65S"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 36EB521D99;
	Tue, 22 Sep 2026 16:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790095284; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=o92RDs3+5OR79bvIM3LPSH1yi+hqorzRDQPotPzoxD4=;
	b=s9JTh/+1GtQEP5kqpx32U8CqFs5v06ESeaoS2cVxe886tb8W6aPkufvCuxQb5Th3AGnOtz
	3IUOSouIEN5zh182vMEDefyWDfvceVML7HTEFE4CjK+JGGGAGM+YT8Nn5rg8rQo8UgXrDt
	U5oqsC7SQgkw37VwiFNUVePYZA3ucBM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790095284;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=o92RDs3+5OR79bvIM3LPSH1yi+hqorzRDQPotPzoxD4=;
	b=ol3fcHWJZGP9974n1Y9weG0CDwQafeXR+/DQ8zCjy1Eu3pyceyx5ILiGLKxE47Lnzey09q
	29LfHyDdqdlXMgAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790095280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=o92RDs3+5OR79bvIM3LPSH1yi+hqorzRDQPotPzoxD4=;
	b=cE7+Usws6CbGLrRfvMbYXILiHN0LC9TBNNT369LnOp89goZjSitrYXkd9jtPvDmOyXyUAx
	TkgSpA4K+NKvBu7jIuSPkLU8gi/oSfCUM5orozxnyq670ft3WmZwPCDPKl/Az37tc3NOF3
	fze2WxLCn6q84usNLxd65BivKzo/AGI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790095280;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=o92RDs3+5OR79bvIM3LPSH1yi+hqorzRDQPotPzoxD4=;
	b=zywDZ65SLTxI2E+9ACHs1Fnn5ioM/T42Mp0pBoQcdu/tQ0bGSLSdRVMDoWy1wILqN9+64R
	qPSqmQR0xPGNHWCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9E3111365D;
	Tue, 22 Sep 2026 16:41:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1FFLGa+vsmoXSQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 22 Sep 2026 16:41:19 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next] netfilter: nft_nat: use the right enum members for nat type switch
Date: Tue, 22 Sep 2026 18:40:59 +0200
Message-ID: <20260922164059.4320-1-fmancera@suse.de>
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
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

The member 'type' from struct 'nft_nat' is of type enum
nf_nat_manip_type but at the switch statements for
nft_nat_setup_netmap() and nft_nat_validate() functions the members from
nft_nat_types enum were used instead.

This does not cause any problem but is worth fixing for correctness.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
Note: found this while working on something else but confused for a
bit.. so I guess it is worth fixing.
---
 net/netfilter/nft_nat.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index e32cd9fbc7c2..2691cfb10290 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -70,7 +70,7 @@ static void nft_nat_setup_netmap(struct nf_nat_range2 *range,
 	int i, len = 0;
 
 	switch (priv->type) {
-	case NFT_NAT_SNAT:
+	case NF_NAT_MANIP_SRC:
 		if (nft_pf(pkt) == NFPROTO_IPV4) {
 			new_addr.ip = ip_hdr(skb)->saddr;
 			len = sizeof(struct in_addr);
@@ -79,7 +79,7 @@ static void nft_nat_setup_netmap(struct nf_nat_range2 *range,
 			len = sizeof(struct in6_addr);
 		}
 		break;
-	case NFT_NAT_DNAT:
+	case NF_NAT_MANIP_DST:
 		if (nft_pf(pkt) == NFPROTO_IPV4) {
 			new_addr.ip = ip_hdr(skb)->daddr;
 			len = sizeof(struct in_addr);
@@ -152,12 +152,12 @@ static int nft_nat_validate(const struct nft_ctx *ctx,
 		return err;
 
 	switch (priv->type) {
-	case NFT_NAT_SNAT:
+	case NF_NAT_MANIP_SRC:
 		err = nft_chain_validate_hooks(ctx->chain,
 					       (1 << NF_INET_POST_ROUTING) |
 					       (1 << NF_INET_LOCAL_IN));
 		break;
-	case NFT_NAT_DNAT:
+	case NF_NAT_MANIP_DST:
 		err = nft_chain_validate_hooks(ctx->chain,
 					       (1 << NF_INET_PRE_ROUTING) |
 					       (1 << NF_INET_LOCAL_OUT));
-- 
2.55.0

