Return-Path: <SRS0=Y5HT=D4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908F8C4363A
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Oct 2020 11:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FB2C21707
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Oct 2020 11:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439262AbgJULCH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Oct 2020 07:02:07 -0400
Received: from correo.us.es ([193.147.175.20]:51600 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439234AbgJULCH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Oct 2020 07:02:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BCFBDD9AD6D
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2020 13:02:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFFF1FF138
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2020 13:02:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AF11FFF135; Wed, 21 Oct 2020 13:02:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56B8A78420
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2020 13:02:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 21 Oct 2020 13:02:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 384FD4301DE0
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2020 13:02:04 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_dup_netdev: clear timestamp in forwarding path
Date:   Wed, 21 Oct 2020 13:02:00 +0200
Message-Id: <20201021110200.31985-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Similar to 7980d2eabde8 ("ipvs: clear skb->tstamp in forwarding path").
fq qdisc requires tstamp to be cleared in forwarding path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_dup_netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 2b01a151eaa8..a3d2e1e176e3 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -19,6 +19,7 @@ static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev)
 		skb_push(skb, skb->mac_len);
 
 	skb->dev = dev;
+	skb->timestamp = 0;
 	dev_queue_xmit(skb);
 }
 
-- 
2.20.1

