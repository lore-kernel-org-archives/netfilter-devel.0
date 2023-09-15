Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFEBEED615
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Sep 2023 15:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbjIOP5d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Sep 2023 11:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236237AbjIOP5T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Sep 2023 11:57:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2B6610D9
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Sep 2023 08:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694793389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zi3JC7eBZw8Sh8+pYAQ3NW2PJjKOY44Tzx9FIXnd7sk=;
        b=SgqbTbAkL/bETVu9UnBFASuXWGR23dhn3B9m69KvMqKD8W9RYWp+3o3+zEICTUxn+jvUhi
        HYuLZ7KAj6t860jyaor9o3Ls9/ZklmEpPInFY3v4+2IXFxBxktpP7WQMTVdKGxcHfwt/y4
        G0DIh4DTJgiMpEnddGeu3l7Pb573FTs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-g4MQ1cYAP8elm0B4o-O2Ew-1; Fri, 15 Sep 2023 11:56:28 -0400
X-MC-Unique: g4MQ1cYAP8elm0B4o-O2Ew-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E0C8949A2A
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Sep 2023 15:56:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A0C3940C2070;
        Fri, 15 Sep 2023 15:56:27 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/3] tests/shell: skip "sets/reset_command_0" on unsupported reset command
Date:   Fri, 15 Sep 2023 17:54:01 +0200
Message-ID: <20230915155614.1325657-3-thaller@redhat.com>
In-Reply-To: <20230915155614.1325657-1-thaller@redhat.com>
References: <20230915155614.1325657-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The NFT_MSG_GETSETELEM_RESET command was only added to kernel
v6.4-rc3-764-g079cd633219d. Also, it doesn't work on Fedora 38
(6.4.14-200.fc38.x86_64), although that would appear to have the
feature. On CentOS-Stream-9 (5.14.0-354.el9.x86_64) the test passes.

Note that this is not implemented via a re-usable feature detection.
Instead, we just in the middle of the test notice that it appears not to
work, and abort (skip).

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=079cd633219d7298d087cd115c17682264244c18

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/testcases/sets/reset_command_0 | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/tests/shell/testcases/sets/reset_command_0 b/tests/shell/testcases/sets/reset_command_0
index ad2e16a7d274..a0f5ca017b0f 100755
--- a/tests/shell/testcases/sets/reset_command_0
+++ b/tests/shell/testcases/sets/reset_command_0
@@ -2,7 +2,7 @@
 
 set -e
 
-trap '[[ $? -eq 0 ]] || echo FAIL' EXIT
+trap 'rc="$?"; [ "$rc" -ne 0 -a "$rc" -ne 77 ] && echo FAIL' EXIT
 
 RULESET="table t {
 	set s {
@@ -36,11 +36,21 @@ expires_minutes() {
 	sed -n 's/.*expires \([0-9]*\)m.*/\1/p'
 }
 
-echo -n "get set elem matches reset set elem: "
 elem='element t s { 1.0.0.1 . udp . 53 }'
-[[ $($NFT "get $elem ; reset $elem" | \
-	grep 'elements = ' | drop_seconds | uniq | wc -l) == 1 ]]
-echo OK
+
+rc=0
+OUT="$( $NFT "get $elem ; reset $elem" )" || rc=$?
+if [ "$rc" -ne 0 ] ; then
+	echo "Command \`nft \"get $elem ; reset $elem\"\` failed. Assume reset is not supported. SKIP"
+	exit 77
+fi
+
+[ "$(printf '%s\n' "$OUT" | \
+      grep 'elements = ' | \
+      drop_seconds | \
+      uniq | \
+      wc -l)" = 1 ] || die "Unexpected output getting elements: \`nft \"get $elem ; reset $elem\"\`"$'\nOutput\n>'"$OUT"'<'
+echo "get set elem matches reset set elem: OK"
 
 echo -n "counters and expiry are reset: "
 NEW=$($NFT "get $elem")
-- 
2.41.0

