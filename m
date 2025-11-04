Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6065E3385B3
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Nov 2025 17:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762276844; cv=none; b=hWZzC52Ndr5750SVLFDrd+xaCbmy3JVwhRGSAaNsW3QDjM4Vg5eMU2hjoIsZm/+F9cfYfIzK5X1Khz5M//dsT0cmlU0EGehIXO8V+7agvy87GI3OJhZ+M38PaJdtAZZzhUmFwXOkK8APmb5FP9bF0bu/AOP1JthtpegZTrnrhVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762276844; c=relaxed/simple;
	bh=r+pjShIEphTN0cRwQhtJNKOQAeI+TyZNSyNTjLthkVM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T8WosRi+eVR/X6ALoC/WcEwtjdrHSBY5m/inEpb1giDPrJWO0RaRYxiVCbDNIpN/gI84BwyH0HCoOGRZm6hq4156pOLw+8zeckENB/HDBjJuOzQ6FC/Q17wrHuM9xG7exJtWFTyRRD5/Kv2v8AFdVCb9Y7HT7adCXn62ngeW8Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2DNSeFBv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Egi+n5yI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2DNSeFBv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Egi+n5yI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2DNSeFBv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Egi+n5yI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2DNSeFBv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Egi+n5yI"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 01C7F2118E;
	Tue,  4 Nov 2025 17:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762276839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=llM4dEjmHk0mOFrlm0PNyq3y2b8JFQgFWFBGAtDudpY=;
	b=2DNSeFBv72FHK21cYPv4VdDk0eAZEdTmiHCcMdlZSqtTY1UyQi1WrWSmhIV9C3d+wM46/r
	E7AhYWlIwhwn6QYWC1hTqOck7RXWqv/zv3VJXXwSpmS7s85fzZKAyRUFKTdXFi3wzqy9/i
	MJMamZYqwFyDIAighFcTbXWTLpq2244=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762276839;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=llM4dEjmHk0mOFrlm0PNyq3y2b8JFQgFWFBGAtDudpY=;
	b=Egi+n5yIRtBlV8rnDM1oYRASuBxRff4sWa1Yc39ovS7UPXbAvRXOUnAwrMAQrg6WyyxLBv
	NRhTu0W2kb44uOBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2DNSeFBv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Egi+n5yI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762276839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=llM4dEjmHk0mOFrlm0PNyq3y2b8JFQgFWFBGAtDudpY=;
	b=2DNSeFBv72FHK21cYPv4VdDk0eAZEdTmiHCcMdlZSqtTY1UyQi1WrWSmhIV9C3d+wM46/r
	E7AhYWlIwhwn6QYWC1hTqOck7RXWqv/zv3VJXXwSpmS7s85fzZKAyRUFKTdXFi3wzqy9/i
	MJMamZYqwFyDIAighFcTbXWTLpq2244=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762276839;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=llM4dEjmHk0mOFrlm0PNyq3y2b8JFQgFWFBGAtDudpY=;
	b=Egi+n5yIRtBlV8rnDM1oYRASuBxRff4sWa1Yc39ovS7UPXbAvRXOUnAwrMAQrg6WyyxLBv
	NRhTu0W2kb44uOBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B7F9B139A9;
	Tue,  4 Nov 2025 17:20:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YEQoKuY1CmlkegAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 04 Nov 2025 17:20:38 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next] netfilter: nft_connlimit: add support to object update operation
Date: Tue,  4 Nov 2025 18:20:25 +0100
Message-ID: <20251104172025.29752-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 01C7F2118E
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -3.01

This is useful to update the limit or flags without clearing the
connections tracked.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nft_connlimit.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 92b984fa8175..c723bdf76d1b 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -137,6 +137,16 @@ static int nft_connlimit_obj_init(const struct nft_ctx *ctx,
 	return nft_connlimit_do_init(ctx, tb, priv);
 }
 
+static void nft_connlimit_obj_update(struct nft_object *obj,
+				     struct nft_object *newobj)
+{
+	struct nft_connlimit *newpriv = nft_obj_data(newobj);
+	struct nft_connlimit *priv = nft_obj_data(obj);
+
+	priv->limit = newpriv->limit;
+	priv->invert = newpriv->invert;
+}
+
 static void nft_connlimit_obj_destroy(const struct nft_ctx *ctx,
 				      struct nft_object *obj)
 {
@@ -166,6 +176,7 @@ static const struct nft_object_ops nft_connlimit_obj_ops = {
 	.init		= nft_connlimit_obj_init,
 	.destroy	= nft_connlimit_obj_destroy,
 	.dump		= nft_connlimit_obj_dump,
+	.update		= nft_connlimit_obj_update,
 };
 
 static struct nft_object_type nft_connlimit_obj_type __read_mostly = {
-- 
2.51.0

