Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC150EE800D
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 14:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbjIHORr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 10:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238573AbjIHORq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 10:17:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D651BEE
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 07:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694182616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZPUjb4nfexMhzaYT6rSvjSQRWp8cUtlUO+99mGnF3vs=;
        b=Lg7c9ZPSS/X8OXyF08A9Z/G5rsLO+uunwq/sBpg3Illpje1oCPxYYHy8TyEQiS6Dlh8RCm
        l6rLQdL1LkAh2egRlC3FJPSha5Kp8pIok2a5inR/31OZGQluq0lEwZQ97+9/DeJ5Yj7oZd
        tbBrmSr7KlE32dUL1dbn0z/pbxnCsJw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-xy3uRgKhO3uky8SDBWGaRg-1; Fri, 08 Sep 2023 10:16:54 -0400
X-MC-Unique: xy3uRgKhO3uky8SDBWGaRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92D3B18307C6
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 14:16:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C4CA40ED774;
        Fri,  8 Sep 2023 14:16:45 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 1/4] tests/shell: honor .nodump file for tests without nft dumps
Date:   Fri,  8 Sep 2023 16:14:24 +0200
Message-ID: <20230908141634.1023071-2-thaller@redhat.com>
In-Reply-To: <20230908141634.1023071-1-thaller@redhat.com>
References: <20230908141634.1023071-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For some tests, the dump is not stable or useful to test. For example,
if they have an "expires" timestamps. Those tests don't have a .nft file
in the dumps directory, and don't have it checked.

DUMPGEN=y generates a new dump file, if the "dumps/" directory exists.
Omitting that directory is a way to prevent the generation of the file.
However, many such tests share their directory with tests that do have dumps.

When running tests with DUMPGEN=y, new files for old tests are generated.
Those files are not meant to be compared or committed to git because
it's known to not work.

Whether a test has a dump file, is part of the test. The absence of the
dump file should also be recorded and committed to git.

Add a way to opt-out from such generating such dumps by having .nodump
files instead of the .nft dump.

Later we should add unit tests that checks that no test has both a .nft
and a .nodump file in git, that the .nodump file is always empty, and
that every .nft/.nodump file has a corresponding test committed to git.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index 405e70c86751..03213187eb3c 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -49,6 +49,7 @@ read tainted_after < /proc/sys/kernel/tainted
 
 DUMPPATH="$TESTDIR/dumps"
 DUMPFILE="$DUMPPATH/$TESTBASE.nft"
+NODUMPFILE="$DUMPPATH/$TESTBASE.nodump"
 
 dump_written=
 
@@ -59,9 +60,14 @@ dump_written=
 #
 # It also will only happen for tests, that have a "$DUMPPATH" directory. There
 # might be tests, that don't want to have dumps created. The existence of the
-# directory controls that.
-if [ "$rc_test" -eq 0 -a "$DUMPGEN" = y -a -d "$DUMPPATH" ] ; then
+# directory controls that. Tests that have a "$NODUMPFILE" file, don't get a dump generated.
+if [ "$rc_test" -eq 0 -a "$DUMPGEN" = y -a -d "$DUMPPATH" -a ! -f "$NODUMPFILE" ] ; then
 	dump_written=y
+	if [ ! -f "$DUMPFILE" ] ; then
+		# No dumpfile exists yet. We generate both a .nft and a .nodump
+		# file. The user can pick which one to commit to git.
+		: > "$NODUMPFILE"
+	fi
 	cat "$NFT_TEST_TESTTMPDIR/ruleset-after" > "$DUMPFILE"
 fi
 
-- 
2.41.0

