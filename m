Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AD21F76A8
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2025 09:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755595440; cv=none; b=Qzm8t9gP6rDt+RvPR5iCK4ewpzmKpjKtqaA2vl9UJ+i7EMXxUPFrFNBH23CG3TNhaH2vQWYQkYmNvNn+LTOpEoq3xWOFPsmxbjprDOG7YnYjIK/ncEcgzaJJJ0j7bd3tciI+NYXLAfZvuh+LvOBPwbSWBILuVPIhYOFJmYiCb8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755595440; c=relaxed/simple;
	bh=MGplLmq1MCC4eNn6t+iJPW7ok9QD32ZGilsWp6Ksbeg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SS300N54dCM5YtpQ27RB4VAuIiUJz+A2TW9AxcsxHd+pJMu/b6KgZQ/iioBlP4xtIOET/DNSrobBz8n248al7TZ+6+si2pGi4FYWq6EePQ9VA7AgJSn7nTffgAxCyLyMd4adXLsiPBf7gWJtoClrKXtbkxFAXcsZ3rN1QJYm4Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AKbaRENk; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fueN1M5a; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AKbaRENk";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fueN1M5a"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E4EBC60253; Tue, 19 Aug 2025 11:23:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755595431;
	bh=5ODmc60innH3gDQE4ficB6y575KcVqKmnaEkRx9YEQg=;
	h=From:To:Cc:Subject:Date:From;
	b=AKbaRENkWKlwz/YFc4HsuNBo/BpLGoh7bSsgKfFg+ON4+3WWdgrZ/GwC8fYAle35u
	 c41L14cDW0dq8YvHxVQcA/bNATkNUvrbamHa1Mext8b7I2Pt0kRHMxetYs4+1v38ko
	 kIWDV9xSZlQU8jVie+7fflxYzoF/fA5q2MEIaL+++pq41sr19lgKlACgj28sAdkNBq
	 SiJuNS+fMnq6YkauPAE5Z2j752Xsk5SXIhPnyP4m7J7CJJbVbKPM2c3kCkNfFgem53
	 9jfwayVgxazHYNjycI37cCHZUjLlfKVxWjt1rypvkpkG3/wmr1AvSXy03n8wqaD5lM
	 UnGLsYFtT8NdQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C26C760253;
	Tue, 19 Aug 2025 11:23:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755595428;
	bh=5ODmc60innH3gDQE4ficB6y575KcVqKmnaEkRx9YEQg=;
	h=From:To:Cc:Subject:Date:From;
	b=fueN1M5arQ9KFH+NsvPpbA7TgfqmrERudQPqiposrLquMt8E3p+tRi7qqaxUOLCLl
	 qJzaOqcbPGZs4W4XStULjfG2bHWOOXX0+wGATIShTeh7oe0mLoCkw44TZvU7itNgUq
	 e2SQ/pbVeFmKisY7a3BO8ru3DNV/GvWEEPeua+D6OlapOX7LFcqg0LbnGQODxepKv9
	 JAbussF4eFiscuk5JP4vWtmUKd4ufV8fWnKM8X0A1az67oCU0JPEO7LVKvETlf0BXA
	 9wMePivaM9yzrCUBJ/A/EXDpMqVD9rAIYrofL4So/b1KWJA/raG1oBYmzTRy3MDRjn
	 w+GAkwTqrHxxQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc
Subject: [PATCH nft] fib: restore JSON output for relational expressions
Date: Tue, 19 Aug 2025 11:23:42 +0200
Message-Id: <20250819092342.721798-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

JSON output for the fib expression changed:

-                    "result": "check"
+                    "result": "oif"

This breaks third party JSON parsers, revert this change for relational
expressions only via workaround until there are clear rules on how to
proceed with JSON schema updates.

As for set and map statements, keep this new "check" result type since
it is not possible to peek on rhs in such case to guess if the
NFT_FIB_F_PRESENT flag needs to be set on.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=3D1806
Fixes: f4b646032acf ("fib: allow to check if route exists in maps")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Not nice, but it addresses the issue.

 include/fib.h                                 |  2 +-
 src/fib.c                                     |  7 ++++---
 src/json.c                                    | 20 ++++++++++++++-----
 tests/py/inet/fib.t.json                      |  4 ++--
 tests/py/inet/fib.t.json.output               |  4 ++--
 tests/shell/testcases/json/single_flag        |  2 +-
 .../parsing/dumps/large_rule_pipe.json-nft    |  2 +-
 tests/shell/testcases/transactions/0049huge_0 |  2 +-
 .../transactions/dumps/0049huge_0.json-nft    |  2 +-
 9 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/include/fib.h b/include/fib.h
index 07bb2210d223..4e39ec91f695 100644
--- a/include/fib.h
+++ b/include/fib.h
@@ -3,7 +3,7 @@
=20
 #include <linux/netfilter/nf_tables.h>
=20
-extern const char *fib_result_str(const struct expr *expr);
+extern const char *fib_result_str(const struct expr *expr, bool check);
 extern struct expr *fib_expr_alloc(const struct location *loc,
 				   unsigned int flags,
 				   unsigned int result);
diff --git a/src/fib.c b/src/fib.c
index e28c52243f42..5383613292a5 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -53,13 +53,14 @@ const struct datatype fib_addr_type =3D {
 	.sym_tbl	=3D &addrtype_tbl,
 };
=20
-const char *fib_result_str(const struct expr *expr)
+const char *fib_result_str(const struct expr *expr, bool check)
 {
 	enum nft_fib_result result =3D expr->fib.result;
 	uint32_t flags =3D expr->fib.flags;
=20
 	/* Exception: check if route exists. */
-	if (result =3D=3D NFT_FIB_RESULT_OIF &&
+	if (check &&
+	    result =3D=3D NFT_FIB_RESULT_OIF &&
 	    flags & NFTA_FIB_F_PRESENT)
 		return "check";
=20
@@ -95,7 +96,7 @@ static void fib_expr_print(const struct expr *expr, struc=
t output_ctx *octx)
 	if (flags)
 		nft_print(octx, "0x%x", flags);
=20
-	nft_print(octx, " %s", fib_result_str(expr));
+	nft_print(octx, " %s", fib_result_str(expr, true));
 }
=20
 static bool fib_expr_cmp(const struct expr *e1, const struct expr *e2)
diff --git a/src/json.c b/src/json.c
index fcbc0bba9932..50c0a10d6c35 100644
--- a/src/json.c
+++ b/src/json.c
@@ -668,12 +668,21 @@ json_t *binop_expr_json(const struct expr *expr, stru=
ct output_ctx *octx)
 			 __binop_expr_json(expr->op, expr, octx));
 }
=20
+/* Workaround to retain backwards compatibility in fib output. */
+#define __NFT_CTX_OUTPUT_RELATIONAL	(1 << 30)
+
 json_t *relational_expr_json(const struct expr *expr, struct output_ctx *o=
ctx)
 {
-	return nft_json_pack("{s:{s:s, s:o, s:o}}", "match",
-			 "op", expr_op_symbols[expr->op] ? : "in",
-			 "left", expr_print_json(expr->left, octx),
-			 "right", expr_print_json(expr->right, octx));
+	json_t *ret;
+
+	octx->flags |=3D __NFT_CTX_OUTPUT_RELATIONAL;
+	ret =3D nft_json_pack("{s:{s:s, s:o, s:o}}", "match",
+			    "op", expr_op_symbols[expr->op] ? : "in",
+			    "left", expr_print_json(expr->left, octx),
+			    "right", expr_print_json(expr->right, octx));
+	octx->flags &=3D ~__NFT_CTX_OUTPUT_RELATIONAL;
+
+	return ret;
 }
=20
 json_t *range_expr_json(const struct expr *expr, struct output_ctx *octx)
@@ -1047,9 +1056,10 @@ json_t *fib_expr_json(const struct expr *expr, struc=
t output_ctx *octx)
 {
 	const char *fib_flags[] =3D { "saddr", "daddr", "mark", "iif", "oif" };
 	unsigned int flags =3D expr->fib.flags & ~NFTA_FIB_F_PRESENT;
+	bool check =3D !(octx->flags & __NFT_CTX_OUTPUT_RELATIONAL);
 	json_t *root;
=20
-	root =3D nft_json_pack("{s:s}", "result", fib_result_str(expr));
+	root =3D nft_json_pack("{s:s}", "result", fib_result_str(expr, check));
=20
 	if (flags) {
 		json_t *tmp =3D json_array();
diff --git a/tests/py/inet/fib.t.json b/tests/py/inet/fib.t.json
index 2bfe4f70b839..b6953c8fe35c 100644
--- a/tests/py/inet/fib.t.json
+++ b/tests/py/inet/fib.t.json
@@ -101,7 +101,7 @@
             "left": {
                 "fib": {
                     "flags": "daddr",
-                    "result": "check"
+                    "result": "oif"
                 }
             },
 	    "op": "=3D=3D",
@@ -117,7 +117,7 @@
             "left": {
                 "fib": {
                     "flags": "daddr",
-                    "result": "check"
+                    "result": "oif"
                 }
             },
 	    "op": "=3D=3D",
diff --git a/tests/py/inet/fib.t.json.output b/tests/py/inet/fib.t.json.out=
put
index d3396dd26daf..18a13b32186d 100644
--- a/tests/py/inet/fib.t.json.output
+++ b/tests/py/inet/fib.t.json.output
@@ -46,7 +46,7 @@
                     "flags": [
                         "daddr"
                     ],
-                    "result": "check"
+                    "result": "oif"
                 }
             },
             "op": "=3D=3D",
