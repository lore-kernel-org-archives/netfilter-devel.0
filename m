Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A76FEC433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 18:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A9EB20679
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 18:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfHMSie (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 14:38:34 -0400
Received: from correo.us.es ([193.147.175.20]:59038 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728678AbfHMSiY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 14:38:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CF1C4B6323
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 20:38:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C069E1150DD
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 20:38:21 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B44911150CE; Tue, 13 Aug 2019 20:38:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7CD2512D2;
        Tue, 13 Aug 2019 20:38:19 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 20:38:19 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 724D64265A2F;
        Tue, 13 Aug 2019 20:38:19 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 17/17] netfilter: connlabels: prefer static lock initialiser
Date:   Tue, 13 Aug 2019 20:38:09 +0200
Message-Id: <20190813183809.4081-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190813183809.4081-1-pablo@netfilter.org>
References: <20190813183809.4081-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

seen during boot:
BUG: spinlock bad magic on CPU#2, swapper/0/1
 lock: nf_connlabels_lock+0x0/0x60, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
Call Trace:
 do_raw_spin_lock+0x14e/0x1b0
 nf_connlabels_get+0x15/0x40
 ct_init_net+0xc4/0x270
 ops_init+0x56/0x1c0
 register_pernet_operations+0x1c8/0x350
 register_pernet_subsys+0x1f/0x40
 tcf_register_action+0x7c/0x1a0
 do_one_initcall+0x13d/0x2d9

Problem is that ct action init function can run before
connlabels_init().  Lock has not been initialised yet.

Fix it by using a static initialiser.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_labels.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index 74b8113f7aeb..d1c6b2a2e7bd 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -11,7 +11,7 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_labels.h>
 
-static spinlock_t nf_connlabels_lock;
+static __read_mostly DEFINE_SPINLOCK(nf_connlabels_lock);
 
 static int replace_u32(u32 *address, u32 mask, u32 new)
 {
@@ -89,7 +89,6 @@ int nf_conntrack_labels_init(void)
 {
 	BUILD_BUG_ON(NF_CT_LABELS_MAX_SIZE / sizeof(long) >= U8_MAX);
 
-	spin_lock_init(&nf_connlabels_lock);
 	return nf_ct_extend_register(&labels_extend);
 }
 
-- 
2.11.0


