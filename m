Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195C4215F6B
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 19:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727897942; cv=none; b=BBCfBfYcpGCTUF2J7hNjEnbp1vg/GaC2edWMR1q/vQ7+KGmL4dr8fM2A9gpwBMnY8pbnNq9eAd9UDHfLmGq3HXFnSo1jOo7di/TGZNrsA2KdWYz1zLoGHyejAElhcp5v7CspoA1uECUDXAcemAMYgYBw3dU0zIbCXk1ZfqvzPYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727897942; c=relaxed/simple;
	bh=QfhrtNMtE+tAI1PUYAegbOL4E+GFx/51cYhUkTFut98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpT529zuAeb4BYBOniY5128EYUCDJ6mtOZt9REdm5aDSVnPsamggx1Vr4lXLqruQwvKZ745+W+LypTrLtOo5fGHngpQ5z8No+qs4TFfU4fGPfhIs+viX+xYrdQ/RoR0AdUyUgQUua9F1/qAMUhRKLJgK6WkI+iUL4ScxyKwKRsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gHpz+5kW; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gHpz+5kW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8brUj/HEw+T+2uSmbvegEqqVsSdb/dCfFVguNueJuNg=; b=gHpz+5kWDEl3Q0Q6eZTAfRhS0C
	L40gsaj2/vsCVCAX9lNrtLANThOAY61NaBY0BRyjNTKzLZy48PTPutbnoJ5am2xevM4Y1PXk8Scud
	OuFsj8iNGqzqjXLwGwQ4AYBHGl2S/4n2DoB7ztYqmX5CX/Gwmx8oUOFKqtnH8wPMsu/xbMhhJKuFX
	jKko6oL5+62N1+FOl2bjBIo22BEOJaG9oJWn1MbbbZSP2VDTRMVSluQTSFomf4mFbXL9+vPl0IaVL
	ISLfkZ8VDw6lsYHi5bwD1L0hnCyoFM/RiF/qPdGFGCd0em8LQ9CIuIyJuFVgnlyQUu5gK8a2S9ZIl
	XJri2pzQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sw5Bb-0000000030o-2GwT;
	Wed, 02 Oct 2024 21:38:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 7/9] tests: shell: Adjust to ifname-based flowtables
Date: Wed,  2 Oct 2024 21:38:51 +0200
Message-ID: <20241002193853.13818-8-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241002193853.13818-1-phil@nwl.cc>
References: <20241002193853.13818-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Removed interfaces will remain in place in dumps. Also drop
transactions/0050rule_1 test entirely: It won't fail anymore as the
flowtable is accepted despite the non-existent interfaces and thus the
test as a whole does not work anymore.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../chains/dumps/netdev_chain_0.json-nft      | 17 +++++++++++++++++
 .../testcases/chains/dumps/netdev_chain_0.nft |  3 +++
 .../netdev_chain_dormant_autoremove.json-nft  |  5 ++++-
 .../dumps/netdev_chain_dormant_autoremove.nft |  2 +-
 .../dumps/0012flowtable_variable_0.json-nft   | 10 ++++++++--
 .../dumps/0012flowtable_variable_0.nft        |  4 ++--
 .../testcases/json/dumps/netdev.json-nft      | 13 +++++++++++++
 tests/shell/testcases/json/dumps/netdev.nft   |  3 +++
 .../listing/dumps/0020flowtable_0.json-nft    |  6 ++++--
 .../listing/dumps/0020flowtable_0.nft         |  2 ++
 tests/shell/testcases/transactions/0050rule_1 | 19 -------------------
 .../transactions/dumps/0050rule_1.json-nft    | 11 -----------
 .../transactions/dumps/0050rule_1.nft         |  0
 13 files changed, 57 insertions(+), 38 deletions(-)
 delete mode 100755 tests/shell/testcases/transactions/0050rule_1
 delete mode 100644 tests/shell/testcases/transactions/dumps/0050rule_1.json-nft
 delete mode 100644 tests/shell/testcases/transactions/dumps/0050rule_1.nft

diff --git a/tests/shell/testcases/chains/dumps/netdev_chain_0.json-nft b/tests/shell/testcases/chains/dumps/netdev_chain_0.json-nft
index 7d78bd6757034..13e9f6bb016f7 100644
--- a/tests/shell/testcases/chains/dumps/netdev_chain_0.json-nft
+++ b/tests/shell/testcases/chains/dumps/netdev_chain_0.json-nft
@@ -13,6 +13,23 @@
         "name": "x",
         "handle": 0
       }
