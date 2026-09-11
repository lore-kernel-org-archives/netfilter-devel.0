Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1625191F93
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 14:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138785; cv=none; b=cQeBim+t6MHNPGiofB/nWIU3KNEqtFaAZrMQnPB5A8QjlleqVTA+YMGHgAG6i6mmtYWowjaVx8BpQvEac6I4kKG40JAn++B0TkjGkJibbclgSqI+Nvf+yRgKsj2emaPphndu8GFWK1RP5omg0n+FzPmvyi8ZUu+drMHGEsx/qrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138785; c=relaxed/simple;
	bh=fn4oDAA1DaPquttB8CSABRJ8AwtWwJ1NLmmAkrBW5/E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oRA8ihbjg83+pxWxjp/n5FZQdMXO5W+bpd2fAJhf16Kk9dmy12Qwl7ilkXenuKrrgKYS81kjIeswAwvEt17FIGWnMYhglO3x46NLsdmnKcbTmFyCdo70HZ0IeZcQQYkeFOq7ANvhUc02Cnj+1nAaWHVqGcLJsNn7fGnFzZqR2EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g1bWNIob; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g1bWNIob"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc149372c14so770777a12.1
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 07:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789138783; x=1789743583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CkJffz7lKk+sNih4LlPnVjSet8+P4uj4YoJONhSidI8=;
        b=g1bWNIobcr5oj2nTa8R0tbU1HvD5vJ4ebbcHTux+okwLo9/YCuwEsvXY260nxXPDx0
         X4kiiqp3ha31mpxSc8w6AgjXU48CUiSUHpmuVMTP94ovGylEtSF/IcE08nOuJgPa7DB9
         FoKdvLLNJUekLaoRURwVM/uzdEpLbrv5Jo4S6/SbpOKLdqY4LwDMuqr8AnwBdYlfFQtx
         vRPxIjoGyD2bpI6rs9dsdkhE7RZaVLkSmlpZguu5+xCTGl8pFdXGoVB/D+j68fB7iyi/
         vszmemVhWlYs1sk0gegeSqWw3ANybTQHqediBI1UNDLk9LtybtgiBYHU0wYVc35NDlVb
         G+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789138783; x=1789743583;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CkJffz7lKk+sNih4LlPnVjSet8+P4uj4YoJONhSidI8=;
        b=VggJDhlPuE7LlkezRQ3duo+IzqBE7mTYTxpKM+VpDYshvXdH6CcQbJ5+i/76TIpSEQ
         jKu4qijpArhukT9JGHAmdvlh0DobA7K4HHEHlKnxeEwTOk1BxMMD3HrBnugyQ2h+Eb83
         J+lx7XuBVB1CRVkd25MC2ChcFxPvCyzkGw859Xa6N0/OatMytUN6IhKrLWCPHx7/348g
         tA+5KBCko872tKkuU8nmDfM2eJtxdHVSPttEBXF3+FUf8rgwEvvSpTFN2PHeRQiyrBcB
         HXJlMn7fyINLneZoDoEFwjXrPOU7xC4A7R9zK008Ibo/vzu6FMi1TmGfdxexpT5XxsnZ
         XgjA==
X-Gm-Message-State: AFuF++nkEEwLL/totz3p9lRryIrTtmQOOEJIjNFz8+CD17Hr8RYWbU5g
	7VGZ4FiQAg35lqMEiUg8AeKSLiCcGNG2x1601Z/c2crKn8GpQNj0KAGYfvPLVw==
