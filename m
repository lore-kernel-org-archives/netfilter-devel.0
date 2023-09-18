Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BC2CD37B0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 10:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241246AbjIRKb4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241261AbjIRKbj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 06:31:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1581100
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 03:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695033009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iCIDVQ3KHGTZwWbIlCs+kn3bK2GwTy9SM4PTd6Kql7I=;
        b=IXB1tdnVeiuZUfJfxm6Xsfqrnv5LXW6ChRY7342I7aqLE7s0r4nSwT4uBtzgjC/l3u9zXG
        TSlyN1onoHKbOGoEX33n2WiLP+MhphPrdoocA7XfDbLqBtmxO4QGradxRuDJNld8Pj62zF
        voBUcLUF7WFSe1T3rYOvnf51IOCLVJk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-690-ABbxPU8IOb6Eo0nVk1HRqw-1; Mon, 18 Sep 2023 06:30:05 -0400
X-MC-Unique: ABbxPU8IOb6Eo0nVk1HRqw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 720CF29AA3AD;
        Mon, 18 Sep 2023 10:30:05 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C5A8EC15BB8;
        Mon, 18 Sep 2023 10:30:04 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 08/14] tests/shell: skip destroy tests if kernel lacks support
Date:   Mon, 18 Sep 2023 12:28:22 +0200
Message-ID: <20230918102947.2125883-9-thaller@redhat.com>
In-Reply-To: <20230918102947.2125883-1-thaller@redhat.com>
References: <20230918102947.2125883-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Destroy support was added for table/flowtable/chain etc. in a single
commit, so no need to add capability tests for each destroy subtype.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/features/destroy.nft                    | 3 +++
 tests/shell/testcases/chains/0044chain_destroy_0    | 2 ++
 tests/shell/testcases/flowtable/0015destroy_0       | 2 ++
 tests/shell/testcases/maps/0014destroy_0            | 2 ++
 tests/shell/testcases/rule_management/0012destroy_0 | 2 ++
 tests/shell/testcases/sets/0072destroy_0            | 2 ++
 6 files changed, 13 insertions(+)
 create mode 100644 tests/shell/features/destroy.nft

diff --git a/tests/shell/features/destroy.nft b/tests/shell/features/destroy.nft
new file mode 100644
index 000000000000..b97242e41e9f
--- /dev/null
+++ b/tests/shell/features/destroy.nft
@@ -0,0 +1,3 @@
+# f80a612dd77c ("netfilter: nf_tables: add support to destroy operation")
+# v6.3-rc1~162^2~264^2
+destroy table t
diff --git a/tests/shell/testcases/chains/0044chain_destroy_0 b/tests/shell/testcases/chains/0044chain_destroy_0
index 8384da66a5b0..1763d802c1dd 100755
--- a/tests/shell/testcases/chains/0044chain_destroy_0
+++ b/tests/shell/testcases/chains/0044chain_destroy_0
@@ -1,5 +1,7 @@
 #!/bin/sh -e
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_destroy)
+
 $NFT add table t
 
 # pass for non-existent chain
diff --git a/tests/shell/testcases/flowtable/0015destroy_0 b/tests/shell/testcases/flowtable/0015destroy_0
index 66fce4992a50..9e91ef5036a2 100755
--- a/tests/shell/testcases/flowtable/0015destroy_0
+++ b/tests/shell/testcases/flowtable/0015destroy_0
@@ -1,5 +1,7 @@
 #!/bin/sh -e
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_destroy)
+
 $NFT add table t
 
 # pass for non-existent flowtable
diff --git a/tests/shell/testcases/maps/0014destroy_0 b/tests/shell/testcases/maps/0014destroy_0
index 14c3f78af7f1..b17d0021d926 100755
--- a/tests/shell/testcases/maps/0014destroy_0
+++ b/tests/shell/testcases/maps/0014destroy_0
@@ -1,5 +1,7 @@
 #!/bin/sh -e
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_destroy)
+
 $NFT add table x
 
 # pass for non-existent map
diff --git a/tests/shell/testcases/rule_management/0012destroy_0 b/tests/shell/testcases/rule_management/0012destroy_0
index 85f9c9f6d4c7..46a906cf36b8 100755
--- a/tests/shell/testcases/rule_management/0012destroy_0
+++ b/tests/shell/testcases/rule_management/0012destroy_0
@@ -1,5 +1,7 @@
 #!/bin/sh -e
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_destroy)
+
 $NFT add table t
 $NFT add chain t c
 
diff --git a/tests/shell/testcases/sets/0072destroy_0 b/tests/shell/testcases/sets/0072destroy_0
index fd1d645057c0..6399dd0ff4c8 100755
--- a/tests/shell/testcases/sets/0072destroy_0
+++ b/tests/shell/testcases/sets/0072destroy_0
@@ -1,5 +1,7 @@
 #!/bin/sh -e
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_destroy)
+
 $NFT add table x
 
 # pass for non-existent set
-- 
2.41.0

