Return-Path: <SRS0=0f1v=RX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF023C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 07:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5F1C2184D
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 07:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfCTHk6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 03:40:58 -0400
Received: from mail.us.es ([193.147.175.20]:58786 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfCTHk6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 03:40:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A2464E2D86
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 08:40:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B409132C8C
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 08:40:55 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 808DF132C89; Wed, 20 Mar 2019 08:40:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EE9A132C8B
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 08:40:53 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 Mar 2019 08:40:53 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.hhotels.local (148.160.broadband14.iol.cz [90.181.160.148])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5F8294265A4E
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 08:40:53 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_flowtable: skip device lookup from interface index
Date:   Wed, 20 Mar 2019 08:40:47 +0100
Message-Id: <20190320074047.7754-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the output device from the route that we cache in the flowtable
entry.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 1d291a51cd45..6452550d187f 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -235,13 +235,10 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (tuplehash == NULL)
 		return NF_ACCEPT;
 
-	outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.oifidx);
-	if (!outdev)
-		return NF_ACCEPT;
-
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
+	outdev = rt->dst.dev;
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)) &&
 	    (ip_hdr(skb)->frag_off & htons(IP_DF)) != 0)
@@ -452,13 +449,10 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (tuplehash == NULL)
 		return NF_ACCEPT;
 
-	outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.oifidx);
-	if (!outdev)
-		return NF_ACCEPT;
-
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	rt = (struct rt6_info *)flow->tuplehash[dir].tuple.dst_cache;
+	outdev = rt->dst.dev;
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
-- 
2.11.0

