Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8B8C004C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Oct 2023 16:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbjJWQOc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 12:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjJWQOb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 12:14:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664B483
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 09:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698077622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QcMZLJpNqg71sGlHrmfYkFfSuAYi+0Yul2WJfZlhSIY=;
        b=C8OFdTXYIVYzEufnI58QIwDWtnFD1T8ODsM8JZmuFdxtvH6HNC3knONEN7Nx+FdMDzJN7W
        2sg2/pUGKIdpmEpuoWycH3gDhmZ8m2JerchZj+D8FBtrpOrsDYzLCCxh7BMLcM5NbxUCqQ
        YyM3B5Mb8i7GDZHLFHyup9aNAXSKmto=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-178-SJm-9SSpM3OoF6hpcZqxbQ-1; Mon,
 23 Oct 2023 12:13:31 -0400
X-MC-Unique: SJm-9SSpM3OoF6hpcZqxbQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04BF93826D2A
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 16:13:31 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.226])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 78EFA503B;
        Mon, 23 Oct 2023 16:13:30 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/2] tools: reject unexpected files in "tests/shell/testcases/" with "check-tree.sh"
Date:   Mon, 23 Oct 2023 18:13:16 +0200
Message-ID: <20231023161319.781725-2-thaller@redhat.com>
In-Reply-To: <20231023161319.781725-1-thaller@redhat.com>
References: <20231023161319.781725-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

"check-tree.sh" does consistency checks on the source tree. Extend
the check to flag more unexpected files. We don't want to accidentally
have left over files.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tools/check-tree.sh | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/check-tree.sh b/tools/check-tree.sh
index ede3e6998ecc..c3aaa08d05ce 100755
--- a/tools/check-tree.sh
+++ b/tools/check-tree.sh
@@ -2,6 +2,10 @@
 
 # Preform various consistency checks of the source tree.
 
+unset LANGUAGE
+export LANG=C
+export LC_ALL=C
+
 die() {
 	printf '%s\n' "$*"
 	exit 1
@@ -56,7 +60,7 @@ check_shell_dumps() {
 	fi
 }
 
-SHELL_TESTS=( $(find "tests/shell/testcases/" -type f -executable | LANG=C sort) )
+SHELL_TESTS=( $(find "tests/shell/testcases/" -type f -executable | sort) )
 
 if [ "${#SHELL_TESTS[@]}" -eq 0 ] ; then
 	echo "No executable tests under \"tests/shell/testcases/\" found"
@@ -74,9 +78,20 @@ if [ "${SHELL_TESTS[*]}" != "${SHELL_TESTS2[*]}" ] ; then
 	EXIT_CODE=1
 fi
 
+##############################################################################
+#
+F=( $(find tests/shell/testcases/ -type f | grep '^tests/shell/testcases/[^/]\+/dumps/[^/]\+\.\(nft\|nodump\)$' -v | sort) )
+IGNORED_FILES=( tests/shell/testcases/bogons/nft-f/* )
+for f in "${F[@]}" ; do
+	if ! array_contains "$f" "${SHELL_TESTS[@]}" "${IGNORED_FILES[@]}" ; then
+		echo "Unexpected file \"$f\""
+		EXIT_CODE=1
+	fi
+done
+
 ##############################################################################
 
-FILES=( $(find "tests/shell/testcases/" -type f | sed -n 's#\(tests/shell/testcases\(/.*\)\?/\)dumps/\(.*\)\.\(nft\|nodump\)$#\0#p' | LANG=C sort) )
+FILES=( $(find "tests/shell/testcases/" -type f | sed -n 's#\(tests/shell/testcases\(/.*\)\?/\)dumps/\(.*\)\.\(nft\|nodump\)$#\0#p' | sort) )
 
 for f in "${FILES[@]}" ; do
 	f2="$(echo "$f" | sed -n 's#\(tests/shell/testcases\(/.*\)\?/\)dumps/\(.*\)\.\(nft\|nodump\)$#\1\3#p')"
-- 
2.41.0

