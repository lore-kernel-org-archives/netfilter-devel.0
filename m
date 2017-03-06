From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink: use nftnl_udata_put_u32()/nftnl_udata_get_u32()
Date: Mon,  6 Mar 2017 17:48:36 +0100
Message-ID: <1488818916-4172-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45114 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753684AbdCFQso (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Mar 2017 11:48:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 02CBADA722
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 17:48:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA10FDA818
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 17:48:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACC11DA804
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 17:48:39 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use these new type-specific helper functions instead available in
libnftnl.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 8b0fc9403361..2ff9afcefa20 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1143,9 +1143,11 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		}
 
 		if (ud[UDATA_SET_KEYBYTEORDER])
-			keybyteorder = *((uint32_t *)nftnl_udata_get(ud[UDATA_SET_KEYBYTEORDER]));
+			keybyteorder =
+				nftnl_udata_get_u32(ud[UDATA_SET_KEYBYTEORDER]);
 		if (ud[UDATA_SET_DATABYTEORDER])
-			databyteorder = *((uint32_t *)nftnl_udata_get(ud[UDATA_SET_DATABYTEORDER]));
+			databyteorder =
+				nftnl_udata_get_u32(ud[UDATA_SET_DATABYTEORDER]);
 	}
 
 	key = nftnl_set_get_u32(nls, NFTNL_SET_KEY_TYPE);
@@ -1284,13 +1286,13 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 	udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
 	if (!udbuf)
 		memory_allocation_error();
-	if (!nftnl_udata_put(udbuf, UDATA_SET_KEYBYTEORDER, sizeof(uint32_t),
-			     &set->keytype->byteorder))
+	if (!nftnl_udata_put_u32(udbuf, UDATA_SET_KEYBYTEORDER,
+				 set->keytype->byteorder))
 		memory_allocation_error();
 
 	if (set->flags & NFT_SET_MAP &&
-	    !nftnl_udata_put(udbuf, UDATA_SET_DATABYTEORDER, sizeof(uint32_t),
-			     &set->datatype->byteorder))
+	    !nftnl_udata_put_u32(udbuf, UDATA_SET_DATABYTEORDER,
+				 set->datatype->byteorder))
 		memory_allocation_error();
 
 	nftnl_set_set_data(nls, NFTNL_SET_USERDATA, nftnl_udata_buf_data(udbuf),
-- 
2.1.4