@@ -64,7 +64,7 @@
                     "flags": [
                         "daddr"
                     ],
-                    "result": "check"
+                    "result": "oif"
                 }
             },
             "op": "=3D=3D",
diff --git a/tests/shell/testcases/json/single_flag b/tests/shell/testcases=
/json/single_flag
index 1d70f249a571..fa917eb9c767 100755
--- a/tests/shell/testcases/json/single_flag
+++ b/tests/shell/testcases/json/single_flag
@@ -82,7 +82,7 @@ STD_FIB_1=3D"table ip t {
 		fib saddr check exists
 	}
 }"
-JSON_FIB_1=3D'{"nftables": [{"table": {"family": "ip", "name": "t", "handl=
e": 0}}, {"chain": {"family": "ip", "table": "t", "name": "c", "handle": 0}=
}, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr=
": [{"match": {"op": "=3D=3D", "left": {"fib": {"result": "check", "flags":=
 "saddr"}}, "right": true}}]}}]}'
+JSON_FIB_1=3D'{"nftables": [{"table": {"family": "ip", "name": "t", "handl=
e": 0}}, {"chain": {"family": "ip", "table": "t", "name": "c", "handle": 0}=
}, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr=
": [{"match": {"op": "=3D=3D", "left": {"fib": {"result": "oif", "flags": "=
saddr"}}, "right": true}}]}}]}'
 JSON_FIB_1_EQUIV=3D$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_FI=
B_1")
=20
 STD_FIB_2=3D$(sed 's/\(fib saddr\)/\1 . iif/' <<< "$STD_FIB_1")
