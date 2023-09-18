Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5ECBCD13D2
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 10:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241259AbjIRKb6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241262AbjIRKbj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 06:31:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F01187
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 03:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695033012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DKiGRC64wE9ShIKFmFQfNVN+jkIjsNPFSy4lrU/JsKg=;
        b=aXkFXgol9qVRTEQGG9PdmTJmUK4DOeAiU7ygNz//TAlU5hrER8WP3K9dFyxV44jPz1XmQr
        ftjUJDJYbMQstiWbMoz5ALl+FOpulwjKCqc/7p5iED4Q2E5Qq8ZEHHgSe+AO1XmI/J8VLv
        ++akS6nbD04TQOYdzA1pExsLDD3uq7g=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-V93EUxYAPsy-cl8nXDfmmw-1; Mon, 18 Sep 2023 06:30:08 -0400
X-MC-Unique: V93EUxYAPsy-cl8nXDfmmw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B9E63C025C0;
        Mon, 18 Sep 2023 10:30:08 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CCC5C15BB8;
        Mon, 18 Sep 2023 10:30:07 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 11/14] tests/shell: skip test cases if ct expectation and/or timeout lacks support
Date:   Mon, 18 Sep 2023 12:28:25 +0200
Message-ID: <20230918102947.2125883-12-thaller@redhat.com>
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
 tests/shell/features/ctexpect.nft             | 10 ++++
 tests/shell/features/cttimeout.nft            |  8 +++
 tests/shell/testcases/listing/0013objects_0   | 50 +++++--------------
 .../testcases/listing/dumps/0013objects_0.nft |  2 -
 .../testcases/nft-f/0017ct_timeout_obj_0      |  2 +
 5 files changed, 33 insertions(+), 39 deletions(-)
 create mode 100644 tests/shell/features/ctexpect.nft
 create mode 100644 tests/shell/features/cttimeout.nft

diff --git a/tests/shell/features/ctexpect.nft b/tests/shell/features/ctexpect.nft
new file mode 100644
index 000000000000..02c3dfd74bd4
--- /dev/null
+++ b/tests/shell/features/ctexpect.nft
@@ -0,0 +1,10 @@
+# 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
+# v5.3-rc1~140^2~153^2~19
+table t {
+	ct expectation ctexpect {
+		protocol tcp
+		dport 5432
+		timeout 1h
+		size 12;
+	}
+}
diff --git a/tests/shell/features/cttimeout.nft b/tests/shell/features/cttimeout.nft
new file mode 100644
index 000000000000..4be58cd3c26b
--- /dev/null
+++ b/tests/shell/features/cttimeout.nft
@@ -0,0 +1,8 @@
+# 7e0b2b57f01d ("netfilter: nft_ct: add ct timeout support")
+# v4.19-rc1~140^2~64^2~3
+table t {
+	ct timeout cttime {
+		protocol tcp;
+		policy = {established: 120 }
+	}
+}
diff --git a/tests/shell/testcases/listing/0013objects_0 b/tests/shell/testcases/listing/0013objects_0
index c81b94e20f65..c78ada947a94 100755
--- a/tests/shell/testcases/listing/0013objects_0
+++ b/tests/shell/testcases/listing/0013objects_0
@@ -1,47 +1,23 @@
 #!/bin/bash
 
-# list table with all objects and chains
-
-EXPECTED="table ip test {
-	quota https-quota {
-		25 mbytes
-	}
-
-	ct helper cthelp {
-		type \"sip\" protocol tcp
-		l3proto ip
-	}
-
-	ct timeout cttime {
-		protocol udp
-		l3proto ip
-		policy = { unreplied : 15s, replied : 12s }
-	}
-
-	ct expectation ctexpect {
-		protocol tcp
-		dport 5432
-		timeout 1h
-		size 12
-		l3proto ip
-	}
-
-	chain input {
-	}
-}"
-
 set -e
 
 $NFT add table test
 $NFT add chain test input
 $NFT add quota test https-quota 25 mbytes
 $NFT add ct helper test cthelp { type \"sip\" protocol tcp \; }
-$NFT add ct timeout test cttime { protocol udp \; policy = {replied : 12, unreplied : 15 } \; }
-$NFT add ct expectation test ctexpect { protocol tcp \; dport 5432 \; timeout 1h \; size 12 \; }
-$NFT add table test-ip
+if [ "$NFT_TEST_HAVE_cttimeout" != n ] ; then
+	$NFT add ct timeout test cttime { protocol udp \; policy = {replied : 12, unreplied : 15 } \; }
+fi
+if [ "$NFT_TEST_HAVE_ctexpect" != n ] ; then
+	$NFT add ct expectation test ctexpect { protocol tcp \; dport 5432 \; timeout 1h \; size 12 \; }
+fi
 
-GET="$($NFT list table test)"
-if [ "$EXPECTED" != "$GET" ] ; then
-	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
-	exit 1
+if [ "$NFT_TEST_HAVE_cttimeout" = n ] ; then
+	echo "Ran partial test due to NFT_TEST_HAVE_cttimeout=n (skipped)"
+	exit 77
+fi
+if [ "$NFT_TEST_HAVE_ctexpect" = n ] ; then
+	echo "Ran partial test due to NFT_TEST_HAVE_ctexpect=n (skipped)"
+	exit 77
 fi
diff --git a/tests/shell/testcases/listing/dumps/0013objects_0.nft b/tests/shell/testcases/listing/dumps/0013objects_0.nft
index 1ea610f8b8d8..427db268163a 100644
--- a/tests/shell/testcases/listing/dumps/0013objects_0.nft
+++ b/tests/shell/testcases/listing/dumps/0013objects_0.nft
@@ -25,5 +25,3 @@ table ip test {
 	chain input {
 	}
 }
-table ip test-ip {
-}
diff --git a/tests/shell/testcases/nft-f/0017ct_timeout_obj_0 b/tests/shell/testcases/nft-f/0017ct_timeout_obj_0
index 4f407793b23b..cfb789501bea 100755
--- a/tests/shell/testcases/nft-f/0017ct_timeout_obj_0
+++ b/tests/shell/testcases/nft-f/0017ct_timeout_obj_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_cttimeout)
+
 EXPECTED='table ip filter {
 	ct timeout cttime{
 		protocol tcp
-- 
2.41.0

