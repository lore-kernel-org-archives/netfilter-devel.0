Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31965C433E2
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Mar 2021 17:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0017261A1E
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Mar 2021 17:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhCYRZt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 13:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbhCYRZd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 13:25:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E5FC06175F
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Mar 2021 10:25:31 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lPTje-0004qL-63; Thu, 25 Mar 2021 18:25:30 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     phil@nwl.cc, Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/8] netfilter: nf_log_ipv4: rename to nf_log_syslog
Date:   Thu, 25 Mar 2021 18:25:05 +0100
Message-Id: <20210325172512.17729-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210325172512.17729-1-fw@strlen.de>
References: <20210325172512.17729-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Netfilter has multiple log modules:
 nf_log_arp
 nf_log_bridge
 nf_log_ipv4
 nf_log_ipv6
 nf_log_netdev
 nfnetlink_log
 nf_log_common

With the exception of nfnetlink_log (packet is sent to userspace for
dissection/logging), all of them log to the kernel ringbuffer.

This is the first part of a series to merge all modules except
nfnetlink_log into a single module: nf_log_syslog.

This allows to reduce code.  After the series, only two log modules remain:
nfnetlink_log and nf_log_syslog. The latter provides the same
functionality as the old per-af log modules.

This renames nf_log_ipv4 to nf_log_syslog.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/Kconfig                    |   5 +-
 net/ipv4/netfilter/Makefile                   |   1 -
 net/netfilter/Kconfig                         |  14 +-
 net/netfilter/Makefile                        |   1 +
 .../nf_log_syslog.c}                          | 120 +++++++++---------
 5 files changed, 76 insertions(+), 65 deletions(-)
 rename net/{ipv4/netfilter/nf_log_ipv4.c => netfilter/nf_log_syslog.c} (78%)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index a2f4f894be2b..aadb98e43fb1 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -81,7 +81,10 @@ config NF_LOG_ARP
 config NF_LOG_IPV4
 	tristate "IPv4 packet logging"
 	default m if NETFILTER_ADVANCED=n
-	select NF_LOG_COMMON
+	select NF_LOG_SYSLOG
+	help
+	This is a backwards-compat option for the user's convenience
+	(e.g. when running oldconfig). It selects CONFIG_NF_LOG_SYSLOG.
 
 config NF_REJECT_IPV4
 	tristate "IPv4 packet rejection"
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 7c497c78105f..abd133048b42 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -11,7 +11,6 @@ obj-$(CONFIG_NF_TPROXY_IPV4) += nf_tproxy_ipv4.o
 
 # logging
 obj-$(CONFIG_NF_LOG_ARP) += nf_log_arp.o
-obj-$(CONFIG_NF_LOG_IPV4) += nf_log_ipv4.o
 
 # reject
 obj-$(CONFIG_NF_REJECT_IPV4) += nf_reject_ipv4.o
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 1a92063c73a4..d5c047190eb9 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -78,6 +78,18 @@ config NF_LOG_NETDEV
 	tristate "Netdev packet logging"
 	select NF_LOG_COMMON
 
+config NF_LOG_SYSLOG
+	tristate "Syslog packet logging"
+	default m if NETFILTER_ADVANCED=n
+	select NF_LOG_COMMON
+	help
+	  This option enable support for packet logging via syslog.
+	  It supports IPv4 and common transport protocols such as TCP and UDP.
+	  This is a simpler but less flexible logging method compared to
+	  CONFIG_NETFILTER_NETLINK_LOG.
+	  If both are enabled the backend to use can be configured at run-time
+	  by means of per-address-family sysctl tunables.
+
 if NF_CONNTRACK
 config NETFILTER_CONNCOUNT
 	tristate
@@ -923,7 +935,7 @@ config NETFILTER_XT_TARGET_LED
 config NETFILTER_XT_TARGET_LOG
 	tristate "LOG target support"
 	select NF_LOG_COMMON
-	select NF_LOG_IPV4
+	select NF_LOG_SYSLOG
 	select NF_LOG_IPV6 if IP6_NF_IPTABLES
 	default m if NETFILTER_ADVANCED=n
 	help
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 33da7bf1b68e..59642d9ab7a5 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -50,6 +50,7 @@ nf_nat-y	:= nf_nat_core.o nf_nat_proto.o nf_nat_helper.o
 
 # generic transport layer logging
 obj-$(CONFIG_NF_LOG_COMMON) += nf_log_common.o
