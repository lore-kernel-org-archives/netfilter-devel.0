Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2E5230278
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2025 18:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750789429; cv=none; b=HLkFAnsV5WW52tdBOyeDJ0mwN89z7xNX6HwT3TlXtnx/NrjPt/MFs7SHAao4cYMhb9apeW/TkRRkWLPdTCuqCtSaesytJLDIAO6+8DHYYY6wDF8T1XL2Ox1nIPgXHP9KUTmqs6QrWKw/Nmjs84VHt5ZiV4jss4SsKa/owFO2rAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750789429; c=relaxed/simple;
	bh=w5+39PWcUMTxR8R8AF/mSVQoTqxkzMI+iN9w304TnuI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UMb2D8HJqXxNd1FW/WZ+XJTJF7WC5oOLs12YjFAMtQ/HUk+YsKgX2gpUiQ8Iv8rp6UwdfqsalyKRF4+lirV+hqXN8szPE7POPqZ9Bl79Tm7KYSbY4ouzEwvV06tKpZbSS3N7lyHtyQFsH3w7Wnd0+MkozYs5oKtkvqZyZ0u7JPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=f42g0fxZ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ujxDdcFa; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="f42g0fxZ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ujxDdcFa"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8F5AA6026D; Tue, 24 Jun 2025 20:23:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750789421;
	bh=Iv77rmzvLeevf5SuTvZ6uPjnuBgUvnCPWNuATfc3ItM=;
	h=From:To:Cc:Subject:Date:From;
	b=f42g0fxZf5JSZfcnx2WYmz5PYozVUvRT/tssBPcPPJFWh+gaFiuye1z0DKBSIzQrs
	 9LKddjfm2k3kOhOVyrtsdODKALc+y5N8U6XH8pxjB1pejJbNTj6wBdYgoEEXn7Ti2Y
	 zZ4DtUeHqwjNEBQSXQ0t+LhyPK21BcjHR6WOLkaMflo7aC87DfmzAHHXYezRVpVndU
	 ngrRlJonSa7P3VfPIJE9VJ42f+Z9WjNIA7HFbtOxFyCJ8dDylDJjYyUxSgseIJdHVs
	 7Cn85HB5lBZnFWwEQK/oufHme1DNY3/kaQVLka/QsAquE+COVkcfxBdeFK7oxQsR/F
	 MVDOGR8HJwbwg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B64D560264;
	Tue, 24 Jun 2025 20:23:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750789415;
	bh=Iv77rmzvLeevf5SuTvZ6uPjnuBgUvnCPWNuATfc3ItM=;
	h=From:To:Cc:Subject:Date:From;
	b=ujxDdcFa4hjnizNE8m4IWJo483kxOB7jRJM8A3vhcuIXxKH/kFoQ1a8P73lsxagT/
	 57XD0ChShRwBTRl6wKTYQI5GeV2pb4MYbuR0UiRNAndWm28cRZAbelbOhY4NV0VtEd
	 mYJPFrVYLMWcQGOmjD1ed1jqi/g5pfrOxD4QCOy2BWckCHM9DyUrpCR1739V3Fm7L5
	 aJeUkkc0c5mrnjCH77nz3chSGMSGiBTukuExVo64F2dVaMUkWgLAS63ELFCmygeuWJ
	 pjTTGy4eyPYa2yCuvPxfTDTrGW13XL2sm6srhaZO4QSWDrV2vcvmM/YEchcaKiOeXw
	 TPPnd5+8IEXKg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	phil@nwl.cc
Subject: [PATCH nft,v2 1/2] fib: allow to check if route exists in maps
Date: Tue, 24 Jun 2025 20:23:29 +0200
Message-Id: <20250624182330.673905-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

f686a17eafa0 ("fib: Support existence check") adds EXPR_F_BOOLEAN as a
workaround to infer from the rhs of the relational expression if the fib
lookup wants to check for a specific output interface or, instead,
simply check for existence. This, however, does not work with maps.

