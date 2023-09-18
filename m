Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2206ACD13DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 10:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240485AbjIRKbY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241238AbjIRKa5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 06:30:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4BCF4
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 03:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695033005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hlcKIx4XHLOKZsFfQA8NOHuTKfYU8es53lIS1WFVCa0=;
        b=b2FAXAKwfhX4VTjzstBkqEXRpZTlSM4F5Hs/XsikiFh/MYumqxg/y+TzxmVpcpwwHFyPIl
        /6ww2eSLQo3XxscDr7uGOqWSDGYgox40FTxs/zvRZIrJ3bjubbgMeOTCe8yB/ru8yNpBaP
        NNAfgGrACsnITBg1JkDGJX8B4yOUJKc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-Zl5vo-WkNoeDcMkQzlPo-Q-1; Mon, 18 Sep 2023 06:30:02 -0400
X-MC-Unique: Zl5vo-WkNoeDcMkQzlPo-Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D41633806714;
        Mon, 18 Sep 2023 10:30:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 317BEC15BB8;
        Mon, 18 Sep 2023 10:30:01 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 04/14] tests/shell: skip inner matching tests if unsupported
Date:   Mon, 18 Sep 2023 12:28:18 +0200
Message-ID: <20230918102947.2125883-5-thaller@redhat.com>
In-Reply-To: <20230918102947.2125883-1-thaller@redhat.com>
References: <20230918102947.2125883-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/features/inner_matching.nft | 7 +++++++
 tests/shell/testcases/sets/inner_0      | 2 ++
 2 files changed, 9 insertions(+)
 create mode 100644 tests/shell/features/inner_matching.nft

diff --git a/tests/shell/features/inner_matching.nft b/tests/shell/features/inner_matching.nft
new file mode 100644
index 000000000000..6c86fd3558ac
--- /dev/null
+++ b/tests/shell/features/inner_matching.nft
@@ -0,0 +1,7 @@
+# 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
+# v6.2-rc1~99^2~350^2~4
+table ip t {
+        chain c {
+                udp dport 4789 vxlan ip saddr 1.2.3.4
+        }
+}
diff --git a/tests/shell/testcases/sets/inner_0 b/tests/shell/testcases/sets/inner_0
index 0eb172a8cf06..39d91bd9c3ed 100755
--- a/tests/shell/testcases/sets/inner_0
+++ b/tests/shell/testcases/sets/inner_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_inner_matching)
+
 set -e
 
 RULESET="table netdev x {
-- 
2.41.0

