Return-Path: <SRS0=fjj5=CH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722B6C433E2
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 07:04:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5058820738
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 07:04:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f7TjdhjY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgH2HEW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Aug 2020 03:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgH2HET (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Aug 2020 03:04:19 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAC1C06123A
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2020 00:04:19 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id o4so1140290wrn.0
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2020 00:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K1Hk/MM+7Waldffy1TUvpaANXjYs4DAdVECghwnIFmQ=;
        b=f7TjdhjYifS44hAuXl/FzcuGfGXwuzheCH1NCkNkIGdw0UJ5nlLEZQwO0XvpCDOUKy
         4Rre2Cb64wP57UGMxJpSZ6zq6RCfP0MNg0slZOVoPrNELkTDvwf+CdI9NI8KKOAkqQMF
         3WOxqxClz8uPdQ8QPMnN5qDk5Gk/IKI6e8RR3cLACIdug7LVl0cGJetjtuIeBi5pprFm
         rUBHXn0c5/fB4ta7+IpHOkhE+Rvuyrlu1spT1SUTq9O6761z4tUXH0ylWiqgXCII+uHF
         mZSWt3jN8f6pXKOLnF7IQTd0CZ8eU+7E92NtQh/1Xy5ro9d1bowYEEmN416NvRdu2HKu
         2Ssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K1Hk/MM+7Waldffy1TUvpaANXjYs4DAdVECghwnIFmQ=;
        b=eaVjbmax+ETgQwm0BDLYVzawBDGyVRLkD/uuA+8nkBPuUI/hbZbRSWEejzROsfcXCJ
         qiMqAVVdviIVZ9rZL049jUTiooK8Rx53iAxi5g6uxqV3sMcX4LH1JMWv8sIoAzCRHdcA
         7d7g62MfqXhCvQy0LJ2nMdE5uIweiTvjGZ7+KgRUoLPdSOedhNw9OaHPK5Ix8zWvVh9a
         ghODBgG/8Au4ZyU6W6mJsppfc5cJIXrZtRdIpHV37/ySccGy6TSjQfmInu5mLOG6+oCF
         Mo6yF0SvlUT68Zy9pXAWLFuWwycl+2boyvMfPDEo3WwH2jjrx9zZGL6iKMqMqwA6b5Va
         8qYQ==
X-Gm-Message-State: AOAM531dexQplC9grO0CF4tBjF7Z8u+HTNRUOZ0mL9CyjsrKTJNSgvkk
        GHPsTRm9mmtPuQ+pYwN/KceX6hz8e0mcqA==
X-Google-Smtp-Source: ABdhPJy9vh2hfzMr/VgJJ7bDZcCi7s2dRJ95ccCIZ4jKaHG57DyZybLjNjjUzIiq/nmidJq0mvv7FA==
X-Received: by 2002:adf:c789:: with SMTP id l9mr2458482wrg.41.1598684658040;
        Sat, 29 Aug 2020 00:04:18 -0700 (PDT)
Received: from localhost.localdomain (94-21-174-118.pool.digikabel.hu. [94.21.174.118])
        by smtp.gmail.com with ESMTPSA id f2sm2489756wrj.54.2020.08.29.00.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2020 00:04:17 -0700 (PDT)
From:   Balazs Scheidler <bazsi77@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Balazs Scheidler <bazsi77@gmail.com>
Subject: [PATCH nftables v2 4/5] tests: added "socket wildcard" testcases
Date:   Sat, 29 Aug 2020 09:04:04 +0200
Message-Id: <20200829070405.23636-5-bazsi77@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200829070405.23636-1-bazsi77@gmail.com>
References: <20200829070405.23636-1-bazsi77@gmail.com>
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

