Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13862EBB99
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 20:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854970; cv=none; b=HXuMyPZ8dw0iRyFRr4m2L7+Vr1YbJJ22CD4oPg9Gm9//tBssdFc2nb+ciD/0S5tSvm00UiZWtgvbuJ4ncYHswkTYJ9zrw+y0n4pou21uf0ovgCltVzjbOlV347N7KH6xp7dFoJLD6u3UcbiJ3ipISXS7jy6F9BNQK6g+7rsUcaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854970; c=relaxed/simple;
	bh=nxZNnu1cAZS9dpA+E9d+Ss8kHkUOHAjHZu3Cjr/Dcec=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hF8CJ0T5uqlBTtZDUCruIu5P/2bXFNTE+RSpaefqiwIko97nfeBYso/AhQcCfdU9FluoRdc/1ls6avgtfGgRtj2RR/pVQ5M1hQvOn/ueqgH32r2U0xyA6ozxABZ3B0FtUHZ4/GpvEc3ngL9rXkwuknliZ2gSvOPTeI7ZTFC8iHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rq/14XW6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5l1Fv6HM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vg/8Zhf6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UJC8JXuI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rq/14XW6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5l1Fv6HM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vg/8Zhf6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UJC8JXuI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E55D1337BE;
	Mon, 19 Jan 2026 20:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768854967; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=YJ9U1q6TAgQfn2HBv9rip+sHKcLgGEQSiejbq3zI3xQ=;
	b=rq/14XW6CVb9VC4JTQZBmozQc+9CZcvv/B7OSUX0wwtUQLHAuxIJBWOYpxrtXvBkByjbV+
	LNYt552kAZ3KFc4NtnKKUwE1UpJnu197T7eJWA03Wt7JGBYVadKA3Yag2qVvU+/l3WKTxQ
	1HETGOcfXMcFQbP6oMdBXS+W+1R6dgI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768854967;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=YJ9U1q6TAgQfn2HBv9rip+sHKcLgGEQSiejbq3zI3xQ=;
	b=5l1Fv6HMz3eBROm6Yjg8yv1yE0ASJ80dyZE/HY11Wp/yKAgZzJ3PeglbLkIlfEkI9bdpzH
	dlNq2FddbvKKNdAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768854966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=YJ9U1q6TAgQfn2HBv9rip+sHKcLgGEQSiejbq3zI3xQ=;
	b=vg/8Zhf6Nhnz1r+vn+vHX7ibrlxUOetGYe1CF64ijUKDYddGgK30n8ko7tSClsal763jPH
	Nkc1jjg5dYssJlfAqAKCooncbJrqxoENmqFTDK7AUqYEGE4cDL9v/G0kalafC/YU4OEeav
	DZg8TrDrz957BOO3ZzgbJzVsn4XZd5w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768854966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=YJ9U1q6TAgQfn2HBv9rip+sHKcLgGEQSiejbq3zI3xQ=;
	b=UJC8JXuIBEUCT/d6cRhTsD45ITfUvBp616pKUUFhD0pdxlR7WTklAFXjUsbZoh+aMU5+I+
	i5K/G/GqXkM/1aDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 651723EA63;
	Mon, 19 Jan 2026 20:36:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +dVhFbaVbmlZYAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 19 Jan 2026 20:36:06 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Michal Slabihoudek <michal.slabihoudek@gooddata.com>
Subject: [PATCH nf-next v2] netfilter: nf_conncount: fix tracking of connections from localhost
Date: Mon, 19 Jan 2026 21:35:46 +0100
Message-ID: <20260119203546.11207-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Since commit be102eb6a0e7 ("netfilter: nf_conncount: rework API to use
sk_buff directly"), we skip the adding and trigger a GC when the ct is
confirmed. For connections originated from local to local it doesn't
work because the connection is confirmed on POSTROUTING, therefore
tracking on the INPUT hook is always skipped.

In order to fix this, we check whether skb input ifindex is set to
loopback ifindex. If it is then we fallback on a GC plus track operation
skipping the optimization. This fallback is necessary to avoid
duplicated tracking of a packet train e.g 10 UDP datagrams sent on a
burst when initiating the connection.

Tested with xt_connlimit/nft_connlimit and OVS limit and with a HTTP
server and iperf3 on UDP mode.

Fixes: be102eb6a0e7 ("netfilter: nf_conncount: rework API to use sk_buff directly")
Reported-by: Michal Slabihoudek <michal.slabihoudek@gooddata.com>
Closes: https://lore.kernel.org/netfilter/6989BD9F-8C24-4397-9AD7-4613B28BF0DB@gooddata.com/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: use skb_iif to understand if this is a local connection
---
 net/netfilter/nf_conncount.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 288936f5c1bf..14e62b3263cd 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -179,14 +179,25 @@ static int __nf_conncount_add(struct net *net,
 		return -ENOENT;
 
 	if (ct && nf_ct_is_confirmed(ct)) {
-		err = -EEXIST;
-		goto out_put;
+		/* local connections are confirmed in postrouting so confirmation
+		 * might have happened before hitting connlimit
+		 */
+		if (skb->skb_iif != LOOPBACK_IFINDEX) {
+			err = -EEXIST;
+			goto out_put;
+		}
+
+		/* this is likely a local connection, skip optimization to avoid
+		 * adding duplicates from a 'packet train'
+		 */
+		goto check_connections;
 	}
 
 	if ((u32)jiffies == list->last_gc &&
 	    (list->count - list->last_gc_count) < CONNCOUNT_GC_MAX_COLLECT)
 		goto add_new_node;
 
+check_connections:
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
 		if (collect > CONNCOUNT_GC_MAX_COLLECT)
-- 
2.52.0

