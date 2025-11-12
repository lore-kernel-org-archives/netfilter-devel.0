Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D173148AC
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Nov 2025 11:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762947910; cv=none; b=Re5SFEMGsZ+rQ0hipjRoH2uNJF1eVLLu+vKvGKOkJ+ws3X7Lp3okFQmkYwyMf5gMfEZTfxPiNM6BBoXbEy5aEI9qdSyM0TjhqzIMX3QqaFsH7YIWEBQUigZ/89mALCFYZvorU5I5lm06bCQBCAfFLY7+tvc+3WTAgAly1GYDyog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762947910; c=relaxed/simple;
	bh=Wj9SlP85kWLYYDqEyd8HZrxZKtkjoWqawKIeIuDG51o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CHaPOh6HLO6cHTc3B/W5zQkvpepOEcU+eD+GtiPfNI8sEsRiLfSCce9Vm2vGSyuEQsrQj/xSKQnauoikeAqqP2d3trC/OThEzQg8jCEcJk3TzfWd4KUQGDL1iQ7tw+W1258vvPCxG+rKbSidZCm4VN+Dv8wys5NWijmv39ive8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BZDCSkhs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FMl6yZ2T; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BZDCSkhs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FMl6yZ2T; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BZDCSkhs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FMl6yZ2T";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BZDCSkhs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FMl6yZ2T"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 15A5621CAF;
	Wed, 12 Nov 2025 11:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762947907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=HWRT/70j4WoplrreAwXR9Uf9ne5x6TbcDXNaRaJvpJA=;
	b=BZDCSkhsQ5jCvklVKYlTS13C3OcLSGfQyjsjbHdTxPRCSUGvCiMmZ0eaFrVpR1Wq93OZ0F
	gVWT8y2XAIDwljrSjDElTppq4g6/398ei83n4Bt1bPHv6Wg1KTUgm9WGkFr3uVDmO6GMLk
	fCBPwMdbqjzuXFJsAh3WbH8b9qkdDo4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762947907;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=HWRT/70j4WoplrreAwXR9Uf9ne5x6TbcDXNaRaJvpJA=;
	b=FMl6yZ2T5JeNml8tU9pLW5wwdocfziSzaiTjZgKFIIcS4dRJeh+/onIw/Hi4hReQ5cnwpm
	MuM/lmC+M2fAg+AA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762947907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=HWRT/70j4WoplrreAwXR9Uf9ne5x6TbcDXNaRaJvpJA=;
	b=BZDCSkhsQ5jCvklVKYlTS13C3OcLSGfQyjsjbHdTxPRCSUGvCiMmZ0eaFrVpR1Wq93OZ0F
	gVWT8y2XAIDwljrSjDElTppq4g6/398ei83n4Bt1bPHv6Wg1KTUgm9WGkFr3uVDmO6GMLk
	fCBPwMdbqjzuXFJsAh3WbH8b9qkdDo4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762947907;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=HWRT/70j4WoplrreAwXR9Uf9ne5x6TbcDXNaRaJvpJA=;
	b=FMl6yZ2T5JeNml8tU9pLW5wwdocfziSzaiTjZgKFIIcS4dRJeh+/onIw/Hi4hReQ5cnwpm
	MuM/lmC+M2fAg+AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 735CF3EA61;
	Wed, 12 Nov 2025 11:45:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TUIwGUJzFGmvCQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 12 Nov 2025 11:45:06 +0000
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
Subject: [PATCH 0/6 nf-next v3] netfilter: rework conncount API to receive sk_buff directly
Date: Wed, 12 Nov 2025 12:43:46 +0100
Message-ID: <20251112114351.3273-2-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.80

This series is fixing two different problems. The first issue is related
to duplicated entries when used for non-confirmed connections in
nft_connlimit and xt_connlimit. Now, nf_conncount_add() checks whether
the connection is confirmed or not. If the connection is confirmed,
skip the add.

In order to do that, nf_conncount_count_skb() and nf_conncount_add_skb()
API has been introduced. They allow the user to pass the sk_buff
directly. The old API has been removed.

The second issue this series is fixing is related to
nft_connlimit/xt_connlimit not updating the list of connection for
confirmed connections breaking softlimiting use-cases like limiting the
bandwidth when too many connections are open.

This has been tested with nftables and iptables both in filter and raw
priorities. I have stressed the system up to 2000 connections.

CC'ing openvswitch maintainers as this change on the API required me to
touch their code. I am not very familiar with the internals of
openvswitch but I believe this should be fine. If you could provide some
testing from openvswitch side it would be really helpful.

Fernando Fernandez Mancera (6):
  netfilter: nf_conncount: introduce new nf_conncount_count_skb() API
  netfilter: xt_connlimit: use nf_conncount_count_skb() directly
  openvswitch: use nf_conncount_count_skb() directly
  netfilter: nf_conncount: pass the sk_buff down to __nf_conncount_add()
  netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
  netfilter: nft_connlimit: update the count if add was skipped

 include/net/netfilter/nf_conntrack_count.h |  17 +-
 net/netfilter/nf_conncount.c               | 193 ++++++++++++++-------
 net/netfilter/nft_connlimit.c              |  41 ++---
 net/netfilter/xt_connlimit.c               |  14 +-
 net/openvswitch/conntrack.c                |  16 +-
 5 files changed, 169 insertions(+), 112 deletions(-)

-- 
2.51.0

