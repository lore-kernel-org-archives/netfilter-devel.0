Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5CDCD13DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 10:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241269AbjIRKcA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241267AbjIRKbl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 06:31:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A29D12B
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 03:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695033011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qfVc2Q0kQh6Y/uyPLeV2GMsRmnZ0Z+6OrrqpzPxRpm0=;
        b=PxO0EEq7znwqiJJGPH1GsT2D972hLfSj/yRhmiz+gDTUOabgOGkryxctShhrleDIU8JaWj
        J+keY2lPuGBXtG/r30nXUupapaiMO1/xBPZMU+4R293hSt1iRqCp3TCzjZumNkb40+JBNB
        hpBjNjJ61kvxSeemNyqtPY+Y+B/HbhQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-681-U2NJqf9JMgK23ljBQ7Vmcg-1; Mon, 18 Sep 2023 06:30:09 -0400
X-MC-Unique: U2NJqf9JMgK23ljBQ7Vmcg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13887811E7D;
        Mon, 18 Sep 2023 10:30:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 66C99C15BB8;
        Mon, 18 Sep 2023 10:30:08 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 12/14] tests/shell: skip reset tests if kernel lacks support
Date:   Mon, 18 Sep 2023 12:28:26 +0200
Message-ID: <20230918102947.2125883-13-thaller@redhat.com>
In-Reply-To: <20230918102947.2125883-1-thaller@redhat.com>
References: <20230918102947.2125883-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

reset is implemented via flush + extra attribute, so older kernels
perform a flush.  This means .nft doesn't work, we need to check
if the individual set contents/sets are still in place post-reset.

Make this generic and permit use of feat.sh in addition to the simpler
foo.nft feature files.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/features/reset_rule.sh            |  8 ++++++
 tests/shell/features/reset_set.sh             | 10 ++++++++
 tests/shell/run-tests.sh                      | 25 ++++++++++++++++---
 .../testcases/rule_management/0011reset_0     |  2 ++
 tests/shell/testcases/sets/reset_command_0    |  2 ++
 5 files changed, 43 insertions(+), 4 deletions(-)
 create mode 100755 tests/shell/features/reset_rule.sh
 create mode 100755 tests/shell/features/reset_set.sh

diff --git a/tests/shell/features/reset_rule.sh b/tests/shell/features/reset_rule.sh
new file mode 100755
index 000000000000..567ee2f1a4bd
--- /dev/null
+++ b/tests/shell/features/reset_rule.sh
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+# 8daa8fde3fc3 ("netfilter: nf_tables: Introduce NFT_MSG_GETRULE_RESET")
+# v6.2-rc1~99^2~210^2~2
+
+unshare -n bash -c "$NFT \"add table t; add chain t c ; add rule t c counter packets 1 bytes 42\"; \
+$NFT reset rules chain t c ; \
+$NFT reset rules chain t c |grep counter\ packets\ 0\ bytes\ 0"
diff --git a/tests/shell/features/reset_set.sh b/tests/shell/features/reset_set.sh
new file mode 100755
index 000000000000..3d034175d82a
--- /dev/null
+++ b/tests/shell/features/reset_set.sh
@@ -0,0 +1,10 @@
+#!/bin/bash
+
+# 079cd633219d ("netfilter: nf_tables: Introduce NFT_MSG_GETSETELEM_RESET")
+# v6.5-rc1~163^2~9^2~1
+
+unshare -n bash -c "$NFT add table t; \
+ $NFT add set t s { type ipv4_addr\; counter\; elements = { 127.0.0.1 counter packets 1 bytes 2 } } ; \
+ $NFT reset set t s ; \
+ $NFT reset set t s | grep counter\ packets\ 0\ bytes\ 0
+"
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index d11b4a63b6d1..9c7e280e31c7 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -224,13 +224,13 @@ export NFT_TEST_BASEDIR
 _HAVE_OPTS=( json )
 _HAVE_OPTS_NFT=()
 shopt -s nullglob
-F=( "$NFT_TEST_BASEDIR/features/"*.nft )
+F=( "$NFT_TEST_BASEDIR/features/"*.nft "$NFT_TEST_BASEDIR/features/"*.sh )
 shopt -u nullglob
 for file in "${F[@]}"; do
 	feat="${file##*/}"
-	feat="${feat%.nft}"
+	feat="${feat%.*}"
 	re="^[a-z_0-9]+$"
-	if [[ "$feat" =~ $re ]] && ! array_contains "$feat" "${_HAVE_OPTS[@]}" ; then
+	if [[ "$feat" =~ $re ]] && ! array_contains "$feat" "${_HAVE_OPTS[@]}" "${_HAVE_OPTS_NFT[@]}" && [[ "$file" != *.sh || -x "$file" ]] ; then
 		_HAVE_OPTS_NFT+=( "$feat" )
 	else
 		msg_warn "Ignore feature file \"$file\""
@@ -494,11 +494,28 @@ else
 fi
 export NFT_TEST_HAVE_json
 
+feature_probe()
+{
+	local with_path="$NFT_TEST_BASEDIR/features/$1"
+
+	if [ -r "$with_path.nft" ] ; then
+		$NFT_TEST_UNSHARE_CMD "$NFT_REAL" --check -f "$with_path.nft" &>/dev/null
+		return $?
+	fi
+
+	if [ -x "$with_path.sh" ] ; then
+		NFT="$NFT_REAL" $NFT_TEST_UNSHARE_CMD "$with_path.sh" &>/dev/null
+		return $?
+	fi
+
+	return 1
+}
+
 for feat in "${_HAVE_OPTS_NFT[@]}" ; do
 	var="NFT_TEST_HAVE_$feat"
 	if [ -z "${!var+x}" ] ; then
 		val='y'
-		$NFT_TEST_UNSHARE_CMD "$NFT_REAL" --check -f "$NFT_TEST_BASEDIR/features/$feat.nft" &>/dev/null || val='n'
+		feature_probe "$feat" || val='n'
 	else
 		val="$(bool_n "${!var}")"
 	fi
diff --git a/tests/shell/testcases/rule_management/0011reset_0 b/tests/shell/testcases/rule_management/0011reset_0
index 8d2307964c37..33eadd9eb562 100755
--- a/tests/shell/testcases/rule_management/0011reset_0
+++ b/tests/shell/testcases/rule_management/0011reset_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_reset_rule)
+
 set -e
 
 echo "loading ruleset"
diff --git a/tests/shell/testcases/sets/reset_command_0 b/tests/shell/testcases/sets/reset_command_0
index ad2e16a7d274..5e769fe66d68 100755
--- a/tests/shell/testcases/sets/reset_command_0
+++ b/tests/shell/testcases/sets/reset_command_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_reset_set)
+
 set -e
 
 trap '[[ $? -eq 0 ]] || echo FAIL' EXIT
-- 
2.41.0

