Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C508C10DCE
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 10:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7ED020768
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 10:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgCRKwj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Mar 2020 06:52:39 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:36707 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbgCRKwj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 06:52:39 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 7A76B416CC;
        Wed, 18 Mar 2020 18:52:35 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_flow_table_offload: fix kernel NULL pointer dereference in nf_flow_table_indr_block_cb
Date:   Wed, 18 Mar 2020 18:52:35 +0800
Message-Id: <1584528755-7969-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVNSkpLS0tLTUpLSE5KTVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MRw6EQw4TDg8MBwzA0tPQi4x
        PC4KChRVSlVKTkNPTklDTE5OTkNJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhMT043Bg++
X-HM-Tid: 0a70ed460b362086kuqy7a76b416cc
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

nf_flow_table_indr_block_cb will list net->nft.tables. But nf_flow_table
may load without nf_tables modules. So the list net->nft.tables may be
uinit.

[  630.908086] BUG: kernel NULL pointer dereference, address: 00000000000000f0
[  630.908233] #PF: error_code(0x0000) - not-present page
[  630.908304] PGD 800000104addd067 P4D 800000104addd067 PUD 104311d067 PMD 0
[  630.908380] Oops: 0000 [#1] SMP PTI [  630.908615] RIP: 0010:nf_flow_table_indr_block_cb+0xc0/0x190 [nf_flow_table]
[  630.908690] Code: 5b 41 5c 41 5d 41 5e 41 5f 5d c3 4c 89 75 a0 4c 89 65 a8 4d 89 ee 49 89 dd 4c 89 fe 48 c7 c7 b7 64 36 a0 31 c0 e8 ce ed d8 e0 <49> 8b b7 f0 00 00 00 48 c7 c7 c8 64      36 a0 31 c0 e8 b9 ed d8 e0 49[  630.908790] RSP: 0018:ffffc9000895f8c0 EFLAGS: 00010246
[  630.908860] RAX: 000000000000001d RBX: ffff888884788000 RCX: 0000000000000001
[  630.908935] RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffff88905fc18cc0
[  630.909010] RBP: ffffc9000895f920 R08: 00000000000005bc R09: 00000000000005bc
[  630.909084] R10: 0000000000000030 R11: ffffffff826ce604 R12: ffffffff823bdcc8
[  630.909159] R13: ffff888884788000 R14: ffffffff823bdc98 R15: 0000000000000000[  630.909234] FS:  00007f1d633e7740(0000) GS:ffff88905fc00000(0000) knlGS:0000000000000000[  630.909970] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  630.910372] CR2: 00000000000000f0 CR3: 000000103ad2e004 CR4: 00000000001606e0
[  630.910774] Call Trace:
[  630.911192]  ? mlx5e_rep_indr_setup_block+0x270/0x270 [mlx5_core]
[  630.911621]  ? mlx5e_rep_indr_setup_block+0x270/0x270 [mlx5_core]
[  630.912040]  ? mlx5e_rep_indr_setup_block+0x270/0x270 [mlx5_core]
[  630.912443]  flow_block_cmd+0x51/0x80
[  630.912844]  __flow_indr_block_cb_register+0x26c/0x510
[  630.913265]  mlx5e_nic_rep_netdevice_event+0x9e/0x110 [mlx5_core]
[  630.913665]  notifier_call_chain+0x53/0xa0
[  630.914063]  raw_notifier_call_chain+0x16/0x20
[  630.914466]  call_netdevice_notifiers_info+0x39/0x90
[  630.914859]  register_netdevice+0x484/0x550
[  630.915256]  __ip_tunnel_create+0x12b/0x1f0 [ip_tunnel]
[  630.915661]  ip_tunnel_init_net+0x116/0x180 [ip_tunnel]
[  630.916062]  ipgre_tap_init_net+0x22/0x30 [ip_gre]
[  630.916458]  ops_init+0x44/0x110
[  630.916851]  register_pernet_operations+0x112/0x200

Fixes: b5140a36da78 ("netfilter: flowtable: add indr block setup support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index ad54931..ca40dfa 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1029,6 +1029,9 @@ static void nf_flow_table_indr_block_cb(struct net_device *dev,
 	struct nft_table *table;
 	struct nft_hook *hook;
 
+	if (!net->nft.base_seq)
+		return;
+
 	mutex_lock(&net->nft.commit_mutex);
 	list_for_each_entry(table, &net->nft.tables, list) {
 		list_for_each_entry(nft_ft, &table->flowtables, list) {
-- 
1.8.3.1

