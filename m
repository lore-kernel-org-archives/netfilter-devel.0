Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714992BD584
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104763; cv=none; b=H0uaRl3CxQe88h8M+foYJa/4JJ+wl84f1PqtI2YYX6TpE1O/GvwYAn3o/l30uoEirUBy3S7tr66QQESJaDcFb/ctPws+zZWHjPprdIhqjdozUQV/P6WPrzDzHBYbufPfiCg+na+NmUUuTZ6NrkRbxy8arkBfOSNEAMfiZD4ezV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104763; c=relaxed/simple;
	bh=DO9qapsvNWg27CRZV29YbEZbUPRfnHXthCjtantmIP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvAxZDSjJfKJRiBnAbDZ2PvgNkrpWIjSt3gsraQ6ZbFpZ1a8NuyvSFIyUQqKUuDWPc96cM83KzGQ/KbP35f8JZ5c891pFLW6ANZIrapia1/Zp8/n1lNfWgll0EHS9bRSJzIXWzCVbs0x+MzLwf2tSaY+M/+HfnZDXxlfIFZLYVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=TfqVDfzA; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="TfqVDfzA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+Zus8DAWLR2SMaNOJuHXp7E3oha8ENCvjlnZYLiRWfo=; b=TfqVDfzA1p2WugIuUCHT8IBAnE
	HtxXE7YpJzOAlS4hp5vb2To+PaCgXkUoFZqvPamOjG4+o/vtlYCaEMNKMDypJPQN7+QJPegJqjRxU
	OGv98Wcop9oM5NIs0NErgGctNi9MPtoOMvN/7PGksepZu19nxiUchqMEvRw4uhA/pqaoa4A02X9or
	Ff1KS/CcEN1nmKi3Ur0iJEkBv1WO6GdPK1w0r5WcrZgJjw5iKBDuLfNEG9tB7zEP/GfQ6XA09kx7/
	7xOzamtbr8EeKBxDuf98fpBZ7HuaSCL3L5K/F3w/IpoDBEVOdkrij1HR8TthKoZ9KSjzP0T7iIsIk
	oUhoMPNA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umEvJ-000000003oJ-07OU;
	Wed, 13 Aug 2025 19:06:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 13/14] tests: py: Fix tests added for 'icmpv6 taddr' support
Date: Wed, 13 Aug 2025 19:05:48 +0200
Message-ID: <20250813170549.27880-14-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250813170549.27880-1-phil@nwl.cc>
References: <20250813170549.27880-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There was a duplicate test, also stored JSON equivalents should match
input as much as possible. The expected deviation in output (just like
with standard syntax) is stored in the .json.output file instead.

Fixes: 2e86f45d0260a ("icmpv6: Allow matching target address in NS/NA, redirect and MLD")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/ip6/icmpv6.t             |  2 --
 tests/py/ip6/icmpv6.t.json        | 58 -------------------------------
 tests/py/ip6/icmpv6.t.json.output | 36 +++++++++++++++++++
 3 files changed, 36 insertions(+), 60 deletions(-)

diff --git a/tests/py/ip6/icmpv6.t b/tests/py/ip6/icmpv6.t
index 7632bfd878f47..5108b427a60a5 100644
--- a/tests/py/ip6/icmpv6.t
+++ b/tests/py/ip6/icmpv6.t
@@ -91,8 +91,6 @@ icmpv6 type nd-neighbor-solicit icmpv6 taddr 2001:db8::133;ok
 icmpv6 type nd-neighbor-advert icmpv6 taddr 2001:db8::133;ok
 icmpv6 taddr 2001:db8::133;ok;icmpv6 type { mld-listener-query, mld-listener-report, mld-listener-done, nd-neighbor-solicit, nd-neighbor-advert, nd-redirect} icmpv6 taddr 2001:db8::133
 
-icmpv6 taddr 2001:db8::133;ok;icmpv6 type { mld-listener-query, mld-listener-report, mld-listener-done, nd-neighbor-solicit, nd-neighbor-advert, nd-redirect} icmpv6 taddr 2001:db8::133
-
 icmpv6 type { mld-listener-query, mld-listener-report, mld-listener-done, nd-neighbor-solicit, nd-neighbor-advert, nd-redirect} icmpv6 taddr 2001:db8::133;ok
 icmpv6 type { nd-neighbor-solicit, nd-neighbor-advert } icmpv6 taddr 2001:db8::133;ok
 icmpv6 daddr 2001:db8::133;ok
diff --git a/tests/py/ip6/icmpv6.t.json b/tests/py/ip6/icmpv6.t.json
index 9df886dd22772..5c36aabaaaee5 100644
--- a/tests/py/ip6/icmpv6.t.json
+++ b/tests/py/ip6/icmpv6.t.json
@@ -1250,64 +1250,6 @@
 
 # icmpv6 taddr 2001:db8::133
 [
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "icmpv6"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    "mld-listener-query",
-                    "mld-listener-report",
-                    "mld-listener-done",
-                    "nd-neighbor-solicit",
-                    "nd-neighbor-advert",
-                    "nd-redirect"
-                ]
-            }
-        }
-    },
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "taddr",
-                    "protocol": "icmpv6"
-                }
-            },
-            "op": "==",
-            "right": "2001:db8::133"
-        }
-    }
-]
-
-# icmpv6 taddr 2001:db8::133
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "icmpv6"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    "mld-listener-query",
-                    "mld-listener-report",
-                    "mld-listener-done",
-                    "nd-neighbor-solicit",
-                    "nd-neighbor-advert",
-                    "nd-redirect"
-                ]
-            }
-        }
-    },
     {
         "match": {
             "left": {
diff --git a/tests/py/ip6/icmpv6.t.json.output b/tests/py/ip6/icmpv6.t.json.output
index 5d33780ee82ba..568bdb533910a 100644
--- a/tests/py/ip6/icmpv6.t.json.output
+++ b/tests/py/ip6/icmpv6.t.json.output
@@ -696,3 +696,39 @@
     }
 ]
 
+# icmpv6 taddr 2001:db8::133
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "mld-listener-query",
+                    "mld-listener-report",
+                    "mld-listener-done",
+                    "nd-neighbor-solicit",
+                    "nd-neighbor-advert",
+                    "nd-redirect"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "taddr",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": "2001:db8::133"
+        }
+    }
+]
-- 
2.49.0

