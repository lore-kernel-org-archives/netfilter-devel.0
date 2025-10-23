Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2321E27B324
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 23:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761261669; cv=none; b=joAdBdcP6qRX/lmbPqOfexxYHf5rS1SXNig4SOeYhvmHWsWq9raTv6Sb2XYSwz0cw/DgGTRAfyh8K2AwVIkLmFf4hezMcjDvhNDPDm0xI8HIpY4eM8tn3Q2qx4djJuKMDsDNY15uGJywbSNP1Q39xHxKWqJ0evVZqQp4eS1zmvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761261669; c=relaxed/simple;
	bh=lTRarRf1MKqe78HtHd+BO7JQhpWWJiFQ9w+ykyAsrM8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CSbqPZaaBaBlqtqiwoo+l6qwoVeoU8uE+eVbJD5o/p3DKTnNmN0RswyWutoV9nBkUwDE3193oZkHaLVZlNq1rFcFB/oBIMCAOowUT97x7AxNVq/9ZyZQ3sPBgRKFFDYCN29t3oziMap4QzEER3t/kCy7b/USH5lkkLqgoQS098s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CtYpUKxU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Hzk4yVDW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=X2m0QQpY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mCNLbjKo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CtYpUKxU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Hzk4yVDW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="X2m0QQpY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mCNLbjKo"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E901F1F38D;
	Thu, 23 Oct 2025 23:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761261659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pBNF4D7adR2uWuIMpr5bM8Oxpfw8RgB8TffhTZgvxCQ=;
	b=CtYpUKxU2GuAp5oA76PfQYsX1hJrEyHgW0eylTSvzSyqc3vfYKJA9M7BsIu9gqji2Fyzey
	7viVTziD/OjDzbC67HAX2oFsZmM+uXgTrZbovRNp2GpjukhCdjqEYRwFkQdmQXaODRgtAj
	LykR4b2Uxr2VA+3CbQ++KRU9Bm3PSoI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761261659;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pBNF4D7adR2uWuIMpr5bM8Oxpfw8RgB8TffhTZgvxCQ=;
	b=Hzk4yVDWQTGKGBpLJ54dExxGkJr9QkjIi22HkYZBQY2YRIu09Wo58W7Q7FVWNxGBuXc419
	9IMhV/8kLw7yZ5Ag==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761261654; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pBNF4D7adR2uWuIMpr5bM8Oxpfw8RgB8TffhTZgvxCQ=;
	b=X2m0QQpYIC0rcUAGVA4NRm6S10irNKdBn8xvuF0WVQOO6c3Fi5/U9NrpebKH1GKu3epVRS
	uK3IHnqeB32/hIkoKdrlvR3+twk5YE12xXysPEq+RHsComjJMH54gWo19Uc61f5Zd1OrbN
	lYw2gOzn5PRMurecR+SLKkGvW/8I2YY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761261654;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pBNF4D7adR2uWuIMpr5bM8Oxpfw8RgB8TffhTZgvxCQ=;
	b=mCNLbjKoTgFA9S34geJR2TXkL/YKpxIgtBIWkMMmUnjnMxDURgK3mYDGed7oWx7uxhGYli
	Q54XWIS9r30seHAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5586213285;
	Thu, 23 Oct 2025 23:20:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oM0WD1a4+miOVQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 23 Oct 2025 23:20:54 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	louis.t42@caramail.com,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf] netfilter: nft_connlimit: fix stale read of connection count
Date: Fri, 24 Oct 2025 01:20:37 +0200
Message-ID: <20251023232037.3777-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[netfilter.org,caramail.com,suse.de];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email];
	FREEMAIL_ENVRCPT(0.00)[caramail.com]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

nft_connlimit_eval() reads priv->list->count to check if the connection
limit has been exceeded. This value can be cached by the CPU while it
can be decremented by a different CPU when a connection is closed. This
causes a data race as the value cached might be outdated.

When a new connection is established and evaluated by the connlimit
expression, priv->list->count is incremented by nf_conncount_add(),
triggering the CPU's cache coherency protocol and therefore refreshing
the cached value before updating it.

Solve this situation by reading the value using READ_ONCE().

Fixes: df4a90250976 ("netfilter: nf_conncount: merge lookup and add functions")
Closes: https://lore.kernel.org/netfilter/trinity-85c72a88-d762-46c3-be97-36f10e5d9796-1761173693813@3c-app-mailcom-bs12/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nft_connlimit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 92b984fa8175..fc35a11cdca2 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -48,7 +48,7 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 		return;
 	}
 
-	count = priv->list->count;
+	count = READ_ONCE(priv->list->count);
 
 	if ((count > priv->limit) ^ priv->invert) {
 		regs->verdict.code = NFT_BREAK;
-- 
2.51.0

