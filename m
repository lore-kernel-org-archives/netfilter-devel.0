Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CAAC04AAC
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 11:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27E6620656
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 11:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731642AbfETLny (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 07:43:54 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35314 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729598AbfETLnx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 07:43:53 -0400
Received: from localhost ([::1]:48404 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hSghr-0008AA-Px; Mon, 20 May 2019 13:43:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] Revert "build: don't include tests in released tarball"
Date:   Mon, 20 May 2019 13:43:57 +0200
Message-Id: <20190520114357.4905-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This reverts commit 4b187eeed49dc507d38438affabe90d36847412d.

Having the testsuites available in release tarball is helpful for
SRPM-based CI at least. The other two suites are included already, so
it's actually 2:1 keep or drop.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index 044f6461abf5a..b1ba015ffe8e6 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -26,7 +26,7 @@ tarball:
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
 	pushd ${top_srcdir} && git archive --prefix=${PACKAGE_TARNAME}-${PACKAGE_VERSION}/ HEAD | tar -C /tmp -x && popd;
 	pushd /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION} && ./autogen.sh && popd;
-	tar --exclude=*.t --exclude=iptables-test.py -C /tmp -cjf ${PACKAGE_TARNAME}-${PACKAGE_VERSION}.tar.bz2 --owner=root --group=root ${PACKAGE_TARNAME}-${PACKAGE_VERSION}/;
+	tar -C /tmp -cjf ${PACKAGE_TARNAME}-${PACKAGE_VERSION}.tar.bz2 --owner=root --group=root ${PACKAGE_TARNAME}-${PACKAGE_VERSION}/;
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
 
 config.status: extensions/GNUmakefile.in \
-- 
2.21.0

