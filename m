Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43612F39AB
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 11:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777289265; cv=none; b=i78I7Sv5tl9XYFkCZ7x5/9GGQTSADEVbKquQZ4H46xhFjeWfshes1yQAkD4MAsoub8CLCZ9K3St1+NeL11Y17pZpHuvuoe1B52UOQcLk4za86PDgyhPovvCNi3DYtnuRbMk9T09IzdWr3mGh7HSiXVxMtyaP0WdcRRB7aJ2D5/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777289265; c=relaxed/simple;
	bh=zE9lE7tXHu1N8bQGQevHhdhp3yEztjauQVoLoYT+heU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DCqoy4+9RrmoJi70t9wjFfCPUynYHbapirstemaVkjWd3Wtuvz/5AnT58QTg3V+hkBjxjcsRklkJJFgvQ6iKOpp7N81eSA8Y4gjZFGPRim/L4geG0gyLbVJbfirORtMSB8WVWBbcACoYgS4DDGtetoLXnSLh4SKtrAuX9R3z7bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eNLcuHco; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sDZucj+x; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eNLcuHco; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sDZucj+x; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eNLcuHco";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sDZucj+x";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eNLcuHco";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sDZucj+x"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6894B6A8EA;
	Mon, 27 Apr 2026 11:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777289262; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sKCU0l/xvjIXGxXWxz31UFpwzqOV0fWt8DuK0iC+hxY=;
	b=eNLcuHcoDMqdcC/YSVGM81xwufd9cLRTtkLbO3BGLkipun7uQp8iubddm2aKx/cmJ8+Ejc
	Je1McAIXWSmckYzlMD0T+qlSZhwapiF0A+lvVquZvzqzOVpTekJlfJkZKAQtOx9TcYqpZ2
	CjmgorOxPzsMH+J0UniJqE9yGRdjGKs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777289262;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sKCU0l/xvjIXGxXWxz31UFpwzqOV0fWt8DuK0iC+hxY=;
	b=sDZucj+xNSW5DNyNwaAUrpr9DUUIUY0Z6akvkiaBxxMzlZWtCHaH4l3+VbOCDxe5jTREWX
	kDI+LHNT0ELkkNDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777289262; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sKCU0l/xvjIXGxXWxz31UFpwzqOV0fWt8DuK0iC+hxY=;
	b=eNLcuHcoDMqdcC/YSVGM81xwufd9cLRTtkLbO3BGLkipun7uQp8iubddm2aKx/cmJ8+Ejc
	Je1McAIXWSmckYzlMD0T+qlSZhwapiF0A+lvVquZvzqzOVpTekJlfJkZKAQtOx9TcYqpZ2
	CjmgorOxPzsMH+J0UniJqE9yGRdjGKs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777289262;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sKCU0l/xvjIXGxXWxz31UFpwzqOV0fWt8DuK0iC+hxY=;
	b=sDZucj+xNSW5DNyNwaAUrpr9DUUIUY0Z6akvkiaBxxMzlZWtCHaH4l3+VbOCDxe5jTREWX
	kDI+LHNT0ELkkNDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 051A8593B0;
	Mon, 27 Apr 2026 11:27:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EY73OS1I72kaWgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 27 Apr 2026 11:27:41 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 1/3 nf v4] netfilter: nf_socket: skip socket lookup for non-first fragments
Date: Mon, 27 Apr 2026 13:27:18 +0200
Message-ID: <20260427112720.5128-1-fmancera@suse.de>
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
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.984];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Both nft_socket and xt_socket relies on L4 headers to perform socket
lookup in the slow path. For fragmented packets, while the IP protocol
remains constant across all fragments, only the first fragment contains
the actual L4 header.

As the expression/match could be attached to a chain with a priority
lower than -400, it could bypass defragmentation.

Add a check for fragmentation in the lookup functions directly so the
problem is handled for both nft_socket and xt_socket at the same time.
In addition, future users of the functions would not need to care about
this.

Fixes: 902d6a4c2a4f ("netfilter: nf_defrag: Skip defrag if NOTRACK is set")
Fixes: 554ced0a6e29 ("netfilter: nf_tables: add support for native socket matching")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v3: added this patch to the series, I splitted this as the fix is
generic for both nft_socket and xt_socket
v4: no changes
---
 net/ipv4/netfilter/nf_socket_ipv4.c | 3 +++
 net/ipv6/netfilter/nf_socket_ipv6.c | 5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_socket_ipv4.c b/net/ipv4/netfilter/nf_socket_ipv4.c
index 5080fa5fbf6a..f9c6755f5ec5 100644
--- a/net/ipv4/netfilter/nf_socket_ipv4.c
+++ b/net/ipv4/netfilter/nf_socket_ipv4.c
@@ -94,6 +94,9 @@ struct sock *nf_sk_lookup_slow_v4(struct net *net, const struct sk_buff *skb,
 #endif
 	int doff = 0;
 
+	if (ntohs(iph->frag_off) & IP_OFFSET)
+		return NULL;
+
 	if (iph->protocol == IPPROTO_UDP || iph->protocol == IPPROTO_TCP) {
 		struct tcphdr _hdr;
 		struct udphdr *hp;
diff --git a/net/ipv6/netfilter/nf_socket_ipv6.c b/net/ipv6/netfilter/nf_socket_ipv6.c
index ced8bd44828e..893f2aeb4711 100644
--- a/net/ipv6/netfilter/nf_socket_ipv6.c
+++ b/net/ipv6/netfilter/nf_socket_ipv6.c
@@ -100,6 +100,7 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 	const struct in6_addr *daddr = NULL, *saddr = NULL;
 	struct ipv6hdr *iph = ipv6_hdr(skb), ipv6_var;
 	struct sk_buff *data_skb = NULL;
+	unsigned short fragoff = 0;
 	int doff = 0;
 	int thoff = 0, tproto;
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
@@ -107,8 +108,8 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 	struct nf_conn const *ct;
 #endif
 
-	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
-	if (tproto < 0) {
+	tproto = ipv6_find_hdr(skb, &thoff, -1, &fragoff, NULL);
+	if (tproto < 0 || fragoff) {
 		pr_debug("unable to find transport header in IPv6 packet, dropping\n");
 		return NULL;
 	}
-- 
2.53.0

