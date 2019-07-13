Return-Path: <SRS0=nOV7=VK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93D6C31E40
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jul 2019 17:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CC2220838
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jul 2019 17:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbfGMRXg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Jul 2019 13:23:36 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45072 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727853AbfGMRXf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Jul 2019 13:23:35 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hmLkC-0003vr-Gd; Sat, 13 Jul 2019 19:23:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] proto: add pseudo th protocol to match d/sport in generic way
Date:   Sat, 13 Jul 2019 19:23:27 +0200
Message-Id: <20190713172327.13928-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Problem: Its not possible to easily match both udp and tcp in a single
rule.

... input ip protocol { tcp,udp } dport 53

will not work, as bison expects "tcp dport" or "sctp dport", or any
other transport protocol name.

Its possible to match the sport and dport via raw payload expressions,
e.g.:
... input ip protocol { tcp,udp } @th,16,16 53

but its not very readable.
Furthermore, its not possible to use this for set definitions:

table inet filter {
        set myset {
                type ipv4_addr . inet_proto . inet_service
        }

        chain forward {
                type filter hook forward priority filter; policy accept;
                ip daddr . ip protocol . @th,0,16 @myset
        }
}
 # nft -f test
 test:7:26-35: Error: can not use variable sized data types (integer) in concat expressions

During the netfilter workshop Pablo suggested to add an alias to do raw
sport/dport matching more readable, and make it use the inet_service
type automatically.

So, this change makes @th,0,16 work for the set definition case by
setting the data type to inet_service.

A new "th s|dport" syntax is provided as readable alternative:

ip protocol { tcp, udp } th dport 53

As "th" is an alias for the raw expression, no dependency is
generated -- its the users responsibility to add a suitable test to
select the l4 header types that should be matched.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/payload-expression.txt                    |  9 ++++++++
 include/proto.h                               |  7 ++++++
 src/parser_bison.y                            | 16 +++++++++++++
 src/payload.c                                 | 23 +++++++++++++++++++
 src/proto.c                                   | 12 ++++++++++
 tests/py/any/rawpayload.t                     |  2 +-
 .../sets/0037_set_with_inet_service_0         |  6 +++++
 .../dumps/0037_set_with_inet_service_0.nft    | 16 +++++++++++++
 8 files changed, 90 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/sets/0037_set_with_inet_service_0
 create mode 100644 tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.nft

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index b98a60772027..dba42fd542cf 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -498,6 +498,15 @@ Transport Header, for example TCP
 ----------------------------------------------
 inet filter input meta l4proto {tcp, udp} @th,16,16 { 53, 80 }
 -----------------------------------------------------------------
+The above can also be written as
+-----------------------------------------------------------------
+inet filter input meta l4proto {tcp, udp} th dport { 53, 80 }
+-----------------------------------------------------------------
+it is more convenient, but like the raw expression notation no
+dependencies are created or checked. It is the users responsibility
+to restrict matching to those header types that have a notion of ports.
+Otherwise, rules using raw expressions will errnously match unrelated
+packets, e.g. mis-interpreting ESP packets SPI field as a port.
 
 .Rewrite arp packet target hardware address if target protocol address matches a given address
 ----------------------------------------------------------------------------------------------
diff --git a/include/proto.h b/include/proto.h
index 92b25edbd3da..fab48c1bb30c 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -310,6 +310,12 @@ enum sctp_hdr_fields {
 	SCTPHDR_CHECKSUM,
 };
 
+enum th_hdr_fields {
+	THDR_INVALID,
+	THDR_SPORT,
+	THDR_DPORT,
+};
+
 extern const struct proto_desc proto_icmp;
 extern const struct proto_desc proto_igmp;
 extern const struct proto_desc proto_ah;
@@ -320,6 +326,7 @@ extern const struct proto_desc proto_udplite;
 extern const struct proto_desc proto_tcp;
 extern const struct proto_desc proto_dccp;
 extern const struct proto_desc proto_sctp;
+extern const struct proto_desc proto_th;
 extern const struct proto_desc proto_icmp6;
 
 extern const struct proto_desc proto_ip;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index a4905f2a39ae..0a387f619998 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -719,6 +719,9 @@ int nft_lex(void *, void *, void *);
 %type <expr>			dccp_hdr_expr	sctp_hdr_expr
 %destructor { expr_free($$); }	dccp_hdr_expr	sctp_hdr_expr
 %type <val>			dccp_hdr_field	sctp_hdr_field
+%type <expr>			th_hdr_expr
+%destructor { expr_free($$); }	th_hdr_expr
+%type <val>			th_hdr_field
 
 %type <expr>			exthdr_expr
 %destructor { expr_free($$); }	exthdr_expr
@@ -4198,6 +4201,7 @@ payload_expr		:	payload_raw_expr
 			|	tcp_hdr_expr
 			|	dccp_hdr_expr
 			|	sctp_hdr_expr
