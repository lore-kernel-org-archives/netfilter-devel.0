Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5384CA5507
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 08:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbjIMIXX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 04:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjIMIXX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 04:23:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 35EBAC3
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 01:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694593352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vrlh/YxwL4qiGQ6lfuKLN/b0nM1fE6wl0FdIpD0QpFM=;
        b=dj7s5Wlh5aYuKu7z1+DGlOLZAb+wYi0wcHL6nsoKRA0n8KpApkSKPgj+Pzrur3UQrOVTXK
        Ekww/TQJaH4ffBcjr7CJiFZnKqZ3cP+jaKbMu9hadQY9s5Og3dqZ84oWkxvytHwGzynBS5
        OoKDtStYJTy0WEkZwTBxHm4gUwUhol0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-bp_E2AVOPq6nHu8camAUCw-1; Wed, 13 Sep 2023 04:22:30 -0400
X-MC-Unique: bp_E2AVOPq6nHu8camAUCw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33B028B7486
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 08:22:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A73627B62;
        Wed, 13 Sep 2023 08:22:29 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/3] tests/shell: export NFT_TEST_RANDOM_SEED variable for tests
Date:   Wed, 13 Sep 2023 10:20:23 +0200
Message-ID: <20230913082217.2711665-2-thaller@redhat.com>
In-Reply-To: <20230913082217.2711665-1-thaller@redhat.com>
References: <20230913082217.2711665-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Let "run-tests.sh" export a NFT_TEST_RANDOM_SEED variable, set to
a decimal, random integer (in the range of 0 to 0x7FFFFFFF).

The purpose is to provide a seed to tests for randomization.
Randomizing tests is very useful to increase the coverage while not
testing all combinations (which might not be practical).

The point of NFT_TEST_RANDOM_SEED is that the user can set the
environment variable so that the same series of random events is used.
That is useful for reproducing an issue, that is known to happen with a
certain seed.

- by default, if the user leaves NFT_TEST_RANDOM_SEED unset or empty,
  the script generates a number using $SRANDOM.
- if the user sets NFT_TEST_RANDOM_SEED to an integer it is taken
  as is (modulo 0x80000000).
- otherwise, calculate a number by hashing the value of
  $NFT_TEST_RANDOM_SEED.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 46 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index f20a2bec9e9b..2acea85e7836 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -21,6 +21,31 @@ array_contains() {
 	return 1
 }
 
+strtonum() {
+	local s="$1"
+	local n
+	local n2
+
+	re='^[[:space:]]*([0-9]+)[[:space:]]*$'
+	if [[ "$s" =~ $re ]] ; then
+		n="${BASH_REMATCH[1]}"
+		if [ "$(( n + 0 ))" = "$n" ] ; then
+			echo "$n"
+			return 0
+		fi
+	fi
+	re='^[[:space:]]*0x([0-9a-fA-F]+)[[:space:]]*$'
+	if [[ "$s" =~ $re ]] ; then
+		n="${BASH_REMATCH[1]}"
+		n2="$(( 16#$n + 0 ))"
+		if [ "$n2" = "$(printf '%d' "0x$n" 2>/dev/null)" ] ; then
+			echo "$n2"
+			return 0
+		fi
+	fi
+	return 1
+}
+
 _msg() {
 	local level="$1"
 	shift
@@ -170,6 +195,9 @@ usage() {
 	echo "                 Setting this to \"0\" means also to perform global cleanups between tests (remove"
 	echo "                 kernel modules)."
 	echo "                 Parallel jobs requires unshare and are disabled with NFT_TEST_UNSHARE_CMD=\"\"."
+	echo " NFT_TEST_RANDOM_SEED=<SEED>: The test runner will export the environment variable NFT_TEST_RANDOM_SEED"
+	echo "                 set to a random number. This can be used as a stable seed for tests to randomize behavior."
+	echo "                 Set this to a fixed value to get reproducible behavior."
 	echo " TMPDIR=<PATH> : select a different base directory for the result data."
 	echo
 	echo " NFT_TEST_HAVE_<FEATURE>=*|y: Some tests requires certain features or will be skipped."
@@ -209,9 +237,26 @@ KMEMLEAK="$(bool_y "$KMEMLEAK")"
 NFT_TEST_KEEP_LOGS="$(bool_y "$NFT_TEST_KEEP_LOGS")"
 NFT_TEST_HAS_REALROOT="$NFT_TEST_HAS_REALROOT"
 NFT_TEST_JOBS="${NFT_TEST_JOBS:-$_NFT_TEST_JOBS_DEFAULT}"
+NFT_TEST_RANDOM_SEED="$NFT_TEST_RANDOM_SEED"
 NFT_TEST_SKIP_slow="$(bool_y "$NFT_TEST_SKIP_slow")"
 DO_LIST_TESTS=
 
+if [ -z "$NFT_TEST_RANDOM_SEED" ] ; then
+	# Choose a random value.
+	n="$SRANDOM"
+else
+	# Parse as number.
+	n="$(strtonum "$NFT_TEST_RANDOM_SEED")"
+	if [ -z "$n" ] ; then
+		# If not a number, pick a hash based on the SHA-sum of the seed.
+		n="$(printf "%d" "0x$(sha256sum <<<"NFT_TEST_RANDOM_SEED:$NFT_TEST_RANDOM_SEED" | sed -n '1 { s/^\(........\).*/\1/p }')")"
+	fi
+fi
+# Limit a 31 bit decimal so tests can rely on this being in a certain
+# restricted form.
+NFT_TEST_RANDOM_SEED="$(( $n % 0x80000000 ))"
+export NFT_TEST_RANDOM_SEED
+
 TESTS=()
 
 while [ $# -gt 0 ] ; do
@@ -450,6 +495,7 @@ msg_info "conf: NFT_TEST_HAS_UNSHARED=$(printf '%q' "$NFT_TEST_HAS_UNSHARED")"
 msg_info "conf: NFT_TEST_HAS_UNSHARED_MOUNT=$(printf '%q' "$NFT_TEST_HAS_UNSHARED_MOUNT")"
 msg_info "conf: NFT_TEST_KEEP_LOGS=$(printf '%q' "$NFT_TEST_KEEP_LOGS")"
 msg_info "conf: NFT_TEST_JOBS=$NFT_TEST_JOBS"
+msg_info "conf: NFT_TEST_RANDOM_SEED=$NFT_TEST_RANDOM_SEED"
 msg_info "conf: TMPDIR=$(printf '%q' "$_TMPDIR")"
 echo
 for KEY in $(compgen -v | grep '^NFT_TEST_SKIP_' | sort) ; do
-- 
2.41.0

