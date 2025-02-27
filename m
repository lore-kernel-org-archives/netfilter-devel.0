Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FAB25D91A
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2025 14:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740667972; cv=none; b=GGC46hGCNAyacquaKfRMzBPMsqWOHAF24kQ/LetRUvLRBY/c4mPdwCAgUkk1BHDl576y8VTG9GCiwre1PP1ZTy9XeehW9nnknzB8Ajz7D9ae1Lcc6oK6EU0NCp27gcqscwPV3U1t1O2nieaDrFEiLFh7NebPfOBgsDgqS8I7zx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740667972; c=relaxed/simple;
	bh=+Llsb/iDdhAmnd1zIGMUwN5WbgmG14NMn89cXAVgBow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpKz4EjeDnXl2kh0CyIpm2no+mCIOU97HoYW6SceSuIDrN3rzRGrj8ZftAZBJMP41yUuxrajWzte4MW5N4qR4MCKnTirijKBfgxJ/wzfzzAXGdb8Si3HpWDURIWEcG5QKn3qAUFKzSctifeEus9k046xLlEyGHNu9hLtv8rNzP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tnfFn-0002MM-CT; Thu, 27 Feb 2025 15:52:47 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/4] tcpopt: add symbol table for mptcp suboptions
Date: Thu, 27 Feb 2025 15:52:07 +0100
Message-ID: <20250227145214.27730-2-fw@strlen.de>
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

nft can be used t match on specific multipath tcp subtypes:

  tcp option mptcp subtype 0

However, depending on which subtype to match, users need to look up the
type/value to use in rfc8684. Add support for mnemonics and
"nft describe tcp option mptcp subtype" to get the subtype list.

Because the number of unique 'enum datatypes' is limited by ABI contraints
this adds a new mptcp suboption type as integer alias.

After this patch, nft supports all of the following:
 add element t s { mp-capable }
 add rule t c tcp option mptcp subtype mp-capable
 add rule t c tcp option mptcp subtype { mp-capable, mp-fail }

For the 3rd case, listing will break because unlike for named sets, nft
lacks the type information needed to pretty-print the integer values,
i.e. nft will print the 3rd rule as 'subtype { 0, 6 }'.

This is resolved in a followup patch.

Other problematic constructs are:
  set s1 {
    typeof tcp option mptcp subtype . ip saddr
    elements = { mp-fail . 1.2.3.4 }
  }

Followed by:
  tcp option mptcp subtype . ip saddr @s1

nft will print this as:
  tcp option mptcp unknown & 240) >> 4 . ip saddr @s1

All of these issues are not related to this patch, however, they also occur
with other bit-sized extheader fields.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/datatype.h                            |  5 +++-
 src/tcpopt.c                                  | 30 ++++++++++++++++++-
 tests/py/any/tcpopt.t                         |  4 +--
 tests/py/any/tcpopt.t.json                    |  6 ++--
 tests/py/any/tcpopt.t.payload                 |  2 +-
 .../testcases/sets/dumps/typeof_sets_0.nft    |  9 ++++++
 tests/shell/testcases/sets/typeof_sets_0      | 18 +++++++++++
 7 files changed, 66 insertions(+), 8 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 8b950f9165a5..4fb47f158fc2 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -251,7 +251,6 @@ extern const struct datatype verdict_type;
 extern const struct datatype nfproto_type;
 extern const struct datatype bitmask_type;
 extern const struct datatype integer_type;
-extern const struct datatype xinteger_type;
 extern const struct datatype string_type;
 extern const struct datatype lladdr_type;
 extern const struct datatype ipaddr_type;
@@ -279,6 +278,10 @@ extern const struct datatype reject_icmp_code_type;
 extern const struct datatype reject_icmpv6_code_type;
 extern const struct datatype reject_icmpx_code_type;
 
+/* TYPE_INTEGER aliases: */
+extern const struct datatype xinteger_type;
+extern const struct datatype mptcpopt_subtype;
+
 void inet_service_type_print(const struct expr *expr, struct output_ctx *octx);
 
 extern const struct datatype *concat_type_alloc(uint32_t type);
