Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F76B3E5EF8
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Apr 2026 18:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775155412; cv=none; b=oB/0gdgjpcV23fNjhqbcpWwr9pmoe23QBc4Htb94Ra4s+0ff4dsNdurwOQYrhTwhu/9VGiOPj7GP68b0JkXYMv90ZGPTe2DaTEh46ctC7dB0OD2C/aePT4byrRi4YzLfpWh9qPkcwpVeGbeYrWV8cs+4GFqIBZGPhUiwLPEmaNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775155412; c=relaxed/simple;
	bh=kAJSCh5gSawY5WMlZFkUrBdaAJYwMfYy67VoJFET+GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZqd2iBeQIw8dhHZy9iRE//vM4oEQRAjy+ijzsglPO480bvbvpf1DWu09qOyzb8a3EYfIjzEn0RBCXV/+kSjzMSf6CnojiKroYFBiiH7A7PGXTOsPi7RRBxh+ZTCF/Pi/VnlPSdkwqPJWSl2VRhoJ6U0YfX8WnQwimgzNIp+1+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kqxXip3c; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kqxXip3c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dJxIagA7FBmqVyzAiogHv+Hi5GKyac54W31li0fWnEE=; b=kqxXip3cSkc9GsBXXT0nIUcxlZ
	3fTECaVd2fVS7z/xfhnICXnz32SrkSvKRJpQSxJQ6XpVq7C2e58cn8lhk38wM0SeCdMQEyj52pSnb
	qxnRQ5dtAsKMyM52P4/LDkM9DOD3+LhJIGvsqTsSrnsnHKIRqSf80zFfbm2Ak2naa1B9CTeBYyqfS
	VaY2/2WkufgdAVhEaoqjbkElLxe6vxfqfLBX9vEwTGLZfJgA//Lw0cZ+d1BsVoapFMJMuGryUSjqr
	bCNcAtDbwwlX4iKStIWEPzBW60E6e1Hdj9dG3snopMEjElW9mkj8+9tnZNd6gbW3dou88E/HguGuW
	XX4cCmUg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w8N0n-000000005oc-2tOL;
	Thu, 02 Apr 2026 20:43:25 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Dion Bosschieter <dionbosschieter@gmail.com>
Subject: [nft PATCH 2/2] parser_bison: Accept non-constant binop on LHS of relationals
Date: Thu,  2 Apr 2026 20:43:20 +0200
Message-ID: <20260402184320.14862-3-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260402184320.14862-1-phil@nwl.cc>
References: <20260402184320.14862-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 14a9968a56f8b35138bab172aa7ce796f5d98e03.

Thanks to start conditions, stray "ecn" is no longer recognized by flex
and returned as keyword, so the workaround is not needed anymore. All it
takes is to move it into the block for SCANSTATE_IP and SCANSTATE_IP6 in
scanner.l.

Likewise, keyword_expr no longer has to cover for ECN keyword.

