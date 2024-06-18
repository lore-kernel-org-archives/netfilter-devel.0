Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F75200B7
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2024 15:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718725100; cv=none; b=GC9Oevvc3Ij49Gg5wYxKoBcgJ3YZYkK3wx5LzY1V+izmN680/w0y2ep06D6CVXRqpe41PVEwXlTdRMcXYkQIbdFIXyqjr0JZ5M+IIDJkCXH5GDm1gvKahanJLlvWMCYoA0Hz62OXExG6S32WlIJ/b5v6UYMWqVqKNPCLvWQZX5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718725100; c=relaxed/simple;
	bh=BAS0swsXsHu1UUyUrk/qKvCh3sX3N3gZQbET7GzPR+8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=e/KiHcHqm63338jyO4nXAcI+L21EP65C3nCWNFqwX+/xVtQ8Rcbkf+LYeLsGB9cVQ5nZsp8vnI0NXpKuzXJK4WlN7cIU0kfbveylIUBolTqzKfVkkDyj1gh9kPfhKCCAJmxUYS6cGiNrJcaW206PPpDbvGmQJlPxXWe18oaNM0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: py: drop redundant JSON outputs
Date: Tue, 18 Jun 2024 17:38:05 +0200
Message-Id: <20240618153805.187607-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

8abe71f862e6 ("tests: py: Warn if recorded JSON output matches the input")
adds a warning on duplicated JSON outputs.

Remove them when running tests with -j:

  WARNING: Recorded JSON output matches input for: icmp code { 2, 4, 54, 33, 56}

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/icmp.t.json.output    | 24 ------------
 tests/py/ip6/icmpv6.t.json.output | 62 -------------------------------
 2 files changed, 86 deletions(-)

diff --git a/tests/py/ip/icmp.t.json.output b/tests/py/ip/icmp.t.json.output
index 52fd6016e116..d79e72b59669 100644
--- a/tests/py/ip/icmp.t.json.output
+++ b/tests/py/ip/icmp.t.json.output
@@ -1,27 +1,3 @@
-# icmp code { 2, 4, 54, 33, 56}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "code",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    2,
-                    4,
-                    33,
-                    54,
-                    56
-                ]
-            }
-        }
-    }
-]
-
 # icmp id 1245 log
 [
     {
diff --git a/tests/py/ip6/icmpv6.t.json.output b/tests/py/ip6/icmpv6.t.json.output
index f29b346c0c9b..5d33780ee82b 100644
--- a/tests/py/ip6/icmpv6.t.json.output
+++ b/tests/py/ip6/icmpv6.t.json.output
@@ -93,68 +93,6 @@
     }
 ]
 
-# icmpv6 code 4
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "code",
-                    "protocol": "icmpv6"
-                }
-            },
-            "op": "==",
-            "right": 4
-        }
-    }
-]
-
-# icmpv6 code 3-66
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "code",
-                    "protocol": "icmpv6"
-                }
-            },
-            "op": "==",
-            "right": {
-                "range": [
-                    3,
-                    66
-                ]
-            }
-        }
-    }
-]
-
-# icmpv6 code {5, 6, 7} accept
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "code",
-                    "protocol": "icmpv6"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    5,
-                    6,
-                    7
-                ]
-            }
-        }
-    },
-    {
-        "accept": null
-    }
-]
-
 # icmpv6 code { 3-66}
 [
     {
-- 
2.30.2

