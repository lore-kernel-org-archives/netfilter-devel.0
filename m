Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142082E88BD
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 10:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777371981; cv=none; b=Iq4MRkeUgUZHYl70kOiyX2Kb6GE0/AiUA40SbqJ2t17S+cMCnBVRhcXCpwJH7BAuazSYyUxqpMhbSeujfBECAuBGuhnynoTHxbBy66DPnlO66wrKrLiW2odBHk98t6QFXQPLYVfSJuzxr9BxPtHati3+j2Lzt36YQ1WbGtbrgVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777371981; c=relaxed/simple;
	bh=1Z/aGsZ6C/KiTZ2VSdA6wlvR7E2E1C5ms6iPrV5sSJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KX89cy1zdLTuyhEfvk0sV9yGgQ10UGmGVrgUFQcHr6vnHJq9ExzRaQinX4eAzOE+7BXRILs6DYYehnepQNxUkZ1SszDockOh3P+r8ZVby0nxd5ECbVhZg8VyJIbiroGd7CkJO8gmUiK4s5nlqPbZPtyRwNS4US+enOlPhdyNBzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JPVNfWvf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZgvM3pQJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JPVNfWvf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZgvM3pQJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JPVNfWvf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZgvM3pQJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JPVNfWvf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZgvM3pQJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 47C755BD47;
	Tue, 28 Apr 2026 10:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777371974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FhI7v75tFq+ikwUFQEh637dTzCptpsG8gJkjec0EqGc=;
	b=JPVNfWvfmi0xBkxOyxf2Ptw0jjPu0hxZySUNBvahxfX2dXFnMiBa+jSG7A67QQbdpd6FKG
	HBGjlk6ZTCaqI799ydbYJPOeaqWSi1iVpkfylzA5nwfJ4SBOryLfSmkCcC7X+YpZlQHc2v
	BFK6Cxf2wS7FnRXipPTrvW7XjlPGWDk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777371974;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FhI7v75tFq+ikwUFQEh637dTzCptpsG8gJkjec0EqGc=;
	b=ZgvM3pQJZWdZ/3lSJC98Qjeq0LhrdnolieCliADmh8lFGVP/Fxl0K41cdKf8GDNfe5KFCJ
	mfUYChgygwYQvWDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777371974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FhI7v75tFq+ikwUFQEh637dTzCptpsG8gJkjec0EqGc=;
	b=JPVNfWvfmi0xBkxOyxf2Ptw0jjPu0hxZySUNBvahxfX2dXFnMiBa+jSG7A67QQbdpd6FKG
	HBGjlk6ZTCaqI799ydbYJPOeaqWSi1iVpkfylzA5nwfJ4SBOryLfSmkCcC7X+YpZlQHc2v
	BFK6Cxf2wS7FnRXipPTrvW7XjlPGWDk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777371974;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FhI7v75tFq+ikwUFQEh637dTzCptpsG8gJkjec0EqGc=;
	b=ZgvM3pQJZWdZ/3lSJC98Qjeq0LhrdnolieCliADmh8lFGVP/Fxl0K41cdKf8GDNfe5KFCJ
	mfUYChgygwYQvWDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DD300593B0;
	Tue, 28 Apr 2026 10:26:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eKU7M0WL8GmULQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 28 Apr 2026 10:26:13 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 3/3 nf v5] netfilter: xtables: fix L4 header parsing for non-first fragments
Date: Tue, 28 Apr 2026 12:25:48 +0200
Message-ID: <20260428102548.6750-3-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260428102548.6750-1-fmancera@suse.de>
References: <20260428102548.6750-1-fmancera@suse.de>
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
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO

Multiple targets and matches relies on L4 header to operate. For
fragmented packets, every fragment carries the transport protocol
identifier, but only the first fragment contains the L4 header.

As the 'raw' table can be configured to run at priority -450 (before
defragmentation at -400), the target/match can be reached before
reassembly. In this case, non-first fragments have their payload
incorrectly parsed as a TCP/UDP header. This would be of course a
misconfiguration scenario. In most of the cases this just lead to a
unreliable behavior for fragmented traffic.

Add a fragment check to ensure target/match only evaluates unfragmented
packets or the first fragment in the stream.

