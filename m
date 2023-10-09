Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D04E95A8E
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Oct 2023 10:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345930AbjJIKo6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Oct 2023 06:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345755AbjJIKo5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2023 06:44:57 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACB99D
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2023 03:44:41 -0700 (PDT)
Received: from [78.30.34.192] (port=51170 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qpnkQ-00DIHF-Gj; Mon, 09 Oct 2023 12:44:35 +0200
Date:   Mon, 9 Oct 2023 12:44:25 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@debian.org>
Cc:     Jeremy Sowden <jeremy@azazel.net>, netfilter-devel@vger.kernel.org,
        fw@strlen.de, phil@nwl.cc
Subject: [RFC] nftables 1.0.6 -stable backports
Message-ID: <ZSPZiekbEmjDfIF2@calendula>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="F+ks2EEYNkSkSUS3"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--F+ks2EEYNkSkSUS3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Arturo, Jeremy,

This is an batch offering fixes for nftables 1.0.6. It contains
accumulated 41 fixes from Dec 21 2022 up to what I could find in git
HEAD to make tests/shell happy. This batch also includes the fix for the
implicit chain regression in recent kernels.

Alternatively:

- I can also send you a smaller batch including only the implicit chain
  regression if you consider this is too large.

- Another possibility is to make a nftables 1.0.6.1 or 1.0.6a -stable
  release from netfilter.org. netfilter.org did not follow this
  procedure very often (a few cases in the past in iptables IIRC).

- Simply discard this batch, if it was not worth the effort to pursue
  such a large list for fixes, or fall back to smallest necessary fix
  to address the implicit chain regression.

In any case, some of these fixes are not yet included in a public
release, so probably it is better option to release nftables 1.0.9.

I have run the existing tests/shell on git HEAD, these are the
results with -stable Linux kernel 6.1:

W: [FAILED]      73/378 testcases/bitwise/0040mark_binop_7
W: [FAILED]      85/378 testcases/bitwise/0040mark_binop_4
W: [FAILED]     264/378 testcases/bitwise/0040mark_binop_9
W: [FAILED]     267/378 testcases/bitwise/0040mark_binop_2
W: [FAILED]     292/378 testcases/bitwise/0040mark_binop_8
W: [FAILED]     296/378 testcases/bitwise/0040mark_binop_3
W: [FAILED]     325/378 testcases/bitwise/0040mark_binop_6
W: [FAILED]     365/378 testcases/bitwise/0040mark_binop_5

This is a missing feature in nftables 1.0.6, I have only included
fixes.

W: [DUMP FAIL]  360/378 testcases/maps/vmap_mark_bitwise_0

This is a false positive:

--- testcases/maps/dumps/vmap_mark_bitwise_0.nft        2023-10-07 16:36:20.270782179 +0200
+++ /tmp/nft-test.20231008-111945.835.12djRv/test-testcases-maps-vmap_mark_bitwise_0.1/ruleset-after       2023-10-08 11:19:46.664558864 +0200
@@ -20,7 +20,7 @@
        }
 
        chain SET_ctmark_RPLYroute {
-               meta mark >> 8 & 0xf vmap @sctm_o0
-               counter name meta mark >> 8 & 0xf map @sctm_o1
+               meta mark >> 8 & 0x0000000f vmap @sctm_o0
+               counter name meta mark >> 8 & 0x0000000f map @sctm_o1
        }
 }

This is because in 1.0.6 the meta mark datatype is used and >= 1.0.7
use the integer datatype whenever a bitwise operation on meta mark
happens (an implicit datatype casting happens). It is just the listing
that slightly differs.

W: [FAILED]      50/378 testcases/sets/type_set_symbol

This fails because a missing feature from Florian, that I did not
cherry-picked:

commit b422b07ab2f96436001f33dfdfd937238033c799
Author: Florian Westphal <fw@strlen.de>
Date:   Wed May 24 13:25:22 2023 +0200

    src: permit use of constant values in set lookup keys

W: [DUMP FAIL]  180/378 testcases/sets/0062set_connlimit_0

This is a bogus error, it also triggers in latest kernel I have to fix
this test.

I: results: [OK] 357 [SKIPPED] 10 [FAILED] 11 [TOTAL] 378

Let me know, thanks.

--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-scanner-treat-invalid-octal-strings-as-strings.patch"

From b502a6e3b9cb6754e66b0678a22d49d59629991f Mon Sep 17 00:00:00 2001
From: Jeremy Sowden <jeremy@azazel.net>
Date: Fri, 16 Dec 2022 20:27:14 +0000
Subject: [PATCH nft,v1.0.6 01/41] scanner: treat invalid octal strings as
 strings

commit f0f9cd656c005ba9a17cd3cef5769c285064b202 upstream.

The action associated with the `{numberstring}` pattern, passes `yytext`
to `strtoull` with base 0:

	errno = 0;
	yylval->val = strtoull(yytext, NULL, 0);
	if (errno != 0) {
		yylval->string = xstrdup(yytext);
		return STRING;
	}
	return NUM;

If `yytext` begins with '0', it will be parsed as octal.  However, this
has unexpected consequences if the token contains non-octal characters.
`09` will be parsed as 0; `0308` will be parsed as 24, because
`strtoull` and its siblings stop parsing as soon as they reach a
character in the input which is not valid for the base.

Replace the `{numberstring}` match with separate `{hexstring}` and
`{decstring}` matches.  For `{decstring}` set the base to 8 if the
leading character is '0', and handle an incompletely parsed token in
the same way as one that causes `strtoull` to set `errno`.

Thus, instead of:

  $ sudo nft -f - <<<'
    table x {
      chain y {
        ip saddr 0308 continue comment "parsed as 0.0.0.24/32"
      }
    }
  '
  $ sudo nft list chain x y
  table ip x {
    chain y {
      ip saddr 0.0.0.24 continue comment "parsed as 0.0.0.24/32"
    }
  }

We get:

  $ sudo ./src/nft -f - <<<'
  > table x {
  >   chain y {
  >     ip saddr 0308 continue comment "error"
  >   }
  > }
  > '
  /dev/stdin:4:14-17: Error: Could not resolve hostname: Name or service not known
      ip saddr 0308 continue comment "error"
               ^^^^

Add a test-case.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=932880
Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1363
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/scanner.l                       | 18 +++++++++++++++---
 tests/shell/testcases/parsing/octal | 13 +++++++++++++
 2 files changed, 28 insertions(+), 3 deletions(-)
 create mode 100755 tests/shell/testcases/parsing/octal

diff --git a/src/scanner.l b/src/scanner.l
index 583c251171fd..b4315b8f8860 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -118,7 +118,6 @@ digit		[0-9]
 hexdigit	[0-9a-fA-F]
 decstring	{digit}+
 hexstring	0[xX]{hexdigit}+
-numberstring	({decstring}|{hexstring})
 letter		[a-zA-Z]
 string		({letter}|[_.])({letter}|{digit}|[/\-_\.])*
 quotedstring	\"[^"]*\"
@@ -819,9 +818,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return STRING;
 			}
 
