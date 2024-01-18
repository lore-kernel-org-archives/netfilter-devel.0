Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77251241F5
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jan 2024 12:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705580664; cv=none; b=VYtpkOgWnzzMTId7D86ogg7JECo/2x/bxzGeRSFkNpjhkoXcKWNjlGBxM1iivIaaeEkd0wpb3SzYv9yxKMbPLHo7JML2gwZsUFluu5WY3wI0afUzx7nMZ6k0oGXJfNmSb5dZ2M4Tg8tG3Zk2GJ994m+FmHmSdpnI48RBDHzcjX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705580664; c=relaxed/simple;
	bh=UCIVtPv2L807eFRdWLtdD1abQQW8u4L/YR7R7u5uYUs=;
	h=Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding; b=CYH8WKppTIRJb9W+kzGwGlvs2eDQTVPkDfyRLlUg3PbaysBfss0Z9raE6ExXLYVML8ABKH1CtH6C5dthNMfPnMFNB2cX2FVawtKqyn1qKboh5t4c8L4GktQOIJ55YLa6p9eFNuIk4EfMsPkbSln1my79cBlNQMdAkITrvHmoJlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rQRRO-0001XZ-9I; Thu, 18 Jan 2024 13:24:14 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: py: remove huge-limit test cases
Date: Thu, 18 Jan 2024 13:24:04 +0100
Message-ID: <20240118122408.2536-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These tests will fail once the kernel checks for overflow
in the internal token bucken counter, so drop them.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/any/limit.t             |  4 ---
 tests/py/any/limit.t.json        | 51 --------------------------------
 tests/py/any/limit.t.json.output | 28 ------------------
 tests/py/any/limit.t.payload     | 17 -----------
 4 files changed, 100 deletions(-)

diff --git a/tests/py/any/limit.t b/tests/py/any/limit.t
index a04ef42af931..2a84e3f56e4e 100644
--- a/tests/py/any/limit.t
+++ b/tests/py/any/limit.t
@@ -22,7 +22,6 @@ limit rate 2 kbytes/second;ok
 limit rate 1025 kbytes/second;ok
 limit rate 1023 mbytes/second;ok
 limit rate 10230 mbytes/second;ok
-limit rate 1023000 mbytes/second;ok
 limit rate 512 kbytes/second burst 5 packets;fail
 
 limit rate 1 bytes / second;ok;limit rate 1 bytes/second
@@ -33,7 +32,6 @@ limit rate 1 gbytes / second;fail
 limit rate 1025 bytes/second burst 512 bytes;ok
 limit rate 1025 kbytes/second burst 1023 kbytes;ok
 limit rate 1025 mbytes/second burst 1025 kbytes;ok
-limit rate 1025000 mbytes/second burst 1023 mbytes;ok
 
 limit rate over 400/minute;ok;limit rate over 400/minute burst 5 packets
 limit rate over 20/second;ok;limit rate over 20/second burst 5 packets
@@ -47,9 +45,7 @@ limit rate over 2 kbytes/second;ok
 limit rate over 1025 kbytes/second;ok
 limit rate over 1023 mbytes/second;ok
 limit rate over 10230 mbytes/second;ok
-limit rate over 1023000 mbytes/second;ok
 
 limit rate over 1025 bytes/second burst 512 bytes;ok
 limit rate over 1025 kbytes/second burst 1023 kbytes;ok
 limit rate over 1025 mbytes/second burst 1025 kbytes;ok
-limit rate over 1025000 mbytes/second burst 1023 mbytes;ok
diff --git a/tests/py/any/limit.t.json b/tests/py/any/limit.t.json
index e001ba0fe9ac..73160b27fad8 100644
--- a/tests/py/any/limit.t.json
+++ b/tests/py/any/limit.t.json
@@ -114,17 +114,6 @@
     }
 ]
 
-# limit rate 1023000 mbytes/second
-[
-    {
-        "limit": {
-            "per": "second",
-            "rate": 1023000,
-            "rate_unit": "mbytes"
-        }
-    }
-]
-
 # limit rate 1 bytes / second
 [
     {
@@ -203,19 +192,6 @@
     }
 ]
 
