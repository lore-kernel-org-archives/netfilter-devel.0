Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C981E3769
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jul 2025 23:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752016306; cv=none; b=X/pIl43NSX9orA6E3zglu5sMZsxnb+A6EUUpfaL4w8CRD/K17Hx/CD9Pf/h+NLe5TgDT3bTppMNAkwiw/ht4NHNXygR9sr2QPQfx6m4qBv96m5TppopRBIJmzidpNNnrwasrH4ib4YyHI0EuY/ohxiuZji25JEXgzY4zVs7BBPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752016306; c=relaxed/simple;
	bh=sTptlvB26pjF6I144wXBScdngDAGDec/AfZs2hu/oUM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=lHiI8zzRL8wfc4ONmAayaSNcLq5QcQjuwnb6FW08vc7ZrzqeQmbcdMpyIik5weqYHZ0ariXcdf8uOZIyvJUhy5yVyGBh/WozHM0xZKlZIYMwcNc/Kb8aczSr0xq08wDCkeRC1gXsxrfnLmphOCMh+amlZ8zBCH+x51LL/jsRWKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HwiHwvKH; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EQlSii8c; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HwiHwvKH";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EQlSii8c"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2AF0C60265; Wed,  9 Jul 2025 01:11:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752016294;
	bh=2LejTMGxZpZJ8/ftoEfDLv+omvmnMJ5NKYGae83Ixcw=;
	h=From:To:Subject:Date:From;
	b=HwiHwvKHzq4L1gayNQcXTdUOMbGwa2+ZFZAe6LLRCwgGdsBqvaAPfGvzTE8rYm4gm
	 J+S+vLakRzLyWl8URoIjv7sIM61ydgjUO/WmR+rbl+36N5bG02PMJZxQC3NPkJckj4
	 pklL1PsoVxvCQ48DMmj3CvqCnfQSSmicoqoAD25Ab001QZ6ZNm1SRTzmFr7oEh7zwv
	 3gPKc8o1cuR+4RqW41BGlNH/2sEQdsN92KveQX92jK85plk/4+AYUvtLxMrGzHokjz
	 qiLmI8lkC/p1e5DmJ07Ws2LWfN1960MfqnQ7StKto4ie460xY9kFhg+wnugad51a9k
	 tUpHoiXbfJD7g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 58FEF60263
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 01:11:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752016293;
	bh=2LejTMGxZpZJ8/ftoEfDLv+omvmnMJ5NKYGae83Ixcw=;
	h=From:To:Subject:Date:From;
	b=EQlSii8clDMZsPxr//iXngPHsyMjIwuiJo3iScDoEXbo00c5Xq10FTkZJKnXgs4SX
	 oKrJ80EbA2DSCmdDnAKsFtEm019Xlkc5SbEU3p0+lPbp0qigt+bk/jkjGxFDFiDNDn
	 5HSyFpEYrwdsl5NMqhL4SIbFxF8Irv1+6hWm40Qk/MTxYTmSAJeKUGxjxSodF3h3oO
	 7LR8Ta+kSDbGEx+jUSZiiuOBH6sSVCn/gzlVGNGJGPhywwr1ANVEJKkppwt/ywFDNJ
	 l+FfKnRgqqvbXDUIy8avemI22Z2/4KV8ByLw0Us7qs119GrCO7QEm/IJgUM675Ankm
	 7kfc7Yips3nJw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] rule: print chain and flowtable devices in quotes
Date: Wed,  9 Jul 2025 01:11:28 +0200
Message-Id: <20250708231128.2045876-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Print devices in quotes, for consistency with:

- the existing chain listing with single device:

  type filter hook ingress device "lo" priority filter; policy accept

- the ifname datatype used in sets.

In general, tokens that are user-defined, not coming in the datatype
symbol list, are enclosed in quotes.

