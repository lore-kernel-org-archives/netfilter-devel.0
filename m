Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2402C0299
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Feb 2026 11:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771241775; cv=none; b=unL1VEjn9CDjq0SNIZmUA71rp1o/UskEZJgUZqxZlmHVcqkr4XpODwBhe9kY9d0/Z0IE96TXnOorPqg799ddFSUiTxwAtgLx5CNPGjFTCt8WCW/ON/oDIUS203OklFpcqJ7bVZ+Q+X78gd2QvyDimpjYsPnP2wCz9SUSqgFwVdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771241775; c=relaxed/simple;
	bh=TK2H9dUwIpeJBJi5XxsvDDdrnQPAetldgfLEabWHIyY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=bTfKv29bMRb+hidQRm75sqZloivrASLpJb1Zdxf41oaaTCy7sC0Ia6qk03zMDfM5YeaonSQMk5bw6Aggny5B+Ff/3auErbQRsh8b4oUwJBDDH3NDzRmsgcZe4swf3riEMuNbVvW8GhFXE/5lWMBdl+FoMzahoE7HZ8UlbgbCdVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cu/mntiq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cu/mntiq"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A094960263
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Feb 2026 12:26:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1771241209;
	bh=L8B9nQY+X6hUMuLVrmOmbbZ09Ap1CDKA/7MKA4knino=;
	h=From:To:Subject:Date:From;
	b=cu/mntiqfSYM6SYBhI7lQOiP6y3YL7TswzLryG4R0JnuN8uqi+r3iEWXH1OaYur0A
	 hRbmRfvaakwjXUwLxj3cbdheenoGZN4+XRdZYFotLlmiEUXZW51wO0Sbmxi6IV2L3D
	 xqrq1HjxMJaep3LJUALCSnGbkvRDLqJPFB6ZAAT3dyEO9LhidW0L2JNy/75DPwXAuF
	 hJrIbqd8KWyWX9dupFbb41uETUzlsAW8vK5iZm+qooYV2ugb01dvmJl7RUaD9nh/6l
	 FxK6sLsQtHPPIBvN6UJn9utYpggesZ6ftNrKYuCIEDoo4gKG0Pi8oAdjxjcFvazU9x
	 fLKGMkA9tCfBw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] json: complete multi-statement set element support
Date: Mon, 16 Feb 2026 12:26:45 +0100
Message-ID: <20260216112645.1739412-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove artificial limitation on the maximum number of statements per
element in listings.

Moreover, update tests/shell which are currently incorrect.

Fixes: e6d1d0d61195 ("src: add set element multi-statement support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/json.c                                         |  2 --
 .../nft-f/dumps/0025empty_dynset_0.json-nft        |  4 ++++
 .../sets/dumps/0060set_multistmt_0.json-nft        | 12 ++++++++++++
 .../sets/dumps/0060set_multistmt_1.json-nft        | 14 ++++++++++++++
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/src/json.c b/src/json.c
index 3c369fb916d0..7312215dede4 100644
--- a/src/json.c
+++ b/src/json.c
@@ -821,8 +821,6 @@ static json_t *__set_elem_expr_json(const struct expr *expr,
 			/* XXX: detect and complain about clashes? */
 			json_object_update_missing(root, tmp);
 			json_decref(tmp);
-			/* TODO: only one statement per element. */
-			break;
 		}
 		return nft_json_pack("{s:o}", "elem", root);
 	}
diff --git a/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.json-nft b/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.json-nft
index 0cde23b00000..5e73c644805d 100644
--- a/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.json-nft
@@ -101,6 +101,10 @@
                 "rate": 1,
                 "burst": 5,
                 "per": "second"
+              },
+              "counter": {
+                "packets": 0,
+                "bytes": 0
               }
             }
           }
diff --git a/tests/shell/testcases/sets/dumps/0060set_multistmt_0.json-nft b/tests/shell/testcases/sets/dumps/0060set_multistmt_0.json-nft
index 1aede147cacf..8622d50f8e96 100644
--- a/tests/shell/testcases/sets/dumps/0060set_multistmt_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0060set_multistmt_0.json-nft
@@ -41,6 +41,10 @@
                 "rate": 1,
                 "burst": 5,
                 "per": "second"
+              },
+              "counter": {
+                "packets": 0,
+                "bytes": 0
               }
             }
           },
@@ -51,6 +55,10 @@
                 "rate": 1,
                 "burst": 5,
                 "per": "second"
+              },
+              "counter": {
+                "packets": 0,
+                "bytes": 0
               }
             }
           },
@@ -61,6 +69,10 @@
                 "rate": 1,
                 "burst": 5,
                 "per": "second"
+              },
+              "counter": {
+                "packets": 0,
+                "bytes": 0
               }
             }
           }
diff --git a/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft b/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft
index 6098dc563141..aea0fe493981 100644
--- a/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft
+++ b/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft
@@ -44,6 +44,10 @@
               "counter": {
                 "packets": 0,
                 "bytes": 0
+              },
+              "quota": {
+                "val": 500,
+                "val_unit": "bytes"
               }
             }
           },
@@ -53,6 +57,12 @@
               "counter": {
                 "packets": 9,
                 "bytes": 756
+              },
+              "quota": {
+                "val": 500,
+                "val_unit": "bytes",
+                "used": 500,
+                "used_unit": "bytes"
               }
             }
           },
@@ -62,6 +72,10 @@
               "counter": {
                 "packets": 0,
                 "bytes": 0
+              },
+              "quota": {
+                "val": 1000,
+                "val_unit": "bytes"
               }
             }
           }
-- 
2.47.3

