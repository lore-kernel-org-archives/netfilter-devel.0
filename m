Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC6A1EB9E1
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jan 2025 17:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738259430; cv=none; b=lhwpSLE9puD5B8qg8W1tNjMe28b3oF4ET8Dr40rONPvHM/rx//CeiUPCqCyozT2nVUrWVyQD6WVssP+AtZHqRmcaPItesFSD6lHHHn19nHZfGpZglzCu1GGa62X80eyjZl/451pDner6XJKZXxlfyb7/qZMVlAZ43aG2qRsgBtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738259430; c=relaxed/simple;
	bh=sYhiIIsGeKrlbXXwobhsIi3J30fwiwhwOv20jAPPGWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQ32mL/RW57I3IlwupYPUCNEUvW5YN1NjUwGTcl5a5XT0026QRbqmYlXJJrvqgrrEIEG++pS66mc/I3ms+tl0seK1H0kPXgTkw25Q2A/eHFELYxqY4qOh26EPinH3rcqWjPiQrUJ5WsORgO2VKWxczBF9gzbK1pL8t5yyYCshqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tdYgM-00019H-Tt; Thu, 30 Jan 2025 18:50:26 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] tests: py: extend raw payload match tests
Date: Thu, 30 Jan 2025 18:47:14 +0100
Message-ID: <20250130174718.6644-3-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
In-Reply-To: <20250130174718.6644-1-fw@strlen.de>
References: <20250130174718.6644-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add more test cases to exercise binop elimination for raw
payload matches.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/any/rawpayload.t         |   7 ++
 tests/py/any/rawpayload.t.json    | 157 ++++++++++++++++++++++++++++++
 tests/py/any/rawpayload.t.payload |  53 ++++++++++
 3 files changed, 217 insertions(+)

diff --git a/tests/py/any/rawpayload.t b/tests/py/any/rawpayload.t
index 5bc9d35f7465..745b4a615e6c 100644
--- a/tests/py/any/rawpayload.t
+++ b/tests/py/any/rawpayload.t
@@ -15,6 +15,7 @@ meta l4proto tcp @th,16,16 { 22, 23, 80};ok;tcp dport { 22, 23, 80}
 
 @ll,0,0 2;fail
 @ll,0,1;fail
+@ll,1,0 1;fail
 @ll,0,1 1;ok;@ll,0,8 & 0x80 == 0x80
 @ll,0,8 & 0x80 == 0x80;ok
 @ll,0,128 0xfedcba987654321001234567890abcde;ok
@@ -22,3 +23,9 @@ meta l4proto tcp @th,16,16 { 22, 23, 80};ok;tcp dport { 22, 23, 80}
 meta l4proto 91 @th,400,16 0x0 accept;ok
 
 @ih,32,32 0x14000000;ok
+@ih,58,6 set 0 @ih,86,6 set 0 @ih,170,22 set 0;ok;@ih,58,6 set 0x0 @ih,86,6 set 0x0 @ih,170,22 set 0x0
+@ih,58,6 set 0x1 @ih,86,6 set 0x2 @ih,170,22 set 0x3;ok
+@ih,58,6 0x0 @ih,86,6 0x0 @ih,170,22 0x0;ok
+@ih,1,1 0x2;fail
+@ih,1,2 0x2;ok
+@ih,35,3 0x2;ok
diff --git a/tests/py/any/rawpayload.t.json b/tests/py/any/rawpayload.t.json
index 4cae4d493da3..4a06c5987a7b 100644
--- a/tests/py/any/rawpayload.t.json
+++ b/tests/py/any/rawpayload.t.json
@@ -204,3 +204,160 @@
     }
 ]
 
