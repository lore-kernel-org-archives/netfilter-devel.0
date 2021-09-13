Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155D8C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 18:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB0626108B
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 18:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235454AbhIMSkO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 14:40:14 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53344 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhIMSkO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 14:40:14 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 95AF56005C
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Sep 2021 20:37:45 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: Fix oversized kvmalloc() calls
Date:   Mon, 13 Sep 2021 20:38:52 +0200
Message-Id: <20210913183852.1743-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
limits the max allocatable memory via kvmalloc() to MAX_INT.

Reported-by: syzbot+cd43695a64bcd21b8596@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 081437dd75b7..4b6255c4b183 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4336,7 +4336,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (ops->privsize != NULL)
 		size = ops->privsize(nla, &desc);
 	alloc_size = sizeof(*set) + size + udlen;
-	if (alloc_size < size)
+	if (alloc_size < size || alloc_size > INT_MAX)
 		return -ENOMEM;
 	set = kvzalloc(alloc_size, GFP_KERNEL);
 	if (!set)
-- 
2.30.2

