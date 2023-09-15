Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE662EED60B
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Sep 2023 15:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbjIOP5c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Sep 2023 11:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236207AbjIOP5Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Sep 2023 11:57:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A65810E6
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Sep 2023 08:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694793390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6H9AkdtZWnf7S4qNS8WRWwwzoPhcKieim9t7+k7jmfY=;
        b=HoSLmDEoTO2wwWfSWRgeJEbUaNqGwA9sxY9lyMTPj9KFBzB7eMkaXgv4WtQgANlQ8Nco7N
        CTc4iR4/o47kHXzuHkqk67bqZC8jq7xa7w8oOeIvlPJKISTiSvqxPFtnr4Fd4XK5HZXxxg
        Hxkzjz2eApncY49tysaE8J7wV1Vd6Ho=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-NZD40b0bP72S_p6q4Coqcw-1; Fri, 15 Sep 2023 11:56:29 -0400
X-MC-Unique: NZD40b0bP72S_p6q4Coqcw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA8F8945931
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Sep 2023 15:56:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 687C740C2070;
        Fri, 15 Sep 2023 15:56:28 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/3] tests/shell: suggest 4Mb /proc/sys/net/core/{wmem_max,rmem_max} for rootless
Date:   Fri, 15 Sep 2023 17:54:02 +0200
Message-ID: <20230915155614.1325657-4-thaller@redhat.com>
In-Reply-To: <20230915155614.1325657-1-thaller@redhat.com>
References: <20230915155614.1325657-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

2Mb was not enough to pass "tests/shell/testcases/sets/0030add_many_elements_interval_0"
in an unprivileged/rootless namespace.

Instead, bump the suggestion to 4Mb, which lets the test pass.

Note that the 4Mb are only the recommended value when running the test
as rootless, and is used to autodetect NFT_TEST_HAS_SOCKET_LIMITS=y.
You can set whatever values are suitable for your environment, and
explicitly indicate whether the limits are appropriate or not via
NFT_TEST_HAS_SOCKET_LIMITS=n|y.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 1527b2a6455c..d11b4a63b6d1 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -180,7 +180,7 @@ usage() {
 	echo "                 with rootless the test would fail. Tests will check for [ "\$NFT_TEST_HAS_SOCKET_LIMITS" = y ]"
 	echo "                 and skip. You may set NFT_TEST_HAS_SOCKET_LIMITS=n if you ensure those limits are"
 	echo "                 suitable to run the test rootless. Otherwise will be autodetected."
-	echo "                 Set /proc/sys/net/core/{wmem_max,rmem_max} to at least 2MB to get them to pass automatically."
+	echo "                 Set /proc/sys/net/core/{wmem_max,rmem_max} to at least 4MB to get them to pass automatically."
 	echo " NFT_TEST_UNSHARE_CMD=cmd : when set, this is the command line for an unshare"
 	echo "                 command, which is used to sandbox each test invocation. By"
 	echo "                 setting it to empty, no unsharing is done."
@@ -391,8 +391,8 @@ export NFT_TEST_HAS_REALROOT
 if [ "$NFT_TEST_HAS_SOCKET_LIMITS" = "" ] ; then
 	if [ "$NFT_TEST_HAS_REALROOT" = y ] ; then
 		NFT_TEST_HAS_SOCKET_LIMITS=n
-	elif [ "$(cat /proc/sys/net/core/wmem_max 2>/dev/null)" -ge $((2000*1024)) ] 2>/dev/null && \
-	     [ "$(cat /proc/sys/net/core/rmem_max 2>/dev/null)" -ge $((2000*1024)) ] 2>/dev/null ; then
+	elif [ "$(cat /proc/sys/net/core/wmem_max 2>/dev/null)" -ge $((4000*1024)) ] 2>/dev/null && \
+	     [ "$(cat /proc/sys/net/core/rmem_max 2>/dev/null)" -ge $((4000*1024)) ] 2>/dev/null ; then
 		NFT_TEST_HAS_SOCKET_LIMITS=n
 	else
 		NFT_TEST_HAS_SOCKET_LIMITS=y
-- 
2.41.0