+# @ih,58,6 set 0 @ih,86,6 set 0 @ih,170,22 set 0
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "base": "ih",
+                    "len": 6,
+                    "offset": 58
+                }
+            },
+            "value": 0
+        }
+    },
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "base": "ih",
+                    "len": 6,
+                    "offset": 86
+                }
+            },
+            "value": 0
+        }
+    },
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "base": "ih",
+                    "len": 22,
+                    "offset": 170
+                }
+            },
+            "value": 0
+        }
+    }
+]
+
+# @ih,58,6 set 0x1 @ih,86,6 set 0x2 @ih,170,22 set 0x3
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "base": "ih",
+                    "len": 6,
+                    "offset": 58
+                }
+            },
+            "value": 1
+        }
+    },
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "base": "ih",
+                    "len": 6,
+                    "offset": 86
+                }
+            },
+            "value": 2
+        }
+    },
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "base": "ih",
+                    "len": 22,
+                    "offset": 170
+                }
+            },
+            "value": 3
+        }
+    }
+]
+
+# @ih,58,6 0x0 @ih,86,6 0x0 @ih,170,22 0x0
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "base": "ih",
+                    "len": 6,
+                    "offset": 58
+                }
+            },
+            "op": "==",
+            "right": 0
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "base": "ih",
+                    "len": 6,
+                    "offset": 86
+                }
+            },
+            "op": "==",
+            "right": 0
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "base": "ih",
+                    "len": 22,
+                    "offset": 170
+                }
+            },
+            "op": "==",
+            "right": 0
+        }
+    }
+]
+
+# @ih,1,2 0x2
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "base": "ih",
+                    "len": 2,
+                    "offset": 1
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    }
+]
+
+# @ih,35,3 0x2
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "base": "ih",
+                    "len": 3,
+                    "offset": 35
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    }
+]
+
diff --git a/tests/py/any/rawpayload.t.payload b/tests/py/any/rawpayload.t.payload
index fe2377e65a77..8984eef6a481 100644
--- a/tests/py/any/rawpayload.t.payload
+++ b/tests/py/any/rawpayload.t.payload
@@ -61,3 +61,56 @@ inet test-inet input
   [ payload load 4b @ inner header + 4 => reg 1 ]
   [ cmp eq reg 1 0x00000014 ]
 
+# @ih,58,6 set 0 @ih,86,6 set 0 @ih,170,22 set 0
+inet test-inet input
+  [ payload load 2b @ inner header + 6 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c0ff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ inner header + 6 csum_type 0 csum_off 0 csum_flags 0x1 ]
+  [ payload load 2b @ inner header + 10 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000ffc ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ inner header + 10 csum_type 0 csum_off 0 csum_flags 0x1 ]
+  [ payload load 4b @ inner header + 20 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c0ff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 4b @ inner header + 20 csum_type 0 csum_off 0 csum_flags 0x1 ]
+
+# @ih,58,6 set 0x1 @ih,86,6 set 0x2 @ih,170,22 set 0x3
+inet test-inet input
+  [ payload load 2b @ inner header + 6 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c0ff ) ^ 0x00000100 ]
+  [ payload write reg 1 => 2b @ inner header + 6 csum_type 0 csum_off 0 csum_flags 0x1 ]
+  [ payload load 2b @ inner header + 10 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000ffc ) ^ 0x00002000 ]
+  [ payload write reg 1 => 2b @ inner header + 10 csum_type 0 csum_off 0 csum_flags 0x1 ]
+  [ payload load 4b @ inner header + 20 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c0ff ) ^ 0x03000000 ]
+  [ payload write reg 1 => 4b @ inner header + 20 csum_type 0 csum_off 0 csum_flags 0x1 ]
+
+# @ih,58,6 0x0 @ih,86,6 0x0 @ih,170,22 0x0
+inet test-inet input
+  [ payload load 1b @ inner header + 7 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000003f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+  [ payload load 2b @ inner header + 10 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f003 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+  [ payload load 3b @ inner header + 21 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ffff3f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# @ih,1,2 0x2
+inet test-inet input
+  [ payload load 1b @ inner header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000060 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000040 ]
+
+# @ih,2,1 0x1
+inet test-inet input
+  [ payload load 1b @ inner header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000020 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000020 ]
+
+# @ih,35,3 0x2
+inet test-inet input
+  [ payload load 1b @ inner header + 4 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000001c ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000008 ]
-- 
2.45.3

