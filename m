Return-Path: <SRS0=kyt/=4Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D574C10DCE
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Mar 2020 02:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7DB2206D7
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Mar 2020 02:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgCGCYi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Mar 2020 21:24:38 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:36958 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgCGCYi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Mar 2020 21:24:38 -0500
Received: from localhost ([::1]:50048 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jAP8n-0001Vc-1a; Sat, 07 Mar 2020 03:24:37 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests/py: Fix JSON output for changed timezone
Date:   Sat,  7 Mar 2020 03:24:28 +0100
Message-Id: <20200307022428.5833-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When setting a fixed timezone, JSON expected output for one (known)
asymmetric rule was left out by accident.

Fixes: 7e326d697ecf4 ("tests/py: Set a fixed timezone in nft-test.py")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/any/meta.t.json.output | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/py/any/meta.t.json.output b/tests/py/any/meta.t.json.output
index 037f67189682e..74b934b848393 100644
--- a/tests/py/any/meta.t.json.output
+++ b/tests/py/any/meta.t.json.output
@@ -620,7 +620,7 @@
                 }
             },
             "op": "==",
-            "right": "1970-05-23 21:07:14"
+            "right": "1970-05-23 22:07:14"
         }
     },
     {
-- 
2.25.1