Fixes: 902d6a4c2a4f ("netfilter: nf_defrag: Skip defrag if NOTRACK is set")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: handled fragmented packets for socket expression too,
squashed nftables expression commits into this one.
v3: removed changes to nft_socket and created a generic solution for
xt/nft
v4: no changes
v5: no changes
---
 net/netfilter/xt_TPROXY.c    | 11 +++++++++--
 net/netfilter/xt_ecn.c       |  4 ++++
 net/netfilter/xt_hashlimit.c |  4 +++-
 net/netfilter/xt_osf.c       |  3 +++
 net/netfilter/xt_tcpmss.c    |  4 ++++
 5 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index e4bea1d346cf..5f60e7298a1e 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -86,6 +86,9 @@ tproxy_tg4_v0(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tproxy_target_info *tgi = par->targinfo;
 
+	if (par->fragoff)
+		return NF_DROP;
+
 	return tproxy_tg4(xt_net(par), skb, tgi->laddr, tgi->lport,
 			  tgi->mark_mask, tgi->mark_value);
 }
@@ -95,6 +98,9 @@ tproxy_tg4_v1(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tproxy_target_info_v1 *tgi = par->targinfo;
 
+	if (par->fragoff)
+		return NF_DROP;
+
 	return tproxy_tg4(xt_net(par), skb, tgi->laddr.ip, tgi->lport,
 			  tgi->mark_mask, tgi->mark_value);
 }
@@ -106,6 +112,7 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
 	const struct xt_tproxy_target_info_v1 *tgi = par->targinfo;
+	unsigned short fragoff = 0;
 	struct udphdr _hdr, *hp;
 	struct sock *sk;
 	const struct in6_addr *laddr;
@@ -113,8 +120,8 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 	int thoff = 0;
 	int tproto;
 
-	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
-	if (tproto < 0)
+	tproto = ipv6_find_hdr(skb, &thoff, -1, &fragoff, NULL);
+	if (tproto < 0 || fragoff)
 		return NF_DROP;
 
 	hp = skb_header_pointer(skb, thoff, sizeof(_hdr), &_hdr);
diff --git a/net/netfilter/xt_ecn.c b/net/netfilter/xt_ecn.c
index b96e8203ac54..a8503f5d26bf 100644
--- a/net/netfilter/xt_ecn.c
+++ b/net/netfilter/xt_ecn.c
@@ -30,6 +30,10 @@ static bool match_tcp(const struct sk_buff *skb, struct xt_action_param *par)
 	struct tcphdr _tcph;
 	const struct tcphdr *th;
 
+	/* this is fine for IPv6 as ecn_mt_check6() enforces -p tcp */
+	if (par->fragoff)
+		return false;
+
 	/* In practice, TCP match does this, so can't fail.  But let's
 	 * be good citizens.
 	 */
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 3bd127bfc114..2704b4b60d1e 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -658,6 +658,8 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 		if (!(hinfo->cfg.mode &
 		      (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)))
 			return 0;
+		if (ntohs(ip_hdr(skb)->frag_off) & IP_OFFSET)
+			return -1;
 		nexthdr = ip_hdr(skb)->protocol;
 		break;
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
@@ -681,7 +683,7 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 			return 0;
 		nexthdr = ipv6_hdr(skb)->nexthdr;
 		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr, &frag_off);
-		if ((int)protoff < 0)
+		if ((int)protoff < 0 || ntohs(frag_off) & IP6_OFFSET)
 			return -1;
 		break;
 	}
diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index dc9485854002..e8807caede68 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -27,6 +27,9 @@
 static bool
 xt_osf_match_packet(const struct sk_buff *skb, struct xt_action_param *p)
 {
+	if (p->fragoff)
+		return false;
+
 	return nf_osf_match(skb, xt_family(p), xt_hooknum(p), xt_in(p),
 			    xt_out(p), p->matchinfo, xt_net(p), nf_osf_fingers);
 }
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 0d32d4841cb3..b9da8269161d 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -32,6 +32,10 @@ tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	u8 _opt[15 * 4 - sizeof(_tcph)];
 	unsigned int i, optlen;
 
+	/* this is fine for IPv6 as xt_tcpmss enforces -p tcp */
+	if (par->fragoff)
+		return false;
+
 	/* If we don't have the whole header, drop packet. */
 	th = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);
 	if (th == NULL)
-- 
2.53.0