The NFT_FIB_F_PRESENT flag can be used both with NFT_FIB_RESULT_OIF and
NFT_FIB_RESULT_OFINAME, my understanding is that they serve the same
purpose which is to check if a route exists, so they are redundant.

Add a 'check' fib result to check for routes while still keeping the
inference workaround for backward compatibility, but prefer the new
syntax in the listing.

Update man nft(8) and tests/py.

Fixes: f686a17eafa0 ("fib: Support existence check")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: adjust json tests too.

 doc/data-types.txt                            |  2 +-
 doc/primary-expression.txt                    |  5 ++-
 include/fib.h                                 |  2 +-
 src/fib.c                                     | 12 +++++--
 src/json.c                                    |  2 +-
 src/parser_bison.y                            | 21 +++++++----
 src/parser_json.c                             | 12 +++++--
 src/scanner.l                                 |  4 +++
 tests/py/inet/fib.t                           |  6 ++--
 tests/py/inet/fib.t.json                      | 35 +++++++++++++++++--
 tests/py/inet/fib.t.json.output               |  6 ++--
 tests/py/inet/fib.t.payload                   |  8 ++++-
 tests/shell/testcases/json/single_flag        |  4 +--
 .../parsing/dumps/large_rule_pipe.json-nft    |  2 +-
 .../parsing/dumps/large_rule_pipe.nft         |  2 +-
 tests/shell/testcases/parsing/large_rule_pipe |  2 +-
 tests/shell/testcases/transactions/0049huge_0 |  2 +-
 .../transactions/dumps/0049huge_0.json-nft    |  2 +-
 .../transactions/dumps/0049huge_0.nft         |  2 +-
 19 files changed, 100 insertions(+), 31 deletions(-)

diff --git a/doc/data-types.txt b/doc/data-types.txt
index 6c0e2f9420fe..46b0867cb5a4 100644
--- a/doc/data-types.txt
+++ b/doc/data-types.txt
@@ -166,7 +166,7 @@ Check TCP option header existence.
 .Boolean specification
 ----------------------
 # match if route exists
-filter input fib daddr . iif oif exists
+filter input fib daddr . iif check exists
=20
 # match only non-fragmented packets in IPv6 traffic
 filter input exthdr frag missing
diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index 40aca3d3fcf6..ea231fe57f7b 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -312,7 +312,7 @@ FIB EXPRESSIONS
 [verse]
 *fib* 'FIB_TUPLE' 'FIB_RESULT'
 'FIB_TUPLE' :=3D { *saddr* | *daddr*} [ *.* { *iif* | *oif* } *.* *mark* ]
-'FIB_RESULT'  :=3D { *oif* | *oifname* | *type* }
+'FIB_RESULT'  :=3D { *oif* | *oifname* | *check* | *type* }
=20
=20
 A fib expression queries the fib (forwarding information base) to obtain i=
nformation
@@ -355,6 +355,9 @@ address types can be shown with *nft* *describe* *fib_a=
ddrtype*.
 |oif|
 Output interface index|
 iface_index
+|check|
+Output interface check|
+boolean
 |oifname|
 Output interface name|
 ifname
diff --git a/include/fib.h b/include/fib.h
index 67edccfea0d5..07bb2210d223 100644
--- a/include/fib.h
+++ b/include/fib.h
@@ -3,7 +3,7 @@
=20
 #include <linux/netfilter/nf_tables.h>
=20
-extern const char *fib_result_str(enum nft_fib_result result);
+extern const char *fib_result_str(const struct expr *expr);
 extern struct expr *fib_expr_alloc(const struct location *loc,
 				   unsigned int flags,
 				   unsigned int result);
diff --git a/src/fib.c b/src/fib.c
index 5a7c1170b240..e28c52243f42 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -53,8 +53,16 @@ const struct datatype fib_addr_type =3D {
 	.sym_tbl	=3D &addrtype_tbl,
 };
