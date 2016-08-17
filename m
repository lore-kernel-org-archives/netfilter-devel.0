From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 10/10] parser_bison: redirect to :port for consistency with nat/masq statement
Date: Wed, 17 Aug 2016 15:30:01 +0200
Message-ID: <1471440601-5327-11-git-send-email-pablo@netfilter.org>
References: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44036 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbcHQNaQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 09:30:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6AD28E9777
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 52EC0FF2D5
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E0997DA7FE
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:12 +0200 (CEST)
In-Reply-To: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use the colon port syntax for consistency with other statements.
Existing syntax is still preserved but the output displays the colon.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y                  |  9 +++++++++
 tests/py/ip/redirect.t              | 24 ++++++++++++------------
 tests/py/ip/redirect.t.payload      | 20 ++++++++++----------
 tests/py/ip6/redirect.t             | 18 +++++++++---------
 tests/py/ip6/redirect.t.payload.ip6 | 14 +++++++-------
 5 files changed, 47 insertions(+), 38 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index f4ce11d..8025415 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1701,6 +1701,10 @@ redir_stmt_arg		:	TO	stmt_expr
 			{
 				$<stmt>0->redir.proto = $2;
 			}
+			|	TO	COLON	stmt_expr
+			{
+				$<stmt>0->redir.proto = $3;
+			}
 			|	nf_nat_flags
 			{
 				$<stmt>0->redir.flags = $1;
@@ -1710,6 +1714,11 @@ redir_stmt_arg		:	TO	stmt_expr
 				$<stmt>0->redir.proto = $2;
 				$<stmt>0->redir.flags = $3;
 			}
+			|	TO	COLON	stmt_expr	nf_nat_flags
+			{
+				$<stmt>0->redir.proto = $3;
+				$<stmt>0->redir.flags = $4;
+			}
 			;
 
 dup_stmt		:	DUP	TO	stmt_expr
diff --git a/tests/py/ip/redirect.t b/tests/py/ip/redirect.t
index 7e205a9..f6ddfc0 100644
--- a/tests/py/ip/redirect.t
+++ b/tests/py/ip/redirect.t
@@ -18,19 +18,19 @@ udp dport 53 redirect persistent,fully-random;ok;udp dport 53 redirect fully-ran
 udp dport 53 redirect persistent,fully-random,random;ok;udp dport 53 redirect random,fully-random,persistent
 
 # port specification
-tcp dport 22 redirect to 22;ok
-udp dport 1234 redirect to 4321;ok
-ip daddr 172.16.0.1 udp dport 9998 redirect to 6515;ok
-tcp dport 39128 redirect to 993;ok
-ip protocol tcp redirect to 100-200;ok;ip protocol 6 redirect to 100-200
-redirect to 1234;fail
-redirect to 12341111;fail
+tcp dport 22 redirect to :22;ok
+udp dport 1234 redirect to :4321;ok
+ip daddr 172.16.0.1 udp dport 9998 redirect to :6515;ok
+tcp dport 39128 redirect to :993;ok
+ip protocol tcp redirect to :100-200;ok;ip protocol 6 redirect to :100-200
+redirect to :1234;fail
+redirect to :12341111;fail
 
 # both port and nf_nat flags
-tcp dport 9128 redirect to 993 random;ok
-tcp dport 9128 redirect to 993 fully-random;ok
-tcp dport 9128 redirect to 123 persistent;ok
-tcp dport 9128 redirect to 123 random,persistent;ok
+tcp dport 9128 redirect to :993 random;ok
+tcp dport 9128 redirect to :993 fully-random;ok
+tcp dport 9128 redirect to :123 persistent;ok
+tcp dport 9128 redirect to :123 random,persistent;ok
 
 # nf_nat flags is the last argument
 udp dport 1234 redirect random to 123;fail
@@ -47,5 +47,5 @@ ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter packets 0 bytes 0 redirect;ok
 iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } redirect;ok
 
 # redirect with maps
-ip protocol 6 redirect to tcp dport map { 22 : 8000, 80 : 8080};ok
+ip protocol 6 redirect to : tcp dport map { 22 : 8000, 80 : 8080};ok
 
