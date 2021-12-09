Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F246C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 15:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbhLIPPW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 10:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239340AbhLIPPR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 10:15:17 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B633C061A32
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Dec 2021 07:11:44 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mvL5C-00077q-Ga; Thu, 09 Dec 2021 16:11:42 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] tcpopt: add phony mptcp suboption datatype
Date:   Thu,  9 Dec 2021 16:11:30 +0100
Message-Id: <20211209151131.22618-2-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211209151131.22618-1-fw@strlen.de>
References: <20211209151131.22618-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Because the number of unique 'enum datatypes' is limited by ABI
contraints this adds a new mptcp suboption type as integer alias.

This means that input side will work fine, but output won't, e.g.

tcp option mptcp subtype mp-capable

works, but will be shown as 'subtype 0'.

A followup patch will augment delinearization to infer the correct
type.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/datatype.h                            |  5 ++-
 src/tcpopt.c                                  | 30 +++++++++++++++++-
 tests/py/any/tcpopt.t                         |  4 +--
 tests/py/any/tcpopt.t.json                    |  2 +-
 tests/py/any/tcpopt.t.json.output             | 31 +++++++++++++++++++
 tests/py/any/tcpopt.t.payload                 |  2 +-
 .../testcases/sets/dumps/typeof_sets_0.nft    |  9 ++++++
 tests/shell/testcases/sets/typeof_sets_0      |  9 ++++++
 8 files changed, 86 insertions(+), 6 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index f5bb9dc4d937..70a0a8ac8f5d 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -254,7 +254,6 @@ extern const struct datatype verdict_type;
 extern const struct datatype nfproto_type;
 extern const struct datatype bitmask_type;
 extern const struct datatype integer_type;
-extern const struct datatype xinteger_type;
 extern const struct datatype string_type;
 extern const struct datatype lladdr_type;
 extern const struct datatype ipaddr_type;
@@ -276,6 +275,10 @@ extern const struct datatype priority_type;
 extern const struct datatype policy_type;
 extern const struct datatype cgroupv2_type;
 
+/* TYPE_INTEGER aliases: */
+extern const struct datatype xinteger_type;
+extern const struct datatype mptcpopt_subtype;
+
 void inet_service_type_print(const struct expr *expr, struct output_ctx *octx);
 
 extern const struct datatype *concat_type_alloc(uint32_t type);
diff --git a/src/tcpopt.c b/src/tcpopt.c
index c3e07d7889ab..9f2f082ec333 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -109,6 +109,31 @@ static const struct exthdr_desc tcpopt_md5sig = {
 	},
 };
 
+static const struct symbol_table mptcp_subtype_tbl = {
+	.base		= BASE_DECIMAL,
+	.symbols	= {
+		SYMBOL("mp-capable",	0),
+		SYMBOL("mp-join",	1),
+		SYMBOL("dss",		2),
+		SYMBOL("add-addr",	3),
+		SYMBOL("remove-addr",	4),
+		SYMBOL("mp-prio",	5),
+		SYMBOL("mp-fail",	6),
+		SYMBOL("mp-fastclose",	7),
+		SYMBOL("mp-tcprst",	8),
+		SYMBOL_LIST_END
+	},
+};
+
+/* alias of integer_type to parse mptcp subtypes */
+const struct datatype mptcpopt_subtype = {
+	.type		= TYPE_INTEGER,
+	.name		= "integer",
+	.desc		= "mptcp option subtype",
+	.size		= 4,
+	.basetype	= &integer_type,
+	.sym_tbl	= &mptcp_subtype_tbl,
+};
 
 static const struct exthdr_desc tcpopt_mptcp = {
 	.name		= "mptcp",
@@ -116,7 +141,10 @@ static const struct exthdr_desc tcpopt_mptcp = {
 	.templates	= {
 		[TCPOPT_MPTCP_KIND]	= PHT("kind",   0,   8),
 		[TCPOPT_MPTCP_LENGTH]	= PHT("length", 8,  8),
-		[TCPOPT_MPTCP_SUBTYPE]  = PHT("subtype", 16, 4),
+		[TCPOPT_MPTCP_SUBTYPE]  = PROTO_HDR_TEMPLATE("subtype",
+							     &mptcpopt_subtype,
+							     BYTEORDER_BIG_ENDIAN,
+							     16, 4),
 	},
 };
 #undef PHT
diff --git a/tests/py/any/tcpopt.t b/tests/py/any/tcpopt.t
index 3d4be2a274df..a5ac1e86e207 100644
--- a/tests/py/any/tcpopt.t
+++ b/tests/py/any/tcpopt.t
@@ -51,6 +51,6 @@ tcp option md5sig exists;ok
 tcp option fastopen exists;ok
 tcp option mptcp exists;ok
 
-tcp option mptcp subtype 0;ok
-tcp option mptcp subtype 1;ok
+tcp option mptcp subtype mp-capable;ok
+tcp option mptcp subtype 1;ok;tcp option mptcp subtype mp-join
 tcp option mptcp subtype { 0, 2};ok
diff --git a/tests/py/any/tcpopt.t.json b/tests/py/any/tcpopt.t.json
index 5cc6f8f42446..dc1e7a279c4a 100644
--- a/tests/py/any/tcpopt.t.json
+++ b/tests/py/any/tcpopt.t.json
@@ -533,7 +533,7 @@
     }
 ]
 
