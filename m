Return-Path: <SRS0=WNzP=VO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79CD7C76192
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jul 2019 10:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 465AA20880
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jul 2019 10:47:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="RtiCSGq5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfGQKrF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 06:47:05 -0400
Received: from mx1.riseup.net ([198.252.153.129]:55740 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfGQKrE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 06:47:04 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 750AD1B9366
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jul 2019 03:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563360424; bh=+non05eMULzj0lUBgk+ey370mgGN4Y4ZkbC8SeZAJm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtiCSGq5VQ/+fc8wLnXnH/4XC8qVWGylMoLBebwUHpXOGjZgK1vQzOKICUsLWUuX6
         ntYGymT/cLLKQ5XTXToENcP93zvaseZwJ8X1NjQKeUwhRQ9h3cH+EYjPG7gA7zQ0Dw
         q37TZvDmBVEjco9wAOup/9iBO93wvWNbem4qxUfk=
X-Riseup-User-ID: F06EEB049B6CEF51C41AF7C3A8D15E6270902A8FD52D68A1016B9845EB3C66C2
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id A5FF81204FF;
        Wed, 17 Jul 2019 03:47:03 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 2/2 nft] tests: py: add missing json outputs
Date:   Wed, 17 Jul 2019 12:46:46 +0200
Message-Id: <20190717104646.3387-2-ffmancera@riseup.net>
In-Reply-To: <20190717104646.3387-1-ffmancera@riseup.net>
References: <20190717104646.3387-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes: 1188a69604c3 ("src: introduce SYNPROXY matching")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 tests/py/inet/synproxy.t.json | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tests/py/inet/synproxy.t.json b/tests/py/inet/synproxy.t.json
index 313fa9f..92c69d7 100644
--- a/tests/py/inet/synproxy.t.json
+++ b/tests/py/inet/synproxy.t.json
@@ -69,3 +69,28 @@
         }
     }
 ]
+
+# synproxy mss 1460 wscale 5 timestamp sack-perm
+[
+    {
+        "synproxy": {
+            "flags": [
+                "timestamp",
+                "sack-perm"
+            ],
+            "mss": 1460,
+            "wscale": 5
+        }
+    }
+]
+
+# synproxy sack-perm
+[
+    {
+        "synproxy": {
+            "flags": [
+                "sack-perm"
+            ]
+        }
+    }
+]
-- 
2.20.1