Undoing the commit's workarounds in binop expression parser cases lifts
their restriction which is no longer needed since commit 54bfc38c522ba
("src: allow binop expressions with variable right-hand operands").

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/payload-expression.txt        |  6 ++++
 src/parser_bison.y                | 16 +++++-----
 src/scanner.l                     |  2 +-
 tests/py/arp/arp.t                |  4 +++
 tests/py/arp/arp.t.json           | 51 +++++++++++++++++++++++++++++++
 tests/py/arp/arp.t.payload        | 14 +++++++++
 tests/py/arp/arp.t.payload.netdev | 18 +++++++++++
 7 files changed, 103 insertions(+), 8 deletions(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 8b538968c84b5..59be68be5e21b 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -87,6 +87,12 @@ IPv4 target address|
 ipv4_addr
 |======================
 
+.Using arp header expression
+----------------------------
+# matching on gratuitous ARP packets
+arp saddr ip ^ arp daddr ip == 0.0.0.0
+----------------------------
+
 IPV4 HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~
 [verse]
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5a334bf0c4997..368d1004c0ec4 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4466,32 +4466,32 @@ osf_ttl			:	/* empty */	{ $$ = NF_OSF_TTL_TRUE; }
 			;
 
 shift_expr		:	primary_expr
-			|	shift_expr		LSHIFT		primary_rhs_expr
+			|	shift_expr		LSHIFT		primary_expr
 			{
 				$$ = binop_expr_alloc(&@$, OP_LSHIFT, $1, $3);
 			}
-			|	shift_expr		RSHIFT		primary_rhs_expr
+			|	shift_expr		RSHIFT		primary_expr
 			{
 				$$ = binop_expr_alloc(&@$, OP_RSHIFT, $1, $3);
 			}
 			;
 
 and_expr		:	shift_expr
-			|	and_expr		AMPERSAND	shift_rhs_expr
+			|	and_expr		AMPERSAND	shift_expr
 			{
 				$$ = binop_expr_alloc(&@$, OP_AND, $1, $3);
 			}
 			;
 
 exclusive_or_expr	:	and_expr
-			|	exclusive_or_expr	CARET		and_rhs_expr
+			|	exclusive_or_expr	CARET		and_expr
 			{
 				$$ = binop_expr_alloc(&@$, OP_XOR, $1, $3);
 			}
 			;
 
 inclusive_or_expr	:	exclusive_or_expr
-			|	inclusive_or_expr	'|'		exclusive_or_rhs_expr
+			|	inclusive_or_expr	'|'		exclusive_or_expr
 			{
 				$$ = binop_expr_alloc(&@$, OP_OR, $1, $3);
 			}
@@ -5186,6 +5186,10 @@ relational_expr		:	expr	/* implicit */	rhs_expr
 			{
 				$$ = relational_expr_alloc(&@2, $2, $1, $3);
 			}
+			|	expr	relational_op	'(' rhs_expr ')'
+			{
+				$$ = relational_expr_alloc(&@2, $2, $1, $4);
+			}
 			|	expr	relational_op	list_rhs_expr
 			{
 				$$ = relational_expr_alloc(&@2, $2, $1, $3);
@@ -5287,7 +5291,6 @@ keyword_expr		:	ETHER   close_scope_eth { $$ = symbol_value(&@$, "ether"); }
 			|	ARP	close_scope_arp { $$ = symbol_value(&@$, "arp"); }
 			|	DNAT	close_scope_nat	{ $$ = symbol_value(&@$, "dnat"); }
 			|	SNAT	close_scope_nat	{ $$ = symbol_value(&@$, "snat"); }
-			|	ECN			{ $$ = symbol_value(&@$, "ecn"); }
 			|	RESET	close_scope_reset	{ $$ = symbol_value(&@$, "reset"); }
 			|	DESTROY	close_scope_destroy	{ $$ = symbol_value(&@$, "destroy"); }
 			|	ORIGINAL		{ $$ = symbol_value(&@$, "original"); }
@@ -5391,7 +5394,6 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
-			|	'('	basic_rhs_expr	')'	{ $$ = $2; }
 			;
 
 relational_op		:	EQ		{ $$ = OP_EQ; }
diff --git a/src/scanner.l b/src/scanner.l
index 1b4eb1cf13a47..912788ee0e55b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -536,8 +536,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 }
 <SCANSTATE_IP,SCANSTATE_IP6,SCANSTATE_TYPE>{
 	"dscp"			{ return DSCP; }
+	"ecn"			{ return ECN; }
 }
-"ecn"			{ return ECN; }
 <SCANSTATE_EXPR_UDP,SCANSTATE_IP,SCANSTATE_IP6,SCANSTATE_META,SCANSTATE_TCP,SCANSTATE_SCTP,SCANSTATE_EXPR_SCTP_CHUNK>"length"		{ return LENGTH; }
 <SCANSTATE_EXPR_FRAG,SCANSTATE_IP>{
 	"frag-off"		{ return FRAG_OFF; }
diff --git a/tests/py/arp/arp.t b/tests/py/arp/arp.t
index 222b91cf08457..2c850315c662a 100644
--- a/tests/py/arp/arp.t
+++ b/tests/py/arp/arp.t
@@ -58,3 +58,7 @@ arp saddr ip 192.168.1.1 arp daddr ether fe:ed:00:c0:ff:ee;ok
 arp daddr ether fe:ed:00:c0:ff:ee arp saddr ip 192.168.1.1;ok;arp saddr ip 192.168.1.1 arp daddr ether fe:ed:00:c0:ff:ee
 
 meta iifname "invalid" arp ptype 0x0800 arp htype 1 arp hlen 6 arp plen 4 @nh,192,32 0xc0a88f10 @nh,144,48 set 0x112233445566;ok;iifname "invalid" arp htype 1 arp ptype ip arp hlen 6 arp plen 4 arp daddr ip 192.168.143.16 arp daddr ether set 11:22:33:44:55:66
+
+# gratuitous ARP or not?
+arp saddr ip ^ arp daddr ip == 0.0.0.0;ok
+arp saddr ip ^ arp daddr ip != 0.0.0.0;ok
diff --git a/tests/py/arp/arp.t.json b/tests/py/arp/arp.t.json
index 7ce7609539ba4..ac7ef28d94a2b 100644
--- a/tests/py/arp/arp.t.json
+++ b/tests/py/arp/arp.t.json
@@ -891,3 +891,54 @@
     }
 ]
 
