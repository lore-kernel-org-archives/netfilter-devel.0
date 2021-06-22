Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E951C2B9F4
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 10:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03718613B3
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 10:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhFVKQD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 06:16:03 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57788 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhFVKQC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 06:16:02 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 008FD64133
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Jun 2021 12:12:21 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/2] netfilter: nf_tables: skip netlink portID validation if zero
Date:   Tue, 22 Jun 2021 12:13:41 +0200
Message-Id: <20210622101342.33758-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
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

