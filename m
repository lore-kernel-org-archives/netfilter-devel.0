Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD818EED617
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Sep 2023 15:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbjIOPgp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Sep 2023 11:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236215AbjIOPgY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Sep 2023 11:36:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA362F3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Sep 2023 08:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694792132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZqK4QoDgrnH08QDyRDKLcZWMQbcBSvi9lL0om1cbwoA=;
        b=ITt4YkD/IVt2efWBzIAaEvY5nZW4F1VKOVDSTDjt3rx18P6vzo/jJGxca3uKS0CdZMCQWL
        XaUXhHCayEgO0cqdD/e7PPXBJEh2q7ZeYDBQuauVw2ISX4exaScT8va93czUba9fMtlDfx
        70hFwfnEqMtopkk1sIspZ2YIBkeu60Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-2dnLsgvTPzOUcwuLmyZx_g-1; Fri, 15 Sep 2023 11:35:29 -0400
X-MC-Unique: 2dnLsgvTPzOUcwuLmyZx_g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A804D18175A1;
        Fri, 15 Sep 2023 15:35:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AB7982026D4B;
        Fri, 15 Sep 2023 15:35:26 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] tests/shell: add feature probing via "features/*.nft" files
Date:   Fri, 15 Sep 2023 17:32:35 +0200
Message-ID: <20230915153515.1315886-2-thaller@redhat.com>
In-Reply-To: <20230915153515.1315886-1-thaller@redhat.com>
References: <20230915153515.1315886-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Running selftests on older kernels makes some of them fail very early
because some tests use features that are not available on older kernels,
e.g. -stable releases.

Known examples:
- inner header matching
- anonymous chains
- elem delete from packet path

Also, some test cases might fail because a feature isn't compiled in,
such as netdev chains.

This adds a feature-probing mechanism to shell tests.

Simply drop a 'nft -f' compatible file with a .nft suffix into
"tests/shell/features". "run-tests.sh" will load it via `nft --check`
and will export

  NFT_TEST_HAVE_${feature}=y|n

Here ${feature} is the basename of the .nft file without file extension.
It must be all lower-case.

This extends the existing NFT_TEST_HAVE_json= feature detection.
Similarly, NFT_TEST_REQUIRES(NFT_TEST_HAVE_*) tags work to easily skip a
test.

The test script that cannot fully work without the feature should either
skip the test entirely (NFT_TEST_REQUIRES(NFT_TEST_HAVE_*)), or run a
reduced/modified test. If a modified test was run and passes, it is
still a good idea to mark the overall result as skipped (exit 77)
instead of claiming success to the modified test. We want to know when
not the full test was running, while we want to test as much as we can.

This patch is based on Florian's feature probing patch.

Originally-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Thomas Haller <thaller@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/run-tests.sh | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index c5d6307d067e..01a312d0ee2c 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -222,6 +222,23 @@ NFT_TEST_BASEDIR="$(dirname "$0")"
 export NFT_TEST_BASEDIR
 
 _HAVE_OPTS=( json )
+_HAVE_OPTS_NFT=()
+shopt -s nullglob
+F=( "$NFT_TEST_BASEDIR/features/"*.nft )
+shopt -u nullglob
+for file in "${F[@]}"; do
+	feat="${file##*/}"
+	feat="${feat%.nft}"
+	re="^[a-z_0-9]+$"
+	if [[ "$feat" =~ $re ]] && ! array_contains "$feat" "${_HAVE_OPTS[@]}" ; then
+		_HAVE_OPTS_NFT+=( "$feat" )
+	else
+		msg_warn "Ignore feature file \"$file\""
+	fi
+done
+_HAVE_OPTS+=( "${_HAVE_OPTS_NFT[@]}" )
+_HAVE_OPTS=( $(printf '%s\n' "${_HAVE_OPTS[@]}" | LANG=C sort) )
+
 for KEY in $(compgen -v | grep '^NFT_TEST_HAVE_' | sort) ; do
 	if ! array_contains "${KEY#NFT_TEST_HAVE_}" "${_HAVE_OPTS[@]}" ; then
 		unset "$KEY"
@@ -477,6 +494,17 @@ else
 fi
 export NFT_TEST_HAVE_json
 
+for feat in "${_HAVE_OPTS_NFT[@]}" ; do
+	var="NFT_TEST_HAVE_$feat"
+	if [ -z "${!var+x}" ] ; then
+		val='y'
+		$NFT_TEST_UNSHARE_CMD "$NFT_REAL" --check -f "$NFT_TEST_BASEDIR/features/$feat.nft" &>/dev/null || val='n'
+	else
+		val="$(bool_n "${!var}")"
+	fi
+	eval "export $var=$val"
+done
+
 if [ "$NFT_TEST_JOBS" -eq 0 ] ; then
 	MODPROBE="$(which modprobe)"
 	if [ ! -x "$MODPROBE" ] ; then
-- 
2.41.0

