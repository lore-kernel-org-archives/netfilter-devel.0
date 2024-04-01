Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B6DC2030A
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Apr 2024 11:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711969241; cv=none; b=jZJnIdLEoC4LuMc0M9+Or/EwETOEmMBZ0k8RxTsjqQb3fvPX/Jrx6O8RZ9WvXX4ELXHwDBvqq4bMHFiKazXDaNk6WvC+NuevqIz199hqpoOnsaptIoaTibgPug37sRBHwU8E7gmmePaTtEYNinwJEdfzk0TJ/DUbM4Ec+vEhYw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711969241; c=relaxed/simple;
	bh=77xgveLj/gY1UyFx5RypOfNlCHQ/czHhbCmnSisJz4Y=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=kfF5kUk/e4kbP0Xy2RJrYGuGKsNPU8BJBTXA0OSrgT1U7xantohWMcvoKm3xphKcyEvLICXn36mJDtNGSwalW9wsof+1Pxm9pEYqO8LjARak9OrF2BXQILOlpHB7m3iPEbBAOxKsMwfdxgiP3gAvfNZK/4k/q2+Cryw9bYwJeAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink_delinearize: unused code in reverse cross-day meta hour range
Date: Mon,  1 Apr 2024 13:00:22 +0200
Message-Id: <20240401110022.167239-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

f8f32deda31d ("meta: Introduce new conditions 'time', 'day' and 'hour'")
reverses a cross-day range expressed as "22:00"-"02:00" UTC time into
!= "02:00"-"22:00" so meta hour ranges works.

Listing is however confusing, hence, 44d144cd593e ("netlink_delinearize:
reverse cross-day meta hour range") introduces code to reverse a cross-day.

However, it also adds code to reverse a range in == to-from form
(assuming OP_IMPLICIT) which is never exercised from the listing path
because the range expression is not currently used, instead two
instructions (cmp gte and cmp lte) are used to represent the range.
Remove this branch otherwise a reversed notation will be used to display
meta hour ranges once the range instruction is to represent this.

While at it, unreliable test dump:

  tests/shell/testcases/listing/dumps/meta_time.nft

and move the cross-day check to the test script.

Fixes: 44d144cd593e ("netlink_delinearize: reverse cross-day meta hour range")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c                     | 12 +++----
 .../testcases/listing/dumps/meta_time.nft     | 32 -------------------
 .../testcases/listing/dumps/meta_time.nodump  |  0
 tests/shell/testcases/listing/meta_time       |  8 +++++
 4 files changed, 12 insertions(+), 40 deletions(-)
 delete mode 100644 tests/shell/testcases/listing/dumps/meta_time.nft
 create mode 100644 tests/shell/testcases/listing/dumps/meta_time.nodump

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5a4cf1b88110..24dfb3116eab 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2858,14 +2858,10 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 				 * is a cross-day range.
 				 */
 				if (mpz_cmp(range->left->value,
-					    range->right->value) <= 0) {
-					if (expr->op == OP_NEQ) {
-		                                range_expr_swap_values(range);
-		                                expr->op = OP_IMPLICIT;
-					} else if (expr->op == OP_IMPLICIT) {
-		                                range_expr_swap_values(range);
-					        expr->op = OP_NEG;
-					}
+					    range->right->value) <= 0 &&
+				    expr->op == OP_NEQ) {
+					range_expr_swap_values(range);
+					expr->op = OP_IMPLICIT;
 				}
 			}
 			/* fallthrough */
diff --git a/tests/shell/testcases/listing/dumps/meta_time.nft b/tests/shell/testcases/listing/dumps/meta_time.nft
deleted file mode 100644
index 9121aef59169..000000000000
--- a/tests/shell/testcases/listing/dumps/meta_time.nft
+++ /dev/null
@@ -1,32 +0,0 @@
-table ip t {
-	chain c {
-		meta hour "01:00"-"01:59"
-		meta hour "02:00"-"02:59"
-		meta hour "03:00"-"03:59"
-		meta hour "04:00"-"04:59"
-		meta hour "05:00"-"05:59"
-		meta hour "06:00"-"06:59"
-		meta hour "07:00"-"07:59"
-		meta hour "08:00"-"08:59"
-		meta hour "09:00"-"09:59"
-		meta hour "10:00"-"10:59"
-		meta hour "11:00"-"11:59"
-		meta hour "12:00"-"12:59"
-		meta hour "13:00"-"13:59"
-		meta hour "14:00"-"14:59"
-		meta hour "15:00"-"15:59"
-		meta hour "16:00"-"16:59"
-		meta hour "17:00"-"17:59"
-		meta hour "18:00"-"18:59"
-		meta hour "19:00"-"19:59"
-		meta hour "20:00"-"20:59"
-		meta hour "21:00"-"21:59"
-		meta hour "22:00"-"22:59"
-		meta hour "23:00"-"23:59"
-		meta hour "00:00"-"00:59"
-		meta hour "04:00"-"15:00"
-		meta hour "05:00"-"16:00"
-		meta hour "06:00"-"17:00"
-		meta hour "07:00"-"18:00"
-	}
-}
diff --git a/tests/shell/testcases/listing/dumps/meta_time.nodump b/tests/shell/testcases/listing/dumps/meta_time.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/listing/meta_time b/tests/shell/testcases/listing/meta_time
index 39fa43874ea9..96a9d5570fd1 100755
--- a/tests/shell/testcases/listing/meta_time
+++ b/tests/shell/testcases/listing/meta_time
@@ -53,7 +53,15 @@ printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 0 0 0 59 >> "$TMP1"
 
 check_decode UTC-1
 
+$NFT flush chain t c
 TZ=EADT $NFT add rule t c meta hour "03:00"-"14:00"
 TZ=EADT $NFT add rule t c meta hour "04:00"-"15:00"
 TZ=EADT $NFT add rule t c meta hour "05:00"-"16:00"
 TZ=EADT $NFT add rule t c meta hour "06:00"-"17:00"
+
+printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 3 0 14 0 > "$TMP1"
+printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 4 0 15 0 >> "$TMP1"
+printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 5 0 16 0 >> "$TMP1"
+printf "\t\tmeta hour \"%02d:%02d\"-\"%02d:%02d\"\n" 6 0 17 0 >> "$TMP1"
+
+check_decode EADT
-- 
2.30.2

