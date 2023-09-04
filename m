Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12332CA0FF3
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Sep 2023 13:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbjIDNwj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Sep 2023 09:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237273AbjIDNwi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2023 09:52:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82ADCDB
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 06:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693835510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mCaplx2b12gPOHy5dzAq/vtfxMJVXEqhklR3v9oyYAA=;
        b=QpI2WSaB81YyezqZR7ZvE6lwOEPnbC5kVIgdju6oG6KK4SrT05NmoXDmmuQAFDrXT2ovaY
        cMx1u/opKOHUULt6SDshDbC+3HqJyPYAqrF1eoznZ6nw7UTjg0vIdDoD7aFri+iv2k1ffc
        aeA2FvooGFMnxEqPx7VYqKXn24sBG1s=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-oetfPCniMwqUqiultya67w-1; Mon, 04 Sep 2023 09:51:48 -0400
X-MC-Unique: oetfPCniMwqUqiultya67w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C4603C19365
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 13:51:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F0D381121314;
        Mon,  4 Sep 2023 13:51:47 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v3 03/11] tests/shell: check test names before start and support directories
Date:   Mon,  4 Sep 2023 15:48:05 +0200
Message-ID: <20230904135135.1568180-4-thaller@redhat.com>
In-Reply-To: <20230904135135.1568180-1-thaller@redhat.com>
References: <20230904135135.1568180-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check for valid test names early. That's useful because we treat any
unrecognized options as test names. We should detect a mistake early.

While at it, also support specifying directory names instead of
executable files.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 184dd3f38be5..0a2598f10bed 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -103,6 +103,18 @@ if [ "${#TESTS[@]}" -eq 0 ] ; then
 	test "${#TESTS[@]}" -gt 0 || msg_error "Could not find tests"
 fi
 
+TESTSOLD=( "${TESTS[@]}" )
+TESTS=()
+for t in "${TESTSOLD[@]}" ; do
+	if [ -f "$t" -a -x "$t" ] ; then
+		TESTS+=( "$t" )
+	elif [ -d "$t" ] ; then
+		TESTS+=( $(find_tests "$t") )
+	else
+		msg_error "Unknown test \"$t\""
+	fi
+done
+
 if [ "$DO_LIST_TESTS" = y ] ; then
 	printf '%s\n' "${TESTS[@]}"
 	exit 0
-- 
2.41.0

