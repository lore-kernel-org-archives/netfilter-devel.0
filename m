Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86263284662
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Aug 2026 21:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786741829; cv=none; b=FDB0eq0hjVpgn7DzOOWfTuecTJFqs6wGsE6s4qsqWW1fEkNErDNyyaXSYcmrmB/qLLxl+K/hFcXeQJVc7tSZnV0qbZqAv8zkibjVmfBhBctgRhr4GuMc8sXfIBMEgyUdCNTu8vcORvOMiguorrfoQ1zDO+GU0ulVwqm+72v2Qtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786741829; c=relaxed/simple;
	bh=o5+vfJz8rRbTcxqyqV0GUltILl0Ev3heH4d1ItKrea0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E4xVPvANXzZ/PIDMsrKUbQ4yn1kN74Ezla5PZvLDGVvipM7KgAKBBQFtGUtZqzb+mGdBYxQ56FjWnDM2646Y6O6G9zLLmyx6dHVjooBnaF17VM2d4P7kIJOQHfkIHcvBOb+Eu5X/1Wtl9u5ylNMrkXo92Bo0+D0d4NMx5/Zm94Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M/bhwpFY; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M/bhwpFY"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cc61541f8cso32656065ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Aug 2026 14:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786741828; x=1787346628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n/tYAV1lA5Vz9wmC1cTZPR3sO9dHeZYtCtNC1QCyXlY=;
        b=M/bhwpFYvNwyPQPh2bfX8rnwJKzTAw3ooFA9pgfyeehclofpoIUuP3zH/mFQEb6B8L
         0muknGACkofR7+doqszj1v65I4mTx0adFKQG4bkGPGGosShCVdwAWrwdexywmi0baj6r
         n0OdgPyzjtbvuDDfuArqyQOS+EnKb83/8TWr9G1fajmnivEzjp9yAQ8WEaH3FhsN+XgK
         aRpkW9TOMSP1sWrnwVwPpzTTCY/yRpUOLsnmnuDtVr7f2nOfUFJE2aOUU4RhBJG7s768
         DiGS/vtFe/WK70s4NYlQSd0PFKffec9W4Qwq4J5mHk7woxTeva/rf6pM/WbeeITf1py1
         gNUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786741828; x=1787346628;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n/tYAV1lA5Vz9wmC1cTZPR3sO9dHeZYtCtNC1QCyXlY=;
        b=EkNZVUzZe6lYzlm0PLA76vwCh6V757iB/0UWv5Qe3oKLP1eyQG/gn1t1/I/wbHdqDM
         PeyGC/Zt27CRVIH5V/eBuyVnjJoPfFgLa8+8z5f/l7KV/LM1XrQj43UO0Vq9omxODmty
         gyKN0TNcPkCrqwyMYDQrfrPu6G5YQg3EDYSmBBr2Arqx/nlwxaL8uUBMdMlt93KETzaG
         xkztJ7incaf+4Pzdvr9L05X0AKFu5HEcj6WWTSqUGOOyEQY8FKxUmyM9EoBkBDBLogbG
         eBZuNql5emapOB+u4kvCmIvCUkDlb6snXkHZLN/e5gJ4dQYvIs0VLHt8uyxW1sFVPfkm
         OARg==
X-Gm-Message-State: AOJu0YyJJ2HTAtFmLI57u7lOjHobiescr4I6J5TGSdlAUKWcfuJKSGPX
	HMbUrxAUvNbwsCHffE9L1xrmu+Lv7ARCNQkYN/6tcDqSBuH6UH4hkmXYiJv8PQ==