-# limit rate 1025000 mbytes/second burst 1023 mbytes
-[
-    {
-        "limit": {
-            "burst": 1023,
-            "burst_unit": "mbytes",
-            "per": "second",
-            "rate": 1025000,
-            "rate_unit": "mbytes"
-        }
-    }
-]
-
 # limit rate over 400/minute
 [
     {
@@ -343,18 +319,6 @@
     }
 ]
 
-# limit rate over 1023000 mbytes/second
-[
-    {
-        "limit": {
-            "inv": true,
-            "per": "second",
-            "rate": 1023000,
-            "rate_unit": "mbytes"
-        }
-    }
-]
-
 # limit rate over 1025 bytes/second burst 512 bytes
 [
     {
@@ -396,18 +360,3 @@
         }
     }
 ]
-
-# limit rate over 1025000 mbytes/second burst 1023 mbytes
-[
-    {
-        "limit": {
-            "burst": 1023,
-            "burst_unit": "mbytes",
-            "inv": true,
-            "per": "second",
-            "rate": 1025000,
-            "rate_unit": "mbytes"
-        }
-    }
-]
-
diff --git a/tests/py/any/limit.t.json.output b/tests/py/any/limit.t.json.output
index 5a95f5e10a86..2c94d2de1236 100644
--- a/tests/py/any/limit.t.json.output
+++ b/tests/py/any/limit.t.json.output
@@ -118,19 +118,6 @@
     }
 ]
 
-# limit rate 1023000 mbytes/second
-[
-    {
-        "limit": {
-            "burst": 0,
-            "burst_unit": "bytes",
-            "per": "second",
-            "rate": 1023000,
-            "rate_unit": "mbytes"
-        }
-    }
-]
-
 # limit rate over 400/minute
 [
     {
@@ -260,18 +247,3 @@
         }
     }
 ]
-
-# limit rate over 1023000 mbytes/second
-[
-    {
-        "limit": {
-            "burst": 0,
-            "burst_unit": "bytes",
-            "inv": true,
-            "per": "second",
-            "rate": 1023000,
-            "rate_unit": "mbytes"
-        }
-    }
-]
-
diff --git a/tests/py/any/limit.t.payload b/tests/py/any/limit.t.payload
index 0c7ee942927d..dc6701b3521c 100644
--- a/tests/py/any/limit.t.payload
+++ b/tests/py/any/limit.t.payload
@@ -42,10 +42,6 @@ ip test-ip4 output
 ip test-ip4 output
   [ limit rate 10726932480/second burst 0 type bytes flags 0x0 ]
 
-# limit rate 1023000 mbytes/second
-ip test-ip4 output
-  [ limit rate 1072693248000/second burst 0 type bytes flags 0x0 ]
-
 # limit rate 1 bytes / second
 ip
   [ limit rate 1/second burst 0 type bytes flags 0x0 ]
@@ -71,10 +67,6 @@ ip test-ip4 output
 ip test-ip4 output
   [ limit rate 1074790400/second burst 1049600 type bytes flags 0x0 ]
 
-# limit rate 1025000 mbytes/second burst 1023 mbytes
-ip test-ip4 output
-  [ limit rate 1074790400000/second burst 1072693248 type bytes flags 0x0 ]
-
 # limit rate over 400/minute
 ip test-ip4 output
   [ limit rate 400/minute burst 5 type packets flags 0x1 ]
@@ -119,10 +111,6 @@ ip test-ip4 output
 ip test-ip4 output
   [ limit rate 10726932480/second burst 0 type bytes flags 0x1 ]
 
-# limit rate over 1023000 mbytes/second
-ip test-ip4 output
-  [ limit rate 1072693248000/second burst 0 type bytes flags 0x1 ]
-
 # limit rate over 1025 bytes/second burst 512 bytes
 ip test-ip4 output
   [ limit rate 1025/second burst 512 type bytes flags 0x1 ]
@@ -134,8 +122,3 @@ ip test-ip4 output
 # limit rate over 1025 mbytes/second burst 1025 kbytes
 ip test-ip4 output
   [ limit rate 1074790400/second burst 1049600 type bytes flags 0x1 ]
-
-# limit rate over 1025000 mbytes/second burst 1023 mbytes
-ip test-ip4 output
-  [ limit rate 1074790400000/second burst 1072693248 type bytes flags 0x1 ]
-
-- 
2.43.0