diff --git a/src/tcpopt.c b/src/tcpopt.c
index f977e417536a..d8139337cc20 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -108,6 +108,31 @@ static const struct exthdr_desc tcpopt_md5sig = {
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
@@ -115,7 +140,10 @@ static const struct exthdr_desc tcpopt_mptcp = {
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
 
diff --git a/tests/py/any/tcpopt.t b/tests/py/any/tcpopt.t
index 177f01c45506..a2fcdb3afb25 100644
--- a/tests/py/any/tcpopt.t
+++ b/tests/py/any/tcpopt.t
@@ -51,8 +51,8 @@ tcp option md5sig exists;ok
 tcp option fastopen exists;ok
 tcp option mptcp exists;ok
 
-tcp option mptcp subtype 0;ok
-tcp option mptcp subtype 1;ok
+tcp option mptcp subtype mp-capable;ok
+tcp option mptcp subtype 1;ok;tcp option mptcp subtype mp-join
 tcp option mptcp subtype { 0, 2};ok
 
 reset tcp option mptcp;ok
diff --git a/tests/py/any/tcpopt.t.json b/tests/py/any/tcpopt.t.json
index 87074b9d216a..ea580473c8ad 100644
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
@@ -544,7 +544,7 @@
                 }
             },
             "op": "==",
-            "right": 0
+            "right": "mp-capable"
         }
     }
 ]
@@ -560,7 +560,7 @@
                 }
             },
             "op": "==",
-            "right": 1
+            "right": "mp-join"
         }
     }
 ]
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
index 99b8985f0f68..e3cf500b964b 100644
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
index 63fc5b145137..ed45d84a0eff 100644
--- a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
@@ -60,6 +60,11 @@ table inet t {
 		elements = { "eth0" . 10.1.1.2 . exists }
 	}
 
+	set s13 {
+		typeof tcp option mptcp subtype
+		elements = { mp-join, dss }
+	}
+
 	chain c1 {
 		osf name @s1 accept
 	}
@@ -103,4 +108,8 @@ table inet t {
 	chain c12 {
 		iifname . ip saddr . meta ipsec @s12 accept
 	}
+
+	chain c13 {
+		tcp option mptcp subtype @s13 accept
+	}
 }
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index a105acffde48..5ba7fc76ce15 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -119,6 +119,11 @@ INPUT="table inet t {$INPUT_OSF_SET
 		typeof meta iifname . ip saddr . meta ipsec
 		elements = { \"eth0\" . 10.1.1.2 . 1 }
 	}
+
+	set s13 {
+		typeof tcp option mptcp subtype
+		elements = { mp-join, dss }
+	}
 $INPUT_OSF_CHAIN
 	chain c2 {
 		ether type vlan vlan id @s2 accept
@@ -148,6 +153,10 @@ $INPUT_VERSION_CHAIN
 	chain c12 {
 		meta iifname . ip saddr . meta ipsec @s12 accept
 	}
+
+	chain c13 {
+		tcp option mptcp subtype @s13 accept
+	}
 }"
 
 EXPECTED="table inet t {$INPUT_OSF_SET
@@ -196,6 +205,11 @@ $INPUT_VERSION_SET
 		typeof iifname . ip saddr . meta ipsec
 		elements = { \"eth0\" . 10.1.1.2 . exists }
 	}
+
+	set s13 {
+		typeof tcp option mptcp subtype
+		elements = { mp-join, dss }
+	}
 $INPUT_OSF_CHAIN
 	chain c2 {
 		vlan id @s2 accept
@@ -224,6 +238,10 @@ $INPUT_SCTP_CHAIN$INPUT_VERSION_CHAIN
 	chain c12 {
 		iifname . ip saddr . meta ipsec @s12 accept
 	}
+
+	chain c13 {
+		tcp option mptcp subtype @s13 accept
+	}
 }"
 
 
-- 
2.45.3

