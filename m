Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631E626AC3
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Aug 2026 01:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786152804; cv=none; b=NK5lRKYJOycCdiJqTDvDOAB2klmFMFcTRn2yN/BWmSQRcPj8tBxI2gBYyZG5ZWqNnP1oESdPkVMHdFXTEB425+KbQqPkM0aQVkQTontToSJkf1XiD6Y8qoHQ6McXoMc9hYcGB7HZnQL2JoWrUKRH7TWvEISzVAvLZKyDQOgiL7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786152804; c=relaxed/simple;
	bh=srRNMDgcUF5npNhmEcLsGTEOWa/PA77J/lFD1LQ7ZHA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KIQRuf0uUiPVInlwgSExj3fEMMEImMhLgqxBRKLXZGANtYYdbT4Qrl0J0kb7bTbB55iJnUhQQ3kbP07ScNLtIXi4f0dBC2LuD4w1Z5bpK0dhTrFh8ou1Ljd41aym0RCtQ2khd9UUaY7MtdQyM/+PVvxlu6C92PibBTEuoWBAHjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o4ADOJIw; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o4ADOJIw"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2d032846c95so2112225ad.1
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Aug 2026 18:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786152803; x=1786757603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ivEwe6vI9Hr+Vc2EiJ+jpxvy/RqtBm6iJCWEJkyxXBg=;
        b=o4ADOJIwaVsOR8KZFbhpEJlmYsBEfir/xJ83bL8wY1ZqTS5Mdv2k5rTylOPMlMjgeh
         S+PQK+hVci+LwIW5ZWX4soJi1Ecs1OnaaM89n7Jq4U/1h624i29wGai1LNLLNcLhADLH
         9StWxGQCb6ZJrE3bwssiyHou+BiipE7z2SqO/AWz919UuxqGF8/sD622GF6+zfkkhZY+
         iBhDfmiAnVolrlN+PwBdrBIarBJTjfODmzhCgJQdf+LdV7bBfUoJW8fS2tPChkmoak8W
         I7QjhuEhiM6uBwuam+IW7U4o05EiXEoRVjXxsHykuOa3ZQROEhUG3hQ6lVGdb4f0gpTH
         T/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786152803; x=1786757603;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ivEwe6vI9Hr+Vc2EiJ+jpxvy/RqtBm6iJCWEJkyxXBg=;
        b=ZyMfVZ2S0MAed52RK89NzrHboP8QEv3BUtvXWk/Mp0YL+0R0iIiliVD849YQ7kUSf9
         8W/GqL3TqXRjrVi3F3Wel9DcNyrsLml2Cr/KfwT/2l1HfdnMFjrlbfZDn7TwsnOHxvQI
         qx26u/2tVjLxZ86oTrTAC0VErMw5ryx+UVhwt3Bvby6V7z3yLP5+dH5mykNiYXD1+DbW
         vFcgiLc7EuT7pLndFlZ/ZCZUGmw+JqMqxFBRfJJx63L2oL4Ar896q8h07iw/XshXIFRl
         bWO3WLjFSV1obGHUGINcATEZ3kl7qTYcPZ3bfySJVQZ1+V+87uHzz3GMNc7i5/WfBk4e
         RUVw==
X-Gm-Message-State: AOJu0YwLQBWf/w/zafoJ6T5Zw5lon9Pts9cABfvyYBKkN7NwXRarTESH
	+eCtD+/Uz0N5JWzo/ofMbnKFJhQUpLAEseoSdKQ5mDiTDlYByBF13OmYP2pC4W9A
X-Gm-Gg: AR+sD105gmRtxEKbrBo/qNTgmo6pUhlYkCtK+JHf8RVBfvQYwC0FECM4nviTVtY8fq9
	OeT198nVLOSK8BPJV1tBp7Tmv60zUaoEWPi6hCCCggpHI2LgzycPq1zRfOcLGPC284eW3o1gRz0
	zYeqqVyneQ6n66bENsAY7bJAAbxrBqSfpC7BHRTU1IDHueEVQ8unVLuJT/uHg45mGXpKU5Jr/HZ
	/toftLMt/rvJwoGFU8EIqkp1S70N2+ZZkAsM4iAMgxNB7od0k8Jjx14BLDVOEbRBy0sfb7FR29p
	Awk0LByXf+erVpPm7/DiVgguSMFmt8cbNr1MIZit0wgxBmUSxRN/H5oUFvi3hLv72VnCejO/2mS
	xpiQrAyEnD189K8ODSIQmn2rLA3cnK8K55Ojf6hFGA+xY+q5rdskpKoGtDdGi5P3WasJ6wACVOb
	7qOAYg1VWwKyWNl+Zr1WaUTDfriyU6WJHZsiFhh1Fg9PPM6ymLNj3hfk1nGBez17X2+gjHE4iIK
	xStiT3eW4ipt0A0NYcbufxEGbqniK2370s=
X-Received: by 2002:a05:6a21:e352:b0:3cb:b3fc:510f with SMTP id adf61e73a8af0-3cbb3fc5a0cmr10776778637.24.1786152802661;
        Fri, 07 Aug 2026 18:33:22 -0700 (PDT)
Received: from r912.tailbb6e1e.ts.net ([160.30.85.32])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bec2ec20sm14452977eec.28.2026.08.07.18.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 18:33:22 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft] evaluate: reject negative values for unsigned datatypes
Date: Sat,  8 Aug 2026 07:03:18 +0530
Message-ID: <20260808013318.2766219-1-avinash.duduskar@gmail.com>
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

The error string has read "Value %s exceeds valid range 0-%s" since the
check was added, so the contract was already unsigned; only the upper
half of it was enforced. The result is not a wrap either: "-1" gives 1
while "-4294967295" gives 0xffffffff.

Reject a negative value, unless the evaluation context is a chain
priority, which is signed.

Fixes: cb7cb885d65e ("evaluate: add expr_evaluate_integer()")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Avinash Duduskar <avinash.duduskar@gmail.com>
---
 src/evaluate.c                                | 12 +++++
 tests/py/any/meta.t                           |  2 +
 .../parsing/dumps/negative_values_0.nodump    |  0
 .../shell/testcases/parsing/negative_values_0 | 46 +++++++++++++++++++
 4 files changed, 60 insertions(+)
 create mode 100644 tests/shell/testcases/parsing/dumps/negative_values_0.nodump
 create mode 100755 tests/shell/testcases/parsing/negative_values_0

diff --git a/src/evaluate.c b/src/evaluate.c
index 8bb7b609..f5b88c0b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -447,6 +447,18 @@ static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
 		return -1;
 	}
 
+	/* chain priorities are signed, everything else is an unsigned key:
+	 * mpz_export() drops the sign, so "-1" would silently become 1.
+	 */
+	if (mpz_sgn(expr->value) < 0 && ctx->ectx.dtype != &priority_type) {
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
index 00000000..663579a0
--- /dev/null
+++ b/tests/shell/testcases/parsing/negative_values_0
@@ -0,0 +1,46 @@
+#!/bin/bash
+
+# mpz_export() drops the sign, so a negative value used to land as its
+# absolute value: "-1" became 1. Chain priorities are signed and must keep
+# working.
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
+# the signed exception: every spelling of a negative chain priority
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
+exit 0

base-commit: 49e418238ece947e92f87a35ef6cf50755485370
-- 
2.55.0

