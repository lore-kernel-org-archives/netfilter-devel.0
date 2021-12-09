Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D3AC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 15:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbhLIPPX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 10:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239443AbhLIPPV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 10:15:21 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA68C061B38
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Dec 2021 07:11:48 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mvL5G-000784-PB; Thu, 09 Dec 2021 16:11:46 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] src: propagate key datatype for anonymous sets
Date:   Thu,  9 Dec 2021 16:11:31 +0100
Message-Id: <20211209151131.22618-3-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211209151131.22618-1-fw@strlen.de>
References: <20211209151131.22618-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

set s10 {
  typeof tcp option mptcp subtype
  elements = { mp-join, dss }
}

is listed correctly: typeof provides the 'mptcpopt_subtype'
datatype, so listing will print the elements with their sybolic types.

In anon case this doesn't work:
tcp option mptcp subtype { mp-join, dss }

gets shown as 'tcp option mptcp subtype { 1,  2}' because the anon
set has integer type.

This change propagates the datatype to the individual members
of the anon set.

After this change, multiple existing data types such as
TYPE_ICMP_TYPE could be replaced by integer-type aliases, but those
data types are already exposed to userspace via the 'set type'
directive so doing this may break existing set definitions.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expression.c              | 34 ++++++++++++++++++++++++++++++++++
 tests/py/any/tcpopt.t         |  2 +-
 tests/py/any/tcpopt.t.payload | 10 +++++-----
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index f1cca8845376..9de70c6cc1a4 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1249,6 +1249,31 @@ static void set_ref_expr_destroy(struct expr *expr)
 	set_free(expr->set);
 }
 
+static void set_ref_expr_set_type(const struct expr *expr,
+				  const struct datatype *dtype,
+				  enum byteorder byteorder)
+{
+	const struct set *s = expr->set;
+
+	/* normal sets already have a precise datatype that is given in
+	 * the set definition via type foo.
+	 *
+	 * Anon sets do not have this, and need to rely on type info
+	 * generated at rule creation time.
+	 *
+	 * For most cases, the type info is correct.
+	 * In some cases however, the kernel only stores TYPE_INTEGER.
+	 *
+	 * This happens with expressions that only use an integer alias
+	 * type, such as mptcp_suboption.
+	 *
+	 * In this case nft would print '1', '2', etc. instead of symbolic
+	 * names because the base type lacks ->sym_tbl information.
+	 */
+	if (s->init && set_is_anonymous(s->flags))
+		expr_set_type(s->init, dtype, byteorder);
+}
+
 static const struct expr_ops set_ref_expr_ops = {
 	.type		= EXPR_SET_REF,
 	.name		= "set reference",
@@ -1256,6 +1281,7 @@ static const struct expr_ops set_ref_expr_ops = {
 	.json		= set_ref_expr_json,
 	.clone		= set_ref_expr_clone,
 	.destroy	= set_ref_expr_destroy,
+	.set_type	= set_ref_expr_set_type,
 };
 
 struct expr *set_ref_expr_alloc(const struct location *loc, struct set *set)
@@ -1310,6 +1336,13 @@ static void set_elem_expr_clone(struct expr *new, const struct expr *expr)
 	init_list_head(&new->stmt_list);
 }
 
+static void set_elem_expr_set_type(const struct expr *expr,
+				   const struct datatype *dtype,
+				   enum byteorder byteorder)
+{
+       expr_set_type(expr->key, dtype, byteorder);
+}
+
 static const struct expr_ops set_elem_expr_ops = {
 	.type		= EXPR_SET_ELEM,
 	.name		= "set element",
@@ -1317,6 +1350,7 @@ static const struct expr_ops set_elem_expr_ops = {
 	.print		= set_elem_expr_print,
 	.json		= set_elem_expr_json,
 	.destroy	= set_elem_expr_destroy,
+	.set_type	= set_elem_expr_set_type,
 };
 
 struct expr *set_elem_expr_alloc(const struct location *loc, struct expr *key)
diff --git a/tests/py/any/tcpopt.t b/tests/py/any/tcpopt.t
index a5ac1e86e207..f57532c3016d 100644
--- a/tests/py/any/tcpopt.t
+++ b/tests/py/any/tcpopt.t
@@ -53,4 +53,4 @@ tcp option mptcp exists;ok
 
 tcp option mptcp subtype mp-capable;ok
 tcp option mptcp subtype 1;ok;tcp option mptcp subtype mp-join
-tcp option mptcp subtype { 0, 2};ok
+tcp option mptcp subtype { mp-capable, mp-join, remove-addr, mp-prio, mp-fail, mp-fastclose, mp-tcprst };ok
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
index 269dee0aedb6..5a3102f9b459 100644
--- a/tests/py/any/tcpopt.t.payload
+++ b/tests/py/any/tcpopt.t.payload
@@ -180,11 +180,11 @@ inet
   [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000010 ]
 
-# tcp option mptcp subtype { 0, 2}
-__set%d test-inet 3 size 2
-__set%d test-inet 0
-	element 00000000  : 0 [end]	element 00000020  : 0 [end]
-inet
+# tcp option mptcp subtype { mp-capable, mp-join, remove-addr, mp-prio, mp-fail, mp-fastclose, mp-tcprst }
+__set%d test-ip4 3 size 7
+__set%d test-ip4 0
+	element 00000000  : 0 [end]	element 00000010  : 0 [end]	element 00000040  : 0 [end]	element 00000050  : 0 [end]	element 00000060  : 0 [end]	element 00000070  : 0 [end]	element 00000080  : 0 [end]
+ip test-ip4 input
   [ exthdr load tcpopt 1b @ 30 + 2 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
-- 
2.32.0

