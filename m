Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F243C3F99DD
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2026 14:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774536208; cv=none; b=BMaR9Nr0iaOOYKy14y/GVe82w10RcVONeor6JnAgQqn0N+tn/Sci2H85dPrzZvfqowCU4Jf3u2eYqBD9zR6lKuMejRYALwRggtBHlUUQVkg3bo+bdPPTA9qkqRA6AeKmsh+O8Ee8HkaRyPBXYmSXY5UUDF2ADawNMwcBj7Sgew8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774536208; c=relaxed/simple;
	bh=LLTrDOPrAVfMPp3uEpVBgf2Vp00cGZONn4ZMDKbmAHA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nEm751MUdu6Z+do5b6gke1Nli4FFhnbN5vVezucp+Dx99k8aS9yyxwTgj4tttJsStF/bglW09uZgJ1/SQ6KNP3rRdP04RqYty76fbGLRSEAk8FZ+yZVGHpQ6wzOehyVUDK8Ym8ROQfanWw+U6Jy9+8F3PPvp2V/vNT3j/mgbLWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=frKSm62i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VHcSPFhI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=frKSm62i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VHcSPFhI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="frKSm62i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VHcSPFhI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="frKSm62i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VHcSPFhI"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 31F3A5BD37;
	Thu, 26 Mar 2026 14:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774536205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XUkKdugCn2eGJdw9wwUkrhUZPJ0JvMg5rTtvd4ml5lw=;
	b=frKSm62i+6Rav+biRxOomKCnEAXXE/6ROdzKlI2mi5cxIS/wwWpuLBC3t2zYWaMnUXlKC/
	GMEM/mZWC+RKGFWVbPRrFyznHC1E4Mx+qrXf0xyaNazz/KFXsTtz39xrFD4WJm3JI8kPe6
	OHWxcpE8e2FPaHEN/fAYYg1GHWrM87k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774536205;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XUkKdugCn2eGJdw9wwUkrhUZPJ0JvMg5rTtvd4ml5lw=;
	b=VHcSPFhIDyAb/X6LE0G9gxFBCifwRYAHlIHo64zDxQq1WermsH1iCgh8hmd2XqCePFTfYE
	l81Tbn1aqO2TkzAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=frKSm62i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VHcSPFhI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774536205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XUkKdugCn2eGJdw9wwUkrhUZPJ0JvMg5rTtvd4ml5lw=;
	b=frKSm62i+6Rav+biRxOomKCnEAXXE/6ROdzKlI2mi5cxIS/wwWpuLBC3t2zYWaMnUXlKC/
	GMEM/mZWC+RKGFWVbPRrFyznHC1E4Mx+qrXf0xyaNazz/KFXsTtz39xrFD4WJm3JI8kPe6
	OHWxcpE8e2FPaHEN/fAYYg1GHWrM87k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774536205;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XUkKdugCn2eGJdw9wwUkrhUZPJ0JvMg5rTtvd4ml5lw=;
	b=VHcSPFhIDyAb/X6LE0G9gxFBCifwRYAHlIHo64zDxQq1WermsH1iCgh8hmd2XqCePFTfYE
	l81Tbn1aqO2TkzAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B2F9E4A0A3;
	Thu, 26 Mar 2026 14:43:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id weGtKAxGxWnFMwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 26 Mar 2026 14:43:24 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next] netfilter: Kconfig: make NF_FLOW_TABLE_INET depend on NF_TABLES_INET
Date: Thu, 26 Mar 2026 15:42:46 +0100
Message-ID: <20260326144246.4430-1-fmancera@suse.de>
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
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 31F3A5BD37

As it is not possible to create an inet flowtable without a parent table
on inet family, it makes sense that Kconfig NF_FLOW_TABLE_INET symbol
depends on NF_TABLES_INET. This reduces the kernel image size a bit when
compiling the kernel with CONFIG_IPV6=n.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 6cdc994fdc8a..c50f2ad67b51 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -717,6 +717,7 @@ endif # NF_TABLES
 config NF_FLOW_TABLE_INET
 	tristate "Netfilter flow table mixed IPv4/IPv6 module"
 	depends on NF_FLOW_TABLE
+	depends on NF_TABLES_INET
 	help
 	  This option adds the flow table mixed IPv4/IPv6 support.
 
-- 
2.53.0