=20
-const char *fib_result_str(enum nft_fib_result result)
+const char *fib_result_str(const struct expr *expr)
 {
+	enum nft_fib_result result =3D expr->fib.result;
+	uint32_t flags =3D expr->fib.flags;
+
+	/* Exception: check if route exists. */
+	if (result =3D=3D NFT_FIB_RESULT_OIF &&
+	    flags & NFTA_FIB_F_PRESENT)
+		return "check";
+
 	if (result <=3D NFT_FIB_RESULT_MAX)
 		return fib_result[result];
=20
@@ -87,7 +95,7 @@ static void fib_expr_print(const struct expr *expr, struc=
t output_ctx *octx)
 	if (flags)
 		nft_print(octx, "0x%x", flags);
=20
-	nft_print(octx, " %s", fib_result_str(expr->fib.result));
+	nft_print(octx, " %s", fib_result_str(expr));
 }
=20
 static bool fib_expr_cmp(const struct expr *e1, const struct expr *e2)
diff --git a/src/json.c b/src/json.c
index 5bd5daf3f7fa..f0430776851c 100644
--- a/src/json.c
+++ b/src/json.c
@@ -938,7 +938,7 @@ json_t *fib_expr_json(const struct expr *expr, struct o=
utput_ctx *octx)
 	unsigned int flags =3D expr->fib.flags & ~NFTA_FIB_F_PRESENT;
 	json_t *root;
