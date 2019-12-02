Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBEAC432C3
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 19:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16C4120833
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 19:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfLBTwK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 14:52:10 -0500
Received: from a3.inai.de ([88.198.85.195]:39572 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbfLBTwK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 14:52:10 -0500
Received: by a3.inai.de (Postfix, from userid 65534)
        id 0D8935985090B; Mon,  2 Dec 2019 20:52:09 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id C05F959842AE8;
        Mon,  2 Dec 2019 20:52:04 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Cc:     jengelh@inai.de
Subject: [PATCH] build: remove stray @ sign in manpage
Date:   Mon,  2 Dec 2019 20:52:04 +0100
Message-Id: <20191202195204.23316-1-jengelh@inai.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Because the sed command was not matching the trailing @, it
was left in the manpage, leading to

NAME
       ebtables-legacy (2.0.11@) - Ethernet bridge frame table administration (legacy)

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index b879941..6181003 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -64,6 +64,6 @@ ebtables-legacy-save: ebtables-save.in ${top_builddir}/config.status
 	${AM_V_GEN}sed -e 's![@]sbindir@!${sbindir}!g' <$< >$@
 
 ebtables-legacy.8: ebtables-legacy.8.in ${top_builddir}/config.status
-	${AM_V_GEN}sed -e 's![@]PACKAGE_VERSION!${PACKAGE_VERSION}!g' \
+	${AM_V_GEN}sed -e 's![@]PACKAGE_VERSION@!${PACKAGE_VERSION}!g' \
 		-e 's![@]PACKAGE_DATE@!${PROGDATE}!g' \
 		-e 's![@]LOCKFILE@!${LOCKFILE}!g' <$< >$@
-- 
2.24.0

