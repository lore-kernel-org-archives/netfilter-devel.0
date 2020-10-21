Return-Path: <SRS0=Y5HT=D4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D780C4363A
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Oct 2020 11:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B884821741
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Oct 2020 11:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439262AbgJULFw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Oct 2020 07:05:52 -0400
Received: from correo.us.es ([193.147.175.20]:55682 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438908AbgJULFw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Oct 2020 07:05:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 44CF9DE3851
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2020 13:05:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37CC34DE7A
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2020 13:05:51 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2CBF93491; Wed, 21 Oct 2020 13:05:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0203DFF135
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2020 13:05:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 21 Oct 2020 13:05:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id E09B24301DE2
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2020 13:05:48 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2] netfilter: nf_dup_netdev: clear timestamp in forwarding path
Date:   Wed, 21 Oct 2020 13:05:45 +0200
Message-Id: <20201021110545.9771-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Similar to 7980d2eabde8 ("ipvs: clear skb->tstamp in forwarding path").
fq qdisc requires tstamp to be cleared in forwarding path.

Fixes: 8203e2d844d3 ("net: clear skb->tstamp in forwarding paths")
Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")
Fixes: 80b14dee2bea ("net: Add a new socket option for a future transmit time.")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_dup_netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 2b01a151eaa8..a579e59ee5c5 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -19,6 +19,7 @@ static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev)
 		skb_push(skb, skb->mac_len);
 
 	skb->dev = dev;
+	skb->tstamp = 0;
 	dev_queue_xmit(skb);
 }
 
-- 
2.20.1