Fixes: 3fdc7541fba0 ("src: add multidevice support for netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c                                           |  4 ++--
 tests/shell/features/flowtable_counter.sh            |  2 +-
 .../testcases/chains/dumps/0042chain_variable_0.nft  |  4 ++--
 .../testcases/flowtable/dumps/0001flowtable_0.nft    |  2 +-
 .../flowtable/dumps/0002create_flowtable_0.nft       |  2 +-
 .../flowtable/dumps/0003add_after_flush_0.nft        |  2 +-
 .../flowtable/dumps/0005delete_in_use_1.nft          |  2 +-
 .../flowtable/dumps/0012flowtable_variable_0.nft     |  4 ++--
 .../flowtable/dumps/0013addafterdelete_0.nft         |  2 +-
 .../flowtable/dumps/0014addafterdelete_0.nft         |  2 +-
 tests/shell/testcases/listing/0020flowtable_0        | 12 ++++++------
 .../testcases/listing/dumps/0020flowtable_0.nft      |  4 ++--
 12 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index c0f7570e233c..3e3cc3b0fb7d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1062,7 +1062,7 @@ static void chain_print_declaration(const struct chain *chain,
 		} else if (chain->dev_array_len > 1) {
 			nft_print(octx, " devices = { ");
 			for (i = 0; i < chain->dev_array_len; i++) {
-				nft_print(octx, "%s", chain->dev_array[i]);
+				nft_print(octx, "\"%s\"", chain->dev_array[i]);
 					if (i + 1 != chain->dev_array_len)
 						nft_print(octx, ", ");
 			}
@@ -2149,7 +2149,7 @@ static void flowtable_print_declaration(const struct flowtable *flowtable,
 	if (flowtable->dev_array_len > 0) {
 		nft_print(octx, "%s%sdevices = { ", opts->tab, opts->tab);
 		for (i = 0; i < flowtable->dev_array_len; i++) {
-			nft_print(octx, "%s", flowtable->dev_array[i]);
+			nft_print(octx, "\"%s\"", flowtable->dev_array[i]);
 			if (i + 1 != flowtable->dev_array_len)
 				nft_print(octx, ", ");
 		}
diff --git a/tests/shell/features/flowtable_counter.sh b/tests/shell/features/flowtable_counter.sh
index a4c4c62124b0..5d47215f2f94 100755
--- a/tests/shell/features/flowtable_counter.sh
+++ b/tests/shell/features/flowtable_counter.sh
@@ -6,7 +6,7 @@
 EXPECTED="table ip filter2 {
 	flowtable main_ft2 {
 		hook ingress priority filter
-		devices = { lo }
+		devices = { \"lo\" }
 		counter
 	}
 }"
diff --git a/tests/shell/testcases/chains/dumps/0042chain_variable_0.nft b/tests/shell/testcases/chains/dumps/0042chain_variable_0.nft
index 84a908d33dee..08a19014e7b8 100644
--- a/tests/shell/testcases/chains/dumps/0042chain_variable_0.nft
+++ b/tests/shell/testcases/chains/dumps/0042chain_variable_0.nft
@@ -5,12 +5,12 @@ table netdev filter1 {
 }
 table netdev filter2 {
 	chain Main_Ingress2 {
-		type filter hook ingress devices = { d23456789012345, lo } priority -500; policy accept;
+		type filter hook ingress devices = { "d23456789012345", "lo" } priority -500; policy accept;
 	}
 }
 table netdev filter3 {
 	chain Main_Ingress3 {
-		type filter hook ingress devices = { d23456789012345, lo } priority -500; policy accept;
+		type filter hook ingress devices = { "d23456789012345", "lo" } priority -500; policy accept;
 	}
 
 	chain Main_Egress3 {
diff --git a/tests/shell/testcases/flowtable/dumps/0001flowtable_0.nft b/tests/shell/testcases/flowtable/dumps/0001flowtable_0.nft
index 629bfe81cb18..79fa59130843 100644
--- a/tests/shell/testcases/flowtable/dumps/0001flowtable_0.nft
+++ b/tests/shell/testcases/flowtable/dumps/0001flowtable_0.nft
@@ -1,7 +1,7 @@
 table inet t {
 	flowtable f {
 		hook ingress priority filter + 10
-		devices = { lo }
+		devices = { "lo" }
 	}
 
 	chain c {
diff --git a/tests/shell/testcases/flowtable/dumps/0002create_flowtable_0.nft b/tests/shell/testcases/flowtable/dumps/0002create_flowtable_0.nft
index aecfb2ab25df..2d0ea905d8b9 100644
--- a/tests/shell/testcases/flowtable/dumps/0002create_flowtable_0.nft
+++ b/tests/shell/testcases/flowtable/dumps/0002create_flowtable_0.nft
@@ -1,6 +1,6 @@
 table ip t {
 	flowtable f {
 		hook ingress priority filter + 10
-		devices = { lo }
+		devices = { "lo" }
 	}
 }
diff --git a/tests/shell/testcases/flowtable/dumps/0003add_after_flush_0.nft b/tests/shell/testcases/flowtable/dumps/0003add_after_flush_0.nft
index dd904f449ca1..39de91b19a82 100644
--- a/tests/shell/testcases/flowtable/dumps/0003add_after_flush_0.nft
+++ b/tests/shell/testcases/flowtable/dumps/0003add_after_flush_0.nft
@@ -1,6 +1,6 @@
 table ip x {
 	flowtable y {
 		hook ingress priority filter
-		devices = { lo }
+		devices = { "lo" }
 	}
 }
diff --git a/tests/shell/testcases/flowtable/dumps/0005delete_in_use_1.nft b/tests/shell/testcases/flowtable/dumps/0005delete_in_use_1.nft
index c1d79e7b144d..b01b3027c50e 100644
--- a/tests/shell/testcases/flowtable/dumps/0005delete_in_use_1.nft
+++ b/tests/shell/testcases/flowtable/dumps/0005delete_in_use_1.nft
@@ -1,7 +1,7 @@
 table ip x {
 	flowtable y {
 		hook ingress priority filter
-		devices = { lo }
+		devices = { "lo" }
 	}
 
 	chain x {
diff --git a/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft b/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft
index df1c51a24703..7863822d754b 100644
--- a/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft
+++ b/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft
@@ -1,14 +1,14 @@
 table ip filter1 {
 	flowtable Main_ft1 {
 		hook ingress priority filter
-		devices = { lo }
+		devices = { "lo" }
 		counter
 	}
 }
 table ip filter2 {
 	flowtable Main_ft2 {
 		hook ingress priority filter
-		devices = { lo }
+		devices = { "lo" }
 		counter
 	}
 }
diff --git a/tests/shell/testcases/flowtable/dumps/0013addafterdelete_0.nft b/tests/shell/testcases/flowtable/dumps/0013addafterdelete_0.nft
index 67db7d029392..585f63b1b916 100644
--- a/tests/shell/testcases/flowtable/dumps/0013addafterdelete_0.nft
+++ b/tests/shell/testcases/flowtable/dumps/0013addafterdelete_0.nft
@@ -1,6 +1,6 @@
 table inet filter {
 	flowtable f {
 		hook ingress priority filter - 1
-		devices = { lo }
+		devices = { "lo" }
 	}
 }
diff --git a/tests/shell/testcases/flowtable/dumps/0014addafterdelete_0.nft b/tests/shell/testcases/flowtable/dumps/0014addafterdelete_0.nft
index 145aa08153bc..12f97a75e2e5 100644
--- a/tests/shell/testcases/flowtable/dumps/0014addafterdelete_0.nft
+++ b/tests/shell/testcases/flowtable/dumps/0014addafterdelete_0.nft
@@ -1,7 +1,7 @@
 table inet filter {
 	flowtable f {
 		hook ingress priority filter - 1
-		devices = { lo }
+		devices = { "lo" }
 		counter
 	}
 
diff --git a/tests/shell/testcases/listing/0020flowtable_0 b/tests/shell/testcases/listing/0020flowtable_0
index 14b0c909a7eb..84f518970426 100755
--- a/tests/shell/testcases/listing/0020flowtable_0
+++ b/tests/shell/testcases/listing/0020flowtable_0
@@ -8,11 +8,11 @@ set -e
 
 FLOWTABLES="flowtable f {
 	hook ingress priority filter
-	devices = { lo }
+	devices = { \"lo\" }
 }
 flowtable f2 {
 	hook ingress priority filter
-	devices = { d0 }
+	devices = { \"d0\" }
 }"
 
 RULESET="table inet filter {
@@ -25,23 +25,23 @@ table ip filter {
 EXPECTED="table inet filter {
 	flowtable f {
 		hook ingress priority filter
-		devices = { lo }
+		devices = { \"lo\" }
 	}
 }"
 EXPECTED2="table ip filter {
 	flowtable f2 {
 		hook ingress priority filter
-		devices = { d0 }
+		devices = { \"d0\" }
 	}
 }"
 EXPECTED3="table ip filter {
 	flowtable f {
 		hook ingress priority filter
-		devices = { lo }
+		devices = { \"lo\" }
 	}
 	flowtable f2 {
 		hook ingress priority filter
-		devices = { d0 }
+		devices = { \"d0\" }
 	}
 }"
 
diff --git a/tests/shell/testcases/listing/dumps/0020flowtable_0.nft b/tests/shell/testcases/listing/dumps/0020flowtable_0.nft
index 4a64e531db84..0962e73aff2c 100644
--- a/tests/shell/testcases/listing/dumps/0020flowtable_0.nft
+++ b/tests/shell/testcases/listing/dumps/0020flowtable_0.nft
@@ -1,7 +1,7 @@
 table inet filter {
 	flowtable f {
 		hook ingress priority filter
-		devices = { lo }
+		devices = { "lo" }
 	}
 
 	flowtable f2 {
@@ -11,7 +11,7 @@ table inet filter {
 table ip filter {
 	flowtable f {
 		hook ingress priority filter
-		devices = { lo }
+		devices = { "lo" }
 	}
 
 	flowtable f2 {
-- 
2.30.2

