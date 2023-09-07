Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C5FEC875E
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 22:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239006AbjIGWKf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 18:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237078AbjIGWKe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 18:10:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DE41BD5
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 15:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694124530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LzRJMC35G2BEDlECvoqimMR3Bpfmq/VCP6LOxQd86pk=;
        b=cMtrwrmJdcpOV69WNnFH9hnjroFJPdwtCMM6ahItIQbO25v5qGl6SWVBGOkdXroeEWa5TN
        iFf4sijTD7Yn929tIKy0OEt3G76tzB6UBQo/11hBuiPP9upR9Zp5A8aieh59CY4O375hst
        gifUttNOf2gfd2Rn1Gp9MTNwi4YLpzw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-ssaCps8_MViRyq8Wv005gQ-1; Thu, 07 Sep 2023 18:08:48 -0400
X-MC-Unique: ssaCps8_MViRyq8Wv005gQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DD093802BAC
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 22:08:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D5B9C7B62;
        Thu,  7 Sep 2023 22:08:47 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 05/11] tests/shell: print the NFT setting with the VALGRIND=y wrapper
Date:   Fri,  8 Sep 2023 00:07:17 +0200
Message-ID: <20230907220833.2435010-6-thaller@redhat.com>
In-Reply-To: <20230907220833.2435010-1-thaller@redhat.com>
References: <20230907220833.2435010-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With this we see in the info output

  I: info: NFT=./tests/shell/helpers/nft-valgrind-wrapper.sh

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index ab91fd4d9053..4f0df3217b76 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -411,6 +411,11 @@ echo
 msg_info "info: NFT_TEST_BASEDIR=$(printf '%q' "$NFT_TEST_BASEDIR")"
 msg_info "info: NFT_TEST_TMPDIR=$(printf '%q' "$NFT_TEST_TMPDIR")"
 
+if [ "$VALGRIND" == "y" ]; then
+	NFT="$NFT_TEST_BASEDIR/helpers/nft-valgrind-wrapper.sh"
+	msg_info "info: NFT=$(printf '%q' "$NFT")"
+fi
+
 kernel_cleanup() {
 	if [ "$NFT_TEST_JOBS" -ne 0 ] ; then
 		# When we run jobs in parallel (even with only one "parallel"
@@ -442,10 +447,6 @@ kernel_cleanup() {
 	nft_xfrm
 }
 
-if [ "$VALGRIND" == "y" ]; then
-	NFT="$NFT_TEST_BASEDIR/helpers/nft-valgrind-wrapper.sh"
-fi
-
 echo ""
 ok=0
 skipped=0
-- 
2.41.0

