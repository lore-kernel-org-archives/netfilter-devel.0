Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F73829DB88
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Oct 2025 12:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760444348; cv=none; b=V6EeDGORzrhQrIH5pNKWRJhr7wIK8aroW9IkBeINNQIXQ14RBN9A5iG//oXaNE6yD5kEvCIAAHUg+2w2y6s171oAc2pVYC9shg07Jo3YWu5uqwP4GBuZ/JWcCyJeCXKLrr/qBGncX7BiidkL8jzBZfjs0pi+UT3o/AtiZlVqvjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760444348; c=relaxed/simple;
	bh=4BC7ehqQEdPZYCpTwK4QMd+2JHc1rvAVvvwiE7FUx3A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l5NbFpz8IdV/4lIq9ZDA3mD6xgQ1Tzyhmcv59IarAbCYG9k3ZF9qV3BNaVSb+stFPTuOuFZDqE3pXlyxDC+h0MaUXVYXyAyUpc0PvASvGr1bLhXRnriaKYgtvo0IKuXPkDci4PXON8HLk3ttVYJd6m/FQYcnzG8Mw0kM1VAxyX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DZjTJB1T; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OpQCaPI5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DZjTJB1T; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OpQCaPI5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DZjTJB1T";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OpQCaPI5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DZjTJB1T";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OpQCaPI5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0AA321F391;
	Tue, 14 Oct 2025 12:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760444344; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6n3jDh44kHYF27DUk3xM5BccTwDS65LwioIFM6Tj34A=;
	b=DZjTJB1TdXuUG6pvsVcmiBIVs60IjnrWj96ej11d27UrOWysS/t7VJNyu4IiuDciZge/yF
	riAjgRNLJnxmwrlj6Tsq8zHZBab1lLkE/kGRp1IlE73Hmux3dZWuoH5tVuRqhcqxv3/Yiq
	ePW/G5iQX3H1phUWRKQjUBezIogJaLQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760444344;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6n3jDh44kHYF27DUk3xM5BccTwDS65LwioIFM6Tj34A=;
	b=OpQCaPI5m81/jmSjY6zGUBRzsVJEsUuhTxjxFRNZbyuJBMi6kTsz3CnhdzA2oOM3deFzL2
	mRTa0rfb1Dfuq2CQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DZjTJB1T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OpQCaPI5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760444344; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6n3jDh44kHYF27DUk3xM5BccTwDS65LwioIFM6Tj34A=;
	b=DZjTJB1TdXuUG6pvsVcmiBIVs60IjnrWj96ej11d27UrOWysS/t7VJNyu4IiuDciZge/yF
	riAjgRNLJnxmwrlj6Tsq8zHZBab1lLkE/kGRp1IlE73Hmux3dZWuoH5tVuRqhcqxv3/Yiq
	ePW/G5iQX3H1phUWRKQjUBezIogJaLQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760444344;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6n3jDh44kHYF27DUk3xM5BccTwDS65LwioIFM6Tj34A=;
	b=OpQCaPI5m81/jmSjY6zGUBRzsVJEsUuhTxjxFRNZbyuJBMi6kTsz3CnhdzA2oOM3deFzL2
	mRTa0rfb1Dfuq2CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C1A8D13A44;
	Tue, 14 Oct 2025 12:19:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +gWLLLY/7mixeQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 14 Oct 2025 12:19:02 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH libnftnl v2] expr: meta: introduce ibrhwaddr meta expression
Date: Tue, 14 Oct 2025 14:18:51 +0200
Message-ID: <20251014121851.28882-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0AA321F391
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: rename to ibrhwaddr
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/expr/meta.c                     | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 40bca48..37cd622 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -959,6 +959,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_SDIF: slave device interface index
  * @NFT_META_SDIFNAME: slave device interface name
  * @NFT_META_BRI_BROUTE: packet br_netfilter_broute bit
+ * @NFT_META_BRI_IIFHWADDR: packet input bridge interface ethernet address
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -999,6 +1000,7 @@ enum nft_meta_keys {
 	NFT_META_SDIFNAME,
 	NFT_META_BRI_BROUTE,
 	__NFT_META_IIFTYPE,
+	NFT_META_BRI_IIFHWADDR,
 };
 
 /**
diff --git a/src/expr/meta.c b/src/expr/meta.c
index d1ff6c4..7c56fdc 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -18,7 +18,7 @@
 #include <libnftnl/rule.h>
 
 #ifndef NFT_META_MAX
-#define NFT_META_MAX (NFT_META_BRI_BROUTE + 1)
+#define NFT_META_MAX (NFT_META_BRI_IIFHWADDR + 1)
 #endif
 
 struct nftnl_expr_meta {
@@ -163,6 +163,7 @@ static const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_SDIF]		= "sdif",
 	[NFT_META_SDIFNAME]	= "sdifname",
 	[NFT_META_BRI_BROUTE]	= "broute",
+	[NFT_META_BRI_IIFHWADDR] = "ibrhwaddr",
 };
 
 static const char *meta_key2str(uint8_t key)
-- 
2.51.0

