Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 642A2CA5505
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 08:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238518AbjIMIXY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 04:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjIMIXY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 04:23:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A569510E6
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 01:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694593352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L0guPmZhsh5IGgA8+NH+OtFR/ps9U8+qkv9MUik5weA=;
        b=VHzH5eJqV19CPv+rTj0F+re0CjWfIfGM/ABjzNhVVnDLm85cP+5C6HFAz7Ek+7WRUuYel3
        h+CvkEUCD6BNVMcK68jwWsam8Eo9c3T0fqW718h1rLNxzNJgz3R79bshlzggQV3QpdJujT
        eeg8iG4Xsr5o9Wu9KZakEWuOYdvnTuw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-sv9_7aRWO861S1T1dNa4BA-1; Wed, 13 Sep 2023 04:22:31 -0400
X-MC-Unique: sv9_7aRWO861S1T1dNa4BA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A2E08A12BB
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 08:22:31 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F23763F9D;
        Wed, 13 Sep 2023 08:22:30 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/3] tests/shell: add "random-source.sh" helper for random-source for sort/shuf
Date:   Wed, 13 Sep 2023 10:20:24 +0200
Message-ID: <20230913082217.2711665-3-thaller@redhat.com>
In-Reply-To: <20230913082217.2711665-1-thaller@redhat.com>
References: <20230913082217.2711665-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commands `sort` and `shuf` have a "--random-source" argument. That's
useful for generating stable, reproducible "random" output.

However, we want to do this based on a fixed seed, while the
"--random-source" expects a stream of randomness. Add a helper script
for that.

Also, use the stable randomness for shuf in the test
"tests/shell/testcases/sets/automerge_0".

See-also: https://www.gnu.org/software/coreutils/manual/html_node/Random-sources.html#Random-sources

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/random-source.sh   | 40 ++++++++++++++++++++++++++
 tests/shell/testcases/sets/automerge_0 |  2 +-
 2 files changed, 41 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/helpers/random-source.sh

diff --git a/tests/shell/helpers/random-source.sh b/tests/shell/helpers/random-source.sh
new file mode 100755
index 000000000000..91a8248bea1f
--- /dev/null
+++ b/tests/shell/helpers/random-source.sh
@@ -0,0 +1,40 @@
+#!/bin/bash
+
+# Commands like `sort` and `shuf` have a "--random-source" argument, for
+# generating a stable, reproducible output. However, they require an input
+# that provides sufficiently many bytes (depending on the input).
+#
+# This script generates a stream that can be used like
+#
+#     shuf --random-source=<($0 "$seed")
+
+seed=""
+for a; do
+	seed="$seed${#a}:$a\n"
+done
+
+if command -v openssl &>/dev/null ; then
+	# We have openssl. Use it.
+	# https://www.gnu.org/software/coreutils/manual/html_node/Random-sources.html#Random-sources
+	#
+	# Note that we don't care that different installations/architectures generate the
+	# same output.
+	openssl enc -aes-256-ctr -pass "pass:$seed" -nosalt </dev/zero 2>/dev/null
+else
+	# Hack something. It's much slower.
+	idx=0
+	while : ; do
+		idx="$((idx++))"
+		seed="$(sha256sum <<<"$idx.$seed")"
+		echo ">>>$seed" >> a
+		seed="${seed%% *}"
+		LANG=C awk -v s="$seed" 'BEGIN{
+			for (i=1; i <= length(s); i+=2) {
+				xchar = substr(s, i, 2);
+				decnum = strtonum("0x"xchar);
+				printf("%c", decnum);
+			}
+		}' || break
+	done
+fi
+exit 0
diff --git a/tests/shell/testcases/sets/automerge_0 b/tests/shell/testcases/sets/automerge_0
index 170c38651de0..1dbac0b7cdbd 100755
--- a/tests/shell/testcases/sets/automerge_0
+++ b/tests/shell/testcases/sets/automerge_0
@@ -44,7 +44,7 @@ do
 done
 
 tmpfile3=$(mktemp)
-shuf $tmpfile2 > $tmpfile3
+shuf "$tmpfile2" --random-source=<("$NFT_TEST_BASEDIR/helpers/random-source.sh" "automerge-shuf-tmpfile2" "$NFT_TEST_RANDOM_SEED") > "$tmpfile3"
 i=0
 cat $tmpfile3 | while read line && [ $i -lt 10 ]
 do
-- 
2.41.0

