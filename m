Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567922C11D5
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2026 10:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776768269; cv=none; b=nrdNfcS8oYm672zcWek+S8dS2Ic33XaaHFBR4Nx4aOTIO1b8NbrgaF6MrcFma9HbzRbqNekHGTsG1UIsG2taWYyhw4JHGaOMpoNrkVZr8oeaIAoDHM4vvioVTMg9t8QJ0wXDkB8aPE6HLMsyz98CUxDxZU2Vne1RfkCYw8OFTME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776768269; c=relaxed/simple;
	bh=mZxQvTFnBDxExGM6h13mh5BONBNuxGdsvq7Vqcu4Dw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEQQqQPymhGbTbeK/bNBxKaM3OmRl/13F6QTl5XT/ylOBdYc1BzSk7CBFQbEwkf8Izd85PMP4gSP35NzbX+K9+0THGK0HHyO6b7dzUNgz741UkzjUUXH9FikG17qWgnOZqp17Gm/eYQFiOKGUU42XI/i9RbN40VpRxxQqykwpqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jI6nNV4q; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=shBrUxKg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jI6nNV4q; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=shBrUxKg; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jI6nNV4q";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="shBrUxKg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jI6nNV4q";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="shBrUxKg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AA6E36A8EA;
	Tue, 21 Apr 2026 10:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776768265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aLYV60dJOhfP7PM3eyxs3RaF3jDLINC5IPyVm0xw7r0=;
	b=jI6nNV4qHkIHg1ZQnEMGlieCSdTjQAx6h1G7MkiI8JveQHHac+mBqutFCcYE3WJAZEfZoB
	nFu1fO+g+1BcXLBTXwxTr7+8vCXrYq0QezDgWANpXwNalwGyB2bJSs850fzuk8CDEqPq1y
	7YEeoCLolCMxZxpha5gyFE7xluf4+f8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776768265;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aLYV60dJOhfP7PM3eyxs3RaF3jDLINC5IPyVm0xw7r0=;
	b=shBrUxKgbcPLdQ7+kQWvko/ED1ekntGtOiChA6a3cvnyT1kGhs2Tp0zYnurs9+UwFRAJKN
	zYM1Tj4JLJykM/AQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776768265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aLYV60dJOhfP7PM3eyxs3RaF3jDLINC5IPyVm0xw7r0=;
	b=jI6nNV4qHkIHg1ZQnEMGlieCSdTjQAx6h1G7MkiI8JveQHHac+mBqutFCcYE3WJAZEfZoB
	nFu1fO+g+1BcXLBTXwxTr7+8vCXrYq0QezDgWANpXwNalwGyB2bJSs850fzuk8CDEqPq1y
	7YEeoCLolCMxZxpha5gyFE7xluf4+f8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776768265;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aLYV60dJOhfP7PM3eyxs3RaF3jDLINC5IPyVm0xw7r0=;
	b=shBrUxKgbcPLdQ7+kQWvko/ED1ekntGtOiChA6a3cvnyT1kGhs2Tp0zYnurs9+UwFRAJKN
	zYM1Tj4JLJykM/AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32BEC593AF;
	Tue, 21 Apr 2026 10:44:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UHtTCQlV52ljagAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 21 Apr 2026 10:44:25 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	ecklm94@gmail.com,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 3/3 nf v3] netfilter: xtables: fix L4 header parsing for non-first fragments
Date: Tue, 21 Apr 2026 12:44:09 +0200
Message-ID: <20260421104409.5452-3-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260421104409.5452-1-fmancera@suse.de>
References: <20260421104409.5452-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[netfilter.org,gmail.com,nwl.cc,strlen.de,suse.de];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 

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
v2: handled ecn, socket and tcpmss matches
v3: extracted socket to its own patch with a generic solution for
nft/xt, added a comment specifying that par->fragoff is fine for
ecn/tcpmss ipv6 as they enforce -p tcp. Keep on mind that osf only
supports ipv4.
---
 net/netfilter/xt_TPROXY.c | 11 +++++++++--
 net/netfilter/xt_ecn.c    |  4 ++++
 net/netfilter/xt_osf.c    |  3 +++
 net/netfilter/xt_tcpmss.c |  4 ++++
 4 files changed, 20 insertions(+), 2 deletions(-)

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

