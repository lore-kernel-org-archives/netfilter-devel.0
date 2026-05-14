Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEF23E4C99
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 14:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778768215; cv=none; b=DaMa+l0Cm4fsr3t9VISdgf+QUQEEVfxCDhfhdTDnYdV6AqtOOd5JYYM16zMaIB69IM2zYXpNauzdB/qZx56iOzFXIkdKbmDLdrHwJDHHxmiAvRt8cWmCJuCCRPefi7NmL2ZpQmQoiHexj2s+DVuaMgOE6STNEq+1PNyJBH86d3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778768215; c=relaxed/simple;
	bh=ZG1kkI99XsHUKePORICZxQoeSkInL13lepaNxrEWMZo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ubeSgFfwF5c2ozkDHZjfbw1KUbuIJz8iEV5Lct38m+/FoFjr71NRYb5RTuIgCat2lUDX/dVmA0iHKZR+nn65BGVWUhP52dlSVNyh04Vz7s/rdxATNVNkx8yu6IN8Dby9F+LVmD4L4nDUjuJvi4AwrHduYE6yJfw2q2A/Qo7gQ7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CQA0smkd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fiD8SxaU; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WAH4/cWp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pWCSd8ks; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CQA0smkd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fiD8SxaU";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WAH4/cWp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pWCSd8ks"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D489E679BA;
	Thu, 14 May 2026 14:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778768208; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ArHansl9wm+VnrIjn7qPtn6up8SSEYNCqJGg7I1TqMI=;
	b=CQA0smkdyXMaU2V0Yw0MuD0ZVj1nJ6UBinL7vY9F4Qp5Nx86H2hm40AWv7nUnZjEqH2iz9
	c96qtQgR3vwx80m4rXfXZmA0Hk7GbyW0Wks/Jub7IUuqign6R5tBpY2u8rOHTsRyMjvxRs
	wg7xUEeAIyFz9tVO/QixZp8MJYQP00k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778768208;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ArHansl9wm+VnrIjn7qPtn6up8SSEYNCqJGg7I1TqMI=;
	b=fiD8SxaUaqH7eQKo2HuKBujswGvn0/L4tejgO0ZvkYtHfdnJa6/uYI5PmLzrS+cOKtg8FY
	miAfJ+IvuKSXJ3Bg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778768206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ArHansl9wm+VnrIjn7qPtn6up8SSEYNCqJGg7I1TqMI=;
	b=WAH4/cWpeWyFRlZ/I3k9bwgss4jjgDTHzS0tOILNPti0I8EwFE2u/zWli2iz+qghCUYB9W
	BuMuqkLvadm7/nFUo+FCnAs18ZaYJG55qxaqq6p+pGcI2iZMlHFASR8qVjXHYTyGhBa8cj
	A9W9Sk+XwgbTkve3Sddv3I9g8eZgBl8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778768206;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ArHansl9wm+VnrIjn7qPtn6up8SSEYNCqJGg7I1TqMI=;
	b=pWCSd8ksug07yZVSYY8TJwFQDiMK1Heva2j4VQrg8rEJJljGjS5RCAHOVBhJeW3LKeBPh/
	MSpjGZSlWuPUffCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B631593A9;
	Thu, 14 May 2026 14:16:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wigpE07ZBWpVIAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 14 May 2026 14:16:46 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>
Subject: [PATCH nf v2] netfilter: nf_conncount: prevent connlimit drops for early confirmed ct
Date: Thu, 14 May 2026 16:16:28 +0200
Message-ID: <20260514141628.4636-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[netfilter.org,nwl.cc,strlen.de,suse.de,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

Commit 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add
was skipped") introduced a regression where packets for valid
connections are dropped when using connlimit for soft-limiting
scenarios.

The issue occurs when a new connection reuses a socket currently in
the TIME_WAIT state. In this scenario, the connection tracking entry
is evaluated as already confirmed. Previously, __nf_conncount_add()
assumed that if a connection was confirmed and did not originate from
the loopback interface, it should skip the addition and return -EEXIST.

Skipping the addition triggers a garbage collection run that cleans up
the TIME_WAIT connection. Consequently, the active connection count
drops to 0, which xt_connlimit mishandles, leading to the false rejection
of the perfectly valid new connection.

Fix this by replacing the interface check with protocol-agnostic state
checks. We now skip the tree insertion and preserve the lockless garbage
collection optimization only if the connection is IPS_ASSURED. This
allows early-confirmed setup packets (such as reused TIME_WAIT sockets
or locally generated SYN-ACKs) to be properly evaluated and counted
without falsely dropping. The goto check_connections path is maintained
to ensure these setup packets are deduplicated correctly.

This has been tested with slowhttptest and HTTP server configured
locally to ensure we are not breaking soft-limiting scenarios for local
or external connections. In addition, it was tested with a OVS zone
limit too.

Fixes: 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add was skipped")
Reported-by: Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/177349610461.3071718.4083978280323144323@eldamar.lan/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: remove the ESTABLISHED check as it is redundant for the relevant
protocols (UDP, TCP, SCTP).
---
 net/netfilter/nf_conncount.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 00eed5b4d1b1..facd7ffdf5c2 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -179,17 +179,16 @@ static int __nf_conncount_add(struct net *net,
 		return -ENOENT;
 
 	if (ct && nf_ct_is_confirmed(ct)) {
-		/* local connections are confirmed in postrouting so confirmation
-		 * might have happened before hitting connlimit
+		/* Connection is confirmed but might still be in the setup phase.
+		 * Only skip the tracking if it is fully assured. This guarantees
+		 * that setup packets or retransmissions are properly counted and
+		 * deduplicated.
 		 */
-		if (skb->skb_iif != LOOPBACK_IFINDEX) {
+		if (test_bit(IPS_ASSURED_BIT, &ct->status)) {
 			err = -EEXIST;
 			goto out_put;
 		}
 
-		/* this is likely a local connection, skip optimization to avoid
-		 * adding duplicates from a 'packet train'
-		 */
 		goto check_connections;
 	}
 
-- 
2.53.0

