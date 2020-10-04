Return-Path: <SRS0=OxIk=DL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF71C47095
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Oct 2020 19:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 555D52068E
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Oct 2020 19:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgJDTuM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Oct 2020 15:50:12 -0400
Received: from correo.us.es ([193.147.175.20]:34948 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgJDTuL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Oct 2020 15:50:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A11B7EF438
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2020 21:50:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90F12DA704
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2020 21:50:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 86A34DA78C; Sun,  4 Oct 2020 21:50:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4CFB6DA73F;
        Sun,  4 Oct 2020 21:50:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 04 Oct 2020 21:50:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 23E7142EF9E2;
        Sun,  4 Oct 2020 21:50:07 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 03/11] ipvs: Remove unused macros
Date:   Sun,  4 Oct 2020 21:49:32 +0200
Message-Id: <20201004194940.7368-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201004194940.7368-1-pablo@netfilter.org>
References: <20201004194940.7368-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

They are not used since commit e4ff67513096 ("ipvs: add
sync_maxlen parameter for the sync daemon")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_sync.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 2b8abbfe018c..16b48064f715 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -242,9 +242,6 @@ struct ip_vs_sync_thread_data {
       |                    IPVS Sync Connection (1)                   |
 */
 
-#define SYNC_MESG_HEADER_LEN	4
-#define MAX_CONNS_PER_SYNCBUFF	255 /* nr_conns in ip_vs_sync_mesg is 8 bit */
-
 /* Version 0 header */
 struct ip_vs_sync_mesg_v0 {
 	__u8                    nr_conns;
-- 
2.20.1

