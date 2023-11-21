Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD785C54FB9
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbjKUMOC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234720AbjKUMOA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:14:00 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 14456192;
        Tue, 21 Nov 2023 04:13:56 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,5.4 26/26] netfilter: nf_tables: bogus EBUSY when deleting flowtable after flush (for 5.4)
Date:   Tue, 21 Nov 2023 13:13:33 +0100
Message-Id: <20231121121333.294238-27-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231121121333.294238-1-pablo@netfilter.org>
References: <20231121121333.294238-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

3f0465a9ef02 ("netfilter: nf_tables: dynamically allocate hooks per
net_device in flowtables") reworks flowtable support to allow for
dynamic allocation of hooks, which implicitly fixes the following
bogus EBUSY in transaction:

  delete flowtable
  add flowtable # same flowtable with same devices, it hits EBUSY

This patch does not exist in any tree, but it fixes this issue for
-stable Linux kernel 5.4

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f379131903e5..78be121f38ac 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6132,6 +6132,9 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 			continue;
 
 		list_for_each_entry(ft, &table->flowtables, list) {
+			if (!nft_is_active_next(net, ft))
+				continue;
+
 			for (k = 0; k < ft->ops_len; k++) {
 				if (!ft->ops[k].dev)
 					continue;
-- 
2.30.2

