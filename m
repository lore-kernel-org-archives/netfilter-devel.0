Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74CF5C433DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Mar 2021 14:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 397FC619CB
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Mar 2021 14:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhC3OrV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhC3Oq7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 10:46:59 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B166EC061574
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Mar 2021 07:46:58 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 2A45B59E37A73; Tue, 30 Mar 2021 16:46:54 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id A712659E37A70
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Mar 2021 16:46:53 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] files: move example files away from /etc
Date:   Tue, 30 Mar 2021 16:46:53 +0200
Message-Id: <20210330144653.25119-1-jengelh@inai.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As per file-hierarchy(5), /etc is for "system-specific configuration", not
"vendor-supplied default configuration files".

Moreover, the comments in all-in-one.nft say it is an example, and so,
not a vendor config either.

Move it out of /etc.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
For nftables.git.

 files/nftables/Makefile.am | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git files/nftables/Makefile.am files/nftables/Makefile.am
index fc8b94ea..ee88dd89 100644
--- files/nftables/Makefile.am
+++ files/nftables/Makefile.am
@@ -1,5 +1,4 @@
-pkgsysconfdir = ${sysconfdir}/nftables
-dist_pkgsysconf_DATA =	all-in-one.nft		\
+dist_pkgdata_DATA =	all-in-one.nft		\
 			arp-filter.nft		\
 			bridge-filter.nft	\
 			inet-filter.nft		\
-- 
2.30.2

