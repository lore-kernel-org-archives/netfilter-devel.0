Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F429EED60B
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Sep 2023 15:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236211AbjIOP5d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Sep 2023 11:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236213AbjIOP5T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Sep 2023 11:57:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0878210CC
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Sep 2023 08:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694793389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JedpswcPAn3NOSZ6fI3JAA2OrBxpWvTuLUL2hEXOXxI=;
        b=PT11NeWNBkMZ7YcPLGb1J3YJ0wFKj5FTj70clQhpV5nlJDhs8RHi+b+yUVzKBTCtVF/A7A
        i/TFaqjGHU1PFAcozk78eldO7GqBfSjTDx5r64uk10A/oV7SFVc8i+pKjQKwFw6GhKZ65U
        FsD1ODBxYFvGIv37qaVnVFw0bJInWT4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-JxNyUmdbNL2nBEzDa50Rmg-1; Fri, 15 Sep 2023 11:56:27 -0400
X-MC-Unique: JxNyUmdbNL2nBEzDa50Rmg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65494811E98
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Sep 2023 15:56:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B0BB40C2070;
        Fri, 15 Sep 2023 15:56:26 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/3] tests/shell: cleanup creating dummy interfaces in tests
Date:   Fri, 15 Sep 2023 17:54:00 +0200
Message-ID: <20230915155614.1325657-2-thaller@redhat.com>
In-Reply-To: <20230915155614.1325657-1-thaller@redhat.com>
References: <20230915155614.1325657-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In "tests/shell/testcases/chains/netdev_chain_0", calling "trap ...
EXIT" multiple times does not work. Fix it, by calling one cleanup
function.

Note that we run in separate namespaces, so the cleanup is usually not
necessary. Still do it, we might want to run without unshare (via
NFT_TEST_UNSHARE_CMD=""). Without unshare, it's important that the
cleanup always works. In practice it might not, for example, "trap ...
EXIT" does not run for SIGTERM. A leaked interface might break the
follow up test and tests interfere with each other.

Try to workaround that by first trying to delete the interface.

Also failures to create the interfaces are not considered fatal. I don't
understand under what circumstances this might fail, note that there are
other tests that create dummy interface and don't "exit 77" on failure.
We want to know when something odd is going on.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 .../testcases/chains/dumps/netdev_chain_0.nft |  3 ---
 tests/shell/testcases/chains/netdev_chain_0   | 26 +++++++------------
 .../flowtable/0012flowtable_variable_0        |  6 +++++
 .../dumps/0012flowtable_variable_0.nft        |  4 +--
 tests/shell/testcases/json/netdev             | 12 +++++----
 tests/shell/testcases/listing/0020flowtable_0 | 12 +++++----
 6 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/tests/shell/testcases/chains/dumps/netdev_chain_0.nft b/tests/shell/testcases/chains/dumps/netdev_chain_0.nft
index bc02dc18692d..aa571e00885f 100644
--- a/tests/shell/testcases/chains/dumps/netdev_chain_0.nft
+++ b/tests/shell/testcases/chains/dumps/netdev_chain_0.nft
@@ -1,5 +1,2 @@
 table netdev x {
-	chain y {
-		type filter hook ingress devices = { d0, d1 } priority filter; policy accept;
-	}
 }
diff --git a/tests/shell/testcases/chains/netdev_chain_0 b/tests/shell/testcases/chains/netdev_chain_0
index 41e724413528..88bbc437d471 100755
--- a/tests/shell/testcases/chains/netdev_chain_0
+++ b/tests/shell/testcases/chains/netdev_chain_0
@@ -1,24 +1,18 @@
 #!/bin/bash
 
-ip link add d0 type dummy || {
-        echo "Skipping, no dummy interface available"
-        exit 77
-}
-trap "ip link del d0" EXIT
-
-ip link add d1 type dummy || {
-        echo "Skipping, no dummy interface available"
-        exit 77
-}
-trap "ip link del d1" EXIT
+set -e
 
-ip link add d2 type dummy || {
-        echo "Skipping, no dummy interface available"
-        exit 77
+iface_cleanup() {
+	ip link del d0 &>/dev/null || :
+	ip link del d1 &>/dev/null || :
+	ip link del d2 &>/dev/null || :
 }
-trap "ip link del d2" EXIT
+trap 'iface_cleanup' EXIT
+iface_cleanup
 
-set -e
+ip link add d0 type dummy
+ip link add d1 type dummy
+ip link add d2 type dummy
 
 RULESET="table netdev x {
 	chain y {
diff --git a/tests/shell/testcases/flowtable/0012flowtable_variable_0 b/tests/shell/testcases/flowtable/0012flowtable_variable_0
index 8e334224ac66..080059d24935 100755
--- a/tests/shell/testcases/flowtable/0012flowtable_variable_0
+++ b/tests/shell/testcases/flowtable/0012flowtable_variable_0
@@ -2,6 +2,12 @@
 
 set -e
 
+iface_cleanup() {
+	ip link del dummy1 &>/dev/null || :
+}
+trap 'iface_cleanup' EXIT
+iface_cleanup
+
 ip link add name dummy1 type dummy
 
 EXPECTED="define if_main = { lo, dummy1 }
diff --git a/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft b/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft
index 1cbb2f1103f0..df1c51a24703 100644
--- a/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft
+++ b/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft
@@ -1,14 +1,14 @@
 table ip filter1 {
 	flowtable Main_ft1 {
 		hook ingress priority filter
-		devices = { dummy1, lo }
+		devices = { lo }
 		counter
 	}
 }
 table ip filter2 {
 	flowtable Main_ft2 {
 		hook ingress priority filter
-		devices = { dummy1, lo }
+		devices = { lo }
 		counter
 	}
 }
diff --git a/tests/shell/testcases/json/netdev b/tests/shell/testcases/json/netdev
index dad7afcdc020..8c16cf42baa0 100755
--- a/tests/shell/testcases/json/netdev
+++ b/tests/shell/testcases/json/netdev
@@ -1,12 +1,14 @@
 #!/bin/bash
 
-ip link add d0 type dummy || {
-        echo "Skipping, no dummy interface available"
-        exit 77
+set -e
+
+iface_cleanup() {
+	ip link del d0 &>/dev/null || :
 }
-trap "ip link del d0" EXIT
+trap 'iface_cleanup' EXIT
+iface_cleanup
 
-set -e
+ip link add d0 type dummy
 
 $NFT flush ruleset
 $NFT add table inet test
diff --git a/tests/shell/testcases/listing/0020flowtable_0 b/tests/shell/testcases/listing/0020flowtable_0
index 210289d70415..6eb82cfeabc3 100755
--- a/tests/shell/testcases/listing/0020flowtable_0
+++ b/tests/shell/testcases/listing/0020flowtable_0
@@ -2,6 +2,8 @@
 
 # list only the flowtable asked for with table
 
+set -e
+
 FLOWTABLES="flowtable f {
 	hook ingress priority filter
 	devices = { lo }
@@ -41,13 +43,13 @@ EXPECTED3="table ip filter {
 	}
 }"
 
-ip link add d0 type dummy || {
-	echo "Skipping, no dummy interface available"
-	exit 77
+iface_cleanup() {
+	ip link del d0 &>/dev/null || :
 }
-trap "ip link del d0" EXIT
+trap 'iface_cleanup' EXIT
+iface_cleanup
 
-set -e
+ip link add d0 type dummy
 
 $NFT -f - <<< "$RULESET"
 
-- 
2.41.0

