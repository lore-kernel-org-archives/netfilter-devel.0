Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C531833FE12
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 15:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774883991; cv=none; b=ONE+x8F/dRvEGSOrwVGfTxVjYU4BhKpIos/t13tLOKQCTYwfChgLPff9NslQB/KBbbM+yCO+/HdHwji3iDuNXChcQFAHrzUkCM88Z0W+fCuah+Xe6kF+Xs0EZD29EEoVmEa+5mz0F/xdvMqkWLFVuteJdF3cDUXr+6c87o1jtP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774883991; c=relaxed/simple;
	bh=CyTIFKIJvMHzxrjnSBhz+Zbe1eHRGjdFPAXaOVmGj90=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=APQOQGBr5G/bmkBRP/xLfvP7jQ0xwT7NUT4j3D4lckfmhoaGzo9uDWOcStXDz5/aDZvOuyUXIE4IjtiZin4gldA8BjpAOJkOw1ijI9IWsGxl/k6dsBAKglTRrlaZw4PQL2/pjdJJ8lGRePxFddDI4Kh+T6Nzj/ClHWkyw2dO8kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QMOPEMml; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BwoYpsxZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iascoNTo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DeGSQ9E7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QMOPEMml";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BwoYpsxZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iascoNTo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DeGSQ9E7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ECB6B4D20F;
	Mon, 30 Mar 2026 15:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774883988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=A5rXH0Re9hSzJY9t2thgtUcE5GPd6Agxz4wt3QB/xOo=;
	b=QMOPEMmlUdxpZMcxkjdWoiTsWg8UsvarB2U5YmciYF1yC3FT0558MUc1dVmm5xu62AULRu
	4OcmahiGtrxqyoDDzMnbFFJxtL9YXO3gxDIZkIIOY9+8yvyedhtrNtO37BYSHBWubAR7YY
	WuwGM9OgJRJCBTMzYQzxWPprm6PNH0k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774883988;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=A5rXH0Re9hSzJY9t2thgtUcE5GPd6Agxz4wt3QB/xOo=;
	b=BwoYpsxZ5WEKrx/X2FCb/H+eu3pfnybQvvKPUts58btUK9JR3KojUZlsbJIs9zQPMdeh1S
	qD9Hkj8m06p9pTAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774883987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=A5rXH0Re9hSzJY9t2thgtUcE5GPd6Agxz4wt3QB/xOo=;
	b=iascoNTosSbFFT82xiDKmqFhEmbAjUCMElBwNhyFTReJM9VBApUUJMLILswwJ6UCl3UD/S
	mvdOC80DCACsstldnaT6/L/LdDyonSSKG+iNXRFnjdvmcfQlGnl+PZfwpBS6y2f5Uqb5pC
	a+tBJlRhHSsW8HNIbxKzd7rsAoMrVBI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774883987;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=A5rXH0Re9hSzJY9t2thgtUcE5GPd6Agxz4wt3QB/xOo=;
	b=DeGSQ9E7hrqywLkinRmrD8GNZO+iKaZ6HE8sooAz4c7vHQ2E3zdxENqmCF4p6xgE6yR+fo
	IJ6TT+7CTQZpIGBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E32D4A0A2;
	Mon, 30 Mar 2026 15:19:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6Z2lG5OUymn8EQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 30 Mar 2026 15:19:47 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 1/2 nf-next] netfilter: conntrack: remove UDP-Lite conntrack support
Date: Mon, 30 Mar 2026 17:19:34 +0200
Message-ID: <20260330151935.5828-1-fmancera@suse.de>
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
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

UDP-Lite (RFC 3828) socket support was recently retired from the core
networking stack. As a follow-up of that, drop the connection tracker
and NAT support for UDP-Lite in Netfilter.

This patch removes CONFIG_NF_CT_PROTO_UDPLITE and scrubs UDP-Lite
awareness from the conntrack core, NAT core, nft_ct, and ctnetlink.
Please note that stateless packet inspection, matching, ipsets or
logging support for IPPROTO_UDPLITE is preserved.

