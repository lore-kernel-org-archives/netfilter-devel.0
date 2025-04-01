Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C032EAF7
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Apr 2025 17:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527010; cv=none; b=V8hk1YBVxETUqOAOsFsdIlkTXsxCOtb2Qp/2WA8beg2fKou8Dk61stEfUAYNvHX5X5sV777a1X6dcsfLmwPIJywXJoepWFDAdHqgSdPYjAG3hxDv8GQgASXubFoG87s5bduVXrku+S2Cx+7sMNq97aClP1soxdid6yx++wWoVV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527010; c=relaxed/simple;
	bh=ED9dfSkZgPlk1iVnownCbdLAqjLoi43fa/YDu6B9fow=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=TyNB4wowVLgh/ysQcYVLj5HnEYjaPOnv3eRT5oLs6V7yVcuxpLbnfm6NtnNKXEu+2oaRKmtEnecn8ri6ZS6I4O5HM3JeRy4Z/HMkd5gSfaILR840a+a3F0Lzn/Ly67qn3s7DbvwsVbPKir88MLJtEBK71C+SwLr21YisgXPm4NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=s5tm+R/S; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=E7eag8Dq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="s5tm+R/S";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="E7eag8Dq"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 214D4605B3; Tue,  1 Apr 2025 19:03:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743527005;
	bh=O7h3yDwLKX7uvvQWYI/x+f9R4oS+CJQwM6UxTJGW1lo=;
	h=From:To:Subject:Date:From;
	b=s5tm+R/SyHW+KEU1ouiF43s2IC+zsQXEPlJ0aGnYDMlJ0HZSePDn+8zXxmoTfWaqm
	 wiPPW4JLrqjt+13ALpcNzacIcekQq4Jfrwggi16Qo5uSGSVHokqEVcoExE9M1M2eje
	 obqXVakzTYDJraImzzgAZl0nZFKpktH21ic60zMyWtRFIDNEqNwNiPee7mGO79MUld
	 4scYVZuYBe9DroMCdCBsfZiH4c+7pPXC4ZN45/1QCA2cUet06pAsP69t3IbM24Sz3G
	 UB/HXRMbA7mRsbGN9Xp/WKRn/mL0tUrDmjgfrD8rfvvCVfLLnrM8c907bBlQ1VyMFM
	 F4KrqWjpcei8Q==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 87074605A6
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Apr 2025 19:03:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743527004;
	bh=O7h3yDwLKX7uvvQWYI/x+f9R4oS+CJQwM6UxTJGW1lo=;
	h=From:To:Subject:Date:From;
	b=E7eag8DqrvWB4YckRjgSXOxcG1P6eTKaRGy3A6mHxmRIKAzLxDNzN8nMKEhlbdy21
	 9nHa1f6jQjvW9MV79iKL8X6QrUpDWAljNiE4P3fiLOBdEit45i5gsn1VVOVTrR9lVI
	 s021+VXRq7OA345teeQsB5MyxQ7ONiZgqAFy+2Ne8EMTcrRPYHYXfqM2FVnRrsuJcW
	 Q2mxyTVLPppB/qTxoXWYwLHrtHDx/l5MT+ynbf3m6/uxuiNvdoNJWO/nWt03Qskxcx
	 7mitJxaejclcBUnH+90bW052m7mhWyzlYOsfXFRT5x3LKi2bubMFjQIuiJflaEHVhw
	 v9SnDVGzqYuLQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] optimize: expand expression list when merging into concatenation
Date: Tue,  1 Apr 2025 19:03:20 +0200
Message-Id: <20250401170320.1341011-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following rules:

    udp dport 137 ct state new,untracked accept
    udp dport 138 ct state new,untracked accept

results in:

  nft: src/optimize.c:670: __merge_concat: Assertion `0' failed.

The logic to expand to the new,untracked list in the concatenation is
missing.

Fixes: 187c6d01d357 ("optimize: expand implicit set element when merging into concatenation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 10 +++
 .../dumps/merge_stmts_concat.json-nft         | 61 +++++++++++++++++++
 .../dumps/merge_stmts_concat.nft              |  1 +
 .../optimizations/merge_stmts_concat          |  2 +
 4 files changed, 74 insertions(+)

diff --git a/src/optimize.c b/src/optimize.c
index 44010f2bb377..139bc2d73c3c 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -666,6 +666,16 @@ static void __merge_concat(const struct optimize_ctx *ctx, uint32_t i,
 				clone = expr_clone(stmt_a->expr->right);
 				compound_expr_add(concat, clone);
 				break;
+			case EXPR_LIST:
+				list_for_each_entry(expr, &stmt_a->expr->right->expressions, list) {
+					concat_clone = expr_clone(concat);
+					clone = expr_clone(expr);
+					compound_expr_add(concat_clone, clone);
+					list_add_tail(&concat_clone->list, &pending_list);
+				}
+				list_del(&concat->list);
+				expr_free(concat);
+				break;
 			default:
 				assert(0);
 				break;
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.json-nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.json-nft
index 267d84efffa3..46e740a8f5b5 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.json-nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.json-nft
@@ -181,6 +181,67 @@
         ]
       }
     },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "x",
+        "chain": "y",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "concat": [
+                  {
+                    "payload": {
+                      "protocol": "udp",
+                      "field": "dport"
+                    }
+                  },
+                  {
+                    "ct": {
+                      "key": "state"
+                    }
+                  }
+                ]
+              },
+              "right": {
+                "set": [
+                  {
+                    "concat": [
+                      137,
+                      "new"
+                    ]
+                  },
+                  {
+                    "concat": [
+                      138,
+                      "new"
+                    ]
+                  },
+                  {
+                    "concat": [
+                      137,
+                      "untracked"
+                    ]
+                  },
+                  {
+                    "concat": [
+                      138,
+                      "untracked"
+                    ]
+                  }
+                ]
+              }
+            }
+          },
+          {
+            "accept": null
+          }
+        ]
+      }
+    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
index f56cea1c4fd7..d00ac417ca75 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
@@ -2,6 +2,7 @@ table ip x {
 	chain y {
 		iifname . ip saddr . ip daddr { "eth1" . 1.1.1.1 . 2.2.2.3, "eth1" . 1.1.1.2 . 2.2.2.4, "eth1" . 1.1.1.2 . 2.2.3.0/24, "eth1" . 1.1.1.2 . 2.2.4.0-2.2.4.10, "eth2" . 1.1.1.3 . 2.2.2.5 } accept
 		ip protocol . th dport { tcp . 22, udp . 67 }
+		udp dport . ct state { 137 . new, 138 . new, 137 . untracked, 138 . untracked } accept
 	}
 
 	chain c1 {
diff --git a/tests/shell/testcases/optimizations/merge_stmts_concat b/tests/shell/testcases/optimizations/merge_stmts_concat
index 4db4a6f90944..bae54e3665e0 100755
--- a/tests/shell/testcases/optimizations/merge_stmts_concat
+++ b/tests/shell/testcases/optimizations/merge_stmts_concat
@@ -12,6 +12,8 @@ RULESET="table ip x {
 		meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.4.0-2.2.4.10 accept
 		meta iifname eth2 ip saddr 1.1.1.3 ip daddr 2.2.2.5 accept
 		ip protocol . th dport { tcp . 22, udp . 67 }
+		udp dport 137 ct state new,untracked accept
+		udp dport 138 ct state new,untracked accept
 	}
 }"
 
-- 
2.30.2

