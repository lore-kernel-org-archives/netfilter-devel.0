Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A35EC875D
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 21:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236127AbjIGVOv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 17:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjIGVOv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 17:14:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF3892
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 14:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694121242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=R3h7/P0Zqzu7b9jZOAVxM64jMBy5ZeKRg80nvBa670g=;
        b=OCE1JN+KqrSXh2rX+gbMYRVmDrVyjkoxuHNWdey9z5P/vgxW+qvEzV3offhfSM2GkT/HV7
        nA+RsBIjz61jQhDLhrlEZVGek2jP+xejlNGWG/1gGugwZRE/K/prlqWJwJg4B37657qXPy
        f+1RNMGTgtvfgb9w2SBxNvKdKEbBrHg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-UuHSaMXTMrS-HDU0rPdQrQ-1; Thu, 07 Sep 2023 17:14:01 -0400
X-MC-Unique: UuHSaMXTMrS-HDU0rPdQrQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E59F029AB3ED
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 21:14:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 601542026D4B;
        Thu,  7 Sep 2023 21:14:00 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft] tests/shell: return 77/skip for tests that fail to create dummy device
Date:   Thu,  7 Sep 2023 23:13:43 +0200
Message-ID: <20230907211345.2412012-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are some existing tests, that skip operation when they fail to
create a dummy interface. Use the new exit code 77 to indicate
"SKIPPED".

I wonder why creating a dummy device would ever fail and why we don't
just fail the test altogether in that case. But the patch does not
change that.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/testcases/chains/netdev_chain_0   | 6 +++---
 tests/shell/testcases/json/netdev             | 2 +-
 tests/shell/testcases/listing/0020flowtable_0 | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tests/shell/testcases/chains/netdev_chain_0 b/tests/shell/testcases/chains/netdev_chain_0
index 67cd715fc59f..41e724413528 100755
--- a/tests/shell/testcases/chains/netdev_chain_0
+++ b/tests/shell/testcases/chains/netdev_chain_0
@@ -2,19 +2,19 @@
 
 ip link add d0 type dummy || {
         echo "Skipping, no dummy interface available"
-        exit 0
+        exit 77
 }
 trap "ip link del d0" EXIT
 
 ip link add d1 type dummy || {
         echo "Skipping, no dummy interface available"
-        exit 0
+        exit 77
 }
 trap "ip link del d1" EXIT
 
 ip link add d2 type dummy || {
         echo "Skipping, no dummy interface available"
-        exit 0
+        exit 77
 }
 trap "ip link del d2" EXIT
 
diff --git a/tests/shell/testcases/json/netdev b/tests/shell/testcases/json/netdev
index a16a4f5e030e..9f6033810b55 100755
--- a/tests/shell/testcases/json/netdev
+++ b/tests/shell/testcases/json/netdev
@@ -2,7 +2,7 @@
 
 ip link add d0 type dummy || {
         echo "Skipping, no dummy interface available"
-        exit 0
+        exit 77
 }
 trap "ip link del d0" EXIT
 
diff --git a/tests/shell/testcases/listing/0020flowtable_0 b/tests/shell/testcases/listing/0020flowtable_0
index 47488d8ea92a..210289d70415 100755
--- a/tests/shell/testcases/listing/0020flowtable_0
+++ b/tests/shell/testcases/listing/0020flowtable_0
@@ -43,7 +43,7 @@ EXPECTED3="table ip filter {
 
 ip link add d0 type dummy || {
 	echo "Skipping, no dummy interface available"
-	exit 0
+	exit 77
 }
 trap "ip link del d0" EXIT
 
-- 
2.41.0