=20
-	root =3D nft_json_pack("{s:s}", "result", fib_result_str(expr->fib.result=
));
+	root =3D nft_json_pack("{s:s}", "result", fib_result_str(expr));
=20
 	if (flags) {
 		json_t *tmp =3D json_array();
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9278b67a2931..e1afbbb6e56e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -284,6 +284,7 @@ int nft_lex(void *, void *, void *);
 %token UNDEFINE			"undefine"
=20
 %token FIB			"fib"
+%token CHECK			"check"
=20
 %token SOCKET			"socket"
 %token TRANSPARENT		"transparent"
@@ -4360,30 +4361,38 @@ primary_expr		:	symbol_expr			{ $$ =3D $1; }
=20
 fib_expr		:	FIB	fib_tuple	fib_result	close_scope_fib
 			{
-				if (($2 & (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) =3D=3D 0) {
+				uint32_t flags =3D $2, result =3D $3;
+
+				if (result =3D=3D __NFT_FIB_RESULT_MAX) {
+					result =3D NFT_FIB_RESULT_OIF;
+					flags |=3D NFTA_FIB_F_PRESENT;
+				}
+
+				if ((flags & (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) =3D=3D 0) {
 					erec_queue(error(&@2, "fib: need either saddr or daddr"), state->msgs=
);
 					YYERROR;
 				}
=20
-				if (($2 & (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) =3D=3D
-					  (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) {
+				if ((flags & (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) =3D=3D
+					     (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) {
 					erec_queue(error(&@2, "fib: saddr and daddr are mutually exclusive"),=
 state->msgs);
 					YYERROR;
 				}
=20
-				if (($2 & (NFTA_FIB_F_IIF|NFTA_FIB_F_OIF)) =3D=3D
-					  (NFTA_FIB_F_IIF|NFTA_FIB_F_OIF)) {
+				if ((flags & (NFTA_FIB_F_IIF|NFTA_FIB_F_OIF)) =3D=3D
+					     (NFTA_FIB_F_IIF|NFTA_FIB_F_OIF)) {
 					erec_queue(error(&@2, "fib: iif and oif are mutually exclusive"), sta=
te->msgs);
 					YYERROR;
 				}
=20
-				$$ =3D fib_expr_alloc(&@$, $2, $3);
+				$$ =3D fib_expr_alloc(&@$, flags, result);
 			}
 			;
=20
 fib_result		:	OIF	{ $$ =3DNFT_FIB_RESULT_OIF; }
 			|	OIFNAME { $$ =3DNFT_FIB_RESULT_OIFNAME; }
 			|	TYPE	close_scope_type	{ $$ =3DNFT_FIB_RESULT_ADDRTYPE; }
+			|	CHECK	{ $$ =3D __NFT_FIB_RESULT_MAX; }	/* actually, NFT_FIB_F_PRESENT=
. */
 			;
=20
 fib_flag		:       SADDR	{ $$ =3D NFTA_FIB_F_SADDR; }
diff --git a/src/parser_json.c b/src/parser_json.c
index e3dd14cda350..a8724a0c5af5 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1157,6 +1157,7 @@ static struct expr *json_parse_fib_expr(struct json_c=
tx *ctx,
 		[NFT_FIB_RESULT_OIF] =3D "oif",
 		[NFT_FIB_RESULT_OIFNAME] =3D "oifname",
 		[NFT_FIB_RESULT_ADDRTYPE] =3D "type",
+		[__NFT_FIB_RESULT_MAX] =3D "check",	/* Actually, NFT_FIB_F_PRESENT. */
 	};
 	enum nft_fib_result resultval =3D NFT_FIB_RESULT_UNSPEC;
 	const char *result;
@@ -1172,12 +1173,19 @@ static struct expr *json_parse_fib_expr(struct json=
_ctx *ctx,
 			break;
 		}
 	}
-	if (resultval =3D=3D NFT_FIB_RESULT_UNSPEC) {
+	switch (resultval) {
+	case NFT_FIB_RESULT_UNSPEC:
 		json_error(ctx, "Invalid fib result '%s'.", result);
 		return NULL;
+	case __NFT_FIB_RESULT_MAX:
+		resultval =3D NFT_FIB_RESULT_OIF;
+		flagval =3D NFTA_FIB_F_PRESENT;
+		break;
+	default:
+		break;
 	}
=20
-	flagval =3D parse_flags_array(ctx, root, "flags", fib_flag_parse);
+	flagval |=3D parse_flags_array(ctx, root, "flags", fib_flag_parse);
 	if (flagval < 0)
 		return NULL;
=20
diff --git a/src/scanner.l b/src/scanner.l
index 4787cc12f993..b69d8e81fd8c 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -795,6 +795,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
=20
 "fib"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_FIB); return F=
IB; }
=20
+<SCANSTATE_EXPR_FIB>{
+	"check"		{ return CHECK; }
+}
+
 "osf"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_OSF); return O=
SF; }
=20
 "synproxy"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_SYNPROXY);=
 return SYNPROXY; }
diff --git a/tests/py/inet/fib.t b/tests/py/inet/fib.t
index dbe45d95b4cf..f9c03b3ad2be 100644
--- a/tests/py/inet/fib.t
+++ b/tests/py/inet/fib.t
@@ -13,5 +13,7 @@ fib daddr . iif type local;ok
 fib daddr . iif type vmap { blackhole : drop, prohibit : drop, unicast : a=
ccept };ok
 fib daddr . oif type local;fail
=20
-fib daddr oif exists;ok
-fib daddr oif missing;ok
+fib daddr check missing;ok
+fib daddr oif exists;ok;fib daddr check exists
+
+fib daddr check vmap { missing : drop, exists : accept };ok
diff --git a/tests/py/inet/fib.t.json b/tests/py/inet/fib.t.json
index c29891562764..c2e9d4548a06 100644
--- a/tests/py/inet/fib.t.json
+++ b/tests/py/inet/fib.t.json
@@ -103,7 +103,7 @@
                     "flags": [
                         "daddr"
                     ],
-                    "result": "oif"
+                    "result": "check"
                 }
             },
 	    "op": "=3D=3D",
@@ -112,7 +112,7 @@
     }
 ]
=20
-# fib daddr oif missing
+# fib daddr check missing
 [
     {
         "match": {
@@ -121,7 +121,7 @@
                     "flags": [
                         "daddr"
                     ],
-                    "result": "oif"
+                    "result": "check"
                 }
             },
 	    "op": "=3D=3D",
@@ -130,3 +130,32 @@
     }
 ]
