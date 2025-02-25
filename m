Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2A8265610
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2025 10:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740477808; cv=none; b=K73Pew077ePbdBM69x2smndZDNwjViXJliFE77Y4iYDEXlABOyBwh8+fEFfTHCf4NV/pKBCD7HPoGuuy6WdNp8UvBMHhmMM1Jgz86fAcBkTfxtyySq/2qi+OwiLS1VXCz3QDEXst3woUpIihReuEuhUHDvGUy4/fSec7770qjxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740477808; c=relaxed/simple;
	bh=IeUmnZ49uCxtu0IfgA5zRZibVpQu4uuKWDTRp2vTjGc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=OpvS9bxUPxde6bpg/EfoYSEP441mBgjK4mB1CpVDadwf2bHuupfMmfR4D2yWiMU8UIsrdF9w0vJr4W3uJ9hNKiXHt7Q0n8yKvK3UplFwXZ7o+bO1vNxWc/OM7qza5W5a/8nqcoME79Fmli5jqbfse9RBh1/nYED7BuTSHLJn/Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iDCD4x9h; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iDCD4x9h"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-220ca204d04so87379255ad.0
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2025 02:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740477806; x=1741082606; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=KV+KjddgBL37MsG5inWBtX2cTp7xmomdBeoI+xW/b0c=;
        b=iDCD4x9hI/5w+chFw2rlpBsSGo+fvieK+BvEF7HGJD2z+RyGO+3ZMuIITHR+lJs+P9
         cwtw2fpOVpCxDp4Lu6VrCDMw4p8cMqzJ+K2rgqx4LQJSn/WvW4nyixVfPFeBXdeaScL5
         Q2BVHRRKN5JfLBzr4y2CvgxphL6rNn/9WQ2V20ALY3rs2IBFknOmNH+UeNzJiU/eVnr2
         j37j3cYur8wg99TWFxWKAUCoqCsqggmTu4Sidfta2ME6jSNurc+tinMuf2PVE5vGwJxn
         xWWCYlffzmxcOv3v4pMFs4j566aZHMb+cz2r3/mdap8/kARGOcMEZoHb+68qofYNa61T
         dcnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740477806; x=1741082606;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KV+KjddgBL37MsG5inWBtX2cTp7xmomdBeoI+xW/b0c=;
        b=Z6ctAyjCptmt7rw/S6SxtNjH7BhH66a/0CBLBsTxW7UMveWmVgZjq+eKaT7ZUZPf4A
         qh5IcXgTlO//RbC066bLqh+LTrzHIMFKVAiqlrtBrDjibCykNs46n9q35pC2ugwaI1Kq
         ouU/SeAHf6fcWKmxkgui5i+I3IjCNaitAuELvzwVTLUVqRoS43QI6SeFvIbsyrXPul7Y
         mmSUWrTAXssadUydFGg9YiZ6/h1tCoL6n6sbzSah/pSuTWJk6WbQfStb2wi+Iqr61411
         PEVKfLUvb1tmSOigBwjkborDmfWiwjgAWvohtlc7RJjquihEKdlMrTCM35XzEkwnOZn4
         oM2A==
X-Gm-Message-State: AOJu0YytFFxiNaVJbfRNlZjJDQG56LnpGSrNpwnjT+Hmc+b0OZw5aU1y
	M5FdHfESj+z/Rz65qoliPf84HjVF7bn8yh1exx3giQYfXRdyPKl2fUqcNuLM
X-Gm-Gg: ASbGncsqJMVsdEcXnioreqCLcOs3dNu5xSiRpGaEbaE78KSINzhxcb7wrcfPuHh0VaW
	1Fj78r2jv7m0fnzOzLMfMjAROiU2BTzen9Pm5aBnVXQyyjNXWjPcaPX4oKo5m//ZDzwpLinpSl5
	ZresSOdw97By/dHOSg46r+EMUMPKwmBchkPnS6b8mbSpG47XQYXf7oIhRtixg6cnV+0Za0/ATtx
	e2hZRqIfZ0h6mQlgEaJHd+5RAFGJEm3spwWFEQOYjcImISxnltRUXiFAJF21Q3dgKB1x5fHk71v
	3RhElQ==