As conntrack no longer extracts UDP-Lite ports or tracks its L4 state,
when performing NAT the UDP-Lite checksum cannot be updated anymore.
That is an expected and acceptable consequence of removing UDP-Lite
conntrack module.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 .../net/netfilter/ipv4/nf_conntrack_ipv4.h    |   3 -
 include/net/netfilter/nf_conntrack_l4proto.h  |   5 -
 net/netfilter/Kconfig                         |  11 --
 net/netfilter/nf_conntrack_core.c             |   8 --
 net/netfilter/nf_conntrack_proto.c            |   3 -
 net/netfilter/nf_conntrack_proto_udp.c        | 108 ------------------
 net/netfilter/nf_conntrack_standalone.c       |   2 -
 net/netfilter/nf_nat_core.c                   |   6 -
 net/netfilter/nf_nat_proto.c                  |  20 ----
 net/netfilter/nfnetlink_cttimeout.c           |   1 -
 net/netfilter/nft_ct.c                        |   1 -
 11 files changed, 168 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 8d65ffbf57de..b39417ad955e 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -16,9 +16,6 @@ extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp;
 #ifdef CONFIG_NF_CT_PROTO_SCTP
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp;
 #endif
-#ifdef CONFIG_NF_CT_PROTO_UDPLITE
-extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite;
-#endif
 #ifdef CONFIG_NF_CT_PROTO_GRE
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre;
 #endif
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index cd5020835a6d..91f5254ad6fa 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -107,11 +107,6 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
 			    unsigned int dataoff,
 			    enum ip_conntrack_info ctinfo,
 			    const struct nf_hook_state *state);
-int nf_conntrack_udplite_packet(struct nf_conn *ct,
-				struct sk_buff *skb,
-				unsigned int dataoff,
-				enum ip_conntrack_info ctinfo,
-				const struct nf_hook_state *state);
 int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			    struct sk_buff *skb,
 			    unsigned int dataoff,
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 6cdc994fdc8a..276f4652596a 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -209,17 +209,6 @@ config NF_CT_PROTO_SCTP
 
 	  If unsure, say Y.
 
-config NF_CT_PROTO_UDPLITE
-	bool 'UDP-Lite protocol connection tracking support'
-	depends on NETFILTER_ADVANCED
-	default y
-	help
-	  With this option enabled, the layer 3 independent connection
-	  tracking code will be able to do state tracking on UDP-Lite
-	  connections.
-
-	  If unsure, say Y.
-
 config NF_CONNTRACK_AMANDA
 	tristate "Amanda backup protocol support"
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 27ce5fda8993..b08189226320 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -323,9 +323,6 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 #endif
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
-#ifdef CONFIG_NF_CT_PROTO_UDPLITE
-	case IPPROTO_UDPLITE:
-#endif
 #ifdef CONFIG_NF_CT_PROTO_SCTP
 	case IPPROTO_SCTP:
 #endif
