Return-Path: <SRS0=O/k4=YS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37ECBCA9EBD
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Oct 2019 14:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EDC020663
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Oct 2019 14:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572012427;
	bh=ZZjjnG3npdaGzZzxef3vjTrq7vHubzzO5lJ6IcAPVKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0jDy4730LbrMJ+P9TdlxHvBYffMfHVlFoaWlMLqiqjrT7h/DpwX/5096tGNPOUEiV
	 v5X0O1jCG2OEqFaXvw34r/+aVnRKWqk4QL3rp7zimx9SFOZOpuQptnmgKwSk7uliNL
	 H5XmopOqlE//AoVxESDQ+JLBd7An8WyaOSWQul8s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505114AbfJYNzg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Oct 2019 09:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505101AbfJYNzf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Oct 2019 09:55:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7234222BD;
        Fri, 25 Oct 2019 13:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011734;
        bh=ZZjjnG3npdaGzZzxef3vjTrq7vHubzzO5lJ6IcAPVKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNSG62Phu14zNrKY4EJOnALBH7CTO63QES+mP8l0NAXA2N92+CEWj0M8VslHDRE0T
         DsaxTk67I4v2lMJMRXFpE8KfhI126A+yHg89JT+4o7wq9oFxy3ktn52CgGVLfMEQCP
         /2tjF1cTebVqgDn5wq9K9/R6UHmMzst3gC1RbN/Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 16/33] netfilter: connlabels: prefer static lock initialiser
Date:   Fri, 25 Oct 2019 09:54:48 -0400
Message-Id: <20191025135505.24762-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135505.24762-1-sashal@kernel.org>
References: <20191025135505.24762-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 105333435b4f3b21ffc325f32fae17719310db64 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_labels.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index 74b8113f7aebe..d1c6b2a2e7bd1 100644
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
2.20.1

