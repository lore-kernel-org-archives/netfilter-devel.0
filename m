Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAA4224AFA
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 11:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749729155; cv=none; b=XobENEEYH/w9vTCLwOp8dLdY+DPScOBdueJB8D4Wdo2iPkBSz1q2ImZKaVKNVkGOlA+V/6+dKCAHtQ92ziPLnuuCBtrr9SEg2VQHSRN2hHYe4MvsLkOk4bb4ksWA5VGRWn+7IJEKpvjKIHydXiJH13Ezc89KqlbuQyN2EbhUYlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749729155; c=relaxed/simple;
	bh=55RopuoPAz7h+pNsIfGCdjyCMZ1lJk2Yxf4TwmSbpeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPp6O9hoUdTDy0p/PnqIbKjHkrYqEIIFLxS6LXE7fVI9LSYX2cwZAd/yORalGMlcg0GZKcTksqnLtMKwEnUqq2a9tK4sjL2pwKtK4bsPe7iXL1x5SwMcr1IexYVeI0b12evtos62EKAQeo/evyKIE0HppO86j+t5obLlH3UijDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kkQONTyS; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kkQONTyS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UOGz5aM5OGktSu3VJb5Nrn8VWp2sOJIAFaj2flMK4Yo=; b=kkQONTySLnraUkRd0C0Npwe0Bq
	Fgha1X4jrqZ1tINzTOyXSJJFjmiy3Tfkd7xQr93GydUsc6+9bGCrU3990A3JRegQNeyF+GLfnMbO9
	f/+6UQyE/TeaMKwHw66eHmy2cGdDXLmQgMkdON3gAcXevWnAJXtwfMzTYsBPg7bAYCp5h5ubjcF/z
	/1SyHuHipvlfPd/lI12xHSXtoMcZ1MGYVwQ9KSns9AePCj9Ud++Mg/OonCXlf6ZE09CrWzLJWbOhw
	DelsQK1ieHoAPq5GjfCI7L4mNQ5qpDuCrQuLRAm5e2TRn2Yod20/cfWjFaLYCuPkTuexciyOlVck3
	zkccISng==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPgTv-000000006GG-0vyl;
	Thu, 12 Jun 2025 13:52:31 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 7/7] tests: py: Properly fix JSON equivalents for netdev/reject.t
Date: Thu, 12 Jun 2025 13:52:18 +0200
Message-ID: <20250612115218.4066-8-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250612115218.4066-1-phil@nwl.cc>
References: <20250612115218.4066-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Revert commit d1a7b9e19fe65 ("tests: py: update netdev reject test
file"), the stored JSON equivalents were correct in that they matched
the standard syntax input.

In fact, we missed a .json.output file recording the expected deviation
in JSON output.

Fixes: d1a7b9e19fe65 ("tests: py: update netdev reject test file")
Fixes: 7ca3368cd7575 ("reject: Unify inet, netdev and bridge delinearization")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/netdev/reject.t.json        | 66 +++++++++++++++--------
 tests/py/netdev/reject.t.json.output | 81 ++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+), 21 deletions(-)
 create mode 100644 tests/py/netdev/reject.t.json.output

diff --git a/tests/py/netdev/reject.t.json b/tests/py/netdev/reject.t.json
index 9968aaf834ec2..b80db03b9d3af 100644
--- a/tests/py/netdev/reject.t.json
+++ b/tests/py/netdev/reject.t.json
@@ -130,17 +130,6 @@
 
 # mark 12345 reject with tcp reset
 [
-    {
-        "match": {
-            "left": {
-                "meta": {
-                    "key": "l4proto"
-                }
-            },
-            "op": "==",
-            "right": 6
-        }
-    },
     {
         "match": {
             "left": {
@@ -162,30 +151,43 @@
 # reject
 [
     {
-        "reject": {
-            "expr": "port-unreachable",
-            "type": "icmpx"
-        }
+        "reject": null
     }
 ]
 
 # meta protocol ip reject
 [
     {
-        "reject": {
-            "expr": "port-unreachable",
-            "type": "icmp"
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "protocol"
+                }
+            },
+            "op": "==",
+            "right": "ip"
         }
+    },
+    {
+        "reject": null
     }
 ]
 
 # meta protocol ip6 reject
 [
     {
-        "reject": {
-            "expr": "port-unreachable",
-            "type": "icmpv6"
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "protocol"
+                }
+            },
+            "op": "==",
+            "right": "ip6"
         }
+    },
+    {
+        "reject": null
     }
 ]
 
@@ -231,6 +233,17 @@
 
 # meta protocol ip reject with icmp host-unreachable
 [
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "protocol"
+                }
+            },
+            "op": "==",
+            "right": "ip"
+        }
+    },
     {
         "reject": {
             "expr": "host-unreachable",
@@ -241,6 +254,17 @@
 
 # meta protocol ip6 reject with icmpv6 no-route
 [
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "protocol"
+                }
+            },
+            "op": "==",
+            "right": "ip6"
+        }
+    },
     {
         "reject": {
             "expr": "no-route",
diff --git a/tests/py/netdev/reject.t.json.output b/tests/py/netdev/reject.t.json.output
new file mode 100644
index 0000000000000..cbd73104e4432
--- /dev/null
+++ b/tests/py/netdev/reject.t.json.output
@@ -0,0 +1,81 @@
+# mark 12345 reject with tcp reset
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 6
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "op": "==",
+            "right": 12345
+        }
+    },
+    {
+        "reject": {
+            "type": "tcp reset"
+        }
+    }
+]
+
+# reject
+[
+    {
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmpx"
+        }
+    }
+]
+
+# meta protocol ip reject
+[
+    {
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmp"
+        }
+    }
+]
+
+# meta protocol ip6 reject
+[
+    {
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmpv6"
+        }
+    }
+]
+
+# meta protocol ip reject with icmp host-unreachable
+[
+    {
+        "reject": {
+            "expr": "host-unreachable",
+            "type": "icmp"
+        }
+    }
+]
+
+# meta protocol ip6 reject with icmpv6 no-route
+[
+    {
+        "reject": {
+            "expr": "no-route",
+            "type": "icmpv6"
+        }
+    }
+]
+
-- 
2.49.0