@@ -1987,11 +1984,6 @@ static int nf_conntrack_handle_packet(struct nf_conn *ct,
 	case IPPROTO_ICMPV6:
 		return nf_conntrack_icmpv6_packet(ct, skb, ctinfo, state);
 #endif
-#ifdef CONFIG_NF_CT_PROTO_UDPLITE
-	case IPPROTO_UDPLITE:
-		return nf_conntrack_udplite_packet(ct, skb, dataoff,
-						   ctinfo, state);
-#endif
 #ifdef CONFIG_NF_CT_PROTO_SCTP
 	case IPPROTO_SCTP:
 		return nf_conntrack_sctp_packet(ct, skb, dataoff,
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index bc1d96686b9c..50ddd3d613e1 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -103,9 +103,6 @@ const struct nf_conntrack_l4proto *nf_ct_l4proto_find(u8 l4proto)
 #ifdef CONFIG_NF_CT_PROTO_SCTP
 	case IPPROTO_SCTP: return &nf_conntrack_l4proto_sctp;
 #endif
-#ifdef CONFIG_NF_CT_PROTO_UDPLITE
-	case IPPROTO_UDPLITE: return &nf_conntrack_l4proto_udplite;
-#endif
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	case IPPROTO_GRE: return &nf_conntrack_l4proto_gre;
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 0030fbe8885c..cc9b7e5e1935 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -129,91 +129,6 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
 	return NF_ACCEPT;
 }
 
-#ifdef CONFIG_NF_CT_PROTO_UDPLITE
-static void udplite_error_log(const struct sk_buff *skb,
-			      const struct nf_hook_state *state,
-			      const char *msg)
-{
-	nf_l4proto_log_invalid(skb, state, IPPROTO_UDPLITE, "%s", msg);
-}
-
-static bool udplite_error(struct sk_buff *skb,
-			  unsigned int dataoff,
-			  const struct nf_hook_state *state)
-{
-	unsigned int udplen = skb->len - dataoff;
-	const struct udphdr *hdr;
-	struct udphdr _hdr;
-	unsigned int cscov;
-
-	/* Header is too small? */
-	hdr = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
-	if (!hdr) {
-		udplite_error_log(skb, state, "short packet");
-		return true;
-	}
-
-	cscov = ntohs(hdr->len);
-	if (cscov == 0) {
-		cscov = udplen;
-	} else if (cscov < sizeof(*hdr) || cscov > udplen) {
-		udplite_error_log(skb, state, "invalid checksum coverage");
-		return true;
-	}
-
-	/* UDPLITE mandates checksums */
-	if (!hdr->check) {
-		udplite_error_log(skb, state, "checksum missing");
-		return true;
-	}
-
-	/* Checksum invalid? Ignore. */
-	if (state->hook == NF_INET_PRE_ROUTING &&
-	    state->net->ct.sysctl_checksum &&
-	    nf_checksum_partial(skb, state->hook, dataoff, cscov, IPPROTO_UDP,
-				state->pf)) {
-		udplite_error_log(skb, state, "bad checksum");
-		return true;
-	}
-
-	return false;
-}
-
-/* Returns verdict for packet, and may modify conntracktype */
-int nf_conntrack_udplite_packet(struct nf_conn *ct,
-				struct sk_buff *skb,
-				unsigned int dataoff,
-				enum ip_conntrack_info ctinfo,
-				const struct nf_hook_state *state)
-{
-	unsigned int *timeouts;
-
-	if (udplite_error(skb, dataoff, state))
-		return -NF_ACCEPT;
-
-	timeouts = nf_ct_timeout_lookup(ct);
-	if (!timeouts)
-		timeouts = udp_get_timeouts(nf_ct_net(ct));
-
-	/* If we've seen traffic both ways, this is some kind of UDP
-	   stream.  Extend timeout. */
-	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
-		nf_ct_refresh_acct(ct, ctinfo, skb,
-				   timeouts[UDP_CT_REPLIED]);
-
-		if (unlikely((ct->status & IPS_NAT_CLASH)))
-			return NF_ACCEPT;
-
-		/* Also, more likely to be important, and not a probe */
-		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
-			nf_conntrack_event_cache(IPCT_ASSURED, ct);
-	} else {
-		nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[UDP_CT_UNREPLIED]);
-	}
-	return NF_ACCEPT;
-}
-#endif
-
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 
 #include <linux/netfilter/nfnetlink.h>
@@ -299,26 +214,3 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp =
 	},
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 };
-
-#ifdef CONFIG_NF_CT_PROTO_UDPLITE
-const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite =
-{
-	.l4proto		= IPPROTO_UDPLITE,
-	.allow_clash		= true,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
-	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
-	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
-	.nla_policy		= nf_ct_port_nla_policy,
-#endif
-#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-	.ctnl_timeout		= {
-		.nlattr_to_obj	= udp_timeout_nlattr_to_obj,
-		.obj_to_nlattr	= udp_timeout_obj_to_nlattr,
-		.nlattr_max	= CTA_TIMEOUT_UDP_MAX,
-		.obj_size	= sizeof(unsigned int) * CTA_TIMEOUT_UDP_MAX,
-		.nla_policy	= udp_timeout_nla_policy,
-	},
-#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
-};
-#endif
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 207b240b14e5..be2953c7d702 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -61,7 +61,6 @@ print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 			   ntohs(tuple->src.u.tcp.port),
 			   ntohs(tuple->dst.u.tcp.port));
 		break;
-	case IPPROTO_UDPLITE:
 	case IPPROTO_UDP:
 		seq_printf(s, "sport=%hu dport=%hu ",
 			   ntohs(tuple->src.u.udp.port),
@@ -277,7 +276,6 @@ static const char* l4proto_name(u16 proto)
 	case IPPROTO_UDP: return "udp";
 	case IPPROTO_GRE: return "gre";
 	case IPPROTO_SCTP: return "sctp";
-	case IPPROTO_UDPLITE: return "udplite";
 	case IPPROTO_ICMPV6: return "icmpv6";
 	}
 
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 3b5434e4ec9c..83b2b5e9759a 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -68,7 +68,6 @@ static void nf_nat_ipv4_decode_session(struct sk_buff *skb,
 		fl4->daddr = t->dst.u3.ip;
 		if (t->dst.protonum == IPPROTO_TCP ||
 		    t->dst.protonum == IPPROTO_UDP ||
-		    t->dst.protonum == IPPROTO_UDPLITE ||
 		    t->dst.protonum == IPPROTO_SCTP)
 			fl4->fl4_dport = t->dst.u.all;
 	}