-{numberstring}		{
+{hexstring}		{
 				errno = 0;
-				yylval->val = strtoull(yytext, NULL, 0);
+				yylval->val = strtoull(yytext, NULL, 16);
 				if (errno != 0) {
 					yylval->string = xstrdup(yytext);
 					return STRING;
@@ -829,6 +828,19 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return NUM;
 			}
 
+{decstring}		{
+				int base = yytext[0] == '0' ? 8 : 10;
+				char *end;
+
+				errno = 0;
+				yylval->val = strtoull(yytext, &end, base);
+				if (errno != 0 || *end) {
+					yylval->string = xstrdup(yytext);
+					return STRING;
+				}
+				return NUM;
+			}
+
 {classid}/[ \t\n:\-},]	{
 				yylval->string = xstrdup(yytext);
 				return STRING;
diff --git a/tests/shell/testcases/parsing/octal b/tests/shell/testcases/parsing/octal
new file mode 100755
index 000000000000..09ac26e76144
--- /dev/null
+++ b/tests/shell/testcases/parsing/octal
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+$NFT add table t || exit 1
+$NFT add chain t c || exit 1
+$NFT add rule t c 'ip saddr 01 continue comment "0.0.0.1"' || exit 1
+$NFT add rule t c 'ip saddr 08 continue comment "error"' && {
+  echo "'"ip saddr 08"'" not rejected 1>&2
+  exit 1
+}
+$NFT delete table t || exit 1
+
+exit 0
+
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0002-ct-use-inet_service_type-for-proto-src-and-proto-dst.patch"

From 62e4ccf01a79f7c247c1d0154ea7cf22755734c0 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 22 Dec 2022 12:49:59 +0100
Subject: [PATCH nft,v1.0.6 02/41] ct: use inet_service_type for proto-src and
 proto-dst

commit f470e181d8c6280ca031cfd9ee1ab52a2b21c93a upstream backport.

Instead of using the invalid type.

Problem was uncovered by this ruleset:

 table ip foo {
        map pinned {
                typeof ip daddr . ct original proto-dst : ip daddr . tcp dport
                size 65535
                flags dynamic,timeout
                timeout 6m
        }

        chain pr {
                meta l4proto tcp update @pinned { ip saddr . ct original proto-dst timeout 1m30s : ip daddr . tcp dport }
        }
 }

resulting in the following misleading error:

map-broken.nft:10:51-82: Error: datatype mismatch: expected concatenation of (IPv4 address), expression has type concatenation of (IPv4 address, internet network service)
                meta l4proto tcp update @pinned { ip saddr . ct original proto-dst timeout 1m30s : ip daddr . tcp dport }
                                 ~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/ct.c                                                      | 4 ++--
 .../testcases/maps/dumps/typeof_maps_concat_update_0.nft      | 1 +
 tests/shell/testcases/maps/typeof_maps_concat_update_0        | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index e246d3039240..64327561d089 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -271,10 +271,10 @@ const struct ct_template ct_templates[__NFT_CT_MAX] = {
 	[NFT_CT_PROTOCOL]	= CT_TEMPLATE("protocol",   &inet_protocol_type,
 					      BYTEORDER_BIG_ENDIAN,
 					      BITS_PER_BYTE),
-	[NFT_CT_PROTO_SRC]	= CT_TEMPLATE("proto-src",  &invalid_type,
+	[NFT_CT_PROTO_SRC]	= CT_TEMPLATE("proto-src",  &inet_service_type,
 					      BYTEORDER_BIG_ENDIAN,
 					      2 * BITS_PER_BYTE),
-	[NFT_CT_PROTO_DST]	= CT_TEMPLATE("proto-dst",  &invalid_type,
+	[NFT_CT_PROTO_DST]	= CT_TEMPLATE("proto-dst",  &inet_service_type,
 					      BYTEORDER_BIG_ENDIAN,
 					      2 * BITS_PER_BYTE),
 	[NFT_CT_LABELS]		= CT_TEMPLATE("label", &ct_label_type,
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_concat_update_0.nft b/tests/shell/testcases/maps/dumps/typeof_maps_concat_update_0.nft
index d91b795fa000..f9e0a1197df0 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_concat_update_0.nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_concat_update_0.nft
@@ -8,5 +8,6 @@ table ip foo {
 
 	chain pr {
 		update @pinned { ip saddr . ct original proto-dst timeout 1m30s : ip daddr . tcp dport }
+		update @pinned { ip saddr . ct original proto-dst timeout 1m30s : ip daddr . tcp dport }
 	}
 }
diff --git a/tests/shell/testcases/maps/typeof_maps_concat_update_0 b/tests/shell/testcases/maps/typeof_maps_concat_update_0
index 645ae142a5af..2766166b733d 100755
--- a/tests/shell/testcases/maps/typeof_maps_concat_update_0
+++ b/tests/shell/testcases/maps/typeof_maps_concat_update_0
@@ -10,6 +10,7 @@ EXPECTED="table ip foo {
         timeout 6m
   }
   chain pr {
+     update @pinned { ip saddr . ct original proto-dst timeout 1m30s : ip daddr . tcp dport }
      meta l4proto tcp update @pinned { ip saddr . ct original proto-dst timeout 1m30s : ip daddr . tcp dport }
   }
 }"
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0003-optimize-Clarify-chain_optimize-array-allocations.patch"

From b1891a31e0bbd03e689f50317ff8635a6c2c3194 Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 10 Jan 2023 22:13:44 +0100
Subject: [PATCH nft,v1.0.6 03/41] optimize: Clarify chain_optimize() array
 allocations

commit b83a0416cdc881c6ac35739cd858e4fe5fb2e04f upstream.

Arguments passed to sizeof() where deemed suspicious by covscan due to
the different type. Consistently specify size of an array 'a' using
'sizeof(*a) * nmemb'.

For the statement arrays in stmt_matrix, even use xzalloc_array() since
the item count is fixed and therefore can't be zero.

Fixes: fb298877ece27 ("src: add ruleset optimization infrastructure")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/optimize.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 09013efc548c..13aa1acc33f2 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -1111,10 +1111,11 @@ static int chain_optimize(struct nft_ctx *nft, struct list_head *rules)
 		ctx->num_rules++;
 	}
 
-	ctx->rule = xzalloc(sizeof(ctx->rule) * ctx->num_rules);
-	ctx->stmt_matrix = xzalloc(sizeof(struct stmt *) * ctx->num_rules);
+	ctx->rule = xzalloc(sizeof(*ctx->rule) * ctx->num_rules);
+	ctx->stmt_matrix = xzalloc(sizeof(*ctx->stmt_matrix) * ctx->num_rules);
 	for (i = 0; i < ctx->num_rules; i++)
-		ctx->stmt_matrix[i] = xzalloc(sizeof(struct stmt *) * MAX_STMTS);
+		ctx->stmt_matrix[i] = xzalloc_array(MAX_STMTS,
+						    sizeof(**ctx->stmt_matrix));
 
 	merge = xzalloc(sizeof(*merge) * ctx->num_rules);
 
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0004-intervals-restrict-check-missing-elements-fix-to-set.patch"

From be716c55cddf4c2e07ac465dbe99af386f7de2e3 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 12 Jan 2023 21:46:41 +0100
Subject: [PATCH nft,v1.0.6 04/41] intervals: restrict check missing elements
 fix to sets with no auto-merge

commit ce04d25b4a116ef04f27d0b71994f61a24114d6d upstream.

If auto-merge is enabled, skip check for element mismatch introduced by
6d1ee9267e7e ("intervals: check for EXPR_F_REMOVE in case of element
mismatch"), which is only relevant to sets with no auto-merge.

The interval adjustment routine for auto-merge already checks for
unexisting intervals in that case.

Uncovered via ASAN:

==11946==ERROR: AddressSanitizer: heap-use-after-free on address
0x60d00000021c at pc 0x559ae160d5b3 bp 0x7ffc37bcb800 sp 0x7ffc37bcb7f8
READ of size 4 at 0x60d00000021c thread T0
    #0 0x559ae160d5b2 in 0? /builddir/build/BUILD/nftables-1.0.6/src/intervals.c:424
    #1 0x559ae15cb05a in interval_set_eval.lto_priv.0 (/usr/lib64/libnftables.so.1+0xaf05a)
    #2 0x559ae15e1c0d in setelem_evaluate.lto_priv.0 (/usr/lib64/libnftables.so.1+0xc5c0d)
    #3 0x559ae166b715 in nft_evaluate (/usr/lib64/libnftables.so.1+0x14f715)
    #4 0x559ae16749b4 in nft_run_cmd_from_buffer (/usr/lib64/libnftables.so.1+0x1589b4)
    #5 0x559ae20c0e7e in main (/usr/bin/nft+0x8e7e)
    #6 0x559ae1341146 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
    #7 0x559ae1341204 in __libc_start_main_impl ../csu/libc-start.c:381
    #8 0x559ae20c1420 in _start ../sysdeps/x86_64/start.S:115

0x60d00000021c is located 60 bytes inside of 144-byte region [0x60d0000001e0,0x60d000000270) freed by thread T0 here:
    #0 0x559ae18ea618 in __interceptor_free ../../../../gcc-12.2.0/libsanitizer/asan/asan_malloc_linux.cpp:52
    #1 0x559ae160c315 in 4 /builddir/build/BUILD/nftables-1.0.6/src/intervals.c:349
    #2 0x559ae160c315 in 0? /builddir/build/BUILD/nftables-1.0.6/src/intervals.c:420

previously allocated by thread T0 here:
    #0 0x559ae18eb927 in __interceptor_calloc ../../../../gcc-12.2.0/libsanitizer/asan/asan_malloc_linux.cpp:77
    #1 0x559ae15c5076 in set_elem_expr_alloc (/usr/lib64/libnftables.so.1+0xa9076)

Fixes: 6d1ee9267e7e ("intervals: check for EXPR_F_REMOVE in case of element mismatch")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/intervals.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index 13009ca1b888..95e25cf09662 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -416,11 +416,12 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 				list_del(&i->list);
 				expr_free(i);
 			}
-		} else if (set->automerge &&
-			   setelem_adjust(set, purge, &prev_range, &range, prev, i) < 0) {
-			expr_error(msgs, i, "element does not exist");
-			err = -1;
-			goto err;
+		} else if (set->automerge) {
+			if (setelem_adjust(set, purge, &prev_range, &range, prev, i) < 0) {
+				expr_error(msgs, i, "element does not exist");
+				err = -1;
+				goto err;
+			}
 		} else if (i->flags & EXPR_F_REMOVE) {
 			expr_error(msgs, i, "element does not exist");
 			err = -1;
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0005-optimize-Do-not-return-garbage-from-stack.patch"

From 4645ae61b6c795624d81dae2d5dba2d58f744e58 Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Fri, 13 Jan 2023 17:09:53 +0100
Subject: [PATCH nft,v1.0.6 05/41] optimize: Do not return garbage from stack

commit d4d47e5bdf943be494aeb5d5a29b8f5212acbddf upstream.

If input does not contain a single 'add' command (unusual, but
possible), 'ret' value was not initialized by nft_optimize() before
returning its value.

Fixes: fb298877ece27 ("src: add ruleset optimization infrastructure")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/optimize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/optimize.c b/src/optimize.c
index 13aa1acc33f2..d592aee02e14 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -1215,7 +1215,7 @@ static int cmd_optimize(struct nft_ctx *nft, struct cmd *cmd)
 int nft_optimize(struct nft_ctx *nft, struct list_head *cmds)
 {
 	struct cmd *cmd;
-	int ret;
+	int ret = 0;
 
 	list_for_each_entry(cmd, cmds, list) {
 		switch (cmd->op) {
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0006-evaluate-set-eval-ctx-for-add-update-statements-with.patch"

From 2deeb9558c604c08436e811940ab3f2ad09f3f73 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Mon, 23 Jan 2023 19:03:28 +0100
Subject: [PATCH nft,v1.0.6 06/41] evaluate: set eval ctx for add/update
 statements with integer constants

commit 4cc6b20d31498d90e90ff574ce8b70276afcee8f upstream.

Eric reports that nft asserts when using integer basetype constants with
'typeof' sets.  Example:
table netdev t {
	set s {
		typeof ether saddr . vlan id
		flags dynamic,timeout
	}

	chain c { }
}

loads fine.  But adding a rule with add/update statement fails:
nft 'add rule netdev t c set update ether saddr . 0 @s'
nft: netlink_linearize.c:867: netlink_gen_expr: Assertion `dreg < ctx->reg_low' failed.

When the 'ether saddr . 0' concat expression is processed, there is
no set definition available anymore to deduce the required size of the
integer constant.

nft eval step then derives the required length using the data types.
'0' has integer basetype, so the deduced length is 0.

The assertion triggers because serialization step finds that it
needs one more register.

2 are needed to store the ethernet address, another register is
needed for the vlan id.

Update eval step to make the expression context store the set key
information when processing the preceeding set reference, then
let stmt_evaluate_set() preserve the  existing context instead of
zeroing it again via stmt_evaluate_arg().

This makes concat expression evaluation compute the total size
needed based on the sets key definition.

Reported-by: Eric Garver <eric@garver.life>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 32 +++++++++++++++++--
 .../maps/dumps/typeof_maps_concat.nft         | 11 +++++++
 tests/shell/testcases/maps/typeof_maps_concat |  6 ++++
 .../sets/dumps/typeof_sets_concat.nft         | 12 +++++++
 tests/shell/testcases/sets/typeof_sets_concat |  6 ++++
 5 files changed, 65 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/maps/dumps/typeof_maps_concat.nft
 create mode 100755 tests/shell/testcases/maps/typeof_maps_concat
 create mode 100644 tests/shell/testcases/sets/dumps/typeof_sets_concat.nft
 create mode 100755 tests/shell/testcases/sets/typeof_sets_concat

diff --git a/src/evaluate.c b/src/evaluate.c
index c04cb91d3919..230f0ed7859c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1593,6 +1593,14 @@ static int interval_set_eval(struct eval_ctx *ctx, struct set *set,
 	return ret;
 }
 
+static void expr_evaluate_set_ref(struct eval_ctx *ctx, struct expr *expr)
+{
+	struct set *set = expr->set;
+
+	expr_set_context(&ctx->ectx, set->key->dtype, set->key->len);
+	ctx->ectx.key = set->key;
+}
+
 static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *set = *expr, *i, *next;
@@ -2455,6 +2463,7 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	case EXPR_VARIABLE:
 		return expr_evaluate_variable(ctx, expr);
 	case EXPR_SET_REF:
+		expr_evaluate_set_ref(ctx, *expr);
 		return 0;
 	case EXPR_VALUE:
 		return expr_evaluate_value(ctx, expr);
@@ -2617,6 +2626,25 @@ static int stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 	return __stmt_evaluate_arg(ctx, stmt, dtype, len, byteorder, expr);
 }
 
+/* like stmt_evaluate_arg, but keep existing context created
+ * by previous expr_evaluate().
+ *
+ * This is needed for add/update statements:
+ * ctx->ectx.key has the set key, which may be needed for 'typeof'
+ * sets: the 'add/update' expression might contain integer data types.
+ *
+ * Without the key we cannot derive the element size.
+ */
+static int stmt_evaluate_key(struct eval_ctx *ctx, struct stmt *stmt,
+			     const struct datatype *dtype, unsigned int len,
+			     enum byteorder byteorder, struct expr **expr)
+{
+	if (expr_evaluate(ctx, expr) < 0)
+		return -1;
+
+	return __stmt_evaluate_arg(ctx, stmt, dtype, len, byteorder, expr);
+}
+
 static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	if (stmt_evaluate_arg(ctx, stmt, &verdict_type, 0, 0, &stmt->expr) < 0)
@@ -3830,7 +3858,7 @@ static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
 		return expr_error(ctx->msgs, stmt->set.set,
 				  "Expression does not refer to a set");
 
-	if (stmt_evaluate_arg(ctx, stmt,
+	if (stmt_evaluate_key(ctx, stmt,
 			      stmt->set.set->set->key->dtype,
 			      stmt->set.set->set->key->len,
 			      stmt->set.set->set->key->byteorder,
@@ -3873,7 +3901,7 @@ static int stmt_evaluate_map(struct eval_ctx *ctx, struct stmt *stmt)
 		return expr_error(ctx->msgs, stmt->map.set,
 				  "Expression does not refer to a set");
 
-	if (stmt_evaluate_arg(ctx, stmt,
+	if (stmt_evaluate_key(ctx, stmt,
 			      stmt->map.set->set->key->dtype,
 			      stmt->map.set->set->key->len,
 			      stmt->map.set->set->key->byteorder,
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_concat.nft b/tests/shell/testcases/maps/dumps/typeof_maps_concat.nft
new file mode 100644
index 000000000000..1ca98d811f7d
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_concat.nft
@@ -0,0 +1,11 @@
+table netdev t {
+	map m {
+		typeof ether saddr . vlan id : meta mark
+		size 1234
+		flags dynamic,timeout
+	}
+
+	chain c {
+		ether type != 8021q update @m { ether daddr . 123 timeout 1m : 0x0000002a } counter packets 0 bytes 0 return
+	}
+}
diff --git a/tests/shell/testcases/maps/typeof_maps_concat b/tests/shell/testcases/maps/typeof_maps_concat
new file mode 100755
index 000000000000..07820b7c4fdd
--- /dev/null
+++ b/tests/shell/testcases/maps/typeof_maps_concat
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+set -e
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+
+$NFT -f "$dumpfile"
diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_concat.nft b/tests/shell/testcases/sets/dumps/typeof_sets_concat.nft
new file mode 100644
index 000000000000..dbaf7cdc2d7d
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_concat.nft
@@ -0,0 +1,12 @@
+table netdev t {
+	set s {
+		typeof ether saddr . vlan id
+		size 2048
+		flags dynamic,timeout
+	}
+
+	chain c {
+		ether type != 8021q add @s { ether saddr . 0 timeout 5s } counter packets 0 bytes 0 return
+		ether type != 8021q update @s { ether daddr . 123 timeout 1m } counter packets 0 bytes 0 return
+	}
+}
diff --git a/tests/shell/testcases/sets/typeof_sets_concat b/tests/shell/testcases/sets/typeof_sets_concat
new file mode 100755
index 000000000000..07820b7c4fdd
--- /dev/null
+++ b/tests/shell/testcases/sets/typeof_sets_concat
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+set -e
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+
+$NFT -f "$dumpfile"
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0007-optimize-wrap-code-to-build-concatenation-in-helper-.patch"

From 4a400db3a7ba1440938131fc26811e5b784c8c44 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 2 Feb 2023 18:15:22 +0100
Subject: [PATCH nft,v1.0.6 07/41] optimize: wrap code to build concatenation
 in helper function

commit 9dbbf397b2f3d9fa40454648cb98c13c7c5515b7 upstream.

Move code to build concatenations into helper function, this routine
includes support for expansion of implicit sets containing singleton
values. This is preparation work to reuse existing code in a follow up
patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index d592aee02e14..c4f5b00854c0 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -550,20 +550,19 @@ static void merge_stmts(const struct optimize_ctx *ctx,
 	}
 }
 
-static void __merge_concat_stmts(const struct optimize_ctx *ctx, uint32_t i,
-				 const struct merge *merge, struct expr *set)
+static void __merge_concat(const struct optimize_ctx *ctx, uint32_t i,
+			   const struct merge *merge, struct list_head *concat_list)
 {
-	struct expr *concat, *next, *expr, *concat_clone, *clone, *elem;
+	struct expr *concat, *next, *expr, *concat_clone, *clone;
 	LIST_HEAD(pending_list);
-	LIST_HEAD(concat_list);
 	struct stmt *stmt_a;
 	uint32_t k;
 
 	concat = concat_expr_alloc(&internal_location);
-	list_add(&concat->list, &concat_list);
+	list_add(&concat->list, concat_list);
 
 	for (k = 0; k < merge->num_stmts; k++) {
-		list_for_each_entry_safe(concat, next, &concat_list, list) {
+		list_for_each_entry_safe(concat, next, concat_list, list) {
 			stmt_a = ctx->stmt_matrix[i][merge->stmt[k]];
 			switch (stmt_a->expr->right->etype) {
 			case EXPR_SET:
@@ -588,8 +587,17 @@ static void __merge_concat_stmts(const struct optimize_ctx *ctx, uint32_t i,
 				break;
 			}
 		}
-		list_splice_init(&pending_list, &concat_list);
+		list_splice_init(&pending_list, concat_list);
 	}
+}
+
+static void __merge_concat_stmts(const struct optimize_ctx *ctx, uint32_t i,
+				 const struct merge *merge, struct expr *set)
+{
+	struct expr *concat, *next, *elem;
+	LIST_HEAD(concat_list);
+
+	__merge_concat(ctx, i, merge, &concat_list);
 
 	list_for_each_entry_safe(concat, next, &concat_list, list) {
 		list_del(&concat->list);
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0008-optimize-fix-incorrect-expansion-into-concatenation-.patch"

From d13e3e5cc6185ce0e0e48852b16d50cac582e613 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 2 Feb 2023 21:47:56 +0100
Subject: [PATCH nft,v1.0.6 08/41] optimize: fix incorrect expansion into
 concatenation with verdict map

commit b691e2ea1d643adeb89c576a105f08cfff677cfb upstream.

 # nft -c -o -f ruleset.nft
 Merging:
 ruleset.nft:3:3-53:          meta pkttype broadcast udp dport { 67, 547 } accept
 ruleset.nft:4:17-58:         meta pkttype multicast udp dport 1900 drop
 into:
        meta pkttype . udp dport vmap { broadcast . { 67, 547 } : accept, multicast . 1900 : drop }
 ruleset.nft:3:38-39: Error: invalid data type, expected concatenation of (packet type, internet network service)
                meta pkttype broadcast udp dport { 67, 547 } accept
                                                   ^^

Similar to 187c6d01d357 ("optimize: expand implicit set element when
merging into concatenation") but for verdict maps.

Reported-by: Simon G. Trajkovski <neur0armitage@proton.me>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 33 ++++++++++++-------
 .../dumps/merge_stmts_concat_vmap.nft         |  4 +++
 .../optimizations/merge_stmts_concat_vmap     |  4 +++
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index c4f5b00854c0..794af452c911 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -736,14 +736,32 @@ static void merge_stmts_vmap(const struct optimize_ctx *ctx,
 	stmt_free(verdict_a);
 }
 
+static void __merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
+				      uint32_t i, const struct merge *merge,
+				      struct expr *set, struct stmt *verdict)
+{
+	struct expr *concat, *next, *elem, *mapping;
+	LIST_HEAD(concat_list);
+
+	__merge_concat(ctx, i, merge, &concat_list);
+
+	list_for_each_entry_safe(concat, next, &concat_list, list) {
+		list_del(&concat->list);
+		elem = set_elem_expr_alloc(&internal_location, concat);
+		mapping = mapping_expr_alloc(&internal_location, elem,
+					     expr_get(verdict->expr));
+		compound_expr_add(set, mapping);
+	}
+}
+
 static void merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
 				    uint32_t from, uint32_t to,
 				    const struct merge *merge)
 {
 	struct stmt *orig_stmt = ctx->stmt_matrix[from][merge->stmt[0]];
-	struct expr *concat_a, *concat_b, *expr, *set;
-	struct stmt *stmt, *stmt_a, *stmt_b, *verdict;
-	uint32_t i, j;
+	struct stmt *stmt, *stmt_a, *verdict;
+	struct expr *concat_a, *expr, *set;
+	uint32_t i;
 	int k;
 
 	k = stmt_verdict_find(ctx);
@@ -761,15 +779,8 @@ static void merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
 	set->set_flags |= NFT_SET_ANONYMOUS;
 
 	for (i = from; i <= to; i++) {
-		concat_b = concat_expr_alloc(&internal_location);
-		for (j = 0; j < merge->num_stmts; j++) {
-			stmt_b = ctx->stmt_matrix[i][merge->stmt[j]];
-			expr = stmt_b->expr->right;
-			compound_expr_add(concat_b, expr_get(expr));
-		}
 		verdict = ctx->stmt_matrix[i][k];
-		build_verdict_map(concat_b, verdict, set);
-		expr_free(concat_b);
+		__merge_concat_stmts_vmap(ctx, i, merge, set, verdict);
 	}
 
 	expr = map_expr_alloc(&internal_location, concat_a, set);
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft
index c0f9ce0ccb6c..780aa09adbe6 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft
@@ -1,4 +1,8 @@
 table ip x {
+	chain x {
+		meta pkttype . udp dport vmap { broadcast . 547 : accept, broadcast . 67 : accept, multicast . 1900 : drop }
+	}
+
 	chain y {
 		ip saddr . ip daddr vmap { 1.1.1.1 . 2.2.2.2 : accept, 2.2.2.2 . 3.3.3.3 : drop, 4.4.4.4 . 5.5.5.5 : accept }
 	}
diff --git a/tests/shell/testcases/optimizations/merge_stmts_concat_vmap b/tests/shell/testcases/optimizations/merge_stmts_concat_vmap
index 5c0ae60caafa..657d0aea2272 100755
--- a/tests/shell/testcases/optimizations/merge_stmts_concat_vmap
+++ b/tests/shell/testcases/optimizations/merge_stmts_concat_vmap
@@ -3,6 +3,10 @@
 set -e
 
 RULESET="table ip x {
+	chain x {
+		meta pkttype broadcast udp dport { 67, 547 } accept
+		meta pkttype multicast udp dport 1900 drop
+	}
 	chain y {
 		ip saddr 1.1.1.1 ip daddr 2.2.2.2 accept
 		ip saddr 4.4.4.4 ip daddr 5.5.5.5 accept
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0009-rule-add-helper-function-to-expand-chain-rules-into-.patch"

From 7f2f1152467e7b38c93abf5cfc3dcb84f23396e5 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 6 Feb 2023 15:28:40 +0100
Subject: [PATCH nft,v1.0.6 09/41] rule: add helper function to expand chain
 rules into commands

commit 784597a4ed63b9decb10d74fdb49a1b021e22728 upstream.

This patch adds a helper function to expand chain rules into commands.
This comes in preparation for the follow up patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 1402210acd8d..43c6520517ce 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1310,13 +1310,31 @@ void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc)
 	cmd->num_attrs++;
 }
 
+static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds)
+{
+	struct rule *rule;
+	struct handle h;
+	struct cmd *new;
+
+	list_for_each_entry(rule, &chain->rules, list) {
+		memset(&h, 0, sizeof(h));
+		handle_merge(&h, &rule->handle);
+		if (chain->flags & CHAIN_F_BINDING) {
+			rule->handle.chain_id = chain->handle.chain_id;
+			rule->handle.chain.location = chain->location;
+		}
+		new = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &h,
+				&rule->location, rule_get(rule));
+		list_add_tail(&new->list, new_cmds);
+	}
+}
+
 void nft_cmd_expand(struct cmd *cmd)
 {
 	struct list_head new_cmds;
 	struct flowtable *ft;
 	struct table *table;
 	struct chain *chain;
-	struct rule *rule;
 	struct set *set;
 	struct obj *obj;
 	struct cmd *new;
@@ -1362,22 +1380,9 @@ void nft_cmd_expand(struct cmd *cmd)
 					&ft->location, flowtable_get(ft));
 			list_add_tail(&new->list, &new_cmds);
 		}
-		list_for_each_entry(chain, &table->chains, list) {
-			list_for_each_entry(rule, &chain->rules, list) {
-				memset(&h, 0, sizeof(h));
-				handle_merge(&h, &rule->handle);
-				if (chain->flags & CHAIN_F_BINDING) {
-					rule->handle.chain_id =
-						chain->handle.chain_id;
-					rule->handle.chain.location =
-						chain->location;
-				}
-				new = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &h,
-						&rule->location,
-						rule_get(rule));
-				list_add_tail(&new->list, &new_cmds);
-			}
-		}
+		list_for_each_entry(chain, &table->chains, list)
+			nft_cmd_expand_chain(chain, &new_cmds);
+
 		list_splice(&new_cmds, &cmd->list);
 		break;
 	case CMD_OBJ_SET:
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0010-optimize-select-merge-criteria-based-on-candidates-r.patch"

From 3dd10c6f3def6ea46a9221ded487f0b4a3cc8ea4 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 6 Feb 2023 14:18:10 +0100
Subject: [PATCH nft,v1.0.6 10/41] optimize: select merge criteria based on
 candidates rules

commit 299823d46b6d0c49040d81ee3eb0f37b3b0520ea upstream.

Select the merge criteria based on the statements that are used
in the candidate rules, instead of using the list of statements
in the given chain.

Update tests to include a rule with a verdict, which triggers
the bug described in the bugzilla ticket.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1657
Fixes: 0a6dbfce6dc3 ("optimize: merge nat rules with same selectors into map")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 22 +++++++++----------
 .../optimizations/dumps/merge_nat.nft         |  4 ++++
 tests/shell/testcases/optimizations/merge_nat |  4 ++++
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 794af452c911..48f669c8462c 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -983,21 +983,21 @@ static void rule_optimize_print(struct output_ctx *octx,
 	fprintf(octx->error_fp, "%s\n", line);
 }
 
-static enum stmt_types merge_stmt_type(const struct optimize_ctx *ctx)
+static enum stmt_types merge_stmt_type(const struct optimize_ctx *ctx,
+				       uint32_t from, uint32_t to)
 {
-	uint32_t i;
+	uint32_t i, j;
 
-	for (i = 0; i < ctx->num_stmts; i++) {
-		switch (ctx->stmt[i]->ops->type) {
-		case STMT_VERDICT:
-		case STMT_NAT:
-			return ctx->stmt[i]->ops->type;
-		default:
-			continue;
+	for (i = from; i <= to; i++) {
+		for (j = 0; j < ctx->num_stmts; j++) {
+			if (!ctx->stmt_matrix[i][j])
+				continue;
+			if (ctx->stmt_matrix[i][j]->ops->type == STMT_NAT)
+				return STMT_NAT;
 		}
 	}
 
-	/* actually no verdict, this assumes rules have the same verdict. */
+	/* merge by verdict, even if no verdict is specified. */
 	return STMT_VERDICT;
 }
 
@@ -1010,7 +1010,7 @@ static void merge_rules(const struct optimize_ctx *ctx,
 	bool same_verdict;
 	uint32_t i;
 
-	stmt_type = merge_stmt_type(ctx);
+	stmt_type = merge_stmt_type(ctx, from, to);
 
 	switch (stmt_type) {
 	case STMT_VERDICT:
diff --git a/tests/shell/testcases/optimizations/dumps/merge_nat.nft b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
index 7a6ecb76a934..32423b220ed1 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_nat.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
@@ -1,20 +1,24 @@
 table ip test1 {
 	chain y {
+		oif "lo" accept
 		dnat to ip saddr map { 4.4.4.4 : 1.1.1.1, 5.5.5.5 : 2.2.2.2 }
 	}
 }
 table ip test2 {
 	chain y {
+		oif "lo" accept
 		dnat ip to tcp dport map { 80 : 1.1.1.1 . 8001, 81 : 2.2.2.2 . 9001 }
 	}
 }
 table ip test3 {
 	chain y {
+		oif "lo" accept
 		snat to ip saddr . tcp sport map { 1.1.1.1 . 1024-65535 : 3.3.3.3, 2.2.2.2 . 1024-65535 : 4.4.4.4 }
 	}
 }
 table ip test4 {
 	chain y {
+		oif "lo" accept
 		dnat ip to ip daddr . tcp dport map { 1.1.1.1 . 80 : 4.4.4.4 . 8000, 2.2.2.2 . 81 : 3.3.3.3 . 9000 }
 	}
 }
diff --git a/tests/shell/testcases/optimizations/merge_nat b/tests/shell/testcases/optimizations/merge_nat
index 290cfcfebe2e..ec9b239c6f48 100755
--- a/tests/shell/testcases/optimizations/merge_nat
+++ b/tests/shell/testcases/optimizations/merge_nat
@@ -4,6 +4,7 @@ set -e
 
 RULESET="table ip test1 {
         chain y {
+                oif lo accept
                 ip saddr 4.4.4.4 dnat to 1.1.1.1
                 ip saddr 5.5.5.5 dnat to 2.2.2.2
         }
@@ -13,6 +14,7 @@ $NFT -o -f - <<< $RULESET
 
 RULESET="table ip test2 {
         chain y {
+                oif lo accept
                 tcp dport 80 dnat to 1.1.1.1:8001
                 tcp dport 81 dnat to 2.2.2.2:9001
         }
@@ -22,6 +24,7 @@ $NFT -o -f - <<< $RULESET
 
 RULESET="table ip test3 {
         chain y {
+                oif lo accept
                 ip saddr 1.1.1.1 tcp sport 1024-65535 snat to 3.3.3.3
                 ip saddr 2.2.2.2 tcp sport 1024-65535 snat to 4.4.4.4
         }
@@ -31,6 +34,7 @@ $NFT -o -f - <<< $RULESET
 
 RULESET="table ip test4 {
         chain y {
+                oif lo accept
                 ip daddr 1.1.1.1 tcp dport 80 dnat to 4.4.4.4:8000
                 ip daddr 2.2.2.2 tcp dport 81 dnat to 3.3.3.3:9000
         }
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0011-rule-expand-standalone-chain-that-contains-rules.patch"

From ed14e81330327e9168465367ab243994104231b4 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 6 Feb 2023 15:28:41 +0100
Subject: [PATCH nft,v1.0.6 11/41] rule: expand standalone chain that contains
 rules

commit 27c753e4a8d4744f479345e3f5e34cafef751602 upstream.

Otherwise rules that this chain contains are ignored when expressed
using the following syntax:

chain inet filter input2 {
       type filter hook input priority filter; policy accept;
       ip saddr 1.2.3.4 tcp dport { 22, 443, 123 } drop
}

When expanding the chain, remove the rule so the new CMD_OBJ_CHAIN
case does not expand it again.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1655
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c                                    | 15 +++++++++---
 .../testcases/include/0020include_chain_0     | 23 +++++++++++++++++++
 .../include/dumps/0020include_chain_0.nft     |  6 +++++
 3 files changed, 41 insertions(+), 3 deletions(-)
 create mode 100755 tests/shell/testcases/include/0020include_chain_0
 create mode 100644 tests/shell/testcases/include/dumps/0020include_chain_0.nft

diff --git a/src/rule.c b/src/rule.c
index 43c6520517ce..323d89afd141 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1312,11 +1312,12 @@ void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc)
 
 static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds)
 {
-	struct rule *rule;
+	struct rule *rule, *next;
 	struct handle h;
 	struct cmd *new;
 
-	list_for_each_entry(rule, &chain->rules, list) {
+	list_for_each_entry_safe(rule, next, &chain->rules, list) {
+		list_del(&rule->list);
 		memset(&h, 0, sizeof(h));
 		handle_merge(&h, &rule->handle);
 		if (chain->flags & CHAIN_F_BINDING) {
@@ -1324,7 +1325,7 @@ static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds
 			rule->handle.chain.location = chain->location;
 		}
 		new = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &h,
-				&rule->location, rule_get(rule));
+				&rule->location, rule);
 		list_add_tail(&new->list, new_cmds);
 	}
 }
@@ -1385,6 +1386,14 @@ void nft_cmd_expand(struct cmd *cmd)
 
 		list_splice(&new_cmds, &cmd->list);
 		break;
+	case CMD_OBJ_CHAIN:
+		chain = cmd->chain;
+		if (!chain || list_empty(&chain->rules))
+			break;
+
+		nft_cmd_expand_chain(chain, &new_cmds);
+		list_splice(&new_cmds, &cmd->list);
+		break;
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
 		set = cmd->set;
diff --git a/tests/shell/testcases/include/0020include_chain_0 b/tests/shell/testcases/include/0020include_chain_0
new file mode 100755
index 000000000000..8f78e8c606ec
--- /dev/null
+++ b/tests/shell/testcases/include/0020include_chain_0
@@ -0,0 +1,23 @@
+#!/bin/bash
+
+set -e
+
+tmpfile1=$(mktemp -p .)
+if [ ! -w $tmpfile1 ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile1" EXIT # cleanup if aborted
+
+RULESET="table inet filter { }
+include \"$tmpfile1\""
+
+RULESET2="chain inet filter input2 {
+	type filter hook input priority filter; policy accept;
+	ip saddr 1.2.3.4 tcp dport { 22, 443, 123 } drop
+}"
+
+echo "$RULESET2" > $tmpfile1
+
+$NFT -o -f - <<< $RULESET
diff --git a/tests/shell/testcases/include/dumps/0020include_chain_0.nft b/tests/shell/testcases/include/dumps/0020include_chain_0.nft
new file mode 100644
index 000000000000..3ad6db14d2f5
--- /dev/null
+++ b/tests/shell/testcases/include/dumps/0020include_chain_0.nft
@@ -0,0 +1,6 @@
+table inet filter {
+	chain input2 {
+		type filter hook input priority filter; policy accept;
+		ip saddr 1.2.3.4 tcp dport { 22, 123, 443 } drop
+	}
+}
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0012-optimize-ignore-existing-nat-mapping.patch"

From 5be12083db7c9e86b24fa8431cdf21482896444a Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 7 Feb 2023 10:53:41 +0100
Subject: [PATCH nft,v1.0.6 12/41] optimize: ignore existing nat mapping

commit 9be404a153bc9525d52afabed622843717c37851 upstream.

User might be already using a nat mapping in their ruleset, use the
unsupported statement when collecting statements in this case.

 # nft -c -o -f ruleset.nft
 nft: optimize.c:443: rule_build_stmt_matrix_stmts: Assertion `k >= 0' failed.
 Aborted

The -o/--optimize feature only cares about linear rulesets at this
stage, but do not hit assert() in this case.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1656
Fixes: 0a6dbfce6dc3 ("optimize: merge nat rules with same selectors into map")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                          | 7 +++++++
 tests/shell/testcases/optimizations/dumps/merge_nat.nft | 1 +
 tests/shell/testcases/optimizations/merge_nat           | 1 +
 3 files changed, 9 insertions(+)

diff --git a/src/optimize.c b/src/optimize.c
index 48f669c8462c..98977f03f28a 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -368,6 +368,13 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 				clone->log.prefix = expr_get(stmt->log.prefix);
 			break;
 		case STMT_NAT:
+			if ((stmt->nat.addr &&
+			     stmt->nat.addr->etype == EXPR_MAP) ||
+			    (stmt->nat.proto &&
+			     stmt->nat.proto->etype == EXPR_MAP)) {
+				clone->ops = &unsupported_stmt_ops;
+				break;
+			}
 			clone->nat.type = stmt->nat.type;
 			clone->nat.family = stmt->nat.family;
 			if (stmt->nat.addr)
diff --git a/tests/shell/testcases/optimizations/dumps/merge_nat.nft b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
index 32423b220ed1..96e38ccd798a 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_nat.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
@@ -14,6 +14,7 @@ table ip test3 {
 	chain y {
 		oif "lo" accept
 		snat to ip saddr . tcp sport map { 1.1.1.1 . 1024-65535 : 3.3.3.3, 2.2.2.2 . 1024-65535 : 4.4.4.4 }
+		oifname "enp2s0" snat ip to ip saddr map { 10.1.1.0/24 : 72.2.3.66-72.2.3.78 }
 	}
 }
 table ip test4 {
diff --git a/tests/shell/testcases/optimizations/merge_nat b/tests/shell/testcases/optimizations/merge_nat
index ec9b239c6f48..1484b7d39d48 100755
--- a/tests/shell/testcases/optimizations/merge_nat
+++ b/tests/shell/testcases/optimizations/merge_nat
@@ -27,6 +27,7 @@ RULESET="table ip test3 {
                 oif lo accept
                 ip saddr 1.1.1.1 tcp sport 1024-65535 snat to 3.3.3.3
                 ip saddr 2.2.2.2 tcp sport 1024-65535 snat to 4.4.4.4
+                oifname enp2s0 snat ip to ip saddr map { 10.1.1.0/24 : 72.2.3.66-72.2.3.78 }
         }
 }"
 
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0013-optimize-infer-family-for-nat-mapping.patch"

From 28d3d0ea260e8a9ab4fc319f8ae0ce15cfc8204b Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 15 Feb 2023 19:20:22 +0100
Subject: [PATCH nft,v1.0.6 13/41] optimize: infer family for nat mapping

commit 114ba9606cb5ad85b2215e59f8af8ad97a16cac8 upstream.

Infer family from key in nat mapping, otherwise nat mapping via merge
breaks since family is not specified.

Merging:
fw-test-bug2.nft:4:9-78:         iifname enp2s0 ip daddr 72.2.3.66 tcp dport 53122 dnat to 10.1.1.10:22
fw-test-bug2.nft:5:9-77:         iifname enp2s0 ip daddr 72.2.3.66 tcp dport 443 dnat to 10.1.1.52:443
fw-test-bug2.nft:6:9-75:         iifname enp2s0 ip daddr 72.2.3.70 tcp dport 80 dnat to 10.1.1.52:80
into:
        dnat ip to iifname . ip daddr . tcp dport map { enp2s0 . 72.2.3.66 . 53122 : 10.1.1.10 . 22, enp2s0 . 72.2.3.66 . 443 : 10.1.1.52 . 443, enp2s0 . 72.2.3.70 . 80 : 10.1.1.52 . 80 }

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1657
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 23 +++++++++++++++++--
 .../optimizations/dumps/merge_nat.nft         | 11 +++++++++
 tests/shell/testcases/optimizations/merge_nat | 16 +++++++++++++
 .../shell/testcases/sets/dumps/0047nat_0.nft  | 11 +++++++++
 4 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 98977f03f28a..e54693fdf67c 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -21,6 +21,7 @@
 #include <statement.h>
 #include <utils.h>
 #include <erec.h>
+#include <linux/netfilter.h>
 
 #define MAX_STMTS	32
 
@@ -870,9 +871,9 @@ static void merge_nat(const struct optimize_ctx *ctx,
 		      const struct merge *merge)
 {
 	struct expr *expr, *set, *elem, *nat_expr, *mapping, *left;
+	int k, family = NFPROTO_UNSPEC;
 	struct stmt *stmt, *nat_stmt;
 	uint32_t i;
-	int k;
 
 	k = stmt_nat_find(ctx);
 	assert(k >= 0);
@@ -894,9 +895,18 @@ static void merge_nat(const struct optimize_ctx *ctx,
 
 	stmt = ctx->stmt_matrix[from][merge->stmt[0]];
 	left = expr_get(stmt->expr->left);
+	if (left->etype == EXPR_PAYLOAD) {
+		if (left->payload.desc == &proto_ip)
+			family = NFPROTO_IPV4;
+		else if (left->payload.desc == &proto_ip6)
+			family = NFPROTO_IPV6;
+	}
 	expr = map_expr_alloc(&internal_location, left, set);
 
 	nat_stmt = ctx->stmt_matrix[from][k];
+	if (nat_stmt->nat.family == NFPROTO_UNSPEC)
+		nat_stmt->nat.family = family;
+
 	expr_free(nat_stmt->nat.addr);
 	nat_stmt->nat.addr = expr;
 
@@ -910,9 +920,9 @@ static void merge_concat_nat(const struct optimize_ctx *ctx,
 			     const struct merge *merge)
 {
 	struct expr *expr, *set, *elem, *nat_expr, *mapping, *left, *concat;
+	int k, family = NFPROTO_UNSPEC;
 	struct stmt *stmt, *nat_stmt;
 	uint32_t i, j;
-	int k;
 
 	k = stmt_nat_find(ctx);
 	assert(k >= 0);
@@ -941,11 +951,20 @@ static void merge_concat_nat(const struct optimize_ctx *ctx,
 	for (j = 0; j < merge->num_stmts; j++) {
 		stmt = ctx->stmt_matrix[from][merge->stmt[j]];
 		left = stmt->expr->left;
+		if (left->etype == EXPR_PAYLOAD) {
+			if (left->payload.desc == &proto_ip)
+				family = NFPROTO_IPV4;
+			else if (left->payload.desc == &proto_ip6)
+				family = NFPROTO_IPV6;
+		}
 		compound_expr_add(concat, expr_get(left));
 	}
 	expr = map_expr_alloc(&internal_location, concat, set);
 
 	nat_stmt = ctx->stmt_matrix[from][k];
+	if (nat_stmt->nat.family == NFPROTO_UNSPEC)
+		nat_stmt->nat.family = family;
+
 	expr_free(nat_stmt->nat.addr);
 	nat_stmt->nat.addr = expr;
 
diff --git a/tests/shell/testcases/optimizations/dumps/merge_nat.nft b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
index 96e38ccd798a..dd17905dbfeb 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_nat.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
@@ -23,3 +23,14 @@ table ip test4 {
 		dnat ip to ip daddr . tcp dport map { 1.1.1.1 . 80 : 4.4.4.4 . 8000, 2.2.2.2 . 81 : 3.3.3.3 . 9000 }
 	}
 }
+table inet nat {
+	chain prerouting {
+		oif "lo" accept
+		dnat ip to iifname . ip daddr . tcp dport map { "enp2s0" . 72.2.3.70 . 80 : 10.1.1.52 . 80, "enp2s0" . 72.2.3.66 . 53122 : 10.1.1.10 . 22, "enp2s0" . 72.2.3.66 . 443 : 10.1.1.52 . 443 }
+	}
+
+	chain postrouting {
+		oif "lo" accept
+		snat ip to ip daddr map { 72.2.3.66 : 10.2.2.2, 72.2.3.67 : 10.2.3.3 }
+	}
+}
diff --git a/tests/shell/testcases/optimizations/merge_nat b/tests/shell/testcases/optimizations/merge_nat
index 1484b7d39d48..edf7f4c438b9 100755
--- a/tests/shell/testcases/optimizations/merge_nat
+++ b/tests/shell/testcases/optimizations/merge_nat
@@ -42,3 +42,19 @@ RULESET="table ip test4 {
 }"
 
 $NFT -o -f - <<< $RULESET
+
+RULESET="table inet nat {
+	chain prerouting {
+		oif lo accept
+		iifname enp2s0 ip daddr 72.2.3.66 tcp dport 53122 dnat to 10.1.1.10:22
+		iifname enp2s0 ip daddr 72.2.3.66 tcp dport 443 dnat to 10.1.1.52:443
+		iifname enp2s0 ip daddr 72.2.3.70 tcp dport 80 dnat to 10.1.1.52:80
+	}
+	chain postrouting {
+		oif lo accept
+		ip daddr 72.2.3.66 snat to 10.2.2.2
+		ip daddr 72.2.3.67 snat to 10.2.3.3
+	}
+}"
+
+$NFT -o -f - <<< $RULESET
diff --git a/tests/shell/testcases/sets/dumps/0047nat_0.nft b/tests/shell/testcases/sets/dumps/0047nat_0.nft
index e796805471a3..97c04a1637a2 100644
--- a/tests/shell/testcases/sets/dumps/0047nat_0.nft
+++ b/tests/shell/testcases/sets/dumps/0047nat_0.nft
@@ -11,3 +11,14 @@ table ip x {
 		snat ip to ip saddr map @y
 	}
 }
+table inet x {
+	chain x {
+		type nat hook prerouting priority dstnat; policy accept;
+		dnat ip to ip daddr . tcp dport map { 10.141.10.1 . 22 : 192.168.2.2, 10.141.11.2 . 2222 : 192.168.4.2 }
+	}
+
+	chain y {
+		type nat hook postrouting priority srcnat; policy accept;
+		snat ip to ip saddr map { 10.141.10.0/24 : 192.168.2.2-192.168.2.4, 10.141.11.0/24 : 192.168.4.2/31 }
+	}
+}
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0014-evaluate-infer-family-from-mapping.patch"

From 7b2e72bd84de3bdd80c70b9b52ba483218c41f32 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 16 Feb 2023 15:41:30 +0100
Subject: [PATCH nft,v1.0.6 14/41] evaluate: infer family from mapping

commit 2f4935a8d7aeb6b2e019aebb961a579d9950c74a upstream backport.

If the key in the nat mapping is either ip or ip6, then set the nat
family accordingly, no need for explicit family in the nat statement.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                       | 45 ++++++++++++++++++++++++----
 tests/shell/testcases/sets/0047nat_0 | 14 +++++++++
 2 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 230f0ed7859c..de6f66a639db 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3379,15 +3379,47 @@ static int stmt_evaluate_l3proto(struct eval_ctx *ctx,
 	return 0;
 }
 
+static void expr_family_infer(struct proto_ctx *pctx, const struct expr *expr,
+			      uint8_t *family)
+{
+	struct expr *i;
+
+	if (expr->etype == EXPR_MAP) {
+		switch (expr->map->etype) {
+		case EXPR_CONCAT:
+			list_for_each_entry(i, &expr->map->expressions, list) {
+				if (i->etype == EXPR_PAYLOAD) {
+					if (i->payload.desc == &proto_ip)
+						*family = NFPROTO_IPV4;
+					else if (i->payload.desc == &proto_ip6)
+						*family = NFPROTO_IPV6;
+				}
+			}
+			break;
+		case EXPR_PAYLOAD:
+			if (expr->map->payload.desc == &proto_ip)
+				*family = NFPROTO_IPV4;
+			else if (expr->map->payload.desc == &proto_ip6)
+				*family = NFPROTO_IPV6;
+			break;
+		default:
+			break;
+		}
+	}
+}
+
 static int stmt_evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
-			      uint8_t family,
-			      struct expr **addr)
+			      uint8_t *family, struct expr **addr)
 {
 	const struct datatype *dtype;
 	int err;
 
 	if (ctx->pctx.family == NFPROTO_INET) {
-		dtype = get_addr_dtype(family);
+		if (*family == NFPROTO_INET ||
+		    *family == NFPROTO_UNSPEC)
+			expr_family_infer(&ctx->pctx, *addr, family);
+
+		dtype = get_addr_dtype(*family);
 		if (dtype->size == 0)
 			return stmt_error(ctx, stmt,
 					  "ip or ip6 must be specified with address for inet tables.");
@@ -3408,6 +3440,9 @@ static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
 	const struct datatype *dtype;
 	int addr_type, err;
 
+	if (stmt->nat.family == NFPROTO_INET)
+		expr_family_infer(pctx, stmt->nat.addr, &stmt->nat.family);
+
 	switch (stmt->nat.family) {
 	case NFPROTO_IPV4:
 		addr_type = TYPE_IPADDR;
@@ -3532,7 +3567,7 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 			return 0;
 		}
 
-		err = stmt_evaluate_addr(ctx, stmt, stmt->nat.family,
+		err = stmt_evaluate_addr(ctx, stmt, &stmt->nat.family,
 					 &stmt->nat.addr);
 		if (err < 0)
 			return err;
@@ -3582,7 +3617,7 @@ static int stmt_evaluate_tproxy(struct eval_ctx *ctx, struct stmt *stmt)
 		if (stmt->tproxy.addr->etype == EXPR_RANGE)
 			return stmt_error(ctx, stmt, "Address ranges are not supported for tproxy.");
 
-		err = stmt_evaluate_addr(ctx, stmt, stmt->tproxy.family,
+		err = stmt_evaluate_addr(ctx, stmt, &stmt->tproxy.family,
 					 &stmt->tproxy.addr);
 
 		if (err < 0)
diff --git a/tests/shell/testcases/sets/0047nat_0 b/tests/shell/testcases/sets/0047nat_0
index cb1d4d68d2d2..d19f5b69fd33 100755
--- a/tests/shell/testcases/sets/0047nat_0
+++ b/tests/shell/testcases/sets/0047nat_0
@@ -18,3 +18,17 @@ EXPECTED="table ip x {
 set -e
 $NFT -f - <<< $EXPECTED
 $NFT add element x y { 10.141.12.0/24 : 192.168.5.10-192.168.5.20 }
+
+EXPECTED="table inet x {
+            chain x {
+                    type nat hook prerouting priority dstnat; policy accept;
+                    dnat to ip daddr . tcp dport map { 10.141.10.1 . 22 : 192.168.2.2, 10.141.11.2 . 2222 : 192.168.4.2 }
+            }
+
+            chain y {
+                    type nat hook postrouting priority srcnat; policy accept;
+                    snat to ip saddr map { 10.141.10.0/24 : 192.168.2.2-192.168.2.4, 10.141.11.0/24 : 192.168.4.2-192.168.4.3 }
+            }
+}"
+
+$NFT -f - <<< $EXPECTED
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0015-evaluate-expand-value-to-range-when-nat-mapping-cont.patch"

From 30c7efb6ece47022ab54b3d5a5846e99b3718771 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 17 Feb 2023 15:10:44 +0100
Subject: [PATCH nft,v1.0.6 15/41] evaluate: expand value to range when nat
 mapping contains intervals

commit ddb962604cda323f15589f3b424c4618db7494de upstream.

If the data in the mapping contains a range, then upgrade value to range.
Otherwise, the following error is displayed:

/dev/stdin:11:57-75: Error: Could not process rule: Invalid argument
dnat ip to iifname . ip saddr map { enp2s0 . 10.1.1.136 : 1.1.2.69, enp2s0 . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
                                    ^^^^^^^^^^^^^^^^^^^

The kernel rejects this command because userspace sends a single value
while the kernel expects the range that represents the min and the max
IP address to be used for NAT. The upgrade is also done when concatenation
with intervals is used in the rhs of the mapping.

For anonymous sets, expansion cannot be done from expr_evaluate_mapping()
because the EXPR_F_INTERVAL flag is inferred from the elements. For
explicit sets, this can be done from expr_evaluate_mapping() because the
user already specifies the interval flag in the rhs of the map definition.

Update tests/shell and tests/py to improve testing coverage in this case.

Fixes: 9599d9d25a6b ("src: NAT support for intervals in maps")
Fixes: 66746e7dedeb ("src: support for nat with interval concatenation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                |  47 +++++-
 tests/py/ip/dnat.t                            |   2 +
 tests/py/ip/dnat.t.json                       | 146 ++++++++++++++++++
 tests/py/ip/dnat.t.payload.ip                 |  22 +++
 tests/shell/testcases/sets/0047nat_0          |   6 +
 .../testcases/sets/0067nat_concat_interval_0  |  27 ++++
 .../shell/testcases/sets/dumps/0047nat_0.nft  |   6 +
 .../sets/dumps/0067nat_concat_interval_0.nft  |  16 ++
 8 files changed, 270 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index de6f66a639db..5ecde2410184 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1707,10 +1707,45 @@ static void map_set_concat_info(struct expr *map)
 	}
 }
 
+static void __mapping_expr_expand(struct expr *i)
+{
+	struct expr *j, *range, *next;
+
+	assert(i->etype == EXPR_MAPPING);
+	switch (i->right->etype) {
+	case EXPR_VALUE:
+		range = range_expr_alloc(&i->location, expr_get(i->right), expr_get(i->right));
+		expr_free(i->right);
+		i->right = range;
+		break;
+	case EXPR_CONCAT:
+		list_for_each_entry_safe(j, next, &i->right->expressions, list) {
+			if (j->etype != EXPR_VALUE)
+				continue;
+
+			range = range_expr_alloc(&j->location, expr_get(j), expr_get(j));
+			list_replace(&j->list, &range->list);
+			expr_free(j);
+		}
+		i->right->flags &= ~EXPR_F_SINGLETON;
+		break;
+	default:
+		break;
+	}
+}
+
+static void mapping_expr_expand(struct expr *init)
+{
+	struct expr *i;
+
+	list_for_each_entry(i, &init->expressions, list)
+		__mapping_expr_expand(i);
+}
+
 static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 {
-	struct expr_ctx ectx = ctx->ectx;
 	struct expr *map = *expr, *mappings;
+	struct expr_ctx ectx = ctx->ectx;
 	const struct datatype *dtype;
 	struct expr *key, *data;
 
@@ -1781,9 +1816,13 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		if (binop_transfer(ctx, expr) < 0)
 			return -1;
 
-		if (ctx->set->data->flags & EXPR_F_INTERVAL)
+		if (ctx->set->data->flags & EXPR_F_INTERVAL) {
 			ctx->set->data->len *= 2;
 
+			if (set_is_anonymous(ctx->set->flags))
+				mapping_expr_expand(ctx->set->init);
+		}
+
 		ctx->set->key->len = ctx->ectx.len;
 		ctx->set = NULL;
 		map = *expr;
@@ -1886,6 +1925,10 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	    data_mapping_has_interval(mapping->right))
 		set->data->flags |= EXPR_F_INTERVAL;
 
+	if (!set_is_anonymous(set->flags) &&
+	    set->data->flags & EXPR_F_INTERVAL)
+		__mapping_expr_expand(mapping);
+
 	if (!(set->data->flags & EXPR_F_INTERVAL) &&
 	    !expr_is_singleton(mapping->right))
 		return expr_error(ctx->msgs, mapping->right,
diff --git a/tests/py/ip/dnat.t b/tests/py/ip/dnat.t
index 889f0fd7bf6c..881571db2f83 100644
--- a/tests/py/ip/dnat.t
+++ b/tests/py/ip/dnat.t
@@ -19,3 +19,5 @@ dnat ip to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.0/24  . 8888
 dnat ip to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.0/24  . 80 };ok
 dnat ip to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.2 . 8888 - 8999 };ok
 ip daddr 192.168.0.1 dnat ip to tcp dport map { 443 : 10.141.10.4 . 8443, 80 : 10.141.10.4 . 8080 };ok
+meta l4proto 6 dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 };ok
+dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69/32, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 };ok
diff --git a/tests/py/ip/dnat.t.json b/tests/py/ip/dnat.t.json
index ede4d04bdb10..fe15d0726302 100644
--- a/tests/py/ip/dnat.t.json
+++ b/tests/py/ip/dnat.t.json
@@ -595,3 +595,149 @@
     }
 ]
 
+# meta l4proto 6 dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 6
+        }
+    },
+    {
+        "dnat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                {
+                                    "concat": [
+                                        "enp2s0",
+                                        "10.1.1.136"
+                                    ]
+                                },
+                                {
+                                    "concat": [
+                                        "1.1.2.69",
+                                        22
+                                    ]
+                                }
+                            ],
+                            [
+                                {
+                                    "concat": [
+                                        "enp2s0",
+                                        {
+                                            "range": [
+                                                "10.1.1.1",
+                                                "10.1.1.135"
+                                            ]
+                                        }
+                                    ]
+                                },
+                                {
+                                    "concat": [
+                                        {
+                                            "range": [
+                                                "1.1.2.66",
+                                                "1.84.236.78"
+                                            ]
+                                        },
+                                        22
+                                    ]
+                                }
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "concat": [
+                            {
+                                "meta": {
+                                    "key": "iifname"
+                                }
+                            },
+                            {
+                                "payload": {
+                                    "field": "saddr",
+                                    "protocol": "ip"
+                                }
+                            }
+                        ]
+                    }
+                }
+            },
+            "family": "ip"
+        }
+    }
+]
+
+# dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69/32, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+[
+    {
+        "dnat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                {
+                                    "concat": [
+                                        "enp2s0",
+                                        "10.1.1.136"
+                                    ]
+                                },
+                                {
+                                    "prefix": {
+                                        "addr": "1.1.2.69",
+                                        "len": 32
+                                    }
+                                }
+                            ],
+                            [
+                                {
+                                    "concat": [
+                                        "enp2s0",
+                                        {
+                                            "range": [
+                                                "10.1.1.1",
+                                                "10.1.1.135"
+                                            ]
+                                        }
+                                    ]
+                                },
+                                {
+                                    "range": [
+                                        "1.1.2.66",
+                                        "1.84.236.78"
+                                    ]
+                                }
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "concat": [
+                            {
+                                "meta": {
+                                    "key": "iifname"
+                                }
+                            },
+                            {
+                                "payload": {
+                                    "field": "saddr",
+                                    "protocol": "ip"
+                                }
+                            }
+                        ]
+                    }
+                }
+            },
+            "family": "ip"
+        }
+    }
+]
+
diff --git a/tests/py/ip/dnat.t.payload.ip b/tests/py/ip/dnat.t.payload.ip
index e53838a32262..439c6abef03f 100644
--- a/tests/py/ip/dnat.t.payload.ip
+++ b/tests/py/ip/dnat.t.payload.ip
@@ -180,3 +180,25 @@ ip
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 proto_min reg 9 ]
 
