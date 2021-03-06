Return-Path: <SRS0=HMuw=IE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0EBC433E0
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Mar 2021 12:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD8B764FE8
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Mar 2021 12:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhCFMMu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Mar 2021 07:12:50 -0500
Received: from correo.us.es ([193.147.175.20]:45978 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230413AbhCFMMk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Mar 2021 07:12:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 63924C516E
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Mar 2021 13:12:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4F7DEDA78F
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Mar 2021 13:12:30 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 44841DA78A; Sat,  6 Mar 2021 13:12:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E48E9DA704;
        Sat,  6 Mar 2021 13:12:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 06 Mar 2021 13:12:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id BB16D42DC6E3;
        Sat,  6 Mar 2021 13:12:27 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/9] uapi: nfnetlink_cthelper.h: fix userspace compilation error
Date:   Sat,  6 Mar 2021 13:12:15 +0100
Message-Id: <20210306121223.28711-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210306121223.28711-1-pablo@netfilter.org>
References: <20210306121223.28711-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: "Dmitry V. Levin" <ldv@altlinux.org>

Apparently, <linux/netfilter/nfnetlink_cthelper.h> and
<linux/netfilter/nfnetlink_acct.h> could not be included into the same
compilation unit because of a cut-and-paste typo in the former header.

Fixes: 12f7a505331e6 ("netfilter: add user-space connection tracking helper infrastructure")
Cc: <stable@vger.kernel.org> # v3.6
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nfnetlink_cthelper.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_cthelper.h b/include/uapi/linux/netfilter/nfnetlink_cthelper.h
index a13137afc429..70af02092d16 100644
--- a/include/uapi/linux/netfilter/nfnetlink_cthelper.h
+++ b/include/uapi/linux/netfilter/nfnetlink_cthelper.h
@@ -5,7 +5,7 @@
 #define NFCT_HELPER_STATUS_DISABLED	0
 #define NFCT_HELPER_STATUS_ENABLED	1
 
-enum nfnl_acct_msg_types {
+enum nfnl_cthelper_msg_types {
 	NFNL_MSG_CTHELPER_NEW,
 	NFNL_MSG_CTHELPER_GET,
 	NFNL_MSG_CTHELPER_DEL,
-- 
2.20.1

