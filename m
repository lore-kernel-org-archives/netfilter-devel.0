Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D04EB8FB6
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbjIFMCO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjIFMCO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:02:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2D4137
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5szBOaJ8Gr+rgLWX1prVc678UTVoALgMGLwKmUiZmdw=;
        b=cmE41C6mDtUWg5Sqb7Q969gWY/r+6fY90wtpyLcnytfIhIzMHFKFbj7FH89KxjGdFUswwd
        cAuK/57cUdBYlqlhIsYYS8W+DpAcg8HWrAxpb+ApoSlH3HUVGF+A/JNLuh9KJkToaXYiDG
        Jp/2C8rPu2kyQ/fg+cNjf0J4AkJL4tc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-9Ua30OGVN8ueCY_akyJbdw-1; Wed, 06 Sep 2023 08:01:22 -0400
X-MC-Unique: 9Ua30OGVN8ueCY_akyJbdw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5608F1C0725E
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CA421C15BB8;
        Wed,  6 Sep 2023 12:01:21 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 03/19] tests/shell: check test names before start and support directories
Date:   Wed,  6 Sep 2023 13:52:06 +0200
Message-ID: <20230906120109.1773860-4-thaller@redhat.com>
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
index 5f526dd8f258..34c3b324b04b 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -109,6 +109,18 @@ if [ "${#TESTS[@]}" -eq 0 ] ; then
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