+obj-$(CONFIG_NF_LOG_SYSLOG) += nf_log_syslog.o
 
 # packet logging for netdev family
 obj-$(CONFIG_NF_LOG_NETDEV) += nf_log_netdev.o
diff --git a/net/ipv4/netfilter/nf_log_ipv4.c b/net/netfilter/nf_log_syslog.c
similarity index 78%
rename from net/ipv4/netfilter/nf_log_ipv4.c
rename to net/netfilter/nf_log_syslog.c
index d07583fac8f8..e6fe156e77c7 100644
--- a/net/ipv4/netfilter/nf_log_ipv4.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -32,13 +32,14 @@ static const struct nf_loginfo default_loginfo = {
 };
 
 /* One level of recursion won't kill us */
-static void dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
-			     const struct nf_loginfo *info,
-			     const struct sk_buff *skb, unsigned int iphoff)
+static noinline_for_stack void
+dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
+		 const struct nf_loginfo *info,
+		 const struct sk_buff *skb, unsigned int iphoff)
 {
-	struct iphdr _iph;
 	const struct iphdr *ih;
 	unsigned int logflags;
+	struct iphdr _iph;
 
 	if (info->type == NF_LOG_TYPE_LOG)
 		logflags = info->u.log.logflags;
@@ -46,14 +47,15 @@ static void dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 		logflags = NF_LOG_DEFAULT_MASK;
 
 	ih = skb_header_pointer(skb, iphoff, sizeof(_iph), &_iph);
-	if (ih == NULL) {
+	if (!ih) {
 		nf_log_buf_add(m, "TRUNCATED");
 		return;
 	}
 
 	/* Important fields:
-	 * TOS, len, DF/MF, fragment offset, TTL, src, dst, options. */
-	/* Max length: 40 "SRC=255.255.255.255 DST=255.255.255.255 " */
+	 * TOS, len, DF/MF, fragment offset, TTL, src, dst, options.
+	 * Max length: 40 "SRC=255.255.255.255 DST=255.255.255.255 "
+	 */
 	nf_log_buf_add(m, "SRC=%pI4 DST=%pI4 ", &ih->saddr, &ih->daddr);
 
 	/* Max length: 46 "LEN=65535 TOS=0xFF PREC=0xFF TTL=255 ID=65535 " */
@@ -75,14 +77,14 @@ static void dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 
 	if ((logflags & NF_LOG_IPOPT) &&
 	    ih->ihl * 4 > sizeof(struct iphdr)) {
-		const unsigned char *op;
 		unsigned char _opt[4 * 15 - sizeof(struct iphdr)];
+		const unsigned char *op;
 		unsigned int i, optsize;
 
 		optsize = ih->ihl * 4 - sizeof(struct iphdr);
-		op = skb_header_pointer(skb, iphoff+sizeof(_iph),
+		op = skb_header_pointer(skb, iphoff + sizeof(_iph),
 					optsize, _opt);
-		if (op == NULL) {
+		if (!op) {
 			nf_log_buf_add(m, "TRUNCATED");
 			return;
 		}
@@ -98,36 +100,31 @@ static void dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 	case IPPROTO_TCP:
 		if (nf_log_dump_tcp_header(m, skb, ih->protocol,
 					   ntohs(ih->frag_off) & IP_OFFSET,
-					   iphoff+ih->ihl*4, logflags))
+					   iphoff + ih->ihl * 4, logflags))
 			return;
 		break;
 	case IPPROTO_UDP:
 	case IPPROTO_UDPLITE:
 		if (nf_log_dump_udp_header(m, skb, ih->protocol,
 					   ntohs(ih->frag_off) & IP_OFFSET,
-					   iphoff+ih->ihl*4))
+					   iphoff + ih->ihl * 4))
 			return;
 		break;
 	case IPPROTO_ICMP: {
-		struct icmphdr _icmph;
+		static const size_t required_len[NR_ICMP_TYPES + 1] = {
+			[ICMP_ECHOREPLY] = 4,
+			[ICMP_DEST_UNREACH] = 8 + sizeof(struct iphdr),
+			[ICMP_SOURCE_QUENCH] = 8 + sizeof(struct iphdr),
+			[ICMP_REDIRECT] = 8 + sizeof(struct iphdr),
+			[ICMP_ECHO] = 4,
+			[ICMP_TIME_EXCEEDED] = 8 + sizeof(struct iphdr),
+			[ICMP_PARAMETERPROB] = 8 + sizeof(struct iphdr),
+			[ICMP_TIMESTAMP] = 20,
+			[ICMP_TIMESTAMPREPLY] = 20,
+			[ICMP_ADDRESS] = 12,
+			[ICMP_ADDRESSREPLY] = 12 };
 		const struct icmphdr *ich;
-		static const size_t required_len[NR_ICMP_TYPES+1]
-			= { [ICMP_ECHOREPLY] = 4,
-			    [ICMP_DEST_UNREACH]
-			    = 8 + sizeof(struct iphdr),
-			    [ICMP_SOURCE_QUENCH]
-			    = 8 + sizeof(struct iphdr),
-			    [ICMP_REDIRECT]
-			    = 8 + sizeof(struct iphdr),
-			    [ICMP_ECHO] = 4,
-			    [ICMP_TIME_EXCEEDED]
-			    = 8 + sizeof(struct iphdr),
-			    [ICMP_PARAMETERPROB]
-			    = 8 + sizeof(struct iphdr),
-			    [ICMP_TIMESTAMP] = 20,
-			    [ICMP_TIMESTAMPREPLY] = 20,
-			    [ICMP_ADDRESS] = 12,
-			    [ICMP_ADDRESSREPLY] = 12 };
+		struct icmphdr _icmph;
 
 		/* Max length: 11 "PROTO=ICMP " */
 		nf_log_buf_add(m, "PROTO=ICMP ");
@@ -138,9 +135,9 @@ static void dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
 		ich = skb_header_pointer(skb, iphoff + ih->ihl * 4,
 					 sizeof(_icmph), &_icmph);
-		if (ich == NULL) {
+		if (!ich) {
 			nf_log_buf_add(m, "INCOMPLETE [%u bytes] ",
-				       skb->len - iphoff - ih->ihl*4);
+				       skb->len - iphoff - ih->ihl * 4);
 			break;
 		}
 
@@ -150,9 +147,9 @@ static void dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
 		if (ich->type <= NR_ICMP_TYPES &&
 		    required_len[ich->type] &&
-		    skb->len-iphoff-ih->ihl*4 < required_len[ich->type]) {
+		    skb->len - iphoff - ih->ihl * 4 < required_len[ich->type]) {
 			nf_log_buf_add(m, "INCOMPLETE [%u bytes] ",
-				       skb->len - iphoff - ih->ihl*4);
+				       skb->len - iphoff - ih->ihl * 4);
 			break;
 		}
 
@@ -181,7 +178,7 @@ static void dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 			if (!iphoff) { /* Only recurse once. */
 				nf_log_buf_add(m, "[");
 				dump_ipv4_packet(net, m, info, skb,
-					    iphoff + ih->ihl*4+sizeof(_icmph));
+						 iphoff + ih->ihl * 4 + sizeof(_icmph));
 				nf_log_buf_add(m, "] ");
 			}
 
