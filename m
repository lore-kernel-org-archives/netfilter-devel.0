Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE455A0E6
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Mar 2024 16:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711123614; cv=none; b=tKqiQiElbBEaxx0dzPcWpQi2hpcw9xPD3AkqYvgRVv9Sqlf2tWHo/Peo9i2d0XuNYc2c2kmukcEggtTDn5MDlbpS5StPj06qUD0z8FBjhHjWR3UyEj8wR3ehkMGT2IRnxBiDf1tGniakdAe2iy+OdKE5h0jcZJKv7fJNxDUAKZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711123614; c=relaxed/simple;
	bh=PKGDrrwUHWswjrXl4pHDmwwhDEH9Rjn3IQCDeAXlU9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4WkGtSrYLLacSKfUJ+5RBP+lJxQAmU8nSH3S43P5eRrI77r3Qmyg3s+8JkXOZzml1yJZ3hSZ/vjaVpSH5JPkYiJjCBzQqbQE44AjoEW97CEY9wVEqSvR9qdfwcarlNYtioResYmj01XqQBOYcB93LcI6YPt8Pv/dZdenjSrSLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LxRChuQ6; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LxRChuQ6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=X8F5/VJV2rsGvCYNDc7wCvoQUOhgQPO0+VMXzkHKuEg=; b=LxRChuQ6hvn3HQPO9YNXchl8SY
	NPzSQMfylZI7AdgLk7RsdfptAM6nZlEm8cKRkYzVx11dYV2hrfXn2rE5yDmuInwfw0xTstPHT6SZ/
	5oscJGhAdF+XmYF4YgfKEcCUUraKunGbwXpWFeE65JvGbPk+EZ/jod1fvA+e/Oje8wH1eF6T8dPnB
	cOxhplTTRif0mKWg56izZiM4omme/2VRUIKUZypbsxQCqPCmOHfX0WVvGT/0po8ydC0rd5hmdu074
	0Klsn9UH1n777blqSJ2BQuudEjD5uaim+PunaMinbUNXfNvRRtsceRJZVEByrf3gm3NA4pLK23oEC
	6DsC4x3g==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rnhPu-000000000yZ-496A;
	Fri, 22 Mar 2024 17:06:51 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 3/5] tests: py: Fix some JSON equivalents
Date: Fri, 22 Mar 2024 17:06:43 +0100
Message-ID: <20240322160645.18331-4-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240322160645.18331-1-phil@nwl.cc>
References: <20240322160645.18331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure they match the standard syntax input as much as possible.

For some reason inet/tcp.t.json was using plain arrays in place of
binary OR expressions in many cases. These arrays are interpreted as
list expressions, which seems to be semantically identical but the goal
here is to present an accurate equivalent to the rule in standard
syntax.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/any/meta.t.json   |   2 +-
 tests/py/any/tcpopt.t.json |   4 +-
 tests/py/inet/tcp.t.json   | 124 +++++++++++++++++++++----------------
 3 files changed, 75 insertions(+), 55 deletions(-)

diff --git a/tests/py/any/meta.t.json b/tests/py/any/meta.t.json
index d50272de55a5b..60e27d48fdf03 100644
--- a/tests/py/any/meta.t.json
+++ b/tests/py/any/meta.t.json
@@ -2661,7 +2661,7 @@
                 }
             },
             "op": "==",
-            "right": "17:00"
+            "right": "17:00:00"
         }
     },
     {
diff --git a/tests/py/any/tcpopt.t.json b/tests/py/any/tcpopt.t.json
index 4466f14fac638..87074b9d216a3 100644
--- a/tests/py/any/tcpopt.t.json
+++ b/tests/py/any/tcpopt.t.json
@@ -192,7 +192,7 @@
             "left": {
                 "tcp option": {
                     "field": "left",
-                    "name": "sack"
+                    "name": "sack0"
                 }
             },
             "op": "==",
@@ -272,7 +272,7 @@
             "left": {
                 "tcp option": {
                     "field": "right",
-                    "name": "sack"
+                    "name": "sack0"
                 }
             },
             "op": "==",
diff --git a/tests/py/inet/tcp.t.json b/tests/py/inet/tcp.t.json
index bd589cf0091fe..28dd4341f08b5 100644
--- a/tests/py/inet/tcp.t.json
+++ b/tests/py/inet/tcp.t.json
@@ -1370,13 +1370,13 @@
             "op": "==",
             "right": {
                 "set": [
+                    "syn",
                     {
                         "|": [
                             "syn",
                             "ack"
                         ]
-                    },
-                    "syn"
+                    }
                 ]
             }
         }