@@ -79,7 +78,6 @@ static void nf_nat_ipv4_decode_session(struct sk_buff *skb,
 		fl4->saddr = t->src.u3.ip;
 		if (t->dst.protonum == IPPROTO_TCP ||
 		    t->dst.protonum == IPPROTO_UDP ||
-		    t->dst.protonum == IPPROTO_UDPLITE ||
 		    t->dst.protonum == IPPROTO_SCTP)
 			fl4->fl4_sport = t->src.u.all;
 	}
@@ -99,7 +97,6 @@ static void nf_nat_ipv6_decode_session(struct sk_buff *skb,
 		fl6->daddr = t->dst.u3.in6;
 		if (t->dst.protonum == IPPROTO_TCP ||
 		    t->dst.protonum == IPPROTO_UDP ||
-		    t->dst.protonum == IPPROTO_UDPLITE ||
 		    t->dst.protonum == IPPROTO_SCTP)
 			fl6->fl6_dport = t->dst.u.all;
 	}
@@ -110,7 +107,6 @@ static void nf_nat_ipv6_decode_session(struct sk_buff *skb,
 		fl6->saddr = t->src.u3.in6;
 		if (t->dst.protonum == IPPROTO_TCP ||
 		    t->dst.protonum == IPPROTO_UDP ||
-		    t->dst.protonum == IPPROTO_UDPLITE ||
 		    t->dst.protonum == IPPROTO_SCTP)
 			fl6->fl6_sport = t->src.u.all;
 	}
@@ -415,7 +411,6 @@ static bool l4proto_in_range(const struct nf_conntrack_tuple *tuple,
 	case IPPROTO_GRE: /* all fall though */
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
-	case IPPROTO_UDPLITE:
 	case IPPROTO_SCTP:
 		if (maniptype == NF_NAT_MANIP_SRC)
 			port = tuple->src.u.all;
@@ -612,7 +607,6 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 		goto find_free_id;
 #endif
 	case IPPROTO_UDP:
-	case IPPROTO_UDPLITE:
 	case IPPROTO_TCP:
 	case IPPROTO_SCTP:
 		if (maniptype == NF_NAT_MANIP_SRC)
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 97c0f841fc96..07f51fe75fbe 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -79,23 +79,6 @@ static bool udp_manip_pkt(struct sk_buff *skb,
 	return true;
 }
 
-static bool udplite_manip_pkt(struct sk_buff *skb,
-			      unsigned int iphdroff, unsigned int hdroff,
-			      const struct nf_conntrack_tuple *tuple,
-			      enum nf_nat_manip_type maniptype)
-{
-#ifdef CONFIG_NF_CT_PROTO_UDPLITE
-	struct udphdr *hdr;
-
-	if (skb_ensure_writable(skb, hdroff + sizeof(*hdr)))
-		return false;
-
-	hdr = (struct udphdr *)(skb->data + hdroff);
-	__udp_manip_pkt(skb, iphdroff, hdr, tuple, maniptype, true);
-#endif
-	return true;
-}
-
 static bool
 sctp_manip_pkt(struct sk_buff *skb,
 	       unsigned int iphdroff, unsigned int hdroff,
@@ -287,9 +270,6 @@ static bool l4proto_manip_pkt(struct sk_buff *skb,
 	case IPPROTO_UDP:
 		return udp_manip_pkt(skb, iphdroff, hdroff,
 				     tuple, maniptype);
-	case IPPROTO_UDPLITE:
-		return udplite_manip_pkt(skb, iphdroff, hdroff,
-					 tuple, maniptype);
 	case IPPROTO_SCTP:
 		return sctp_manip_pkt(skb, iphdroff, hdroff,
 				      tuple, maniptype);
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index fd8652aa7e88..dca6826af7de 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -457,7 +457,6 @@ static int cttimeout_default_get(struct sk_buff *skb,
 		timeouts = nf_tcp_pernet(info->net)->timeouts;
 		break;
 	case IPPROTO_UDP:
-	case IPPROTO_UDPLITE:
 		timeouts = nf_udp_pernet(info->net)->timeouts;
 		break;
 	case IPPROTO_ICMPV6:
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index a8fcb4b6ea1a..b8c8cfcf05b7 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1252,7 +1252,6 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 	switch (priv->l4proto) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
-	case IPPROTO_UDPLITE:
 	case IPPROTO_DCCP:
 	case IPPROTO_SCTP:
 		break;
-- 
2.53.0

