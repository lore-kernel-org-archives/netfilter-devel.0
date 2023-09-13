Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A02EE01EC
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 17:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjIMRIM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 13:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbjIMRH4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 13:07:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27FE61BC8
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 10:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694624827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GZ0WlOIdM2xEB21EPnqcRujlXGR6GBVBR+FcFsDPQgE=;
        b=dF1SvN7CuA+7SkcO8YC5EnrKywfjSZ9sqC+JYuqMYIbQycz3Q+yPkEnQXRYeDkPV+7ZrSj
        yPO0F/IJ80y2ltHKf6fhewEDiGcVATrJj7kLxbKMrgOKC5Ge0xy/4BoiZyTg49sJcLNRoH
        nlYRPArlA+xFqkI9mL3wWdB+ZnWYsjU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-qSaPx4jdNc2rrxCDRod3WQ-1; Wed, 13 Sep 2023 13:07:05 -0400
X-MC-Unique: qSaPx4jdNc2rrxCDRod3WQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35BA480523C
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 17:07:05 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A82E940C6EA8;
        Wed, 13 Sep 2023 17:07:04 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 6/6] tools: add "tools/check-tree.sh" script to check consistency of nft dumps
Date:   Wed, 13 Sep 2023 19:05:09 +0200
Message-ID: <20230913170649.439394-7-thaller@redhat.com>
In-Reply-To: <20230913170649.439394-1-thaller@redhat.com>
References: <20230913170649.439394-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The script performs some checks on the source tree, and fails if
any problems are found.

Currently it only checks for the dumps files, but it shall be extended
to perform various consistency checks of the source tree.

This script was already successful at finding issues with the dumps.
Running it helps to make sure we don't make mistakes.

Later it should also integrate with `make check` and/or be called
from CI.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tools/check-tree.sh | 91 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)
 create mode 100755 tools/check-tree.sh

diff --git a/tools/check-tree.sh b/tools/check-tree.sh
new file mode 100755
index 000000000000..ede3e6998ecc
--- /dev/null
+++ b/tools/check-tree.sh
@@ -0,0 +1,91 @@
+#!/bin/bash -e
+
+# Preform various consistency checks of the source tree.
+
+die() {
+	printf '%s\n' "$*"
+	exit 1
+}
+
+array_contains() {
+	local needle="$1"
+	local a
+	shift
+	for a; do
+		[ "$a" = "$needle" ] && return 0
+	done
+	return 1
+}
+
+cd "$(dirname "$0")/.."
+
+EXIT_CODE=0
+
+##############################################################################
+
+check_shell_dumps() {
+	local TEST="$1"
+	local base="$(basename "$TEST")"
+	local dir="$(dirname "$TEST")"
+	local has_nft=0
+	local has_nodump=0
+	local nft_name
+	local nodump_name
+
+	if [ ! -d "$dir/dumps/" ] ; then
+		echo "\"$TEST\" has no \"$dir/dumps/\" directory"
+		EXIT_CODE=1
+		return 0
+	fi
+
+	nft_name="$dir/dumps/$base.nft"
+	nodump_name="$dir/dumps/$base.nodump"
+
+	[ -f "$nft_name" ] && has_nft=1
+	[ -f "$nodump_name" ] && has_nodump=1
+
+	if [ "$has_nft" != 1 -a "$has_nodump" != 1 ] ; then
+		echo "\"$TEST\" has no \"$dir/dumps/$base.{nft,nodump}\" file"
+		EXIT_CODE=1
+	elif [ "$has_nft" == 1 -a "$has_nodump" == 1 ] ; then
+		echo "\"$TEST\" has both \"$dir/dumps/$base.{nft,nodump}\" files"
+		EXIT_CODE=1
+	elif [ "$has_nodump" == 1 -a -s "$nodump_name" ] ; then
+		echo "\"$TEST\" has a non-empty \"$dir/dumps/$base.nodump\" file"
+		EXIT_CODE=1
+	fi
+}
+
+SHELL_TESTS=( $(find "tests/shell/testcases/" -type f -executable | LANG=C sort) )
+
+if [ "${#SHELL_TESTS[@]}" -eq 0 ] ; then
+	echo "No executable tests under \"tests/shell/testcases/\" found"
+	EXIT_CODE=1
+fi
+for t in "${SHELL_TESTS[@]}" ; do
+	check_shell_dumps "$t"
+done
+
+##############################################################################
+
+SHELL_TESTS2=( $(./tests/shell/run-tests.sh --list-tests) )
+if [ "${SHELL_TESTS[*]}" != "${SHELL_TESTS2[*]}" ] ; then
+	echo "\`./tests/shell/run-tests.sh --list-tests\` does not list the expected tests"
+	EXIT_CODE=1
+fi
+
+##############################################################################
+
+FILES=( $(find "tests/shell/testcases/" -type f | sed -n 's#\(tests/shell/testcases\(/.*\)\?/\)dumps/\(.*\)\.\(nft\|nodump\)$#\0#p' | LANG=C sort) )
+
+for f in "${FILES[@]}" ; do
+	f2="$(echo "$f" | sed -n 's#\(tests/shell/testcases\(/.*\)\?/\)dumps/\(.*\)\.\(nft\|nodump\)$#\1\3#p')"
+	if ! array_contains "$f2" "${SHELL_TESTS[@]}" ; then
+		echo "\"$f\" has no test \"$f2\""
+		EXIT_CODE=1
+	fi
+done
+
+##############################################################################
+
+exit "$EXIT_CODE"
-- 
2.41.0

