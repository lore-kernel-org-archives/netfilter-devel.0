Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6880E2356D9
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236091; cv=none; b=eJwyV6MafrvcjBC55pqdAmyOccEqrNGlXlR9KeYEritckw2u6i/6uZsOwp3CDT2Zyd4KuqAX8NlJ5JmLxGXT4UbaNG+iJHY4NORJLQebTcZtp/0G4ywzo8Bo/XtIx/xeH1RNg2UwCONNQanQ/uaomE2yV+WIfFG5K0/vtbi1YOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236091; c=relaxed/simple;
	bh=m7NYhs9C9qAvm7dV5ZO/YUuYW36e8Y2zDcr9d3N7eoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKyJeW1W1/uSoR6trbCKgJApgIT/eeivsgwzxiRontUSr58D4mMMi1CVDhQtPrFEJ+K3ZxjRngW2FcMER4UbP2VOGykZQZIjWOeyf1zC2GanQOzRb3CzVixoyC4Nguc8a9B08DheWEJjFJ4ie/jQtTk1VRM21RkWiEk8T78Mtlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=iU8L/U4a; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iU8L/U4a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fY7CRsHqNvOXPn8OAMmU1FwjqEwEZzK57+/WWDNVmSc=; b=iU8L/U4agDN7hGjRpNpkuXO46Z
	YnhewgKqptD++dyyLcZ5fYWTL8r7Y02f76rRXQ2lV2qA8Wweyp/6CjJKd4/F/37HwetSAxZjUQ2U8
	GfJaqyOZk9MtAmVWu15EsXu3kRtrIe8Mnnpy7nVjJSVMwurO6LJq04kHoA21e5bodJX9X4jBSLjiH
	HGTIIiLMrYBgQKLgAucv7Cz7Biv2AwqPCAYFybjNOyJtjogXOvTchFf55xti/kixXrSnaDHoZFJ6F
	0qehkZigNPWZQJGJTT40vCtWkFhNmml/B7fdcs8Y4pmB7BA32bwf0jeUoLDeMOvchSAVl6zH5D4DX
	mt8EqTEw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxg-00000000070-27va;
	Thu, 23 Oct 2025 18:14:48 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 05/28] tests: py: inet/osf.t: Fix element ordering in JSON equivalents
Date: Thu, 23 Oct 2025 18:13:54 +0200
Message-ID: <20251023161417.13228-6-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The original rules order set elements differently. Stick to that and add
entries to inet/osf.t.json.output to cover for nftables reordering
entries.

Fixes: 92029c1282958 ("src: osf: add json support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/inet/osf.t.json        | 12 ++++----
 tests/py/inet/osf.t.json.output | 53 +++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 6 deletions(-)
 create mode 100644 tests/py/inet/osf.t.json.output

diff --git a/tests/py/inet/osf.t.json b/tests/py/inet/osf.t.json
index cedb7f67bd52f..b1bf747265f81 100644
--- a/tests/py/inet/osf.t.json
+++ b/tests/py/inet/osf.t.json
@@ -73,8 +73,8 @@
             "op": "==",
             "right": {
                 "set": [
-                    "MacOs",
-                    "Windows"
+                    "Windows",
+                    "MacOs"
                 ]
             }
         }
@@ -114,13 +114,13 @@
                 "map": {
                     "data": {
                         "set": [
-                            [
-                                "MacOs",
-                                2
-                            ],
                             [
                                 "Windows",
                                 1
+                            ],
+                            [
+                                "MacOs",
+                                2
                             ]
                         ]
                     },
diff --git a/tests/py/inet/osf.t.json.output b/tests/py/inet/osf.t.json.output
new file mode 100644
index 0000000000000..922e395f202c7
--- /dev/null
+++ b/tests/py/inet/osf.t.json.output
@@ -0,0 +1,53 @@
+# osf name { "Windows", "MacOs" }
+[
+    {
+        "match": {
+            "left": {
+                "osf": {
+                    "key": "name"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "MacOs",
+                    "Windows"
+                ]
+            }
+        }
+    }
+]
+
+# ct mark set osf name map { "Windows" : 0x00000001, "MacOs" : 0x00000002 }
+[
+    {
+        "mangle": {
+            "key": {
+                "ct": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                "MacOs",
+                                2
+                            ],
+                            [
+                                "Windows",
+                                1
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "osf": {
+                            "key": "name"
+                        }
+                    }
+                }
+            }
+        }
+    }
+]
-- 
2.51.0

