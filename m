Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CED9C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 12:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECE3C6139E
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 12:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344049AbhDFMWO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 08:22:14 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34432 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343959AbhDFMWE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 08:22:04 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7D26863E67;
        Tue,  6 Apr 2021 14:21:33 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 16/28] netfilter: nftables: fix a warning message in nf_tables_commit_audit_collect()
Date:   Tue,  6 Apr 2021 14:21:21 +0200
Message-Id: <20210406122133.1644-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

The first argument of a WARN_ONCE() is a condition.  This WARN_ONCE()
will only print the table name, and is potentially problematic if the
table name has a %s in it.

Fixes: c520292f29b8 ("audit: log nftables configuration change events once per table")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 005f1c620fc0..edb51c9ebab0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7978,7 +7978,7 @@ static void nf_tables_commit_audit_collect(struct list_head *adl,
 		if (adp->table == table)
 			goto found;
 	}
-	WARN_ONCE("table=%s not expected in commit list", table->name);
+	WARN_ONCE(1, "table=%s not expected in commit list", table->name);
 	return;
 found:
 	adp->entries++;
-- 
2.30.2