+# meta l4proto 6 dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+__map%d test-ip4 8f size 2
+__map%d test-ip4 0
+        element 32706e65 00003073 00000000 00000000 8801010a  - 32706e65 00003073 00000000 00000000 8801010a  : 45020101 00001600 45020101 00001600 0 [end]     element 32706e65 00003073 00000000 00000000 0101010a  - 32706e65 00003073 00000000 00000000 8701010a  : 42020101 00001600 4eec5401 00001600 0 [end]
+ip test-ip4 prerouting
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ meta load iifname => reg 1 ]
+  [ payload load 4b @ network header + 12 => reg 2 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 10 proto_min reg 9 proto_max reg 11 ]
+
+# dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69/32, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+__map%d test-ip4 8f size 2
+__map%d test-ip4 0
+        element 32706e65 00003073 00000000 00000000 8801010a  - 32706e65 00003073 00000000 00000000 8801010a  : 45020101 45020101 0 [end]       element 32706e65 00003073 00000000 00000000 0101010a  - 32706e65 00003073 00000000 00000000 8701010a  : 42020101 4eec5401 0 [end]
+ip test-ip4 prerouting
+  [ meta load iifname => reg 1 ]
+  [ payload load 4b @ network header + 12 => reg 2 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 9 ]
+
diff --git a/tests/shell/testcases/sets/0047nat_0 b/tests/shell/testcases/sets/0047nat_0
index d19f5b69fd33..4e53b7b8e8c8 100755
--- a/tests/shell/testcases/sets/0047nat_0
+++ b/tests/shell/testcases/sets/0047nat_0
@@ -8,6 +8,12 @@ EXPECTED="table ip x {
 				 10.141.11.0/24 : 192.168.4.2-192.168.4.3 }
             }
 
