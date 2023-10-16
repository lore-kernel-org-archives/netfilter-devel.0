Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD4E0CDB482
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Oct 2023 13:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbjJPNbc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Oct 2023 09:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbjJPNbY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Oct 2023 09:31:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B646A118
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 06:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697463032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9/rO7DZ2O/ZFJNuEbzHZWVrhhfsZXGYZlKuEi93YOXk=;
        b=BAtmjuMH1bDUKFmdd0vJGV8XyHEu3/Fc8uEtM5cXJUqqvlKujOzXQJfc00OLvZD4E0aqQf
        dIZMtNL/lfcHgbWizh7lQWSLJVLHPZCkXO1bQiiWHU6HYtKxVVxA/jb1d3P09Fd5wlWmtH
        SNdpJYQEMkWY539rObG9HH6wLoEcVxI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-zkEPudNKPMyms5OnnDMFDQ-1; Mon, 16 Oct 2023 09:30:31 -0400
X-MC-Unique: zkEPudNKPMyms5OnnDMFDQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4D00857EC1
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 13:30:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 38620C15BBC;
        Mon, 16 Oct 2023 13:30:30 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/2] tests/shell: use bash instead of /bin/sh for tests
Date:   Mon, 16 Oct 2023 15:30:10 +0200
Message-ID: <20231016133019.1134188-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All tests under "tests/shell" are shell scripts with shebang /bin/bash
or /bin/sh. This may seem expected, since these tests are under
"tests/shell" directory, but any executable file would work.

Anyway. The vast majority of the tests has "#!/bin/bash" as shebang.
A few tests had "#!/bin/sh" or "#!/bin/sh -e". Unify this and always use bash.
Since we anyway require bash, this is not a limitation.

Also, if we know that this is a bash script (by parsing the shebang), we
can let the test wrapper pass "-x" to the script. The next commit will
do that, and it is nicer if the shebangs are all uniform.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/testcases/chains/0014rename_0            | 2 +-
 tests/shell/testcases/chains/0044chain_destroy_0     | 2 +-
 tests/shell/testcases/flowtable/0015destroy_0        | 2 +-
 tests/shell/testcases/maps/0014destroy_0             | 2 +-
 tests/shell/testcases/rule_management/0010replace_0  | 2 +-
 tests/shell/testcases/rule_management/0012destroy_0  | 2 +-
 tests/shell/testcases/sets/0043concatenated_ranges_0 | 2 +-
 tests/shell/testcases/sets/0043concatenated_ranges_1 | 2 +-
 tests/shell/testcases/sets/0044interval_overlap_0    | 2 +-
 tests/shell/testcases/sets/0044interval_overlap_1    | 2 +-
 tests/shell/testcases/sets/0072destroy_0             | 2 +-
 tests/shell/testcases/transactions/bad_expression    | 2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tests/shell/testcases/chains/0014rename_0 b/tests/shell/testcases/chains/0014rename_0
index bebe48d67af9..bd84e95784a7 100755
--- a/tests/shell/testcases/chains/0014rename_0
+++ b/tests/shell/testcases/chains/0014rename_0
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 $NFT add table t || exit 1
 $NFT add chain t c1 || exit 1
diff --git a/tests/shell/testcases/chains/0044chain_destroy_0 b/tests/shell/testcases/chains/0044chain_destroy_0
index 1763d802c1dd..5c5a10a7b9c8 100755
--- a/tests/shell/testcases/chains/0044chain_destroy_0
+++ b/tests/shell/testcases/chains/0044chain_destroy_0
@@ -1,4 +1,4 @@
-#!/bin/sh -e
+#!/bin/bash -e
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_destroy)
 
diff --git a/tests/shell/testcases/flowtable/0015destroy_0 b/tests/shell/testcases/flowtable/0015destroy_0
index 9e91ef5036a2..d2a87da080fb 100755
--- a/tests/shell/testcases/flowtable/0015destroy_0
+++ b/tests/shell/testcases/flowtable/0015destroy_0
@@ -1,4 +1,4 @@
-#!/bin/sh -e
+#!/bin/bash -e
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_destroy)
 
