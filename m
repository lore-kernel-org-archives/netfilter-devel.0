Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 995E4C2B9F4
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 22:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8280A61360
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 22:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhFVWDF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 18:03:05 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59284 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbhFVWDA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 18:03:00 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 61A8D64279;
        Tue, 22 Jun 2021 23:59:18 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 7/8] netfilter: nf_tables: skip netlink portID validation if zero
Date:   Wed, 23 Jun 2021 00:00:00 +0200
Message-Id: <20210622220001.198508-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210622220001.198508-1-pablo@netfilter.org>
References: <20210622220001.198508-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_table_lookup() allows us to obtain the table object by the name and
the family. The netlink portID validation needs to be skipped for the
dump path, since the ownership only applies to commands to update the
given table. Skip validation if the specified netlink PortID is zero
when calling nft_table_lookup().

Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ca9ec8721e6c..1d62b1a83299 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -571,7 +571,7 @@ static struct nft_table *nft_table_lookup(const struct net *net,
 		    table->family == family &&
 		    nft_active_genmask(table, genmask)) {
 			if (nft_table_has_owner(table) &&
-			    table->nlpid != nlpid)
+			    nlpid && table->nlpid != nlpid)
 				return ERR_PTR(-EPERM);
 
 			return table;
-- 
2.30.2