X-Gm-Gg: AR+sD13K4jl4usEcNMILZkcnUoYOO6JZRf8ogiE9iLBJCxhJU6lqj/ah5FEqfG3IGlF
	u2Vt1UaNC4aXT/lYMWQ5aJU5KPWUh9yk0td23qFBHKvI5O1LddBas9K7QI0ioCSfHVOffNY8bpR
	yykAF9mtATlCA/tCCaFjRvLL/8jvI0lZblTgDWfr+35My2PCtIeGB+oJ8rpFR+lXsFCy6uef63r
	AzhRNCfP6ZiUweF72IoCGkrslaCaE1hnFut4GbQOVn0mAncXYJ99+Y19L6mOBe1bh8xJIiGj4Ry
	sleAgEnElBRB2qkvD1DnHoZGH7U8xqagmJjZ5KWwgfxqs/2OoxuU97eTXSYmx7e9WW9wqlprUdj
	4jaKA8pL8u3XTHTi089zCKbA9G8MF6iPZOP/MZuHUhtz4Zh7YdymmlFC9rIQ7vlpz/0ha0hy7UQ
	n8yIPcuZcYTJB9ade0Bkc/0/UsmsclBNNQladCogRAkvDuDIHpu8Y+9h8KBxlIscGL8XZcbBNj2
	2aNfzyvejURBCRDTzea8tIEdNJHYgZvcWwNB0Uzz2lNCH27WQ==
X-Received: by 2002:a17:902:ea08:b0:2cc:ac15:ff4c with SMTP id d9443c01a7336-2d37f68dd75mr165129685ad.8.1786741827655;
        Fri, 14 Aug 2026 14:10:27 -0700 (PDT)
Received: from r912.tailbb6e1e.ts.net ([106.216.241.121])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320ea8fe3cdsm7866549eec.28.2026.08.14.14.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 14:10:27 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v2] evaluate: reject negative values for unsigned datatypes
Date: Sat, 15 Aug 2026 02:40:22 +0530
Message-ID: <20260814211022.2813482-1-avinash.duduskar@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

expr_evaluate_integer() only tests the upper bound, so a negative value
passes the range check and mpz_export() then drops the sign:

  # nft add element ip t m { "-1" }
  # nft list set ip t m
  table ip t {
          set m {
                  type mark
                  elements = { 0x00000001 }
          }
  }

The json frontend has it twice over: "elem": ["-1"] and the bare number
"elem": [-1] are both accepted and land as element 1 the same way.

The error string has read "Value %s exceeds valid range 0-%s" since the
check was added, so the contract was already unsigned; only the upper
half of it was enforced. The result is not a wrap either: "-1" gives 1
while "-4294967295" gives 0xffffffff.

Reject any negative value. Chain and flowtable priorities are signed but
never reach this check as a negative mpz: bare and json numeric
priorities are built as raw C ints by both frontends, symbols are
rebuilt from atoi() in priority_type_parse(), and the name-plus-offset
forms are computed as C ints in evaluate_priority().

Fixes: cb7cb885d65e ("evaluate: add expr_evaluate_integer()")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Avinash Duduskar <avinash.duduskar@gmail.com>
---
v2: drop the priority_type special case, it can never see a negative
    mpz (Phil, Pablo); name the json string and number forms in the
    message and cover them plus flowtable priority in the test

 src/evaluate.c                                | 10 +++
 tests/py/any/meta.t                           |  2 +
 .../parsing/dumps/negative_values_0.nodump    |  0
 .../shell/testcases/parsing/negative_values_0 | 70 +++++++++++++++++++
 4 files changed, 82 insertions(+)
 create mode 100644 tests/shell/testcases/parsing/dumps/negative_values_0.nodump
 create mode 100755 tests/shell/testcases/parsing/negative_values_0

diff --git a/src/evaluate.c b/src/evaluate.c
index 8bb7b609..250ed609 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -447,6 +447,16 @@ static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
 		return -1;
 	}
 
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
 	if (ctx->stmt_len > ctx->ectx.len)
 		masklen = ctx->stmt_len;
 	else
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
index 00000000..b2909a1a
--- /dev/null
+++ b/tests/shell/testcases/parsing/negative_values_0
@@ -0,0 +1,70 @@
+#!/bin/bash
+
+# mpz_export() drops the sign, so a negative value used to land as its
+# absolute value: "-1" became 1, from every frontend spelling. Chain and
+# flowtable priorities are signed and must keep working.
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
+# flowtables share evaluate_priority(); --check keeps the kernel out of it
+$NFT -c add flowtable ip t f '{ hook ingress priority -300; }'
+
+exit 0

base-commit: 4f54425ea59250dcd02518ef4a50e6c0b7c162bf
-- 
2.55.0