@@ -196,8 +193,8 @@ static void dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 	}
 	/* Max Length */
 	case IPPROTO_AH: {
-		struct ip_auth_hdr _ahdr;
 		const struct ip_auth_hdr *ah;
+		struct ip_auth_hdr _ahdr;
 
 		if (ntohs(ih->frag_off) & IP_OFFSET)
 			break;
@@ -206,11 +203,11 @@ static void dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 		nf_log_buf_add(m, "PROTO=AH ");
 
 		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
-		ah = skb_header_pointer(skb, iphoff+ih->ihl*4,
+		ah = skb_header_pointer(skb, iphoff + ih->ihl * 4,
 					sizeof(_ahdr), &_ahdr);
-		if (ah == NULL) {
+		if (!ah) {
 			nf_log_buf_add(m, "INCOMPLETE [%u bytes] ",
-				       skb->len - iphoff - ih->ihl*4);
+				       skb->len - iphoff - ih->ihl * 4);
 			break;
 		}
 
@@ -219,8 +216,8 @@ static void dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 		break;
 	}
 	case IPPROTO_ESP: {
-		struct ip_esp_hdr _esph;
 		const struct ip_esp_hdr *eh;
+		struct ip_esp_hdr _esph;
 
 		/* Max length: 10 "PROTO=ESP " */
 		nf_log_buf_add(m, "PROTO=ESP ");
@@ -229,11 +226,11 @@ static void dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 			break;
 
 		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
-		eh = skb_header_pointer(skb, iphoff+ih->ihl*4,
+		eh = skb_header_pointer(skb, iphoff + ih->ihl * 4,
 					sizeof(_esph), &_esph);
-		if (eh == NULL) {
+		if (!eh) {
 			nf_log_buf_add(m, "INCOMPLETE [%u bytes] ",
-				       skb->len - iphoff - ih->ihl*4);
+				       skb->len - iphoff - ih->ihl * 4);
 			break;
 		}
 
@@ -270,8 +267,8 @@ static void dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 }
 
 static void dump_ipv4_mac_header(struct nf_log_buf *m,
-			    const struct nf_loginfo *info,
-			    const struct sk_buff *skb)
+				 const struct nf_loginfo *info,
+				 const struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
 	unsigned int logflags = 0;
@@ -329,7 +326,7 @@ static void nf_log_ip_packet(struct net *net, u_int8_t pf,
 	nf_log_dump_packet_common(m, pf, hooknum, skb, in,
 				  out, loginfo, prefix);
 
-	if (in != NULL)
+	if (in)
 		dump_ipv4_mac_header(m, loginfo, skb);
 
 	dump_ipv4_packet(net, m, loginfo, skb, 0);
@@ -344,52 +341,51 @@ static struct nf_logger nf_ip_logger __read_mostly = {
 	.me		= THIS_MODULE,
 };
 
-static int __net_init nf_log_ipv4_net_init(struct net *net)
+static int __net_init nf_log_syslog_net_init(struct net *net)
 {
 	return nf_log_set(net, NFPROTO_IPV4, &nf_ip_logger);
 }
 
-static void __net_exit nf_log_ipv4_net_exit(struct net *net)
+static void __net_exit nf_log_syslog_net_exit(struct net *net)
 {
 	nf_log_unset(net, &nf_ip_logger);
 }
 
-static struct pernet_operations nf_log_ipv4_net_ops = {
-	.init = nf_log_ipv4_net_init,
-	.exit = nf_log_ipv4_net_exit,
+static struct pernet_operations nf_log_syslog_net_ops = {
+	.init = nf_log_syslog_net_init,
+	.exit = nf_log_syslog_net_exit,
 };
 
-static int __init nf_log_ipv4_init(void)
+static int __init nf_log_syslog_init(void)
 {
 	int ret;
 
-	ret = register_pernet_subsys(&nf_log_ipv4_net_ops);
+	ret = register_pernet_subsys(&nf_log_syslog_net_ops);
 	if (ret < 0)
 		return ret;
 
 	ret = nf_log_register(NFPROTO_IPV4, &nf_ip_logger);
-	if (ret < 0) {
-		pr_err("failed to register logger\n");
+	if (ret < 0)
 		goto err1;
-	}
 
 	return 0;
 
 err1:
-	unregister_pernet_subsys(&nf_log_ipv4_net_ops);
+	unregister_pernet_subsys(&nf_log_syslog_net_ops);
 	return ret;
 }
 
-static void __exit nf_log_ipv4_exit(void)
+static void __exit nf_log_syslog_exit(void)
 {
-	unregister_pernet_subsys(&nf_log_ipv4_net_ops);
+	unregister_pernet_subsys(&nf_log_syslog_net_ops);
 	nf_log_unregister(&nf_ip_logger);
 }
 
-module_init(nf_log_ipv4_init);
-module_exit(nf_log_ipv4_exit);
+module_init(nf_log_syslog_init);
+module_exit(nf_log_syslog_exit);
 
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("Netfilter IPv4 packet logging");
+MODULE_DESCRIPTION("Netfilter syslog packet logging");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("nf_log_ipv4");
 MODULE_ALIAS_NF_LOGGER(AF_INET, 0);
-- 
2.26.3

