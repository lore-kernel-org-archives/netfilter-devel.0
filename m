Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A149C3D561
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Aug 2025 09:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754904649; cv=none; b=dKxky5kbMHm9Km+BECVDB/ZQA2F3nsRZ/olUV8qSElPivCr8JVOXMSpOm2fanNpTHqLOiBnExwo/g+fmVh7UWzZdverdD2mxl27wtCghw4p4c3VfTzotygBk9wIkPOh/h+jbmb8ye/VFTdxjIHqTvAIeq7j/Ly0MVV0Z4+ZbcCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754904649; c=relaxed/simple;
	bh=UaFav3XJa//PxeV1+tMVAlx053cKuMwdB/O/EU9AkZs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=riZaRJi0MhO3MvISOv33ICAjRRhcdHR3iNkUCzpziwLLwdadnJbMJos+tXhtJR44+3qTtYISjoK1HPLv7vCamomykCZzCLqOQQcGtsHegt3sETuUi0RqWthDeIjm2D6uxQiNNtXpm+8C7yt19nZAYDrP+FrTfp3svMI+N4jOAzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 482D9601B0; Mon, 11 Aug 2025 11:25:18 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: py: revert dccp python tests
Date: Mon, 11 Aug 2025 11:25:06 +0200
Message-ID: <20250811092510.5744-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These fail for kernels with 'CONFIG_NFT_EXTHDR_DCCP is not set', remove
the tests in anticipation of a future removal from both kernel and
nftables.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/inet/dccp.t         |  5 ----
 tests/py/inet/dccp.t.json    | 44 ------------------------------------
 tests/py/inet/dccp.t.payload | 14 ------------
 3 files changed, 63 deletions(-)

diff --git a/tests/py/inet/dccp.t b/tests/py/inet/dccp.t
index 99cddbe77c5b..90142f53254e 100644
--- a/tests/py/inet/dccp.t
+++ b/tests/py/inet/dccp.t
@@ -23,8 +23,3 @@ dccp type {request, response, data, ack, dataack, closereq, close, reset, sync,
 dccp type != {request, response, data, ack, dataack, closereq, close, reset, sync, syncack};ok
 dccp type request;ok
 dccp type != request;ok
-
-dccp option 0 exists;ok
-dccp option 43 missing;ok
-dccp option 255 exists;ok
-dccp option 256 exists;fail
diff --git a/tests/py/inet/dccp.t.json b/tests/py/inet/dccp.t.json
index 9f47e97b8711..806ef5eefca3 100644
--- a/tests/py/inet/dccp.t.json
+++ b/tests/py/inet/dccp.t.json
@@ -230,47 +230,3 @@
     }
 ]
 
-# dccp option 0 exists
-[
-    {
-        "match": {
-            "left": {
-                "dccp option": {
-                    "type": 0
-                }
-            },
-            "op": "==",
-            "right": true
-        }
-    }
-]
-
-# dccp option 43 missing
-[
-    {
-        "match": {
-            "left": {
-                "dccp option": {
-                    "type": 43
-                }
-            },
-            "op": "==",
-            "right": false
-        }
-    }
-]
-
-# dccp option 255 exists
-[
-    {
-        "match": {
-            "left": {
-                "dccp option": {
-                    "type": 255
-                }
-            },
-            "op": "==",
-            "right": true
-        }
-    }
-]
diff --git a/tests/py/inet/dccp.t.payload b/tests/py/inet/dccp.t.payload
index 7cb9721c1cd8..b5edfa5daed9 100644
--- a/tests/py/inet/dccp.t.payload
+++ b/tests/py/inet/dccp.t.payload
@@ -97,17 +97,3 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x0000001e ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
 
-# dccp option 0 exists
-ip test-inet input
-  [ exthdr load 1b @ 0 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# dccp option 43 missing
-ip test-inet input
-  [ exthdr load 1b @ 43 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
-
-# dccp option 255 exists
-ip test-inet input
-  [ exthdr load 1b @ 255 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-- 
2.49.1

