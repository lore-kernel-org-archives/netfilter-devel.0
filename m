Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B1D37B03B
	for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 12:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779713099; cv=none; b=LBVDIHYu1qEw9Y5527tj/qIGpwrev283Vo04LpOAk/bdttuESAHxtemSv5KAfRsIEjXUI9JBbaw5mBn6ZcoYCDUX23QjCQwI0ptqtxdmd39mIwLT4lt4df3GKE6LKiCKWzzJbZX44div1HdFF5YCOjtCA3qScyzeyRqYuKSrMwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779713099; c=relaxed/simple;
	bh=7ECJj993HAs3B5TSniuVKkCDIqoecZylbjtdt6OeGHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nqQdLY3qew3uTjLV71j/4UcYqZJjM4pWSnPWOb4CwqFk0LAoiHqLxL8kX0hxnis5YTTVAt4pG1jPEyc5+14ao+vZPNEwKhLO3v3l4rQK7kbHMfDjPn5rZtkOaOJHtVDf4s7Dd3ppmoznJP01hfr64BBemRnd/KpkCguQ6OP3lw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=egTHXYI7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cRj+cs/C; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=egTHXYI7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cRj+cs/C; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="egTHXYI7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cRj+cs/C";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="egTHXYI7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cRj+cs/C"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1AEA067831;
	Mon, 25 May 2026 12:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779713096; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fHhhCgD5W/lcnFxFtcynvioMCj58v/LyK7jjwI2lyZ0=;
	b=egTHXYI7mvWnngsec1PbQ7cBLgbXqsrhlI+yFVawYAf1vqsHSr1PxP/PuHiyI8J5afMsdN
	ENZpvpuWaCZ5hiDcqZsFqwkF72c9x0vO6Q78v3RiuMXYonepVFnNA9kwUyUBCB5u34lN0M
	cc5H6SwlstUInMYwfpr30sVukeFh+mA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779713096;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fHhhCgD5W/lcnFxFtcynvioMCj58v/LyK7jjwI2lyZ0=;
	b=cRj+cs/C7umvkxk336WHuKgCnlHOzuDAq6LwbbgMaowzzFvoUhl8xqclBuWCn1jDrDcZ5n
	pb4qmzAwEXzpqrCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779713096; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fHhhCgD5W/lcnFxFtcynvioMCj58v/LyK7jjwI2lyZ0=;
	b=egTHXYI7mvWnngsec1PbQ7cBLgbXqsrhlI+yFVawYAf1vqsHSr1PxP/PuHiyI8J5afMsdN
	ENZpvpuWaCZ5hiDcqZsFqwkF72c9x0vO6Q78v3RiuMXYonepVFnNA9kwUyUBCB5u34lN0M
	cc5H6SwlstUInMYwfpr30sVukeFh+mA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779713096;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fHhhCgD5W/lcnFxFtcynvioMCj58v/LyK7jjwI2lyZ0=;
	b=cRj+cs/C7umvkxk336WHuKgCnlHOzuDAq6LwbbgMaowzzFvoUhl8xqclBuWCn1jDrDcZ5n
	pb4qmzAwEXzpqrCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D43759C50;
	Mon, 25 May 2026 12:44:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3cFdI0dEFGq1SgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 25 May 2026 12:44:55 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 0/4 nf v2] netfilter: synproxy: timestamp adjustment fixes
Date: Mon, 25 May 2026 14:44:46 +0200
Message-ID: <20260525124450.6043-1-fmancera@suse.de>
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
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

This series fixes several long standing issues during synproxy timestamp
adjustment. From ignored error handling to unaligned memory access. Most
of this are not issues impacting real setups as they would have been
reported before. The most critical bug is the write to the stale
pointer.

FWIW; I am sending these fixes as separated patches because they
are addressing independent issues.

Fernando Fernandez Mancera (4):
  netfilter: synproxy: drop packets if timestamp adjustment fails
  netfilter: synproxy: adjust duplicate timestamp options
  netfilter: synproxy: fix unaligned memory access in timestamp
    adjustment
  netfilter: synproxy: fix possible write to stale pointer

 net/netfilter/nf_synproxy_core.c | 41 +++++++++++++++++---------------
 1 file changed, 22 insertions(+), 19 deletions(-)

-- 
2.53.0

