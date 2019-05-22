Return-Path: <SRS0=iiCe=TW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F9AC282CE
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 21:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E67E2173E
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 21:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbfEVVS7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 May 2019 17:18:59 -0400
Received: from mail.us.es ([193.147.175.20]:53886 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729720AbfEVVS6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 May 2019 17:18:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 636ABC1D44
        for <netfilter-devel@vger.kernel.org>; Wed, 22 May 2019 23:18:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 516AFDA704
        for <netfilter-devel@vger.kernel.org>; Wed, 22 May 2019 23:18:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 46F61DA703; Wed, 22 May 2019 23:18:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2BF3DA704
        for <netfilter-devel@vger.kernel.org>; Wed, 22 May 2019 23:18:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 22 May 2019 23:18:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.219.46])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C54B04265A32
        for <netfilter-devel@vger.kernel.org>; Wed, 22 May 2019 23:18:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: support for arp sender and target ethernet and IPv4 addresses
Date:   Wed, 22 May 2019 23:18:48 +0200
Message-Id: <20190522211848.32403-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # nft add table arp x
 # nft add chain arp x y { type filter hook input priority 0\; }
 # nft add rule arp x y arp saddr ip 192.168.2.1 counter

Testing this:

 # ip neigh flush dev eth0
 # ping 8.8.8.8
 # nft list ruleset
 table arp x {
        chain y {
                type filter hook input priority filter; policy accept;
		arp saddr ip 192.168.2.1 counter packets 1 bytes 46
        }
 }

