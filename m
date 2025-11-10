Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9D5272801
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 15:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789401; cv=none; b=YemsEpPJWHgIw61/dohucsznGDqiKJ9ov0ubEA38DM4ef+Wt897rLGOYBLCpqaQ7o62tix/Cxmfq8GVzL1xcQaXZFM2q8B+HtwQoZZ2PiOCd2xqAaIx0M0RD1S1Y2Ly17xu17WAJi1gfsVm74xkaeh4mKRlyyu9m1aIiuV6FFsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789401; c=relaxed/simple;
	bh=sB/6Y6TAecJXgrlJ4oecEOKtSq1HaTfLlYaydRKI9zs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E/l0qXOtxJi3GDy3zdH3rXSuF+aJ0MlIyBn76L8Xxno5S4h8lobNKffrXAOrZhPKBeWM3g5Pf2VG9FG/sIpI48ZCME0IAMePfqU6HA4hfi5OsBHPm+oM+4hgurrbqa5UX4OCxSCrfJn2IFYUoPO+J9YPcKWvHkUsgvIzi4wxXxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nAPpnQBz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TVjSACBp; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nAPpnQBz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TVjSACBp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nAPpnQBz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TVjSACBp";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nAPpnQBz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TVjSACBp"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3F015200B0;
	Mon, 10 Nov 2025 15:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762789397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NjiR32yb9sikGMi8FbJ+Xqlg70cpUxryWKzEAj6SU3s=;
	b=nAPpnQBz3W/QV3OhlESOXFjDvrMGeFAaFkTXgFbmJpAi1gucaYx1JxogKH3dG6w5xcoAmp
	VEmzu0cxwQ6k2zcroiB9txLsjQ4KjQQQZo8A3j8V2KaedX5ka7Zieoiz/dcIOE+WdUlbA7
	EV+hx3Mbs0EORA0YpTStEXyhEOvin7g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762789397;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NjiR32yb9sikGMi8FbJ+Xqlg70cpUxryWKzEAj6SU3s=;
	b=TVjSACBp1bTWYc6AlKI965AFu1StWuKjLfGAfBx5Rl68kvmbzB2daCF3FlRapvKQrXQnTA
	Whgk3TsqmDx0+CCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762789397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NjiR32yb9sikGMi8FbJ+Xqlg70cpUxryWKzEAj6SU3s=;
	b=nAPpnQBz3W/QV3OhlESOXFjDvrMGeFAaFkTXgFbmJpAi1gucaYx1JxogKH3dG6w5xcoAmp
	VEmzu0cxwQ6k2zcroiB9txLsjQ4KjQQQZo8A3j8V2KaedX5ka7Zieoiz/dcIOE+WdUlbA7
	EV+hx3Mbs0EORA0YpTStEXyhEOvin7g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762789397;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NjiR32yb9sikGMi8FbJ+Xqlg70cpUxryWKzEAj6SU3s=;
	b=TVjSACBp1bTWYc6AlKI965AFu1StWuKjLfGAfBx5Rl68kvmbzB2daCF3FlRapvKQrXQnTA
	Whgk3TsqmDx0+CCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AFB1614480;
	Mon, 10 Nov 2025 15:43:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1GwYKBQIEmkWWgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 10 Nov 2025 15:43:16 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	aconole@redhat.com,
	echaudro@redhat.com,
	i.maximets@ovn.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 0/4 nf-next v2] netfilter: rework conncount API to receive ct directly
Date: Mon, 10 Nov 2025 16:42:45 +0100
Message-ID: <20251110154249.3586-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
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
openvswitch but I believe this should be fine for them as they hold a
reference to a valid ct already. If you could provide some testing from
openvswitch side it would be really helpful.

Fernando Fernandez Mancera (4):
  netfilter: conntrack: add nf_ct_get_or_find() helper
  netfilter: nf_conncount: only track connection if it is not confirmed
  netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
  netfilter: nft_connlimit: update connection list if add was skipped

 include/net/netfilter/nf_conntrack.h       |  3 +
 include/net/netfilter/nf_conntrack_count.h | 10 +--
 net/netfilter/nf_conncount.c               | 94 +++++++++++++---------
 net/netfilter/nf_conntrack_core.c          | 35 ++++++++
 net/netfilter/nft_connlimit.c              | 45 ++++++-----
 net/netfilter/xt_connlimit.c               | 27 +++----
 net/openvswitch/conntrack.c                | 14 ++--
 7 files changed, 133 insertions(+), 95 deletions(-)

-- 
2.51.0

