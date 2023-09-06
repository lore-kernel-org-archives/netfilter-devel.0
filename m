Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00302EB8FBB
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbjIFMCy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237430AbjIFMCx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:02:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8BC1730
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FU5lcnGKE/11VMSsLNK8M7Sv5WfamoBd60eXs5+hK98=;
        b=hTMHmtqT97vsgfO4LPsqYmajruaJMS8GXTtwWtb+ZsNIC8YOfgJadXTqfpMixpxsChBu4N
        aEqUl9IQUuqveoXEuj3wBHY0g1W/VjpZIhREpbKclBtx4dzBZgEsJXmY+xIKDlth8oRUmg
        qHd32eKCPywHVOsRTLhwf9noJOI0YjE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-b--kIhGZN6KKA5wXTqxleg-1; Wed, 06 Sep 2023 08:01:33 -0400
X-MC-Unique: b--kIhGZN6KKA5wXTqxleg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B8D28AA802
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:33 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF38CC15BB8;
        Wed,  6 Sep 2023 12:01:32 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 17/19] tests/shell: record the test duration (wall time) in the result data
Date:   Wed,  6 Sep 2023 13:52:20 +0200
Message-ID: <20230906120109.1773860-18-thaller@redhat.com>
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Runtimes are important. Add a way to find out how long tests took.

  $ ./tests/shell/run-tests.sh
  ...
  $ for d in /tmp/nft-test.latest.*/test-*/ ; do \
         printf '%10.2f  %s\n' \
                "$(sed '1!d' "$d/times")" \
                "$(cat "$d/name")" ; \
    done \
    | sort -n \
    | awk '{print $0; s+=$1} END{printf("%10.2f\n", s)}'

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index b8a54ed7444d..e745df85a08d 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -9,6 +9,8 @@ TEST="$1"
 TESTBASE="$(basename "$TEST")"
 TESTDIR="$(dirname "$TEST")"
 
+START_TIME="$(cut -d ' ' -f1 /proc/uptime)"
+
 CLEANUP_UMOUNT_RUN_NETNS=n
 
 cleanup() {
@@ -99,4 +101,8 @@ else
 	fi
 fi
 
+END_TIME="$(cut -d ' ' -f1 /proc/uptime)"
+WALL_TIME="$(awk -v start="$START_TIME" -v end="$END_TIME" "BEGIN { print(end - start) }")"
+printf "%s\n" "$WALL_TIME" "$START_TIME" "$END_TIME" > "$NFT_TEST_TESTTMPDIR/times"
+
 exit "$rc_exit"
-- 
2.41.0

