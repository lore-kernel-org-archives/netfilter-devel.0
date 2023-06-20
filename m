Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EFCBEB64D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Jun 2023 16:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbjFTQFA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Jun 2023 12:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjFTQE7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jun 2023 12:04:59 -0400
X-Greylist: delayed 1201 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 20 Jun 2023 09:04:49 PDT
Received: from tretyak2.mcst.ru (tretyak2.mcst.ru [212.5.119.215])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6591F4;
        Tue, 20 Jun 2023 09:04:49 -0700 (PDT)
Received: from tretyak2.mcst.ru (localhost [127.0.0.1])
        by tretyak2.mcst.ru (Postfix) with ESMTP id E5BCF1023A3;
        Tue, 20 Jun 2023 18:27:39 +0300 (MSK)
Received: from frog.lab.sun.mcst.ru (frog.lab.sun.mcst.ru [176.16.4.50])
        by tretyak2.mcst.ru (Postfix) with ESMTP id DC62F102395;
        Tue, 20 Jun 2023 18:26:38 +0300 (MSK)
Received: from artemiev-i.lab.sun.mcst.ru (avior-1 [192.168.53.223])
        by frog.lab.sun.mcst.ru (8.13.4/8.12.11) with ESMTP id 35KFQceY023407;
        Tue, 20 Jun 2023 18:26:38 +0300
From:   Igor Artemiev <Igor.A.Artemiev@mcst.ru>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: [lvc-project] [PATCH] netfilter: ebtables: remove unnecessary NULL check
Date:   Tue, 20 Jun 2023 18:25:49 +0300
Message-Id: <20230620152549.2109063-1-Igor.A.Artemiev@mcst.ru>
X-Mailer: git-send-email 2.39.0.152.ga5737674b6
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.39/RELEASE,
         bases: 20111107 #2745587, check: 20230620 notchecked
X-AV-Checked: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In ebt_do_table() 'private->chainstack' cannot be NULL
and the 'cs' pointer is dereferenced below, so it does not make
sense to compare 'private->chainstack' with NULL. 

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Igor Artemiev <Igor.A.Artemiev@mcst.ru>
---
 net/bridge/netfilter/ebtables.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 757ec46fc45a..74daca8a5142 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -212,10 +212,7 @@ unsigned int ebt_do_table(void *priv, struct sk_buff *skb,
 	private = table->private;
 	cb_base = COUNTER_BASE(private->counters, private->nentries,
 	   smp_processor_id());
-	if (private->chainstack)
-		cs = private->chainstack[smp_processor_id()];
-	else
-		cs = NULL;
+	cs = private->chainstack[smp_processor_id()];
 	chaininfo = private->hook_entry[hook];
 	nentries = private->hook_entry[hook]->nentries;
 	point = (struct ebt_entry *)(private->hook_entry[hook]->data);
-- 
2.30.2