diff --git a/tests/py/ip/redirect.t.payload b/tests/py/ip/redirect.t.payload
index e02a26d..dfb5a3b 100644
--- a/tests/py/ip/redirect.t.payload
+++ b/tests/py/ip/redirect.t.payload
@@ -86,7 +86,7 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00003500 ]
   [ redir flags 0x1c ]
 
-# tcp dport 22 redirect to 22
+# tcp dport 22 redirect to :22
 ip test-ip4 output
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -95,7 +95,7 @@ ip test-ip4 output
   [ immediate reg 1 0x00001600 ]
   [ redir proto_min reg 1 ]
 
-# udp dport 1234 redirect to 4321
+# udp dport 1234 redirect to :4321
 ip test-ip4 output
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
@@ -104,7 +104,7 @@ ip test-ip4 output
   [ immediate reg 1 0x0000e110 ]
   [ redir proto_min reg 1 ]
 
-# ip daddr 172.16.0.1 udp dport 9998 redirect to 6515
+# ip daddr 172.16.0.1 udp dport 9998 redirect to :6515
 ip test-ip4 output
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp eq reg 1 0x010010ac ]
@@ -115,7 +115,7 @@ ip test-ip4 output
   [ immediate reg 1 0x00007319 ]
   [ redir proto_min reg 1 ]
 
-# tcp dport 39128 redirect to 993
+# tcp dport 39128 redirect to :993
 ip test-ip4 output
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -124,7 +124,7 @@ ip test-ip4 output
   [ immediate reg 1 0x0000e103 ]
   [ redir proto_min reg 1 ]
 
-# ip protocol tcp redirect to 100-200
+# ip protocol tcp redirect to :100-200
 ip test-ip4 output
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -132,7 +132,7 @@ ip test-ip4 output
   [ immediate reg 2 0x0000c800 ]
   [ redir proto_min reg 1 proto_max reg 2 ]
 
-# tcp dport 9128 redirect to 993 random
+# tcp dport 9128 redirect to :993 random
 ip test-ip4 output
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -141,7 +141,7 @@ ip test-ip4 output
   [ immediate reg 1 0x0000e103 ]
   [ redir proto_min reg 1 flags 0x4 ]
 
-# tcp dport 9128 redirect to 993 fully-random
+# tcp dport 9128 redirect to :993 fully-random
 ip test-ip4 output
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -150,7 +150,7 @@ ip test-ip4 output
   [ immediate reg 1 0x0000e103 ]
   [ redir proto_min reg 1 flags 0x10 ]
 
-# tcp dport 9128 redirect to 123 persistent
+# tcp dport 9128 redirect to :123 persistent
 ip test-ip4 output
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -159,7 +159,7 @@ ip test-ip4 output
   [ immediate reg 1 0x00007b00 ]
   [ redir proto_min reg 1 flags 0x8 ]
 
-# tcp dport 9128 redirect to 123 random,persistent
+# tcp dport 9128 redirect to :123 random,persistent
 ip test-ip4 output
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -207,7 +207,7 @@ ip test-ip4 output
   [ lookup reg 1 set __map%d dreg 0 ]
   [ redir ]
 
-# ip protocol 6 redirect to tcp dport map { 22 : 8000, 80 : 8080}
+# ip protocol 6 redirect to : tcp dport map { 22 : 8000, 80 : 8080}
 __map%d test-ip4 b
 __map%d test-ip4 0
         element 00001600  : 0000401f 0 [end]    element 00005000  : 0000901f 0 [end]
diff --git a/tests/py/ip6/redirect.t b/tests/py/ip6/redirect.t
index fca84e5..c5d939c 100644
--- a/tests/py/ip6/redirect.t
+++ b/tests/py/ip6/redirect.t
@@ -20,16 +20,16 @@ udp dport 53 redirect persistent,fully-random;ok;udp dport 53 redirect fully-ran
 udp dport 53 redirect persistent,fully-random,random;ok;udp dport 53 redirect random,fully-random,persistent
 
 # port specification