-# tcp option mptcp subtype 0
+# tcp option mptcp subtype mp-capable
 [
     {
         "match": {
diff --git a/tests/py/any/tcpopt.t.json.output b/tests/py/any/tcpopt.t.json.output
index ad0d25f4d56c..fd17cc2ace34 100644
--- a/tests/py/any/tcpopt.t.json.output
+++ b/tests/py/any/tcpopt.t.json.output
@@ -30,3 +30,34 @@
     }
 ]
 
+# tcp option mptcp subtype mp-capable
+[
+    {
+        "match": {
+            "left": {
+                "tcp option": {
+                    "field": "subtype",
+                    "name": "mptcp"
+                }
+            },
+            "op": "==",
+            "right": "mp-capable"
+        }
+    }
+]
+
+# tcp option mptcp subtype 1
+[
+    {
+        "match": {
+            "left": {
+                "tcp option": {
+                    "field": "subtype",
+                    "name": "mptcp"
+                }
+            },
+            "op": "==",
+            "right": "mp-join"
+        }
+    }
+]
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
index 121cc97fac09..269dee0aedb6 100644
--- a/tests/py/any/tcpopt.t.payload
+++ b/tests/py/any/tcpopt.t.payload
@@ -168,7 +168,7 @@ inet
   [ exthdr load tcpopt 1b @ 30 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option mptcp subtype 0
+# tcp option mptcp subtype mp-capable
 inet
   [ exthdr load tcpopt 1b @ 30 + 2 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
index e397a6345462..52dc583b139c 100644
--- a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
@@ -45,6 +45,11 @@ table inet t {
 			     15 }
 	}
 
+	set s10 {
+		typeof tcp option mptcp subtype
+		elements = { mp-join, dss }
+	}
+
 	chain c1 {
 		osf name @s1 accept
 	}
@@ -76,4 +81,8 @@ table inet t {
 	chain c9 {
 		ip hdrlength @s9 accept
 	}
+
+	chain c10 {
+		tcp option mptcp subtype @s10 accept
+	}
 }
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index be906cdcc842..5a40fe4f20c2 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -50,6 +50,11 @@ EXPECTED="table inet t {
 		elements = { 0, 1, 2, 3, 4, 15 }
 	}
 
+	set s10 {
+		typeof tcp option mptcp subtype
+		elements = { mp-join, dss }
+	}
+
 	chain c1 {
 		osf name @s1 accept
 	}
@@ -81,6 +86,10 @@ EXPECTED="table inet t {
 	chain c9 {
 		ip hdrlength @s9 accept
 	}
+
+	chain c10 {
+		tcp option mptcp subtype @s10 accept
+	}
 }"
 
 set -e
-- 
2.32.0