=20
+# fib daddr check vmap { missing : drop, exists : accept }
+[
+    {
+        "vmap": {
+            "data": {
+                "set": [
+                    [
+                        false,
+                        {
+                            "drop": null
+                        }
+                    ],
+                    [
+                        true,
+                        {
+                            "accept": null
+                        }
+                    ]
+                ]
+            },
+            "key": {
+                "fib": {
+                    "flags": "daddr",
+                    "result": "check"
+                }
+            }
+        }
+    }
+]
diff --git a/tests/py/inet/fib.t.json.output b/tests/py/inet/fib.t.json.out=
put
index e21f1e72c636..e8d016698b93 100644
--- a/tests/py/inet/fib.t.json.output
+++ b/tests/py/inet/fib.t.json.output
@@ -44,7 +44,7 @@
             "left": {
                 "fib": {
                     "flags": "daddr",
-                    "result": "oif"
+                    "result": "check"
                 }
             },
             "op": "=3D=3D",
@@ -53,14 +53,14 @@
     }
 ]
=20
-# fib daddr oif missing
+# fib daddr check missing
 [
     {
         "match": {
             "left": {
                 "fib": {
                     "flags": "daddr",
-                    "result": "oif"
+                    "result": "check"
                 }
             },
             "op": "=3D=3D",
diff --git a/tests/py/inet/fib.t.payload b/tests/py/inet/fib.t.payload
index 050857d96994..e09a260cc41e 100644
--- a/tests/py/inet/fib.t.payload
+++ b/tests/py/inet/fib.t.payload
@@ -26,7 +26,13 @@ ip test-ip prerouting
   [ fib daddr oif present =3D> reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
=20
-# fib daddr oif missing
+# fib daddr check missing
 ip test-ip prerouting
   [ fib daddr oif present =3D> reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
+
+# fib daddr check vmap { missing : drop, exists : accept }
+        element 00000000  : drop 0 [end]        element 00000001  : accept=
 0 [end]
+ip test-ip prerouting
+  [ fib daddr oif present =3D> reg 1 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
diff --git a/tests/shell/testcases/json/single_flag b/tests/shell/testcases=
/json/single_flag
index 43ae4528a179..f0a608ad8412 100755
--- a/tests/shell/testcases/json/single_flag
+++ b/tests/shell/testcases/json/single_flag
@@ -79,10 +79,10 @@ back_n_forth "$STD_SET_2" "$JSON_SET_2"
=20
 STD_FIB_1=3D"table ip t {
 	chain c {
-		fib saddr oif exists
+		fib saddr check exists
 	}
 }"
-JSON_FIB_1=3D'{"nftables": [{"table": {"family": "ip", "name": "t", "handl=
e": 0}}, {"chain": {"family": "ip", "table": "t", "name": "c", "handle": 0}=
}, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr=
": [{"match": {"op": "=3D=3D", "left": {"fib": {"result": "oif", "flags": "=
saddr"}}, "right": true}}]}}]}'
+JSON_FIB_1=3D'{"nftables": [{"table": {"family": "ip", "name": "t", "handl=
e": 0}}, {"chain": {"family": "ip", "table": "t", "name": "c", "handle": 0}=
}, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr=
": [{"match": {"op": "=3D=3D", "left": {"fib": {"result": "check", "flags":=
 "saddr"}}, "right": true}}]}}]}'
 JSON_FIB_1_EQUIV=3D$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_FI=
B_1")
=20
 STD_FIB_2=3D$(sed 's/\(fib saddr\)/\1 . iif/' <<< "$STD_FIB_1")
