Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB512E88BD
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 10:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777371970; cv=none; b=sAlZwmfC9sDo1/24jbjQ41UBOvMxdOWYnQEbTwf1vnVsfgosiCcksBCTmN0KBmI0AnOnzSVcprpAkFEaIxN6/oxNcVU3sZlGnkOuPsGt9SQkJzcWg9RHP8ru2k8wMgh4wmh/m+iibdd/1y+cUWq81uxGncwwi3zZWZnylpRVdgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777371970; c=relaxed/simple;
	bh=VpSVSZyMW0rSaxr/v22jtaRSenXz6fQFlo/1yOhHEg4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jsKyOBXaEUvYxkLwHh62srfL/xDsByQAfu1rHPQW0jRP30lg92ppphifKj7tPZmAJr4cPoskVH123hF5aDwYYAWxCrd77XQb8ZhcuMshDRUBvVi9SWyFaO2LGtjFzjedipadAlmzDEBbKuJiblMoLg/DqMvGV+37ogm0Dk2hNuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rxEPXk8t; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cb2hCVou; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rxEPXk8t; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cb2hCVou; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rxEPXk8t";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cb2hCVou";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rxEPXk8t";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cb2hCVou"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AC5796A950;
	Tue, 28 Apr 2026 10:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777371967; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9DIzRQ4Gpyib9bPlcvhirpG2scQPykhlmagVx7DewO4=;
	b=rxEPXk8taPVpGY9j5+iJruS2IWPHEBQR9MkJ8xJ9Quq5yVQS1t/W/en5sh72rCoSQu33m4
	6+JlUn6SyEhrBEZJcA2Ve7290BM8PRA1veKvKWw4RnkoSpdpvYxsx03uDskI1r73pJFVFD
	lsf2nxn5+GgsyCCF0AtIR11o2x9ge4w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777371967;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9DIzRQ4Gpyib9bPlcvhirpG2scQPykhlmagVx7DewO4=;
	b=cb2hCVouhsaERp0iIr3VkGbnL5gCVNeWZ7TEBxtz5+LwpponnjcLCKBdBdJsAQh7/Fy1Do
	gT4eQPwoxRoeKlBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rxEPXk8t;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cb2hCVou
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777371967; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9DIzRQ4Gpyib9bPlcvhirpG2scQPykhlmagVx7DewO4=;
	b=rxEPXk8taPVpGY9j5+iJruS2IWPHEBQR9MkJ8xJ9Quq5yVQS1t/W/en5sh72rCoSQu33m4
	6+JlUn6SyEhrBEZJcA2Ve7290BM8PRA1veKvKWw4RnkoSpdpvYxsx03uDskI1r73pJFVFD
	lsf2nxn5+GgsyCCF0AtIR11o2x9ge4w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777371967;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9DIzRQ4Gpyib9bPlcvhirpG2scQPykhlmagVx7DewO4=;
	b=cb2hCVouhsaERp0iIr3VkGbnL5gCVNeWZ7TEBxtz5+LwpponnjcLCKBdBdJsAQh7/Fy1Do
	gT4eQPwoxRoeKlBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D8C5593B0;
	Tue, 28 Apr 2026 10:26:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OG8uED+L8GmULQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 28 Apr 2026 10:26:07 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 1/3 nf v5] netfilter: nf_socket: skip socket lookup for non-first fragments
Date: Tue, 28 Apr 2026 12:25:46 +0200
Message-ID: <20260428102548.6750-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: AC5796A950

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
v5: no changes
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