X-Gm-Gg: AYBFou3wgBiZnu8tHh/hXo4CMq22P2tSdody6+1NrXpHFPe9TiD++iz9ICupYv3U9zD
	v919vBrqVigQ7aXiI6R0x7SnyeNqQLdK3wBKIJuIRqGyniuy80VuPRo3dBoyzKxEHecW1eCY7fk
	SfffzHehAPBZkHqvj4MXDOPPegbEZfpVdTHxwJdqk/GwYp4JeC1pyNvKyHW3bVwlYBtiJb2ax36
	o9s5J9i6ZAOMYVpmnpO4KegxITSI1Jpawc0Y3McvgrYfI4UASK2GXpz21KMvg/XHzYN6y4hRBxn
	YnqdE1YTjiTdnEaMK5K3vpoL7nHBFRovIhNqkd61dpHDhXSbK/RfXfyTvuQo+2Ohb3uLq2IcQtx
	znnoWHoJnT/yolGYHK+kAjaMUTqT4HP5hRPXC0BsKOrM76JSeVylxzhO1eQ9Zd3MyVRoMjEohJ6
	EDN+dRTxFwJ56gO3ma6u/elmBJrmOKHi8rtzZc0T7XzY2By4Hi/4bxddlsxMaafmva63flkY+58
	uC3lCrUrMn+PPVbb0Zsi6xpQzwFm/UY
X-Received: by 2002:a05:6a20:3c8d:b0:3d4:52bd:b89d with SMTP id adf61e73a8af0-3daed3c168emr9342568637.23.1789138782829;
        Fri, 11 Sep 2026 07:59:42 -0700 (PDT)
Received: from r912.4v1.in ([182.70.116.80])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4f06423sm7824367eec.20.2026.09.11.07.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 07:59:42 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v3] evaluate: reject negative values for unsigned datatypes
Date: Fri, 11 Sep 2026 20:29:37 +0530
Message-ID: <20260911145937.30151-1-avinash.duduskar@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

expr_evaluate_integer() only checks the upper bound, so a negative value
passes and mpz_export() then drops the sign:

  # nft add element ip t m { "-1" }
  # nft list set ip t m
  table ip t {
          set m {
                  type mark
                  elements = { 0x00000001 }
          }
  }

Same through json, both as "elem": ["-1"] and as "elem": [-1].

Reject a negative value. Priorities are unaffected: integer_type_parse()
is the only caller of mpz_set_str() outside mini-gmp, and
priority_type_parse() discards its result for an atoi() int before
evaluation.

Values from a define are not covered. initializer_expr's DASH NUM rule
loses the sign before evaluation, so "define x = -1" still lands as
0xffffffff on an unsigned type. Separate bug, left alone.

Fixes: cb7cb885d65e ("evaluate: add expr_evaluate_integer()")
Link: https://lore.kernel.org/netfilter-devel/amnndnoOMoR05sJK@chamomile/
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Avinash Duduskar <avinash.duduskar@gmail.com>
---
v3: sign check moved ahead of the maxval test. No other code change.
    Commit message now records that a define loses the sign before
    evaluation, so those are out of scope.

    v2 dropped the priority special case Phil objected to and had no
    reply. Pablo, this still does not add the ->validate interface you
    asked for. I did not want a new datatype hook and its per-type
    min/max in the same patch as the fix, but I will do that first as a
    prerequisite if it is the shape you want.

    v2: https://lore.kernel.org/netfilter-devel/20260814211022.2813482-1-avinash.duduskar@gmail.com/
    Tested on fcef13a3: shell 507 ok / 6 skipped / 0 failed, py 2083
    tests 0 error.

 src/evaluate.c                                | 10 +++
 tests/py/any/meta.t                           |  2 +
 .../parsing/dumps/negative_values_0.nodump    |  0
 .../shell/testcases/parsing/negative_values_0 | 71 +++++++++++++++++++
 4 files changed, 83 insertions(+)
 create mode 100644 tests/shell/testcases/parsing/dumps/negative_values_0.nodump
 create mode 100755 tests/shell/testcases/parsing/negative_values_0

diff --git a/src/evaluate.c b/src/evaluate.c
index 8115867f..7af800d3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -437,6 +437,16 @@ static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
 	uint32_t masklen;
 	mpz_t mask;
 
