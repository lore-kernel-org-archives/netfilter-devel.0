Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D65CC04AAC
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 11:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D94320656
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 11:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731525AbfETLoD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 07:44:03 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35326 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729598AbfETLoD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 07:44:03 -0400
Received: from localhost ([::1]:48416 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hSgi1-0008AX-S7; Mon, 20 May 2019 13:44:01 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] Drop release.sh
Date:   Mon, 20 May 2019 13:44:07 +0200
Message-Id: <20190520114407.4973-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Last change in 2010, version number hardcoded - strong evidence this
script is not used anymore.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 release.sh | 31 -------------------------------
 1 file changed, 31 deletions(-)
 delete mode 100644 release.sh

diff --git a/release.sh b/release.sh
deleted file mode 100644
index 7c76423ebdaf7..0000000000000
--- a/release.sh
+++ /dev/null
@@ -1,31 +0,0 @@
-#! /bin/sh
-#
-set -e
-
-VERSION=1.4.7
-PREV_VERSION=1.4.6
-TMPDIR=/tmp/ipt-release
-IPTDIR="$TMPDIR/iptables-$VERSION"
-
-PATCH="patch-iptables-$PREV_VERSION-$VERSION.bz2";
-TARBALL="iptables-$VERSION.tar.bz2";
-CHANGELOG="changes-iptables-$PREV_VERSION-$VERSION.txt";
-
-mkdir -p "$TMPDIR"
-git shortlog "v$PREV_VERSION..v$VERSION" > "$TMPDIR/$CHANGELOG"
-git diff "v$PREV_VERSION..v$VERSION" | bzip2 > "$TMPDIR/$PATCH"
-git archive --prefix="iptables-$VERSION/" "v$VERSION" | tar -xC "$TMPDIR/"
-
-cd "$IPTDIR" && {
-	sh autogen.sh
-	cd ..
-}
-
-tar -cjf "$TARBALL" "iptables-$VERSION";
-gpg -u "Netfilter Core Team" -sb "$TARBALL";
-md5sum "$TARBALL" >"$TARBALL.md5sum";
-sha1sum "$TARBALL" >"$TARBALL.sha1sum";
-
-gpg -u "Netfilter Core Team" -sb "$PATCH";
-md5sum "$PATCH" >"$PATCH.md5sum";
-sha1sum "$PATCH" >"$PATCH.sha1sum";
-- 
2.21.0

