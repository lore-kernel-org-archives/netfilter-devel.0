Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D01C61D9C
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 11:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjKVLUE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 06:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343629AbjKVLUE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 06:20:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75291D8
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 03:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1700651999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=J9j5TsOkmTevUVrAFF1VTMVkS7r+bweavw2KFPi81sI=;
        b=hQYUuEe0OBvI6z2WQOIJfGqp7brXbnhj0yTu1mL3E4BdBc2oIaocKcrLAvHvKn6aEi8pyk
        bx8ByfvVDGVaOzJZZA1FJNjIexwSWbsaUXEasFnJ55FcRYX5OeWbAmMY/dr0zPlQq1+GQR
        gXDAVQ83HLtD2ykGEpS4mKVTwik0XfM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-148-JvOxAVJkMK2CDn9hcymsAA-1; Wed,
 22 Nov 2023 06:19:58 -0500
X-MC-Unique: JvOxAVJkMK2CDn9hcymsAA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5B9C3C027A0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 11:19:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C4AC2026D4C;
        Wed, 22 Nov 2023 11:19:56 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/1] tests: prettify JSON in test output and add helper
Date:   Wed, 22 Nov 2023 12:19:40 +0100
Message-ID: <20231122111946.439474-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- add helper script "json-pretty.sh" for prettify/format JSON.
  It uses either `jq` or a `python` fallback. In my tests, they
  produce the same output, but the output is not guaranteed to be
  stable. This is mainly for informational purpose.

- add a "json-diff-pretty.sh" which prettifies two JSON inputs and
  shows a diff of them.

- in "test-wrapper.sh", after the check for a .json-nft dump fails, also
  call "json-diff-pretty.sh" and write the output to "ruleset-diff.json.pretty".
  This is beside "ruleset-diff.json", which contains the original diff.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/json-diff-pretty.sh | 17 +++++++++++++++++
 tests/shell/helpers/json-pretty.sh      | 17 +++++++++++++++++
 tests/shell/helpers/test-wrapper.sh     |  4 ++++
 3 files changed, 38 insertions(+)
 create mode 100755 tests/shell/helpers/json-diff-pretty.sh
 create mode 100755 tests/shell/helpers/json-pretty.sh

diff --git a/tests/shell/helpers/json-diff-pretty.sh b/tests/shell/helpers/json-diff-pretty.sh
new file mode 100755
index 000000000000..bebb7e8ed006
--- /dev/null
+++ b/tests/shell/helpers/json-diff-pretty.sh
@@ -0,0 +1,17 @@
+#!/bin/bash -e
+
+BASEDIR="$(dirname "$0")"
+
+[ $# -eq 2 ] || (echo "$0: expects two JSON files as arguments" ; exit 1)
+
+FILE1="$1"
+FILE2="$2"
+
+pretty()
+{
+	"$BASEDIR/json-pretty.sh" < "$1" 2>&1 || :
+}
+
+echo "Cmd: \"$0\" \"$FILE1\" \"$FILE2\""
+diff -u "$FILE1" "$FILE2" 2>&1 || :
+diff -u <(pretty "$FILE1") <(pretty "$FILE2") 2>&1 || :
diff --git a/tests/shell/helpers/json-pretty.sh b/tests/shell/helpers/json-pretty.sh
new file mode 100755
index 000000000000..0d6972b81e2f
--- /dev/null
+++ b/tests/shell/helpers/json-pretty.sh
@@ -0,0 +1,17 @@
+#!/bin/bash -e
+
+# WARNING: the output is not guaranteed to be stable.
+
+if command -v jq &>/dev/null ; then
+	# If we have, use `jq`
+	exec jq
+fi
+
+# Fallback to python.
+exec python -c '
+import json
+import sys
+
+parsed = json.load(sys.stdin)
+print(json.dumps(parsed, indent=2))
+'
diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index 9e8e60581890..4ffc48184dd7 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -202,6 +202,10 @@ if [ "$rc_test" -ne 77 -a "$dump_written" != y ] ; then
 	fi
 	if [ "$NFT_TEST_HAVE_json" != n -a -f "$JDUMPFILE" ] ; then
 		if ! $DIFF -u "$JDUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after.json" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" ; then
+			"$NFT_TEST_BASEDIR/helpers/json-diff-pretty.sh" \
+				"$JDUMPFILE" \
+				"$NFT_TEST_TESTTMPDIR/ruleset-after.json" \
+				2>&1 > "$NFT_TEST_TESTTMPDIR/ruleset-diff.json.pretty"
 			show_file "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" "Failed \`$DIFF -u \"$JDUMPFILE\" \"$NFT_TEST_TESTTMPDIR/ruleset-after.json\"\`" >> "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
 			rc_dump=1
 		else
-- 
2.42.0

