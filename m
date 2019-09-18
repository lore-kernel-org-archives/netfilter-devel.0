Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DATE_IN_PAST_96_XX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7381CA9ECB
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 14:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 781F32080F
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 14:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfJaOKQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 10:10:16 -0400
Received: from mailout1.hostsharing.net ([83.223.95.204]:36563 "EHLO
        mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfJaOKP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 10:10:15 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id 19BDB101933FD;
        Thu, 31 Oct 2019 15:10:06 +0100 (CET)
Received: from localhost (pd95be530.dip0.t-ipconnect.de [217.91.229.48])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id B9A97612B6F8;
        Thu, 31 Oct 2019 15:10:05 +0100 (CET)
X-Mailbox-Line: From efce8f52ab1874f27b7a0024d36d269b04ff9773 Mon Sep 17 00:00:00 2001
Message-Id: <efce8f52ab1874f27b7a0024d36d269b04ff9773.1572527944.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Wed, 18 Sep 2019 14:37:06 +0200
Subject: [PATCH nft,RFC] src: Support netdev egress hook
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Martin Mares <mj@ucw.cz>,
        Daniel Borkmann <daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add userspace support for the newly introduced netdev egress hook
with documentation and tests.  Usage is identical to the ingress hook.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 doc/nft.txt                                   |   14 +-
 doc/statements.txt                            |    4 +-
 include/linux/netfilter.h                     |    1 +
 src/evaluate.c                                |    2 +
 src/rule.c                                    |    3 +
 tests/py/any/dup.t                            |    3 +-
 tests/py/any/fwd.t                            |    3 +-
 tests/py/any/icmpX.t.netdev                   |    3 +-
 tests/py/any/limit.t                          |    3 +-
 tests/py/any/meta.t                           |    3 +-
 tests/py/any/objects.t                        |    3 +-
 tests/py/any/quota.t                          |    3 +-
 tests/py/any/rawpayload.t                     |    3 +-
 tests/py/arp/arp.t                            |    3 +-
 tests/py/bridge/vlan.t                        |    3 +-
 tests/py/inet/ah.t                            |    3 +-
 tests/py/inet/comp.t                          |    3 +-
 tests/py/inet/dccp.t                          |    3 +-
 tests/py/inet/esp.t                           |    3 +-
 tests/py/inet/ether-ip.t                      |    3 +-
 tests/py/inet/ether.t                         |    3 +-
 tests/py/inet/ip.t                            |    3 +-
 tests/py/inet/ip_tcp.t                        |    3 +-
 tests/py/inet/map.t                           |    3 +-
 tests/py/inet/sctp.t                          |    3 +-
 tests/py/inet/sets.t                          |    3 +-
 tests/py/inet/tcp.t                           |    3 +-
 tests/py/inet/udp.t                           |    3 +-
 tests/py/inet/udplite.t                       |    3 +-
 tests/py/ip/ip.t                              |    3 +-
 tests/py/ip/ip_tcp.t                          |    2 +
 tests/py/ip/ip_tcp.t.payload.netdev           |   93 ++
 tests/py/ip/sets.t                            |    3 +-
 tests/py/ip6/frag.t                           |    2 +
 tests/py/ip6/frag.t.payload.netdev            | 1476 +++++++++++++++++
 tests/py/ip6/sets.t                           |    3 +-
 tests/py/ip6/vmap.t                           |    3 +-
 tests/shell/testcases/chains/0021prio_0       |    1 +
 .../shell/testcases/chains/0026prio_netdev_1  |    4 +-
 .../testcases/chains/dumps/0021prio_0.nft     |   20 +
 40 files changed, 1670 insertions(+), 36 deletions(-)
 create mode 100644 tests/py/ip/ip_tcp.t.payload.netdev
 create mode 100644 tests/py/ip6/frag.t.payload.netdev

diff --git a/doc/nft.txt b/doc/nft.txt
index 2c790099..bd03546d 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -172,7 +172,7 @@ packet processing paths, which invoke nftables if rules for these hooks exist.
 *inet*:: Internet (IPv4/IPv6) address family.
 *arp*:: ARP address family, handling IPv4 ARP packets.
 *bridge*:: Bridge address family, handling packets which traverse a bridge device.
-*netdev*:: Netdev address family, handling packets from ingress.
+*netdev*:: Netdev address family, handling packets on ingress and egress.
 
 All nftables objects exist in address family specific namespaces, therefore all
 identifiers include an address family. If an identifier is specified without an
@@ -225,7 +225,7 @@ The list of supported hooks is identical to IPv4/IPv6/Inet address families abov
 
 NETDEV ADDRESS FAMILY
 ~~~~~~~~~~~~~~~~~~~~
-The Netdev address family handles packets from ingress.
+The Netdev address family handles packets on ingress and egress.
 
 .Netdev address family hooks
 [options="header"]
@@ -234,6 +234,9 @@ The Netdev address family handles packets from ingress.
 |ingress |
 All packets entering the system are processed by this hook. It is invoked before
 layer 3 protocol handlers and it can be used for early filtering and policing.
+|egress |
+All packets leaving the system are processed by this hook. It is invoked after
+layer 3 protocol handlers and can be used for late filtering and policing.
 |=================
 
 RULESET
@@ -359,9 +362,10 @@ Apart from the special cases illustrated above (e.g. *nat* type not supporting
 *forward* hook or *route* type only supporting *output* hook), there are two
 further quirks worth noticing:
 
-* The netdev family supports merely a single combination, namely *filter* type and
-  *ingress* hook. Base chains in this family also require the *device* parameter
-  to be present since they exist per incoming interface only.
+* The netdev family supports merely two combinations, namely *filter* type with
+  *ingress* hook and *filter* type with *egress* hook. Base chains in this
+  family also require the *device* parameter to be present since they exist per
+  interface only.
 * The arp family supports only the *input* and *output* hooks, both in chains of type
   *filter*.
 
diff --git a/doc/statements.txt b/doc/statements.txt
index e17068a8..cb037234 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -660,8 +660,8 @@ dup to ip daddr map { 192.168.7.1 : "eth0", 192.168.7.2 : "eth1" }
 FWD STATEMENT
 ~~~~~~~~~~~~~
 The fwd statement is used to redirect a raw packet to another interface. It is
-only available in the netdev family ingress hook. It is similar to the dup
-statement except that no copy is made.
+only available in the netdev family ingress and egress hooks. It is similar to
+the dup statement except that no copy is made.
 
 *fwd to* 'device'
 
diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 18075f95..8ca15b43 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -53,6 +53,7 @@ enum nf_inet_hooks {
 
 enum nf_dev_hooks {
 	NF_NETDEV_INGRESS,
+	NF_NETDEV_EGRESS,
 	NF_NETDEV_NUMHOOKS
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index a56cd2a5..f1fcb708 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3545,6 +3545,8 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 	case NFPROTO_NETDEV:
 		if (!strcmp(hook, "ingress"))
 			return NF_NETDEV_INGRESS;
+		else if (!strcmp(hook, "egress"))
+			return NF_NETDEV_EGRESS;
 		break;
 	default:
 		break;
diff --git a/src/rule.c b/src/rule.c
index c258f12e..f26fe3ec 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -775,6 +775,7 @@ static const char * const chain_hookname_str_array[] = {
 	"postrouting",
 	"output",
 	"ingress",
+	"egress",
 	NULL,
 };
 
@@ -931,6 +932,8 @@ const char *hooknum2str(unsigned int family, unsigned int hooknum)
 		switch (hooknum) {
 		case NF_NETDEV_INGRESS:
 			return "ingress";
+		case NF_NETDEV_EGRESS:
+			return "egress";
 		}
 		break;
 	default:
diff --git a/tests/py/any/dup.t b/tests/py/any/dup.t
index 181b4195..56328022 100644
--- a/tests/py/any/dup.t
+++ b/tests/py/any/dup.t
@@ -1,6 +1,7 @@
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 dup to "lo";ok
 dup to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"};ok
diff --git a/tests/py/any/fwd.t b/tests/py/any/fwd.t
index 2e34d55a..6051560a 100644
--- a/tests/py/any/fwd.t
+++ b/tests/py/any/fwd.t
@@ -1,6 +1,7 @@
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 fwd to "lo";ok
 fwd to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"};ok
diff --git a/tests/py/any/icmpX.t.netdev b/tests/py/any/icmpX.t.netdev
index a327ce6a..cf402428 100644
--- a/tests/py/any/icmpX.t.netdev
+++ b/tests/py/any/icmpX.t.netdev
@@ -1,6 +1,7 @@
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 ip protocol icmp icmp type echo-request;ok;icmp type echo-request
 icmp type echo-request;ok
diff --git a/tests/py/any/limit.t b/tests/py/any/limit.t
index ef7f9313..0110e77f 100644
--- a/tests/py/any/limit.t
+++ b/tests/py/any/limit.t
@@ -1,12 +1,13 @@
 :output;type filter hook output priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;output
 *ip6;test-ip6;output
 *inet;test-inet;output
 *arp;test-arp;output
 *bridge;test-bridge;output
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 limit rate 400/minute;ok
 limit rate 20/second;ok
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 86e5d258..b0f92461 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -1,12 +1,13 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
 *arp;test-arp;input
 *bridge;test-bridge;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 meta length 1000;ok
 meta length 22;ok
diff --git a/tests/py/any/objects.t b/tests/py/any/objects.t
index 89a9545f..7b51f918 100644
--- a/tests/py/any/objects.t
+++ b/tests/py/any/objects.t
@@ -1,12 +1,13 @@
 :output;type filter hook output priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;output
 *ip6;test-ip6;output
 *inet;test-inet;output
 *arp;test-arp;output
 *bridge;test-bridge;output
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 %cnt1 type counter;ok
 %qt1 type quota 25 mbytes;ok
diff --git a/tests/py/any/quota.t b/tests/py/any/quota.t
index 9a8db114..79dd7654 100644
--- a/tests/py/any/quota.t
+++ b/tests/py/any/quota.t
@@ -1,12 +1,13 @@
 :output;type filter hook output priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;output
 *ip6;test-ip6;output
 *inet;test-inet;output
 *arp;test-arp;output
 *bridge;test-bridge;output
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 quota 1025 bytes;ok
 quota 1 kbytes;ok
diff --git a/tests/py/any/rawpayload.t b/tests/py/any/rawpayload.t
index c3382a96..9687729d 100644
--- a/tests/py/any/rawpayload.t
+++ b/tests/py/any/rawpayload.t
@@ -1,8 +1,9 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 meta l4proto { tcp, udp, sctp} @th,16,16 { 22, 23, 80 };ok;meta l4proto { 6, 17, 132} th dport { 22, 23, 80}
 meta l4proto tcp @th,16,16 { 22, 23, 80};ok;tcp dport { 22, 23, 80}
diff --git a/tests/py/arp/arp.t b/tests/py/arp/arp.t
index 2540c0a7..46449016 100644
--- a/tests/py/arp/arp.t
+++ b/tests/py/arp/arp.t
@@ -1,9 +1,10 @@
 # filter chains available are: input, output, forward
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *arp;test-arp;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 arp htype 1;ok
 arp htype != 1;ok
diff --git a/tests/py/bridge/vlan.t b/tests/py/bridge/vlan.t
index 7a52a502..d3aa27a7 100644
--- a/tests/py/bridge/vlan.t
+++ b/tests/py/bridge/vlan.t
@@ -1,8 +1,9 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *bridge;test-bridge;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 vlan id 4094;ok
 vlan id 0;ok
diff --git a/tests/py/inet/ah.t b/tests/py/inet/ah.t
index 8544d9dd..878403ae 100644
--- a/tests/py/inet/ah.t
+++ b/tests/py/inet/ah.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 # nexthdr Bug to list table.
 
diff --git a/tests/py/inet/comp.t b/tests/py/inet/comp.t
index 0df18139..082f5c16 100644
--- a/tests/py/inet/comp.t
+++ b/tests/py/inet/comp.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 # BUG: nft: payload.c:88: payload_expr_pctx_update: Assertion `left->payload.base + 1 <= (__PROTO_BASE_MAX - 1)' failed.
 - comp nexthdr esp;ok;comp nexthdr 50
diff --git a/tests/py/inet/dccp.t b/tests/py/inet/dccp.t
index f0dd788b..3b08f62f 100644
--- a/tests/py/inet/dccp.t
+++ b/tests/py/inet/dccp.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 dccp sport 21-35;ok
 dccp sport != 21-35;ok
diff --git a/tests/py/inet/esp.t b/tests/py/inet/esp.t
index e79eeada..65f5a5ec 100644
--- a/tests/py/inet/esp.t
+++ b/tests/py/inet/esp.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 esp spi 100;ok
 esp spi != 100;ok
diff --git a/tests/py/inet/ether-ip.t b/tests/py/inet/ether-ip.t
index 0c8c7f9d..759124de 100644
--- a/tests/py/inet/ether-ip.t
+++ b/tests/py/inet/ether-ip.t
@@ -1,8 +1,9 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept;ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4 accept
 tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04;ok
diff --git a/tests/py/inet/ether.t b/tests/py/inet/ether.t
index afdf8b89..c4b1ced7 100644
--- a/tests/py/inet/ether.t
+++ b/tests/py/inet/ether.t
@@ -1,11 +1,12 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
 *bridge;test-bridge;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 accept;ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 accept
 tcp dport 22 ether saddr 00:0f:54:0c:11:04 accept;ok
diff --git a/tests/py/inet/ip.t b/tests/py/inet/ip.t
index 4eb69d73..3574a612 100644
--- a/tests/py/inet/ip.t
+++ b/tests/py/inet/ip.t
@@ -1,9 +1,10 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *inet;test-inet;input
 *bridge;test-bridge;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe };ok
diff --git a/tests/py/inet/ip_tcp.t b/tests/py/inet/ip_tcp.t
index f2a28ebd..ab76ffa9 100644
--- a/tests/py/inet/ip_tcp.t
+++ b/tests/py/inet/ip_tcp.t
@@ -1,9 +1,10 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *inet;test-inet;input
 *bridge;test-bridge;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 # must not remove ip dependency -- ONLY ipv4 packets should be matched
 ip protocol tcp tcp dport 22;ok;ip protocol 6 tcp dport 22
diff --git a/tests/py/inet/map.t b/tests/py/inet/map.t
index e83490a8..5a7161b7 100644
--- a/tests/py/inet/map.t
+++ b/tests/py/inet/map.t
@@ -1,9 +1,10 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 mark set ip saddr map { 10.2.3.2 : 0x0000002a, 10.2.3.1 : 0x00000017};ok;meta mark set ip saddr map { 10.2.3.1 : 0x00000017, 10.2.3.2 : 0x0000002a}
 mark set ip hdrlength map { 5 : 0x00000017, 4 : 0x00000001};ok;meta mark set ip hdrlength map { 4 : 0x00000001, 5 : 0x00000017}
diff --git a/tests/py/inet/sctp.t b/tests/py/inet/sctp.t
index 5188b57e..02391b35 100644
--- a/tests/py/inet/sctp.t
+++ b/tests/py/inet/sctp.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 sctp sport 23;ok
 sctp sport != 23;ok
diff --git a/tests/py/inet/sets.t b/tests/py/inet/sets.t
index daf8f2d6..0b07ec59 100644
--- a/tests/py/inet/sets.t
+++ b/tests/py/inet/sets.t
@@ -1,9 +1,10 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *inet;test-inet;input
 *bridge;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 !set1 type ipv4_addr timeout 60s;ok
 ?set1 192.168.3.4 timeout 30s, 10.2.1.1;ok
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index e0a83e2b..88e0f562 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 tcp dport set {1, 2, 3};fail
 
diff --git a/tests/py/inet/udp.t b/tests/py/inet/udp.t
index 4e3eaa51..f60e1c77 100644
--- a/tests/py/inet/udp.t
+++ b/tests/py/inet/udp.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 udp sport 80 accept;ok
 udp sport != 60 accept;ok
diff --git a/tests/py/inet/udplite.t b/tests/py/inet/udplite.t
index 7c22acb9..5d574121 100644
--- a/tests/py/inet/udplite.t
+++ b/tests/py/inet/udplite.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 udplite sport 80 accept;ok
 udplite sport != 60 accept;ok
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 0421d01b..0092d422 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *inet;test-inet;input
 *bridge;test-bridge;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 - ip version 2;ok
 
diff --git a/tests/py/ip/ip_tcp.t b/tests/py/ip/ip_tcp.t
index 467da3ef..646b0ca5 100644
--- a/tests/py/ip/ip_tcp.t
+++ b/tests/py/ip/ip_tcp.t
@@ -1,7 +1,9 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip;input
+*netdev;test-netdev;ingress,egress
 
 # can remove ip dependency -- its redundant in ip family
 ip protocol tcp tcp dport 22;ok;tcp dport 22
diff --git a/tests/py/ip/ip_tcp.t.payload.netdev b/tests/py/ip/ip_tcp.t.payload.netdev
new file mode 100644
index 00000000..74dc1195
--- /dev/null
+++ b/tests/py/ip/ip_tcp.t.payload.netdev
@@ -0,0 +1,93 @@
+# ip protocol tcp tcp dport 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip protocol tcp meta mark set 1 tcp dport 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x00000001 ]
+  [ meta set mark with reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip protocol tcp meta mark set 1 tcp dport 22
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x00000001 ]
+  [ meta set mark with reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip protocol tcp tcp dport 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip protocol tcp meta mark set 1 tcp dport 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x00000001 ]
+  [ meta set mark with reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip protocol tcp meta mark set 1 tcp dport 22
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x00000001 ]
+  [ meta set mark with reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip protocol tcp tcp dport 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip protocol tcp meta mark set 1 tcp dport 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x00000001 ]
+  [ meta set mark with reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip protocol tcp meta mark set 1 tcp dport 22
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x00000001 ]
+  [ meta set mark with reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
diff --git a/tests/py/ip/sets.t b/tests/py/ip/sets.t
index 7b7e0722..815a8473 100644
--- a/tests/py/ip/sets.t
+++ b/tests/py/ip/sets.t
@@ -1,9 +1,10 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 !w type ipv4_addr;ok
 !x type inet_proto;ok
diff --git a/tests/py/ip6/frag.t b/tests/py/ip6/frag.t
index e16529ad..3a433cdb 100644
--- a/tests/py/ip6/frag.t
+++ b/tests/py/ip6/frag.t
@@ -1,8 +1,10 @@
 :output;type filter hook output priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip6;test-ip6;output
 *inet;test-inet;output
+*netdev;test-netdev;ingress,egress
 
 frag nexthdr tcp;ok;frag nexthdr 6
 frag nexthdr != icmp;ok;frag nexthdr != 1
diff --git a/tests/py/ip6/frag.t.payload.netdev b/tests/py/ip6/frag.t.payload.netdev
new file mode 100644
index 00000000..b8b193ba
--- /dev/null
+++ b/tests/py/ip6/frag.t.payload.netdev
@@ -0,0 +1,1476 @@
+# frag nexthdr tcp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# frag nexthdr tcp
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# frag nexthdr != icmp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00000001 ]
+
+# frag nexthdr != icmp
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00000001 ]
+
+# frag nexthdr esp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+
+# frag nexthdr esp
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+
+# frag nexthdr ah
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+
+# frag nexthdr ah
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+
+# frag reserved 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000016 ]
+
+# frag reserved 22
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000016 ]
+
+# frag reserved != 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp neq reg 1 0x000000e9 ]
+
+# frag reserved != 233
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp neq reg 1 0x000000e9 ]
+
+# frag reserved 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp gte reg 1 0x00000021 ]
+  [ cmp lte reg 1 0x0000002d ]
+
+# frag reserved 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp gte reg 1 0x00000021 ]
+  [ cmp lte reg 1 0x0000002d ]
+
+# frag reserved != 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
+
+# frag reserved != 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
+
+# frag frag-off 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off 22
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off != 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off != 233
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag reserved2 1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag reserved2 1
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag more-fragments 0
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 0
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag more-fragments 1
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag id 1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# frag id 1
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# frag id 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x16000000 ]
+
+# frag id 22
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x16000000 ]
+
+# frag id != 33
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp neq reg 1 0x21000000 ]
+
+# frag id != 33
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp neq reg 1 0x21000000 ]
+
+# frag id 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp gte reg 1 0x21000000 ]
+  [ cmp lte reg 1 0x2d000000 ]
+
+# frag id 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp gte reg 1 0x21000000 ]
+  [ cmp lte reg 1 0x2d000000 ]
+
+# frag id != 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
+
+# frag id != 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
+
+# frag nexthdr tcp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# frag nexthdr tcp
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# frag nexthdr != icmp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00000001 ]
+
+# frag nexthdr != icmp
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00000001 ]
+
+# frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-netdev 3 size 8
+__set%d test-netdev 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-netdev 3 size 8
+__set%d test-netdev 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-netdev 3 size 8
+__set%d test-netdev 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-netdev 3 size 8
+__set%d test-netdev 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag nexthdr esp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+
+# frag nexthdr esp
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+
+# frag nexthdr ah
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+
+# frag nexthdr ah
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+
+# frag reserved 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000016 ]
+
+# frag reserved 22
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000016 ]
+
+# frag reserved != 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp neq reg 1 0x000000e9 ]
+
+# frag reserved != 233
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp neq reg 1 0x000000e9 ]
+
+# frag reserved 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp gte reg 1 0x00000021 ]
+  [ cmp lte reg 1 0x0000002d ]
+
+# frag reserved 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp gte reg 1 0x00000021 ]
+  [ cmp lte reg 1 0x0000002d ]
+
+# frag reserved != 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
+
+# frag reserved != 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
+
+# frag reserved { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag reserved { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag reserved != { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved != { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag reserved { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag reserved != { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved != { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off 22
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off != 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off != 233
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved2 1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag reserved2 1
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag more-fragments 0
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 0
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag more-fragments 1
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag id 1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# frag id 1
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# frag id 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x16000000 ]
+
+# frag id 22
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x16000000 ]
+
+# frag id != 33
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp neq reg 1 0x21000000 ]
+
+# frag id != 33
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp neq reg 1 0x21000000 ]
+
+# frag id 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp gte reg 1 0x21000000 ]
+  [ cmp lte reg 1 0x2d000000 ]
+
+# frag id 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp gte reg 1 0x21000000 ]
+  [ cmp lte reg 1 0x2d000000 ]
+
+# frag id != 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
+
+# frag id != 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
+
+# frag id { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag id { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag id != { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag id != { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag id { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag id { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag id != { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag id != { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag nexthdr tcp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# frag nexthdr tcp
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# frag nexthdr != icmp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00000001 ]
+
+# frag nexthdr != icmp
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00000001 ]
+
+# frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-netdev 3 size 8
+__set%d test-netdev 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-netdev 3 size 8
+__set%d test-netdev 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-netdev 3 size 8
+__set%d test-netdev 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-netdev 3 size 8
+__set%d test-netdev 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag nexthdr esp
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+
+# frag nexthdr esp
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+
+# frag nexthdr ah
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+
+# frag nexthdr ah
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+
+# frag reserved 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000016 ]
+
+# frag reserved 22
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000016 ]
+
+# frag reserved != 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp neq reg 1 0x000000e9 ]
+
+# frag reserved != 233
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp neq reg 1 0x000000e9 ]
+
+# frag reserved 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp gte reg 1 0x00000021 ]
+  [ cmp lte reg 1 0x0000002d ]
+
+# frag reserved 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp gte reg 1 0x00000021 ]
+  [ cmp lte reg 1 0x0000002d ]
+
+# frag reserved != 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
+
+# frag reserved != 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
+
+# frag reserved { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag reserved { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag reserved != { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved != { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag reserved { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag reserved != { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved != { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off 22
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off != 233
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off != 233
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved2 1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag reserved2 1
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag more-fragments 0
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 0
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag more-fragments 1
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag id 1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# frag id 1
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# frag id 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x16000000 ]
+
+# frag id 22
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x16000000 ]
+
+# frag id != 33
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp neq reg 1 0x21000000 ]
+
+# frag id != 33
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp neq reg 1 0x21000000 ]
+
+# frag id 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp gte reg 1 0x21000000 ]
+  [ cmp lte reg 1 0x2d000000 ]
+
+# frag id 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp gte reg 1 0x21000000 ]
+  [ cmp lte reg 1 0x2d000000 ]
+
+# frag id != 33-45
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
+
+# frag id != 33-45
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
+
+# frag id { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag id { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag id != { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag id != { 33, 55, 67, 88}
+__set%d test-netdev 3 size 4
+__set%d test-netdev 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag id { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag id { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag id != { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag id != { 33-55}
+__set%d test-netdev 7 size 3
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/py/ip6/sets.t b/tests/py/ip6/sets.t
index add82eb8..3b99d661 100644
--- a/tests/py/ip6/sets.t
+++ b/tests/py/ip6/sets.t
@@ -1,9 +1,10 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 !w type ipv6_addr;ok
 !x type inet_proto;ok
diff --git a/tests/py/ip6/vmap.t b/tests/py/ip6/vmap.t
index 434f5d92..2d54b822 100644
--- a/tests/py/ip6/vmap.t
+++ b/tests/py/ip6/vmap.t
@@ -1,9 +1,10 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 ip6 saddr vmap { abcd::3 : accept };ok
 ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234:1234;fail
diff --git a/tests/shell/testcases/chains/0021prio_0 b/tests/shell/testcases/chains/0021prio_0
index e7612974..d450dc0b 100755
--- a/tests/shell/testcases/chains/0021prio_0
+++ b/tests/shell/testcases/chains/0021prio_0
@@ -69,6 +69,7 @@ done
 family=netdev
 echo "add table $family x"
 gen_chains $family ingress filter lo
+gen_chains $family egress filter lo
 
 family=bridge
 echo "add table $family x"
diff --git a/tests/shell/testcases/chains/0026prio_netdev_1 b/tests/shell/testcases/chains/0026prio_netdev_1
index aa902e9b..b6fa3db5 100755
--- a/tests/shell/testcases/chains/0026prio_netdev_1
+++ b/tests/shell/testcases/chains/0026prio_netdev_1
@@ -1,7 +1,8 @@
 #!/bin/bash
 
 family=netdev
-	hook=ingress
+	for hook in ingress egress
+	do
 		for prioname in raw mangle dstnat security srcnat
 		do
 			$NFT add table $family x || exit 1
@@ -12,4 +13,5 @@ family=netdev
 				exit 1
 			fi
 		done
+	done
 exit 0
diff --git a/tests/shell/testcases/chains/dumps/0021prio_0.nft b/tests/shell/testcases/chains/dumps/0021prio_0.nft
index ca94d441..4297d246 100644
--- a/tests/shell/testcases/chains/dumps/0021prio_0.nft
+++ b/tests/shell/testcases/chains/dumps/0021prio_0.nft
@@ -1382,6 +1382,26 @@ table netdev x {
 	chain ingressfilterp11 {
 		type filter hook ingress device "lo" priority 11; policy accept;
 	}
+
+	chain egressfilterm11 {
+		type filter hook egress device "lo" priority -11; policy accept;
+	}
+
+	chain egressfilterm10 {
+		type filter hook egress device "lo" priority filter - 10; policy accept;
+	}
+
+	chain egressfilter {
+		type filter hook egress device "lo" priority filter; policy accept;
+	}
+
+	chain egressfilterp10 {
+		type filter hook egress device "lo" priority filter + 10; policy accept;
+	}
+
+	chain egressfilterp11 {
+		type filter hook egress device "lo" priority 11; policy accept;
+	}
 }
 table bridge x {
 	chain preroutingfilterm11 {
-- 
2.23.0

