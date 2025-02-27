Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6004F25DB05
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2025 14:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740667983; cv=none; b=U2P0DSm9l+LSgOD1JkK/U/GfaWuYK1xdYa1QBVj5x4IWGcviPX4RrRJW4guwCe4dKX5uvTnYVhDknHvGi7w3FoQCOmwMq2xgW4kjVyl2uki3JL8Jzx0bSAkfs+A0Y81bAxNsCDYFvk3BrIivObbg6MLcu8uFuhgxSFTmaambN1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740667983; c=relaxed/simple;
	bh=JNlvRm4smN1/dM/4DG3jJgACidJohbZC/NKPzlB+Pmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0Q3TfyHtGPKxPIgzTy3DChq422ojOUQvQayPz2MQBHajvAoVYf7Kd+cO4tDbfks6615AsKlkBBtsZOzJ4VuozykBY4FLWQd3V7QBTYkrCDco3n3313RW1EAY+rXPHyqNhjCablnSnQVCnRjWqA+BL8zjERnE4ghGqYXsjc/C3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tnfFz-0002N6-MO; Thu, 27 Feb 2025 15:52:59 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/4] expression: expr_build_udata_recurse should recurse
Date: Thu, 27 Feb 2025 15:52:10 +0100
Message-ID: <20250227145214.27730-5-fw@strlen.de>
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

If we see EXPR_BINOP, recurse: ->left can be another EXPR_BINOP.

This is irrelevant for 'typeof' named sets, but for anonymous sets, the
key is derived from the concat expression that builds the lookup key for
the anonymous set.

 tcp option mptcp subtype . ip daddr { mp-join. 10.0.0.1, ..

 needs two binops back-to-back:

  [ exthdr load tcpopt 1b @ 30 + 2 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
  [ bitwise reg 1 = ( reg 1 >> 0x00000004 ) ]

This bug prevents concat_expr_build_udata() from creating the userdata key
at load time.

When listing the rules, we get an assertion:
 nft: src/mergesort.c:23: concat_expr_msort_value: Assertion `ilen > 0' failed.

because the set has a key with 0-length integers.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expression.c              |  2 +-
 tests/py/any/tcpopt.t         |  1 +
 tests/py/any/tcpopt.t.json    | 77 +++++++++++++++++++++++++++++++++++
 tests/py/any/tcpopt.t.payload | 13 ++++++
 4 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/src/expression.c b/src/expression.c
index d2fa46509262..8a90e09dd1c5 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1078,7 +1078,7 @@ static struct expr *expr_build_udata_recurse(struct expr *e)
 {
 	switch (e->etype) {
 	case EXPR_BINOP:
-		return e->left;
+		return expr_build_udata_recurse(e->left);
 	default:
 		break;
 	}
diff --git a/tests/py/any/tcpopt.t b/tests/py/any/tcpopt.t
index 79699e23a4b1..3d46c0efc231 100644
--- a/tests/py/any/tcpopt.t
+++ b/tests/py/any/tcpopt.t
@@ -54,6 +54,7 @@ tcp option mptcp exists;ok
 tcp option mptcp subtype mp-capable;ok
 tcp option mptcp subtype 1;ok;tcp option mptcp subtype mp-join
 tcp option mptcp subtype { mp-capable, mp-join, remove-addr, mp-prio, mp-fail, mp-fastclose, mp-tcprst };ok
+tcp option mptcp subtype . tcp dport { mp-capable . 10, mp-join . 100, add-addr . 200, remove-addr . 300, mp-prio . 400, mp-fail . 500, mp-fastclose . 600, mp-tcprst . 700 };ok
 
 reset tcp option mptcp;ok
 reset tcp option 2;ok;reset tcp option maxseg
diff --git a/tests/py/any/tcpopt.t.json b/tests/py/any/tcpopt.t.json
index a02e71b66c36..e712a5e0ed56 100644
--- a/tests/py/any/tcpopt.t.json
+++ b/tests/py/any/tcpopt.t.json
@@ -591,6 +591,83 @@
    }
 ]
 
+# tcp option mptcp subtype . tcp dport { mp-capable . 10, mp-join . 100, add-addr . 200, remove-addr . 300, mp-prio . 400, mp-fail . 500, mp-fastclose . 600, mp-tcprst . 700 }
+[
+    {
+        "match": {
+            "left": {
+                "concat": [
+                    {
+                        "tcp option": {
+                            "field": "subtype",
+                            "name": "mptcp"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "dport",
+                            "protocol": "tcp"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "concat": [
+                            "mp-capable",
+                            10
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "remove-addr",
+                            300
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "mp-fastclose",
+                            600
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "mp-join",
+                            100
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "mp-prio",
+                            400
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "mp-tcprst",
+                            700
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "add-addr",
+                            200
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "mp-fail",
+                            500
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
 # reset tcp option mptcp
 [
     {
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
index af8c4317e567..437e073aae1c 100644
--- a/tests/py/any/tcpopt.t.payload
+++ b/tests/py/any/tcpopt.t.payload
@@ -189,6 +189,19 @@ ip test-ip4 input
   [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp option mptcp subtype . tcp dport { mp-capable . 10, mp-join . 100, add-addr . 200, remove-addr . 300, mp-prio . 400, mp-fail . 500, mp-fastclose . 600, mp-tcprst . 700 }
+__set%d test-ip4 3
+__set%d test-ip4 0
+        element 00000000 00000a00  : 0 [end]    element 00000001 00006400  : 0 [end]    element 00000003 0000c800  : 0 [end]    element 00000004 00002c01  : 0 [end]    element 00000005 00009001  : 0 [end]    element 00000006 0000f401  : 0 [end]    element 00000007 00005802  : 0 [end]    element 00000008 0000bc02  : 0 [end]
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 30 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000004 ) ]
+  [ payload load 2b @ transport header + 2 => reg 9 ]
+  [ lookup reg 1 set __set%d ]
+
 # reset tcp option mptcp
 ip test-ip4 input
   [ exthdr reset tcpopt 30 ]
-- 
2.45.3

