Return-Path: <SRS0=cPjr=73=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DBAC433DF
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 21:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E4D7206B7
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 21:41:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jMMLVGFv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgFNVlw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Jun 2020 17:41:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50125 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726844AbgFNVlv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jun 2020 17:41:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592170910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XJXo3FUduBJc1TaWZTySo9WGlLuVzEj9LFgQgayAQIs=;
        b=jMMLVGFvvuEmKpVK3DE2uxsbhngxzxPz6y3HGhph96MOu3U8i7vIJ+ePwx6/Ucm7E4OAKh
        0PzXlHVLW65JRIJBseiJKsKA30M520YXM1RfHvpnPMpSwA0UQqfeXMvprFI+JZjTP+yQML
        dZzbW2AjfihoKOo01xxPZeyPYQWcuI0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-o2RfA6L6OKa8BZt2Wl-CIA-1; Sun, 14 Jun 2020 17:41:48 -0400
X-MC-Unique: o2RfA6L6OKa8BZt2Wl-CIA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7469F1845197;
        Sun, 14 Jun 2020 21:41:47 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9554A9CA0;
        Sun, 14 Jun 2020 21:41:46 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: Allow wrappers to be passed as nft command
Date:   Sun, 14 Jun 2020 23:41:37 +0200
Message-Id: <4e47c812a2cbe17159393d8d2667e28b3c0ba79d.1592170384.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The current check on $NFT only allows to directly pass an executable,
so I've been commenting it out locally for a while to run tests with
valgrind.

Instead of using the -x test, run nft without arguments and check the
exit status. POSIX.1-2017, Shell and Utilities volume, par. 2.8.2
("Exit Status for Commands") states:

  If a command is not found, the exit status shall be 127. If the
  command name is found, but it is not an executable utility, the
  exit status shall be 126. Applications that invoke utilities
  without using the shell should use these exit status values to
  report similar errors.

While this script isn't POSIX-compliant, it requires bash, and any
modern version of bash complies with those exit status requirements.
Also valgrind complies with this.

We need to quote the NFT variable passed to execute the commands in
the main loop and adjust error and informational messages, too.

This way, for example, export NFT="valgrind nft" can be issued to
run tests with valgrind.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 tests/shell/run-tests.sh | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 26f8f46d95a0..94115066b1bf 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -23,10 +23,12 @@ if [ "$(id -u)" != "0" ] ; then
 fi
 
 [ -z "$NFT" ] && NFT=$SRC_NFT
-if [ ! -x "$NFT" ] ; then
-	msg_error "no nft binary!"
+${NFT} > /dev/null 2>&1
+ret=$?
+if [ ${ret} -eq 126 ] || [ ${ret} -eq 127 ]; then
+	msg_error "cannot execute nft command: ${NFT}"
 else
-	msg_info "using nft binary $NFT"
+	msg_info "using nft command: ${NFT}"
 fi
 
 if [ ! -d "$TESTDIR" ] ; then
@@ -101,7 +103,7 @@ do
 	kernel_cleanup
 
 	msg_info "[EXECUTING]	$testfile"
-	test_output=$(NFT=$NFT DIFF=$DIFF ${testfile} 2>&1)
+	test_output=$(NFT="$NFT" DIFF=$DIFF ${testfile} 2>&1)
 	rc_got=$?
 	echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
 
-- 
2.27.0