diff --git a/tests/shell/testcases/maps/0014destroy_0 b/tests/shell/testcases/maps/0014destroy_0
index b17d0021d926..ee81e3cdcca9 100755
--- a/tests/shell/testcases/maps/0014destroy_0
+++ b/tests/shell/testcases/maps/0014destroy_0
@@ -1,4 +1,4 @@
-#!/bin/sh -e
+#!/bin/bash -e
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_destroy)
 
diff --git a/tests/shell/testcases/rule_management/0010replace_0 b/tests/shell/testcases/rule_management/0010replace_0
index 251cebb26ec0..cd69a89d9861 100755
--- a/tests/shell/testcases/rule_management/0010replace_0
+++ b/tests/shell/testcases/rule_management/0010replace_0
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 # test for kernel commit ca08987885a147643817d02bf260bc4756ce8cd4
 # ("netfilter: nf_tables: deactivate expressions in rule replecement routine")
diff --git a/tests/shell/testcases/rule_management/0012destroy_0 b/tests/shell/testcases/rule_management/0012destroy_0
index 46a906cf36b8..a058150fed14 100755
--- a/tests/shell/testcases/rule_management/0012destroy_0
+++ b/tests/shell/testcases/rule_management/0012destroy_0
@@ -1,4 +1,4 @@
-#!/bin/sh -e
+#!/bin/bash -e
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_destroy)
 
diff --git a/tests/shell/testcases/sets/0043concatenated_ranges_0 b/tests/shell/testcases/sets/0043concatenated_ranges_0
index 4165b2f5f711..83d743503c7b 100755
--- a/tests/shell/testcases/sets/0043concatenated_ranges_0
+++ b/tests/shell/testcases/sets/0043concatenated_ranges_0
@@ -1,4 +1,4 @@
-#!/bin/sh -e
+#!/bin/bash -e
 #
 # NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
 #
diff --git a/tests/shell/testcases/sets/0043concatenated_ranges_1 b/tests/shell/testcases/sets/0043concatenated_ranges_1
index bab189c56d8c..1be2889352c9 100755
--- a/tests/shell/testcases/sets/0043concatenated_ranges_1
+++ b/tests/shell/testcases/sets/0043concatenated_ranges_1
@@ -1,4 +1,4 @@
-#!/bin/sh -e
+#!/bin/bash -e
 #
 # 0043concatenated_ranges_1 - Insert and list subnets of different sizes
 
diff --git a/tests/shell/testcases/sets/0044interval_overlap_0 b/tests/shell/testcases/sets/0044interval_overlap_0
index 19aa6f5ed081..71bf3345a558 100755
--- a/tests/shell/testcases/sets/0044interval_overlap_0
+++ b/tests/shell/testcases/sets/0044interval_overlap_0
@@ -1,4 +1,4 @@
-#!/bin/sh -e
+#!/bin/bash -e
 #
 # NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
 #
diff --git a/tests/shell/testcases/sets/0044interval_overlap_1 b/tests/shell/testcases/sets/0044interval_overlap_1
index 905e6d5a0348..cdd0c8446f1b 100755
--- a/tests/shell/testcases/sets/0044interval_overlap_1
+++ b/tests/shell/testcases/sets/0044interval_overlap_1
@@ -1,4 +1,4 @@
-#!/bin/sh -e
+#!/bin/bash -e
 #
 # NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
 #
diff --git a/tests/shell/testcases/sets/0072destroy_0 b/tests/shell/testcases/sets/0072destroy_0
index 6399dd0ff4c8..9886a9b04463 100755
--- a/tests/shell/testcases/sets/0072destroy_0
+++ b/tests/shell/testcases/sets/0072destroy_0
@@ -1,4 +1,4 @@
-#!/bin/sh -e
+#!/bin/bash -e
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_destroy)
 
diff --git a/tests/shell/testcases/transactions/bad_expression b/tests/shell/testcases/transactions/bad_expression
index a820c2b98c39..794b62581b62 100755
--- a/tests/shell/testcases/transactions/bad_expression
+++ b/tests/shell/testcases/transactions/bad_expression
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 # table with invalid expression (masquerade called from filter table).
 # nft must return an error.  Also catch nfnetlink retry loops that
-- 
2.41.0