diff --git a/tests/shell/testcases/parsing/dumps/large_rule_pipe.json-nft b=
/tests/shell/testcases/parsing/dumps/large_rule_pipe.json-nft
index bf5dc65fe1dd..ad1bd9120e6e 100644
--- a/tests/shell/testcases/parsing/dumps/large_rule_pipe.json-nft
+++ b/tests/shell/testcases/parsing/dumps/large_rule_pipe.json-nft
@@ -2009,7 +2009,7 @@
               "op": "=3D=3D",
               "left": {
                 "fib": {
-                  "result": "oif",
+                  "result": "check",
                   "flags": [
                     "saddr",
                     "iif"
diff --git a/tests/shell/testcases/parsing/dumps/large_rule_pipe.nft b/test=
s/shell/testcases/parsing/dumps/large_rule_pipe.nft
index 15832752e29a..c85a636a854e 100644
--- a/tests/shell/testcases/parsing/dumps/large_rule_pipe.nft
+++ b/tests/shell/testcases/parsing/dumps/large_rule_pipe.nft
@@ -240,7 +240,7 @@ table inet firewalld {
 	chain raw_PREROUTING {
 		type filter hook prerouting priority raw + 10; policy accept;
 		icmpv6 type { nd-router-advert, nd-neighbor-solicit } accept
-		meta nfproto ipv6 fib saddr . iif oif missing drop
+		meta nfproto ipv6 fib saddr . iif check missing drop
 		jump raw_PREROUTING_ZONES_SOURCE
 		jump raw_PREROUTING_ZONES
 	}
diff --git a/tests/shell/testcases/parsing/large_rule_pipe b/tests/shell/te=
stcases/parsing/large_rule_pipe
index b6760c018ceb..4c4d62d23996 100755
--- a/tests/shell/testcases/parsing/large_rule_pipe
+++ b/tests/shell/testcases/parsing/large_rule_pipe
@@ -246,7 +246,7 @@ table inet firewalld {
 	chain raw_PREROUTING {
 		type filter hook prerouting priority -290; policy accept;
 		icmpv6 type { nd-router-advert, nd-neighbor-solicit } accept
-		meta nfproto ipv6 fib saddr . iif oif missing drop
+		meta nfproto ipv6 fib saddr . iif check missing drop
 		jump raw_PREROUTING_ZONES_SOURCE
 		jump raw_PREROUTING_ZONES
 	}
diff --git a/tests/shell/testcases/transactions/0049huge_0 b/tests/shell/te=
stcases/transactions/0049huge_0
index 698716b2b156..3a789f544407 100755
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
"oif"}}, "op": "=3D=3D", "right": false}}, {"drop": null}]}}}, {"insert": {=
"rule": {"family": "inet", "table": "firewalld", "chain": "raw_PREROUTING",=
 "expr": [{"match": {"left": {"payload": {"protocol": "icmpv6", "field": "t=
ype"}}, "op": "=3D=3D", "right": {"set": ["nd-router-advert", "nd-neighbor-=
solicit"]}}}, {"accept": null}]}}},
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
"check"}}, "op": "=3D=3D", "right": false}}, {"drop": null}]}}}, {"insert":=
 {"rule": {"family": "inet", "table": "firewalld", "chain": "raw_PREROUTING=
", "expr": [{"match": {"left": {"payload": {"protocol": "icmpv6", "field": =
"type"}}, "op": "=3D=3D", "right": {"set": ["nd-router-advert", "nd-neighbo=
r-solicit"]}}}, {"accept": null}]}}},
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
index 456ada940170..4a2e5ad83848 100644
--- a/tests/shell/testcases/transactions/dumps/0049huge_0.json-nft
+++ b/tests/shell/testcases/transactions/dumps/0049huge_0.json-nft
@@ -887,7 +887,7 @@
               "op": "=3D=3D",
               "left": {
                 "fib": {
-                  "result": "oif",
+                  "result": "check",
                   "flags": [
                     "saddr",
                     "iif"
diff --git a/tests/shell/testcases/transactions/dumps/0049huge_0.nft b/test=
s/shell/testcases/transactions/dumps/0049huge_0.nft
index 96f5a38723fb..e42ad3e19a73 100644
--- a/tests/shell/testcases/transactions/dumps/0049huge_0.nft
+++ b/tests/shell/testcases/transactions/dumps/0049huge_0.nft
@@ -2,7 +2,7 @@ table inet firewalld {
 	chain raw_PREROUTING {
 		type filter hook prerouting priority raw + 10; policy accept;
 		icmpv6 type { nd-router-advert, nd-neighbor-solicit } accept
-		meta nfproto ipv6 fib saddr . iif oif missing drop
+		meta nfproto ipv6 fib saddr . iif check missing drop
 		jump raw_PREROUTING_ZONES
 	}
=20
--=20
2.30.2

