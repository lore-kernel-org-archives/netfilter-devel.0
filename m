Received: from smtp-out.freemail.hu (fmfe34.freemail.hu [46.107.16.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6857E1F4282;
	Tue,  7 Jan 2025 18:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736275723; cv=none; b=aqd3l9v0Uv6Q3CaQMviyt2qKiehzNNnEklNp2xIgRJUjtc/RJx+OXMKBehkagU0E6nnPQU59oI+nWjFLD/fR3L4E5OaNWSGmWO8bQSPCu0WSwMkWvgqa3VxYoEMyOED/VwqPArzt1Mw60mDDfIuPjUTgaRUwTptd6SajB3O5NOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736275723; c=relaxed/simple;
	bh=9C0HpMaoBV7meefl43yf2yh0r2jmPFEtgSGgZPdTlUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o1wX995C0WusDWTdTnQ3sXLPrTDj1r11o2puluTdTHGw/F05fNF7gF5IodIOo8mX41hNQWLmh2rbrPINEcCFF5O2TR7EsrRhcnHqhBWQqE0xNTDUMTrMeBvfibYCM8keTyLut+qJYogivFyqzQEi1XsAmSatPgIhbxNqctjjHxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=CZBaQJVA reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="CZBaQJVA"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YSKnb67l0z100L;
	Tue, 07 Jan 2025 19:48:35 +0100 (CET)
From: egyszeregy@freemail.hu
To: fw@strlen.de,
	pablo@netfilter.org,
	lorenzo@kernel.org,
	daniel@iogearbox.net,
	leitao@debian.org,
	amiculas@cisco.com,
	kadlec@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: =?UTF-8?q?Benjamin=20Sz=C5=91ke?= <egyszeregy@freemail.hu>
Subject: [PATCH 5/6] netfilter: x_tables: Merge xt_TCPMSS.c to xt_tcpmss.c
Date: Tue,  7 Jan 2025 19:47:23 +0100
Message-ID: <20250107184724.56223-6-egyszeregy@freemail.hu>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250107184724.56223-1-egyszeregy@freemail.hu>
References: <20250107184724.56223-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736275716;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=24371; bh=bEZb0pCTD8jimTwyjH8TZgCfJ7iEMhRBCaNw8hy3ZtA=;
	b=CZBaQJVASRlBPxXRoJW0ZvQriauQ/ZbVRU/Kmpu6PHTQmhcFl69KF4bq9ZCwgP5m
	4ru+21iIBdJVMWmn4OTxKHCsXiYYQIQIJDKa0+bkKR//Hq315TT/InlooSnwuK/Qaab
	+kv0ogk/p03ghK7rPVrKhWdmO15D2uIXkrL3Gss3e/hz3XU12EoArp8dOTrdQfWYBtc
	viEVADfH+VkZtYaRREqN9UoHiS26rjeE7RQYKYi5Y9hGso7VIdE/7uwEpgS0OpgGbYH
	WI69BwaV07HZdft7gWj0zjqg5QX4BeTGlKHIQ/rje+Rrkr/pVXe/UVUbCkeZOhKFS+B
	YMh1k1uNrQ==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Merge xt_TCPMSS.c to xt_tcpmss.c file and remove xt_TCPMSS.c.

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 net/netfilter/Kconfig     |  22 +++
 net/netfilter/Makefile    |   3 +-
 net/netfilter/xt_TCPMSS.c | 347 -------------------------------------
 net/netfilter/xt_tcpmss.c | 352 ++++++++++++++++++++++++++++++++++++--
 4 files changed, 362 insertions(+), 362 deletions(-)
 delete mode 100644 net/netfilter/xt_TCPMSS.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 1aff3c7c4363..34fbdfdbdde9 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -835,6 +835,18 @@ config NETFILTER_XT_RATEEST
 	  estimated by the RATEEST target.
 	  The target allows you to measure rates similar to TC estimators.
 
+config NETFILTER_XT_TCPMSS
+	tristate '"TCPMSS" target and match support'
+	depends on IPV6 || IPV6=n
+	default m if NETFILTER_ADVANCED=n
+	help
+	  This option adds the "TCPMSS" target and "tcpmss" match.
+
+	  Netfilter tcpmss matching allows you to examine the MSS value of
+	  TCP SYN packets, which control the maximum packet size for that connection.
+	  The target allows you to alter the MSS value of TCP SYN packets,
+	  to control the maximum size for that connection.
+
 # alphabetically ordered list of targets
 
 comment "Xtables targets"
@@ -1170,6 +1182,7 @@ config NETFILTER_XT_TARGET_TCPMSS
 	tristate '"TCPMSS" target support'
 	depends on IPV6 || IPV6=n
 	default m if NETFILTER_ADVANCED=n
+	select NETFILTER_XT_TCPMSS
 	help
 	  This option adds a `TCPMSS' target, which allows you to alter the
 	  MSS value of TCP SYN packets, to control the maximum size for that
@@ -1191,6 +1204,10 @@ config NETFILTER_XT_TARGET_TCPMSS
 	  iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN \
 	                 -j TCPMSS --clamp-mss-to-pmtu
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_TCPMSS (combined tcpmss/TCPMSS module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_TCPOPTSTRIP
@@ -1687,11 +1704,16 @@ config NETFILTER_XT_MATCH_STRING
 config NETFILTER_XT_MATCH_TCPMSS
 	tristate '"tcpmss" match support'
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_TCPMSS
 	help
 	  This option adds a `tcpmss' match, which allows you to examine the
 	  MSS value of TCP SYN packets, which control the maximum packet size
 	  for that connection.
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_TCPMSS (combined tcpmss/TCPMSS module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_MATCH_TIME
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 923112b0dc1e..df6bfa46e6ab 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -163,6 +163,7 @@ obj-$(CONFIG_NETFILTER_XT_NAT) += xt_nat.o
 obj-$(CONFIG_NETFILTER_XT_DSCP) += xt_dscp.o
 obj-$(CONFIG_NETFILTER_XT_HL) += xt_hl.o
 obj-$(CONFIG_NETFILTER_XT_RATEEST) += xt_rateest.o
+obj-$(CONFIG_NETFILTER_XT_TCPMSS) += xt_tcpmss.o
 
 # targets
 obj-$(CONFIG_NETFILTER_XT_TARGET_AUDIT) += xt_AUDIT.o
@@ -180,7 +181,6 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_REDIRECT) += xt_REDIRECT.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_MASQUERADE) += xt_MASQUERADE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) += xt_TPROXY.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TEE) += xt_TEE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
@@ -225,7 +225,6 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_SOCKET) += xt_socket.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) += xt_time.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_U32) += xt_u32.o
 
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
deleted file mode 100644
index 9944ca1eb950..000000000000
--- a/net/netfilter/xt_TCPMSS.c
+++ /dev/null
@@ -1,347 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * This is a module which is used for setting the MSS option in TCP packets.
- *
- * Copyright (C) 2000 Marc Boucher <marc@mbsi.ca>
- * Copyright (C) 2007 Patrick McHardy <kaber@trash.net>
- */
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/gfp.h>
-#include <linux/ipv6.h>
-#include <linux/tcp.h>
-#include <net/dst.h>
-#include <net/flow.h>
-#include <net/ipv6.h>
-#include <net/route.h>
-#include <net/tcp.h>
-
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_tcpudp.h>
-#include <linux/netfilter/xt_tcpmss.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("Xtables: TCP Maximum Segment Size (MSS) adjustment");
-MODULE_ALIAS("ipt_TCPMSS");
-MODULE_ALIAS("ip6t_TCPMSS");
-
-static inline unsigned int
-optlen(const u8 *opt, unsigned int offset)
-{
-	/* Beware zero-length options: make finite progress */
-	if (opt[offset] <= TCPOPT_NOP || opt[offset + 1] == 0)
-		return 1;
-	else
-		return opt[offset + 1];
-}
-
-static u_int32_t tcpmss_reverse_mtu(struct net *net,
-				    const struct sk_buff *skb,
-				    unsigned int family)
-{
-	struct flowi fl;
-	struct rtable *rt = NULL;
-	u32 mtu     = ~0U;
-
-	if (family == PF_INET) {
-		struct flowi4 *fl4 = &fl.u.ip4;
-
-		memset(fl4, 0, sizeof(*fl4));
-		fl4->daddr = ip_hdr(skb)->saddr;
-	} else {
-		struct flowi6 *fl6 = &fl.u.ip6;
-
-		memset(fl6, 0, sizeof(*fl6));
-		fl6->daddr = ipv6_hdr(skb)->saddr;
-	}
-
-	nf_route(net, (struct dst_entry **)&rt, &fl, false, family);
-	if (rt) {
-		mtu = dst_mtu(&rt->dst);
-		dst_release(&rt->dst);
-	}
-	return mtu;
-}
-
-static int
-tcpmss_mangle_packet(struct sk_buff *skb,
-		     const struct xt_action_param *par,
-		     unsigned int family,
-		     unsigned int tcphoff,
-		     unsigned int minlen)
-{
-	const struct xt_tcpmss_info *info = par->targinfo;
-	struct tcphdr *tcph;
-	int len, tcp_hdrlen;
-	unsigned int i;
-	__be16 oldval;
-	u16 newmss;
-	u8 *opt;
-
-	/* This is a fragment, no TCP header is available */
-	if (par->fragoff != 0)
-		return 0;
-
-	if (skb_ensure_writable(skb, skb->len))
-		return -1;
-
-	len = skb->len - tcphoff;
-	if (len < (int)sizeof(struct tcphdr))
-		return -1;
-
-	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
-	tcp_hdrlen = tcph->doff * 4;
-
-	if (len < tcp_hdrlen || tcp_hdrlen < sizeof(struct tcphdr))
-		return -1;
-
-	if (info->mss == XT_TCPMSS_CLAMP_PMTU) {
-		struct net *net = xt_net(par);
-		unsigned int in_mtu = tcpmss_reverse_mtu(net, skb, family);
-		unsigned int min_mtu = min(dst_mtu(skb_dst(skb)), in_mtu);
-
-		if (min_mtu <= minlen) {
-			net_err_ratelimited("unknown or invalid path-MTU (%u)\n",
-					    min_mtu);
-			return -1;
-		}
-		newmss = min_mtu - minlen;
-	} else {
-		newmss = info->mss;
-	}
-
-	opt = (u_int8_t *)tcph;
-	for (i = sizeof(struct tcphdr); i <= tcp_hdrlen - TCPOLEN_MSS; i += optlen(opt, i)) {
-		if (opt[i] == TCPOPT_MSS && opt[i + 1] == TCPOLEN_MSS) {
-			u16 oldmss;
-
-			oldmss = (opt[i + 2] << 8) | opt[i + 3];
-
-			/* Never increase MSS, even when setting it, as
-			 * doing so results in problems for hosts that rely
-			 * on MSS being set correctly.
-			 */
-			if (oldmss <= newmss)
-				return 0;
-
-			opt[i + 2] = (newmss & 0xff00) >> 8;
-			opt[i + 3] = newmss & 0x00ff;
-
-			inet_proto_csum_replace2(&tcph->check, skb,
-						 htons(oldmss), htons(newmss),
-						 false);
-			return 0;
-		}
-	}
-
-	/* There is data after the header so the option can't be added
-	 * without moving it, and doing so may make the SYN packet
-	 * itself too large. Accept the packet unmodified instead.
-	 */
-	if (len > tcp_hdrlen)
-		return 0;
-
-	/* tcph->doff has 4 bits, do not wrap it to 0 */
-	if (tcp_hdrlen >= 15 * 4)
-		return 0;
-
-	/*
-	 * MSS Option not found ?! add it..
-	 */
-	if (skb_tailroom(skb) < TCPOLEN_MSS) {
-		if (pskb_expand_head(skb, 0,
-				     TCPOLEN_MSS - skb_tailroom(skb),
-				     GFP_ATOMIC))
-			return -1;
-		tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
-	}
-
-	skb_put(skb, TCPOLEN_MSS);
-
-	/*
-	 * IPv4: RFC 1122 states "If an MSS option is not received at
-	 * connection setup, TCP MUST assume a default send MSS of 536".
-	 * IPv6: RFC 2460 states IPv6 has a minimum MTU of 1280 and a minimum
-	 * length IPv6 header of 60, ergo the default MSS value is 1220
-	 * Since no MSS was provided, we must use the default values
-	 */
-	if (xt_family(par) == NFPROTO_IPV4)
-		newmss = min(newmss, (u16)536);
-	else
-		newmss = min(newmss, (u16)1220);
-
-	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
-	memmove(opt + TCPOLEN_MSS, opt, len - sizeof(struct tcphdr));
-
-	inet_proto_csum_replace2(&tcph->check, skb,
-				 htons(len), htons(len + TCPOLEN_MSS), true);
-	opt[0] = TCPOPT_MSS;
-	opt[1] = TCPOLEN_MSS;
-	opt[2] = (newmss & 0xff00) >> 8;
-	opt[3] = newmss & 0x00ff;
-
-	inet_proto_csum_replace4(&tcph->check, skb, 0, *((__be32 *)opt), false);
-
-	oldval = ((__be16 *)tcph)[6];
-	tcph->doff += TCPOLEN_MSS / 4;
-	inet_proto_csum_replace2(&tcph->check, skb,
-				 oldval, ((__be16 *)tcph)[6], false);
-	return TCPOLEN_MSS;
-}
-
-static unsigned int
-tcpmss_tg4(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	struct iphdr *iph = ip_hdr(skb);
-	__be16 newlen;
-	int ret;
-
-	ret = tcpmss_mangle_packet(skb, par,
-				   PF_INET,
-				   iph->ihl * 4,
-				   sizeof(*iph) + sizeof(struct tcphdr));
-	if (ret < 0)
-		return NF_DROP;
-	if (ret > 0) {
-		iph = ip_hdr(skb);
-		newlen = htons(ntohs(iph->tot_len) + ret);
-		csum_replace2(&iph->check, iph->tot_len, newlen);
-		iph->tot_len = newlen;
-	}
-	return XT_CONTINUE;
-}
-
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-static unsigned int
-tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-	u8 nexthdr;
-	__be16 frag_off, oldlen, newlen;
-	int tcphoff;
-	int ret;
-
-	nexthdr = ipv6h->nexthdr;
-	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr, &frag_off);
-	if (tcphoff < 0)
-		return NF_DROP;
-	ret = tcpmss_mangle_packet(skb, par,
-				   PF_INET6,
-				   tcphoff,
-				   sizeof(*ipv6h) + sizeof(struct tcphdr));
-	if (ret < 0)
-		return NF_DROP;
-	if (ret > 0) {
-		ipv6h = ipv6_hdr(skb);
-		oldlen = ipv6h->payload_len;
-		newlen = htons(ntohs(oldlen) + ret);
-		if (skb->ip_summed == CHECKSUM_COMPLETE)
-			skb->csum = csum_add(csum_sub(skb->csum, (__force __wsum)oldlen),
-					     (__force __wsum)newlen);
-		ipv6h->payload_len = newlen;
-	}
-	return XT_CONTINUE;
-}
-#endif
-
-/* Must specify -p tcp --syn */
-static inline bool find_syn_match(const struct xt_entry_match *m)
-{
-	const struct xt_tcp *tcpinfo = (const struct xt_tcp *)m->data;
-
-	if (strcmp(m->u.kernel.match->name, "tcp") == 0 &&
-	    tcpinfo->flg_cmp & TCPHDR_SYN &&
-	    !(tcpinfo->invflags & XT_TCP_INV_FLAGS))
-		return true;
-
-	return false;
-}
-
-static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
-{
-	const struct xt_tcpmss_info *info = par->targinfo;
-	const struct ipt_entry *e = par->entryinfo;
-	const struct xt_entry_match *ematch;
-
-	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
-	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
-			   (1 << NF_INET_LOCAL_OUT) |
-			   (1 << NF_INET_POST_ROUTING))) != 0) {
-		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
-		return -EINVAL;
-	}
-	if (par->nft_compat)
-		return 0;
-
-	xt_ematch_foreach(ematch, e)
-		if (find_syn_match(ematch))
-			return 0;
-	pr_info_ratelimited("Only works on TCP SYN packets\n");
-	return -EINVAL;
-}
-
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
-{
-	const struct xt_tcpmss_info *info = par->targinfo;
-	const struct ip6t_entry *e = par->entryinfo;
-	const struct xt_entry_match *ematch;
-
-	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
-	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
-			   (1 << NF_INET_LOCAL_OUT) |
-			   (1 << NF_INET_POST_ROUTING))) != 0) {
-		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
-		return -EINVAL;
-	}
-	if (par->nft_compat)
-		return 0;
-
-	xt_ematch_foreach(ematch, e)
-		if (find_syn_match(ematch))
-			return 0;
-	pr_info_ratelimited("Only works on TCP SYN packets\n");
-	return -EINVAL;
-}
-#endif
-
-static struct xt_target tcpmss_tg_reg[] __read_mostly = {
-	{
-		.family		= NFPROTO_IPV4,
-		.name		= "TCPMSS",
-		.checkentry	= tcpmss_tg4_check,
-		.target		= tcpmss_tg4,
-		.targetsize	= sizeof(struct xt_tcpmss_info),
-		.proto		= IPPROTO_TCP,
-		.me		= THIS_MODULE,
-	},
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-	{
-		.family		= NFPROTO_IPV6,
-		.name		= "TCPMSS",
-		.checkentry	= tcpmss_tg6_check,
-		.target		= tcpmss_tg6,
-		.targetsize	= sizeof(struct xt_tcpmss_info),
-		.proto		= IPPROTO_TCP,
-		.me		= THIS_MODULE,
-	},
-#endif
-};
-
-static int __init tcpmss_tg_init(void)
-{
-	return xt_register_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
-}
-
-static void __exit tcpmss_tg_exit(void)
-{
-	xt_unregister_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
-}
-
-module_init(tcpmss_tg_init);
-module_exit(tcpmss_tg_exit);
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 37704ab01799..9cf627e96226 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -1,25 +1,37 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Kernel module to match TCP MSS values. */
-
-/* Copyright (C) 2000 Marc Boucher <marc@mbsi.ca>
+/* Kernel module for matching/modifying TCP MSS values/packets.
+ *
+ * Copyright (C) 2000 Marc Boucher <marc@mbsi.ca>
  * Portions (C) 2005 by Harald Welte <laforge@netfilter.org>
+ * Copyright (C) 2007 Patrick McHardy <kaber@trash.net>
  */
