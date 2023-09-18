Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2D4CD13DE
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 10:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241248AbjIRKb7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241266AbjIRKbj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 06:31:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7063A130
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 03:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695033011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7sWuox1CGfK0LFguhjny4BCBqzWGUlaW5EJaUUjjcZw=;
        b=O6nPqORN4811lKUvphnCUnIRA38gUKgrKZGRJRPPvOkuZJk/FDT0N1aUGoLv6qhpqVmdEW
        scwUhczfXmeuXnPWGPIq6hF0MjkFy1FTIIO7ifM4mgoNCdHBVNGcFARsXYivyMi9TKjfDv
        0DvwNVVhq6pKcFenZm6HBIAjH9DuZSQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-FLREjoRWNWC18PmGtmE3AA-1; Mon, 18 Sep 2023 06:30:10 -0400
X-MC-Unique: FLREjoRWNWC18PmGtmE3AA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFB20811E86
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 10:30:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E199C15BB8;
        Mon, 18 Sep 2023 10:30:09 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 13/14] tests/shell: implement NFT_TEST_HAVE_json feature detection as script
Date:   Mon, 18 Sep 2023 12:28:27 +0200
Message-ID: <20230918102947.2125883-14-thaller@redhat.com>
In-Reply-To: <20230918102947.2125883-1-thaller@redhat.com>
References: <20230918102947.2125883-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No more need to special case the "run a script" approach for detecting
the json feature. Use the new mechanism instead.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/features/json.sh |  6 ++++++
 tests/shell/run-tests.sh     | 18 ++++--------------
 2 files changed, 10 insertions(+), 14 deletions(-)
 create mode 100755 tests/shell/features/json.sh

diff --git a/tests/shell/features/json.sh b/tests/shell/features/json.sh
new file mode 100755
index 000000000000..d81157020f51
--- /dev/null
+++ b/tests/shell/features/json.sh
@@ -0,0 +1,6 @@
+#!/bin/sh
+
+# Detect JSON support. Note that $NFT may not be the binary from our build
+# tree, hence we detect it by running the binary (instead of asking the build
+# configuration).
+$NFT -j list ruleset
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 9c7e280e31c7..528646f57eca 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -221,8 +221,7 @@ NFT_TEST_BASEDIR="$(dirname "$0")"
 # Export the base directory. It may be used by tests.
 export NFT_TEST_BASEDIR
 
-_HAVE_OPTS=( json )
-_HAVE_OPTS_NFT=()
+_HAVE_OPTS=()
 shopt -s nullglob
 F=( "$NFT_TEST_BASEDIR/features/"*.nft "$NFT_TEST_BASEDIR/features/"*.sh )
 shopt -u nullglob
@@ -230,13 +229,12 @@ for file in "${F[@]}"; do
 	feat="${file##*/}"
 	feat="${feat%.*}"
 	re="^[a-z_0-9]+$"
-	if [[ "$feat" =~ $re ]] && ! array_contains "$feat" "${_HAVE_OPTS[@]}" "${_HAVE_OPTS_NFT[@]}" && [[ "$file" != *.sh || -x "$file" ]] ; then
-		_HAVE_OPTS_NFT+=( "$feat" )
+	if [[ "$feat" =~ $re ]] && ! array_contains "$feat" "${_HAVE_OPTS[@]}" && [[ "$file" != *.sh || -x "$file" ]] ; then
+		_HAVE_OPTS+=( "$feat" )
 	else
 		msg_warn "Ignore feature file \"$file\""
 	fi
 done
-_HAVE_OPTS+=( "${_HAVE_OPTS_NFT[@]}" )
 _HAVE_OPTS=( $(printf '%s\n' "${_HAVE_OPTS[@]}" | LANG=C sort) )
 
 for KEY in $(compgen -v | grep '^NFT_TEST_HAVE_' | sort) ; do
@@ -486,14 +484,6 @@ fi
 
 NFT_REAL="${NFT_REAL-$NFT}"
 
-if [ -z "${NFT_TEST_HAVE_json+x}" ] ; then
-	NFT_TEST_HAVE_json=y
-	$NFT_TEST_UNSHARE_CMD "$NFT_REAL" -j list ruleset &>/dev/null || NFT_TEST_HAVE_json=n
-else
-	NFT_TEST_HAVE_json="$(bool_n "$NFT_TEST_HAVE_json")"
-fi
-export NFT_TEST_HAVE_json
-
 feature_probe()
 {
 	local with_path="$NFT_TEST_BASEDIR/features/$1"
@@ -511,7 +501,7 @@ feature_probe()
 	return 1
 }
 
-for feat in "${_HAVE_OPTS_NFT[@]}" ; do
+for feat in "${_HAVE_OPTS[@]}" ; do
 	var="NFT_TEST_HAVE_$feat"
 	if [ -z "${!var+x}" ] ; then
 		val='y'
-- 
2.41.0