+    },
+    {
+      "chain": {
+        "family": "netdev",
+        "table": "x",
+        "name": "y",
+        "handle": 0,
+        "dev": [
+          "d0",
+          "d1",
+          "d2"
+        ],
+        "type": "filter",
+        "hook": "ingress",
+        "prio": 0,
+        "policy": "accept"
+      }
     }
   ]
 }
diff --git a/tests/shell/testcases/chains/dumps/netdev_chain_0.nft b/tests/shell/testcases/chains/dumps/netdev_chain_0.nft
index aa571e00885fe..6606d5bc3f608 100644
--- a/tests/shell/testcases/chains/dumps/netdev_chain_0.nft
+++ b/tests/shell/testcases/chains/dumps/netdev_chain_0.nft
@@ -1,2 +1,5 @@
 table netdev x {
+	chain y {
+		type filter hook ingress devices = { d0, d1, d2 } priority filter; policy accept;
+	}
 }
diff --git a/tests/shell/testcases/chains/dumps/netdev_chain_dormant_autoremove.json-nft b/tests/shell/testcases/chains/dumps/netdev_chain_dormant_autoremove.json-nft
index 9151d42f17d91..88b8958f4d86e 100644
--- a/tests/shell/testcases/chains/dumps/netdev_chain_dormant_autoremove.json-nft
+++ b/tests/shell/testcases/chains/dumps/netdev_chain_dormant_autoremove.json-nft
@@ -21,7 +21,10 @@
         "table": "test",
         "name": "ingress",
         "handle": 0,
-        "dev": "dummy1",
+        "dev": [
+          "dummy0",
+          "dummy1"
+        ],
         "type": "filter",
         "hook": "ingress",
         "prio": 0,
diff --git a/tests/shell/testcases/chains/dumps/netdev_chain_dormant_autoremove.nft b/tests/shell/testcases/chains/dumps/netdev_chain_dormant_autoremove.nft
index aad7cb6337734..f4bd9556b3e03 100644
--- a/tests/shell/testcases/chains/dumps/netdev_chain_dormant_autoremove.nft
+++ b/tests/shell/testcases/chains/dumps/netdev_chain_dormant_autoremove.nft
@@ -2,6 +2,6 @@ table netdev test {
 	flags dormant
 
 	chain ingress {
-		type filter hook ingress device "dummy1" priority filter; policy drop;
+		type filter hook ingress devices = { dummy0, dummy1 } priority filter; policy drop;
 	}
 }
diff --git a/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.json-nft b/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.json-nft
index 10f1df98874ab..20da08fb2fc29 100644
--- a/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.json-nft
+++ b/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.json-nft
@@ -22,7 +22,10 @@
         "handle": 0,
         "hook": "ingress",
         "prio": 0,
-        "dev": "lo"
+        "dev": [
+          "dummy1",
+          "lo"
+        ]
       }
     },
     {
@@ -40,7 +43,10 @@
         "handle": 0,
         "hook": "ingress",
         "prio": 0,
-        "dev": "lo"
+        "dev": [
+          "dummy1",
+          "lo"
+        ]
       }
     }
   ]
diff --git a/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft b/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft
index df1c51a247033..1cbb2f1103f03 100644
--- a/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft
+++ b/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft
@@ -1,14 +1,14 @@
 table ip filter1 {
 	flowtable Main_ft1 {
 		hook ingress priority filter
-		devices = { lo }
+		devices = { dummy1, lo }
 		counter
 	}
 }
 table ip filter2 {
 	flowtable Main_ft2 {
 		hook ingress priority filter
-		devices = { lo }
+		devices = { dummy1, lo }
 		counter
 	}
 }
diff --git a/tests/shell/testcases/json/dumps/netdev.json-nft b/tests/shell/testcases/json/dumps/netdev.json-nft
index e0d2bfb4385b7..6eb19a17b31d9 100644
--- a/tests/shell/testcases/json/dumps/netdev.json-nft
+++ b/tests/shell/testcases/json/dumps/netdev.json-nft
@@ -13,6 +13,19 @@
         "name": "test_table",
         "handle": 0
       }
