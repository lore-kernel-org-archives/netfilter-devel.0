Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26598C61D97
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 18:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbjKVSWp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 13:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235092AbjKVSWo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 13:22:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0342A4
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 10:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1700677359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7+xcEdyMvYJcvBXsezeDsDK2W05GEXVXmo8cPMwW5C0=;
        b=ELID8zDoqgdpDnNwt5i7EwEA/RatXVceVGn0uei+BwXMHFXUBvCKMDmJsEJ8+iPj/ZqfbJ
        zz6qkrQm1JxJK3mAklbCHYvZU/RsMsGjsy9BNx+iRuwX7octgFvH6rNvpiFcKHxtNNZVWt
        ZMWKVIgeXfH21nStYA7vuCKiBZvhw5A=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-348-zD9wih1OOaGICz_W6mOXpQ-1; Wed,
 22 Nov 2023 13:22:38 -0500
X-MC-Unique: zD9wih1OOaGICz_W6mOXpQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32E603C1ACD3
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 18:22:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A9115492BE0;
        Wed, 22 Nov 2023 18:22:37 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/1] tests/shell: accept name of dump files in place of test names
Date:   Wed, 22 Nov 2023 19:22:25 +0100
Message-ID: <20231122182227.759051-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Imagine you have the filename of a dump file at hand. For example, because
it shows up in `git status` and you can copy it from the terminal.

If you want to run the corresponding test, that was cumbersome. It
involved editing the command line (removing the /dumps/ directory and
the file suffix).

Instead, let "run-tests.sh" do that automatically. There is little value
in bothering the user with a failure:

Before:

  $ ./tests/shell/run-tests.sh tests/shell/testcases/optionals/dumps/comments_table_0.json-nft -L
  E: Unknown test "tests/shell/testcases/optionals/dumps/comments_table_0.json-nft"

After:
  $ ./tests/shell/run-tests.sh tests/shell/testcases/optionals/dumps/comments_table_0.json-nft -L
  tests/shell/testcases/optionals/comments_table_0

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 3cde97b7ea17..c26142b7ff17 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -431,6 +431,19 @@ for t in "${TESTSOLD[@]}" ; do
 	elif [ -d "$t" ] ; then
 		TESTS+=( $(find_tests "$t") )
 	else
+		if [ -f "$t" ] ; then
+			# If the test name looks like a dumps file, autodetect
+			# the correct test name. It's not useful to bother the
+			# user with a failure in this case.
+			rx="^(.*/)?dumps/([^/]+)\\.(nodump|nft|json-nft)$"
+			if [[ "$t" =~ $rx ]] ; then
+				t2="${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
+				if [ -f "$t2" -a -x "$t2" ] ; then
+					TESTS+=( "$t2" )
+					continue
+				fi
+			fi
+		fi
 		msg_error "Unknown test \"$t\""
 	fi
 done
-- 
2.42.0