-
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/gfp.h>
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <net/dst.h>
+#include <net/flow.h>
+#include <net/ipv6.h>
+#include <net/route.h>
 #include <net/tcp.h>
 
-#include <linux/netfilter/xt_tcpmss.h>
-#include <linux/netfilter/x_tables.h>
-
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_tcpudp.h>
+#include <linux/netfilter/xt_tcpmss.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("Xtables: TCP MSS match");
+MODULE_DESCRIPTION("Xtables: TCP Maximum Segment Size (MSS) adjustment and match");
 MODULE_ALIAS("ipt_tcpmss");
 MODULE_ALIAS("ip6t_tcpmss");
+MODULE_ALIAS("ipt_TCPMSS");
+MODULE_ALIAS("ip6t_TCPMSS");
+MODULE_ALIAS("xt_TCPMSS");
 
 static bool
 tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
@@ -93,15 +105,329 @@ static struct xt_match tcpmss_mt_reg[] __read_mostly = {
 	},
 };
 
-static int __init tcpmss_mt_init(void)
+static inline unsigned int
+optlen(const u8 *opt, unsigned int offset)
+{
+	/* Beware zero-length options: make finite progress */
+	if (opt[offset] <= TCPOPT_NOP || opt[offset + 1] == 0)
+		return 1;
+	else
+		return opt[offset + 1];
+}
+
+static u_int32_t tcpmss_reverse_mtu(struct net *net,
+				    const struct sk_buff *skb,
+				    unsigned int family)
+{
+	struct flowi fl;
+	struct rtable *rt = NULL;
+	u32 mtu     = ~0U;
+
+	if (family == PF_INET) {
+		struct flowi4 *fl4 = &fl.u.ip4;
+
+		memset(fl4, 0, sizeof(*fl4));
+		fl4->daddr = ip_hdr(skb)->saddr;
+	} else {
+		struct flowi6 *fl6 = &fl.u.ip6;
+
+		memset(fl6, 0, sizeof(*fl6));
+		fl6->daddr = ipv6_hdr(skb)->saddr;
+	}
+
+	nf_route(net, (struct dst_entry **)&rt, &fl, false, family);
+	if (rt) {
+		mtu = dst_mtu(&rt->dst);
+		dst_release(&rt->dst);
+	}
+	return mtu;
+}
+
+static int
+tcpmss_mangle_packet(struct sk_buff *skb,
+		     const struct xt_action_param *par,
+		     unsigned int family,
+		     unsigned int tcphoff,
+		     unsigned int minlen)
+{
+	const struct xt_tcpmss_info *info = par->targinfo;
+	struct tcphdr *tcph;
+	int len, tcp_hdrlen;
+	unsigned int i;
+	__be16 oldval;
+	u16 newmss;
+	u8 *opt;
+
+	/* This is a fragment, no TCP header is available */
+	if (par->fragoff != 0)
+		return 0;
+
+	if (skb_ensure_writable(skb, skb->len))
+		return -1;
+
+	len = skb->len - tcphoff;
+	if (len < (int)sizeof(struct tcphdr))
+		return -1;
+
+	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
+	tcp_hdrlen = tcph->doff * 4;
+
+	if (len < tcp_hdrlen || tcp_hdrlen < sizeof(struct tcphdr))
+		return -1;
+
+	if (info->mss == XT_TCPMSS_CLAMP_PMTU) {
+		struct net *net = xt_net(par);
+		unsigned int in_mtu = tcpmss_reverse_mtu(net, skb, family);
+		unsigned int min_mtu = min(dst_mtu(skb_dst(skb)), in_mtu);
+
+		if (min_mtu <= minlen) {
+			net_err_ratelimited("unknown or invalid path-MTU (%u)\n",
+					    min_mtu);
+			return -1;
+		}
+		newmss = min_mtu - minlen;
+	} else {
+		newmss = info->mss;
+	}
+
+	opt = (u_int8_t *)tcph;
+	for (i = sizeof(struct tcphdr); i <= tcp_hdrlen - TCPOLEN_MSS; i += optlen(opt, i)) {
+		if (opt[i] == TCPOPT_MSS && opt[i + 1] == TCPOLEN_MSS) {
+			u16 oldmss;
+
+			oldmss = (opt[i + 2] << 8) | opt[i + 3];
+
+			/* Never increase MSS, even when setting it, as
+			 * doing so results in problems for hosts that rely
+			 * on MSS being set correctly.
+			 */
+			if (oldmss <= newmss)
+				return 0;
+
+			opt[i + 2] = (newmss & 0xff00) >> 8;
+			opt[i + 3] = newmss & 0x00ff;
+
+			inet_proto_csum_replace2(&tcph->check, skb,
+						 htons(oldmss), htons(newmss),
+						 false);
+			return 0;
+		}
+	}
+
+	/* There is data after the header so the option can't be added
+	 * without moving it, and doing so may make the SYN packet
+	 * itself too large. Accept the packet unmodified instead.
+	 */
+	if (len > tcp_hdrlen)
+		return 0;
+
+	/* tcph->doff has 4 bits, do not wrap it to 0 */
+	if (tcp_hdrlen >= 15 * 4)
+		return 0;
+
+	/*
+	 * MSS Option not found ?! add it..
+	 */
+	if (skb_tailroom(skb) < TCPOLEN_MSS) {
+		if (pskb_expand_head(skb, 0,
+				     TCPOLEN_MSS - skb_tailroom(skb),
+				     GFP_ATOMIC))
+			return -1;
+		tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
+	}
+
+	skb_put(skb, TCPOLEN_MSS);
+
+	/*
+	 * IPv4: RFC 1122 states "If an MSS option is not received at
+	 * connection setup, TCP MUST assume a default send MSS of 536".
+	 * IPv6: RFC 2460 states IPv6 has a minimum MTU of 1280 and a minimum
+	 * length IPv6 header of 60, ergo the default MSS value is 1220
+	 * Since no MSS was provided, we must use the default values
+	 */
+	if (xt_family(par) == NFPROTO_IPV4)
+		newmss = min(newmss, (u16)536);
+	else
+		newmss = min(newmss, (u16)1220);
+
+	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
+	memmove(opt + TCPOLEN_MSS, opt, len - sizeof(struct tcphdr));
+
+	inet_proto_csum_replace2(&tcph->check, skb,
+				 htons(len), htons(len + TCPOLEN_MSS), true);
+	opt[0] = TCPOPT_MSS;
+	opt[1] = TCPOLEN_MSS;
+	opt[2] = (newmss & 0xff00) >> 8;
+	opt[3] = newmss & 0x00ff;
+
+	inet_proto_csum_replace4(&tcph->check, skb, 0, *((__be32 *)opt), false);
+
+	oldval = ((__be16 *)tcph)[6];
+	tcph->doff += TCPOLEN_MSS / 4;
+	inet_proto_csum_replace2(&tcph->check, skb,
+				 oldval, ((__be16 *)tcph)[6], false);
+	return TCPOLEN_MSS;
+}
+
+static unsigned int
+tcpmss_tg4(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	struct iphdr *iph = ip_hdr(skb);
+	__be16 newlen;
+	int ret;
+
+	ret = tcpmss_mangle_packet(skb, par,
+				   PF_INET,
+				   iph->ihl * 4,
+				   sizeof(*iph) + sizeof(struct tcphdr));
+	if (ret < 0)
+		return NF_DROP;
+	if (ret > 0) {
+		iph = ip_hdr(skb);
+		newlen = htons(ntohs(iph->tot_len) + ret);
+		csum_replace2(&iph->check, iph->tot_len, newlen);
+		iph->tot_len = newlen;
+	}
+	return XT_CONTINUE;
+}
+
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+static unsigned int
+tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
+	u8 nexthdr;
+	__be16 frag_off, oldlen, newlen;
+	int tcphoff;
+	int ret;
+
+	nexthdr = ipv6h->nexthdr;
+	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr, &frag_off);
+	if (tcphoff < 0)
+		return NF_DROP;
+	ret = tcpmss_mangle_packet(skb, par,
+				   PF_INET6,
+				   tcphoff,
+				   sizeof(*ipv6h) + sizeof(struct tcphdr));
+	if (ret < 0)
+		return NF_DROP;
+	if (ret > 0) {
+		ipv6h = ipv6_hdr(skb);
+		oldlen = ipv6h->payload_len;
+		newlen = htons(ntohs(oldlen) + ret);
+		if (skb->ip_summed == CHECKSUM_COMPLETE)
+			skb->csum = csum_add(csum_sub(skb->csum, (__force __wsum)oldlen),
+					     (__force __wsum)newlen);
+		ipv6h->payload_len = newlen;
+	}
+	return XT_CONTINUE;
+}
+#endif
+
+/* Must specify -p tcp --syn */
+static inline bool find_syn_match(const struct xt_entry_match *m)
+{
+	const struct xt_tcp *tcpinfo = (const struct xt_tcp *)m->data;
+
+	if (strcmp(m->u.kernel.match->name, "tcp") == 0 &&
+	    tcpinfo->flg_cmp & TCPHDR_SYN &&
+	    !(tcpinfo->invflags & XT_TCP_INV_FLAGS))
+		return true;
+
+	return false;
+}
+
+static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
+{
+	const struct xt_tcpmss_info *info = par->targinfo;
+	const struct ipt_entry *e = par->entryinfo;
+	const struct xt_entry_match *ematch;
+
+	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
+	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
+			   (1 << NF_INET_LOCAL_OUT) |
+			   (1 << NF_INET_POST_ROUTING))) != 0) {
+		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
+		return -EINVAL;
+	}
+	if (par->nft_compat)
+		return 0;
+
+	xt_ematch_foreach(ematch, e)
+		if (find_syn_match(ematch))
+			return 0;
+	pr_info_ratelimited("Only works on TCP SYN packets\n");
+	return -EINVAL;
+}
+
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
+{
+	const struct xt_tcpmss_info *info = par->targinfo;
+	const struct ip6t_entry *e = par->entryinfo;
+	const struct xt_entry_match *ematch;
+
+	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
+	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
+			   (1 << NF_INET_LOCAL_OUT) |
+			   (1 << NF_INET_POST_ROUTING))) != 0) {
+		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
+		return -EINVAL;
+	}
+	if (par->nft_compat)
+		return 0;
+
+	xt_ematch_foreach(ematch, e)
+		if (find_syn_match(ematch))
+			return 0;
+	pr_info_ratelimited("Only works on TCP SYN packets\n");
+	return -EINVAL;
+}
+#endif
+
+static struct xt_target tcpmss_tg_reg[] __read_mostly = {
+	{
+		.family		= NFPROTO_IPV4,
+		.name		= "TCPMSS",
+		.checkentry	= tcpmss_tg4_check,
+		.target		= tcpmss_tg4,
+		.targetsize	= sizeof(struct xt_tcpmss_info),
+		.proto		= IPPROTO_TCP,
+		.me		= THIS_MODULE,
+	},
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+	{
+		.family		= NFPROTO_IPV6,
+		.name		= "TCPMSS",
+		.checkentry	= tcpmss_tg6_check,
+		.target		= tcpmss_tg6,
+		.targetsize	= sizeof(struct xt_tcpmss_info),
+		.proto		= IPPROTO_TCP,
+		.me		= THIS_MODULE,
+	},
+#endif
+};
+
+static int __init tcpmss_init(void)
 {
-	return xt_register_matches(tcpmss_mt_reg, ARRAY_SIZE(tcpmss_mt_reg));
+	int ret;
+
+	ret = xt_register_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
+	if (ret < 0)
+		return ret;
+	ret = xt_register_matches(tcpmss_mt_reg, ARRAY_SIZE(tcpmss_mt_reg));
+	if (ret < 0) {
+		xt_unregister_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
+		return ret;
+	}
+	return 0;
 }
 
-static void __exit tcpmss_mt_exit(void)
+static void __exit tcpmss_exit(void)
 {
 	xt_unregister_matches(tcpmss_mt_reg, ARRAY_SIZE(tcpmss_mt_reg));
+	xt_unregister_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
 }
 
-module_init(tcpmss_mt_init);
-module_exit(tcpmss_mt_exit);
+module_init(tcpmss_init);
+module_exit(tcpmss_exit);
-- 
2.43.5

