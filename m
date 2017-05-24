From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/3] netlink: add size description for constant sets
Date: Wed, 24 May 2017 11:53:18 +0200
Message-ID: <1495619598-22759-3-git-send-email-pablo@netfilter.org>
References: <1495619598-22759-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42650 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936782AbdEXJxg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 05:53:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 41F271EC2CE
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:53:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3455D18500
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:53:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 19EB6FF2CE
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:53:26 +0200 (CEST)
In-Reply-To: <1495619598-22759-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The kernel side can make better decisions with this information when
selecting the right backend, so add this information to the set netlink
message.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/netlink.c b/src/netlink.c
index 59e8918d2ba0..28821903f18c 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1293,6 +1293,8 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 		if (set->desc.size != 0)
 			nftnl_set_set_u32(nls, NFTNL_SET_DESC_SIZE,
 					  set->desc.size);
+	} else if (set->init) {
+		nftnl_set_set_u32(nls, NFTNL_SET_DESC_SIZE, set->init->size);
 	}
 
 	udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
-- 
2.1.4

