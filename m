From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nf_tables: fix possible oops when dumping stateful objects
Date: Sat,  7 Jan 2017 20:51:50 +0800
Message-ID: <1483793510-30865-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:60964 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932130AbdAGMwk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Jan 2017 07:52:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

When dumping nft stateful objects, if NFTA_OBJ_TABLE and NFTA_OBJ_TYPE
attributes are not specified either, filter will become NULL, so oops
will happen(actually nft utility will always set NFTA_OBJ_TABLE attr,
so I write a test program to make this happen):

  BUG: unable to handle kernel NULL pointer dereference at (null)
  IP: nf_tables_dump_obj+0x17c/0x330 [nf_tables]
  [...]
  Call Trace:
  ? nf_tables_dump_obj+0x5/0x330 [nf_tables]
  ? __kmalloc_reserve.isra.35+0x31/0x90
  ? __alloc_skb+0x5b/0x1e0
  netlink_dump+0x124/0x2a0
  __netlink_dump_start+0x161/0x190
  nf_tables_getobj+0xe8/0x280 [nf_tables]

Fixes: a9fea2a3c3cf ("netfilter: nf_tables: allow to filter stateful object dumps by type")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_tables_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0db5f97..091d2dc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4262,10 +4262,11 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 				if (idx > s_idx)
 					memset(&cb->args[1], 0,
 					       sizeof(cb->args) - sizeof(cb->args[0]));
-				if (filter->table[0] &&
+				if (filter && filter->table[0] &&
 				    strcmp(filter->table, table->name))
 					goto cont;
-				if (filter->type != NFT_OBJECT_UNSPEC &&
+				if (filter &&
+				    filter->type != NFT_OBJECT_UNSPEC &&
 				    obj->type->type != filter->type)
 					goto cont;
 
-- 
2.5.5


