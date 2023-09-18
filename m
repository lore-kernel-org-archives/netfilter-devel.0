Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AFEEC46CA1
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 10:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbjIRKbz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241264AbjIRKbj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 06:31:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829DC126
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 03:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695033009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BIVY62Z4JYWKs8Qawyq0W8YWZXgcIjPvC7W1faOV3Bw=;
        b=c79rOv3rZ9BUyIAusezp1424g5uimMvHL7aoSbxr2Hu9CJKfgDWYbf2uuEJxteOCdPYPQA
        UBgb/4Z/wRwQMWvoqfzU2GD2vO59HiUsG5Q3T0q1pOHLmclL3ba41zQ47JMlvDjEtTWw/h
        VncM19Ucks7XHtx52rehpUuwwOz7CO0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-yKsDYkROMg2rgmWwbWWd_A-1; Mon, 18 Sep 2023 06:30:06 -0400
X-MC-Unique: yKsDYkROMg2rgmWwbWWd_A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 594BE185A79B;
        Mon, 18 Sep 2023 10:30:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AC404C15BB8;
        Mon, 18 Sep 2023 10:30:05 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 09/14] tests/shell: skip catchall tests if kernel lacks support
Date:   Mon, 18 Sep 2023 12:28:23 +0200
Message-ID: <20230918102947.2125883-10-thaller@redhat.com>
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
 tests/shell/features/catchall_element.nft           |  8 ++++++++
 tests/shell/testcases/maps/0011vmap_0               | 10 +++++++++-
 tests/shell/testcases/maps/0017_map_variable_0      | 13 ++++++++++++-
 .../testcases/maps/map_catchall_double_deactivate   |  2 ++
 tests/shell/testcases/sets/0063set_catchall_0       |  2 ++
 tests/shell/testcases/sets/0064map_catchall_0       |  2 ++
 6 files changed, 35 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/features/catchall_element.nft

diff --git a/tests/shell/features/catchall_element.nft b/tests/shell/features/catchall_element.nft
new file mode 100644
index 000000000000..1a02fd61486b
--- /dev/null
+++ b/tests/shell/features/catchall_element.nft
@@ -0,0 +1,8 @@
+# aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
+# v5.13-rc1~94^2~10^2~2
+table t {
+	map m {
+		type inet_service : inet_service
+		elements = { * : 42 }
+	}
+}
diff --git a/tests/shell/testcases/maps/0011vmap_0 b/tests/shell/testcases/maps/0011vmap_0
index 83704d484b28..3e6fa78d7d4c 100755
--- a/tests/shell/testcases/maps/0011vmap_0
+++ b/tests/shell/testcases/maps/0011vmap_0
@@ -22,4 +22,12 @@ EXPECTED="table inet filter {
 }"
 
 $NFT -f - <<< "$EXPECTED"
-$NFT 'add element inet filter portmap { 22 : jump ssh_input, * : drop }'
+
+if [ "$NFT_TEST_HAVE_catchall_element" != n ]; then
+	$NFT 'add element inet filter portmap { 22 : jump ssh_input, * : drop }'
+fi
+
+if [ "$NFT_TEST_HAVE_catchall_element" = n ]; then
+	echo "Ran partial tests due to NFT_TEST_HAVE_catchall_element=n (skipped)"
+	exit 77
+fi
diff --git a/tests/shell/testcases/maps/0017_map_variable_0 b/tests/shell/testcases/maps/0017_map_variable_0
index 70cea88de238..e01adb4c6ac9 100755
--- a/tests/shell/testcases/maps/0017_map_variable_0
+++ b/tests/shell/testcases/maps/0017_map_variable_0
@@ -2,9 +2,15 @@
 
 set -e
 
+if [ "$NFT_TEST_HAVE_catchall_element" != n ] ; then
+	CATCHALL="* : 3,"
+else
+	CATCHALL=","
+fi
+
 RULESET="define x = {
         1.1.1.1 : 2,
-        * : 3,
+        $CATCHALL
 }
 
 table ip x {
@@ -19,3 +25,8 @@ table ip x {
 }"
 
 $NFT -f - <<< "$RULESET"
+
+if [ "$NFT_TEST_HAVE_catchall_element" = n ] ; then
+	echo "Ran modified version of test due to NFT_TEST_HAVE_catchall_element=n (skipped)"
+	exit 77
+fi
diff --git a/tests/shell/testcases/maps/map_catchall_double_deactivate b/tests/shell/testcases/maps/map_catchall_double_deactivate
index 62fa73ad52f8..651c08a1eb10 100755
--- a/tests/shell/testcases/maps/map_catchall_double_deactivate
+++ b/tests/shell/testcases/maps/map_catchall_double_deactivate
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_catchall_element)
+
 $NFT "add table ip test ;
      add map ip test testmap { type ipv4_addr : verdict; };
      add chain ip test testchain;
diff --git a/tests/shell/testcases/sets/0063set_catchall_0 b/tests/shell/testcases/sets/0063set_catchall_0
index faca56a18dc5..edd015d09b21 100755
--- a/tests/shell/testcases/sets/0063set_catchall_0
+++ b/tests/shell/testcases/sets/0063set_catchall_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_catchall_element)
+
 set -e
 
 RULESET="table ip x {
diff --git a/tests/shell/testcases/sets/0064map_catchall_0 b/tests/shell/testcases/sets/0064map_catchall_0
index 436851604e34..fd289372df18 100755
--- a/tests/shell/testcases/sets/0064map_catchall_0
+++ b/tests/shell/testcases/sets/0064map_catchall_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_catchall_element)
+
 set -e
 
 RULESET="table ip x {
-- 
2.41.0

