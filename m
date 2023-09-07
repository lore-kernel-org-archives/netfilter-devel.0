Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB62EC875B
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 21:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbjIGVHB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 17:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236624AbjIGVHA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 17:07:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88BC1BCA
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 14:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694120771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MZIIm7kJnzJEFLvPMdN+mrkjJ1Kri6ODax67BC6tRr0=;
        b=e8c1ez6iN5HHov/Grx+1xtm+w9C+4fw/o7R1ntGvn23GU0U5oDMgjQYDX+wqtHBMm5AOZ8
        kOzoZ60mDu0WE19qeeI6ux6My7U+F6DzVTEFRGE+sD2czECJXV5EbSY+qVqu7EgfMwYUbG
        /1GDO7gbUCNQrSqFIktx6TRb+qoxoS4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-90-7t-jNLq_Ngup6Xsm61Ik4w-1; Thu, 07 Sep 2023 17:06:09 -0400
X-MC-Unique: 7t-jNLq_Ngup6Xsm61Ik4w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 494D185651F
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 21:06:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B6A994060E1;
        Thu,  7 Sep 2023 21:06:08 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/2] tests/shell: honor .nodump file for tests without nft dumps
Date:   Thu,  7 Sep 2023 23:05:54 +0200
Message-ID: <20230907210558.2410789-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For many tests, the dump is not stable or useful to test. Those tests
don't have a .nft file in the dumps directory, and don't have it
checked.

DUMPGEN=y generates a new dump file, if the "dumps/" directory exists.
Omitting that directory is a way to prevent the generation of the file.
However, many such tests share their directory with tests that do have dumps.

When running tests with DUMPGEN=y, a lot of new files get generated.
Those files are not meant to be compared or committed to git.

Whether a test has a dump file, is part of the test. The absence of the
dump file should also be indicated and committed to git.

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
index 43b3aa09ef26..006ead554aeb 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -49,6 +49,7 @@ read tainted_after < /proc/sys/kernel/tainted
 
 DUMPPATH="$TESTDIR/dumps"
 DUMPFILE="$DUMPPATH/$TESTBASE.nft"
+NODUMPFILE="$DUMPPATH/$TESTBASE.nodump"
 
 dump_written=
 rc_dump=
@@ -60,9 +61,14 @@ rc_dump=
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

