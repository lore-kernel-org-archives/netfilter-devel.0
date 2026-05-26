Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F8E3C345F
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 21:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779832744; cv=none; b=MSEdGaQ/cN1/ma91ZuujLG3iQ5FSo8zezST7XmqKhkSUD6rLla8g5i8yk8p7rHM1j8Xn2O1PuhXoWj0rnYe9ELddPBC3SosSTGLNRArMGqkB952n4MZeWw+CtwFk6vZUlrb6/kYDbHLiE97NPDH3F0RL9bxBcpiAfwzeMpCOQuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779832744; c=relaxed/simple;
	bh=lxKAHEUudQunNX6mGebLTFDouHEY6DowUeK1HHV6q58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLUsCUUQAbgTMOTTAvLVwd9wMhDL6VVT6JaNFaRzYXTfRYL96rRsEy9ojDBQ0r6rZJvd7aND78KFB30CQM609qPdxPD6DPPcwPgc8CEX4OS6S3eJkigQ4ZMb19fjWqbc29yU4b0HiPpXabVr0hk1pekZAHgiy3jxqEflkVKNNNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1ZxXwBHg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UkkPDfeT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1ZxXwBHg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UkkPDfeT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1ZxXwBHg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UkkPDfeT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1ZxXwBHg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UkkPDfeT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7C2FC66F2C;
	Tue, 26 May 2026 21:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779832732; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D2GwBImQFQpsyL9e6ISVyAQk//X4I/2POxhBvmsztc0=;
	b=1ZxXwBHgLoL5LivG8DshnZkLXSAmy+PRWvq6D+bxQZDMjA2UF/bx3SGurYZcPg14xTbpPH
	uYEUZyb4ZgXuDzBKYcjE6LdSeRGfXBIPOKRR5+D5iJ+d6DxAU07amqP4v3KI24qM/ucZEi
	GHdMErmKym27L9NAaKgi+vGKWnMYK04=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779832732;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D2GwBImQFQpsyL9e6ISVyAQk//X4I/2POxhBvmsztc0=;
	b=UkkPDfeTWrUUFTwVTl1NP2F9hPZwUIx+914VdlocvZUwWF6O7YNySiEN1h9nfRS7DoQJ2i
	fWAPOB8pWWLZoGDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779832732; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D2GwBImQFQpsyL9e6ISVyAQk//X4I/2POxhBvmsztc0=;
	b=1ZxXwBHgLoL5LivG8DshnZkLXSAmy+PRWvq6D+bxQZDMjA2UF/bx3SGurYZcPg14xTbpPH
	uYEUZyb4ZgXuDzBKYcjE6LdSeRGfXBIPOKRR5+D5iJ+d6DxAU07amqP4v3KI24qM/ucZEi
	GHdMErmKym27L9NAaKgi+vGKWnMYK04=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779832732;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D2GwBImQFQpsyL9e6ISVyAQk//X4I/2POxhBvmsztc0=;
	b=UkkPDfeTWrUUFTwVTl1NP2F9hPZwUIx+914VdlocvZUwWF6O7YNySiEN1h9nfRS7DoQJ2i
	fWAPOB8pWWLZoGDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 163605A419;
	Tue, 26 May 2026 21:58:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id INdvApwXFmrTZAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 26 May 2026 21:58:52 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 4/5 nf-next v4] netfilter: synproxy: protect nf_ct_seqadj_init() with conntrack lock
Date: Tue, 26 May 2026 23:58:30 +0200
Message-ID: <20260526215831.6726-5-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260526215831.6726-1-fmancera@suse.de>
References: <20260526215831.6726-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]

nf_ct_seqadj_init() is called without holding the ct lock. This can race
with nf_ct_seq_adjust() when a connection is in CLOSE state due to an
RST or connection reopening. In addition for SYN_RECV state, concurrent
processing of packets can trigger nf_ct_seq_adjust() too. These
situations create a read/write data race.

As synproxy is the only user of nf_ct_seqadj_init() at the moment, fix
this by holding ct->lock inside nf_ct_seqadj_init() until all is done.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_conntrack_seqadj.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index 7ab2b25b57bc..b7e99f34dfce 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -17,12 +17,14 @@ int nf_ct_seqadj_init(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 	if (off == 0)
 		return 0;
 
+	spin_lock_bh(&ct->lock);
 	set_bit(IPS_SEQ_ADJUST_BIT, &ct->status);
 
 	seqadj = nfct_seqadj(ct);
 	this_way = &seqadj->seq[dir];
 	this_way->offset_before	 = off;
 	this_way->offset_after	 = off;
+	spin_unlock_bh(&ct->lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_ct_seqadj_init);
-- 
2.53.0

