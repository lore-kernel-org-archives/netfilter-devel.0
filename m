From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/6] nft: swap key and direction in ct_dir syntax
Date: Fri,  8 Jan 2016 10:42:47 +0100
Message-ID: <1452246171-13943-3-git-send-email-fw@strlen.de>
References: <1452246171-13943-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47936 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752241AbcAHJuh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 04:50:37 -0500
In-Reply-To: <1452246171-13943-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

old: ct saddr original 1.2.3.4
new: ct original saddr 1.2.3.4

The advantage is that this allows to add ct keys where direction is optional
without creating ambiguities in the parser.

So we can have
ct packets gt 42
ct original packets gt 42

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/ct.c                 | 13 ++++++-------
 src/parser_bison.y       |  6 +++---
 tests/py/any/ct.t        |  8 ++++++++
 tests/py/ip/ct.t         | 26 +++++++++++++-------------
 tests/py/ip/ct.t.payload | 22 +++++++++++-----------
 5 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index 515e3eb..ff6cd61 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -209,19 +209,18 @@ static void ct_expr_print(const struct expr *expr)
 {
 	const struct symbolic_constant *s;
 
-	printf("ct %s", ct_templates[expr->ct.key].token);
-
+	printf("ct ");
 	if (expr->ct.direction < 0)
-		return;
+		goto done;
 
 	for (s = ct_dir_tbl.symbols; s->identifier != NULL; s++) {
 		if (expr->ct.direction == (int) s->value) {
-			printf(" %s", s->identifier);
-			return;
+			printf("%s ", s->identifier);
+			break;
 		}
 	}
-
-	printf(" %d", expr->ct.direction);
+ done:
+	printf("%s", ct_templates[expr->ct.key].token);
 }
 
 static bool ct_expr_cmp(const struct expr *e1, const struct expr *e2)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fcd4813..0ba6f7c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2268,18 +2268,18 @@ ct_expr			: 	CT	ct_key
 			{
 				$$ = ct_expr_alloc(&@$, $2, -1);
 			}
-			|	CT	ct_key_dir 	STRING
+			|	CT	STRING	ct_key_dir
 			{
 				struct error_record *erec;
 				int8_t direction;
 
-				erec = ct_dir_parse(&@$, $3, &direction);
+				erec = ct_dir_parse(&@$, $2, &direction);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
 				}
 
-				$$ = ct_expr_alloc(&@$, $2, direction);
+				$$ = ct_expr_alloc(&@$, $3, direction);
 			}
 			;
 
diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index d402252..a0a2590 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -109,3 +109,11 @@ ct state . ct mark { new . 0x12345678};ok
 ct state . ct mark { new . 0x12345678, new . 0x34127856, established . 0x12785634};ok
 ct direction . ct mark { original . 0x12345678};ok
 ct state . ct mark vmap { new . 0x12345678 : drop};ok
+
+# missing direction
+ct saddr 1.2.3.4;fail
+
+# direction, but must be used without
+ct original mark 42;fail
+# swapped key and direction
+ct mark original;fail
diff --git a/tests/py/ip/ct.t b/tests/py/ip/ct.t
index 28ad766..042f94e 100644
--- a/tests/py/ip/ct.t
+++ b/tests/py/ip/ct.t
@@ -2,22 +2,22 @@
 
 :output;type filter hook output priority 0
 
-ct saddr original 192.168.0.1;ok
-ct saddr reply 192.168.0.1;ok
-ct daddr original 192.168.0.1;ok
-ct daddr reply 192.168.0.1;ok
+ct original saddr 192.168.0.1;ok
+ct reply saddr 192.168.0.1;ok
+ct original daddr 192.168.0.1;ok
+ct reply daddr 192.168.0.1;ok
 
 # same, but with a netmask
-ct saddr original 192.168.1.0/24;ok
-ct saddr reply 192.168.1.0/24;ok
-ct daddr original 192.168.1.0/24;ok
-ct daddr reply 192.168.1.0/24;ok
+ct original saddr 192.168.1.0/24;ok
+ct reply saddr 192.168.1.0/24;ok
+ct original daddr 192.168.1.0/24;ok
+ct reply daddr 192.168.1.0/24;ok
 
-ct l3proto original ipv4;ok
-ct l3proto reply foobar;fail
+ct original l3proto ipv4;ok
+ct reply l3proto foobar;fail
 
-ct protocol original 6 ct proto-dst original 22;ok
-ct protocol original 17 ct proto-src reply 53;ok
+ct original protocol 6 ct original proto-dst 22;ok
+ct original protocol 17 ct reply proto-src 53;ok
 
 # wrong address family
-ct daddr reply dead::beef;fail
+ct reply daddr dead::beef;fail
diff --git a/tests/py/ip/ct.t.payload b/tests/py/ip/ct.t.payload
index e06d988..0449b07 100644
--- a/tests/py/ip/ct.t.payload
+++ b/tests/py/ip/ct.t.payload
@@ -1,60 +1,60 @@
-# ct saddr original 192.168.0.1
+# ct original saddr 192.168.0.1
 ip test-ip4 output
   [ ct load src => reg 1 , dir original ]
   [ cmp eq reg 1 0x0100a8c0 ]
 
-# ct saddr reply 192.168.0.1
+# ct reply saddr 192.168.0.1
 ip test-ip4 output
   [ ct load src => reg 1 , dir reply ]
   [ cmp eq reg 1 0x0100a8c0 ]
 
-# ct daddr original 192.168.0.1
+# ct original daddr 192.168.0.1
 ip test-ip4 output
   [ ct load dst => reg 1 , dir original ]
   [ cmp eq reg 1 0x0100a8c0 ]
 
-# ct daddr reply 192.168.0.1
+# ct reply daddr 192.168.0.1
 ip test-ip4 output
   [ ct load dst => reg 1 , dir reply ]
   [ cmp eq reg 1 0x0100a8c0 ]
 
-# ct saddr original 192.168.1.0/24
+# ct original saddr 192.168.1.0/24
 ip test-ip4 output
   [ ct load src => reg 1 , dir original ]
   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0001a8c0 ]
 
-# ct saddr reply 192.168.1.0/24
+# ct reply saddr 192.168.1.0/24
 ip test-ip4 output
   [ ct load src => reg 1 , dir reply ]
   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0001a8c0 ]
 
-# ct daddr original 192.168.1.0/24
+# ct original daddr 192.168.1.0/24
 ip test-ip4 output
   [ ct load dst => reg 1 , dir original ]
   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0001a8c0 ]
 
-# ct daddr reply 192.168.1.0/24
+# ct reply daddr 192.168.1.0/24
 ip test-ip4 output
   [ ct load dst => reg 1 , dir reply ]
   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0001a8c0 ]
 
-# ct l3proto original ipv4
+# ct original l3proto ipv4
 ip test-ip4 output
   [ ct load l3protocol => reg 1 , dir original ]
   [ cmp eq reg 1 0x00000002 ]
 
-# ct protocol original 6 ct proto-dst original 22
+# ct original protocol 6 ct original proto-dst 22
 ip test-ip4 output
   [ ct load protocol => reg 1 , dir original ]
   [ cmp eq reg 1 0x00000006 ]
   [ ct load proto_dst => reg 1 , dir original ]
   [ cmp eq reg 1 0x00001600 ]
 
-# ct protocol original 17 ct proto-src reply 53
+# ct original protocol 17 ct reply proto-src 53
 ip test-ip4 output
   [ ct load protocol => reg 1 , dir original ]
   [ cmp eq reg 1 0x00000011 ]
-- 
2.4.10

