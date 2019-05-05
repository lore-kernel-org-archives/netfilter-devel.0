Return-Path: <SRS0=aMTL=TF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52DEEC004C9
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 23:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22C5B206DF
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 23:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbfEEXdl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 May 2019 19:33:41 -0400
Received: from mail.us.es ([193.147.175.20]:34080 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728071AbfEEXdV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 May 2019 19:33:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 733FD11ED8D
        for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2019 01:33:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 60F44DA706
        for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2019 01:33:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 56C41DA703; Mon,  6 May 2019 01:33:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4724FDA70A;
        Mon,  6 May 2019 01:33:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 01:33:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 163C24265A31;
        Mon,  6 May 2019 01:33:18 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 11/12] netfilter: xt_hashlimit: use struct_size() helper
Date:   Mon,  6 May 2019 01:33:04 +0200
Message-Id: <20190505233305.13650-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505233305.13650-1-pablo@netfilter.org>
References: <20190505233305.13650-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes, in particular in the
context in which this code is being used.

So, replace code of the following form:

sizeof(struct xt_hashlimit_htable) + sizeof(struct hlist_head) * size

with:

struct_size(hinfo, hash, size)

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_hashlimit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 8d86e39d6280..a30536b17ee1 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -288,8 +288,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 			size = 16;
 	}
 	/* FIXME: don't use vmalloc() here or anywhere else -HW */
-	hinfo = vmalloc(sizeof(struct xt_hashlimit_htable) +
-	                sizeof(struct hlist_head) * size);
+	hinfo = vmalloc(struct_size(hinfo, hash, size));
 	if (hinfo == NULL)
 		return -ENOMEM;
 	*out_hinfo = hinfo;
-- 
2.11.0

