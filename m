Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E867AEC875D
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 22:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240004AbjIGWKl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 18:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237290AbjIGWKl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 18:10:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CC51BDA
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 15:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694124534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j4aAUBnOj+3N9iemaB01OvKvoXA8L5ay7wQO+OpOSaI=;
        b=hz0ZlPeA3th+rw6ObH5dsYSH1UzcMPueQ/4MV+m2oNeKlAGB92Ghr4zIS9FVT+rgjPKxxz
        fcQK0XaoRRB2znA+K7PlN+ttKTmITbaKezn4cLihv7LZCUJWYc6QHhLKQrk6Sje8TGXo1P
        MMkWaokZcXamIs0qfrf2IGz51chH6jY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-CUWCZPTaMLWThMPEAIRGZw-1; Thu, 07 Sep 2023 18:08:52 -0400
X-MC-Unique: CUWCZPTaMLWThMPEAIRGZw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 938753C0EACC
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 22:08:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A06C7B62;
        Thu,  7 Sep 2023 22:08:51 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 10/11] tests/shell: record wall time of test run in result data
Date:   Fri,  8 Sep 2023 00:07:22 +0200
Message-ID: <20230907220833.2435010-11-thaller@redhat.com>
In-Reply-To: <20230907220833.2435010-1-thaller@redhat.com>
References: <20230907220833.2435010-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When running tests, it's useful to see how long it took. Keep track if
the timestamps in a "times" file.

Try:

    ( \
        for d in /tmp/nft-test.latest.*/test-*/ ; do \
               printf '%10.2f  %s\n' \
                      "$(sed '1!d' "$d/times")" \
                      "$(cat "$d/name")" ; \
        done \
        | sort -n \
        | awk '{print $0; s+=$1} END{printf("%10.2f\n", s)}' ; \
        printf '%10.2f wall time\n' "$(sed '1!d' /tmp/nft-test.latest.*/times)" \
    )

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index bb73a771dfdc..35621bac569d 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -249,6 +249,8 @@ if [ "$DO_LIST_TESTS" = y ] ; then
 	exit 0
 fi
 
+START_TIME="$(cut -d ' ' -f1 /proc/uptime)"
+
 _TMPDIR="${TMPDIR:-/tmp}"
 
 if [ "$NFT_TEST_HAS_REALROOT" = "" ] ; then
@@ -636,6 +638,20 @@ msg_info "${RR}results$RESET: [OK] $GREEN$ok$RESET [SKIPPED] $YELLOW$skipped$RES
 
 kernel_cleanup
 
+#    ( \
+#        for d in /tmp/nft-test.latest.*/test-*/ ; do \
+#               printf '%10.2f  %s\n' \
+#                      "$(sed '1!d' "$d/times")" \
+#                      "$(cat "$d/name")" ; \
+#        done \
+#        | sort -n \
+#        | awk '{print $0; s+=$1} END{printf("%10.2f\n", s)}' ; \
+#        printf '%10.2f wall time\n' "$(sed '1!d' /tmp/nft-test.latest.*/times)" \
+#    )
+END_TIME="$(cut -d ' ' -f1 /proc/uptime)"
+WALL_TIME="$(awk -v start="$START_TIME" -v end="$END_TIME" "BEGIN { print(end - start) }")"
+printf "%s\n" "$WALL_TIME" "$START_TIME" "$END_TIME" > "$NFT_TEST_TMPDIR/times"
+
 if [ "$failed" -gt 0 -o "$NFT_TEST_KEEP_LOGS" = y ] ; then
 	msg_info "check the temp directory \"$NFT_TEST_TMPDIR\" (\"$NFT_TEST_LATEST\")"
 	msg_info "   ls -lad \"$NFT_TEST_LATEST\"/*/*"
-- 
2.41.0

