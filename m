Return-Path: <SRS0=ntVu=Z7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3894BC2D0BE
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 19:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08DE5205ED
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 19:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfLIT1d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Dec 2019 14:27:33 -0500
Received: from correo.us.es ([193.147.175.20]:58466 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726856AbfLIT0y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 14:26:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4CB8F12085A
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2019 20:26:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4028CDA712
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2019 20:26:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 34738DA70B; Mon,  9 Dec 2019 20:26:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2EA22DA70B;
        Mon,  9 Dec 2019 20:26:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Dec 2019 20:26:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id EAB4F41E4800;
        Mon,  9 Dec 2019 20:26:47 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 07/17] netfilter: nf_tables_offload: Check for the NETDEV_UNREGISTER event
Date:   Mon,  9 Dec 2019 20:26:28 +0100
Message-Id: <20191209192638.71184-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191209192638.71184-1-pablo@netfilter.org>
References: <20191209192638.71184-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Check for the NETDEV_UNREGISTER event from the nft_offload_netdev_event
function, which is the event that actually triggers the clean up.

Fixes: 06d392cbe3db ("netfilter: nf_tables_offload: remove rules when the device unregisters")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 68f17a6921d8..d7a35da008ef 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -577,6 +577,9 @@ static int nft_offload_netdev_event(struct notifier_block *this,
 	struct net *net = dev_net(dev);
 	struct nft_chain *chain;
 
+	if (event != NETDEV_UNREGISTER)
+		return NOTIFY_DONE;
+
 	mutex_lock(&net->nft.commit_mutex);
 	chain = __nft_offload_get_chain(dev);
 	if (chain)
-- 
2.11.0

