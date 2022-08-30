Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28347ECAAD4
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Aug 2022 09:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiH3Juu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Aug 2022 05:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiH3Jut (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2022 05:50:49 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50CF4A2AB5
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2022 02:50:47 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: check offload flags before splicing hook list
Date:   Tue, 30 Aug 2022 11:50:42 +0200
Message-Id: <20220830095042.452456-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Splice the hook list after validating chain flags, otherwise
nft_chain_release_hook() is called with an empty hook list from the
error path, hence the hook list is memleaked.

BUG: memory leak
unreferenced object 0xffff88810180b100 (size 96):
  comm "syz-executor133", pid 3619, jiffies 4294945714 (age 12.690s)
  hex dump (first 32 bytes):
    28 64 23 02 81 88 ff ff 28 64 23 02 81 88 ff ff  (d#.....(d#.....
    90 a8 aa 83 ff ff ff ff 00 00 b5 0f 81 88 ff ff  ................
  backtrace:
    [<ffffffff83a8c59b>] kmalloc include/linux/slab.h:600 [inline]
    [<ffffffff83a8c59b>] nft_netdev_hook_alloc+0x3b/0xc0 net/netfilter/nf_tables_api.c:1901
    [<ffffffff83a9239a>] nft_chain_parse_netdev net/netfilter/nf_tables_api.c:1998 [inline]
    [<ffffffff83a9239a>] nft_chain_parse_hook+0x33a/0x530 net/netfilter/nf_tables_api.c:2073
    [<ffffffff83a9b14b>] nf_tables_addchain.constprop.0+0x10b/0x950 net/netfilter/nf_tables_api.c:2218
    [<ffffffff83a9c41b>] nf_tables_newchain+0xa8b/0xc60 net/netfilter/nf_tables_api.c:2593
    [<ffffffff83a3d6a6>] nfnetlink_rcv_batch+0xa46/0xd20 net/netfilter/nfnetlink.c:517
    [<ffffffff83a3db79>] nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:638 [inline]
    [<ffffffff83a3db79>] nfnetlink_rcv+0x1f9/0x220 net/netfilter/nfnetlink.c:656
    [<ffffffff83a13b17>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
    [<ffffffff83a13b17>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
    [<ffffffff83a13fd6>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
    [<ffffffff83865ab6>] sock_sendmsg_nosec net/socket.c:714 [inline]
    [<ffffffff83865ab6>] sock_sendmsg+0x56/0x80 net/socket.c:734
    [<ffffffff8386601c>] ____sys_sendmsg+0x36c/0x390 net/socket.c:2482
    [<ffffffff8386a918>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
    [<ffffffff8386aaa8>] __sys_sendmsg+0x88/0x100 net/socket.c:2565
    [<ffffffff845e5955>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845e5955>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Reported-by: syzbot+5fcdbfab6d6744c57418@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2ee50e23c9b7..9323ce8d9bc4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2149,8 +2149,15 @@ static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
 	struct nft_hook *h;
 
 	basechain->type = hook->type;
+	basechain->policy = NF_ACCEPT;
 	INIT_LIST_HEAD(&basechain->hook_list);
+
 	chain = &basechain->chain;
+	chain->flags |= NFT_CHAIN_BASE | flags;
+
+	if (chain->flags & NFT_CHAIN_HW_OFFLOAD &&
+	    !nft_chain_offload_support(basechain))
+		return -EOPNOTSUPP;
 
 	if (nft_base_chain_netdev(family, hook->num)) {
 		list_splice_init(&hook->list, &basechain->hook_list);
@@ -2163,12 +2170,6 @@ static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
 		nft_basechain_hook_init(&basechain->ops, family, hook, chain);
 	}
 
-	chain->flags |= NFT_CHAIN_BASE | flags;
-	basechain->policy = NF_ACCEPT;
-	if (chain->flags & NFT_CHAIN_HW_OFFLOAD &&
-	    !nft_chain_offload_support(basechain))
-		return -EOPNOTSUPP;
-
 	flow_block_init(&basechain->flow_block);
 
 	return 0;
-- 
2.30.2

