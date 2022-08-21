Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80299C00140
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Aug 2022 08:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiHUI7t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Aug 2022 04:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiHUI7r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Aug 2022 04:59:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F05F129C97
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Aug 2022 01:59:45 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     abhishek.shah@columbia.edu
Subject: [PATCH nf] netfilter: nf_tables: make table handle allocation per-netns friendly
Date:   Sun, 21 Aug 2022 10:59:39 +0200
Message-Id: <20220821085939.571378-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

mutex is per-netns, move table_netns to the pernet area.

*read-write* to 0xffffffff883a01e8 of 8 bytes by task 6542 on cpu 0:
 nf_tables_newtable+0x6dc/0xc00 net/netfilter/nf_tables_api.c:1221
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:513 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
 nfnetlink_rcv+0xa6a/0x13a0 net/netfilter/nfnetlink.c:652
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x652/0x730 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x643/0x740 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0x348/0x4c0 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmsg+0x159/0x1f0 net/socket.c:2496
 __do_sys_sendmsg net/socket.c:2505 [inline]
 __se_sys_sendmsg net/socket.c:2503 [inline]
 __x64_sys_sendmsg+0x47/0x50 net/socket.c:2503
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/c

Fixes: f102d66b335a ("netfilter: nf_tables: use dedicated mutex to guard transactions")
Reported-by: Abhishek Shah <abhishek.shah@columbia.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 1 +
 net/netfilter/nf_tables_api.c     | 3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 99aae36c04b9..cdb7db9b0e25 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1652,6 +1652,7 @@ struct nftables_pernet {
 	struct list_head	module_list;
 	struct list_head	notify_list;
 	struct mutex		commit_mutex;
+	u64			table_handle;
 	unsigned int		base_seq;
 	u8			validate_state;
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dff2b5851bbb..0951f31caabe 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -32,7 +32,6 @@ static LIST_HEAD(nf_tables_objects);
 static LIST_HEAD(nf_tables_flowtables);
 static LIST_HEAD(nf_tables_destroy_list);
 static DEFINE_SPINLOCK(nf_tables_destroy_list_lock);
-static u64 table_handle;
 
 enum {
 	NFT_VALIDATE_SKIP	= 0,
@@ -1235,7 +1234,7 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	INIT_LIST_HEAD(&table->flowtables);
 	table->family = family;
 	table->flags = flags;
-	table->handle = ++table_handle;
+	table->handle = ++nft_net->table_handle;
 	if (table->flags & NFT_TABLE_F_OWNER)
 		table->nlpid = NETLINK_CB(skb).portid;
 
-- 
2.30.2

