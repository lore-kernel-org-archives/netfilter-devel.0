Return-Path: <SRS0=C2Rd=CA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C23FC433E3
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Aug 2020 06:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77FF6208E4
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Aug 2020 06:22:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YdHJB05d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgHVGWT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 22 Aug 2020 02:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgHVGWN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Aug 2020 02:22:13 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F0CC061575
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2020 23:22:12 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d16so3770417wrq.9
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2020 23:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K1Hk/MM+7Waldffy1TUvpaANXjYs4DAdVECghwnIFmQ=;
        b=YdHJB05dY1sJ6KschY2OTJjlL7XOR6qZ28jG57KvrW87wTzGg/UsG3tHA6J6zgykE4
         n3jAnn08F/j0L7XAG6tg4k8hZNKoOdR+DRI0ZFDQXmAQIxsVJIekv/tzjZz3z5VjVqOv
         +pJtnVlpPRFGXuaU4vjhPFQXbQVprIGNV2q6mewBlNjP60R3D/oTTeSKGZENSBFZoNzN
         YLGSmAzD6N50jez5CmV57V58caZA1kwDMiObvtcEYWcCThCxEFfU2MdSeRQg3YnvvIGz
         xzAP3zOjVivsrewsMYygJVd0QnKN463Jeibwyy0Y/OlSpHyCjrthWWHy62/J57Tq21Lc
         XCEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K1Hk/MM+7Waldffy1TUvpaANXjYs4DAdVECghwnIFmQ=;
        b=e4kWVNX1nX7jP5kaEFn/DpbYcEmy7uSpyWSaKX1EUnsblPJspGTzWb0cwU2rRK3hIQ
         R7LXua6ypy8n1rz8BFHG8dB6t7wT/Gtot2cmcrM9IbFQuFWEOemdevfrDiSjXdzC/aX/
         u+lGnHSRy946UHJIMngkY3n6PMCCH88/K2r784BTt5AwGfldEEHZ5l6bhrh0e9UybyN+
         FBA8ranFrppiKY17A9DUFNpzwFkZRMhYGmsq5FTctbRWXqI8cA8tJju4zWhNqAA/zqV2
         PeFW7U1OU4MsDn6wsPHwrhp1pk4rYqOEpi8uZAWrHwE2b4pgMpuIQIZsgYcgdyRV1kEn
         7uIg==
X-Gm-Message-State: AOAM533ZT3t0dpkVJOF8Ma5Vr9V2C2zHla+ygjtr7NF/qHAu/ju5wODX
        SECBwsjsUsMFllzJ5IbCO5FZcrxfu2/07A==
X-Google-Smtp-Source: ABdhPJz6vw7aoVxpoEL7GLeC/bN+hwC8mjAOReyAGvJ7078V5Q7OQ/B6eOlKffmv96GGisqJAmd8IQ==
X-Received: by 2002:a5d:4910:: with SMTP id x16mr5606402wrq.131.1598077330933;
        Fri, 21 Aug 2020 23:22:10 -0700 (PDT)
Received: from localhost.localdomain (BC2467A7.dsl.pool.telekom.hu. [188.36.103.167])
        by smtp.gmail.com with ESMTPSA id h5sm7016321wrt.31.2020.08.21.23.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 23:22:10 -0700 (PDT)
From:   Balazs Scheidler <bazsi77@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Balazs Scheidler <bazsi77@gmail.com>
Subject: [PATCH nftables 3/4] tests: added "socked wildcard" testcases
Date:   Sat, 22 Aug 2020 08:22:02 +0200
Message-Id: <20200822062203.3617-4-bazsi77@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200822062203.3617-1-bazsi77@gmail.com>
References: <20200822062203.3617-1-bazsi77@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Balazs Scheidler <bazsi77@gmail.com>
---
 tests/py/inet/socket.t         |  4 ++++
 tests/py/inet/socket.t.json    | 29 +++++++++++++++++++++++++++++
 tests/py/inet/socket.t.payload | 29 +++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+)

diff --git a/tests/py/inet/socket.t b/tests/py/inet/socket.t
index 91846e8e..05e9ebb4 100644
--- a/tests/py/inet/socket.t
+++ b/tests/py/inet/socket.t
@@ -9,3 +9,7 @@ socket transparent 1;ok
 socket transparent 2;fail
 
 socket mark 0x00000005;ok
+
+socket wildcard 0;ok
+socket wildcard 1;ok
+socket wildcard 2;fail
diff --git a/tests/py/inet/socket.t.json b/tests/py/inet/socket.t.json
index 99d6e248..fa48e79d 100644
--- a/tests/py/inet/socket.t.json
+++ b/tests/py/inet/socket.t.json
@@ -43,3 +43,32 @@
     }
 ]
 
+# socket wildcard 0
+[
+    {
+        "match": {
+            "left": {
+                "socket": {
+                    "key": "wildcard"
+                }
+            },
+            "op": "==",
+            "right": 0
+        }
+    }
+]
+
+# socket wildcard 1
+[
+    {
+        "match": {
+            "left": {
+                "socket": {
+                    "key": "wildcard"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
diff --git a/tests/py/inet/socket.t.payload b/tests/py/inet/socket.t.payload
index 687b7a45..79fcea79 100644
--- a/tests/py/inet/socket.t.payload
+++ b/tests/py/inet/socket.t.payload
@@ -43,3 +43,32 @@ inet sockin sockchain
   [ socket load mark => reg 1 ]
   [ cmp eq reg 1 0x00000005 ]
 
+# socket wildcard 0
+ip sockip4 sockchain
+  [ socket load wildcard => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# socket wildcard 0
+ip6 sockip6 sockchain
+  [ socket load wildcard => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# socket wildcard 0
+inet sockin sockchain
+  [ socket load wildcard => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# socket wildcard 1
+ip sockip4 sockchain
+  [ socket load wildcard => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# socket wildcard 1
+ip6 sockip6 sockchain
+  [ socket load wildcard => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# socket wildcard 1
+inet sockin sockchain
+  [ socket load wildcard => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
-- 
2.17.1

