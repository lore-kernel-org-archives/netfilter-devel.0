Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422AB3822A6
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jun 2026 19:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780342294; cv=none; b=pO9uQeWddMp7u0SPdcs7DOjB0hdPLR6VwBAH3mhVapPDgPmO8Zum3fNL7mTwHuXLCicfRBlTagas6Dup24+Wlfhrhb8HAxcl7wvPk/ULB91mKVyMUBETXcNcmj3T8dAkRTECleNdvzhH17xQ+8WvM1Gq3l9PjsQheTbRUwxeakg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780342294; c=relaxed/simple;
	bh=jS95fSe5REQhKOSIZEDXGpmkJm0FJoo0OpZGx9+OuQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVxohYh8bgbhoFBUhZl3xp0QePkNQ3w4GnPB303iBRS791sCuqsFpb01pAOsS9v6Y9n6Zyl8ZsMoY+ZgY8W3bz/uil76T8E14MkH8nJfOer2Whokh44TwQqVXe6ox7LUyY6zsmdVcvBP6V8TKhQBzrtnjXjjjKsOUDtUxeIWFO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pw9yC+CE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nKtJL7MS; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pw9yC+CE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nKtJL7MS; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pw9yC+CE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nKtJL7MS";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pw9yC+CE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nKtJL7MS"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5BC6867229;
	Mon,  1 Jun 2026 19:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780342265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RlAQpha4rrKruGS4R09AV4ReLg99uXBk4/5ZHKw97J0=;
	b=pw9yC+CE+tMX7ZGZDw0l17fhL9lpJArvdPiY2GIc9e9+ibYKedTXMKIRbk1qEX/N+CbV28
	zveuEUgaiT8Z0fYrap+nyGY/WGeMFwhJW0laAmeAB0Y1HrYq8/PNi//lypFwfndD1GqWnE
	3pEP3JNYQ1FVB9KC7MyzUQ4rURb8hRA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780342265;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RlAQpha4rrKruGS4R09AV4ReLg99uXBk4/5ZHKw97J0=;
	b=nKtJL7MSAQDiGjbqBZpLwGZ/JzX3K2GEn+3zOsJchNXqc88mObxMIHC0HYbqL9TBVS8QlC
	qBD7tbItl7TEWXBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pw9yC+CE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nKtJL7MS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780342265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RlAQpha4rrKruGS4R09AV4ReLg99uXBk4/5ZHKw97J0=;
	b=pw9yC+CE+tMX7ZGZDw0l17fhL9lpJArvdPiY2GIc9e9+ibYKedTXMKIRbk1qEX/N+CbV28
	zveuEUgaiT8Z0fYrap+nyGY/WGeMFwhJW0laAmeAB0Y1HrYq8/PNi//lypFwfndD1GqWnE
	3pEP3JNYQ1FVB9KC7MyzUQ4rURb8hRA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780342265;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RlAQpha4rrKruGS4R09AV4ReLg99uXBk4/5ZHKw97J0=;
	b=nKtJL7MSAQDiGjbqBZpLwGZ/JzX3K2GEn+3zOsJchNXqc88mObxMIHC0HYbqL9TBVS8QlC
	qBD7tbItl7TEWXBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F1C54779A7;
	Mon,  1 Jun 2026 19:31:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +BFAOPjdHWobLwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 01 Jun 2026 19:31:04 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 4/9 nf-next] netfilter: conntrack: use DEBUG_NET_WARN_ON_ONCE on packet paths
Date: Mon,  1 Jun 2026 21:30:44 +0200
Message-ID: <20260601193049.8131-5-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260601193049.8131-1-fmancera@suse.de>
References: <20260601193049.8131-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	R_RATELIMIT(0.00)[to_ip_from(RLdq3axj463rejm7ya15ar34kh)];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 5BC6867229
X-Spam-Score: -3.01

