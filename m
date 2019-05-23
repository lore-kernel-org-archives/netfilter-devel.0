Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FDFC282DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 21:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 223FF21773
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 21:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388281AbfEWVf6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 17:35:58 -0400
Received: from mail.us.es ([193.147.175.20]:46944 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388240AbfEWVf5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 17:35:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B8961C1A71
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2019 23:35:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8C4FDA70A
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2019 23:35:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9E516DA707; Thu, 23 May 2019 23:35:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 68F1FDA70A;
        Thu, 23 May 2019 23:35:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 23 May 2019 23:35:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 33F4A4265A32;
        Thu, 23 May 2019 23:35:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 02/11] netfilter: nf_queue: fix reinject verdict handling
Date:   Thu, 23 May 2019 23:35:38 +0200
Message-Id: <20190523213547.15523-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523213547.15523-1-pablo@netfilter.org>
References: <20190523213547.15523-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jagdish Motwani <jagdish.motwani@sophos.com>

This patch fixes netfilter hook traversal when there are more than 1 hooks
returning NF_QUEUE verdict. When the first queue reinjects the packet,
'nf_reinject' starts traversing hooks with a proper hook_index. However,
if it again receives a NF_QUEUE verdict (by some other netfilter hook), it
queues the packet with a wrong hook_index. So, when the second queue
reinjects the packet, it re-executes hooks in between.

Fixes: 960632ece694 ("netfilter: convert hook list to an array")
Signed-off-by: Jagdish Motwani <jagdish.motwani@sophos.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 9dc1d6e04946..b5b2be55ca82 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -255,6 +255,7 @@ static unsigned int nf_iterate(struct sk_buff *skb,
 repeat:
 		verdict = nf_hook_entry_hookfn(hook, skb, state);
 		if (verdict != NF_ACCEPT) {
+			*index = i;
 			if (verdict != NF_REPEAT)
 				return verdict;
 			goto repeat;
-- 
2.11.0

