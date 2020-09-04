Return-Path: <SRS0=mfO0=CN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C380C2D0A8
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Sep 2020 15:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E694D2074D
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Sep 2020 15:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730907AbgIDPZz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Sep 2020 11:25:55 -0400
Received: from correo.us.es ([193.147.175.20]:52668 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730848AbgIDPZx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Sep 2020 11:25:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BF5FEF2585
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2020 17:25:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B3E60DA78A
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2020 17:25:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A99AEDA789; Fri,  4 Sep 2020 17:25:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97AC5DA704;
        Fri,  4 Sep 2020 17:25:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 04 Sep 2020 17:25:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7BA7C42EF4E3;
        Fri,  4 Sep 2020 17:25:48 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nf] netfilter: nft_meta: use socket user_ns to retrieve skuid and skgid
Date:   Fri,  4 Sep 2020 17:25:32 +0200
Message-Id: <20200904152532.2320-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

... instead of using init_user_ns.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 7bc6537f3ccb..b37bd02448d8 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -147,11 +147,11 @@ nft_meta_get_eval_skugid(enum nft_meta_keys key,
 
 	switch (key) {
 	case NFT_META_SKUID:
-		*dest = from_kuid_munged(&init_user_ns,
+		*dest = from_kuid_munged(sock_net(sk)->user_ns,
 					 sock->file->f_cred->fsuid);
 		break;
 	case NFT_META_SKGID:
-		*dest =	from_kgid_munged(&init_user_ns,
+		*dest =	from_kgid_munged(sock_net(sk)->user_ns,
 					 sock->file->f_cred->fsgid);
 		break;
 	default:
-- 
2.20.1