+    },
+    {
+      "chain": {
+        "family": "netdev",
+        "table": "test_table",
+        "name": "test_chain",
+        "handle": 0,
+        "dev": "d0",
+        "type": "filter",
+        "hook": "ingress",
+        "prio": 0,
+        "policy": "accept"
+      }
     }
   ]
 }
diff --git a/tests/shell/testcases/json/dumps/netdev.nft b/tests/shell/testcases/json/dumps/netdev.nft
index 3c568ed3eb38d..373ea0a46d600 100644
--- a/tests/shell/testcases/json/dumps/netdev.nft
+++ b/tests/shell/testcases/json/dumps/netdev.nft
@@ -1,2 +1,5 @@
 table netdev test_table {
+	chain test_chain {
+		type filter hook ingress device "d0" priority filter; policy accept;
+	}
 }
diff --git a/tests/shell/testcases/listing/dumps/0020flowtable_0.json-nft b/tests/shell/testcases/listing/dumps/0020flowtable_0.json-nft
index d511739abd4b6..b1b3a5fba34a0 100644
--- a/tests/shell/testcases/listing/dumps/0020flowtable_0.json-nft
+++ b/tests/shell/testcases/listing/dumps/0020flowtable_0.json-nft
@@ -32,7 +32,8 @@
         "table": "filter",
         "handle": 0,
         "hook": "ingress",
-        "prio": 0
+        "prio": 0,
+        "dev": "d0"
       }
     },
     {
@@ -60,7 +61,8 @@
         "table": "filter",
         "handle": 0,
         "hook": "ingress",
-        "prio": 0
+        "prio": 0,
+        "dev": "d0"
       }
     }
   ]
diff --git a/tests/shell/testcases/listing/dumps/0020flowtable_0.nft b/tests/shell/testcases/listing/dumps/0020flowtable_0.nft
index 4a64e531db840..59fcbec8e5130 100644
--- a/tests/shell/testcases/listing/dumps/0020flowtable_0.nft
+++ b/tests/shell/testcases/listing/dumps/0020flowtable_0.nft
@@ -6,6 +6,7 @@ table inet filter {
 
 	flowtable f2 {
 		hook ingress priority filter
+		devices = { d0 }
 	}
 }
 table ip filter {
@@ -16,5 +17,6 @@ table ip filter {
 
 	flowtable f2 {
 		hook ingress priority filter
+		devices = { d0 }
 	}
 }
diff --git a/tests/shell/testcases/transactions/0050rule_1 b/tests/shell/testcases/transactions/0050rule_1
deleted file mode 100755
index 89e5f42fc9f4d..0000000000000
--- a/tests/shell/testcases/transactions/0050rule_1
+++ /dev/null
@@ -1,19 +0,0 @@
-#!/bin/bash
-
-set -e
-
-RULESET="table inet filter {
-	flowtable ftable {
-		hook ingress priority 0; devices = { eno1, eno0, x };
-	}
-
-chain forward {
-	type filter hook forward priority 0; policy drop;
-
-	ip protocol { tcp, udp } ct mark and 1 == 1 counter flow add @ftable
-	ip6 nexthdr { tcp, udp } ct mark and 2 == 2 counter flow add @ftable
-	ct mark and 30 == 30 ct state established,related log prefix \"nftables accept: \" level info accept
-	}
-}"
-
-$NFT -f - <<< "$RULESET" >/dev/null || exit 0
diff --git a/tests/shell/testcases/transactions/dumps/0050rule_1.json-nft b/tests/shell/testcases/transactions/dumps/0050rule_1.json-nft
deleted file mode 100644
index 546cc5977db61..0000000000000
--- a/tests/shell/testcases/transactions/dumps/0050rule_1.json-nft
+++ /dev/null
@@ -1,11 +0,0 @@
-{
-  "nftables": [
-    {
-      "metainfo": {
-        "version": "VERSION",
-        "release_name": "RELEASE_NAME",
-        "json_schema_version": 1
-      }
-    }
-  ]
-}
diff --git a/tests/shell/testcases/transactions/dumps/0050rule_1.nft b/tests/shell/testcases/transactions/dumps/0050rule_1.nft
deleted file mode 100644
index e69de29bb2d1d..0000000000000
-- 
2.43.0