+# arp saddr ip ^ arp daddr ip == 0.0.0.0
+[
+    {
+        "match": {
+            "left": {
+                "^": [
+                    {
+                        "payload": {
+                            "field": "saddr ip",
+                            "protocol": "arp"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "daddr ip",
+                            "protocol": "arp"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": "0.0.0.0"
+        }
+    }
+]
+
+# arp saddr ip ^ arp daddr ip != 0.0.0.0
+[
+    {
+        "match": {
+            "left": {
+                "^": [
+                    {
+                        "payload": {
+                            "field": "saddr ip",
+                            "protocol": "arp"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "daddr ip",
+                            "protocol": "arp"
+                        }
+                    }
+                ]
+            },
+            "op": "!=",
+            "right": "0.0.0.0"
+        }
+    }
+]
diff --git a/tests/py/arp/arp.t.payload b/tests/py/arp/arp.t.payload
index e23c540ca8bc1..649bda9739431 100644
--- a/tests/py/arp/arp.t.payload
+++ b/tests/py/arp/arp.t.payload
@@ -254,3 +254,17 @@ arp
 arp 
   [ payload load 10b @ network header + 14 => reg 1 ]
   [ cmp eq reg 1 0xc0a80101 0xfeed00c0 0xffee ]
+
+# arp saddr ip ^ arp daddr ip == 0.0.0.0
+arp test-arp input
+  [ payload load 4b @ network header + 14 => reg 1 ]
+  [ payload load 4b @ network header + 24 => reg 2 ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# arp saddr ip ^ arp daddr ip != 0.0.0.0
+arp test-arp input
+  [ payload load 4b @ network header + 14 => reg 1 ]
+  [ payload load 4b @ network header + 24 => reg 2 ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ cmp neq reg 1 0x00000000 ]
diff --git a/tests/py/arp/arp.t.payload.netdev b/tests/py/arp/arp.t.payload.netdev
index ea238978fa73b..044f2712fd827 100644
--- a/tests/py/arp/arp.t.payload.netdev
+++ b/tests/py/arp/arp.t.payload.netdev
@@ -344,3 +344,21 @@ netdev
   [ cmp eq reg 1 0x0806 ]
   [ payload load 10b @ network header + 14 => reg 1 ]
   [ cmp eq reg 1 0xc0a80101 0xfeed00c0 0xffee ]
+
+# arp saddr ip ^ arp daddr ip == 0.0.0.0
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0806 ]
+  [ payload load 4b @ network header + 14 => reg 1 ]
+  [ payload load 4b @ network header + 24 => reg 2 ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# arp saddr ip ^ arp daddr ip != 0.0.0.0
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0806 ]
+  [ payload load 4b @ network header + 14 => reg 1 ]
+  [ payload load 4b @ network header + 24 => reg 2 ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ cmp neq reg 1 0x00000000 ]
-- 
2.51.0

