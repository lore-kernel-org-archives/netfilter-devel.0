Return-Path: <SRS0=LaOm=Z3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A7BC2BD09
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 09:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B4352464F
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 09:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbfLEJiq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Dec 2019 04:38:46 -0500
Received: from correo.us.es ([193.147.175.20]:37430 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729247AbfLEJiQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Dec 2019 04:38:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C6014C22E6
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 10:38:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7A6BDA70D
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 10:38:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AD540DA701; Thu,  5 Dec 2019 10:38:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 32F4DDA709
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 10:38:11 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Dec 2019 10:38:11 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0DF9D4265A5A
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 10:38:11 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] build: nftables 0.9.3 depends on libnftnl 1.1.5
Date:   Thu,  5 Dec 2019 10:38:09 +0100
Message-Id: <20191205093809.128045-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nftables 0.9.3 requires libnftnl 1.1.5, otherwise compilation breaks:
https://bugs.gentoo.org/701976.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 5ed3f18ad6f0..c487029abbc5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -57,7 +57,7 @@ AS_IF([test "x$enable_man_doc" = "xyes"], [
 ])
 
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
-PKG_CHECK_MODULES([LIBNFTNL], [libnftnl >= 1.1.4])
+PKG_CHECK_MODULES([LIBNFTNL], [libnftnl >= 1.1.5])
 
 AC_ARG_WITH([mini-gmp], [AS_HELP_STRING([--with-mini-gmp],
             [Use builtin mini-gmp (for embedded builds)])],
-- 
2.11.0

