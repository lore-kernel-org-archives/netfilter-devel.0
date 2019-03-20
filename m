Return-Path: <SRS0=0f1v=RX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB97EC10F05
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 10:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD79B2075C
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 10:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfCTKfk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:35:40 -0400
Received: from mail.us.es ([193.147.175.20]:36154 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbfCTKfk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 06:35:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1614F67B98
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 11:35:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EED4917B3AA
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 11:35:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ED6F817B3A0; Wed, 20 Mar 2019 11:35:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D629017B3B8
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 11:35:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 Mar 2019 11:35:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.hhotels.local (148.160.broadband14.iol.cz [90.181.160.148])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8F5CC4265A2F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 11:35:36 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] build: missing misspell.h in Makefile.am
Date:   Wed, 20 Mar 2019 11:35:30 +0100
Message-Id: <20190320103530.23974-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190320103530.23974-1-pablo@netfilter.org>
References: <20190320103530.23974-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/Makefile.am | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/Makefile.am b/include/Makefile.am
index c103f4853bcc..b1f4fcf29015 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -22,6 +22,7 @@ noinst_HEADERS = 	cli.h		\
 			headers.h	\
 			list.h		\
 			meta.h		\
+			misspell.h	\
 			numgen.h	\
 			netlink.h	\
 			osf.h		\
-- 
2.11.0