You can also specify hardware sender address, eg.

 # nft add rule arp x y arp saddr ether aa:bb:cc:aa:bb:cc drop counter

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/payload-expression.txt        | 14 +++++++++++++-
 include/headers.h                 | 12 ++++++++++++
 include/proto.h                   |  4 ++++
 src/parser_bison.y                |  4 ++++
 src/proto.c                       | 22 ++++++++++++++--------
 tests/py/arp/arp.t                |  7 ++++++-
 tests/py/arp/arp.t.payload        | 21 +++++++++++++++++++++
 tests/py/arp/arp.t.payload.netdev | 28 ++++++++++++++++++++++++++++
 8 files changed, 102 insertions(+), 10 deletions(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 7f3ca42d4605..ebbffe50b1e1 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -44,7 +44,7 @@ ether_type
 ARP HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*arp* {*htype* | *ptype* | *hlen* | *plen* | *operation*}
+*arp* {*htype* | *ptype* | *hlen* | *plen* | *operation* | *saddr* { *ip* | *ether* } | *daddr* { *ip* | *ether* }
 
 .ARP header expression
 [options="header"]
@@ -65,6 +65,18 @@ integer (8 bit)
 |operation|
 Operation |
 arp_op
+|saddr ether|
+Ethernet sender address|
+ether_addr
+|daddr ether|
+Ethernet target address|
+ether_addr
+|saddr ip|
+IPv4 sender address|
+ipv4_addr
+|daddr ip|
+IPv4 target address|
+ipv4_addr
 |======================
 
 IPV4 HEADER EXPRESSION
diff --git a/include/headers.h b/include/headers.h
index 3d564debf8b0..759f93bf8c7a 100644
--- a/include/headers.h
+++ b/include/headers.h
@@ -78,6 +78,18 @@ struct sctphdr {
 	uint32_t	checksum;
 };
 
+struct arp_hdr {
+	uint16_t	htype;
+	uint16_t	ptype;
+	uint8_t		hlen;
+	uint8_t		plen;
+	uint16_t	oper;
+	uint8_t		sha[6];
+	uint32_t	spa;
+	uint8_t		tha[6];
+	uint32_t	tpa;
+} __attribute__((__packed__));
+
 struct ipv6hdr {
 	uint8_t		version:4,
 			priority:4;
diff --git a/include/proto.h b/include/proto.h
index 99c57a7997cc..92b25edbd3da 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -182,6 +182,10 @@ enum arp_hdr_fields {
 	ARPHDR_HLN,
 	ARPHDR_PLN,
 	ARPHDR_OP,
+	ARPHDR_SADDR_ETHER,
+	ARPHDR_DADDR_ETHER,
+	ARPHDR_SADDR_IP,
+	ARPHDR_DADDR_IP,
 };
 
 enum ip_hdr_fields {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9e632c0d1f6e..8c8cd43264cf 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4243,6 +4243,10 @@ arp_hdr_field		:	HTYPE		{ $$ = ARPHDR_HRD; }
 			|	HLEN		{ $$ = ARPHDR_HLN; }
 			|	PLEN		{ $$ = ARPHDR_PLN; }
 			|	OPERATION	{ $$ = ARPHDR_OP; }
+			|	SADDR ETHER	{ $$ = ARPHDR_SADDR_ETHER; }
+			|	DADDR ETHER	{ $$ = ARPHDR_DADDR_ETHER; }
+			|	SADDR IP	{ $$ = ARPHDR_SADDR_IP; }
+			|	DADDR IP	{ $$ = ARPHDR_DADDR_IP; }
 			;
 
 ip_hdr_expr		:	IP	ip_hdr_field
diff --git a/src/proto.c b/src/proto.c
index f68fb68436b6..67e86f2070c1 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -874,23 +874,29 @@ const struct datatype arpop_type = {
 };
 
 #define ARPHDR_TYPE(__name, __type, __member) \
-	HDR_TYPE(__name, __type, struct arphdr, __member)
+	HDR_TYPE(__name, __type, struct arp_hdr, __member)
 #define ARPHDR_FIELD(__name, __member) \
-	HDR_FIELD(__name, struct arphdr, __member)
+	HDR_FIELD(__name, struct arp_hdr, __member)
 
 const struct proto_desc proto_arp = {
 	.name		= "arp",
 	.base		= PROTO_BASE_NETWORK_HDR,
 	.templates	= {
-		[ARPHDR_HRD]		= ARPHDR_FIELD("htype",	ar_hrd),
-		[ARPHDR_PRO]		= ARPHDR_TYPE("ptype", &ethertype_type, ar_pro),
-		[ARPHDR_HLN]		= ARPHDR_FIELD("hlen", ar_hln),
-		[ARPHDR_PLN]		= ARPHDR_FIELD("plen", ar_pln),
-		[ARPHDR_OP]		= ARPHDR_TYPE("operation", &arpop_type, ar_op),
+		[ARPHDR_HRD]		= ARPHDR_FIELD("htype",	htype),
+		[ARPHDR_PRO]		= ARPHDR_TYPE("ptype", &ethertype_type, ptype),
+		[ARPHDR_HLN]		= ARPHDR_FIELD("hlen", hlen),
+		[ARPHDR_PLN]		= ARPHDR_FIELD("plen", plen),
+		[ARPHDR_OP]		= ARPHDR_TYPE("operation", &arpop_type, oper),
+		[ARPHDR_SADDR_ETHER]	= ARPHDR_TYPE("saddr ether", &etheraddr_type, sha),
+		[ARPHDR_DADDR_ETHER]	= ARPHDR_TYPE("daddr ether", &etheraddr_type, tha),
+		[ARPHDR_SADDR_IP]	= ARPHDR_TYPE("saddr ip", &ipaddr_type, spa),
+		[ARPHDR_DADDR_IP]	= ARPHDR_TYPE("daddr ip", &ipaddr_type, tpa),
 	},
 	.format		= {
 		.filter	= (1 << ARPHDR_HRD) | (1 << ARPHDR_PRO) |
-			  (1 << ARPHDR_HLN) | (1 << ARPHDR_PLN),
+			  (1 << ARPHDR_HLN) | (1 << ARPHDR_PLN) |
+			  (1 << ARPHDR_SADDR_ETHER) | (1 << ARPHDR_DADDR_ETHER) |
+			  (1 << ARPHDR_SADDR_IP) | (1 << ARPHDR_DADDR_IP),
 	},
 };
 
diff --git a/tests/py/arp/arp.t b/tests/py/arp/arp.t
index d62cc546f24d..86bab5232eaf 100644
--- a/tests/py/arp/arp.t
+++ b/tests/py/arp/arp.t
@@ -55,4 +55,9 @@ arp operation != inreply;ok
 arp operation != nak;ok
 arp operation != reply;ok
 
-meta iifname "invalid" arp ptype 0x0800 arp htype 1 arp hlen 6 arp plen 4 @nh,192,32 0xc0a88f10 @nh,144,48 set 0x112233445566;ok;iifname "invalid" arp htype 1 arp ptype ip arp hlen 6 arp plen 4 @nh,192,32 3232272144 @nh,144,48 set 18838586676582
+arp saddr ip 1.2.3.4;ok
+arp daddr ip 4.3.2.1;ok
+arp saddr ether aa:bb:cc:aa:bb:cc;ok
+arp daddr ether aa:bb:cc:aa:bb:cc;ok
+
+meta iifname "invalid" arp ptype 0x0800 arp htype 1 arp hlen 6 arp plen 4 @nh,192,32 0xc0a88f10 @nh,144,48 set 0x112233445566;ok;iifname "invalid" arp htype 1 arp ptype ip arp hlen 6 arp plen 4 arp daddr ip 192.168.143.16 arp daddr ether set 11:22:33:44:55:66
diff --git a/tests/py/arp/arp.t.payload b/tests/py/arp/arp.t.payload
index 33e7341716d1..d36bef183396 100644
--- a/tests/py/arp/arp.t.payload
+++ b/tests/py/arp/arp.t.payload
@@ -280,3 +280,24 @@ arp test-arp input
   [ cmp eq reg 1 0x108fa8c0 ]
   [ immediate reg 1 0x44332211 0x00006655 ]
   [ payload write reg 1 => 6b @ network header + 18 csum_type 0 csum_off 0 csum_flags 0x0 ]
+
+# arp saddr ip 1.2.3.4
+arp test-arp input 
+  [ payload load 4b @ network header + 14 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+
+# arp daddr ip 4.3.2.1
+arp test-arp input 
+  [ payload load 4b @ network header + 24 => reg 1 ]
+  [ cmp eq reg 1 0x01020304 ]
+
+# arp saddr ether aa:bb:cc:aa:bb:cc
+arp test-arp input 
+  [ payload load 6b @ network header + 8 => reg 1 ]
+  [ cmp eq reg 1 0xaaccbbaa 0x0000ccbb ]
+
+# arp daddr ether aa:bb:cc:aa:bb:cc
+arp test-arp input 
+  [ payload load 6b @ network header + 18 => reg 1 ]
+  [ cmp eq reg 1 0xaaccbbaa 0x0000ccbb ]
+
diff --git a/tests/py/arp/arp.t.payload.netdev b/tests/py/arp/arp.t.payload.netdev
index 4fcf35049de2..0146cf500ee2 100644
--- a/tests/py/arp/arp.t.payload.netdev
+++ b/tests/py/arp/arp.t.payload.netdev
@@ -373,3 +373,31 @@ netdev test-netdev ingress
   [ immediate reg 1 0x44332211 0x00006655 ]
   [ payload write reg 1 => 6b @ network header + 18 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
+# arp saddr ip 1.2.3.4
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 4b @ network header + 14 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+
+# arp daddr ip 4.3.2.1
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 4b @ network header + 24 => reg 1 ]
+  [ cmp eq reg 1 0x01020304 ]
+
+# arp saddr ether aa:bb:cc:aa:bb:cc
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 6b @ network header + 8 => reg 1 ]
+  [ cmp eq reg 1 0xaaccbbaa 0x0000ccbb ]
+
+# arp daddr ether aa:bb:cc:aa:bb:cc
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 6b @ network header + 18 => reg 1 ]
+  [ cmp eq reg 1 0xaaccbbaa 0x0000ccbb ]
+
-- 
2.11.0


