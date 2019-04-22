Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA8A6C10F11
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8178B20859
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbfDVUsL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 16:48:11 -0400
Received: from mail.us.es ([193.147.175.20]:46694 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728747AbfDVUsK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 16:48:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 013AD443824
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 22:48:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E59F2DA70E
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 22:48:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D818DDA70B; Mon, 22 Apr 2019 22:48:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D424BDA708;
        Mon, 22 Apr 2019 22:48:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Apr 2019 22:48:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A8B244265A32;
        Mon, 22 Apr 2019 22:48:06 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/10] netfilter: conntrack: initialize ct->timeout
Date:   Mon, 22 Apr 2019 22:47:54 +0200
Message-Id: <20190422204801.26321-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190422204801.26321-1-pablo@netfilter.org>
References: <20190422204801.26321-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Alexander Potapenko <glider@google.com>

KMSAN started reporting an error when accessing ct->timeout for the
first time without initialization:

 BUG: KMSAN: uninit-value in __nf_ct_refresh_acct+0x1ae/0x470 net/netfilter/nf_conntrack_core.c:1765
 ...
 dump_stack+0x173/0x1d0 lib/dump_stack.c:113
 kmsan_report+0x131/0x2a0 mm/kmsan/kmsan.c:624
 __msan_warning+0x7a/0xf0 mm/kmsan/kmsan_instr.c:310
 __nf_ct_refresh_acct+0x1ae/0x470 net/netfilter/nf_conntrack_core.c:1765
 nf_ct_refresh_acct ./include/net/netfilter/nf_conntrack.h:201
 nf_conntrack_udp_packet+0xb44/0x1040 net/netfilter/nf_conntrack_proto_udp.c:122
 nf_conntrack_handle_packet net/netfilter/nf_conntrack_core.c:1605
 nf_conntrack_in+0x1250/0x26c9 net/netfilter/nf_conntrack_core.c:1696
 ...
 Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:205
 kmsan_internal_poison_shadow+0x92/0x150 mm/kmsan/kmsan.c:159
 kmsan_kmalloc+0xa9/0x130 mm/kmsan/kmsan_hooks.c:173
 kmem_cache_alloc+0x554/0xb10 mm/slub.c:2789
 __nf_conntrack_alloc+0x16f/0x690 net/netfilter/nf_conntrack_core.c:1342
 init_conntrack+0x6cb/0x2490 net/netfilter/nf_conntrack_core.c:1421

Signed-off-by: Alexander Potapenko <glider@google.com>
Fixes: cc16921351d8ba1 ("netfilter: conntrack: avoid same-timeout update")
Cc: Florian Westphal <fw@strlen.de>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 82bfbeef46af..a137d4e7f218 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1350,6 +1350,7 @@ __nf_conntrack_alloc(struct net *net,
 	/* save hash for reusing when confirming */
 	*(unsigned long *)(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode.pprev) = hash;
 	ct->status = 0;
+	ct->timeout = 0;
 	write_pnet(&ct->ct_net, net);
 	memset(&ct->__nfct_init_offset[0], 0,
 	       offsetof(struct nf_conn, proto) -
-- 
2.11.0

