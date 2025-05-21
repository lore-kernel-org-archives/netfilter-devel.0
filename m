Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2B9250BED
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 09:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747820501; cv=none; b=LABu60vJQWS4pt0zvD46G+cNuwfZa/RXyhDcgVB4ZaCzOqVtmJzocKUEPgk1nrEBJ7INNSRPXeYfZ6+LloGLvvzKBUdL32u0y+UClI7ZAALRl74HFP+lxHQXS7eQhqZnDyPK+j+arFS+enXzpg9HBqOED/v5PjDFDDVqAeJPLtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747820501; c=relaxed/simple;
	bh=6+lipTu1Kj/IRkwUmfNF49kyyydcx2KsvYsMwukokb0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QRTBsACVfrvk+vST4CX1FpSRr7VWugP53HRhkAgfcPsgVyja6wxRummzBA0w5Zi6CbNfCKMR4YuX0wf1lB9hAuMsmBBFcHjvkW/KJ4hJZ37yO/jQDjSsunVQnQ+utLzyIS5Km4UTmxfsBFt7sVjrOD/7NiHiMsqaJquQcj+LvQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=edo/rUvs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=U7wBEKcK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=edo/rUvs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=U7wBEKcK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="edo/rUvs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="U7wBEKcK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="edo/rUvs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="U7wBEKcK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E01502080C;
	Wed, 21 May 2025 09:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747820497; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cke/grpHNZ1QNIUV/Vek/0wkszcPu6wFazqTyBWh88s=;
	b=edo/rUvsWk9fs9CM6d/rdtw2mzQX65UZ7F6BiSiVbJ0C+3HVgceMnt0ghFeS4DpD0ax4vl
	1RxfmVHFxzn95MsrIp8/R2UdQ9P3+k8uveNpG+Rs9HpyuVDNZp0ZYnAsV/Kn0z6fQl2NFQ
	cg/UGJhoMdgXKLJMH48eNeYsGUecmP0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747820497;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cke/grpHNZ1QNIUV/Vek/0wkszcPu6wFazqTyBWh88s=;
	b=U7wBEKcKWHPZYU56d5b92ZL/Jkd+NmlTLsWln7GyO5fdCWILzewF6Tb56Tb2v5Ok4uQDPk
	b03eGWaAab7vTSBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747820497; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cke/grpHNZ1QNIUV/Vek/0wkszcPu6wFazqTyBWh88s=;
	b=edo/rUvsWk9fs9CM6d/rdtw2mzQX65UZ7F6BiSiVbJ0C+3HVgceMnt0ghFeS4DpD0ax4vl
	1RxfmVHFxzn95MsrIp8/R2UdQ9P3+k8uveNpG+Rs9HpyuVDNZp0ZYnAsV/Kn0z6fQl2NFQ
	cg/UGJhoMdgXKLJMH48eNeYsGUecmP0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747820497;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cke/grpHNZ1QNIUV/Vek/0wkszcPu6wFazqTyBWh88s=;
	b=U7wBEKcKWHPZYU56d5b92ZL/Jkd+NmlTLsWln7GyO5fdCWILzewF6Tb56Tb2v5Ok4uQDPk
	b03eGWaAab7vTSBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C2DE713888;
	Wed, 21 May 2025 09:41:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JhpGLtGfLWhGQwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 21 May 2025 09:41:37 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf] netfilter: nft_tunnel: fix geneve_opt dump
Date: Wed, 21 May 2025 11:41:08 +0200
Message-ID: <20250521094108.23690-1-fmancera@suse.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: 0.20
X-Spamd-Result: default: False [0.20 / 50.00];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]

When dumping a nft_tunnel with more than one geneve_opt configured the
netlink attribute hierarchy should be as follow:

 NFTA_TUNNEL_KEY_OPTS
 |
 |--NFTA_TUNNEL_KEY_OPTS_GENEVE
 |  |
 |  |--NFTA_TUNNEL_KEY_GENEVE_CLASS
 |  |--NFTA_TUNNEL_KEY_GENEVE_TYPE
 |  |--NFTA_TUNNEL_KEY_GENEVE_DATA
 |
 |--NFTA_TUNNEL_KEY_OPTS_GENEVE
 |  |
 |  |--NFTA_TUNNEL_KEY_GENEVE_CLASS
 |  |--NFTA_TUNNEL_KEY_GENEVE_TYPE
 |  |--NFTA_TUNNEL_KEY_GENEVE_DATA
 |
 |--NFTA_TUNNEL_KEY_OPTS_GENEVE
 ...

Otherwise, userspace tools won't be able to fetch the geneve options
configured correctly.

Fixes: 925d844696d9 ("netfilter: nft_tunnel: add support for geneve opts")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nft_tunnel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 0c63d1367cf7..a12486ae089d 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -621,10 +621,10 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 		struct geneve_opt *opt;
 		int offset = 0;
 
-		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_GENEVE);
-		if (!inner)
-			goto failure;
 		while (opts->len > offset) {
+			inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_GENEVE);
+			if (!inner)
+				goto failure;
 			opt = (struct geneve_opt *)(opts->u.data + offset);
 			if (nla_put_be16(skb, NFTA_TUNNEL_KEY_GENEVE_CLASS,
 					 opt->opt_class) ||
@@ -634,8 +634,8 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 				    opt->length * 4, opt->opt_data))
 				goto inner_failure;
 			offset += sizeof(*opt) + opt->length * 4;
+			nla_nest_end(skb, inner);
 		}
-		nla_nest_end(skb, inner);
 	}
 	nla_nest_end(skb, nest);
 	return 0;
-- 
2.49.0

