Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A6F25DAFE
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2025 14:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740667976; cv=none; b=kqATGIBNuA757mnTzJNHCSzBLXXERqZ5jtl4Fr926G8VPKi4z4vWL2xPTOHIUPgRVI8drVt0R304v5ADSp+xNhkXVFvsM7NVfiKZ0vuI7N2OkfTm3KGE4Np8LxkzL0DgpDL4W+VVW43OvM+bBKDVZOJ/JREX7tiSLYC7/4RD5U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740667976; c=relaxed/simple;
	bh=Z4n/qDy/bH/tZorbQA7V23bcIeyk996mAb+gKXhE9s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9uDxNFKV96dbWIg3jknRCMjQViuyuznwrUc9f0lQAkMK/NJr2i90Pbny4THL0qmrI1myN7RblMmHBi+U5tqvl1d3b5VvmlhfgxYVnrns19IY/NkIoc8z++xUGZ0sGmCwuaAvAC37cw2QThZY8ijBu9/fg5QmtVKStiuksAzcp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tnfFr-0002MV-Ff; Thu, 27 Feb 2025 15:52:51 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/4] expression: propagate key datatype for anonymous sets
Date: Thu, 27 Feb 2025 15:52:08 +0100
Message-ID: <20250227145214.27730-3-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
In-Reply-To: <20250227145214.27730-1-fw@strlen.de>
References: <20250227145214.27730-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

set s {
  typeof tcp option mptcp subtype
  elements = { mp-join, dss }
}

is listed correctly. The set key provides the 'mptcpopt_subtype'
information and listing can print all elements with symbolic names.

In anon set case this doesn't work:
  tcp option mptcp subtype { mp-join, dss }

is printed as "... subtype { 1, 2}" because the anon set only provides
plain integer type.

This change propagates the datatype to the individual members of the
anon set.

After this change, multiple existing data types such as TYPE_ICMP_TYPE
could theoretically be replaced by integer-type aliases.

However, those datatypes are already exposed to userspace via the
'set type' keyword.  Thus removing them will break set definitions that
use them.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expression.c              | 35 +++++++++++++++++++++++++++++++++++
 tests/py/any/tcpopt.t         |  2 +-
 tests/py/any/tcpopt.t.json    | 11 ++++++++---
 tests/py/any/tcpopt.t.payload | 10 +++++-----
 4 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index 53d4c521ae18..d2fa46509262 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1485,6 +1485,32 @@ static void set_ref_expr_destroy(struct expr *expr)
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
+	 * type, e.g. the mptcpopt_subtype datatype.
+	 *
+	 * In this case nft will print the elements as numerical values
+	 * because the base type lacks the ->sym_tbl information of the
+	 * subtypes.
+	 */
+	if (s->init && set_is_anonymous(s->flags))
+		expr_set_type(s->init, dtype, byteorder);
+}
+
 static const struct expr_ops set_ref_expr_ops = {
 	.type		= EXPR_SET_REF,
 	.name		= "set reference",
@@ -1492,6 +1518,7 @@ static const struct expr_ops set_ref_expr_ops = {
 	.json		= set_ref_expr_json,
 	.clone		= set_ref_expr_clone,
 	.destroy	= set_ref_expr_destroy,
+	.set_type	= set_ref_expr_set_type,
 };
 
 struct expr *set_ref_expr_alloc(const struct location *loc, struct set *set)
@@ -1556,6 +1583,13 @@ static void set_elem_expr_clone(struct expr *new, const struct expr *expr)
 	__set_elem_expr_clone(new, expr);
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
@@ -1563,6 +1597,7 @@ static const struct expr_ops set_elem_expr_ops = {
 	.print		= set_elem_expr_print,
 	.json		= set_elem_expr_json,
 	.destroy	= set_elem_expr_destroy,
+	.set_type	= set_elem_expr_set_type,
 };
 
 struct expr *set_elem_expr_alloc(const struct location *loc, struct expr *key)
diff --git a/tests/py/any/tcpopt.t b/tests/py/any/tcpopt.t
index a2fcdb3afb25..79699e23a4b1 100644
--- a/tests/py/any/tcpopt.t
+++ b/tests/py/any/tcpopt.t
@@ -53,7 +53,7 @@ tcp option mptcp exists;ok
 
 tcp option mptcp subtype mp-capable;ok
 tcp option mptcp subtype 1;ok;tcp option mptcp subtype mp-join
-tcp option mptcp subtype { 0, 2};ok
+tcp option mptcp subtype { mp-capable, mp-join, remove-addr, mp-prio, mp-fail, mp-fastclose, mp-tcprst };ok
 
 reset tcp option mptcp;ok
 reset tcp option 2;ok;reset tcp option maxseg
diff --git a/tests/py/any/tcpopt.t.json b/tests/py/any/tcpopt.t.json
index ea580473c8ad..a02e71b66c36 100644
--- a/tests/py/any/tcpopt.t.json
+++ b/tests/py/any/tcpopt.t.json
@@ -565,7 +565,7 @@
     }
 ]
 
-# tcp option mptcp subtype { 0, 2}
+# tcp option mptcp subtype { mp-capable, mp-join, remove-addr, mp-prio, mp-fail, mp-fastclose, mp-tcprst }
 [
     {
         "match": {
@@ -578,8 +578,13 @@
             "op": "==",
             "right": {
                 "set": [
-                    0,
-                    2
+                    "mp-capable",
+                    "mp-join",
+                    "remove-addr",
+                    "mp-prio",
+                    "mp-fail",
+                    "mp-fastclose",
+                    "mp-tcprst"
                 ]
             }
         }
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
index e3cf500b964b..af8c4317e567 100644
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
2.45.3

