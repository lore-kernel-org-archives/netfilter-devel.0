Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D0C1EF36E
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Nov 2025 00:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762390594; cv=none; b=EFrEfpxjR6I/hUJZKK4G/NAEShycVOMvkzL2dFiFcYxJR9f2m9wg0uIIgIu0rTL6ONEXY1sqD3zXmI5TT6yKEMbqhSWe6Gnv6VrN+GGi6FjFtGdYJL51U6k2mwslDHM9oirwBWa37P3ttnkf2FZnePrdIrdL7sLHvEKXI/7f/yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762390594; c=relaxed/simple;
	bh=1JsQP+jyBsxys7iInO8R6JSvwe0ICRBtJmZPGnHocPM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fEcI7e5o8OU3c2ZXedHk8t5CdW6W+XcP9Fu93IG+g/1IhfN/8DSrX9jXwCmC1vwQXC0wcJFb3l6HoECHkxMmH/wxlV1oId+poqmBmg9pvHqV5gy9sXThtZ2aCI+QQDJ3BVzpiqSOgoCO0YRgI8dMAVSNNBH2tNKXnKSZBdK6whU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xY83x7Nt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UrLJc0Pn; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xY83x7Nt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UrLJc0Pn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xY83x7Nt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UrLJc0Pn";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xY83x7Nt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UrLJc0Pn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1C3441F393;
	Thu,  6 Nov 2025 00:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762390590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=+nIngGyBQkILGOsYzMkpcUJietCAD4cCOR2Kwpm/HTc=;
	b=xY83x7NtEIs/uqpgr2BDnOzzwm69Doai5xTyZA9uF/YZsDEOr7vSKEWfDD9qLpavPvdWZZ
	ztdMmhOBiYhdE+rItHbuDuKBpy6RkGT7P+9y6sPgfKPer/jmVikaFBVv22i0f/sT1kqfgx
	rliy+8zSsJNtdb7UA0LGAYaHB3HkjFo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762390590;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=+nIngGyBQkILGOsYzMkpcUJietCAD4cCOR2Kwpm/HTc=;
	b=UrLJc0Pn9y8HdbSSqV8vnd+h3borSJrMCA6tovTZtNDEDf1+vBxNUYmhvuUJIzcPPwBcPC
	+2lxzAc7vHrOlACw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xY83x7Nt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UrLJc0Pn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762390590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=+nIngGyBQkILGOsYzMkpcUJietCAD4cCOR2Kwpm/HTc=;
	b=xY83x7NtEIs/uqpgr2BDnOzzwm69Doai5xTyZA9uF/YZsDEOr7vSKEWfDD9qLpavPvdWZZ
	ztdMmhOBiYhdE+rItHbuDuKBpy6RkGT7P+9y6sPgfKPer/jmVikaFBVv22i0f/sT1kqfgx
	rliy+8zSsJNtdb7UA0LGAYaHB3HkjFo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762390590;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=+nIngGyBQkILGOsYzMkpcUJietCAD4cCOR2Kwpm/HTc=;
	b=UrLJc0Pn9y8HdbSSqV8vnd+h3borSJrMCA6tovTZtNDEDf1+vBxNUYmhvuUJIzcPPwBcPC
	+2lxzAc7vHrOlACw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7ADB9132DD;
	Thu,  6 Nov 2025 00:56:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /eq6Gj3yC2mNLAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 06 Nov 2025 00:56:29 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	aconole@redhat.com,
	echaudro@redhat.com,
	i.maximets@ovn.org,
	dev@openvswitch.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 0/3 nf-next] netfilter: nf_conncount: rework conncount API to
Date: Thu,  6 Nov 2025 01:55:54 +0100
Message-ID: <20251106005557.3849-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1C3441F393
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

This series is fixing two different problems. The first issue is related
to duplicated entries when used for non-confirmed connections in
nft_connlimit and xt_connlimit. Now, nf_conncount_add() checks whether
the connection is confirmed or not. If the connection is confirmed,
skip the add.

In order to do that, the nf_conncount API is now receiving struct nf_conn
as argument instead of tuple and zone. In addition, nf_conncount_count()
also needs to receive the net because it calls nf_conncount_gc_list()
inside it if ct is NULL.

The second issue this series is fixing is related to
nft_connlimit/xt_connlimit not updating the list of connection for
confirmed connections breaking softlimiting use-cases like limiting the
bandwidth when too many connections are open.

This has been tested on datapath using connlimit in nftables and
iptables. I have stressed the system up to 2000 connections.

CC'ing openvswitch maintainers as this change on the API required me to
touch their code. I am not very familiar with the internals of
openvswitch but I believe this should be fine for them. If you could
provide some testing from openvswitch side it would be really helpful. 

Fernando Fernandez Mancera (3):
  netfilter: nf_conncount: only track connection if it is not confirmed
  netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
  netfilter: nft_connlimit: update connection list if add was skipped

 include/net/netfilter/nf_conntrack_count.h | 10 +--
 net/netfilter/nf_conncount.c               | 94 +++++++++++++---------
 net/netfilter/nft_connlimit.c              | 49 ++++++-----
 net/netfilter/xt_connlimit.c               | 28 ++++---
 net/openvswitch/conntrack.c                | 14 ++--
 5 files changed, 106 insertions(+), 89 deletions(-)

-- 
2.51.0

