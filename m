Return-Path: <SRS0=cI96=DJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E15C4363D
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Oct 2020 11:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC417206B6
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Oct 2020 11:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgJBLvf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Oct 2020 07:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgJBLvf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Oct 2020 07:51:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DF7C0613D0
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2020 04:51:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kOJb3-0006mz-TR; Fri, 02 Oct 2020 13:51:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nfnetlink: place subsys mutexes in distinct lockdep classes
Date:   Fri,  2 Oct 2020 13:51:29 +0200
Message-Id: <20201002115129.22273-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From time to time there are lockdep reports similar to this one:

 WARNING: possible circular locking dependency detected
 ------------------------------------------------------
 000000004f61aa56 (&table[i].mutex){+.+.}, at: nfnl_lock [nfnetlink]
 but task is already holding lock:
 [..] (&net->nft.commit_mutex){+.+.}, at: nf_tables_valid_genid [nf_tables]
 which lock already depends on the new lock.
 the existing dependency chain (in reverse order) is:
 -> #1 (&net->nft.commit_mutex){+.+.}:
 [..]
        nf_tables_valid_genid+0x18/0x60 [nf_tables]
        nfnetlink_rcv_batch+0x24c/0x620 [nfnetlink]
        nfnetlink_rcv+0x110/0x140 [nfnetlink]
        netlink_unicast+0x12c/0x1e0
 [..]
        sys_sendmsg+0x18/0x40
        linux_sparc_syscall+0x34/0x44
 -> #0 (&table[i].mutex){+.+.}:
 [..]
        nfnl_lock+0x24/0x40 [nfnetlink]
        ip_set_nfnl_get_byindex+0x19c/0x280 [ip_set]
        set_match_v1_checkentry+0x14/0xc0 [xt_set]
        xt_check_match+0x238/0x260 [x_tables]
        __nft_match_init+0x160/0x180 [nft_compat]
 [..]
        sys_sendmsg+0x18/0x40
        linux_sparc_syscall+0x34/0x44
 other info that might help us debug this:
  Possible unsafe locking scenario:
        CPU0                    CPU1
        ----                    ----
   lock(&net->nft.commit_mutex);
                                lock(&table[i].mutex);
                                lock(&net->nft.commit_mutex);
   lock(&table[i].mutex);

Lockdep considers this an ABBA deadlock because the different nfnl subsys
mutexes reside in the same lockdep class, but this is a false positive.

CPU1 table[i] refers to the nftables subsys mutex, whereas CPU1 locks
the ipset subsys mutex.

Yi Che reported a similar lockdep splat, this time between ipset and
ctnetlink subsys mutexes.

Time to place them in distinct classes to avoid these warnings.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 3a2e64e13b22..2daa1f6ae344 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -46,6 +46,23 @@ static struct {
 	const struct nfnetlink_subsystem __rcu	*subsys;
 } table[NFNL_SUBSYS_COUNT];
 
+static struct lock_class_key nfnl_lockdep_keys[NFNL_SUBSYS_COUNT];
+
+static const char *const nfnl_lockdep_names[NFNL_SUBSYS_COUNT] = {
+	[NFNL_SUBSYS_NONE] = "nfnl_subsys_none",
+	[NFNL_SUBSYS_CTNETLINK] = "nfnl_subsys_ctnetlink",
+	[NFNL_SUBSYS_CTNETLINK_EXP] = "nfnl_subsys_ctnetlink_exp",
+	[NFNL_SUBSYS_QUEUE] = "nfnl_subsys_queue",
+	[NFNL_SUBSYS_ULOG] = "nfnl_subsys_ulog",
+	[NFNL_SUBSYS_OSF] = "nfnl_subsys_osf",
+	[NFNL_SUBSYS_IPSET] = "nfnl_subsys_ipset",
+	[NFNL_SUBSYS_ACCT] = "nfnl_subsys_acct",
+	[NFNL_SUBSYS_CTNETLINK_TIMEOUT] = "nfnl_subsys_cttimeout",
+	[NFNL_SUBSYS_CTHELPER] = "nfnl_subsys_cthelper",
+	[NFNL_SUBSYS_NFTABLES] = "nfnl_subsys_nftables",
+	[NFNL_SUBSYS_NFT_COMPAT] = "nfnl_subsys_nftcompat",
+};
+
 static const int nfnl_group2type[NFNLGRP_MAX+1] = {
 	[NFNLGRP_CONNTRACK_NEW]		= NFNL_SUBSYS_CTNETLINK,
 	[NFNLGRP_CONNTRACK_UPDATE]	= NFNL_SUBSYS_CTNETLINK,
@@ -632,7 +649,7 @@ static int __init nfnetlink_init(void)
 		BUG_ON(nfnl_group2type[i] == NFNL_SUBSYS_NONE);
 
 	for (i=0; i<NFNL_SUBSYS_COUNT; i++)
-		mutex_init(&table[i].mutex);
+		__mutex_init(&table[i].mutex, nfnl_lockdep_names[i], &nfnl_lockdep_keys[i]);
 
 	return register_pernet_subsys(&nfnetlink_net_ops);
 }
-- 
2.26.2