+			|	th_hdr_expr
 			;
 
 payload_raw_expr	:	AT	payload_base_spec	COMMA	NUM	COMMA	NUM
@@ -4487,6 +4491,18 @@ sctp_hdr_field		:	SPORT		{ $$ = SCTPHDR_SPORT; }
 			|	CHECKSUM	{ $$ = SCTPHDR_CHECKSUM; }
 			;
 
+th_hdr_expr		:	TRANSPORT_HDR 	th_hdr_field
+			{
+				$$ = payload_expr_alloc(&@$, &proto_th, $2);
+				if ($$)
+					$$->payload.is_raw = true;
+			}
+			;
+
+th_hdr_field		:	SPORT		{ $$ = THDR_SPORT; }
+			|	DPORT		{ $$ = THDR_DPORT; }
+			;
+
 exthdr_expr		:	hbh_hdr_expr
 			|	rt_hdr_expr
 			|	rt0_hdr_expr
diff --git a/src/payload.c b/src/payload.c
index 3bf1ecc75c40..abd5339c5b0b 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -172,10 +172,33 @@ struct expr *payload_expr_alloc(const struct location *loc,
 void payload_init_raw(struct expr *expr, enum proto_bases base,
 		      unsigned int offset, unsigned int len)
 {
+	enum th_hdr_fields thf;
+
 	expr->payload.base	= base;
 	expr->payload.offset	= offset;
 	expr->len		= len;
 	expr->dtype		= &integer_type;
+
+	if (base != PROTO_BASE_TRANSPORT_HDR)
+		return;
+	if (len != 16)
+		return;
+
+	switch (offset) {
+	case 0:
+		thf = THDR_SPORT;
+		/* fall through */
+	case 16:
+		if (offset == 16)
+			thf = THDR_DPORT;
+		expr->payload.tmpl = &proto_th.templates[thf];
+		expr->payload.desc = &proto_th;
+		expr->dtype = &inet_service_type;
+		expr->payload.desc = &proto_th;
+		break;
+	default:
+		break;
+	}
 }
 
 unsigned int payload_hdr_field(const struct expr *expr)
diff --git a/src/proto.c b/src/proto.c
index 67e86f2070c1..40ce590efd12 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -561,6 +561,18 @@ const struct proto_desc proto_sctp = {
 	},
 };
 
+/*
+ * Dummy Transpor Header (common udp/tcp/dccp/sctp fields)
+ */
+const struct proto_desc proto_th = {
+	.name		= "th",
+	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.templates	= {
+		[THDR_SPORT]		= INET_SERVICE("sport", struct udphdr, source),
+		[THDR_DPORT]		= INET_SERVICE("dport", struct udphdr, dest),
+	},
+};
+
 /*
  * IPv4
  */
diff --git a/tests/py/any/rawpayload.t b/tests/py/any/rawpayload.t
index 9a3402f1a406..c3382a96876c 100644
--- a/tests/py/any/rawpayload.t
+++ b/tests/py/any/rawpayload.t
@@ -4,7 +4,7 @@
 *inet;test-inet;input
 *netdev;test-netdev;ingress
 
-meta l4proto { tcp, udp, sctp} @th,16,16 { 22, 23, 80 };ok;meta l4proto { 6, 17, 132} @th,16,16 { 22, 23, 80}
+meta l4proto { tcp, udp, sctp} @th,16,16 { 22, 23, 80 };ok;meta l4proto { 6, 17, 132} th dport { 22, 23, 80}
 meta l4proto tcp @th,16,16 { 22, 23, 80};ok;tcp dport { 22, 23, 80}
 @nh,8,8 255;ok
 @nh,8,16 0;ok
diff --git a/tests/shell/testcases/sets/0037_set_with_inet_service_0 b/tests/shell/testcases/sets/0037_set_with_inet_service_0
new file mode 100755
index 000000000000..07820b7c4fdd
--- /dev/null
+++ b/tests/shell/testcases/sets/0037_set_with_inet_service_0
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+set -e
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+
+$NFT -f "$dumpfile"
diff --git a/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.nft b/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.nft
new file mode 100644
index 000000000000..0e85f7c20eba
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.nft
@@ -0,0 +1,16 @@
+table inet filter {
+	set myset {
+		type ipv4_addr . inet_proto . inet_service
+		elements = { 192.168.0.12 . tcp . 53,
+			     192.168.0.12 . tcp . 80,
+			     192.168.0.12 . udp . 53,
+			     192.168.0.13 . tcp . 80,
+			     192.168.0.113 . tcp . 22 }
+	}
+
+	chain forward {
+		type filter hook forward priority filter; policy drop;
+		ct state established,related accept
+		ct state new ip daddr . ip protocol . th dport @myset accept
+	}
+}
-- 
2.21.0

