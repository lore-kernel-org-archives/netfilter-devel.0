Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105FBCD13DD
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 10:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239649AbjIRKbX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241246AbjIRKa5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 06:30:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DCDC6
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 03:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695033003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ej9xWLf3dkAXq+CCfcDxtksRz6Enx3wmmMhir96+1Ho=;
        b=hDsdw0aKIOH7I8/7Y+wUZCmJifuEGoFKpCCIwBayM22JseXWN3plfLyK4DW6Fg3e86F+SK
        suuA72X7EufAOKl7buCtQDqto4CCasK8htCkETU8kbld0tUow9aTVmT69mWXHTe6LxVLUn
        QTJwhSLI+pJ8N/fbEvB7uCjJZYr2xRo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-nCWR06bwNPuTE6C6Z6CjWg-1; Mon, 18 Sep 2023 06:30:00 -0400
X-MC-Unique: nCWR06bwNPuTE6C6Z6CjWg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F60485A5BD;
        Mon, 18 Sep 2023 10:30:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 62E5DC15BB8;
        Mon, 18 Sep 2023 10:29:59 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 02/14] tests/shell: skip netdev_chain_0 if kernel requires netdev device
Date:   Mon, 18 Sep 2023 12:28:16 +0200
Message-ID: <20230918102947.2125883-3-thaller@redhat.com>
In-Reply-To: <20230918102947.2125883-1-thaller@redhat.com>
References: <20230918102947.2125883-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This test case only works on kernel 6.4+.

Add feature probe for this and tag the test accordingly using
the scheme added by Thomas Haller in

    "tests/shell: skip tests if nft does not support JSON mode"

so that run-test.sh skips it if kernel requires a device.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/features/netdev_chain_without_device.nft | 7 +++++++
 tests/shell/testcases/chains/netdev_chain_0          | 2 ++
 2 files changed, 9 insertions(+)
 create mode 100644 tests/shell/features/netdev_chain_without_device.nft

diff --git a/tests/shell/features/netdev_chain_without_device.nft b/tests/shell/features/netdev_chain_without_device.nft
new file mode 100644
index 000000000000..25eb200ffe31
--- /dev/null
+++ b/tests/shell/features/netdev_chain_without_device.nft
@@ -0,0 +1,7 @@
+# 207296f1a03b ("netfilter: nf_tables: allow to create netdev chain without device")
+# v6.4-rc1~132^2~14^2
+table netdev t {
+	chain c {
+		type filter hook ingress priority 0; policy accept;
+        }
+}
diff --git a/tests/shell/testcases/chains/netdev_chain_0 b/tests/shell/testcases/chains/netdev_chain_0
index 88bbc437d471..a323e6ec3324 100755
--- a/tests/shell/testcases/chains/netdev_chain_0
+++ b/tests/shell/testcases/chains/netdev_chain_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_netdev_chain_without_device)
+
 set -e
 
 iface_cleanup() {
-- 
2.41.0

