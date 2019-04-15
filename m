Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CB2C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EA892075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbfDORAu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:00:50 -0400
Received: from mail.us.es ([193.147.175.20]:50436 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727912AbfDORAt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 741BE1C4435
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 579F5DA714
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5608FDA710; Mon, 15 Apr 2019 19:00:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30115DA717;
        Mon, 15 Apr 2019 19:00:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E930C4265A31;
        Mon, 15 Apr 2019 19:00:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 22/22] bridge: only include nf_queue.h if needed
Date:   Mon, 15 Apr 2019 19:00:28 +0200
Message-Id: <20190415170028.3470-23-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

After merging the netfilter-next tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

In file included from net/bridge/br_input.c:19:
include/net/netfilter/nf_queue.h:16:23: error: field 'state' has incomplete type
  struct nf_hook_state state;
                       ^~~~~

Fixes: 971502d77faa ("bridge: netfilter: unroll NF_HOOK helper in bridge input path")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/br_input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index e0aacfedcfe1..86dc46f6a68f 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -16,7 +16,9 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/netfilter_bridge.h>
+#ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
 #include <net/netfilter/nf_queue.h>
+#endif
 #include <linux/neighbour.h>
 #include <net/arp.h>
 #include <linux/export.h>
-- 
2.11.0