+            chain x {
+                    type nat hook prerouting priority dstnat; policy accept;
+                    meta l4proto tcp dnat ip to iifname . ip saddr map { enp2s0 . 10.1.1.136 : 1.1.2.69 . 22, enp2s0 . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+                    dnat ip to iifname . ip saddr map { enp2s0 . 10.1.1.136 : 1.1.2.69, enp2s0 . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+            }
+
             chain y {
                     type nat hook postrouting priority srcnat; policy accept;
                     snat to ip saddr map @y
diff --git a/tests/shell/testcases/sets/0067nat_concat_interval_0 b/tests/shell/testcases/sets/0067nat_concat_interval_0
index 530771b0016c..55cc0d4b43df 100755
--- a/tests/shell/testcases/sets/0067nat_concat_interval_0
+++ b/tests/shell/testcases/sets/0067nat_concat_interval_0
@@ -42,3 +42,30 @@ EXPECTED="table ip nat {
 
 $NFT -f - <<< $EXPECTED
 $NFT add rule ip nat prerouting meta l4proto { tcp, udp } dnat to ip daddr . th dport map @fwdtoip_th
+
+EXPECTED="table ip nat {
+        map ipportmap4 {
+		typeof iifname . ip saddr : interval ip daddr
+		flags interval
+		elements = { enp2s0 . 10.1.1.136 : 1.1.2.69, enp2s0 . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+	}
+	chain prerouting {
+		type nat hook prerouting priority dstnat; policy accept;
+		dnat to iifname . ip saddr map @ipportmap4
+	}
+}"
+
+$NFT -f - <<< $EXPECTED
+EXPECTED="table ip nat {
+        map ipportmap5 {
+		typeof iifname . ip saddr : interval ip daddr . tcp dport
+		flags interval
+		elements = { enp2s0 . 10.1.1.136 : 1.1.2.69 . 22, enp2s0 . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+	}
+	chain prerouting {
+		type nat hook prerouting priority dstnat; policy accept;
+		meta l4proto tcp dnat ip to iifname . ip saddr map @ipportmap5
+	}
+}"
+
+$NFT -f - <<< $EXPECTED
diff --git a/tests/shell/testcases/sets/dumps/0047nat_0.nft b/tests/shell/testcases/sets/dumps/0047nat_0.nft
index 97c04a1637a2..9fa9fc7456c5 100644
--- a/tests/shell/testcases/sets/dumps/0047nat_0.nft
+++ b/tests/shell/testcases/sets/dumps/0047nat_0.nft
@@ -6,6 +6,12 @@ table ip x {
 			     10.141.12.0/24 : 192.168.5.10-192.168.5.20 }
 	}
 
+	chain x {
+		type nat hook prerouting priority dstnat; policy accept;
+		meta l4proto tcp dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+		dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69/32, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+	}
+
 	chain y {
 		type nat hook postrouting priority srcnat; policy accept;
 		snat ip to ip saddr map @y
diff --git a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
index 3226da157272..6af47c6682ce 100644
--- a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
+++ b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
@@ -17,10 +17,26 @@ table ip nat {
 		elements = { 1.2.3.4 . 10000-20000 : 192.168.3.4 . 30000-40000 }
 	}
 
+	map ipportmap4 {
+		type ifname . ipv4_addr : interval ipv4_addr
+		flags interval
+		elements = { "enp2s0" . 10.1.1.136 : 1.1.2.69/32,
+			     "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+	}
+
+	map ipportmap5 {
+		type ifname . ipv4_addr : interval ipv4_addr . inet_service
+		flags interval
+		elements = { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22,
+			     "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+	}
+
 	chain prerouting {
 		type nat hook prerouting priority dstnat; policy accept;
 		ip protocol tcp dnat ip to ip saddr map @ipportmap
 		ip protocol tcp dnat ip to ip saddr . ip daddr map @ipportmap2
 		meta l4proto { tcp, udp } dnat ip to ip daddr . th dport map @fwdtoip_th
+		dnat ip to iifname . ip saddr map @ipportmap4
+		meta l4proto tcp dnat ip to iifname . ip saddr map @ipportmap5
 	}
 }
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0016-src-expand-table-command-before-evaluation.patch"

From caeea2998243e035c127d9cac64db6a7ed89e69b Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 23 Feb 2023 19:55:39 +0100
Subject: [PATCH nft,v1.0.6 16/41] src: expand table command before evaluation

commit 3975430b12d97c92cdf03753342f2269153d5624 upstream.

The nested syntax notation results in one single table command which
includes all other objects. This differs from the flat notation where
there is usually one command per object.

This patch adds a previous step to the evaluation phase to expand the
objects that are contained in the table into independent commands, so
both notations have similar representations.

Remove the code to evaluate the nested representation in the evaluation
phase since commands are independently evaluated after the expansion.

The commands are expanded after the set element collapse step, in case
that there is a long list of singleton element commands to be added to
the set, to shorten the command list iteration.

This approach also avoids interference with the object cache that is
populated in the evaluation, which might refer to objects coming in the
existing command list that is being processed.

There is still a post_expand phase to detach the elements from the set
which could be consolidated by updating the evaluation step to handle
the CMD_OBJ_SETELEMS command type.

This patch fixes 27c753e4a8d4 ("rule: expand standalone chain that
contains rules") which broke rule addition/insertion by index because
the expansion code after the evaluation messes up the cache.

Fixes: 27c753e4a8d4 ("rule: expand standalone chain that contains rules")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h    |  1 +
 src/evaluate.c    | 39 ---------------------------------------
 src/libnftables.c |  9 ++++++++-
 src/rule.c        | 19 ++++++++++++++++++-
 4 files changed, 27 insertions(+), 41 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 00a1bac5a773..7625addfd919 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -733,6 +733,7 @@ extern struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 			     const struct handle *h, const struct location *loc,
 			     void *data);
 extern void nft_cmd_expand(struct cmd *cmd);
+extern void nft_cmd_post_expand(struct cmd *cmd);
 extern bool nft_cmd_collapse(struct list_head *cmds);
 extern void nft_cmd_uncollapse(struct list_head *cmds);
 extern struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type,
diff --git a/src/evaluate.c b/src/evaluate.c
index 5ecde2410184..c421b987894d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4707,7 +4707,6 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 {
 	struct table *table;
-	struct rule *rule;
 
 	table = table_cache_find(&ctx->nft->cache.table_cache,
 				 ctx->cmd->handle.table.name,
@@ -4763,11 +4762,6 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 		}
 	}
 
-	list_for_each_entry(rule, &chain->rules, list) {
-		handle_merge(&rule->handle, &chain->handle);
-		if (rule_evaluate(ctx, rule, CMD_INVALID) < 0)
-			return -1;
-	}
 	return 0;
 }
 
@@ -4835,11 +4829,6 @@ static int obj_evaluate(struct eval_ctx *ctx, struct obj *obj)
 
 static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 {
-	struct flowtable *ft;
-	struct chain *chain;
-	struct set *set;
-	struct obj *obj;
-
 	if (!table_cache_find(&ctx->nft->cache.table_cache,
 			      ctx->cmd->handle.table.name,
 			      ctx->cmd->handle.family)) {
@@ -4852,34 +4841,6 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 		}
 	}
 
-	if (ctx->cmd->table == NULL)
-		return 0;
-
-	ctx->table = table;
-	list_for_each_entry(set, &table->sets, list) {
-		expr_set_context(&ctx->ectx, NULL, 0);
-		handle_merge(&set->handle, &table->handle);
-		if (set_evaluate(ctx, set) < 0)
-			return -1;
-	}
-	list_for_each_entry(chain, &table->chains, list) {
-		handle_merge(&chain->handle, &table->handle);
-		ctx->cmd->handle.chain.location = chain->location;
-		if (chain_evaluate(ctx, chain) < 0)
-			return -1;
-	}
-	list_for_each_entry(ft, &table->flowtables, list) {
-		handle_merge(&ft->handle, &table->handle);
-		if (flowtable_evaluate(ctx, ft) < 0)
-			return -1;
-	}
-	list_for_each_entry(obj, &table->objs, list) {
-		handle_merge(&obj->handle, &table->handle);
-		if (obj_evaluate(ctx, obj) < 0)
-			return -1;
-	}
-
-	ctx->table = NULL;
 	return 0;
 }
 
diff --git a/src/libnftables.c b/src/libnftables.c
index a376825d7309..fd4ee6988c27 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -520,6 +520,13 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 	if (nft_cmd_collapse(cmds))
 		collapsed = true;
 
+	list_for_each_entry(cmd, cmds, list) {
+		if (cmd->op != CMD_ADD)
+			continue;
+
+		nft_cmd_expand(cmd);
+	}
+
 	list_for_each_entry_safe(cmd, next, cmds, list) {
 		struct eval_ctx ectx = {
 			.nft	= nft,
@@ -543,7 +550,7 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 		if (cmd->op != CMD_ADD)
 			continue;
 
-		nft_cmd_expand(cmd);
+		nft_cmd_post_expand(cmd);
 	}
 
 	return 0;
diff --git a/src/rule.c b/src/rule.c
index 323d89afd141..982160359aea 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1318,8 +1318,9 @@ static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds
 
 	list_for_each_entry_safe(rule, next, &chain->rules, list) {
 		list_del(&rule->list);
+		handle_merge(&rule->handle, &chain->handle);
 		memset(&h, 0, sizeof(h));
-		handle_merge(&h, &rule->handle);
+		handle_merge(&h, &chain->handle);
 		if (chain->flags & CHAIN_F_BINDING) {
 			rule->handle.chain_id = chain->handle.chain_id;
 			rule->handle.chain.location = chain->location;
@@ -1350,6 +1351,7 @@ void nft_cmd_expand(struct cmd *cmd)
 			return;
 
 		list_for_each_entry(chain, &table->chains, list) {
+			handle_merge(&chain->handle, &table->handle);
 			memset(&h, 0, sizeof(h));
 			handle_merge(&h, &chain->handle);
 			h.chain_id = chain->handle.chain_id;
@@ -1394,6 +1396,21 @@ void nft_cmd_expand(struct cmd *cmd)
 		nft_cmd_expand_chain(chain, &new_cmds);
 		list_splice(&new_cmds, &cmd->list);
 		break;
+	default:
+		break;
+	}
+}
+
+void nft_cmd_post_expand(struct cmd *cmd)
+{
+	struct list_head new_cmds;
+	struct set *set;
+	struct cmd *new;
+	struct handle h;
+
+	init_list_head(&new_cmds);
+
+	switch (cmd->obj) {
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
 		set = cmd->set;
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0017-parser_bison-allow-to-use-quota-in-sets.patch"

From a4fbce0a2117adad68d336d6489ae4aa2864af8b Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 1 Mar 2023 11:12:20 +0100
Subject: [PATCH nft,v1.0.6 17/41] parser_bison: allow to use quota in sets

commit 87e5f35bc58450d352c303a8ff51b02193605d66 upstream.

src: support for restoring element quota

This patch allows you to restore quota in dynamic sets.

 table ip x {
        set y {
                type ipv4_addr
                size 65535
                flags dynamic,timeout
                counter quota 500 bytes
                timeout 1h
                elements = { 8.8.8.8 counter packets 9 bytes 756 quota 500 bytes used 500 bytes timeout 1h expires 56m57s47ms }
        }

        chain z {
                type filter hook output priority filter; policy accept;
                update @y { ip daddr } counter packets 6 bytes 507
        }
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y                            | 16 ++++++++
 .../shell/testcases/sets/0060set_multistmt_1  | 38 +++++++++++++++++++
 .../sets/dumps/0060set_multistmt_1.nft        | 15 ++++++++
 3 files changed, 69 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0060set_multistmt_1
 create mode 100644 tests/shell/testcases/sets/dumps/0060set_multistmt_1.nft

diff --git a/src/parser_bison.y b/src/parser_bison.y
index d7cf8bc5fb1e..47a9ccf3c94a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4426,6 +4426,22 @@ set_elem_stmt		:	COUNTER	close_scope_counter
 				$$->connlimit.count = $4;
 				$$->connlimit.flags = NFT_CONNLIMIT_F_INV;
 			}
+			|	QUOTA	quota_mode NUM quota_unit quota_used	close_scope_quota
+			{
+				struct error_record *erec;
+				uint64_t rate;
+
+				erec = data_unit_parse(&@$, $4, &rate);
+				xfree($4);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+				$$ = quota_stmt_alloc(&@$);
+				$$->quota.bytes	= $3 * rate;
+				$$->quota.used = $5;
+				$$->quota.flags	= $2;
+			}
 			;
 
 set_elem_expr_option	:	TIMEOUT			time_spec
diff --git a/tests/shell/testcases/sets/0060set_multistmt_1 b/tests/shell/testcases/sets/0060set_multistmt_1
new file mode 100755
index 000000000000..1652668a2fec
--- /dev/null
+++ b/tests/shell/testcases/sets/0060set_multistmt_1
@@ -0,0 +1,38 @@
+#!/bin/bash
+
+RULESET="table x {
+	set y {
+		type ipv4_addr
+		size 65535
+		flags dynamic
+		counter quota 500 bytes
+		elements = { 1.2.3.4 counter packets 9 bytes 756 quota 500 bytes used 500 bytes }
+	}
+	chain y {
+		type filter hook output priority filter; policy accept;
+		update @y { ip daddr }
+	}
+}"
+
+$NFT -f - <<< $RULESET
+# should work
+if [ $? -ne 0 ]
+then
+	exit 1
+fi
+
+# should work
+$NFT add element x y { 1.1.1.1 }
+if [ $? -ne 0 ]
+then
+	exit 1
+fi
+
+# should work
+$NFT add element x y { 2.2.2.2 counter quota 1000 bytes }
+if [ $? -ne 0 ]
+then
+	exit 1
+fi
+
+exit 0
diff --git a/tests/shell/testcases/sets/dumps/0060set_multistmt_1.nft b/tests/shell/testcases/sets/dumps/0060set_multistmt_1.nft
new file mode 100644
index 000000000000..ac1bd26b3e58
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0060set_multistmt_1.nft
@@ -0,0 +1,15 @@
+table ip x {
+	set y {
+		type ipv4_addr
+		size 65535
+		flags dynamic
+		counter quota 500 bytes
+		elements = { 1.1.1.1 counter packets 0 bytes 0 quota 500 bytes, 1.2.3.4 counter packets 9 bytes 756 quota 500 bytes used 500 bytes,
+			     2.2.2.2 counter packets 0 bytes 0 quota 1000 bytes }
+	}
+
+	chain y {
+		type filter hook output priority filter; policy accept;
+		update @y { ip daddr }
+	}
+}
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0018-intervals-use-expression-location-when-translating-t.patch"

From ad159008316260a370e27f94e646987da1312441 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 27 Mar 2023 16:36:31 +0200
Subject: [PATCH nft,v1.0.6 18/41] intervals: use expression location when
 translating to intervals

commit 5e39a34b196d68b803911aa13066fef2f83dc98c upstream.

Otherwise, internal location reports:

 # nft -f ruleset.nft
 internal:0:0-0: Error: Could not process rule: File exists

after this patch:

 # nft -f ruleset.nft
 ruleset.nft:402:1-16: Error: Could not process rule: File exists
 1.2.3.0/30,
 ^^^^^^^^^^^

Fixes: 81e36530fcac ("src: replace interval segment tree overlap and automerge")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/intervals.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index 95e25cf09662..d79c52c58710 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -709,9 +709,9 @@ int set_to_intervals(const struct set *set, struct expr *init, bool add)
 			if (set->key->byteorder == BYTEORDER_HOST_ENDIAN)
 				mpz_switch_byteorder(expr->value, set->key->len / BITS_PER_BYTE);
 
-			newelem = set_elem_expr_alloc(&internal_location, expr);
+			newelem = set_elem_expr_alloc(&expr->location, expr);
 			if (i->etype == EXPR_MAPPING) {
-				newelem = mapping_expr_alloc(&internal_location,
+				newelem = mapping_expr_alloc(&expr->location,
 							     newelem,
 							     expr_get(i->right));
 			}
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0019-optimize-assert-nat-type-on-nat-statement-helper.patch"

From d51e2484fff3fc53bccaf7e580efc0f369e63935 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 4 Apr 2023 15:30:16 +0200
Subject: [PATCH nft,v1.0.6 19/41] optimize: assert nat type on nat statement
 helper

commit 17a39cb0b082fe5117801d0b1a41407eec7b776c upstream.

Add assert() to helper function to expression from NAT statement.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/optimize.c b/src/optimize.c
index e54693fdf67c..7fe0bc936382 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -853,6 +853,8 @@ static struct expr *stmt_nat_expr(struct stmt *nat_stmt)
 {
 	struct expr *nat_expr;
 
+	assert(nat_stmt->ops->type == STMT_NAT);
+
 	if (nat_stmt->nat.proto) {
 		nat_expr = concat_expr_alloc(&internal_location);
 		compound_expr_add(nat_expr, expr_get(nat_stmt->nat.addr));
@@ -863,6 +865,8 @@ static struct expr *stmt_nat_expr(struct stmt *nat_stmt)
 		nat_expr = expr_get(nat_stmt->nat.addr);
 	}
 
+	assert(nat_expr);
+
 	return nat_expr;
 }
 
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0020-optimize-support-for-redirect-and-masquerade.patch"

From e4da3a0b93dcc1f1dab5faa61116655f05ff5a1d Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 4 Apr 2023 15:30:21 +0200
Subject: [PATCH nft,v1.0.6 20/41] optimize: support for redirect and
 masquerade

commit 053566f71a28e9afc792d222a6fd7b55f7d8f4a0 upstream.

The redirect and masquerade statements can be handled as verdicts:

- if redirect statement specifies no ports.
- masquerade statement, in any case.

Exceptions to the rule: If redirect statement specifies ports, then nat
map transformation can be used iif both statements specify ports.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1668
Fixes: 0a6dbfce6dc3 ("optimize: merge nat rules with same selectors into map")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 151 ++++++++++++++----
 .../optimizations/dumps/merge_nat.nft         |   4 +
 tests/shell/testcases/optimizations/merge_nat |   7 +
 3 files changed, 130 insertions(+), 32 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 7fe0bc936382..9007f37f67f8 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -237,21 +237,58 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b,
 		if (stmt_a->nat.type != stmt_b->nat.type ||
 		    stmt_a->nat.flags != stmt_b->nat.flags ||
 		    stmt_a->nat.family != stmt_b->nat.family ||
-		    stmt_a->nat.type_flags != stmt_b->nat.type_flags ||
-		    (stmt_a->nat.addr &&
-		     stmt_a->nat.addr->etype != EXPR_SYMBOL &&
-		     stmt_a->nat.addr->etype != EXPR_RANGE) ||
-		    (stmt_b->nat.addr &&
-		     stmt_b->nat.addr->etype != EXPR_SYMBOL &&
-		     stmt_b->nat.addr->etype != EXPR_RANGE) ||
-		    (stmt_a->nat.proto &&
-		     stmt_a->nat.proto->etype != EXPR_SYMBOL &&
-		     stmt_a->nat.proto->etype != EXPR_RANGE) ||
-		    (stmt_b->nat.proto &&
-		     stmt_b->nat.proto->etype != EXPR_SYMBOL &&
-		     stmt_b->nat.proto->etype != EXPR_RANGE))
+		    stmt_a->nat.type_flags != stmt_b->nat.type_flags)
 			return false;
 
+		switch (stmt_a->nat.type) {
+		case NFT_NAT_SNAT:
+		case NFT_NAT_DNAT:
+			if ((stmt_a->nat.addr &&
+			     stmt_a->nat.addr->etype != EXPR_SYMBOL &&
+			     stmt_a->nat.addr->etype != EXPR_RANGE) ||
+			    (stmt_b->nat.addr &&
+			     stmt_b->nat.addr->etype != EXPR_SYMBOL &&
+			     stmt_b->nat.addr->etype != EXPR_RANGE) ||
+			    (stmt_a->nat.proto &&
+			     stmt_a->nat.proto->etype != EXPR_SYMBOL &&
+			     stmt_a->nat.proto->etype != EXPR_RANGE) ||
+			    (stmt_b->nat.proto &&
+			     stmt_b->nat.proto->etype != EXPR_SYMBOL &&
+			     stmt_b->nat.proto->etype != EXPR_RANGE))
+				return false;
+			break;
+		case NFT_NAT_MASQ:
+			break;
+		case NFT_NAT_REDIR:
+			if ((stmt_a->nat.proto &&
+			     stmt_a->nat.proto->etype != EXPR_SYMBOL &&
+			     stmt_a->nat.proto->etype != EXPR_RANGE) ||
+			    (stmt_b->nat.proto &&
+			     stmt_b->nat.proto->etype != EXPR_SYMBOL &&
+			     stmt_b->nat.proto->etype != EXPR_RANGE))
+				return false;
+
+			/* it should be possible to infer implicit redirections
+			 * such as:
+			 *
+			 *	tcp dport 1234 redirect
+			 *	tcp dport 3456 redirect to :7890
+			 * merge:
+			 *	redirect to tcp dport map { 1234 : 1234, 3456 : 7890 }
+			 *
+			 * currently not implemented.
+			 */
+			if (fully_compare &&
+			    stmt_a->nat.type == NFT_NAT_REDIR &&
+			    stmt_b->nat.type == NFT_NAT_REDIR &&
+			    (!!stmt_a->nat.proto ^ !!stmt_b->nat.proto))
+				return false;
+
+			break;
+		default:
+			assert(0);
+		}
+
 		return true;
 	default:
 		/* ... Merging anything else is yet unsupported. */
@@ -835,12 +872,35 @@ static bool stmt_verdict_cmp(const struct optimize_ctx *ctx,
 	return true;
 }
 
-static int stmt_nat_find(const struct optimize_ctx *ctx)
+static int stmt_nat_type(const struct optimize_ctx *ctx, int from,
+			 enum nft_nat_etypes *nat_type)
 {
+	uint32_t j;
+
+	for (j = 0; j < ctx->num_stmts; j++) {
+		if (!ctx->stmt_matrix[from][j])
+			continue;
+
+		if (ctx->stmt_matrix[from][j]->ops->type == STMT_NAT) {
+			*nat_type = ctx->stmt_matrix[from][j]->nat.type;
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+static int stmt_nat_find(const struct optimize_ctx *ctx, int from)
+{
+	enum nft_nat_etypes nat_type;
 	uint32_t i;
 
+	if (stmt_nat_type(ctx, from, &nat_type) < 0)
+		return -1;
+
 	for (i = 0; i < ctx->num_stmts; i++) {
-		if (ctx->stmt[i]->ops->type != STMT_NAT)
+		if (ctx->stmt[i]->ops->type != STMT_NAT ||
+		    ctx->stmt[i]->nat.type != nat_type)
 			continue;
 
 		return i;
@@ -856,9 +916,13 @@ static struct expr *stmt_nat_expr(struct stmt *nat_stmt)
 	assert(nat_stmt->ops->type == STMT_NAT);
 
 	if (nat_stmt->nat.proto) {
-		nat_expr = concat_expr_alloc(&internal_location);
-		compound_expr_add(nat_expr, expr_get(nat_stmt->nat.addr));
-		compound_expr_add(nat_expr, expr_get(nat_stmt->nat.proto));
+		if (nat_stmt->nat.addr) {
+			nat_expr = concat_expr_alloc(&internal_location);
+			compound_expr_add(nat_expr, expr_get(nat_stmt->nat.addr));
+			compound_expr_add(nat_expr, expr_get(nat_stmt->nat.proto));
+		} else {
+			nat_expr = expr_get(nat_stmt->nat.proto);
+		}
 		expr_free(nat_stmt->nat.proto);
 		nat_stmt->nat.proto = NULL;
 	} else {
@@ -879,7 +943,7 @@ static void merge_nat(const struct optimize_ctx *ctx,
 	struct stmt *stmt, *nat_stmt;
 	uint32_t i;
 
-	k = stmt_nat_find(ctx);
+	k = stmt_nat_find(ctx, from);
 	assert(k >= 0);
 
 	set = set_expr_alloc(&internal_location, NULL);
@@ -912,7 +976,10 @@ static void merge_nat(const struct optimize_ctx *ctx,
 		nat_stmt->nat.family = family;
 
 	expr_free(nat_stmt->nat.addr);
-	nat_stmt->nat.addr = expr;
+	if (nat_stmt->nat.type == NFT_NAT_REDIR)
+		nat_stmt->nat.proto = expr;
+	else
+		nat_stmt->nat.addr = expr;
 
 	remove_counter(ctx, from);
 	list_del(&stmt->list);
@@ -928,7 +995,7 @@ static void merge_concat_nat(const struct optimize_ctx *ctx,
 	struct stmt *stmt, *nat_stmt;
 	uint32_t i, j;
 
-	k = stmt_nat_find(ctx);
+	k = stmt_nat_find(ctx, from);
 	assert(k >= 0);
 
 	set = set_expr_alloc(&internal_location, NULL);
@@ -1013,22 +1080,36 @@ static void rule_optimize_print(struct output_ctx *octx,
 	fprintf(octx->error_fp, "%s\n", line);
 }
 
-static enum stmt_types merge_stmt_type(const struct optimize_ctx *ctx,
-				       uint32_t from, uint32_t to)
+enum {
+	MERGE_BY_VERDICT,
+	MERGE_BY_NAT_MAP,
+	MERGE_BY_NAT,
+};
+
+static uint32_t merge_stmt_type(const struct optimize_ctx *ctx,
+				uint32_t from, uint32_t to)
 {
+	const struct stmt *stmt;
 	uint32_t i, j;
 
 	for (i = from; i <= to; i++) {
 		for (j = 0; j < ctx->num_stmts; j++) {
-			if (!ctx->stmt_matrix[i][j])
+			stmt = ctx->stmt_matrix[i][j];
+			if (!stmt)
 				continue;
-			if (ctx->stmt_matrix[i][j]->ops->type == STMT_NAT)
-				return STMT_NAT;
+			if (stmt->ops->type == STMT_NAT) {
+				if ((stmt->nat.type == NFT_NAT_REDIR &&
+				     !stmt->nat.proto) ||
+				    stmt->nat.type == NFT_NAT_MASQ)
+					return MERGE_BY_NAT;
+
+				return MERGE_BY_NAT_MAP;
+			}
 		}
 	}
 
 	/* merge by verdict, even if no verdict is specified. */
-	return STMT_VERDICT;
+	return MERGE_BY_VERDICT;
 }
 
 static void merge_rules(const struct optimize_ctx *ctx,
@@ -1036,14 +1117,14 @@ static void merge_rules(const struct optimize_ctx *ctx,
 			const struct merge *merge,
 			struct output_ctx *octx)
 {
-	enum stmt_types stmt_type;
+	uint32_t merge_type;
 	bool same_verdict;
 	uint32_t i;
 
-	stmt_type = merge_stmt_type(ctx, from, to);
+	merge_type = merge_stmt_type(ctx, from, to);
 
-	switch (stmt_type) {
-	case STMT_VERDICT:
+	switch (merge_type) {
+	case MERGE_BY_VERDICT:
 		same_verdict = stmt_verdict_cmp(ctx, from, to);
 		if (merge->num_stmts > 1) {
 			if (same_verdict)
@@ -1057,12 +1138,18 @@ static void merge_rules(const struct optimize_ctx *ctx,
 				merge_stmts_vmap(ctx, from, to, merge);
 		}
 		break;
-	case STMT_NAT:
+	case MERGE_BY_NAT_MAP:
 		if (merge->num_stmts > 1)
 			merge_concat_nat(ctx, from, to, merge);
 		else
 			merge_nat(ctx, from, to, merge);
 		break;
+	case MERGE_BY_NAT:
+		if (merge->num_stmts > 1)
+			merge_concat_stmts(ctx, from, to, merge);
+		else
+			merge_stmts(ctx, from, to, merge);
+		break;
 	default:
 		assert(0);
 	}
diff --git a/tests/shell/testcases/optimizations/dumps/merge_nat.nft b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
index dd17905dbfeb..48d18a676ee0 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_nat.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
@@ -8,6 +8,7 @@ table ip test2 {
 	chain y {
 		oif "lo" accept
 		dnat ip to tcp dport map { 80 : 1.1.1.1 . 8001, 81 : 2.2.2.2 . 9001 }
+		ip saddr { 10.141.11.0/24, 10.141.13.0/24 } masquerade
 	}
 }
 table ip test3 {
@@ -15,12 +16,15 @@ table ip test3 {
 		oif "lo" accept
 		snat to ip saddr . tcp sport map { 1.1.1.1 . 1024-65535 : 3.3.3.3, 2.2.2.2 . 1024-65535 : 4.4.4.4 }
 		oifname "enp2s0" snat ip to ip saddr map { 10.1.1.0/24 : 72.2.3.66-72.2.3.78 }
+		tcp dport { 8888, 9999 } redirect
 	}
 }
 table ip test4 {
 	chain y {
 		oif "lo" accept
 		dnat ip to ip daddr . tcp dport map { 1.1.1.1 . 80 : 4.4.4.4 . 8000, 2.2.2.2 . 81 : 3.3.3.3 . 9000 }
+		redirect to :tcp dport map { 83 : 8083, 84 : 8084 }
+		tcp dport 85 redirect
 	}
 }
 table inet nat {
diff --git a/tests/shell/testcases/optimizations/merge_nat b/tests/shell/testcases/optimizations/merge_nat
index edf7f4c438b9..3a57d9402301 100755
--- a/tests/shell/testcases/optimizations/merge_nat
+++ b/tests/shell/testcases/optimizations/merge_nat
@@ -17,6 +17,8 @@ RULESET="table ip test2 {
                 oif lo accept
                 tcp dport 80 dnat to 1.1.1.1:8001
                 tcp dport 81 dnat to 2.2.2.2:9001
+                ip saddr 10.141.11.0/24 masquerade
+                ip saddr 10.141.13.0/24 masquerade
         }
 }"
 
@@ -28,6 +30,8 @@ RULESET="table ip test3 {
                 ip saddr 1.1.1.1 tcp sport 1024-65535 snat to 3.3.3.3
                 ip saddr 2.2.2.2 tcp sport 1024-65535 snat to 4.4.4.4
                 oifname enp2s0 snat ip to ip saddr map { 10.1.1.0/24 : 72.2.3.66-72.2.3.78 }
+                tcp dport 8888 redirect
+                tcp dport 9999 redirect
         }
 }"
 
@@ -38,6 +42,9 @@ RULESET="table ip test4 {
                 oif lo accept
                 ip daddr 1.1.1.1 tcp dport 80 dnat to 4.4.4.4:8000
                 ip daddr 2.2.2.2 tcp dport 81 dnat to 3.3.3.3:9000
+                tcp dport 83 redirect to :8083
+                tcp dport 84 redirect to :8084
+                tcp dport 85 redirect
         }
 }"
 
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0021-evaluate-bogus-missing-transport-protocol.patch"

From f0d9a1c0f93b7a4ea9e299132363324b4c90eadb Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 4 Apr 2023 15:30:20 +0200
Subject: [PATCH nft,v1.0.6 21/41] evaluate: bogus missing transport protocol

commit 2c227f00f0df9552b786080a8fd27c6a360e5828 upstream backport.

Users have to specify a transport protocol match such as

	meta l4proto tcp

before the redirect statement, even if the redirect statement already
implicitly refers to the transport protocol, for instance:

test.nft:3:16-53: Error: transport protocol mapping is only valid after transport protocol match
                redirect to :tcp dport map { 83 : 8083, 84 : 8084 }
                ~~~~~~~~     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Evaluate the redirect expression before the mandatory check for the
transport protocol match, so protocol context already provides a
transport protocol.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index c421b987894d..87d32cfddfa5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3392,6 +3392,13 @@ static int nat_evaluate_transport(struct eval_ctx *ctx, struct stmt *stmt,
 				  struct expr **expr)
 {
 	struct proto_ctx *pctx = &ctx->pctx;
+	int err;
+
+	err = stmt_evaluate_arg(ctx, stmt,
+				&inet_service_type, 2 * BITS_PER_BYTE,
+				BYTEORDER_BIG_ENDIAN, expr);
+	if (err < 0)
+		return err;
 
 	if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL &&
 	    !nat_evaluate_addr_has_th_expr(stmt->nat.addr))
@@ -3399,9 +3406,7 @@ static int nat_evaluate_transport(struct eval_ctx *ctx, struct stmt *stmt,
 					 "transport protocol mapping is only "
 					 "valid after transport protocol match");
 
-	return stmt_evaluate_arg(ctx, stmt,
-				 &inet_service_type, 2 * BITS_PER_BYTE,
-				 BYTEORDER_BIG_ENDIAN, expr);
+	return 0;
 }
 
 static int stmt_evaluate_l3proto(struct eval_ctx *ctx,
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0022-netlink_delinearize-do-not-reset-protocol-context-fo.patch"

From 9b8c778b11c04a716381b0ce107a25f1ad750ed6 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 4 Apr 2023 15:34:05 +0200
Subject: [PATCH nft,v1.0.6 22/41] netlink_delinearize: do not reset protocol
 context for nat protocol expression

commit f3b27274bfdb75dc29301bdd537ee6fec6d4e7c1 upstream backport.

This patch reverts 403b46ada490 ("netlink_delinearize: kill dependency
before eval of 'redirect' stmt"). Since ("evaluate: bogus missing
transport protocol"), this workaround is not required anymore.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c           |  4 +---
 tests/py/ip/redirect.t              |  2 +-
 tests/py/ip/redirect.t.json         | 14 +-------------
 tests/py/ip/redirect.t.payload      |  4 ++--
 tests/py/ip6/redirect.t             |  2 +-
 tests/py/ip6/redirect.t.json        | 14 +-------------
 tests/py/ip6/redirect.t.payload.ip6 |  4 ++--
 7 files changed, 9 insertions(+), 35 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index fe3246b2e3e9..b2e907b98656 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -3092,10 +3092,8 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		case STMT_NAT:
 			if (stmt->nat.addr != NULL)
 				expr_postprocess(&rctx, &stmt->nat.addr);
-			if (stmt->nat.proto != NULL) {
-				payload_dependency_reset(&rctx.pdctx);
+			if (stmt->nat.proto != NULL)
 				expr_postprocess(&rctx, &stmt->nat.proto);
-			}
 			break;
 		case STMT_TPROXY:
 			if (stmt->tproxy.addr)
diff --git a/tests/py/ip/redirect.t b/tests/py/ip/redirect.t
index d2991ce288b0..8c2b52f04415 100644
--- a/tests/py/ip/redirect.t
+++ b/tests/py/ip/redirect.t
@@ -47,5 +47,5 @@ ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter redirect;ok
 iifname "eth0" ct state established,new tcp dport vmap {22 : drop, 222 : drop } redirect;ok
 
 # redirect with maps
-ip protocol 6 redirect to :tcp dport map { 22 : 8000, 80 : 8080};ok
+redirect to :tcp dport map { 22 : 8000, 80 : 8080};ok
 
diff --git a/tests/py/ip/redirect.t.json b/tests/py/ip/redirect.t.json
index 3544e7f1b9c5..2afdf9b13e88 100644
--- a/tests/py/ip/redirect.t.json
+++ b/tests/py/ip/redirect.t.json
@@ -593,20 +593,8 @@
     }
 ]
 
-# ip protocol 6 redirect to :tcp dport map { 22 : 8000, 80 : 8080}
+# redirect to :tcp dport map { 22 : 8000, 80 : 8080}
 [
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "protocol",
-                    "protocol": "ip"
-                }
-            },
-	    "op": "==",
-            "right": 6
-        }
-    },
     {
         "redirect": {
             "port": {
diff --git a/tests/py/ip/redirect.t.payload b/tests/py/ip/redirect.t.payload
index 424ad7b4f7ec..4bed47c18ef9 100644
--- a/tests/py/ip/redirect.t.payload
+++ b/tests/py/ip/redirect.t.payload
@@ -207,12 +207,12 @@ ip test-ip4 output
   [ lookup reg 1 set __map%d dreg 0 ]
   [ redir ]
 
-# ip protocol 6 redirect to :tcp dport map { 22 : 8000, 80 : 8080}
+# redirect to :tcp dport map { 22 : 8000, 80 : 8080}
 __map%d test-ip4 b
 __map%d test-ip4 0
         element 00001600  : 0000401f 0 [end]    element 00005000  : 0000901f 0 [end]
 ip test-ip4 output
-  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
diff --git a/tests/py/ip6/redirect.t b/tests/py/ip6/redirect.t
index 778d53f33ce6..70ef7f9f14f6 100644
--- a/tests/py/ip6/redirect.t
+++ b/tests/py/ip6/redirect.t
@@ -46,4 +46,4 @@ ip6 daddr fe00::1-fe00::200 udp dport 53 counter redirect;ok
 iifname "eth0" ct state established,new tcp dport vmap {22 : drop, 222 : drop } redirect;ok
 
 # redirect with maps
-ip6 nexthdr 6 redirect to :tcp dport map { 22 : 8000, 80 : 8080};ok
+redirect to :tcp dport map { 22 : 8000, 80 : 8080};ok
diff --git a/tests/py/ip6/redirect.t.json b/tests/py/ip6/redirect.t.json
index 0059c7accc06..c18223fa7a5b 100644
--- a/tests/py/ip6/redirect.t.json
+++ b/tests/py/ip6/redirect.t.json
@@ -557,20 +557,8 @@
     }
 ]
 
-# ip6 nexthdr 6 redirect to :tcp dport map { 22 : 8000, 80 : 8080}
+# redirect to :tcp dport map { 22 : 8000, 80 : 8080}
 [
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "nexthdr",
-                    "protocol": "ip6"
-                }
-            },
-	    "op": "==",
-            "right": 6
-        }
-    },
     {
         "redirect": {
             "port": {
diff --git a/tests/py/ip6/redirect.t.payload.ip6 b/tests/py/ip6/redirect.t.payload.ip6
index e9a203161485..cfc290137f92 100644
--- a/tests/py/ip6/redirect.t.payload.ip6
+++ b/tests/py/ip6/redirect.t.payload.ip6
@@ -191,12 +191,12 @@ ip6 test-ip6 output
   [ lookup reg 1 set __map%d dreg 0 ]
   [ redir ]
 
-# ip6 nexthdr 6 redirect to :tcp dport map { 22 : 8000, 80 : 8080}
+# redirect to :tcp dport map { 22 : 8000, 80 : 8080}
 __map%d test-ip6 b
 __map%d test-ip6 0
 	element 00001600  : 0000401f 0 [end]	element 00005000  : 0000901f 0 [end]
 ip6 test-ip6 output
-  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0023-netlink-restore-typeof-interval-map-data-type.patch"

From 7f6576222a3932cf09bbda7a78dc5e93c1ab4e4a Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Mon, 1 May 2023 18:51:19 +0200
Subject: [PATCH nft,v1.0.6 23/41] netlink: restore typeof interval map data
 type

commit 0583bac241ea18c9d7f61cb20ca04faa1e043b78 upstream.

When "typeof ... : interval ..." gets used, existing logic
failed to validate the expressions.

"interval" means that kernel reserves twice the size,
so consider this when validating and restoring.

Also fix up the dump file of the existing test
case to be symmetrical.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink.c                                              | 7 ++++++-
 .../testcases/sets/dumps/0067nat_concat_interval_0.nft     | 4 ++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index efbc65650c4b..3119cc877004 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1024,10 +1024,15 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	list_splice_tail(&set_parse_ctx.stmt_list, &set->stmt_list);
 
 	if (datatype) {
+		uint32_t dlen;
+
 		dtype = set_datatype_alloc(datatype, databyteorder);
 		klen = nftnl_set_get_u32(nls, NFTNL_SET_DATA_LEN) * BITS_PER_BYTE;
 
-		if (set_udata_key_valid(typeof_expr_data, klen)) {
+		dlen = data_interval ?  klen / 2 : klen;
+
+		if (set_udata_key_valid(typeof_expr_data, dlen)) {
+			typeof_expr_data->len = klen;
 			datatype_free(datatype_get(dtype));
 			set->data = typeof_expr_data;
 		} else {
diff --git a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
index 6af47c6682ce..0215691e28ee 100644
--- a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
+++ b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
@@ -18,14 +18,14 @@ table ip nat {
 	}
 
 	map ipportmap4 {
-		type ifname . ipv4_addr : interval ipv4_addr
+		typeof iifname . ip saddr : interval ip daddr
 		flags interval
 		elements = { "enp2s0" . 10.1.1.136 : 1.1.2.69/32,
 			     "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
 	}
 
 	map ipportmap5 {
-		type ifname . ipv4_addr : interval ipv4_addr . inet_service
+		typeof iifname . ip saddr : interval ip daddr . tcp dport
 		flags interval
 		elements = { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22,
 			     "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0024-evaluate-allow-stateful-statements-with-anonymous-ve.patch"

From b696d03c254def9218e4a59df95caff6e2f3f06a Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sun, 7 May 2023 19:30:46 +0200
Subject: [PATCH nft,v1.0.6 24/41] evaluate: allow stateful statements with
 anonymous verdict maps

commit aceea86de797bcc315d3e759a44b97cbfb724435 upstream.

Evaluation fails to accept stateful statements in verdict maps, relax
the following check for anonymous sets:

test.nft:4:29-35: Error: missing statement in map declaration
                ip saddr vmap { 127.0.0.1 counter : drop, * counter : accept }
                                          ^^^^^^^

The existing code generates correctly the counter in the anonymous
verdict map.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                  | 3 ++-
 tests/shell/testcases/maps/0009vmap_0           | 2 +-
 tests/shell/testcases/maps/dumps/0009vmap_0.nft | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 87d32cfddfa5..717e41cd25bf 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1472,7 +1472,8 @@ static int __expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr *elem)
 					  "but element has %d", num_set_exprs,
 					  num_elem_exprs);
 		} else if (num_set_exprs == 0) {
-			if (!(set->flags & NFT_SET_EVAL)) {
+			if (!(set->flags & NFT_SET_ANONYMOUS) &&
+			    !(set->flags & NFT_SET_EVAL)) {
 				elem_stmt = list_first_entry(&elem->stmt_list, struct stmt, list);
 				return stmt_error(ctx, elem_stmt,
 						  "missing statement in %s declaration",
diff --git a/tests/shell/testcases/maps/0009vmap_0 b/tests/shell/testcases/maps/0009vmap_0
index 7627c81d99e0..d31e1608f792 100755
--- a/tests/shell/testcases/maps/0009vmap_0
+++ b/tests/shell/testcases/maps/0009vmap_0
@@ -12,7 +12,7 @@ EXPECTED="table inet filter {
 
         chain prerouting {
                 type filter hook prerouting priority -300; policy accept;
-                iif vmap { "lo" : jump wan_input }
+                iif vmap { "lo" counter : jump wan_input }
         }
 }"
 
diff --git a/tests/shell/testcases/maps/dumps/0009vmap_0.nft b/tests/shell/testcases/maps/dumps/0009vmap_0.nft
index c556feceb1aa..c37574ad5fad 100644
--- a/tests/shell/testcases/maps/dumps/0009vmap_0.nft
+++ b/tests/shell/testcases/maps/dumps/0009vmap_0.nft
@@ -8,6 +8,6 @@ table inet filter {
 
 	chain prerouting {
 		type filter hook prerouting priority raw; policy accept;
-		iif vmap { "lo" : jump wan_input }
+		iif vmap { "lo" counter packets 0 bytes 0 : jump wan_input }
 	}
 }
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0025-evaluate-skip-optimization-if-anonymous-set-uses-sta.patch"

From 44a84891167eb5681dd302f28310aff89d47e90d Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sun, 7 May 2023 19:34:19 +0200
Subject: [PATCH nft,v1.0.6 25/41] evaluate: skip optimization if anonymous set
 uses stateful statement

commit 033a664e89362e8c0c191a823bc37a6f92e8c89e upstream.

fee6bda06403 ("evaluate: remove anon sets with exactly one element")
introduces an optimization to remove use of sets with single element.
Skip this optimization if set element contains stateful statements.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                                 | 2 +-
 tests/shell/testcases/optimizations/dumps/single_anon_set.nft  | 1 +
 .../testcases/optimizations/dumps/single_anon_set.nft.input    | 3 +++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 717e41cd25bf..fb2a53fd452f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1669,7 +1669,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			set->set_flags |= NFT_SET_CONCAT;
 	} else if (set->size == 1) {
 		i = list_first_entry(&set->expressions, struct expr, list);
-		if (i->etype == EXPR_SET_ELEM) {
+		if (i->etype == EXPR_SET_ELEM && list_empty(&i->stmt_list)) {
 			switch (i->key->etype) {
 			case EXPR_PREFIX:
 			case EXPR_RANGE:
diff --git a/tests/shell/testcases/optimizations/dumps/single_anon_set.nft b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft
index 35e3f36e1a54..3f703034d80f 100644
--- a/tests/shell/testcases/optimizations/dumps/single_anon_set.nft
+++ b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft
@@ -11,5 +11,6 @@ table ip test {
 		ip daddr . tcp dport { 192.168.0.1 . 22 } accept
 		meta mark set ip daddr map { 192.168.0.1 : 0x00000001 }
 		ct state { established, related } accept
+		meta mark { 0x0000000a counter packets 0 bytes 0 }
 	}
 }
diff --git a/tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input
index 35b93832420f..ecc5691ba581 100644
--- a/tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input
+++ b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input
@@ -31,5 +31,8 @@ table ip test {
 		# ct state cannot be both established and related
 		# at the same time, but this needs extra work.
 		ct state { established, related } accept
+
+		# with stateful statement
+		meta mark { 0x0000000a counter }
 	}
 }
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0026-optimize-do-not-remove-counter-in-verdict-maps.patch"

From c77f7368a384716ce2df1436be0fcfcbfc7ea9ad Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sun, 7 May 2023 19:54:30 +0200
Subject: [PATCH nft,v1.0.6 26/41] optimize: do not remove counter in verdict
 maps

commit 686ab8b6996e154592a5fc16bd1e15e661201b2a upstream.

Add counter to set element instead of dropping it:

 # nft -c -o -f test.nft
 Merging:
 test.nft:6:3-50:              ip saddr 1.1.1.1 ip daddr 2.2.2.2 counter accept
 test.nft:7:3-48:              ip saddr 1.1.1.2 ip daddr 3.3.3.3 counter drop
 into:
       ip daddr . ip saddr vmap { 2.2.2.2 . 1.1.1.1 counter : accept, 3.3.3.3 . 1.1.1.2 counter : drop }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 50 ++++++++++++++++---
 .../optimizations/dumps/merge_stmts_vmap.nft  |  4 ++
 .../testcases/optimizations/merge_stmts_vmap  |  4 ++
 3 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 9007f37f67f8..f7546fd18d18 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -687,7 +687,8 @@ static void merge_concat_stmts(const struct optimize_ctx *ctx,
 	}
 }
 
-static void build_verdict_map(struct expr *expr, struct stmt *verdict, struct expr *set)
+static void build_verdict_map(struct expr *expr, struct stmt *verdict,
+			      struct expr *set, struct stmt *counter)
 {
 	struct expr *item, *elem, *mapping;
 
@@ -695,6 +696,9 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict, struct ex
 	case EXPR_LIST:
 		list_for_each_entry(item, &expr->expressions, list) {
 			elem = set_elem_expr_alloc(&internal_location, expr_get(item));
+			if (counter)
+				list_add_tail(&counter->list, &elem->stmt_list);
+
 			mapping = mapping_expr_alloc(&internal_location, elem,
 						     expr_get(verdict->expr));
 			compound_expr_add(set, mapping);
@@ -703,6 +707,9 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict, struct ex
 	case EXPR_SET:
 		list_for_each_entry(item, &expr->expressions, list) {
 			elem = set_elem_expr_alloc(&internal_location, expr_get(item->key));
+			if (counter)
+				list_add_tail(&counter->list, &elem->stmt_list);
+
 			mapping = mapping_expr_alloc(&internal_location, elem,
 						     expr_get(verdict->expr));
 			compound_expr_add(set, mapping);
@@ -714,6 +721,9 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict, struct ex
 	case EXPR_SYMBOL:
 	case EXPR_CONCAT:
 		elem = set_elem_expr_alloc(&internal_location, expr_get(expr));
+		if (counter)
+			list_add_tail(&counter->list, &elem->stmt_list);
+
 		mapping = mapping_expr_alloc(&internal_location, elem,
 					     expr_get(verdict->expr));
 		compound_expr_add(set, mapping);
@@ -742,6 +752,26 @@ static void remove_counter(const struct optimize_ctx *ctx, uint32_t from)
 	}
 }
 
+static struct stmt *zap_counter(const struct optimize_ctx *ctx, uint32_t from)
+{
+	struct stmt *stmt;
+	uint32_t i;
+
+	/* remove counter statement */
+	for (i = 0; i < ctx->num_stmts; i++) {
+		stmt = ctx->stmt_matrix[from][i];
+		if (!stmt)
+			continue;
+
+		if (stmt->ops->type == STMT_COUNTER) {
+			list_del(&stmt->list);
+			return stmt;
+		}
+	}
+
+	return NULL;
+}
+
 static void merge_stmts_vmap(const struct optimize_ctx *ctx,
 			     uint32_t from, uint32_t to,
 			     const struct merge *merge)
@@ -749,31 +779,33 @@ static void merge_stmts_vmap(const struct optimize_ctx *ctx,
 	struct stmt *stmt_a = ctx->stmt_matrix[from][merge->stmt[0]];
 	struct stmt *stmt_b, *verdict_a, *verdict_b, *stmt;
 	struct expr *expr_a, *expr_b, *expr, *left, *set;
+	struct stmt *counter;
 	uint32_t i;
 	int k;
 
 	k = stmt_verdict_find(ctx);
 	assert(k >= 0);
 
-	verdict_a = ctx->stmt_matrix[from][k];
 	set = set_expr_alloc(&internal_location, NULL);
 	set->set_flags |= NFT_SET_ANONYMOUS;
 
 	expr_a = stmt_a->expr->right;
-	build_verdict_map(expr_a, verdict_a, set);
+	verdict_a = ctx->stmt_matrix[from][k];
+	counter = zap_counter(ctx, from);
+	build_verdict_map(expr_a, verdict_a, set, counter);
+
 	for (i = from + 1; i <= to; i++) {
 		stmt_b = ctx->stmt_matrix[i][merge->stmt[0]];
 		expr_b = stmt_b->expr->right;
 		verdict_b = ctx->stmt_matrix[i][k];
-
-		build_verdict_map(expr_b, verdict_b, set);
+		counter = zap_counter(ctx, i);
+		build_verdict_map(expr_b, verdict_b, set, counter);
 	}
 
 	left = expr_get(stmt_a->expr->left);
 	expr = map_expr_alloc(&internal_location, left, set);
 	stmt = verdict_stmt_alloc(&internal_location, expr);
 
-	remove_counter(ctx, from);
 	list_add(&stmt->list, &stmt_a->list);
 	list_del(&stmt_a->list);
 	stmt_free(stmt_a);
@@ -787,12 +819,17 @@ static void __merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
 {
 	struct expr *concat, *next, *elem, *mapping;
 	LIST_HEAD(concat_list);
+	struct stmt *counter;
 
+	counter = zap_counter(ctx, i);
 	__merge_concat(ctx, i, merge, &concat_list);
 
 	list_for_each_entry_safe(concat, next, &concat_list, list) {
 		list_del(&concat->list);
 		elem = set_elem_expr_alloc(&internal_location, concat);
+		if (counter)
+			list_add_tail(&counter->list, &elem->stmt_list);
+
 		mapping = mapping_expr_alloc(&internal_location, elem,
 					     expr_get(verdict->expr));
 		compound_expr_add(set, mapping);
@@ -831,7 +868,6 @@ static void merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
 	expr = map_expr_alloc(&internal_location, concat_a, set);
 	stmt = verdict_stmt_alloc(&internal_location, expr);
 
-	remove_counter(ctx, from);
 	list_add(&stmt->list, &orig_stmt->list);
 	list_del(&orig_stmt->list);
 	stmt_free(orig_stmt);
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft
index 5a9b3006743b..8ecbd9276fd9 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_vmap.nft
@@ -6,4 +6,8 @@ table ip x {
 	chain z {
 		tcp dport vmap { 1 : accept, 2-3 : drop, 4 : accept }
 	}
+
+	chain w {
+		ip saddr vmap { 1.1.1.1 counter packets 0 bytes 0 : accept, 1.1.1.2 counter packets 0 bytes 0 : drop }
+	}
 }
diff --git a/tests/shell/testcases/optimizations/merge_stmts_vmap b/tests/shell/testcases/optimizations/merge_stmts_vmap
index 79350076d6c6..6e0f0762b7bb 100755
--- a/tests/shell/testcases/optimizations/merge_stmts_vmap
+++ b/tests/shell/testcases/optimizations/merge_stmts_vmap
@@ -12,6 +12,10 @@ RULESET="table ip x {
 		tcp dport 2-3 drop
 		tcp dport 4 accept
 	}
+	chain w {
+		ip saddr 1.1.1.1 counter accept
+		ip saddr 1.1.1.2 counter drop
+	}
 }"
 
 $NFT -o -f - <<< $RULESET
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0027-evaluate-do-not-abort-when-prefix-map-has-non-map-el.patch"

From 896733a47f3f92ac6331b25e6a0ea50acc60e2d6 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Mon, 19 Jun 2023 22:43:02 +0200
Subject: [PATCH nft,v1.0.6 27/41] evaluate: do not abort when prefix map has
 non-map element

commit 75217cb7bb78e22fc9317116353149def8a306e9 upstream.

Before:
nft: evaluate.c:1849: __mapping_expr_expand: Assertion `i->etype == EXPR_MAPPING' failed.

after:
Error: expected mapping, not set element
   snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24, 10.141.12.1 }

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                  | 17 +++++++++++++----
 tests/shell/testcases/bogons/assert_failures    | 12 ++++++++++++
 .../nat_prefix_map_with_set_element_assert      |  7 +++++++
 3 files changed, 32 insertions(+), 4 deletions(-)
 create mode 100755 tests/shell/testcases/bogons/assert_failures
 create mode 100644 tests/shell/testcases/bogons/nft-f/nat_prefix_map_with_set_element_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index fb2a53fd452f..e619320270a5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1735,12 +1735,21 @@ static void __mapping_expr_expand(struct expr *i)
 	}
 }
 
-static void mapping_expr_expand(struct expr *init)
+static int mapping_expr_expand(struct eval_ctx *ctx)
 {
 	struct expr *i;
 
-	list_for_each_entry(i, &init->expressions, list)
+	if (!set_is_anonymous(ctx->set->flags))
+		return 0;
+
+	list_for_each_entry(i, &ctx->set->init->expressions, list) {
+		if (i->etype != EXPR_MAPPING)
+			return expr_error(ctx->msgs, i,
+					  "expected mapping, not %s", expr_name(i));
 		__mapping_expr_expand(i);
+	}
+
+	return 0;
 }
 
 static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
@@ -1820,8 +1829,8 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		if (ctx->set->data->flags & EXPR_F_INTERVAL) {
 			ctx->set->data->len *= 2;
 
-			if (set_is_anonymous(ctx->set->flags))
-				mapping_expr_expand(ctx->set->init);
+			if (mapping_expr_expand(ctx))
+				return -1;
 		}
 
 		ctx->set->key->len = ctx->ectx.len;
diff --git a/tests/shell/testcases/bogons/assert_failures b/tests/shell/testcases/bogons/assert_failures
new file mode 100755
index 000000000000..79099427c98a
--- /dev/null
+++ b/tests/shell/testcases/bogons/assert_failures
@@ -0,0 +1,12 @@
+#!/bin/bash
+
+dir=$(dirname $0)/nft-f/
+
+for f in $dir/*; do
+	$NFT --check -f "$f"
+
+	if [ $? -ne 1 ]; then
+		echo "Bogus input file $f did not cause expected error code" 1>&2
+		exit 111
+	fi
+done
diff --git a/tests/shell/testcases/bogons/nft-f/nat_prefix_map_with_set_element_assert b/tests/shell/testcases/bogons/nft-f/nat_prefix_map_with_set_element_assert
new file mode 100644
index 000000000000..18c7edd14c5d
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/nat_prefix_map_with_set_element_assert
@@ -0,0 +1,7 @@
+table ip x {
+	chain y {
+	type nat hook postrouting priority srcnat; policy accept;
+		snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24, 10.141.12.1 }
+	}
+}
+
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0028-parser-don-t-assert-on-scope-underflows.patch"

From 85c98b5b8e5809bc2b3a1c823858bc4c87ae38b4 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Mon, 19 Jun 2023 22:43:03 +0200
Subject: [PATCH nft,v1.0.6 28/41] parser: don't assert on scope underflows

commit bb16416ec82599e41043a52887c37157e6f61984 upstream.

close_scope() gets called from the object destructors;
imbalance can cause us to hit assert().

Before:
nft: parser_bison.y:88: close_scope: Assertion `state->scope > 0' failed.
After:
assertion3:4:7-7: Error: too many levels of nesting jump {
assertion3:5:8-8: Error: too many levels of nesting jump
assertion3:5:9-9: Error: syntax error, unexpected newline, expecting '{'
assertion3:7:1-1: Error: syntax error, unexpected end of file

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                                        | 3 +--
 tests/shell/testcases/bogons/nft-f/scope_underflow_assert | 6 ++++++
 2 files changed, 7 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/scope_underflow_assert

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 47a9ccf3c94a..5beb69dc70e7 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -80,12 +80,11 @@ static int open_scope(struct parser_state *state, struct scope *scope)
 
 static void close_scope(struct parser_state *state)
 {
-	if (state->scope_err) {
+	if (state->scope_err || state->scope == 0) {
 		state->scope_err = false;
 		return;
 	}
 
-	assert(state->scope > 0);
 	state->scope--;
 }
 
diff --git a/tests/shell/testcases/bogons/nft-f/scope_underflow_assert b/tests/shell/testcases/bogons/nft-f/scope_underflow_assert
new file mode 100644
index 000000000000..aee1dcbf9d8a
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/scope_underflow_assert
@@ -0,0 +1,6 @@
+table t {
+	chain c {
+		jump{
+			jump {
+				jump
+
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0029-parser-reject-zero-length-interface-names.patch"

From dcbcdd51e7d7d1a0b676733f8246ba51a192ae43 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Mon, 19 Jun 2023 22:43:04 +0200
Subject: [PATCH nft,v1.0.6 29/41] parser: reject zero-length interface names

commit fa52bc22580632b4b78c263e338ddfbe235a8218 upstream.

device "" results in an assertion during evaluation.
Before:
nft: expression.c:426: constant_expr_alloc: Assertion `(((len) + (8) - 1) / (8)) > 0' failed.
After:
zero_length_devicename_assert:3:42-49: Error: you cannot set an empty interface name
type filter hook ingress device""lo" priority -1
                         ^^^^^^^^
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                            | 36 ++++++++++++++++---
 .../nft-f/zero_length_devicename_assert       |  5 +++
 2 files changed, 36 insertions(+), 5 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/zero_length_devicename_assert

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5beb69dc70e7..53873e1b5067 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -144,6 +144,33 @@ static bool already_set(const void *attr, const struct location *loc,
 	return true;
 }
 
+static struct expr *ifname_expr_alloc(const struct location *location,
+				      struct list_head *queue,
+				      const char *name)
+{
+	unsigned int length = strlen(name);
+	struct expr *expr;
+
+	if (length == 0) {
+		xfree(name);
+		erec_queue(error(location, "empty interface name"), queue);
+		return NULL;
+	}
+
+	if (length > 16) {
+		xfree(name);
+		erec_queue(error(location, "interface name too long"), queue);
+		return NULL;
+	}
+
+	expr = constant_expr_alloc(location, &ifname_type, BYTEORDER_HOST_ENDIAN,
+				   length * BITS_PER_BYTE, name);
+
+	xfree(name);
+
+	return expr;
+}
+
 #define YYLLOC_DEFAULT(Current, Rhs, N)	location_update(&Current, Rhs, N)
 
 #define symbol_value(loc, str) \
@@ -2520,12 +2547,11 @@ int_num			:	NUM			{ $$ = $1; }
 
 dev_spec		:	DEVICE	string
 			{
-				struct expr *expr;
+				struct expr *expr = ifname_expr_alloc(&@$, state->msgs, $2);
+
+				if (!expr)
+					YYERROR;
 
-				expr = constant_expr_alloc(&@$, &string_type,
-							   BYTEORDER_HOST_ENDIAN,
-							   strlen($2) * BITS_PER_BYTE, $2);
-				xfree($2);
 				$$ = compound_expr_alloc(&@$, EXPR_LIST);
 				compound_expr_add($$, expr);
 
diff --git a/tests/shell/testcases/bogons/nft-f/zero_length_devicename_assert b/tests/shell/testcases/bogons/nft-f/zero_length_devicename_assert
new file mode 100644
index 000000000000..84f330730fce
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/zero_length_devicename_assert
@@ -0,0 +1,5 @@
+table ip x {
+        chain Main_Ingress1 {
+                type filter hook ingress device""lo" priority -1
+	}
+}
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0030-parser-reject-zero-length-interface-names-in-flowtab.patch"

From 95199eeebecec8cc84579439c91b2e2348c33d7f Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Mon, 19 Jun 2023 22:43:05 +0200
Subject: [PATCH nft,v1.0.6 30/41] parser: reject zero-length interface names
 in flowtables

commit d40c7623837424d4eb8048508b924887b092e050 upstream.

Previous patch wasn't enough, also disable this for flowtable device lists.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                            | 20 +++++++++++--------
 .../zero_length_devicename_flowtable_assert   |  5 +++++
 2 files changed, 17 insertions(+), 8 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/zero_length_devicename_flowtable_assert

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 53873e1b5067..7aad9a853e82 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2236,17 +2236,21 @@ flowtable_list_expr	:	flowtable_expr_member
 
 flowtable_expr_member	:	QUOTED_STRING
 			{
-				$$ = constant_expr_alloc(&@$, &string_type,
-							 BYTEORDER_HOST_ENDIAN,
-							 strlen($1) * BITS_PER_BYTE, $1);
-				xfree($1);
+				struct expr *expr = ifname_expr_alloc(&@$, state->msgs, $1);
+
+				if (!expr)
+					YYERROR;
+
+				$$ = expr;
 			}
 			|	STRING
 			{
-				$$ = constant_expr_alloc(&@$, &string_type,
-							 BYTEORDER_HOST_ENDIAN,
-							 strlen($1) * BITS_PER_BYTE, $1);
-				xfree($1);
+				struct expr *expr = ifname_expr_alloc(&@$, state->msgs, $1);
+
+				if (!expr)
+					YYERROR;
+
+				$$ = expr;
 			}
 			|	variable_expr
 			{
diff --git a/tests/shell/testcases/bogons/nft-f/zero_length_devicename_flowtable_assert b/tests/shell/testcases/bogons/nft-f/zero_length_devicename_flowtable_assert
new file mode 100644
index 000000000000..2c3e6c3ffbd2
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/zero_length_devicename_flowtable_assert
@@ -0,0 +1,5 @@
+table t {
+	flowtable f {
+		devices = { """"lo }
+	}
+}
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0031-expression-define-.clone-for-catchall-set-element.patch"

From 7f41e3480975fc64512a03f1deab7bf78bf8482b Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 30 Jun 2023 09:42:11 +0200
Subject: [PATCH nft,v1.0.6 31/41] expression: define .clone for catchall set
 element

commit 5bd6b4981ce649b5e0ae5ec30b7738ef33ef7c6e upstream.

Otherwise reuse of catchall set element expression in variable triggers
a null-pointer dereference.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c                              | 15 +++++++++++--
 .../shell/testcases/maps/0017_map_variable_0  | 21 +++++++++++++++++++
 2 files changed, 34 insertions(+), 2 deletions(-)
 create mode 100755 tests/shell/testcases/maps/0017_map_variable_0

diff --git a/src/expression.c b/src/expression.c
index 7390089cf57d..37788b18e163 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1341,9 +1341,8 @@ static void set_elem_expr_destroy(struct expr *expr)
 		stmt_free(stmt);
 }
 
-static void set_elem_expr_clone(struct expr *new, const struct expr *expr)
+static void __set_elem_expr_clone(struct expr *new, const struct expr *expr)
 {
-	new->key = expr_clone(expr->key);
 	new->expiration = expr->expiration;
 	new->timeout = expr->timeout;
 	if (expr->comment)
@@ -1351,6 +1350,12 @@ static void set_elem_expr_clone(struct expr *new, const struct expr *expr)
 	init_list_head(&new->stmt_list);
 }
 
+static void set_elem_expr_clone(struct expr *new, const struct expr *expr)
+{
+	new->key = expr_clone(expr->key);
+	__set_elem_expr_clone(new, expr);
+}
+
 static const struct expr_ops set_elem_expr_ops = {
 	.type		= EXPR_SET_ELEM,
 	.name		= "set element",
@@ -1378,11 +1383,17 @@ static void set_elem_catchall_expr_print(const struct expr *expr,
 	nft_print(octx, "*");
 }
 
+static void set_elem_catchall_expr_clone(struct expr *new, const struct expr *expr)
+{
+	__set_elem_expr_clone(new, expr);
+}
+
 static const struct expr_ops set_elem_catchall_expr_ops = {
 	.type		= EXPR_SET_ELEM_CATCHALL,
 	.name		= "catch-all set element",
 	.print		= set_elem_catchall_expr_print,
 	.json		= set_elem_catchall_expr_json,
+	.clone		= set_elem_catchall_expr_clone,
 };
 
 struct expr *set_elem_catchall_expr_alloc(const struct location *loc)
diff --git a/tests/shell/testcases/maps/0017_map_variable_0 b/tests/shell/testcases/maps/0017_map_variable_0
new file mode 100755
index 000000000000..70cea88de238
--- /dev/null
+++ b/tests/shell/testcases/maps/0017_map_variable_0
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+set -e
+
+RULESET="define x = {
+        1.1.1.1 : 2,
+        * : 3,
+}
+
+table ip x {
+        map y {
+                typeof ip saddr : mark
+                elements = \$x
+        }
+        map z {
+                typeof ip saddr : mark
+                elements = \$x
+        }
+}"
+
+$NFT -f - <<< "$RULESET"
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0032-libnftables-Drop-cache-in-c-check-mode.patch"

From edb89f27cd4d2ffd62311769aa741af9c567798c Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 31 Jul 2023 12:29:55 +0200
Subject: [PATCH nft,v1.0.6 32/41] libnftables: Drop cache in -c/--check mode

commit 458e91a954abe4b7fb4ba70901c7da28220c446a upstream.

Extend e0aace943412 ("libnftables: Drop cache in error case") to also
drop the cache with -c/--check, this is a dry run mode and kernel does
not get any update.

This fixes a bug with -o/--optimize, which first runs in an implicit
-c/--check mode to validate that the ruleset is correct, then it
provides the proposed optimization. In this case, if the cache is not
emptied, old objects in the cache refer to scanner data that was
already released, which triggers BUG like this:

 BUG: invalid input descriptor type 151665524
 nft: erec.c:161: erec_print: Assertion `0' failed.
 Aborted

This bug was triggered in a ruleset that contains a set for geoip
filtering. This patch also extends tests/shell to cover this case.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c                                     |  7 +++++--
 .../optimizations/dumps/skip_unsupported.nft          | 11 +++++++++++
 tests/shell/testcases/optimizations/skip_unsupported  | 11 +++++++++++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index fd4ee6988c27..580989063f9e 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -609,8 +609,10 @@ err:
 	    nft_output_json(&nft->output) &&
 	    nft_output_echo(&nft->output))
 		json_print_echo(nft);
-	if (rc)
+
+	if (rc || nft->check)
 		nft_cache_release(&nft->cache);
+
 	return rc;
 }
 
@@ -715,7 +717,8 @@ err:
 	    nft_output_json(&nft->output) &&
 	    nft_output_echo(&nft->output))
 		json_print_echo(nft);
-	if (rc)
+
+	if (rc || nft->check)
 		nft_cache_release(&nft->cache);
 
 	scope_release(nft->state->scopes[0]);
diff --git a/tests/shell/testcases/optimizations/dumps/skip_unsupported.nft b/tests/shell/testcases/optimizations/dumps/skip_unsupported.nft
index 43b6578dc704..f24855e7b5e1 100644
--- a/tests/shell/testcases/optimizations/dumps/skip_unsupported.nft
+++ b/tests/shell/testcases/optimizations/dumps/skip_unsupported.nft
@@ -1,4 +1,15 @@
 table inet x {
+	set GEOIP_CC_wan-lan_120 {
+		type ipv4_addr
+		flags interval
+		elements = { 1.32.128.0/18, 1.32.200.0-1.32.204.128,
+			     1.32.207.0/24, 1.32.216.118-1.32.216.255,
+			     1.32.219.0-1.32.222.255, 1.32.226.0/23,
+			     1.32.231.0/24, 1.32.233.0/24,
+			     1.32.238.0/23, 1.32.240.0/24,
+			     223.223.220.0/22, 223.255.254.0/24 }
+	}
+
 	chain y {
 		ip saddr 1.2.3.4 tcp dport 80 meta mark set 0x0000000a accept
 		ip saddr 1.2.3.4 tcp dport 81 meta mark set 0x0000000b accept
diff --git a/tests/shell/testcases/optimizations/skip_unsupported b/tests/shell/testcases/optimizations/skip_unsupported
index 9313c302048c..6baa8280a9b5 100755
--- a/tests/shell/testcases/optimizations/skip_unsupported
+++ b/tests/shell/testcases/optimizations/skip_unsupported
@@ -3,6 +3,17 @@
 set -e
 
 RULESET="table inet x {
+	set GEOIP_CC_wan-lan_120 {
+		type ipv4_addr
+		flags interval
+		elements = { 1.32.128.0/18, 1.32.200.0-1.32.204.128,
+			     1.32.207.0/24, 1.32.216.118-1.32.216.255,
+			     1.32.219.0-1.32.222.255, 1.32.226.0/23,
+			     1.32.231.0/24, 1.32.233.0/24,
+			     1.32.238.0/23, 1.32.240.0/24,
+			     223.223.220.0/22, 223.255.254.0/24 }
+	}
+
 	chain y {
 		ip saddr 1.2.3.4 tcp dport 80 meta mark set 10 accept
 		ip saddr 1.2.3.4 tcp dport 81 meta mark set 11 accept
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0033-parser-allow-ct-timeouts-to-use-time_spec-values.patch"

From 5a716b585543876baef0dc0ece3469c2516a4e63 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Wed, 2 Aug 2023 17:47:14 +0200
Subject: [PATCH nft,v1.0.6 33/41] parser: allow ct timeouts to use time_spec
 values

commit 5c25c5a35cbd27911d233efd01efcb9be35c85af upstream.

For some reason the parser only allows raw numbers (seconds)
for ct timeouts, e.g.

ct timeout ttcp {
	protocol tcp;
	policy = { syn_sent : 3, ...

Also permit time_spec, e.g. "established : 5d".
Print the nicer time formats on output, but retain
raw numbers support on input for compatibility.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/stateful-objects.txt                               |  2 +-
 src/parser_bison.y                                     | 10 +++++++---
 src/rule.c                                             |  9 ++++++---
 tests/shell/testcases/listing/0013objects_0            |  2 +-
 .../testcases/nft-f/dumps/0017ct_timeout_obj_0.nft     |  2 +-
 5 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/doc/stateful-objects.txt b/doc/stateful-objects.txt
index e3c79220811f..00d3c5f10463 100644
--- a/doc/stateful-objects.txt
+++ b/doc/stateful-objects.txt
@@ -94,7 +94,7 @@ table ip filter {
 	ct timeout customtimeout {
 		protocol tcp;
 		l3proto ip
-		policy = { established: 120, close: 20 }
+		policy = { established: 2m, close: 20s }
 	}
 
 	chain output {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 7aad9a853e82..37dc8ac4c1a6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -660,7 +660,7 @@ int nft_lex(void *, void *, void *);
 %type <string>			identifier type_identifier string comment_spec
 %destructor { xfree($$); }	identifier type_identifier string comment_spec
 
-%type <val>			time_spec quota_used
+%type <val>			time_spec time_spec_or_num_s quota_used
 
 %type <expr>			data_type_expr data_type_atom_expr
 %destructor { expr_free($$); }  data_type_expr data_type_atom_expr
@@ -2633,6 +2633,11 @@ time_spec		:	STRING
 			}
 			;
 
+/* compatibility kludge to allow either 60, 60s, 1m, ... */
+time_spec_or_num_s	:	NUM
+			|	time_spec { $$ = $1 / 1000u; }
+			;
+
 family_spec		:	/* empty */		{ $$ = NFPROTO_IPV4; }
 			|	family_spec_explicit
 			;
@@ -4628,8 +4633,7 @@ timeout_states		:	timeout_state
 			}
 			;
 
-timeout_state		:	STRING	COLON	NUM
-
+timeout_state		:	STRING	COLON	time_spec_or_num_s
 			{
 				struct timeout_state *ts;
 
diff --git a/src/rule.c b/src/rule.c
index 982160359aea..1534dc0afe25 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1880,11 +1880,14 @@ static void print_proto_timeout_policy(uint8_t l4, const uint32_t *timeout,
 	nft_print(octx, "%s%spolicy = { ", opts->tab, opts->tab);
 	for (i = 0; i < timeout_protocol[l4].array_size; i++) {
 		if (timeout[i] != timeout_protocol[l4].dflt_timeout[i]) {
+			uint64_t timeout_ms;
+
 			if (comma)
 				nft_print(octx, ", ");
-			nft_print(octx, "%s : %u",
-				  timeout_protocol[l4].state_to_name[i],
-				  timeout[i]);
+			timeout_ms = timeout[i] * 1000u;
+			nft_print(octx, "%s : ",
+				  timeout_protocol[l4].state_to_name[i]);
+			time_print(timeout_ms, octx);
 			comma = true;
 		}
 	}
diff --git a/tests/shell/testcases/listing/0013objects_0 b/tests/shell/testcases/listing/0013objects_0
index 4d39143d9ce0..c81b94e20f65 100755
--- a/tests/shell/testcases/listing/0013objects_0
+++ b/tests/shell/testcases/listing/0013objects_0
@@ -15,7 +15,7 @@ EXPECTED="table ip test {
 	ct timeout cttime {
 		protocol udp
 		l3proto ip
-		policy = { unreplied : 15, replied : 12 }
+		policy = { unreplied : 15s, replied : 12s }
 	}
 
 	ct expectation ctexpect {
diff --git a/tests/shell/testcases/nft-f/dumps/0017ct_timeout_obj_0.nft b/tests/shell/testcases/nft-f/dumps/0017ct_timeout_obj_0.nft
index 7cff1ed5f21c..c5d9649e4038 100644
--- a/tests/shell/testcases/nft-f/dumps/0017ct_timeout_obj_0.nft
+++ b/tests/shell/testcases/nft-f/dumps/0017ct_timeout_obj_0.nft
@@ -2,7 +2,7 @@ table ip filter {
 	ct timeout cttime {
 		protocol tcp
 		l3proto ip
-		policy = { established : 123, close : 12 }
+		policy = { established : 2m3s, close : 12s }
 	}
 
 	chain c {
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0034-parser-permit-gc-interval-in-map-declarations.patch"

From 2db5f5bcea29e49a1a97a2fe3aa2bbb150d8a17a Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Mon, 21 Aug 2023 16:12:52 +0200
Subject: [PATCH nft,v1.0.6 34/41] parser: permit gc-interval in map
 declarations

commit 61eab46ee62a72629fa86c1929e73a2bfa95bc02 upstream.

Maps support timeouts, so allow to set the gc interval as well.

Fixes: 949cc39eb93f ("parser: support of maps with timeout")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 37dc8ac4c1a6..b6ad51adb62d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2077,6 +2077,11 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->timeout = $3;
 				$$ = $1;
 			}
+			|	map_block	GC_INTERVAL	time_spec	stmt_separator
+			{
+				$1->gc_int = $3;
+				$$ = $1;
+			}
 			|	map_block	TYPE
 						data_type_expr	COLON	data_type_expr
 						stmt_separator	close_scope_type
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0035-evaluate-do-not-remove-anonymous-set-with-protocol-f.patch"

From 6ca3fbbdec4bafc471b3d3948bb0eea93ec1b9c6 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 28 Aug 2023 22:47:05 +0200
Subject: [PATCH nft,v1.0.6 35/41] evaluate: do not remove anonymous set with
 protocol flags and single element

commit 01167c393a12c74c6f9a3015b75702964ff5bcda upstream.

Set lookups with flags search for an exact match, however:

	tcp flags { syn }

gets transformed into:

	tcp flags syn

which is matching on the syn flag only (non-exact match).

This optimization is safe for ct state though, because only one bit is
ever set on in the ct state bitmask.

Since protocol flags allow for combining flags, skip this optimization
to retain exact match semantics.

Another possible solution is to turn OP_IMPLICIT into OP_EQ for exact
flag match to re-introduce this optimization and deal with this corner
case.

Fixes: fee6bda06403 ("evaluate: remove anon sets with exactly one element")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index e619320270a5..3eb3f50f3cc0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1669,7 +1669,12 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			set->set_flags |= NFT_SET_CONCAT;
 	} else if (set->size == 1) {
 		i = list_first_entry(&set->expressions, struct expr, list);
-		if (i->etype == EXPR_SET_ELEM && list_empty(&i->stmt_list)) {
+		if (i->etype == EXPR_SET_ELEM &&
+		    (!i->dtype->basetype ||
+		     i->dtype->basetype->type != TYPE_BITMASK ||
+		     i->dtype->type == TYPE_CT_STATE) &&
+		    list_empty(&i->stmt_list)) {
+
 			switch (i->key->etype) {
 			case EXPR_PREFIX:
 			case EXPR_RANGE:
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0036-evaluate-revisit-anonymous-set-with-single-element-o.patch"

From ec1540fa1378bd310e1fe509c759a11be20162a3 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat, 2 Sep 2023 10:37:39 +0200
Subject: [PATCH nft,v1.0.6 36/41] evaluate: revisit anonymous set with single
 element optimization

commit fa17b17ea74a21a44596f3212466ff3d2d3ede8e upstream.

This patch reworks it to perform this optimization from the evaluation
step of the relational expression. Hence, when optimizing for protocol
flags, use OP_EQ instead of OP_IMPLICIT, that is:

	tcp flags { syn }

becomes (to represent an exact match):

	tcp flags == syn

given OP_IMPLICIT and OP_EQ are not equivalent for flags.

01167c393a12 ("evaluate: do not remove anonymous set with protocol flags
and single element") disabled this optimization, which is enabled again
after this patch.

Fixes: 01167c393a12 ("evaluate: do not remove anonymous set with protocol flags and single element")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 60 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 3eb3f50f3cc0..a16eaed8b763 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1667,26 +1667,6 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 	if (ctx->set) {
 		if (ctx->set->flags & NFT_SET_CONCAT)
 			set->set_flags |= NFT_SET_CONCAT;
-	} else if (set->size == 1) {
-		i = list_first_entry(&set->expressions, struct expr, list);
-		if (i->etype == EXPR_SET_ELEM &&
-		    (!i->dtype->basetype ||
-		     i->dtype->basetype->type != TYPE_BITMASK ||
-		     i->dtype->type == TYPE_CT_STATE) &&
-		    list_empty(&i->stmt_list)) {
-
-			switch (i->key->etype) {
-			case EXPR_PREFIX:
-			case EXPR_RANGE:
-			case EXPR_VALUE:
-				*expr = i->key;
-				i->key = NULL;
-				expr_free(set);
-				return 0;
-			default:
-				break;
-			}
-		}
 	}
 
 	set->set_flags |= NFT_SET_CONSTANT;
@@ -2209,6 +2189,35 @@ static bool range_needs_swap(const struct expr *range)
 	return mpz_cmp(left->value, right->value) > 0;
 }
 
+static void optimize_singleton_set(struct expr *rel, struct expr **expr)
+{
+	struct expr *set = rel->right, *i;
+
+	i = list_first_entry(&set->expressions, struct expr, list);
+	if (i->etype == EXPR_SET_ELEM &&
+	    list_empty(&i->stmt_list)) {
+
+		switch (i->key->etype) {
+		case EXPR_PREFIX:
+		case EXPR_RANGE:
+		case EXPR_VALUE:
+			rel->right = *expr = i->key;
+			i->key = NULL;
+			expr_free(set);
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (rel->op == OP_IMPLICIT &&
+	    rel->right->dtype->basetype &&
+	    rel->right->dtype->basetype->type == TYPE_BITMASK &&
+	    rel->right->dtype->type != TYPE_CT_STATE) {
+		rel->op = OP_EQ;
+	}
+}
+
 static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *rel = *expr, *left, *right;
@@ -2279,6 +2288,17 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		return expr_binary_error(ctx->msgs, right, left,
 					 "Cannot be used with right hand side constant value");
 
+	switch (rel->op) {
+	case OP_EQ:
+	case OP_IMPLICIT:
+	case OP_NEQ:
+		if (right->etype == EXPR_SET && right->size == 1)
+			optimize_singleton_set(rel, &right);
+		break;
+	default:
+		break;
+	}
+
 	switch (rel->op) {
 	case OP_EQ:
 	case OP_IMPLICIT:
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0037-evaluate-fix-get-element-for-concatenated-set.patch"

From ba50d1565e1995902b212536a6f2ab34e5983b41 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Tue, 5 Sep 2023 16:32:16 +0200
Subject: [PATCH nft,v1.0.6 37/41] evaluate: fix get element for concatenated
 set

commit 988e83a1ce61a829473082221a790e72f8d43519 upstream.

given:
table ip filter {
	set test {
		type ipv4_addr . ether_addr . mark
		flags interval
		elements = { 198.51.100.0/25 . 00:0b:0c:ca:cc:10-c1:a0:c1:cc:10:00 . 0x0000006f, }
	}
}

We get lookup failure:

nft get element ip filter test { 198.51.100.1 . 00:0b:0c:ca:cc:10 . 0x6f }
Error: Could not process rule: No such file or directory

Its possible to work around this via dummy range somewhere in the key, e.g.
nft get element ip filter test { 198.51.100.1 . 00:0b:0c:ca:cc:10 . 0x6f-0x6f }

but that shouldn't be needed, so make sure the INTERVAL flag is enabled
for the queried element if the set is of interval type.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index a16eaed8b763..6e35c8cd9e25 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4243,11 +4243,14 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 		return -1;
 
 	cmd->elem.set = set_get(set);
+	if (set_is_interval(ctx->set->flags)) {
+		if (!(set->flags & NFT_SET_CONCAT) &&
+		    interval_set_eval(ctx, ctx->set, cmd->expr) < 0)
+			return -1;
 
-	if (set_is_interval(ctx->set->flags) &&
-	    !(set->flags & NFT_SET_CONCAT) &&
-	    interval_set_eval(ctx, ctx->set, cmd->expr) < 0)
-		return -1;
+		assert(cmd->expr->etype == EXPR_SET);
+		cmd->expr->set_flags |= NFT_SET_INTERVAL;
+	}
 
 	ctx->set = NULL;
 
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0038-libnftables-refuse-to-open-onput-files-other-than-na.patch"

From bfc21d2628be4df1b63761e8fc8462152d42dd8e Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Thu, 14 Sep 2023 11:42:15 +0200
Subject: [PATCH nft,v1.0.6 38/41] libnftables: refuse to open onput files
 other than named pipes or regular files

commit 149b1c95d129f8ec8a3df16aeca0e9063e8d45bf upstream backport.

Don't start e.g. parsing a block device.
nftables is typically run as privileged user, exit early if we
get unexpected input.

Only exception: Allow character device if input is /dev/stdin.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1664
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/libnftables.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/src/libnftables.c b/src/libnftables.c
index 580989063f9e..8537d700b046 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -16,6 +16,7 @@
 #include <errno.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/stat.h>
 
 static int nft_netlink(struct nft_ctx *nft,
 		       struct list_head *cmds, struct list_head *msgs,
@@ -657,13 +658,46 @@ retry:
 	return rc;
 }
 
+/* need to use stat() to, fopen() will block for named fifos and
+ * libjansson makes no checks before or after open either.
+ */
+static struct error_record *filename_is_useable(struct nft_ctx *nft, const char *name)
+{
+	unsigned int type;
+	struct stat sb;
+	int err;
+
+	err = stat(name, &sb);
+	if (err)
+		return error(&internal_location, "Could not open file \"%s\": %s\n",
+			     name, strerror(errno));
+
+	type = sb.st_mode & S_IFMT;
+
+	if (type == S_IFREG || type == S_IFIFO)
+		return NULL;
+
+	if (type == S_IFCHR && 0 == strcmp(name, "/dev/stdin"))
+		return NULL;
+
+	return error(&internal_location, "Not a regular file: \"%s\"\n", name);
+}
+
 static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 {
+	struct error_record *erec;
 	struct cmd *cmd, *next;
 	int rc, parser_rc;
 	LIST_HEAD(msgs);
 	LIST_HEAD(cmds);
 
+	erec = filename_is_useable(nft, filename);
+	if (erec) {
+		erec_print(&nft->output, erec, nft->debug_mask);
+		erec_destroy(erec);
+		return -1;
+	}
+
 	rc = load_cmdline_vars(nft, &msgs);
 	if (rc < 0)
 		goto err;
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0039-scanner-restrict-include-directive-to-regular-files.patch"

From c6753190e130e323c4082d6afcf3b5051ddb3272 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Thu, 14 Sep 2023 11:42:16 +0200
Subject: [PATCH nft,v1.0.6 39/41] scanner: restrict include directive to
 regular files

commit 999ca7dade519ad5757f07a9c488b326a5e7d785 upstream.

Similar to previous change, also check all

include "foo"

and reject those if they refer to named fifos, block devices etc.

Directories are still skipped, I don't think we can change this
anymore.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1664
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/scanner.l                                 | 69 ++++++++++++++++++-
 .../testcases/bogons/nft-f/include-device     |  1 +
 2 files changed, 67 insertions(+), 3 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/include-device

diff --git a/src/scanner.l b/src/scanner.l
index b4315b8f8860..a158ed06b845 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -16,6 +16,7 @@
 #include <arpa/inet.h>
 #include <linux/types.h>
 #include <linux/netfilter.h>
+#include <sys/stat.h>
 
 #include <nftables.h>
 #include <erec.h>
@@ -947,9 +948,59 @@ static void scanner_push_file(struct nft_ctx *nft, void *scanner,
 	scanner_push_indesc(state, indesc);
 }
 
+enum nft_include_type {
+	NFT_INCLUDE,
+	NFT_CMDLINE,
+};
+
+static bool __is_useable(unsigned int type, enum nft_include_type t)
+{
+	type &= S_IFMT;
+	switch (type) {
+	case S_IFREG: return true;
+	case S_IFIFO:
+		 return t == NFT_CMDLINE; /* disallow include /path/to/fifo */
+	default:
+		break;
+	}
+
+	return false;
+}
+
+/* need to use stat() to, fopen() will block for named fifos */
+static bool filename_is_useable(const char *name)
+{
+	struct stat sb;
+	int err;
+
+	err = stat(name, &sb);
+	if (err)
+		return false;
+
+	return __is_useable(sb.st_mode, NFT_INCLUDE);
+}
+
+static bool fp_is_useable(FILE *fp, enum nft_include_type t)
+{
+	int fd = fileno(fp);
+	struct stat sb;
+	int err;
+
+	if (fd < 0)
+		return false;
+
+	err = fstat(fd, &sb);
+	if (err < 0)
+		return false;
+
+	return __is_useable(sb.st_mode, t);
+}
+
 static int include_file(struct nft_ctx *nft, void *scanner,
 			const char *filename, const struct location *loc,
-			const struct input_descriptor *parent_indesc)
+			const struct input_descriptor *parent_indesc,
+			enum nft_include_type includetype)
+
 {
 	struct parser_state *state = yyget_extra(scanner);
 	struct error_record *erec;
@@ -961,12 +1012,24 @@ static int include_file(struct nft_ctx *nft, void *scanner,
 		goto err;
 	}
 
+	if (includetype == NFT_INCLUDE && !filename_is_useable(filename)) {
+		erec = error(loc, "Not a regular file: \"%s\"\n", filename);
+		goto err;
+	}
+
 	f = fopen(filename, "r");
 	if (f == NULL) {
 		erec = error(loc, "Could not open file \"%s\": %s\n",
 			     filename, strerror(errno));
 		goto err;
 	}
+
+	if (!fp_is_useable(f, includetype)) {
+		fclose(f);
+		erec = error(loc, "Not a regular file: \"%s\"\n", filename);
+		goto err;
+	}
+
 	scanner_push_file(nft, scanner, f, filename, loc, parent_indesc);
 	return 0;
 err:
@@ -1039,7 +1102,7 @@ static int include_glob(struct nft_ctx *nft, void *scanner, const char *pattern,
 			if (len == 0 || path[len - 1] == '/')
 				continue;
 
-			ret = include_file(nft, scanner, path, loc, indesc);
+			ret = include_file(nft, scanner, path, loc, indesc, NFT_INCLUDE);
 			if (ret != 0)
 				goto err;
 		}
@@ -1076,7 +1139,7 @@ err:
 int scanner_read_file(struct nft_ctx *nft, const char *filename,
 		      const struct location *loc)
 {
-	return include_file(nft, nft->scanner, filename, loc, NULL);
+	return include_file(nft, nft->scanner, filename, loc, NULL, NFT_CMDLINE);
 }
 
 static bool search_in_include_path(const char *filename)
diff --git a/tests/shell/testcases/bogons/nft-f/include-device b/tests/shell/testcases/bogons/nft-f/include-device
new file mode 100644
index 000000000000..1eb797735481
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/include-device
@@ -0,0 +1 @@
+include "/dev/null"
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0040-evaluate-expand-sets-and-maps-before-evaluation.patch"

From 695ca6acb47ac01ed1d6d0fd8888c392998600e2 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat, 16 Sep 2023 15:42:48 +0200
Subject: [PATCH nft,v1.0.6 40/41] evaluate: expand sets and maps before
 evaluation

commit 56c90a2dd2eb9cb63a6d74d0f5ce8075bef3895b upstream.

3975430b12d9 ("src: expand table command before evaluation") moved
ruleset expansion before evaluation, except for sets and maps. For
sets and maps there is still a post_expand() phase.

This patch moves sets and map expansion to allocate an independent
CMD_OBJ_SETELEMS command to add elements to named set and maps which is
evaluated, this consolidates the ruleset expansion to happen always
before the evaluation step for all objects, except for anonymous sets
and maps.

This approach avoids an interference with the set interval code which
detects overlaps and merges of adjacents ranges. This set interval
routine uses set->init to maintain a cache of existing elements. Then,
the post_expand() phase incorrectly expands set->init cache and it
triggers a bogus ENOENT errors due to incorrect bytecode (placing
element addition before set creation) in combination with user declared
sets using the flat syntax notation.

Since the evaluation step (coming after the expansion) creates
implicit/anonymous sets and maps, those are not expanded anymore. These
anonymous sets still need to be evaluated from set_evaluate() path and
the netlink bytecode generation path, ie. do_add_set(), needs to deal
with anonymous sets.

Note that, for named sets, do_add_set() does not use set->init. Such
content is part of the existing cache, and the CMD_OBJ_SETELEMS command
is responsible for adding elements to named sets.

Fixes: 3975430b12d9 ("src: expand table command before evaluation")
Reported-by: Jann Haber <jannh@selfnet.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c    | 42 +++++++++++++++++++++++++-----------------
 src/libnftables.c |  7 -------
 src/rule.c        | 23 +++++++----------------
 3 files changed, 32 insertions(+), 40 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 6e35c8cd9e25..fcb86888bef7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4326,6 +4326,29 @@ static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+static int elems_evaluate(struct eval_ctx *ctx, struct set *set)
+{
+	ctx->set = set;
+	if (set->init != NULL) {
+		__expr_set_context(&ctx->ectx, set->key->dtype,
+				   set->key->byteorder, set->key->len, 0);
+		if (expr_evaluate(ctx, &set->init) < 0)
+			return -1;
+		if (set->init->etype != EXPR_SET)
+			return expr_error(ctx->msgs, set->init, "Set %s: Unexpected initial type %s, missing { }?",
+					  set->handle.set.name, expr_name(set->init));
+	}
+
+	if (set_is_interval(ctx->set->flags) &&
+	    !(ctx->set->flags & NFT_SET_CONCAT) &&
+	    interval_set_eval(ctx, ctx->set, set->init) < 0)
+		return -1;
+
+	ctx->set = NULL;
+
+	return 0;
+}
+
 static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 {
 	struct set *existing_set = NULL;
@@ -4416,23 +4439,6 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	}
 
 	set->existing_set = existing_set;
-	ctx->set = set;
-	if (set->init != NULL) {
-		__expr_set_context(&ctx->ectx, set->key->dtype,
-				   set->key->byteorder, set->key->len, 0);
-		if (expr_evaluate(ctx, &set->init) < 0)
-			return -1;
-		if (set->init->etype != EXPR_SET)
-			return expr_error(ctx->msgs, set->init, "Set %s: Unexpected initial type %s, missing { }?",
-					  set->handle.set.name, expr_name(set->init));
-	}
-
-	if (set_is_interval(ctx->set->flags) &&
-	    !(ctx->set->flags & NFT_SET_CONCAT) &&
-	    interval_set_eval(ctx, ctx->set, set->init) < 0)
-		return -1;
-
-	ctx->set = NULL;
 
 	return 0;
 }
@@ -4895,6 +4901,8 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SET:
 		handle_merge(&cmd->set->handle, &cmd->handle);
 		return set_evaluate(ctx, cmd->set);
+	case CMD_OBJ_SETELEMS:
+		return elems_evaluate(ctx, cmd->set);
 	case CMD_OBJ_RULE:
 		handle_merge(&cmd->rule->handle, &cmd->handle);
 		return rule_evaluate(ctx, cmd->rule, cmd->op);
diff --git a/src/libnftables.c b/src/libnftables.c
index 8537d700b046..b74429d5ef8b 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -547,13 +547,6 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 	if (err < 0 || nft->state->nerrs)
 		return -1;
 
-	list_for_each_entry(cmd, cmds, list) {
-		if (cmd->op != CMD_ADD)
-			continue;
-
-		nft_cmd_post_expand(cmd);
-	}
-
 	return 0;
 }
 
diff --git a/src/rule.c b/src/rule.c
index 1534dc0afe25..2248732a9737 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1396,21 +1396,6 @@ void nft_cmd_expand(struct cmd *cmd)
 		nft_cmd_expand_chain(chain, &new_cmds);
 		list_splice(&new_cmds, &cmd->list);
 		break;
-	default:
-		break;
-	}
-}
-
-void nft_cmd_post_expand(struct cmd *cmd)
-{
-	struct list_head new_cmds;
-	struct set *set;
-	struct cmd *new;
-	struct handle h;
-
-	init_list_head(&new_cmds);
-
-	switch (cmd->obj) {
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
 		set = cmd->set;
@@ -1641,7 +1626,13 @@ static int do_add_set(struct netlink_ctx *ctx, struct cmd *cmd,
 			return -1;
 	}
 
-	return mnl_nft_set_add(ctx, cmd, flags);
+	if (mnl_nft_set_add(ctx, cmd, flags) < 0)
+		return -1;
+
+	if (set_is_anonymous(set->flags))
+		return __do_add_elements(ctx, cmd, set, set->init, flags);
+
+	return 0;
 }
 
 static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
-- 
2.30.2


--F+ks2EEYNkSkSUS3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0041-limit-display-default-burst-when-listing-ruleset.patch"

From 8f9f84328ffb8f520c4370cb27f392794749d8fc Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 19 Sep 2023 15:25:43 +0200
Subject: [PATCH nft,v1.0.6 41/41] limit: display default burst when listing
 ruleset

commit 7360ab610164c7457b1024419ee046a4d05a6e2f upstream.

Default burst for limit is 5 for historical reasons but it is not
displayed when listing the ruleset.

Update listing to display the default burst to disambiguate.

man nft(8) has been recently updated to document this, no action in this
front is therefore required.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/statement.c                               |  4 +---
 tests/py/any/limit.t                          | 20 +++++++++----------
 .../json/dumps/0001set_statements_0.nft       |  2 +-
 .../nft-f/dumps/0025empty_dynset_0.nft        |  2 +-
 .../sets/dumps/0022type_selective_flush_0.nft |  2 +-
 .../testcases/sets/dumps/0038meter_list_0.nft | 11 ++++++++++
 .../sets/dumps/0059set_update_multistmt_0.nft |  2 +-
 .../sets/dumps/0060set_multistmt_0.nft        |  6 +++---
 8 files changed, 29 insertions(+), 20 deletions(-)
 create mode 100644 tests/shell/testcases/sets/dumps/0038meter_list_0.nft

diff --git a/src/statement.c b/src/statement.c
index eafc51c484de..c15c027f3b49 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -455,9 +455,7 @@ static void limit_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 		nft_print(octx, "limit rate %s%" PRIu64 "/%s",
 			  inv ? "over " : "", stmt->limit.rate,
 			  get_unit(stmt->limit.unit));
-		if (stmt->limit.burst && stmt->limit.burst != 5)
-			nft_print(octx, " burst %u packets",
-				  stmt->limit.burst);
+		nft_print(octx, " burst %u packets", stmt->limit.burst);
 		break;
 	case NFT_LIMIT_PKT_BYTES:
 		data_unit = get_rate(stmt->limit.rate, &rate);
diff --git a/tests/py/any/limit.t b/tests/py/any/limit.t
index 86e8d43009b9..a04ef42af931 100644
--- a/tests/py/any/limit.t
+++ b/tests/py/any/limit.t
@@ -9,11 +9,11 @@
 *bridge;test-bridge;output
 *netdev;test-netdev;ingress,egress
 
-limit rate 400/minute;ok
-limit rate 20/second;ok
-limit rate 400/hour;ok
-limit rate 40/day;ok
-limit rate 400/week;ok
+limit rate 400/minute;ok;limit rate 400/minute burst 5 packets
+limit rate 20/second;ok;limit rate 20/second burst 5 packets
+limit rate 400/hour;ok;limit rate 400/hour burst 5 packets
+limit rate 40/day;ok;limit rate 40/day burst 5 packets
+limit rate 400/week;ok;limit rate 400/week burst 5 packets
 limit rate 1023/second burst 10 packets;ok
 limit rate 1023/second burst 10 bytes;fail
 
@@ -35,11 +35,11 @@ limit rate 1025 kbytes/second burst 1023 kbytes;ok
 limit rate 1025 mbytes/second burst 1025 kbytes;ok
 limit rate 1025000 mbytes/second burst 1023 mbytes;ok
 
-limit rate over 400/minute;ok
-limit rate over 20/second;ok
-limit rate over 400/hour;ok
-limit rate over 40/day;ok
-limit rate over 400/week;ok
+limit rate over 400/minute;ok;limit rate over 400/minute burst 5 packets
+limit rate over 20/second;ok;limit rate over 20/second burst 5 packets
+limit rate over 400/hour;ok;limit rate over 400/hour burst 5 packets
+limit rate over 40/day;ok;limit rate over 40/day burst 5 packets
+limit rate over 400/week;ok;limit rate over 400/week burst 5 packets
 limit rate over 1023/second burst 10 packets;ok
 
 limit rate over 1 kbytes/second;ok
diff --git a/tests/shell/testcases/json/dumps/0001set_statements_0.nft b/tests/shell/testcases/json/dumps/0001set_statements_0.nft
index ee4a86705a94..d80a43211943 100644
--- a/tests/shell/testcases/json/dumps/0001set_statements_0.nft
+++ b/tests/shell/testcases/json/dumps/0001set_statements_0.nft
@@ -7,6 +7,6 @@ table ip testt {
 
 	chain testc {
 		type filter hook input priority filter; policy accept;
-		tcp dport 22 ct state new add @ssh_meter { ip saddr limit rate 10/second } accept
+		tcp dport 22 ct state new add @ssh_meter { ip saddr limit rate 10/second burst 5 packets } accept
 	}
 }
diff --git a/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.nft b/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.nft
index 2bb35592588a..33b9e4ff7f20 100644
--- a/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.nft
+++ b/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.nft
@@ -13,6 +13,6 @@ table ip foo {
 	set inflows_ratelimit {
 		type ipv4_addr . inet_service . ifname . ipv4_addr . inet_service
 		flags dynamic
-		elements = { 10.1.0.3 . 39466 . "veth1" . 10.3.0.99 . 5201 limit rate 1/second counter packets 0 bytes 0 }
+		elements = { 10.1.0.3 . 39466 . "veth1" . 10.3.0.99 . 5201 limit rate 1/second burst 5 packets counter packets 0 bytes 0 }
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft b/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft
index 5a6e3261b4ba..0a4cb0a54d73 100644
--- a/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft
+++ b/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft
@@ -8,6 +8,6 @@ table ip t {
 	}
 
 	chain c {
-		tcp dport 80 meter f size 1024 { ip saddr limit rate 10/second }
+		tcp dport 80 meter f size 1024 { ip saddr limit rate 10/second burst 5 packets }
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/0038meter_list_0.nft b/tests/shell/testcases/sets/dumps/0038meter_list_0.nft
new file mode 100644
index 000000000000..f274086b5285
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0038meter_list_0.nft
@@ -0,0 +1,11 @@
+table ip t {
+	set s {
+		type ipv4_addr
+		size 256
+		flags dynamic,timeout
+	}
+
+	chain c {
+		tcp dport 80 meter m size 128 { ip saddr limit rate 10/second burst 5 packets }
+	}
+}
diff --git a/tests/shell/testcases/sets/dumps/0059set_update_multistmt_0.nft b/tests/shell/testcases/sets/dumps/0059set_update_multistmt_0.nft
index 1b0ffae4d651..c1cc3b51d2bc 100644
--- a/tests/shell/testcases/sets/dumps/0059set_update_multistmt_0.nft
+++ b/tests/shell/testcases/sets/dumps/0059set_update_multistmt_0.nft
@@ -8,6 +8,6 @@ table ip x {
 
 	chain z {
 		type filter hook output priority filter; policy accept;
-		update @y { ip daddr limit rate 1/second counter }
+		update @y { ip daddr limit rate 1/second burst 5 packets counter }
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/0060set_multistmt_0.nft b/tests/shell/testcases/sets/dumps/0060set_multistmt_0.nft
index f23db53436fe..df68fcdf89e6 100644
--- a/tests/shell/testcases/sets/dumps/0060set_multistmt_0.nft
+++ b/tests/shell/testcases/sets/dumps/0060set_multistmt_0.nft
@@ -1,9 +1,9 @@
 table ip x {
 	set y {
 		type ipv4_addr
-		limit rate 1/second counter
-		elements = { 1.1.1.1 limit rate 1/second counter packets 0 bytes 0, 4.4.4.4 limit rate 1/second counter packets 0 bytes 0,
-			     5.5.5.5 limit rate 1/second counter packets 0 bytes 0 }
+		limit rate 1/second burst 5 packets counter
+		elements = { 1.1.1.1 limit rate 1/second burst 5 packets counter packets 0 bytes 0, 4.4.4.4 limit rate 1/second burst 5 packets counter packets 0 bytes 0,
+			     5.5.5.5 limit rate 1/second burst 5 packets counter packets 0 bytes 0 }
 	}
 
 	chain y {
-- 
2.30.2


--F+ks2EEYNkSkSUS3--
