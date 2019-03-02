Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6081CC43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FC0320838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfCBShu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:37:50 -0500
Received: from mail.us.es ([193.147.175.20]:36412 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727214AbfCBShe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:37:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1EBFB1361B4
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:37:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A3BEDA864
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:37:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F3E66DA85D; Sat,  2 Mar 2019 19:37:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A67FDA863;
        Sat,  2 Mar 2019 19:37:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:37:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A14E84265A2F;
        Sat,  2 Mar 2019 19:37:30 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 25/29] netfilter: nf_conntrack: ensure that CONNTRACK_LOCKS is power of 2
Date:   Sat,  2 Mar 2019 19:37:16 +0100
Message-Id: <20190302183720.3220-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183720.3220-1-pablo@netfilter.org>
References: <20190302183720.3220-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

CONNTRACK_LOCKS is divisor when computer array index, if it is power of
2, compiler will optimize modulo operation as bitwise AND, or else
modulo will lower performance.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ff9313c579b4..82bfbeef46af 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2480,6 +2480,7 @@ int nf_conntrack_init_net(struct net *net)
 	int cpu;
 
 	BUILD_BUG_ON(IP_CT_UNTRACKED == IP_CT_NUMBER);
+	BUILD_BUG_ON_NOT_POWER_OF_2(CONNTRACK_LOCKS);
 	atomic_set(&net->ct.count, 0);
 
 	net->ct.pcpu_lists = alloc_percpu(struct ct_pcpu);
-- 
2.11.0


