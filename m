Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBDA4EC875E
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 22:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbjIGWJx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 18:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjIGWJp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 18:09:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BAD1BC8
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 15:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694124527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CVCv5AB+p3+Inv0VY0+UNivHlZexnHKpe+VtRkmQID4=;
        b=Z+28To7dwdgHW05fLyAMzsaEMOhXZornBlAkoXh3ShfX6YG0XCX9M286JoWF7ezw2DB1e0
        BoG8dGoDOpMboO6Up8PaDCujgorxDhDREBJRX/JZj1T7Lol3oBNXmMIIbjDwj5/1YXAKRZ
        ofMjGU8g4CrKniyFfQTXfaq+s/MYYCE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-9BLtVBDiNZ-DDajYMfNh6g-1; Thu, 07 Sep 2023 18:08:46 -0400
X-MC-Unique: 9BLtVBDiNZ-DDajYMfNh6g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 045F2181792D
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 22:08:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 727C963F6C;
        Thu,  7 Sep 2023 22:08:45 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 02/11] tests/shell: cleanup print_test_result() and show TAINTED error code
Date:   Fri,  8 Sep 2023 00:07:14 +0200
Message-ID: <20230907220833.2435010-3-thaller@redhat.com>
In-Reply-To: <20230907220833.2435010-1-thaller@redhat.com>
References: <20230907220833.2435010-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We will add more special error codes (122 for VALGRIND). Minor refactor
of print_test_result() to make it easier to extend for that.

Also, we will soon colorize the output. This preparation patch makes
that easier too.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 423c5465c4d4..e0adb27ad104 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -471,25 +471,27 @@ print_test_result() {
 	shift 3
 
 	local result_msg_level="I"
-	local result_msg_status="OK"
 	local result_msg_suffix=""
 	local result_msg_files=( "$NFT_TEST_TESTTMPDIR/testout.log" "$NFT_TEST_TESTTMPDIR/ruleset-diff" )
+	local result_msg_status
 
 	if [ "$rc_got" -eq 0 ] ; then
 		((ok++))
-	elif [ "$rc_got" -eq 124 ] ; then
-		((failed++))
-		result_msg_level="W"
-		result_msg_status="DUMP FAIL"
+		result_msg_status="OK"
 	elif [ "$rc_got" -eq 77 ] ; then
 		((skipped++))
-		result_msg_level="I"
 		result_msg_status="SKIPPED"
 	else
 		((failed++))
 		result_msg_level="W"
-		result_msg_status="FAILED"
-		result_msg_suffix="got $rc_got"
+		if [ "$rc_got" -eq 123 ] ; then
+			result_msg_status="TAINTED"
+		elif [ "$rc_got" -eq 124 ] ; then
+			result_msg_status="DUMP FAIL"
+		else
+			result_msg_status="FAILED"
+			result_msg_suffix="got $rc_got"
+		fi
 		result_msg_files=( "$NFT_TEST_TESTTMPDIR/testout.log" )
 	fi
 
-- 
2.41.0

