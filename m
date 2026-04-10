Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8530939DBF0;
	Fri, 10 Apr 2026 11:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775820274; cv=none; b=oK1QBxFNu1PvS4ETkL5sFZCkqMPRyLtUtXxYLGa+zKrvrGAM/G+8ItBTGK57JrWgwzepOfYw8GNQCnN8DFcEzK2R0dVyp1kYCfLReq4ljD+I2rS8nvEKneDfMFFWY8wq4Gf8RY2J285hj9ITVGKrgg9d2KdxJy6c5+VQY/1RwCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775820274; c=relaxed/simple;
	bh=S7SiWh6HF9gd4Qkg4gIJqOj/RPcbgxSwZd8h0Qp4aYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0m/EMvbASJb/K/4wmX5PcRE9VJQKRZI8psTjK6s42OUlNNvvNQ3vuUqsOZGhFULyTZ1Jf9Hfe3cLwOPkMdwdf0hiUbuy0WH3B9Mltaq1jTUAIW1Q73rvO7HsmZwoT7F6Lq/TZq7i5BJ4oA6CKK1aR/ksBPotEwcmXK2EYJYaRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DEAEC6065F; Fri, 10 Apr 2026 13:24:30 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 08/11] netfilter: conntrack: remove UDP-Lite conntrack support
Date: Fri, 10 Apr 2026 13:23:49 +0200
Message-ID: <20260410112352.23599-9-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260410112352.23599-1-fw@strlen.de>
References: <20260410112352.23599-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

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
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/ipv4/nf_conntrack_ipv4.h    |   3 -
 include/net/netfilter/nf_conntrack_l4proto.h  |   7 --
 net/netfilter/Kconfig                         |  11 --
 net/netfilter/nf_conntrack_core.c             |   8 --
 net/netfilter/nf_conntrack_proto.c            |   3 -
 net/netfilter/nf_conntrack_proto_udp.c        | 108 ------------------
 net/netfilter/nf_conntrack_standalone.c       |   2 -
 net/netfilter/nf_nat_core.c                   |   6 -
 net/netfilter/nf_nat_proto.c                  |  20 ----
 net/netfilter/nfnetlink_cttimeout.c           |   1 -
 net/netfilter/nft_ct.c                        |   1 -
 11 files changed, 170 deletions(-)

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
index cd5020835a6d..fde2427ceb8f 100644
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
@@ -139,8 +134,6 @@ void nf_conntrack_icmpv6_init_net(struct net *net);
 /* Existing built-in generic protocol */
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
 
-#define MAX_NF_CT_PROTO IPPROTO_UDPLITE
-
 const struct nf_conntrack_l4proto *nf_ct_l4proto_find(u8 l4proto);
 
 /* Generic netlink helpers */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f3ea0cb26f36..682c675125fc 100644
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
index 425525b90ac9..60ee8d932fcb 100644
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
2.52.0