@@ -1401,10 +1401,10 @@
             "op": "==",
             "right": {
                 "set": [
-                    { "|": [ "fin", "psh", "ack" ] },
                     "fin",
+                    "ack",
                     { "|": [ "psh", "ack" ] },
-                    "ack"
+                    { "|": [ "fin", "psh", "ack" ] }
                 ]
             }
         }
@@ -1442,17 +1442,21 @@
                             "protocol": "tcp"
                         }
                     },
-                    [
-                        "fin",
-                        "syn"
-                    ]
+                    {
+                        "|": [
+                            "fin",
+                            "syn"
+                        ]
+                    }
                 ]
             },
             "op": "==",
-            "right": [
-                "fin",
-                "syn"
-            ]
+            "right": {
+                "|": [
+                    "fin",
+                    "syn"
+                ]
+            }
         }
     }
 ]
@@ -1469,10 +1473,12 @@
                             "protocol": "tcp"
                         }
                     },
-                    [
-                        "fin",
-                        "syn"
-                    ]
+                    {
+                        "|": [
+                            "fin",
+                            "syn"
+                        ]
+                    }
                 ]
             },
             "op": "!=",
@@ -1605,12 +1611,14 @@
                             "protocol": "tcp"
                         }
                     },
-                    [
-                        "fin",
-                        "syn",
-                        "rst",
-                        "ack"
-                    ]
+                    {
+                        "|": [
+                            "fin",
+                            "syn",
+                            "rst",
+                            "ack"
+                        ]
+                    }
                 ]
             },
             "op": "==",
@@ -1631,12 +1639,14 @@
                             "protocol": "tcp"
                         }
                     },
-                    [
-                        "fin",
-                        "syn",
-                        "rst",
-                        "ack"
-                    ]
+                    {
+                        "|": [
+                            "fin",
+                            "syn",
+                            "rst",
+                            "ack"
+                        ]
+                    }
                 ]
             },
             "op": "==",
@@ -1658,12 +1668,14 @@
                             "protocol": "tcp"
                         }
                     },
-                    [
-                        "fin",
-                        "syn",
-                        "rst",
-                        "ack"
-                    ]
+                    {
+                        "|": [
+                            "fin",
+                            "syn",
+                            "rst",
+                            "ack"
+                        ]
+                    }
                 ]
             },
             "op": "!=",
@@ -1684,19 +1696,23 @@
                             "protocol": "tcp"
                         }
                     },
-                    [
-                        "fin",
-                        "syn",
-                        "rst",
-                        "ack"
-                    ]
+                    {
+                        "|": [
+                            "fin",
+                            "syn",
+                            "rst",
+                            "ack"
+                        ]
+                    }
                 ]
             },
             "op": "==",
-            "right": [
-                "syn",
-                "ack"
-            ]
+            "right": {
+                "|": [
+                    "syn",
+                    "ack"
+                ]
+            }
         }
     }
 ]
@@ -1713,17 +1729,21 @@
                             "protocol": "tcp"
                         }
                     },
-                    [
-                        "syn",
-                        "ack"
-                    ]
+                    {
+                        "|": [
+                            "syn",
+                            "ack"
+                        ]
+                    }
                 ]
             },
             "op": "==",
-            "right": [
-                "syn",
-                "ack"
-            ]
+            "right": {
+                "|": [
+                    "syn",
+                    "ack"
+                ]
+            }
         }
     }
 ]
-- 
2.43.0

