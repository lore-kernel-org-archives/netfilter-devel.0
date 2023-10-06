Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3ED6E92FFA
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Oct 2023 09:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjJFJoJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Oct 2023 05:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbjJFJoI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Oct 2023 05:44:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A476D9F
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Oct 2023 02:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696585400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2KVyFvcShHYWZo53v4H0HBxXa/ymfkcRVqevp9GQKOE=;
        b=ERc8V+W7O4Lhn57R8NXVccYhjeJRpfAyJm3FwgUdErpKxpTsDJft4+qjbjvf1KX6bDT0XA
        EKHV7uiufzEn1d71nd/B7tX404ucYlPAnzr5SGt6zteNPQNGn9rbWosBOJv9USmUAnCXWU
        TdVC7zTpLv9DpiU/+7wYRbOsoJKZ494=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-3l-J3DX5PEefLMLXyRuPYw-1; Fri, 06 Oct 2023 05:43:18 -0400
X-MC-Unique: 3l-J3DX5PEefLMLXyRuPYw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D8743C176ED
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Oct 2023 09:43:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 98A07215670B;
        Fri,  6 Oct 2023 09:43:17 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH 1/3] tests/shell: mount all of "/var/run" in "test-wrapper.sh"
Date:   Fri,  6 Oct 2023 11:42:18 +0200
Message-ID: <20231006094226.711628-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

After reboot, "/var/run/netns" does not exist before we run the first
`ip netns add` command. Previously, "test-wrapper.sh" would mount a
tmpfs on that directory, but that fails, if the directory doesn't exist.
You will notice this, by deleting /var/run/netns (which only root can
delete or create, and which is wiped on reboot).

Instead, mount all of "/var/run". Then we can also create /var/run/netns
directory.

This means, any other content from /var/run is hidden too. That's
probably desirable, because it means we don't depend on stuff that
happens to be there. If we would require other content in /var/run, then
the test runner needs to be aware of the requirement and ensure it's
present. But best is just to not require anything. It's only iproute2
which insists on /var/run/netns.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index e10360c9b266..13b918f8b8e1 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -23,11 +23,11 @@ START_TIME="$(cut -d ' ' -f1 /proc/uptime)"
 
 export TMPDIR="$NFT_TEST_TESTTMPDIR"
 
-CLEANUP_UMOUNT_RUN_NETNS=n
+CLEANUP_UMOUNT_VAR_RUN=n
 
 cleanup() {
-	if [ "$CLEANUP_UMOUNT_RUN_NETNS" = y ] ; then
-		umount "/var/run/netns" || :
+	if [ "$CLEANUP_UMOUNT_VAR_RUN" = y ] ; then
+		umount "/var/run" &>/dev/null || :
 	fi
 }
 
@@ -38,16 +38,20 @@ printf '%s\n' "$TEST" > "$NFT_TEST_TESTTMPDIR/name"
 read tainted_before < /proc/sys/kernel/tainted
 
 if [ "$NFT_TEST_HAS_UNSHARED_MOUNT" = y ] ; then
-	# We have a private mount namespace. We will mount /run/netns as a tmpfs,
-	# this is useful because `ip netns add` wants to add files there.
+	# We have a private mount namespace. We will mount /var/run/ as a tmpfs.
 	#
-	# When running as rootless, this is necessary to get such tests to
-	# pass.  When running rootful, it's still useful to not touch the
-	# "real" /var/run/netns of the system.
-	mkdir -p /var/run/netns
-	if mount -t tmpfs --make-private "/var/run/netns" ; then
-		CLEANUP_UMOUNT_RUN_NETNS=y
+	# The main purpose is so that we can create /var/run/netns, which is
+	# required for `ip netns add` to work.  When running as rootless, this
+	# is necessary to get such tests to pass. When running rootful, it's
+	# still useful to not touch the "real" /var/run/netns of the system.
+	#
+	# Note that this also hides everything that might reside in /var/run.
+	# That is desirable, as tests should not depend on content there (or if
+	# they do, we need to explicitly handle it as appropriate).
+	if mount -t tmpfs --make-private "/var/run" ; then
+		CLEANUP_UMOUNT_VAR_RUN=y
 	fi
+	mkdir -p /var/run/netns
 fi
 
 TEST_TAGS_PARSED=0
-- 
2.41.0

