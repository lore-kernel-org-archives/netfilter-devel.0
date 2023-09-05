Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3AFCA0FF8
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352193AbjIEQ0e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354501AbjIEMCE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 08:02:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076FECE2
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 05:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693915203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zhnViBuGWx3LAqrXutkWvOSw7bk8Y4kWWb2sq31n6wk=;
        b=VOuUrQWj9FjtD/rKSHPibJN5HMKEbIfkkUc96Mv5WsZZMq26NJJKu9SnEhldLfk4GD+mVU
        2HcBxhW7hoQCG5s91cBw/m+uAgjIVfKF3UW08kqYosPdh6nLBmfn4Q2KaKa3KugQzm/MEk
        b9R4xBUwKR7yvyoPRfTpvEAhh2WUS/Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-O3Salw_tNH-fWkU7x6ehaA-1; Tue, 05 Sep 2023 07:59:59 -0400
X-MC-Unique: O3Salw_tNH-fWkU7x6ehaA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EE6F944BE2
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 11:59:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F38761121314;
        Tue,  5 Sep 2023 11:59:58 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v4 16/17] tests/shell: record the test duration for investigation
Date:   Tue,  5 Sep 2023 13:58:45 +0200
Message-ID: <20230905115936.607599-17-thaller@redhat.com>
In-Reply-To: <20230905115936.607599-1-thaller@redhat.com>
References: <20230905115936.607599-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Runtimes are important. Add a way to find out how long tests took.

  $ ./tests/shell/run-tests.sh -j
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
 tests/shell/helpers/test-wrapper.sh | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index 58cf48172fc0..f8aed3241aea 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -9,6 +9,8 @@ TEST="$1"
 TESTBASE="$(basename "$TEST")"
 TESTDIR="$(dirname "$TEST")"
 
+START_TIME="$(cut -d ' ' -f1 /proc/uptime)"
+
 CLEANUP_UMOUNT_RUN_NETNS=n
 
 cleanup() {
@@ -99,4 +101,9 @@ else
 	fi
 fi
 
+END_TIME="$(cut -d ' ' -f1 /proc/uptime)"
+WALL_TIME="$(awk -v start="$START_TIME" -v end="$END_TIME" "BEGIN { print(end - start) }")" ||
+  WALL_TIME="$(echo "scale=4; $END_TIME - $START_TIME" | bc)"
+printf "%s\n" "$WALL_TIME" "$START_TIME" "$END_TIME" > "$NFT_TEST_TESTTMPDIR/times"
+
 exit "$rc_exit"
-- 
2.41.0

