Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730C2C25B70
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 21:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjJYV0L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 17:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjJYV0I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 17:26:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD64D133;
        Wed, 25 Oct 2023 14:26:06 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net-next 08/19] netfilter: nf_tables: Drop pointless memset in nf_tables_dump_obj
Date:   Wed, 25 Oct 2023 23:25:44 +0200
Message-Id: <20231025212555.132775-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231025212555.132775-1-pablo@netfilter.org>
References: <20231025212555.132775-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

The code does not make use of cb->args fields past the first one, no
need to zero them.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 03a306d15f43..fa216d1cfb74 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7717,9 +7717,6 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 				goto cont;
 			if (idx < s_idx)
 				goto cont;
-			if (idx > s_idx)
-				memset(&cb->args[1], 0,
-				       sizeof(cb->args) - sizeof(cb->args[0]));
 			if (filter && filter->table &&
 			    strcmp(filter->table, table->name))
 				goto cont;
-- 
2.30.2

