Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5846F3B47C6
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 14:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779805139; cv=none; b=hB8FS2DahJF6CfPWKWr0tvhixqtY+k1A8Jh3W9tll6oMvI0rUOvhWy9sU+D9Up1ywvqfQC3hVel1Ps5ghS3TaOflOs1YB8gM7P55kRROV3xdd+J7f1JmODQFOWBOc2UhUWe6wqDydFtXLkdQ+7yqF+y2oKf9/CGVXXXp2G85Anc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779805139; c=relaxed/simple;
	bh=7cDtJxlFUiU9EwM9las121+OWmUXrsS/PjdxyWyQ7F8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bViCTg7HRIJ4XNO37HkmCjypHrBDWwsI9C4ju/CisE7WIc+C+xRg0HeOObKYCjm0goIBb6hVi2A0OQVbksW5nfpOV8kiQdKZF9LctTH7GmFKhF4kcH3SybEJzDgNu6HshgutIXEaFQcthoj1JO7Ea4nqF9EgbTZgd1VUx4lWjUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WIw5p8KY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SmtX/McM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WIw5p8KY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SmtX/McM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WIw5p8KY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SmtX/McM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WIw5p8KY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SmtX/McM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B5B976AF8D;
	Tue, 26 May 2026 14:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779805136; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Hq2hsvsHw1y8r2DzWDcpTgqVfyCUHHGl1FS8ANJV6c8=;
	b=WIw5p8KYGfNCpH2tHTfhE/5LYa8ZIqvx47AjODlKFTfYNZyNjTLH5OPLWkoo5I6KomPoEu
	DGrEUu9uMpYCCzslMbSXa1DgkYjldCBClu4Mqml3ls0aB1uhr1W2NoaEu0nf1eM1RcMnoc
	n/5gP9VscaiZT8GiChR2UtMkq2l4vL8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779805136;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Hq2hsvsHw1y8r2DzWDcpTgqVfyCUHHGl1FS8ANJV6c8=;
	b=SmtX/McMW/4wintS+HWpk7YMjVy/EpRIA7HIP532CDdeO3Ery6jGnLBWfJyZMEod0CzHDY
	2QWnRlxrCngk/fAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779805136; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Hq2hsvsHw1y8r2DzWDcpTgqVfyCUHHGl1FS8ANJV6c8=;
	b=WIw5p8KYGfNCpH2tHTfhE/5LYa8ZIqvx47AjODlKFTfYNZyNjTLH5OPLWkoo5I6KomPoEu
	DGrEUu9uMpYCCzslMbSXa1DgkYjldCBClu4Mqml3ls0aB1uhr1W2NoaEu0nf1eM1RcMnoc
	n/5gP9VscaiZT8GiChR2UtMkq2l4vL8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779805136;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Hq2hsvsHw1y8r2DzWDcpTgqVfyCUHHGl1FS8ANJV6c8=;
	b=SmtX/McMW/4wintS+HWpk7YMjVy/EpRIA7HIP532CDdeO3Ery6jGnLBWfJyZMEod0CzHDY
	2QWnRlxrCngk/fAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 46EE25A24D;
	Tue, 26 May 2026 14:18:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 51BpDtCrFWqbJQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 26 May 2026 14:18:56 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 0/5 nf-next v3] netfilter: synproxy: misc fixes about synproxy core
Date: Tue, 26 May 2026 16:18:33 +0200
Message-ID: <20260526141838.4191-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.988];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]

This series fixes several long standing issues during synproxy timestamp
adjustment and concurrent hook registration. From ignored error handling
to unaligned memory access. Most of this are not issues impacting real
setups as they would have been reported before.

FWIW; I am sending these fixes as separated patches because they are
addressing independent issues.

Fernando Fernandez Mancera (5):
  netfilter: synproxy: drop packets if timestamp adjustment fails
  netfilter: synproxy: adjust duplicate timestamp options
  netfilter: synproxy: fix unaligned memory access in timestamp
    adjustment
  netfilter: synproxy: protect nf_ct_seqadj_init() with conntrack lock
  netfilter: synproxy: add mutex to guard hook reference counting

 net/netfilter/nf_synproxy_core.c | 76 +++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 25 deletions(-)

-- 
2.53.0

