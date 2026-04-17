Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C602826E142
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Apr 2026 18:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776450914; cv=none; b=fEsjqduEQO2dVPNj8/6I8foS3LznXkBumeoepA1HhmWPqnrR1jYvsbUuZ06RZjncMzRUMgc1APncL/s1oHl28NR+Mp7H6405kuynJpx4PEsQagx9hRLewpWymltprX4Mv4pBt0URj0lTKS+ZbZ04EZKSIKanuTD0B7wKES65IV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776450914; c=relaxed/simple;
	bh=OsNYKBXPI1nUZB+sgsghKh4fzbsOq2gggETk7M3a6ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0XCbUtb4wAQxs/JCooPDkLJCC2GbciD98ZWFdICQauSkNtmiptH4vneVDC6ppUmJ4/+OUeVcaj34flxIwjCBXC/NBM0QykOfioGnVFtO38SiHqRtmH5Wg7bKgNwRD/XpKPbVNVH2wQNJR/hwnPF2NfkJuCYElwLvbGI1aC/RtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VcHAp0rA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uQzgWfgV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VcHAp0rA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uQzgWfgV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VcHAp0rA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uQzgWfgV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VcHAp0rA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uQzgWfgV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1F0605BD6D;
	Fri, 17 Apr 2026 18:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776450911; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4tRw78NnQ8r63dxdxGlbEvc/S4kLNyqmm0kBi2Ao9WM=;
	b=VcHAp0rAYyGTwJQ4f6CF2VaucNlupqSoUCWnS5gK5RhUCbSxkOmjDDc8mmjD39avciTsFK
	KFRMCHtkytW6ssVBI/6g1VxVJx6cmQ2dx9TZ3+Ly1kbkL/xFgsWxR4JNKhcGpCUvbuWxso
	e6ELKcdepp4yDm0oT/KHUWo8ZHs5BIo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776450911;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4tRw78NnQ8r63dxdxGlbEvc/S4kLNyqmm0kBi2Ao9WM=;
	b=uQzgWfgVTYxfb0hTd2s7x9qcfoV+mZUkFjhjb5CFpUlFXlZyWpNfSewKHnU+ceJx5OIWNa
	fSsZHGAw7agoceCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VcHAp0rA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=uQzgWfgV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776450911; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4tRw78NnQ8r63dxdxGlbEvc/S4kLNyqmm0kBi2Ao9WM=;
	b=VcHAp0rAYyGTwJQ4f6CF2VaucNlupqSoUCWnS5gK5RhUCbSxkOmjDDc8mmjD39avciTsFK
	KFRMCHtkytW6ssVBI/6g1VxVJx6cmQ2dx9TZ3+Ly1kbkL/xFgsWxR4JNKhcGpCUvbuWxso
	e6ELKcdepp4yDm0oT/KHUWo8ZHs5BIo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776450911;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4tRw78NnQ8r63dxdxGlbEvc/S4kLNyqmm0kBi2Ao9WM=;
	b=uQzgWfgVTYxfb0hTd2s7x9qcfoV+mZUkFjhjb5CFpUlFXlZyWpNfSewKHnU+ceJx5OIWNa
	fSsZHGAw7agoceCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A9866593AE;
	Fri, 17 Apr 2026 18:35:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4OaeJl594mmFFQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 17 Apr 2026 18:35:10 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 3/4 nf] netfilter: nft_osf: skip evaluation for non-first fragments
Date: Fri, 17 Apr 2026 20:34:33 +0200
Message-ID: <20260417183433.4739-4-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260417183433.4739-1-fmancera@suse.de>
References: <20260417183433.4739-1-fmancera@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 1F0605BD6D
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

The osf expression extracts TCP options to match them against
fingerprints. For fragmented packets, every fragment carries the
transport protocol used but only the first fragment contains the TCP
header.

As nftables is not evaluating chain priority, a osf expression could be
attached to a PREROUTING chain with a priority lower than -400. This
would bypass defragmentation. In addition, nft_osf should be able to
work in stateless environments, therefore it can be use in situation
when defragmentation is not being performed.

Add a check for pkt->fragoff to ensure osf only evaluates unfragmented
packets or the first fragment in the stream.

Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nft_osf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 1c0b493ef0a9..ceca87e405eb 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -28,7 +28,7 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct nf_osf_data data;
 	struct tcphdr _tcph;
 
-	if (pkt->tprot != IPPROTO_TCP) {
+	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-- 
2.53.0

