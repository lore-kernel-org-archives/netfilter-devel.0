Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2BFDEE800F
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 14:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbjIHO06 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 10:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235721AbjIHO05 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 10:26:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5658A1BF9
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 07:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694183166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fBOE0hpIIkye1Wm5dE4ngeeozzEBhmZ276ANSEzSvNU=;
        b=OjE3F8ifFdgtMxXmfrtb8R5Pj2WjVatIOL1kay6Du2oQdfdK5BJq8NFTxKljJ1BZvaEFRp
        O+u7rZwGV1XFXLMb1iZCby3T4P16ohMEE5kvueKTYIUkmdLQRh3yIreMMlFUC8gIMp9PiF
        GmbxPg6c8m2Dg7VbY16KHL0JiXT37gs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-nYFz5ZWsOiGfXaNAAR5QQA-1; Fri, 08 Sep 2023 10:25:59 -0400
X-MC-Unique: nYFz5ZWsOiGfXaNAAR5QQA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 858C1811728
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 14:25:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F33F26B595;
        Fri,  8 Sep 2023 14:25:57 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/1] tests/shell: set valgrind's "--vgdb-prefix=" to orignal TMPDIR
Date:   Fri,  8 Sep 2023 16:25:31 +0200
Message-ID: <20230908142547.1143942-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

"test-wrapper.sh" sets TMPDIR="$NFT_TEST_TESTTMPDIR". That is useful, so
that temporary files of the tests are placed inside the test result
data.

Sometimes tests miss to delete those files, which would result in piling
up /tmp/tmp.XXXXXXXXXX files. By setting $TMPDIR, those files are
clearly related to the test run that created them, and can be deleted
together.

However, valgrind likes to create files like
"vgdb-pipe-from-vgdb-to-68-by-thom-on-???"  inside $TMPDIR. These are
pipes, so if you run `grep -R ^ /tmp/nft-test.latest` while
the test is still running (to inspect the results), then the process
hands reading from the pipe.

Instead, tell valgrind to put those files in the original TMPDIR. For
that purpose, export NFT_TEST_TMPDIR_ORIG from "run-tests.sh".

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/nft-valgrind-wrapper.sh | 1 +
 tests/shell/run-tests.sh                    | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/tests/shell/helpers/nft-valgrind-wrapper.sh b/tests/shell/helpers/nft-valgrind-wrapper.sh
index ad8cc74bc781..6125dd0f3089 100755
--- a/tests/shell/helpers/nft-valgrind-wrapper.sh
+++ b/tests/shell/helpers/nft-valgrind-wrapper.sh
@@ -12,6 +12,7 @@ libtool \
 		--show-leak-kinds=all \
 		--num-callers=100 \
 		--error-exitcode=122 \
+		--vgdb-prefix="$NFT_TEST_TMPDIR_ORIG/vgdb-pipe-nft-test-$SUFFIX" \
 		$NFT_TEST_VALGRIND_OPTS \
 		"$NFT_REAL" \
 		"$@" \
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index c622c1509500..5931b20e1645 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -257,6 +257,11 @@ START_TIME="$(cut -d ' ' -f1 /proc/uptime)"
 
 _TMPDIR="${TMPDIR:-/tmp}"
 
+# Export the orignal TMPDIR for the tests. "test-wrapper.sh" sets TMPDIR to
+# NFT_TEST_TESTTMPDIR, so that temporary files are placed along side the
+# test data. In some cases, we may want to know the original TMPDIR.
+export NFT_TEST_TMPDIR_ORIG="$_TMPDIR"
+
 if [ "$NFT_TEST_HAS_REALROOT" = "" ] ; then
 	# The caller didn't set NFT_TEST_HAS_REALROOT and didn't specify
 	# -R/--without-root option. Autodetect it based on `id -u`.
-- 
2.41.0

