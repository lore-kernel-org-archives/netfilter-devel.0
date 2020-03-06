Return-Path: <SRS0=2TpG=4X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40EBC10DCE
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Mar 2020 16:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8197F2072A
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Mar 2020 16:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgCFQsZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Mar 2020 11:48:25 -0500
Received: from correo.us.es ([193.147.175.20]:44016 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbgCFQsZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Mar 2020 11:48:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B31146D010
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Mar 2020 17:48:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4822DA736
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Mar 2020 17:48:05 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9A352DA7B2; Fri,  6 Mar 2020 17:48:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FBD6DA736
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Mar 2020 17:48:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Mar 2020 17:48:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1AC624301DE0
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Mar 2020 17:48:03 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: missing module ownership in chain type definitions
Date:   Fri,  6 Mar 2020 17:48:16 +0100
Message-Id: <20200306164816.139750-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set owner to THIS_MODULE, otherwise the nft_chain_{nat,route} modules
might be removed while there are still inet/nat or route chains in
place.

[  117.942096] BUG: unable to handle page fault for address: ffffffffa0d5e040
[  117.942101] #PF: supervisor read access in kernel mode
[  117.942103] #PF: error_code(0x0000) - not-present page
[  117.942106] PGD 200c067 P4D 200c067 PUD 200d063 PMD 3dc909067 PTE 0
[  117.942113] Oops: 0000 [#1] PREEMPT SMP PTI
[  117.942118] CPU: 3 PID: 27 Comm: kworker/3:0 Not tainted 5.6.0-rc3+ #348
[  117.942133] Workqueue: events nf_tables_trans_destroy_work [nf_tables]
[  117.942145] RIP: 0010:nf_tables_chain_destroy.isra.0+0x94/0x15a [nf_tables]
[  117.942149] Code: f6 45 54 01 0f 84 d1 00 00 00 80 3b 05 74 44 48 8b 75 e8 48 c7 c7 72 be de a0 e8 56 e6 2d e0 48 8b 45 e8 48 c7 c7 7f be de a0 <48> 8b 30 e8 43 e6 2d e0 48 8b 45 e8 48 8b 40 10 48 85 c0 74 5b 8b
[  117.942152] RSP: 0018:ffffc9000015be10 EFLAGS: 00010292
[  117.942155] RAX: ffffffffa0d5e040 RBX: ffff88840be87fc2 RCX: 0000000000000007
[  117.942158] RDX: 0000000000000007 RSI: 0000000000000086 RDI: ffffffffa0debe7f
[  117.942160] RBP: ffff888403b54b50 R08: 0000000000001482 R09: 0000000000000004
[  117.942162] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8883eda7e540
[  117.942164] R13: dead000000000122 R14: dead000000000100 R15: ffff888403b3db80
[  117.942167] FS:  0000000000000000(0000) GS:ffff88840e4c0000(0000) knlGS:0000000000000000
[  117.942169] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  117.942172] CR2: ffffffffa0d5e040 CR3: 00000003e4c52002 CR4: 00000000001606e0
[  117.942174] Call Trace:
[  117.942188]  nf_tables_trans_destroy_work.cold+0xd/0x12 [nf_tables]
[  117.942196]  process_one_work+0x1d6/0x3b0
[  117.942200]  worker_thread+0x45/0x3c0
[  117.942203]  ? process_one_work+0x3b0/0x3b0
[  117.942210]  kthread+0x112/0x130
[  117.942214]  ? kthread_create_worker_on_cpu+0x40/0x40
[  117.942221]  ret_from_fork+0x35/0x40

nf_tables_chain_destroy() crashes on module_put().

Fixes: d164385ec572 ("netfilter: nat: add inet family nat support")
Fixes: c1deb065cf3b ("netfilter: nf_tables: merge route type into core")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Fix route chain type too.
    This supersedes https://patchwork.ozlabs.org/patch/1250406/

 net/netfilter/nft_chain_nat.c   | 1 +
 net/netfilter/nft_chain_route.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/net/netfilter/nft_chain_nat.c b/net/netfilter/nft_chain_nat.c
index ff9ac8ae0031..eac4a901233f 100644
--- a/net/netfilter/nft_chain_nat.c
+++ b/net/netfilter/nft_chain_nat.c
@@ -89,6 +89,7 @@ static const struct nft_chain_type nft_chain_nat_inet = {
 	.name		= "nat",
 	.type		= NFT_CHAIN_T_NAT,
 	.family		= NFPROTO_INET,
+	.owner		= THIS_MODULE,
 	.hook_mask	= (1 << NF_INET_PRE_ROUTING) |
 			  (1 << NF_INET_LOCAL_IN) |
 			  (1 << NF_INET_LOCAL_OUT) |
diff --git a/net/netfilter/nft_chain_route.c b/net/netfilter/nft_chain_route.c
index 8826bbe71136..dcece7be2869 100644
--- a/net/netfilter/nft_chain_route.c
+++ b/net/netfilter/nft_chain_route.c
@@ -54,6 +54,7 @@ static const struct nft_chain_type nft_chain_route_ipv4 = {
 	.name		= "route",
 	.type		= NFT_CHAIN_T_ROUTE,
 	.family		= NFPROTO_IPV4,
+	.owner		= THIS_MODULE,
 	.hook_mask	= (1 << NF_INET_LOCAL_OUT),
 	.hooks		= {
 		[NF_INET_LOCAL_OUT]	= nf_route_table_hook4,
@@ -104,6 +105,7 @@ static const struct nft_chain_type nft_chain_route_ipv6 = {
 	.name		= "route",
 	.type		= NFT_CHAIN_T_ROUTE,
 	.family		= NFPROTO_IPV6,
+	.owner		= THIS_MODULE,
 	.hook_mask	= (1 << NF_INET_LOCAL_OUT),
 	.hooks		= {
 		[NF_INET_LOCAL_OUT]	= nf_route_table_hook6,
@@ -135,6 +137,7 @@ static const struct nft_chain_type nft_chain_route_inet = {
 	.name		= "route",
 	.type		= NFT_CHAIN_T_ROUTE,
 	.family		= NFPROTO_INET,
+	.owner		= THIS_MODULE,
 	.hook_mask	= (1 << NF_INET_LOCAL_OUT),
 	.hooks		= {
 		[NF_INET_LOCAL_OUT]	= nf_route_table_inet,
-- 
2.11.0