diff --git a/tests/shell/testcases/parsing/dumps/large_rule_pipe.json-nft b=
/tests/shell/testcases/parsing/dumps/large_rule_pipe.json-nft
index ad1bd9120e6e..bf5dc65fe1dd 100644
--- a/tests/shell/testcases/parsing/dumps/large_rule_pipe.json-nft
+++ b/tests/shell/testcases/parsing/dumps/large_rule_pipe.json-nft
@@ -2009,7 +2009,7 @@
               "op": "=3D=3D",
               "left": {
                 "fib": {
-                  "result": "check",
+                  "result": "oif",
                   "flags": [
                     "saddr",
                     "iif"
diff --git a/tests/shell/testcases/transactions/0049huge_0 b/tests/shell/te=
stcases/transactions/0049huge_0
index 3a789f544407..698716b2b156 100755
--- a/tests/shell/testcases/transactions/0049huge_0
+++ b/tests/shell/testcases/transactions/0049huge_0
@@ -52,7 +52,7 @@ fi
 $NFT flush ruleset
=20
 RULESET=3D'{"nftables": [{"metainfo": {"json_schema_version": 1}}, {"add":=
 {"table": {"family": "inet", "name": "firewalld"}}}, {"add": {"table": {"f=
amily": "ip", "name": "firewalld"}}}, {"add": {"table": {"family": "ip6", "=
name": "firewalld"}}},
-{"add": {"chain": {"family": "inet", "table": "firewalld", "name": "raw_PR=
EROUTING", "type": "filter", "hook": "prerouting", "prio": -290}}}, {"add":=
 {"chain": {"family": "inet", "table": "firewalld", "name": "raw_PREROUTING=
_ZONES"}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chai=
n": "raw_PREROUTING", "expr": [{"jump": {"target": "raw_PREROUTING_ZONES"}}=
]}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "m=
angle_PREROUTING", "type": "filter", "hook": "prerouting", "prio": -140}}},=
 {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "mangle=
_PREROUTING_ZONES"}}}, {"add": {"rule": {"family": "inet", "table": "firewa=
lld", "chain": "mangle_PREROUTING", "expr": [{"jump": {"target": "mangle_PR=
EROUTING_ZONES"}}]}}}, {"add": {"chain": {"family": "ip", "table": "firewal=
ld", "name": "nat_PREROUTING", "type": "nat", "hook": "prerouting", "prio":=
 -90}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "=
nat_PREROUTING_ZONES"}}}, {"add": {"rule": {"family": "ip", "table": "firew=
alld", "chain": "nat_PREROUTING", "expr": [{"jump": {"target": "nat_PREROUT=
ING_ZONES"}}]}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", =
"name": "nat_POSTROUTING", "type": "nat", "hook": "postrouting", "prio": 11=
0}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "nat=
_POSTROUTING_ZONES"}}}, {"add": {"rule": {"family": "ip", "table": "firewal=
ld", "chain": "nat_POSTROUTING", "expr": [{"jump": {"target": "nat_POSTROUT=
ING_ZONES"}}]}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld",=
 "name": "nat_PREROUTING", "type": "nat", "hook": "prerouting", "prio": -90=
}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat=
_PREROUTING_ZONES"}}}, {"add": {"rule": {"family": "ip6", "table": "firewal=
ld", "chain": "nat_PREROUTING", "expr": [{"jump": {"target": "nat_PREROUTIN=
G_ZONES"}}]}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "=
name": "nat_POSTROUTING", "type": "nat", "hook": "postrouting", "prio": 110=
}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat=
_POSTROUTING_ZONES"}}}, {"add": {"rule": {"family": "ip6", "table": "firewa=
lld", "chain": "nat_POSTROUTING", "expr": [{"jump": {"target": "nat_POSTROU=
TING_ZONES"}}]}}}, {"add": {"chain": {"family": "inet", "table": "firewalld=
", "name": "filter_INPUT", "type": "filter", "hook": "input", "prio": 10}}}=
, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "filte=
r_FORWARD", "type": "filter", "hook": "forward", "prio": 10}}}, {"add": {"c=
hain": {"family": "inet", "table": "firewalld", "name": "filter_OUTPUT", "t=
ype": "filter", "hook": "output", "prio": 10}}}, {"add": {"chain": {"family=
": "inet", "table": "firewalld", "name": "filter_INPUT_ZONES"}}}, {"add": {=
"rule": {"family": "inet", "table": "firewalld", "chain": "filter_INPUT", "=
expr": [{"match": {"left": {"ct": {"key": "state"}}, "op": "in", "right": {=
"set": ["established", "related"]}}}, {"accept": null}]}}}, {"add": {"rule"=
: {"family": "inet", "table": "firewalld", "chain": "filter_INPUT", "expr":=
 [{"match": {"left": {"ct": {"key": "status"}}, "op": "in", "right": "dnat"=
}}, {"accept": null}]}}}, {"add": {"rule": {"family": "inet", "table": "fir=
ewalld", "chain": "filter_INPUT", "expr": [{"match": {"left": {"meta": {"ke=
y": "iifname"}}, "op": "=3D=3D", "right": "lo"}}, {"accept": null}]}}}, {"a=
dd": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter_INP=
UT", "expr": [{"jump": {"target": "filter_INPUT_ZONES"}}]}}}, {"add": {"rul=
e": {"family": "inet", "table": "firewalld", "chain": "filter_INPUT", "expr=
": [{"match": {"left": {"ct": {"key": "state"}}, "op": "in", "right": {"set=
": ["invalid"]}}}, {"drop": null}]}}}, {"add": {"rule": {"family": "inet", =
"table": "firewalld", "chain": "filter_INPUT", "expr": [{"reject": {"type":=
 "icmpx", "expr": "admin-prohibited"}}]}}}, {"add": {"chain": {"family": "i=
net", "table": "firewalld", "name": "filter_FORWARD_IN_ZONES"}}}, {"add": {=
"chain": {"family": "inet", "table": "firewalld", "name": "filter_FORWARD_O=
UT_ZONES"}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "ch=
ain": "filter_FORWARD", "expr": [{"match": {"left": {"ct": {"key": "state"}=
}, "op": "in", "right": {"set": ["established", "related"]}}}, {"accept": n=
ull}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain"=
: "filter_FORWARD", "expr": [{"match": {"left": {"ct": {"key": "status"}}, =
"op": "in", "right": "dnat"}}, {"accept": null}]}}}, {"add": {"rule": {"fam=
ily": "inet", "table": "firewalld", "chain": "filter_FORWARD", "expr": [{"m=
atch": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "lo"=
}}, {"accept": null}]}}}, {"add": {"rule": {"family": "inet", "table": "fir=
ewalld", "chain": "filter_FORWARD", "expr": [{"jump": {"target": "filter_FO=
RWARD_IN_ZONES"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewa=
lld", "chain": "filter_FORWARD", "expr": [{"jump": {"target": "filter_FORWA=
RD_OUT_ZONES"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewall=
d", "chain": "filter_FORWARD", "expr": [{"match": {"left": {"ct": {"key": "=
state"}}, "op": "in", "right": {"set": ["invalid"]}}}, {"drop": null}]}}}, =
{"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter_=
FORWARD", "expr": [{"reject": {"type": "icmpx", "expr": "admin-prohibited"}=
}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "=
filter_OUTPUT", "expr": [{"match": {"left": {"meta": {"key": "oifname"}}, "=
op": "=3D=3D", "right": "lo"}}, {"accept": null}]}}}, {"insert": {"rule": {=
"family": "inet", "table": "firewalld", "chain": "raw_PREROUTING", "expr": =
[{"match": {"left": {"meta": {"key": "nfproto"}}, "op": "=3D=3D", "right": =
"ipv6"}}, {"match": {"left": {"fib": {"flags": ["saddr", "iif"], "result": =
"check"}}, "op": "=3D=3D", "right": false}}, {"drop": null}]}}}, {"insert":=
 {"rule": {"family": "inet", "table": "firewalld", "chain": "raw_PREROUTING=
", "expr": [{"match": {"left": {"payload": {"protocol": "icmpv6", "field": =
"type"}}, "op": "=3D=3D", "right": {"set": ["nd-router-advert", "nd-neighbo=
r-solicit"]}}}, {"accept": null}]}}},
+{"add": {"chain": {"family": "inet", "table": "firewalld", "name": "raw_PR=
EROUTING", "type": "filter", "hook": "prerouting", "prio": -290}}}, {"add":=
 {"chain": {"family": "inet", "table": "firewalld", "name": "raw_PREROUTING=
_ZONES"}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chai=
n": "raw_PREROUTING", "expr": [{"jump": {"target": "raw_PREROUTING_ZONES"}}=
]}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "m=
angle_PREROUTING", "type": "filter", "hook": "prerouting", "prio": -140}}},=
 {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "mangle=
_PREROUTING_ZONES"}}}, {"add": {"rule": {"family": "inet", "table": "firewa=
lld", "chain": "mangle_PREROUTING", "expr": [{"jump": {"target": "mangle_PR=
EROUTING_ZONES"}}]}}}, {"add": {"chain": {"family": "ip", "table": "firewal=
ld", "name": "nat_PREROUTING", "type": "nat", "hook": "prerouting", "prio":=
 -90}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "=
nat_PREROUTING_ZONES"}}}, {"add": {"rule": {"family": "ip", "table": "firew=
alld", "chain": "nat_PREROUTING", "expr": [{"jump": {"target": "nat_PREROUT=
ING_ZONES"}}]}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", =
"name": "nat_POSTROUTING", "type": "nat", "hook": "postrouting", "prio": 11=
0}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "nat=
_POSTROUTING_ZONES"}}}, {"add": {"rule": {"family": "ip", "table": "firewal=
ld", "chain": "nat_POSTROUTING", "expr": [{"jump": {"target": "nat_POSTROUT=
ING_ZONES"}}]}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld",=
 "name": "nat_PREROUTING", "type": "nat", "hook": "prerouting", "prio": -90=
}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat=
_PREROUTING_ZONES"}}}, {"add": {"rule": {"family": "ip6", "table": "firewal=
ld", "chain": "nat_PREROUTING", "expr": [{"jump": {"target": "nat_PREROUTIN=
G_ZONES"}}]}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "=
name": "nat_POSTROUTING", "type": "nat", "hook": "postrouting", "prio": 110=
}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat=
_POSTROUTING_ZONES"}}}, {"add": {"rule": {"family": "ip6", "table": "firewa=
lld", "chain": "nat_POSTROUTING", "expr": [{"jump": {"target": "nat_POSTROU=
TING_ZONES"}}]}}}, {"add": {"chain": {"family": "inet", "table": "firewalld=
", "name": "filter_INPUT", "type": "filter", "hook": "input", "prio": 10}}}=
, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "filte=
r_FORWARD", "type": "filter", "hook": "forward", "prio": 10}}}, {"add": {"c=
hain": {"family": "inet", "table": "firewalld", "name": "filter_OUTPUT", "t=
ype": "filter", "hook": "output", "prio": 10}}}, {"add": {"chain": {"family=
": "inet", "table": "firewalld", "name": "filter_INPUT_ZONES"}}}, {"add": {=
"rule": {"family": "inet", "table": "firewalld", "chain": "filter_INPUT", "=
expr": [{"match": {"left": {"ct": {"key": "state"}}, "op": "in", "right": {=
"set": ["established", "related"]}}}, {"accept": null}]}}}, {"add": {"rule"=
: {"family": "inet", "table": "firewalld", "chain": "filter_INPUT", "expr":=
 [{"match": {"left": {"ct": {"key": "status"}}, "op": "in", "right": "dnat"=
}}, {"accept": null}]}}}, {"add": {"rule": {"family": "inet", "table": "fir=
ewalld", "chain": "filter_INPUT", "expr": [{"match": {"left": {"meta": {"ke=
y": "iifname"}}, "op": "=3D=3D", "right": "lo"}}, {"accept": null}]}}}, {"a=
dd": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter_INP=
UT", "expr": [{"jump": {"target": "filter_INPUT_ZONES"}}]}}}, {"add": {"rul=
e": {"family": "inet", "table": "firewalld", "chain": "filter_INPUT", "expr=
": [{"match": {"left": {"ct": {"key": "state"}}, "op": "in", "right": {"set=
": ["invalid"]}}}, {"drop": null}]}}}, {"add": {"rule": {"family": "inet", =
"table": "firewalld", "chain": "filter_INPUT", "expr": [{"reject": {"type":=
 "icmpx", "expr": "admin-prohibited"}}]}}}, {"add": {"chain": {"family": "i=
net", "table": "firewalld", "name": "filter_FORWARD_IN_ZONES"}}}, {"add": {=
"chain": {"family": "inet", "table": "firewalld", "name": "filter_FORWARD_O=
UT_ZONES"}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "ch=
ain": "filter_FORWARD", "expr": [{"match": {"left": {"ct": {"key": "state"}=
}, "op": "in", "right": {"set": ["established", "related"]}}}, {"accept": n=
ull}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain"=
: "filter_FORWARD", "expr": [{"match": {"left": {"ct": {"key": "status"}}, =
"op": "in", "right": "dnat"}}, {"accept": null}]}}}, {"add": {"rule": {"fam=
ily": "inet", "table": "firewalld", "chain": "filter_FORWARD", "expr": [{"m=
atch": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "lo"=
}}, {"accept": null}]}}}, {"add": {"rule": {"family": "inet", "table": "fir=
ewalld", "chain": "filter_FORWARD", "expr": [{"jump": {"target": "filter_FO=
RWARD_IN_ZONES"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewa=
lld", "chain": "filter_FORWARD", "expr": [{"jump": {"target": "filter_FORWA=
RD_OUT_ZONES"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewall=
d", "chain": "filter_FORWARD", "expr": [{"match": {"left": {"ct": {"key": "=
state"}}, "op": "in", "right": {"set": ["invalid"]}}}, {"drop": null}]}}}, =
{"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter_=
FORWARD", "expr": [{"reject": {"type": "icmpx", "expr": "admin-prohibited"}=
}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "=
filter_OUTPUT", "expr": [{"match": {"left": {"meta": {"key": "oifname"}}, "=
op": "=3D=3D", "right": "lo"}}, {"accept": null}]}}}, {"insert": {"rule": {=
"family": "inet", "table": "firewalld", "chain": "raw_PREROUTING", "expr": =
[{"match": {"left": {"meta": {"key": "nfproto"}}, "op": "=3D=3D", "right": =
"ipv6"}}, {"match": {"left": {"fib": {"flags": ["saddr", "iif"], "result": =
"oif"}}, "op": "=3D=3D", "right": false}}, {"drop": null}]}}}, {"insert": {=
"rule": {"family": "inet", "table": "firewalld", "chain": "raw_PREROUTING",=
 "expr": [{"match": {"left": {"payload": {"protocol": "icmpv6", "field": "t=
ype"}}, "op": "=3D=3D", "right": {"set": ["nd-router-advert", "nd-neighbor-=
solicit"]}}}, {"accept": null}]}}},
 {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter=
_OUTPUT", "index": 0, "expr": [{"match": {"left": {"payload": {"protocol": =
"ip6", "field": "daddr"}}, "op": "=3D=3D", "right": {"set": [{"prefix": {"a=
ddr": "::0.0.0.0", "len": 96}}, {"prefix": {"addr": "::ffff:0.0.0.0", "len"=
: 96}}, {"prefix": {"addr": "2002:0000::", "len": 24}}, {"prefix": {"addr":=
 "2002:0a00::", "len": 24}}, {"prefix": {"addr": "2002:7f00::", "len": 24}}=
, {"prefix": {"addr": "2002:ac10::", "len": 28}}, {"prefix": {"addr": "2002=
:c0a8::", "len": 32}}, {"prefix": {"addr": "2002:a9fe::", "len": 32}}, {"pr=
efix": {"addr": "2002:e000::", "len": 19}}]}}}, {"reject": {"type": "icmpv6=
", "expr": "addr-unreachable"}}]}}}, {"add": {"rule": {"family": "inet", "t=
able": "firewalld", "chain": "filter_FORWARD", "index": 2, "expr": [{"match=
": {"left": {"payload": {"protocol": "ip6", "field": "daddr"}}, "op": "=3D=
=3D", "right": {"set": [{"prefix": {"addr": "::0.0.0.0", "len": 96}}, {"pre=
fix": {"addr": "::ffff:0.0.0.0", "len": 96}}, {"prefix": {"addr": "2002:000=
0::", "len": 24}}, {"prefix": {"addr": "2002:0a00::", "len": 24}}, {"prefix=
": {"addr": "2002:7f00::", "len": 24}}, {"prefix": {"addr": "2002:ac10::", =
"len": 28}}, {"prefix": {"addr": "2002:c0a8::", "len": 32}}, {"prefix": {"a=
ddr": "2002:a9fe::", "len": 32}}, {"prefix": {"addr": "2002:e000::", "len":=
 19}}]}}}, {"reject": {"type": "icmpv6", "expr": "addr-unreachable"}}]}}}, =
{"add": {"chain": {"family": "inet", "table": "firewalld", "name": "raw_PRE=
_public"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "na=
me": "raw_PRE_public_pre"}}}, {"add": {"chain": {"family": "inet", "table":=
 "firewalld", "name": "raw_PRE_public_log"}}}, {"add": {"chain": {"family":=
 "inet", "table": "firewalld", "name": "raw_PRE_public_deny"}}}, {"add": {"=
chain": {"family": "inet", "table": "firewalld", "name": "raw_PRE_public_al=
low"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name":=
 "raw_PRE_public_post"}}}, {"add": {"rule": {"family": "inet", "table": "fi=
rewalld", "chain": "raw_PRE_public", "expr": [{"jump": {"target": "raw_PRE_=
public_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld"=
, "chain": "raw_PRE_public", "expr": [{"jump": {"target": "raw_PRE_public_l=
og"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain=
": "raw_PRE_public", "expr": [{"jump": {"target": "raw_PRE_public_deny"}}]}=
}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "raw=
_PRE_public", "expr": [{"jump": {"target": "raw_PRE_public_allow"}}]}}}, {"=
add": {"rule": {"family": "inet", "table": "firewalld", "chain": "raw_PRE_p=
ublic", "expr": [{"jump": {"target": "raw_PRE_public_post"}}]}}}, {"add": {=
"chain": {"family": "inet", "table": "firewalld", "name": "filter_IN_public=
"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "f=
ilter_IN_public_pre"}}}, {"add": {"chain": {"family": "inet", "table": "fir=
ewalld", "name": "filter_IN_public_log"}}}, {"add": {"chain": {"family": "i=
net", "table": "firewalld", "name": "filter_IN_public_deny"}}}, {"add": {"c=
hain": {"family": "inet", "table": "firewalld", "name": "filter_IN_public_a=
llow"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name"=
: "filter_IN_public_post"}}}, {"add": {"rule": {"family": "inet", "table": =
"firewalld", "chain": "filter_IN_public", "expr": [{"jump": {"target": "fil=
ter_IN_public_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table": "fir=
ewalld", "chain": "filter_IN_public", "expr": [{"jump": {"target": "filter_=
IN_public_log"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewal=
ld", "chain": "filter_IN_public", "expr": [{"jump": {"target": "filter_IN_p=
ublic_deny"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld"=
, "chain": "filter_IN_public", "expr": [{"jump": {"target": "filter_IN_publ=
ic_allow"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", =
"chain": "filter_IN_public", "expr": [{"jump": {"target": "filter_IN_public=
_post"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "ch=
ain": "filter_IN_public_allow", "expr": [{"match": {"left": {"payload": {"p=
rotocol": "tcp", "field": "dport"}}, "op": "=3D=3D", "right": 22}}, {"match=
": {"left": {"ct": {"key": "state"}}, "op": "in", "right": {"set": ["new", =
"untracked"]}}}, {"accept": null}]}}}, {"add": {"rule": {"family": "inet", =
"table": "firewalld", "chain": "filter_IN_public_allow", "expr": [{"match":=
 {"left": {"payload": {"protocol": "ip6", "field": "daddr"}}, "op": "=3D=3D=
", "right": {"prefix": {"addr": "fe80::", "len": 64}}}}, {"match": {"left":=
 {"payload": {"protocol": "udp", "field": "dport"}}, "op": "=3D=3D", "right=
": 546}}, {"match": {"left": {"ct": {"key": "state"}}, "op": "in", "right":=
 {"set": ["new", "untracked"]}}}, {"accept": null}]}}}, {"add": {"chain": {=
"family": "inet", "table": "firewalld", "name": "filter_FWDI_public"}}}, {"=
add": {"chain": {"family": "inet", "table": "firewalld", "name": "filter_FW=
DI_public_pre"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld=
", "name": "filter_FWDI_public_log"}}}, {"add": {"chain": {"family": "inet"=
, "table": "firewalld", "name": "filter_FWDI_public_deny"}}}, {"add": {"cha=
in": {"family": "inet", "table": "firewalld", "name": "filter_FWDI_public_a=
llow"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name"=
: "filter_FWDI_public_post"}}}, {"add": {"rule": {"family": "inet", "table"=
: "firewalld", "chain": "filter_FWDI_public", "expr": [{"jump": {"target": =
"filter_FWDI_public_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table"=
: "firewalld", "chain": "filter_FWDI_public", "expr": [{"jump": {"target": =
"filter_FWDI_public_log"}}]}}}, {"add": {"rule": {"family": "inet", "table"=
: "firewalld", "chain": "filter_FWDI_public", "expr": [{"jump": {"target": =
"filter_FWDI_public_deny"}}]}}}, {"add": {"rule": {"family": "inet", "table=
": "firewalld", "chain": "filter_FWDI_public", "expr": [{"jump": {"target":=
 "filter_FWDI_public_allow"}}]}}}, {"add": {"rule": {"family": "inet", "tab=
le": "firewalld", "chain": "filter_FWDI_public", "expr": [{"jump": {"target=
": "filter_FWDI_public_post"}}]}}}, {"add": {"rule": {"family": "inet", "ta=
ble": "firewalld", "chain": "filter_IN_public", "index": 4, "expr": [{"matc=
h": {"left": {"meta": {"key": "l4proto"}}, "op": "=3D=3D", "right": {"set":=
 ["icmp", "icmpv6"]}}}, {"accept": null}]}}}, {"add": {"rule": {"family": "=
inet", "table": "firewalld", "chain": "filter_FWDI_public", "index": 4, "ex=
pr": [{"match": {"left": {"meta": {"key": "l4proto"}}, "op": "=3D=3D", "rig=
ht": {"set": ["icmp", "icmpv6"]}}}, {"accept": null}]}}}, {"add": {"rule": =
{"family": "inet", "table": "firewalld", "chain": "raw_PREROUTING_ZONES", "=
expr": [{"goto": {"target": "raw_PRE_public"}}]}}}, {"add": {"chain": {"fam=
ily": "inet", "table": "firewalld", "name": "mangle_PRE_public"}}}, {"add":=
 {"chain": {"family": "inet", "table": "firewalld", "name": "mangle_PRE_pub=
lic_pre"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "na=
me": "mangle_PRE_public_log"}}}, {"add": {"chain": {"family": "inet", "tabl=
e": "firewalld", "name": "mangle_PRE_public_deny"}}}, {"add": {"chain": {"f=
amily": "inet", "table": "firewalld", "name": "mangle_PRE_public_allow"}}},=
 {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "mangle=
_PRE_public_post"}}}, {"add": {"rule": {"family": "inet", "table": "firewal=
ld", "chain": "mangle_PRE_public", "expr": [{"jump": {"target": "mangle_PRE=
_public_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld=
", "chain": "mangle_PRE_public", "expr": [{"jump": {"target": "mangle_PRE_p=
ublic_log"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld",=
 "chain": "mangle_PRE_public", "expr": [{"jump": {"target": "mangle_PRE_pub=
lic_deny"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", =
"chain": "mangle_PRE_public", "expr": [{"jump": {"target": "mangle_PRE_publ=
ic_allow"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", =
"chain": "mangle_PRE_public", "expr": [{"jump": {"target": "mangle_PRE_publ=
ic_post"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "=
chain": "mangle_PREROUTING_ZONES", "expr": [{"goto": {"target": "mangle_PRE=
_public"}}]}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "n=
ame": "nat_PRE_public"}}}, {"add": {"chain": {"family": "ip", "table": "fir=
ewalld", "name": "nat_PRE_public_pre"}}}, {"add": {"chain": {"family": "ip"=
, "table": "firewalld", "name": "nat_PRE_public_log"}}}, {"add": {"chain": =
{"family": "ip", "table": "firewalld", "name": "nat_PRE_public_deny"}}}, {"=
add": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_PRE_pub=
lic_allow"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "na=
me": "nat_PRE_public_post"}}}, {"add": {"rule": {"family": "ip", "table": "=
firewalld", "chain": "nat_PRE_public", "expr": [{"jump": {"target": "nat_PR=
E_public_pre"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld"=
, "chain": "nat_PRE_public", "expr": [{"jump": {"target": "nat_PRE_public_l=
og"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain":=
 "nat_PRE_public", "expr": [{"jump": {"target": "nat_PRE_public_deny"}}]}}}=
, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat_PRE=
_public", "expr": [{"jump": {"target": "nat_PRE_public_allow"}}]}}}, {"add"=
: {"rule": {"family": "ip", "table": "firewalld", "chain": "nat_PRE_public"=
, "expr": [{"jump": {"target": "nat_PRE_public_post"}}]}}}, {"add": {"chain=
": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_public"}}}, {"a=
dd": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_pub=
lic_pre"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "nam=
e": "nat_PRE_public_log"}}}, {"add": {"chain": {"family": "ip6", "table": "=
firewalld", "name": "nat_PRE_public_deny"}}}, {"add": {"chain": {"family": =
"ip6", "table": "firewalld", "name": "nat_PRE_public_allow"}}}, {"add": {"c=
hain": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_public_post=
"}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "na=
t_PRE_public", "expr": [{"jump": {"target": "nat_PRE_public_pre"}}]}}}, {"a=
dd": {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_pub=
lic", "expr": [{"jump": {"target": "nat_PRE_public_log"}}]}}}, {"add": {"ru=
le": {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_public", "ex=
pr": [{"jump": {"target": "nat_PRE_public_deny"}}]}}}, {"add": {"rule": {"f=
amily": "ip6", "table": "firewalld", "chain": "nat_PRE_public", "expr": [{"=
jump": {"target": "nat_PRE_public_allow"}}]}}}, {"add": {"rule": {"family":=
 "ip6", "table": "firewalld", "chain": "nat_PRE_public", "expr": [{"jump": =
{"target": "nat_PRE_public_post"}}]}}}, {"add": {"rule": {"family": "ip", "=
table": "firewalld", "chain": "nat_PREROUTING_ZONES", "expr": [{"goto": {"t=
arget": "nat_PRE_public"}}]}}}, {"add": {"rule": {"family": "ip6", "table":=
 "firewalld", "chain": "nat_PREROUTING_ZONES", "expr": [{"goto": {"target":=
 "nat_PRE_public"}}]}}}, {"add": {"chain": {"family": "ip", "table": "firew=
alld", "name": "nat_POST_public"}}}, {"add": {"chain": {"family": "ip", "ta=
ble": "firewalld", "name": "nat_POST_public_pre"}}}, {"add": {"chain": {"fa=
mily": "ip", "table": "firewalld", "name": "nat_POST_public_log"}}}, {"add"=
: {"chain": {"family": "ip", "table": "firewalld", "name": "nat_POST_public=
_deny"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name":=
 "nat_POST_public_allow"}}}, {"add": {"chain": {"family": "ip", "table": "f=
irewalld", "name": "nat_POST_public_post"}}}, {"add": {"rule": {"family": "=
ip", "table": "firewalld", "chain": "nat_POST_public", "expr": [{"jump": {"=
target": "nat_POST_public_pre"}}]}}}, {"add": {"rule": {"family": "ip", "ta=
ble": "firewalld", "chain": "nat_POST_public", "expr": [{"jump": {"target":=
 "nat_POST_public_log"}}]}}}, {"add": {"rule": {"family": "ip", "table": "f=
irewalld", "chain": "nat_POST_public", "expr": [{"jump": {"target": "nat_PO=
ST_public_deny"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewall=
d", "chain": "nat_POST_public", "expr": [{"jump": {"target": "nat_POST_publ=
ic_allow"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "c=
hain": "nat_POST_public", "expr": [{"jump": {"target": "nat_POST_public_pos=
t"}}]}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name":=
 "nat_POST_public"}}}, {"add": {"chain": {"family": "ip6", "table": "firewa=
lld", "name": "nat_POST_public_pre"}}}, {"add": {"chain": {"family": "ip6",=
 "table": "firewalld", "name": "nat_POST_public_log"}}}, {"add": {"chain": =
{"family": "ip6", "table": "firewalld", "name": "nat_POST_public_deny"}}}, =
{"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_POST=
_public_allow"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld"=
, "name": "nat_POST_public_post"}}}, {"add": {"rule": {"family": "ip6", "ta=
ble": "firewalld", "chain": "nat_POST_public", "expr": [{"jump": {"target":=
 "nat_POST_public_pre"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "=
firewalld", "chain": "nat_POST_public", "expr": [{"jump": {"target": "nat_P=
OST_public_log"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewal=
ld", "chain": "nat_POST_public", "expr": [{"jump": {"target": "nat_POST_pub=
lic_deny"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "=
chain": "nat_POST_public", "expr": [{"jump": {"target": "nat_POST_public_al=
low"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "chain=
": "nat_POST_public", "expr": [{"jump": {"target": "nat_POST_public_post"}}=
]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat=
_POSTROUTING_ZONES", "expr": [{"goto": {"target": "nat_POST_public"}}]}}}, =
{"add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_POST=
ROUTING_ZONES", "expr": [{"goto": {"target": "nat_POST_public"}}]}}}, {"add=
": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter_INPUT=
_ZONES", "expr": [{"goto": {"target": "filter_IN_public"}}]}}}, {"add": {"r=
ule": {"family": "inet", "table": "firewalld", "chain": "filter_FORWARD_IN_=
ZONES", "expr": [{"goto": {"target": "filter_FWDI_public"}}]}}}, {"add": {"=
chain": {"family": "inet", "table": "firewalld", "name": "filter_FWDO_publi=
c"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "=
filter_FWDO_public_pre"}}}, {"add": {"chain": {"family": "inet", "table": "=
firewalld", "name": "filter_FWDO_public_log"}}}, {"add": {"chain": {"family=
": "inet", "table": "firewalld", "name": "filter_FWDO_public_deny"}}}, {"ad=
d": {"chain": {"family": "inet", "table": "firewalld", "name": "filter_FWDO=
_public_allow"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld=
", "name": "filter_FWDO_public_post"}}}, {"add": {"rule": {"family": "inet"=
, "table": "firewalld", "chain": "filter_FWDO_public", "expr": [{"jump": {"=
target": "filter_FWDO_public_pre"}}]}}}, {"add": {"rule": {"family": "inet"=
, "table": "firewalld", "chain": "filter_FWDO_public", "expr": [{"jump": {"=
target": "filter_FWDO_public_log"}}]}}}, {"add": {"rule": {"family": "inet"=
, "table": "firewalld", "chain": "filter_FWDO_public", "expr": [{"jump": {"=
target": "filter_FWDO_public_deny"}}]}}}, {"add": {"rule": {"family": "inet=
", "table": "firewalld", "chain": "filter_FWDO_public", "expr": [{"jump": {=
"target": "filter_FWDO_public_allow"}}]}}}, {"add": {"rule": {"family": "in=
et", "table": "firewalld", "chain": "filter_FWDO_public", "expr": [{"jump":=
 {"target": "filter_FWDO_public_post"}}]}}}, {"add": {"rule": {"family": "i=
net", "table": "firewalld", "chain": "filter_FORWARD_OUT_ZONES", "expr": [{=
"goto": {"target": "filter_FWDO_public"}}]}}}, {"add": {"chain": {"family":=
 "inet", "table": "firewalld", "name": "raw_PRE_trusted"}}}, {"add": {"chai=
n": {"family": "inet", "table": "firewalld", "name": "raw_PRE_trusted_pre"}=
}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "raw=
_PRE_trusted_log"}}}, {"add": {"chain": {"family": "inet", "table": "firewa=
lld", "name": "raw_PRE_trusted_deny"}}}, {"add": {"chain": {"family": "inet=
", "table": "firewalld", "name": "raw_PRE_trusted_allow"}}}, {"add": {"chai=
n": {"family": "inet", "table": "firewalld", "name": "raw_PRE_trusted_post"=
}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "ra=
w_PRE_trusted", "expr": [{"jump": {"target": "raw_PRE_trusted_pre"}}]}}}, {=
"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "raw_PRE_=
trusted", "expr": [{"jump": {"target": "raw_PRE_trusted_log"}}]}}}, {"add":=
 {"rule": {"family": "inet", "table": "firewalld", "chain": "raw_PRE_truste=
d", "expr": [{"jump": {"target": "raw_PRE_trusted_deny"}}]}}}, {"add": {"ru=
le": {"family": "inet", "table": "firewalld", "chain": "raw_PRE_trusted", "=
expr": [{"jump": {"target": "raw_PRE_trusted_allow"}}]}}}, {"add": {"rule":=
 {"family": "inet", "table": "firewalld", "chain": "raw_PRE_trusted", "expr=
": [{"jump": {"target": "raw_PRE_trusted_post"}}]}}}, {"insert": {"rule": {=
"family": "inet", "table": "firewalld", "chain": "raw_PREROUTING_ZONES", "e=
xpr": [{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "ri=
ght": "perm_dummy2"}}, {"goto": {"target": "raw_PRE_trusted"}}]}}}, {"add":=
 {"chain": {"family": "inet", "table": "firewalld", "name": "mangle_PRE_tru=
sted"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name"=
: "mangle_PRE_trusted_pre"}}}, {"add": {"chain": {"family": "inet", "table"=
: "firewalld", "name": "mangle_PRE_trusted_log"}}}, {"add": {"chain": {"fam=
ily": "inet", "table": "firewalld", "name": "mangle_PRE_trusted_deny"}}}, {=
"add": {"chain": {"family": "inet", "table": "firewalld", "name": "mangle_P=
RE_trusted_allow"}}}, {"add": {"chain": {"family": "inet", "table": "firewa=
lld", "name": "mangle_PRE_trusted_post"}}}, {"add": {"rule": {"family": "in=
et", "table": "firewalld", "chain": "mangle_PRE_trusted", "expr": [{"jump":=
 {"target": "mangle_PRE_trusted_pre"}}]}}}, {"add": {"rule": {"family": "in=
et", "table": "firewalld", "chain": "mangle_PRE_trusted", "expr": [{"jump":=
 {"target": "mangle_PRE_trusted_log"}}]}}}, {"add": {"rule": {"family": "in=
et", "table": "firewalld", "chain": "mangle_PRE_trusted", "expr": [{"jump":=
 {"target": "mangle_PRE_trusted_deny"}}]}}}, {"add": {"rule": {"family": "i=
net", "table": "firewalld", "chain": "mangle_PRE_trusted", "expr": [{"jump"=
: {"target": "mangle_PRE_trusted_allow"}}]}}}, {"add": {"rule": {"family": =
"inet", "table": "firewalld", "chain": "mangle_PRE_trusted", "expr": [{"jum=
p": {"target": "mangle_PRE_trusted_post"}}]}}}, {"insert": {"rule": {"famil=
y": "inet", "table": "firewalld", "chain": "mangle_PREROUTING_ZONES", "expr=
": [{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right=
": "perm_dummy2"}}, {"goto": {"target": "mangle_PRE_trusted"}}]}}}, {"add":=
 {"chain": {"family": "ip", "table": "firewalld", "name": "nat_PRE_trusted"=
}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_=
PRE_trusted_pre"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld=
", "name": "nat_PRE_trusted_log"}}}, {"add": {"chain": {"family": "ip", "ta=
ble": "firewalld", "name": "nat_PRE_trusted_deny"}}}, {"add": {"chain": {"f=
amily": "ip", "table": "firewalld", "name": "nat_PRE_trusted_allow"}}}, {"a=
dd": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_PRE_trus=
ted_post"}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chai=
n": "nat_PRE_trusted", "expr": [{"jump": {"target": "nat_PRE_trusted_pre"}}=
]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat=
_PRE_trusted", "expr": [{"jump": {"target": "nat_PRE_trusted_log"}}]}}}, {"=
add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat_PRE_tru=
sted", "expr": [{"jump": {"target": "nat_PRE_trusted_deny"}}]}}}, {"add": {=
"rule": {"family": "ip", "table": "firewalld", "chain": "nat_PRE_trusted", =
"expr": [{"jump": {"target": "nat_PRE_trusted_allow"}}]}}}, {"add": {"rule"=
: {"family": "ip", "table": "firewalld", "chain": "nat_PRE_trusted", "expr"=
: [{"jump": {"target": "nat_PRE_trusted_post"}}]}}}, {"add": {"chain": {"fa=
mily": "ip6", "table": "firewalld", "name": "nat_PRE_trusted"}}}, {"add": {=
"chain": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_trusted_p=
re"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "=
nat_PRE_trusted_log"}}}, {"add": {"chain": {"family": "ip6", "table": "fire=
walld", "name": "nat_PRE_trusted_deny"}}}, {"add": {"chain": {"family": "ip=
6", "table": "firewalld", "name": "nat_PRE_trusted_allow"}}}, {"add": {"cha=
in": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_trusted_post"=
}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat=
_PRE_trusted", "expr": [{"jump": {"target": "nat_PRE_trusted_pre"}}]}}}, {"=
add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_tr=
usted", "expr": [{"jump": {"target": "nat_PRE_trusted_log"}}]}}}, {"add": {=
"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_trusted",=
 "expr": [{"jump": {"target": "nat_PRE_trusted_deny"}}]}}}, {"add": {"rule"=
: {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_trusted", "expr=
": [{"jump": {"target": "nat_PRE_trusted_allow"}}]}}}, {"add": {"rule": {"f=
amily": "ip6", "table": "firewalld", "chain": "nat_PRE_trusted", "expr": [{=
"jump": {"target": "nat_PRE_trusted_post"}}]}}}, {"insert": {"rule": {"fami=
ly": "ip", "table": "firewalld", "chain": "nat_PREROUTING_ZONES", "expr": [=
{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "=
perm_dummy2"}}, {"goto": {"target": "nat_PRE_trusted"}}]}}}, {"insert": {"r=
ule": {"family": "ip6", "table": "firewalld", "chain": "nat_PREROUTING_ZONE=
S", "expr": [{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D=
", "right": "perm_dummy2"}}, {"goto": {"target": "nat_PRE_trusted"}}]}}}, {=
"add": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_POST_t=
rusted"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name"=
: "nat_POST_trusted_pre"}}}, {"add": {"chain": {"family": "ip", "table": "f=
irewalld", "name": "nat_POST_trusted_log"}}}, {"add": {"chain": {"family": =
"ip", "table": "firewalld", "name": "nat_POST_trusted_deny"}}}, {"add": {"c=
hain": {"family": "ip", "table": "firewalld", "name": "nat_POST_trusted_all=
ow"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "n=
at_POST_trusted_post"}}}, {"add": {"rule": {"family": "ip", "table": "firew=
alld", "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_=
trusted_pre"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld",=
 "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_truste=
d_log"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chai=
n": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_trusted_deny=
"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "=
nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_trusted_allow"}}]=
}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat_=
POST_trusted", "expr": [{"jump": {"target": "nat_POST_trusted_post"}}]}}}, =
{"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_POST=
_trusted"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "na=
me": "nat_POST_trusted_pre"}}}, {"add": {"chain": {"family": "ip6", "table"=
: "firewalld", "name": "nat_POST_trusted_log"}}}, {"add": {"chain": {"famil=
y": "ip6", "table": "firewalld", "name": "nat_POST_trusted_deny"}}}, {"add"=
: {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_POST_trust=
ed_allow"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "na=
me": "nat_POST_trusted_post"}}}, {"add": {"rule": {"family": "ip6", "table"=
: "firewalld", "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "n=
at_POST_trusted_pre"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "fi=
rewalld", "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_PO=
ST_trusted_log"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewal=
ld", "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_tr=
usted_deny"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld",=
 "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_truste=
d_allow"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "c=
hain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_trusted_p=
ost"}}]}}}, {"insert": {"rule": {"family": "ip", "table": "firewalld", "cha=
in": "nat_POSTROUTING_ZONES", "expr": [{"match": {"left": {"meta": {"key": =
"oifname"}}, "op": "=3D=3D", "right": "perm_dummy2"}}, {"goto": {"target": =
"nat_POST_trusted"}}]}}}, {"insert": {"rule": {"family": "ip6", "table": "f=
irewalld", "chain": "nat_POSTROUTING_ZONES", "expr": [{"match": {"left": {"=
meta": {"key": "oifname"}}, "op": "=3D=3D", "right": "perm_dummy2"}}, {"got=
o": {"target": "nat_POST_trusted"}}]}}}, {"add": {"chain": {"family": "inet=
", "table": "firewalld", "name": "filter_IN_trusted"}}}, {"add": {"chain": =
{"family": "inet", "table": "firewalld", "name": "filter_IN_trusted_pre"}}}=
, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "filte=
r_IN_trusted_log"}}}, {"add": {"chain": {"family": "inet", "table": "firewa=
lld", "name": "filter_IN_trusted_deny"}}}, {"add": {"chain": {"family": "in=
et", "table": "firewalld", "name": "filter_IN_trusted_allow"}}}, {"add": {"=
chain": {"family": "inet", "table": "firewalld", "name": "filter_IN_trusted=
_post"}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain=
": "filter_IN_trusted", "expr": [{"jump": {"target": "filter_IN_trusted_pre=
"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain":=
 "filter_IN_trusted", "expr": [{"jump": {"target": "filter_IN_trusted_log"}=
}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "=
filter_IN_trusted", "expr": [{"jump": {"target": "filter_IN_trusted_deny"}}=
]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "f=
ilter_IN_trusted", "expr": [{"jump": {"target": "filter_IN_trusted_allow"}}=
]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "f=
ilter_IN_trusted", "expr": [{"jump": {"target": "filter_IN_trusted_post"}}]=
}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "fi=
lter_IN_trusted", "expr": [{"accept": null}]}}}, {"insert": {"rule": {"fami=
ly": "inet", "table": "firewalld", "chain": "filter_INPUT_ZONES", "expr": [=
{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "=
perm_dummy2"}}, {"goto": {"target": "filter_IN_trusted"}}]}}}, {"add": {"ch=
ain": {"family": "inet", "table": "firewalld", "name": "filter_FWDI_trusted=
"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "f=
ilter_FWDI_trusted_pre"}}}, {"add": {"chain": {"family": "inet", "table": "=
firewalld", "name": "filter_FWDI_trusted_log"}}}, {"add": {"chain": {"famil=
y": "inet", "table": "firewalld", "name": "filter_FWDI_trusted_deny"}}}, {"=
add": {"chain": {"family": "inet", "table": "firewalld", "name": "filter_FW=
DI_trusted_allow"}}}, {"add": {"chain": {"family": "inet", "table": "firewa=
lld", "name": "filter_FWDI_trusted_post"}}}, {"add": {"rule": {"family": "i=
net", "table": "firewalld", "chain": "filter_FWDI_trusted", "expr": [{"jump=
": {"target": "filter_FWDI_trusted_pre"}}]}}}, {"add": {"rule": {"family": =
"inet", "table": "firewalld", "chain": "filter_FWDI_trusted", "expr": [{"ju=
mp": {"target": "filter_FWDI_trusted_log"}}]}}}, {"add": {"rule": {"family"=
: "inet", "table": "firewalld", "chain": "filter_FWDI_trusted", "expr": [{"=
jump": {"target": "filter_FWDI_trusted_deny"}}]}}}, {"add": {"rule": {"fami=
ly": "inet", "table": "firewalld", "chain": "filter_FWDI_trusted", "expr": =
[{"jump": {"target": "filter_FWDI_trusted_allow"}}]}}}, {"add": {"rule": {"=
family": "inet", "table": "firewalld", "chain": "filter_FWDI_trusted", "exp=
r": [{"jump": {"target": "filter_FWDI_trusted_post"}}]}}}, {"add": {"rule":=
 {"family": "inet", "table": "firewalld", "chain": "filter_FWDI_trusted", "=
expr": [{"accept": null}]}}}, {"insert": {"rule": {"family": "inet", "table=
": "firewalld", "chain": "filter_FORWARD_IN_ZONES", "expr": [{"match": {"le=
ft": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "perm_dummy2"}}=
, {"goto": {"target": "filter_FWDI_trusted"}}]}}}, {"add": {"chain": {"fami=
ly": "inet", "table": "firewalld", "name": "filter_FWDO_trusted"}}}, {"add"=
: {"chain": {"family": "inet", "table": "firewalld", "name": "filter_FWDO_t=
rusted_pre"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", =
"name": "filter_FWDO_trusted_log"}}}, {"add": {"chain": {"family": "inet", =
"table": "firewalld", "name": "filter_FWDO_trusted_deny"}}}, {"add": {"chai=
n": {"family": "inet", "table": "firewalld", "name": "filter_FWDO_trusted_a=
llow"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name"=
: "filter_FWDO_trusted_post"}}}, {"add": {"rule": {"family": "inet", "table=
": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"jump": {"target"=
: "filter_FWDO_trusted_pre"}}]}}}, {"add": {"rule": {"family": "inet", "tab=
le": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"jump": {"targe=
t": "filter_FWDO_trusted_log"}}]}}}, {"add": {"rule": {"family": "inet", "t=
able": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"jump": {"tar=
get": "filter_FWDO_trusted_deny"}}]}}}, {"add": {"rule": {"family": "inet",=
 "table": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"jump": {"=
target": "filter_FWDO_trusted_allow"}}]}}}, {"add": {"rule": {"family": "in=
et", "table": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"jump"=
: {"target": "filter_FWDO_trusted_post"}}]}}}, {"add": {"rule": {"family": =
"inet", "table": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"ac=
cept": null}]}}}, {"insert": {"rule": {"family": "inet", "table": "firewall=
d", "chain": "filter_FORWARD_OUT_ZONES", "expr": [{"match": {"left": {"meta=
": {"key": "oifname"}}, "op": "=3D=3D", "right": "perm_dummy2"}}, {"goto": =
{"target": "filter_FWDO_trusted"}}]}}}, {"add": {"chain": {"family": "inet"=
, "table": "firewalld", "name": "raw_PRE_work"}}}, {"add": {"chain": {"fami=
ly": "inet", "table": "firewalld", "name": "raw_PRE_work_pre"}}}, {"add": {=
"chain": {"family": "inet", "table": "firewalld", "name": "raw_PRE_work_log=
"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "r=
aw_PRE_work_deny"}}}, {"add": {"chain": {"family": "inet", "table": "firewa=
lld", "name": "raw_PRE_work_allow"}}}, {"add": {"chain": {"family": "inet",=
 "table": "firewalld", "name": "raw_PRE_work_post"}}}, {"add": {"rule": {"f=
amily": "inet", "table": "firewalld", "chain": "raw_PRE_work", "expr": [{"j=
ump": {"target": "raw_PRE_work_pre"}}]}}}, {"add": {"rule": {"family": "ine=
t", "table": "firewalld", "chain": "raw_PRE_work", "expr": [{"jump": {"targ=
et": "raw_PRE_work_log"}}]}}}, {"add": {"rule": {"family": "inet", "table":=
 "firewalld", "chain": "raw_PRE_work", "expr": [{"jump": {"target": "raw_PR=
E_work_deny"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld=
", "chain": "raw_PRE_work", "expr": [{"jump": {"target": "raw_PRE_work_allo=
w"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain"=
: "raw_PRE_work", "expr": [{"jump": {"target": "raw_PRE_work_post"}}]}}}, {=
"add": {"chain": {"family": "inet", "table": "firewalld", "name": "filter_I=
N_work"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "nam=
e": "filter_IN_work_pre"}}}, {"add": {"chain": {"family": "inet", "table": =
"firewalld", "name": "filter_IN_work_log"}}}, {"add": {"chain": {"family": =
"inet", "table": "firewalld", "name": "filter_IN_work_deny"}}}, {"add": {"c=
hain": {"family": "inet", "table": "firewalld", "name": "filter_IN_work_all=
ow"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": =
"filter_IN_work_post"}}}, {"add": {"rule": {"family": "inet", "table": "fir=
ewalld", "chain": "filter_IN_work", "expr": [{"jump": {"target": "filter_IN=
_work_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld",=
 "chain": "filter_IN_work", "expr": [{"jump": {"target": "filter_IN_work_lo=
g"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain"=
: "filter_IN_work", "expr": [{"jump": {"target": "filter_IN_work_deny"}}]}}=
}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "filt=
er_IN_work", "expr": [{"jump": {"target": "filter_IN_work_allow"}}]}}}, {"a=
dd": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter_IN_=
work", "expr": [{"jump": {"target": "filter_IN_work_post"}}]}}}, {"add": {"=
rule": {"family": "inet", "table": "firewalld", "chain": "filter_IN_work_al=
low", "expr": [{"match": {"left": {"payload": {"protocol": "tcp", "field": =
"dport"}}, "op": "=3D=3D", "right": 22}}, {"match": {"left": {"ct": {"key":=
 "state"}}, "op": "in", "right": {"set": ["new", "untracked"]}}}, {"accept"=
: null}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "cha=
in": "filter_IN_work_allow", "expr": [{"match": {"left": {"payload": {"prot=
ocol": "ip6", "field": "daddr"}}, "op": "=3D=3D", "right": {"prefix": {"add=
r": "fe80::", "len": 64}}}}, {"match": {"left": {"payload": {"protocol": "u=
dp", "field": "dport"}}, "op": "=3D=3D", "right": 546}}, {"match": {"left":=
 {"ct": {"key": "state"}}, "op": "in", "right": {"set": ["new", "untracked"=
]}}}, {"accept": null}]}}}, {"insert": {"rule": {"family": "inet", "table":=
 "firewalld", "chain": "raw_PREROUTING_ZONES", "expr": [{"match": {"left": =
{"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "perm_dummy"}}, {"go=
to": {"target": "raw_PRE_work"}}]}}}, {"add": {"chain": {"family": "inet", =
"table": "firewalld", "name": "mangle_PRE_work"}}}, {"add": {"chain": {"fam=
ily": "inet", "table": "firewalld", "name": "mangle_PRE_work_pre"}}}, {"add=
": {"chain": {"family": "inet", "table": "firewalld", "name": "mangle_PRE_w=
ork_log"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "na=
me": "mangle_PRE_work_deny"}}}, {"add": {"chain": {"family": "inet", "table=
": "firewalld", "name": "mangle_PRE_work_allow"}}}, {"add": {"chain": {"fam=
ily": "inet", "table": "firewalld", "name": "mangle_PRE_work_post"}}}, {"ad=
d": {"rule": {"family": "inet", "table": "firewalld", "chain": "mangle_PRE_=
work", "expr": [{"jump": {"target": "mangle_PRE_work_pre"}}]}}}, {"add": {"=
rule": {"family": "inet", "table": "firewalld", "chain": "mangle_PRE_work",=
 "expr": [{"jump": {"target": "mangle_PRE_work_log"}}]}}}, {"add": {"rule":=
 {"family": "inet", "table": "firewalld", "chain": "mangle_PRE_work", "expr=
": [{"jump": {"target": "mangle_PRE_work_deny"}}]}}}, {"add": {"rule": {"fa=
mily": "inet", "table": "firewalld", "chain": "mangle_PRE_work", "expr": [{=
"jump": {"target": "mangle_PRE_work_allow"}}]}}}, {"add": {"rule": {"family=
": "inet", "table": "firewalld", "chain": "mangle_PRE_work", "expr": [{"jum=
p": {"target": "mangle_PRE_work_post"}}]}}}, {"insert": {"rule": {"family":=
 "inet", "table": "firewalld", "chain": "mangle_PREROUTING_ZONES", "expr": =
[{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": =
"perm_dummy"}}, {"goto": {"target": "mangle_PRE_work"}}]}}}, {"add": {"chai=
n": {"family": "ip", "table": "firewalld", "name": "nat_PRE_work"}}}, {"add=
": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_PRE_work_p=
re"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "n=
at_PRE_work_log"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld=
", "name": "nat_PRE_work_deny"}}}, {"add": {"chain": {"family": "ip", "tabl=
e": "firewalld", "name": "nat_PRE_work_allow"}}}, {"add": {"chain": {"famil=
y": "ip", "table": "firewalld", "name": "nat_PRE_work_post"}}}, {"add": {"r=
ule": {"family": "ip", "table": "firewalld", "chain": "nat_PRE_work", "expr=
": [{"jump": {"target": "nat_PRE_work_pre"}}]}}}, {"add": {"rule": {"family=
": "ip", "table": "firewalld", "chain": "nat_PRE_work", "expr": [{"jump": {=
"target": "nat_PRE_work_log"}}]}}}, {"add": {"rule": {"family": "ip", "tabl=
e": "firewalld", "chain": "nat_PRE_work", "expr": [{"jump": {"target": "nat=
_PRE_work_deny"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewall=
d", "chain": "nat_PRE_work", "expr": [{"jump": {"target": "nat_PRE_work_all=
ow"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain":=
 "nat_PRE_work", "expr": [{"jump": {"target": "nat_PRE_work_post"}}]}}}, {"=
add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_wo=
rk"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "=
nat_PRE_work_pre"}}}, {"add": {"chain": {"family": "ip6", "table": "firewal=
ld", "name": "nat_PRE_work_log"}}}, {"add": {"chain": {"family": "ip6", "ta=
ble": "firewalld", "name": "nat_PRE_work_deny"}}}, {"add": {"chain": {"fami=
ly": "ip6", "table": "firewalld", "name": "nat_PRE_work_allow"}}}, {"add": =
{"chain": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_work_pos=
t"}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "n=
at_PRE_work", "expr": [{"jump": {"target": "nat_PRE_work_pre"}}]}}}, {"add"=
: {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_work",=
 "expr": [{"jump": {"target": "nat_PRE_work_log"}}]}}}, {"add": {"rule": {"=
family": "ip6", "table": "firewalld", "chain": "nat_PRE_work", "expr": [{"j=
ump": {"target": "nat_PRE_work_deny"}}]}}}, {"add": {"rule": {"family": "ip=
6", "table": "firewalld", "chain": "nat_PRE_work", "expr": [{"jump": {"targ=
et": "nat_PRE_work_allow"}}]}}}, {"add": {"rule": {"family": "ip6", "table"=
: "firewalld", "chain": "nat_PRE_work", "expr": [{"jump": {"target": "nat_P=
RE_work_post"}}]}}}, {"insert": {"rule": {"family": "ip", "table": "firewal=
ld", "chain": "nat_PREROUTING_ZONES", "expr": [{"match": {"left": {"meta": =
{"key": "iifname"}}, "op": "=3D=3D", "right": "perm_dummy"}}, {"goto": {"ta=
rget": "nat_PRE_work"}}]}}}, {"insert": {"rule": {"family": "ip6", "table":=
 "firewalld", "chain": "nat_PREROUTING_ZONES", "expr": [{"match": {"left": =
{"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "perm_dummy"}}, {"go=
to": {"target": "nat_PRE_work"}}]}}}, {"add": {"chain": {"family": "ip", "t=
able": "firewalld", "name": "nat_POST_work"}}}, {"add": {"chain": {"family"=
: "ip", "table": "firewalld", "name": "nat_POST_work_pre"}}}, {"add": {"cha=
in": {"family": "ip", "table": "firewalld", "name": "nat_POST_work_log"}}},=
 {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_POST=
_work_deny"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "n=
ame": "nat_POST_work_allow"}}}, {"add": {"chain": {"family": "ip", "table":=
 "firewalld", "name": "nat_POST_work_post"}}}, {"add": {"rule": {"family": =
"ip", "table": "firewalld", "chain": "nat_POST_work", "expr": [{"jump": {"t=
arget": "nat_POST_work_pre"}}]}}}, {"add": {"rule": {"family": "ip", "table=
": "firewalld", "chain": "nat_POST_work", "expr": [{"jump": {"target": "nat=
_POST_work_log"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewall=
d", "chain": "nat_POST_work", "expr": [{"jump": {"target": "nat_POST_work_d=
eny"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain"=
: "nat_POST_work", "expr": [{"jump": {"target": "nat_POST_work_allow"}}]}}}=
, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat_POS=
T_work", "expr": [{"jump": {"target": "nat_POST_work_post"}}]}}}, {"add": {=
"chain": {"family": "ip6", "table": "firewalld", "name": "nat_POST_work"}}}=
, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_PO=
ST_work_pre"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", =
"name": "nat_POST_work_log"}}}, {"add": {"chain": {"family": "ip6", "table"=
: "firewalld", "name": "nat_POST_work_deny"}}}, {"add": {"chain": {"family"=
: "ip6", "table": "firewalld", "name": "nat_POST_work_allow"}}}, {"add": {"=
chain": {"family": "ip6", "table": "firewalld", "name": "nat_POST_work_post=
"}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "na=
t_POST_work", "expr": [{"jump": {"target": "nat_POST_work_pre"}}]}}}, {"add=
": {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_POST_work=
", "expr": [{"jump": {"target": "nat_POST_work_log"}}]}}}, {"add": {"rule":=
 {"family": "ip6", "table": "firewalld", "chain": "nat_POST_work", "expr": =
[{"jump": {"target": "nat_POST_work_deny"}}]}}}, {"add": {"rule": {"family"=
: "ip6", "table": "firewalld", "chain": "nat_POST_work", "expr": [{"jump": =
{"target": "nat_POST_work_allow"}}]}}}, {"add": {"rule": {"family": "ip6", =
"table": "firewalld", "chain": "nat_POST_work", "expr": [{"jump": {"target"=
: "nat_POST_work_post"}}]}}}, {"insert": {"rule": {"family": "ip", "table":=
 "firewalld", "chain": "nat_POSTROUTING_ZONES", "expr": [{"match": {"left":=
 {"meta": {"key": "oifname"}}, "op": "=3D=3D", "right": "perm_dummy"}}, {"g=
oto": {"target": "nat_POST_work"}}]}}}, {"insert": {"rule": {"family": "ip6=
", "table": "firewalld", "chain": "nat_POSTROUTING_ZONES", "expr": [{"match=
": {"left": {"meta": {"key": "oifname"}}, "op": "=3D=3D", "right": "perm_du=
mmy"}}, {"goto": {"target": "nat_POST_work"}}]}}}, {"insert": {"rule": {"fa=
mily": "inet", "table": "firewalld", "chain": "filter_INPUT_ZONES", "expr":=
 [{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right":=
 "perm_dummy"}}, {"goto": {"target": "filter_IN_work"}}]}}}, {"add": {"chai=
n": {"family": "inet", "table": "firewalld", "name": "filter_FWDI_work"}}},=
 {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "filter=
_FWDI_work_pre"}}}, {"add": {"chain": {"family": "inet", "table": "firewall=
d", "name": "filter_FWDI_work_log"}}}, {"add": {"chain": {"family": "inet",=
 "table": "firewalld", "name": "filter_FWDI_work_deny"}}}, {"add": {"chain"=
: {"family": "inet", "table": "firewalld", "name": "filter_FWDI_work_allow"=
}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "fi=
lter_FWDI_work_post"}}}, {"add": {"rule": {"family": "inet", "table": "fire=
walld", "chain": "filter_FWDI_work", "expr": [{"jump": {"target": "filter_F=
WDI_work_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewall=
d", "chain": "filter_FWDI_work", "expr": [{"jump": {"target": "filter_FWDI_=
work_log"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", =
"chain": "filter_FWDI_work", "expr": [{"jump": {"target": "filter_FWDI_work=
_deny"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "ch=
ain": "filter_FWDI_work", "expr": [{"jump": {"target": "filter_FWDI_work_al=
low"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chai=
n": "filter_FWDI_work", "expr": [{"jump": {"target": "filter_FWDI_work_post=
"}}]}}}, {"insert": {"rule": {"family": "inet", "table": "firewalld", "chai=
n": "filter_FORWARD_IN_ZONES", "expr": [{"match": {"left": {"meta": {"key":=
 "iifname"}}, "op": "=3D=3D", "right": "perm_dummy"}}, {"goto": {"target": =
"filter_FWDI_work"}}]}}}, {"add": {"chain": {"family": "inet", "table": "fi=
rewalld", "name": "filter_FWDO_work"}}}, {"add": {"chain": {"family": "inet=
", "table": "firewalld", "name": "filter_FWDO_work_pre"}}}, {"add": {"chain=
": {"family": "inet", "table": "firewalld", "name": "filter_FWDO_work_log"}=
}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "fil=
ter_FWDO_work_deny"}}}, {"add": {"chain": {"family": "inet", "table": "fire=
walld", "name": "filter_FWDO_work_allow"}}}, {"add": {"chain": {"family": "=
inet", "table": "firewalld", "name": "filter_FWDO_work_post"}}}, {"add": {"=
rule": {"family": "inet", "table": "firewalld", "chain": "filter_FWDO_work"=
, "expr": [{"jump": {"target": "filter_FWDO_work_pre"}}]}}}, {"add": {"rule=
": {"family": "inet", "table": "firewalld", "chain": "filter_FWDO_work", "e=
xpr": [{"jump": {"target": "filter_FWDO_work_log"}}]}}}, {"add": {"rule": {=
"family": "inet", "table": "firewalld", "chain": "filter_FWDO_work", "expr"=
: [{"jump": {"target": "filter_FWDO_work_deny"}}]}}}, {"add": {"rule": {"fa=
mily": "inet", "table": "firewalld", "chain": "filter_FWDO_work", "expr": [=
{"jump": {"target": "filter_FWDO_work_allow"}}]}}}, {"add": {"rule": {"fami=
ly": "inet", "table": "firewalld", "chain": "filter_FWDO_work", "expr": [{"=
jump": {"target": "filter_FWDO_work_post"}}]}}}, {"insert": {"rule": {"fami=
ly": "inet", "table": "firewalld", "chain": "filter_FORWARD_OUT_ZONES", "ex=
pr": [{"match": {"left": {"meta": {"key": "oifname"}}, "op": "=3D=3D", "rig=
ht": "perm_dummy"}}, {"goto": {"target": "filter_FWDO_work"}}]}}}, {"add": =
{"rule": {"family": "inet", "table": "firewalld", "chain": "filter_IN_work"=
, "index": 4, "expr": [{"match": {"left": {"meta": {"key": "l4proto"}}, "op=
": "=3D=3D", "right": {"set": ["icmp", "icmpv6"]}}}, {"accept": null}]}}}, =
{"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter_=
FWDI_work", "index": 4, "expr": [{"match": {"left": {"meta": {"key": "l4pro=
to"}}, "op": "=3D=3D", "right": {"set": ["icmp", "icmpv6"]}}}, {"accept": n=
ull}]}}}]}'
=20
 if [ "$NFT_TEST_HAVE_json" !=3D n ]; then
diff --git a/tests/shell/testcases/transactions/dumps/0049huge_0.json-nft b=
/tests/shell/testcases/transactions/dumps/0049huge_0.json-nft
index 4a2e5ad83848..456ada940170 100644
--- a/tests/shell/testcases/transactions/dumps/0049huge_0.json-nft
+++ b/tests/shell/testcases/transactions/dumps/0049huge_0.json-nft
@@ -887,7 +887,7 @@
               "op": "=3D=3D",
               "left": {
                 "fib": {
-                  "result": "check",
+                  "result": "oif",
                   "flags": [
                     "saddr",
                     "iif"
--=20
2.30.2

