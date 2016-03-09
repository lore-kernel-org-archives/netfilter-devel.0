From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] parser_bison: allow 'snat' and 'dnat' keywords from the right-hand side
Date: Wed,  9 Mar 2016 12:35:11 +0100
Message-ID: <1457523311-19512-1-git-send-email-pablo@netfilter.org>
Cc: karol@babioch.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38079 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbcCILf1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2016 06:35:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C7699843E
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Mar 2016 12:35:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9AA05DA8FB
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Mar 2016 12:35:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E19EEDA8F8
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Mar 2016 12:35:15 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Parse 'snat' and 'dnat' reserved keywords from the right-hand side as
symbols. Thus, we can use them as values from ct status.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=950
Reported-by: Ana Rey <anarey@gmail.com>
Reported-by: Karol Babioch <karol@babioch.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y        | 12 ++++++++++++
 tests/py/any/ct.t         |  8 +++-----
 tests/py/any/ct.t.payload | 19 +++++++++++++++++++
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3f22639..90978ab 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2196,6 +2196,18 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
+			|	SNAT
+			{
+				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
+						       current_scope(state),
+						       "snat");
+			}
+			|	DNAT
+			{
+				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
+						       current_scope(state),
+						       "dnat");
+			}
 			;
 
 relational_op		:	EQ		{ $$ = OP_EQ; }
diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 6896b1f..095e86c 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -26,13 +26,11 @@ ct status != expected;ok
 ct status seen-reply;ok
 ct status != seen-reply;ok
 ct status {expected, seen-reply, assured, confirmed, dying};ok
+ct status expected,seen-reply,assured,confirmed,snat,dnat,dying;ok
+ct status snat;ok
+ct status dnat;ok
 ct status xxx;fail
 
-# SYMBOL("snat", IPS_SRC_NAT)
-# SYMBOL("dnat", IPS_DST_NAT)
-- ct status snat;ok
-- ct status dnat;ok
-
 ct mark 0;ok;ct mark 0x00000000
 ct mark or 0x23 == 0x11;ok;ct mark | 0x00000023 == 0x00000011
 ct mark or 0x3 != 0x1;ok;ct mark | 0x00000003 != 0x00000001
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index ac99429..62e9259 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -304,3 +304,22 @@ ip test-ip4 output
   [ ct load bytes => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 8, 8) ]
   [ cmp gt reg 1 0x00000000 0xa0860100 ]
+
+# ct status expected,seen-reply,assured,confirmed,snat,dnat,dying
+ip test-ip4 output
+  [ ct load status => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000023f ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
+# ct status snat
+ip test-ip4 output
+  [ ct load status => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
+# ct status dnat
+ip test-ip4 output
+  [ ct load status => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000020 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
-- 
2.1.4

