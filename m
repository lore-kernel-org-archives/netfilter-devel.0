Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C14FC432C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 17:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E29920672
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 17:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfLBRQQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 12:16:16 -0500
Received: from correo.us.es ([193.147.175.20]:46234 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727553AbfLBRQQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 12:16:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6D330E34D4
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 18:16:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6003FDA738
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 18:16:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 55623DA70C; Mon,  2 Dec 2019 18:16:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2EF65DA70C;
        Mon,  2 Dec 2019 18:16:11 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Dec 2019 18:16:11 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 01E534265A5A;
        Mon,  2 Dec 2019 18:16:10 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH iptables] build: bump dependency on libnftnl
Date:   Mon,  2 Dec 2019 18:16:09 +0100
Message-Id: <20191202171609.549982-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nftnl_set_list_lookup_byname() libnftnl requires 1.1.5.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index cab77a489dfd..27e90703c9ad 100644
--- a/configure.ac
+++ b/configure.ac
@@ -131,7 +131,7 @@ if test "x$enable_nftables" = "xyes"; then
 		exit 1
 	fi
 
-	PKG_CHECK_MODULES([libnftnl], [libnftnl >= 1.1.3], [nftables=1], [nftables=0])
+	PKG_CHECK_MODULES([libnftnl], [libnftnl >= 1.1.5], [nftables=1], [nftables=0])
 
 	if test "$nftables" = 0;
 	then
-- 
2.11.0