X-Google-Smtp-Source: AGHT+IFSUODJZBxtTiiYfY8Ej8g+yVnsKocrIrTMM89PxduEeEW0Vw20qhFHGZ5NCuOyv+04F831RA==
X-Received: by 2002:a17:903:2ec4:b0:216:3436:b85a with SMTP id d9443c01a7336-2219ffc77fdmr241331525ad.52.1740477805954;
        Tue, 25 Feb 2025 02:03:25 -0800 (PST)
Received: from ws.. ([103.167.140.11])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7347a81eb0dsm1118171b3a.141.2025.02.25.02.03.24
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 02:03:25 -0800 (PST)
From: Xiao Liang <shaw.leon@gmail.com>
To: netfilter-devel@vger.kernel.org
Subject: [RFC PATCH nft] payload: Don't kill dependency for proto_th
Date: Tue, 25 Feb 2025 18:03:18 +0800
Message-ID: <20250225100319.18978-1-shaw.leon@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since proto_th carries no information about the proto number, we need to
preserve the L4 protocol expression.

For example, if "meta l4proto 91 @th,0,16 0" is simplified to
"th sport 0", the information of protocol number is lost. This patch
changes it to "meta l4proto 91 th sport 0".

Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
---

Technically, if port is not defined for the L4 protocol, it's better to
keep "@th,0,16" as raw payload expressions rather than "th sport". But
it's not easy to figure out the context.

---
 src/payload.c                     |  1 +
 tests/py/any/rawpayload.t         |  1 +
 tests/py/any/rawpayload.t.json    | 31 +++++++++++++++++++++++++++++++
 tests/py/any/rawpayload.t.payload |  8 ++++++++
 4 files changed, 41 insertions(+)

diff --git a/src/payload.c b/src/payload.c
index f8b192b5..a039e242 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -920,6 +920,7 @@ void payload_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
 			     unsigned int family)
 {
 	if (expr->payload.desc != &proto_unknown &&
+	    expr->payload.desc != &proto_th &&
 	    payload_dependency_exists(ctx, expr->payload.base) &&
 	    payload_may_dependency_kill(ctx, family, expr))
 		payload_dependency_release(ctx, expr->payload.base);
diff --git a/tests/py/any/rawpayload.t b/tests/py/any/rawpayload.t
index 745b4a61..4ef53f82 100644
--- a/tests/py/any/rawpayload.t
+++ b/tests/py/any/rawpayload.t
@@ -21,6 +21,7 @@ meta l4proto tcp @th,16,16 { 22, 23, 80};ok;tcp dport { 22, 23, 80}
 @ll,0,128 0xfedcba987654321001234567890abcde;ok
 
 meta l4proto 91 @th,400,16 0x0 accept;ok
+meta l4proto 91 @th,0,16 0x0 accept;ok;meta l4proto 91 th sport 0 accept
 
 @ih,32,32 0x14000000;ok
 @ih,58,6 set 0 @ih,86,6 set 0 @ih,170,22 set 0;ok;@ih,58,6 set 0x0 @ih,86,6 set 0x0 @ih,170,22 set 0x0
diff --git a/tests/py/any/rawpayload.t.json b/tests/py/any/rawpayload.t.json
index 4a06c598..2d3c7904 100644
--- a/tests/py/any/rawpayload.t.json
+++ b/tests/py/any/rawpayload.t.json
@@ -187,6 +187,37 @@
     }
 ]
 
+# meta l4proto 91 @th,0,16 0x0 accept
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 91
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "sport",
+                    "protocol": "th"
+                }
+            },
+            "op": "==",
+            "right": 0
+        }
+    },
+    {
+        "accept": null
+    }
+]
+
+
 # @ih,32,32 0x14000000
 [
     {
diff --git a/tests/py/any/rawpayload.t.payload b/tests/py/any/rawpayload.t.payload
index 8984eef6..c093d5d8 100644
--- a/tests/py/any/rawpayload.t.payload
+++ b/tests/py/any/rawpayload.t.payload
@@ -56,6 +56,14 @@ inet test-inet input
   [ cmp eq reg 1 0x00000000 ]
   [ immediate reg 0 accept ]
 
+# meta l4proto 91 @th,0,16 0x0 accept
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000005b ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+  [ immediate reg 0 accept ]
+
 # @ih,32,32 0x14000000
 inet test-inet input
   [ payload load 4b @ inner header + 4 => reg 1 ]
-- 
2.48.1