-udp dport 1234 redirect to 1234;ok
-ip6 daddr fe00::cafe udp dport 9998 redirect to 6515;ok
-ip6 nexthdr tcp redirect to 100-200;ok;ip6 nexthdr 6 redirect to 100-200
-tcp dport 39128 redirect to 993;ok
-redirect to 1234;fail
-redirect to 12341111;fail
+udp dport 1234 redirect to :1234;ok
+ip6 daddr fe00::cafe udp dport 9998 redirect to :6515;ok
+ip6 nexthdr tcp redirect to :100-200;ok;ip6 nexthdr 6 redirect to :100-200
+tcp dport 39128 redirect to :993;ok
+redirect to :1234;fail
+redirect to :12341111;fail
 
 # both port and nf_nat flags
-tcp dport 9128 redirect to 993 random;ok
-tcp dport 9128 redirect to 993 fully-random,persistent;ok
+tcp dport 9128 redirect to :993 random;ok
+tcp dport 9128 redirect to :993 fully-random,persistent;ok
 
 # nf_nat flags are the last argument
 tcp dport 9128 redirect persistent to 123;fail
@@ -46,4 +46,4 @@ ip6 daddr fe00::1-fe00::200 udp dport 53 counter packets 0 bytes 0 redirect;ok
 iifname eth0 ct state new,established tcp dport vmap {22 : drop, 222 : drop } redirect;ok
 
 # redirect with maps
-ip6 nexthdr 6 redirect to tcp dport map { 22 : 8000, 80 : 8080};ok
+ip6 nexthdr 6 redirect to : tcp dport map { 22 : 8000, 80 : 8080};ok
diff --git a/tests/py/ip6/redirect.t.payload.ip6 b/tests/py/ip6/redirect.t.payload.ip6
index 80250ca..420e1f3 100644
--- a/tests/py/ip6/redirect.t.payload.ip6
+++ b/tests/py/ip6/redirect.t.payload.ip6
@@ -97,7 +97,7 @@ ip6 test-ip6 output
   [ cmp eq reg 1 0x00003500 ]
   [ redir flags 0x1c ]
 
-# udp dport 1234 redirect to 1234
+# udp dport 1234 redirect to :1234
 ip6 test-ip6 output
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
@@ -106,7 +106,7 @@ ip6 test-ip6 output
   [ immediate reg 1 0x0000d204 ]
   [ redir proto_min reg 1 ]
 
-# ip6 daddr fe00::cafe udp dport 9998 redirect to 6515
+# ip6 daddr fe00::cafe udp dport 9998 redirect to :6515
 ip6 test-ip6 output
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ cmp eq reg 1 0x000000fe 0x00000000 0x00000000 0xfeca0000 ]
@@ -117,7 +117,7 @@ ip6 test-ip6 output
   [ immediate reg 1 0x00007319 ]
   [ redir proto_min reg 1 ]
 
-# ip6 nexthdr tcp redirect to 100-200
+# ip6 nexthdr tcp redirect to :100-200
 ip6 test-ip6 output
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -125,7 +125,7 @@ ip6 test-ip6 output
   [ immediate reg 2 0x0000c800 ]
   [ redir proto_min reg 1 proto_max reg 2 ]
 
-# tcp dport 39128 redirect to 993
+# tcp dport 39128 redirect to :993
 ip6 test-ip6 output
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -134,7 +134,7 @@ ip6 test-ip6 output
   [ immediate reg 1 0x0000e103 ]
   [ redir proto_min reg 1 ]
 
-# tcp dport 9128 redirect to 993 random
+# tcp dport 9128 redirect to :993 random
 ip6 test-ip6 output
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -143,7 +143,7 @@ ip6 test-ip6 output
   [ immediate reg 1 0x0000e103 ]
   [ redir proto_min reg 1 flags 0x4 ]
 
-# tcp dport 9128 redirect to 993 fully-random,persistent
+# tcp dport 9128 redirect to :993 fully-random,persistent
 ip6 test-ip6 output
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -191,7 +191,7 @@ ip6 test-ip6 output
   [ lookup reg 1 set __map%d dreg 0 ]
   [ redir ]
 
-# ip6 nexthdr 6 redirect to tcp dport map { 22 : 8000, 80 : 8080}
+# ip6 nexthdr 6 redirect to : tcp dport map { 22 : 8000, 80 : 8080}
 __map%d test-ip6 b
 __map%d test-ip6 0
 	element 00001600  : 0000401f 0 [end]	element 00005000  : 0000901f 0 [end]
-- 
2.1.4

