Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8D1CD13DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 10:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241267AbjIRKcC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241260AbjIRKbi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 06:31:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B09911C
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 03:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695033006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HrJvPG+SnbeW18DNKYVB+Hg7i7srQDd2fK0Mv08eRaQ=;
        b=e6Pe+rB6At4sLrrV2fpSpcN1SpgT6d38BmhS01mhQe0SJs3RbWEJBffQAw+pBZHmj2xRZx
        Vm0qiDBis4MUazShFl4g+23Qb6KpbQRH+4P4XbFsRmF/UZWwwl5UT4fxA6+xVXehdKWhqO
        PvDPejem14fnAFhyM/mysXrIWIOIxd0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-0iyqrDPZPZGGLZPlZGLywg-1; Mon, 18 Sep 2023 06:30:03 -0400
X-MC-Unique: 0iyqrDPZPZGGLZPlZGLywg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBEF929AA386;
        Mon, 18 Sep 2023 10:30:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A113C15BB8;
        Mon, 18 Sep 2023 10:30:01 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 05/14] tests/shell: skip bitshift tests if kernel lacks support
Date:   Mon, 18 Sep 2023 12:28:19 +0200
Message-ID: <20230918102947.2125883-6-thaller@redhat.com>
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
 tests/shell/features/bitshift.nft              | 7 +++++++
 tests/shell/testcases/bitwise/0040mark_binop_0 | 2 ++
 tests/shell/testcases/bitwise/0040mark_binop_1 | 2 ++
 tests/shell/testcases/bitwise/0040mark_binop_2 | 2 ++
 tests/shell/testcases/bitwise/0040mark_binop_3 | 2 ++
 tests/shell/testcases/bitwise/0040mark_binop_4 | 2 ++
 tests/shell/testcases/bitwise/0040mark_binop_5 | 2 ++
 tests/shell/testcases/bitwise/0040mark_binop_6 | 2 ++
 tests/shell/testcases/bitwise/0040mark_binop_7 | 2 ++
 tests/shell/testcases/bitwise/0040mark_binop_8 | 2 ++
 tests/shell/testcases/bitwise/0040mark_binop_9 | 2 ++
 11 files changed, 27 insertions(+)
 create mode 100644 tests/shell/features/bitshift.nft

diff --git a/tests/shell/features/bitshift.nft b/tests/shell/features/bitshift.nft
new file mode 100644
index 000000000000..7f9ccb64f0e6
--- /dev/null
+++ b/tests/shell/features/bitshift.nft
@@ -0,0 +1,7 @@
+# 567d746b55bc ("netfilter: bitwise: add support for shifts.")
+# v5.6-rc1~151^2~73^2
+table ip t {
+	chain c {
+		meta mark set meta mark << 2
+	}
+}
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_0 b/tests/shell/testcases/bitwise/0040mark_binop_0
index 4280e33ac45a..4ecc9d3d6c83 100755
--- a/tests/shell/testcases/bitwise/0040mark_binop_0
+++ b/tests/shell/testcases/bitwise/0040mark_binop_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitshift)
+
 set -e
 
 RULESET="
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_1 b/tests/shell/testcases/bitwise/0040mark_binop_1
index 7e71f3eb43a8..bd9e028df78c 100755
--- a/tests/shell/testcases/bitwise/0040mark_binop_1
+++ b/tests/shell/testcases/bitwise/0040mark_binop_1
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitshift)
+
 set -e
 
 RULESET="
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_2 b/tests/shell/testcases/bitwise/0040mark_binop_2
index 94ebe976c987..5e66a27a0498 100755
--- a/tests/shell/testcases/bitwise/0040mark_binop_2
+++ b/tests/shell/testcases/bitwise/0040mark_binop_2
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitshift)
+
 set -e
 
 RULESET="
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_3 b/tests/shell/testcases/bitwise/0040mark_binop_3
index b491565ca573..21dda6701d38 100755
--- a/tests/shell/testcases/bitwise/0040mark_binop_3
+++ b/tests/shell/testcases/bitwise/0040mark_binop_3
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitshift)
+
 set -e
 
 RULESET="
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_4 b/tests/shell/testcases/bitwise/0040mark_binop_4
index adc5f25ba930..e5c8a42a0eb4 100755
--- a/tests/shell/testcases/bitwise/0040mark_binop_4
+++ b/tests/shell/testcases/bitwise/0040mark_binop_4
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitshift)
+
 set -e
 
 RULESET="
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_5 b/tests/shell/testcases/bitwise/0040mark_binop_5
index 286b7b1fc7f9..184fbed0701d 100755
--- a/tests/shell/testcases/bitwise/0040mark_binop_5
+++ b/tests/shell/testcases/bitwise/0040mark_binop_5
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitshift)
+
 set -e
 
 RULESET="
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_6 b/tests/shell/testcases/bitwise/0040mark_binop_6
index 9ea82952ef24..129dd5c085f4 100755
--- a/tests/shell/testcases/bitwise/0040mark_binop_6
+++ b/tests/shell/testcases/bitwise/0040mark_binop_6
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitshift)
+
 set -e
 
 RULESET="
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_7 b/tests/shell/testcases/bitwise/0040mark_binop_7
index ff9cfb55ac3e..791a7943581d 100755
--- a/tests/shell/testcases/bitwise/0040mark_binop_7
+++ b/tests/shell/testcases/bitwise/0040mark_binop_7
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitshift)
+
 set -e
 
 RULESET="
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_8 b/tests/shell/testcases/bitwise/0040mark_binop_8
index b348ee9367df..5e7bd28da754 100755
--- a/tests/shell/testcases/bitwise/0040mark_binop_8
+++ b/tests/shell/testcases/bitwise/0040mark_binop_8
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitshift)
+
 set -e
 
 RULESET="
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_9 b/tests/shell/testcases/bitwise/0040mark_binop_9
index d19447d42b22..a7b60fb87812 100755
--- a/tests/shell/testcases/bitwise/0040mark_binop_9
+++ b/tests/shell/testcases/bitwise/0040mark_binop_9
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitshift)
+
 set -e
 
 RULESET="
-- 
2.41.0