Replace WARN_ON and WARN_ON_ONCE with DEBUG_NET_WARN_ON_ONCE inside
conntrack confirmation, extension management, helper assignment, and
protocol parsing loops. This prevents unnecessary system panics when
panic_on_warn=1 is enabled in production systems.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_conntrack_core.c       | 2 +-
 net/netfilter/nf_conntrack_extend.c     | 3 ++-
 net/netfilter/nf_conntrack_helper.c     | 4 +++-
 net/netfilter/nf_conntrack_ovs.c        | 2 +-
 net/netfilter/nf_conntrack_proto_icmp.c | 3 ++-
 net/netfilter/nf_conntrack_seqadj.c     | 2 +-
 net/netfilter/nf_conntrack_sip.c        | 5 ++++-
 7 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8ba5b22a1eef..51e2d8ebe756 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1244,7 +1244,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	 * unconfirmed conntrack.
 	 */
 	if (unlikely(nf_ct_is_confirmed(ct))) {
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		nf_conntrack_double_unlock(hash, reply_hash);
 		local_bh_enable();
 		return NF_DROP;
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index dd62cc12e775..68169007aea2 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -95,7 +95,8 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	struct nf_ct_ext *new;
 
 	/* Conntrack must not be confirmed to avoid races on reallocation. */
-	WARN_ON(nf_ct_is_confirmed(ct));
+	if (unlikely(nf_ct_is_confirmed(ct)))
+		DEBUG_NET_WARN_ON_ONCE(1);
 
 	/* struct nf_ct_ext uses u8 to store offsets/size */
 	BUILD_BUG_ON(total_extension_size() > 255u);
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 17e971bd4c74..0a0e41dd4c95 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -198,8 +198,10 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	if (test_bit(IPS_HELPER_BIT, &ct->status))
 		return 0;
 
-	if (WARN_ON_ONCE(!tmpl))
+	if (unlikely(!tmpl)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return 0;
+	}
 
 	help = nfct_help(tmpl);
 	if (help != NULL) {
diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
index a6988eeb1579..26f12dd0c1a4 100644
--- a/net/netfilter/nf_conntrack_ovs.c
+++ b/net/netfilter/nf_conntrack_ovs.c
@@ -53,7 +53,7 @@ int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
 		break;
 	}
 	default:
-		WARN_ONCE(1, "helper invoked on non-IP family!");
+		DEBUG_NET_WARN_ONCE(1, "helper invoked on non-IP family!");
 		return NF_DROP;
 	}
 
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index 32148a3a8509..0f39cb147c4f 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -117,7 +117,8 @@ int nf_conntrack_inet_error(struct nf_conn *tmpl, struct sk_buff *skb,
 	enum ip_conntrack_dir dir;
 	struct nf_conn *ct;
 
-	WARN_ON(skb_nfct(skb));
+	if (unlikely(skb_nfct(skb)))
+		DEBUG_NET_WARN_ON_ONCE(1);
 	zone = nf_ct_zone_tmpl(tmpl, skb, &tmp);
 
 	/* Are they talking about one of our connections? */
diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index 7ab2b25b57bc..2bf49f0b9406 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -38,7 +38,7 @@ int nf_ct_seqadj_set(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 		return 0;
 
 	if (unlikely(!seqadj)) {
-		WARN_ONCE(1, "Missing nfct_seqadj_ext_add() setup call\n");
+		DEBUG_NET_WARN_ONCE(1, "Missing nfct_seqadj_ext_add() setup call\n");
 		return 0;
 	}
 
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index e69941f1a101..7e9237c810a0 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -599,7 +599,10 @@ int ct_sip_parse_header_uri(const struct nf_conn *ct, const char *dptr,
 
 	ret = ct_sip_walk_headers(ct, dptr, dataoff ? *dataoff : 0, datalen,
 				  type, in_header, matchoff, matchlen);
-	WARN_ON(ret < 0);
+	if (unlikely(ret < 0)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
+		return -1;
+	}
 	if (ret == 0)
 		return ret;
 
-- 
2.54.0

