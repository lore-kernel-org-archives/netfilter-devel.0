Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4603A380F
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 21:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779832727; cv=none; b=NxGsotkZfvjop0hPAeTetK/jDz+JhJm1oNuQqFhT6nFVxJfOE2ndXbFOeTMPY0ohKEvEriw7cOUhSIQKtwYr/H5dvUjBkmoY/wws4HECzO+IY7sZxCu1u1MDof9TfQEUQL/kge6YwWdUStVnT2MIISPAukDiZvhHYPQFCR440/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779832727; c=relaxed/simple;
	bh=HQSkNixuTRHIUQu75jlEbls+4+Jzi8fGNio+f7sopPE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fu/jshIYnfT8xryD2lu8Kd021K1gZbUiqfgDVvskRv99oefde3ZCAqFhKiXLqb9z79mOXhvO679chSVm6IpgarCy9jufBgAcExX831Hp5IjcpNBsSQpnF1mJmP3OCMi8CPiSvt/x3XGFYnPHnFdP6PXhZkEsZXCDPgJYwiwhNas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=C6u6nK0I; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=F40bdyij; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=C6u6nK0I; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=F40bdyij; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="C6u6nK0I";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="F40bdyij";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="C6u6nK0I";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="F40bdyij"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BE90B6C000;
	Tue, 26 May 2026 21:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779832723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SAFHSA1PHHZX0bBFOQpUZlGx4hKdR50+I06NW2nerXU=;
	b=C6u6nK0ImjXEo+sbSFc9xI8CspqZzFSJpeQJZWveY4s6/wq6bfKJnu5zAc/tL4UTakFB93
	1J6mjwCc+Qbdi4a7BkhQn+gjTmJnMnEqp/bHPeNLzJ1iv2qDTK79BloIYJge6AWym6VbyN
	10PtTCFMwpBwQuQjncOoVjWqJB2+PzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779832723;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SAFHSA1PHHZX0bBFOQpUZlGx4hKdR50+I06NW2nerXU=;
	b=F40bdyijnc7mD6NmBrZ1SmcxxFQZnM3LNyIiqEYb4vs9BNely4hlcJWiRMKxbXcFVFlEL4
	lNGWO2Xf5vRt1kCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779832723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SAFHSA1PHHZX0bBFOQpUZlGx4hKdR50+I06NW2nerXU=;
	b=C6u6nK0ImjXEo+sbSFc9xI8CspqZzFSJpeQJZWveY4s6/wq6bfKJnu5zAc/tL4UTakFB93
	1J6mjwCc+Qbdi4a7BkhQn+gjTmJnMnEqp/bHPeNLzJ1iv2qDTK79BloIYJge6AWym6VbyN
	10PtTCFMwpBwQuQjncOoVjWqJB2+PzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779832723;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SAFHSA1PHHZX0bBFOQpUZlGx4hKdR50+I06NW2nerXU=;
	b=F40bdyijnc7mD6NmBrZ1SmcxxFQZnM3LNyIiqEYb4vs9BNely4hlcJWiRMKxbXcFVFlEL4
	lNGWO2Xf5vRt1kCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 533CB5A419;
	Tue, 26 May 2026 21:58:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RVHBEJMXFmrTZAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 26 May 2026 21:58:43 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 0/5 nf-next v4] netfilter: synproxy: misc fixes about synproxy core
Date: Tue, 26 May 2026 23:58:26 +0200
Message-ID: <20260526215831.6726-1-fmancera@suse.de>
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_TLS_ALL(0.00)[]

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

 net/netfilter/nf_conntrack_seqadj.c |  2 +
 net/netfilter/nf_synproxy_core.c    | 64 ++++++++++++++++++-----------
 2 files changed, 41 insertions(+), 25 deletions(-)

-- 
2.53.0

