Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631361DF97C
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Dec 2025 20:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766002948; cv=none; b=GWOG7U8wXduF3q56xR/IVDPOf2e5HNDEm9q7FxD/qE1NhdQv7kl1PEUiN7Uxnz5hbj41K6+GWh7eVr65HB+ZIgejE2Lfie6Xgt0h2+gMQd1xHEi8KcA/cWFajuQK01PKZDRKPFZN17CMFMwRBbPU4AVBM/bvSdcRhMxfCyXAHgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766002948; c=relaxed/simple;
	bh=O0jy1JofaWmpaXzRln8bAJacMHsv2TJSBKikfhrwtB0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ti6KnY5lrPdn5SFXQhsFxvmrN04bDONVHhXQZzoitGIvgKg79G0SJGuy6DNuTxWiAq8IgrGEqDGyVjS11rsu+pqxGz0kgFt/Na1l2CcXlTjLCgDwl2zfm11X6kHx2KGHg7kYKPbFiUAVoPCW4EoFXV6tlJQTgISKbESt9dLJUIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KmPixFlN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TWhqGgYF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=D/s4XdBk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HXMqpyjJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KmPixFlN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TWhqGgYF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="D/s4XdBk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HXMqpyjJ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 77A5B336A0;
	Wed, 17 Dec 2025 20:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766002944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=VhFAPQBYNFBKJPTWLuieU7B7fzavWYzK4aMQQFgyT+E=;
	b=KmPixFlNHD9Xp/T6MsZgpyPQgWBBixC93dUUlW1YEpS/82xYYexSp188mSXxwntpwc8iak
	uEEVVY2wSGvdGzJusph6XSeFBcAf66Ea4wHi376pfT8Kuh5fQqKGcTNh9pgZkbR7Uyl5L0
	Zh5Cz8kkixNHKL0yrk65SeXeAtbl8pw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766002944;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=VhFAPQBYNFBKJPTWLuieU7B7fzavWYzK4aMQQFgyT+E=;
	b=TWhqGgYFHw/vq/Ibo5vSfxGr6JzTBUEnHbhTfklEq5s+e/tI3XLCFJg64ROyqXrTmzBtRD
	lLX0nlUr/CrTUjBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="D/s4XdBk";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HXMqpyjJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766002942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=VhFAPQBYNFBKJPTWLuieU7B7fzavWYzK4aMQQFgyT+E=;
	b=D/s4XdBkTeDaubKAOCgSgrgywacy/MzPyENhlMxA76UbI22z1x1XHQz89IPKYizALxHraJ
	6pzsu5WyNuQIL60fF1saTtNmNaZPk/7ZS08lyeMlsfJ3vOMHkXn47e1wQ9Cv8EZ+pT42bL
	QvFpBIUenTouPdof2r8Y9M1OLa41glE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766002942;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=VhFAPQBYNFBKJPTWLuieU7B7fzavWYzK4aMQQFgyT+E=;
	b=HXMqpyjJIMESy5BZyNWLJqp7cfS3VENfkQSsXpJD3VUXsiqvT/8egVCCyhLAs/UTP78/le
	lANXUdiCpO7S3qAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 30D223EA63;
	Wed, 17 Dec 2025 20:22:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id scz1B/4QQ2ksUAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 17 Dec 2025 20:22:22 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf] netfilter: nft_synproxy: avoid possible data-race on update operation
Date: Wed, 17 Dec 2025 21:21:59 +0100
Message-ID: <20251217202159.5401-1-fmancera@suse.de>
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
X-Rspamd-Queue-Id: 77A5B336A0
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:dkim,suse.de:email];
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
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

During nft_synproxy eval we are reading nf_synproxy_info struct which
can be modified on update operation concurrently. As nf_synproxy_info
struct fits in 32 bits, use READ_ONCE/WRITE_ONCE annotations.

Fixes: ee394f96ad75 ("netfilter: nft_synproxy: add synproxy stateful object support")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nft_synproxy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 5d3e51825985..4d3e5a31b412 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -48,7 +48,7 @@ static void nft_synproxy_eval_v4(const struct nft_synproxy *priv,
 				 struct tcphdr *_tcph,
 				 struct synproxy_options *opts)
 {
-	struct nf_synproxy_info info = priv->info;
+	struct nf_synproxy_info info = READ_ONCE(priv->info);
 	struct net *net = nft_net(pkt);
 	struct synproxy_net *snet = synproxy_pernet(net);
 	struct sk_buff *skb = pkt->skb;
@@ -79,7 +79,7 @@ static void nft_synproxy_eval_v6(const struct nft_synproxy *priv,
 				 struct tcphdr *_tcph,
 				 struct synproxy_options *opts)
 {
-	struct nf_synproxy_info info = priv->info;
+	struct nf_synproxy_info info = READ_ONCE(priv->info);
 	struct net *net = nft_net(pkt);
 	struct synproxy_net *snet = synproxy_pernet(net);
 	struct sk_buff *skb = pkt->skb;
@@ -340,7 +340,7 @@ static void nft_synproxy_obj_update(struct nft_object *obj,
 	struct nft_synproxy *newpriv = nft_obj_data(newobj);
 	struct nft_synproxy *priv = nft_obj_data(obj);
 
-	priv->info = newpriv->info;
+	WRITE_ONCE(priv->info, newpriv->info);
 }
 
 static struct nft_object_type nft_synproxy_obj_type;
-- 
2.51.1