+	/* mpz_export() ignores the sign, so "-1" would silently become 1. */
+	if (mpz_sgn(expr->value) < 0) {
+		valstr = mpz_get_str(NULL, 10, expr->value);
+		expr_error(ctx->msgs, expr,
+			   "Value %s is negative, expecting an unsigned value",
+			   valstr);
+		nft_gmp_free(valstr);
+		return -1;
+	}
+
 	if (ctx->ectx.maxval > 0 &&
 	    mpz_cmp_ui(expr->value, ctx->ectx.maxval) > 0) {
 		valstr = mpz_get_str(NULL, 10, expr->value);
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index c5ab2ad9..4f486307 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -56,6 +56,8 @@ meta mark and 0x03 == 0x01;ok;meta mark & 0x00000003 == 0x00000001
 meta mark and 0x03 != 0x01;ok;meta mark & 0x00000003 != 0x00000001
 meta mark 0x10;ok;meta mark 0x00000010
 meta mark != 0x10;ok;meta mark != 0x00000010
+meta mark "-1";fail
+meta mark "-4294967295";fail
 meta mark 0xffffff00/24;ok;meta mark & 0xffffff00 == 0xffffff00
 
 meta mark or 0x03 == 0x01;ok;meta mark | 0x00000003 == 0x00000001
diff --git a/tests/shell/testcases/parsing/dumps/negative_values_0.nodump b/tests/shell/testcases/parsing/dumps/negative_values_0.nodump
new file mode 100644
index 00000000..e69de29b
diff --git a/tests/shell/testcases/parsing/negative_values_0 b/tests/shell/testcases/parsing/negative_values_0
new file mode 100755
index 00000000..3c7e3a64
--- /dev/null
+++ b/tests/shell/testcases/parsing/negative_values_0
@@ -0,0 +1,71 @@
+#!/bin/bash
+
+# mpz_export() drops the sign, so "-1" used to land as element 1, in rules
+# and in set elements, from both frontends. Priorities are signed and must
+# keep working. A negative from a define is not rejected, the sign is lost
+# before evaluation, which is why the priority arms below can still use one.
+
+set -e
+
+$NFT add table ip t
+$NFT add set ip t s '{ type mark; }'
+
+if $NFT add element ip t s '{ "-1" }' 2>/dev/null; then
+	echo "E: accepted a negative set element" >&2
+	$NFT list set ip t s >&2
+	exit 1
+fi
+
+# a rejected add must not have committed anything
+out=$($NFT list set ip t s)
+case "$out" in
+*elements*)
+	echo "E: something was stored by the failed add" >&2
+	echo "$out" >&2
+	exit 1
+	;;
+esac
+
+$NFT add chain ip t c
+
+if $NFT add rule ip t c meta mark '"-1"' 2>/dev/null; then
+	echo "E: accepted a negative value in a rule" >&2
+	exit 1
+fi
+
+# the json frontend must reject a negative element as a string and as a
+# bare number, both used to land as element 1
+if [ "$NFT_TEST_HAVE_json" != n ]; then
+	if echo '{"nftables":[{"add":{"element":{"family":"ip","table":"t","name":"s","elem":["-1"]}}}]}' | $NFT -j -f - 2>/dev/null; then
+		echo "E: json accepted a negative element as a string" >&2
+		exit 1
+	fi
+	if echo '{"nftables":[{"add":{"element":{"family":"ip","table":"t","name":"s","elem":[-1]}}}]}' | $NFT -j -f - 2>/dev/null; then
+		echo "E: json accepted a negative element as a number" >&2
+		exit 1
+	fi
+	out=$($NFT list set ip t s)
+	case "$out" in
+	*elements*)
+		echo "E: something was stored by the failed json adds" >&2
+		echo "$out" >&2
+		exit 1
+		;;
+	esac
+fi
+
+# priorities are signed: every spelling of a negative one must keep working
+$NFT add chain ip t c1 '{ type filter hook prerouting priority -300; }'
+$NFT add chain ip t c2 '{ type filter hook prerouting priority filter - 10; }'
+
+$NFT -f - <<'NFT'
+define p = -300
+table ip t2 {
+	chain c { type filter hook prerouting priority $p; policy accept; }
+}
+NFT
+
+# flowtable priority, --check so this needs no kernel support
+$NFT -c add flowtable ip t f '{ hook ingress priority -300; }'
+
+exit 0

base-commit: fcef13a358a0755a0bd980910d47989b064a756d
-- 
2.55.0

