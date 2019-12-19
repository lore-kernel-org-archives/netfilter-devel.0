Return-Path: <SRS0=pcvh=2J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1285C43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 22:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD204227BF
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 22:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfLSWSV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 17:18:21 -0500
Received: from correo.us.es ([193.147.175.20]:38326 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbfLSWSV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 17:18:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 74CE8ED5C3
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Dec 2019 23:18:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F84FDA70B
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Dec 2019 23:18:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 551A9DA709; Thu, 19 Dec 2019 23:18:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CC179DA705;
        Thu, 19 Dec 2019 23:18:15 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Dec 2019 23:18:15 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id ACC064265A5A;
        Thu, 19 Dec 2019 23:18:15 +0100 (CET)
Date:   Thu, 19 Dec 2019 23:18:16 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2 1/3] netfilter: nf_flow_table_offload: fix
 dst_neigh lookup
Message-ID: <20191219221816.rywke7de6izqrere@salvia>
References: <1576572767-19779-1-git-send-email-wenxu@ucloud.cn>
 <1576572767-19779-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="oml6zc4qn5a2zgkr"
Content-Disposition: inline
In-Reply-To: <1576572767-19779-2-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--oml6zc4qn5a2zgkr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2019 at 04:52:45PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Get the dst_neigh through dst_ip, The dst_ip should get
> through peer tuple.src_v4 fix for dnat case.

Please, revamp patch description:

        netfilter: nf_flow_table_offload: fix incorrect ethernet dst address

Proposed description:

        original:       A -> FW
        reply:          B -> A

        Traffic going in original direction uses address B as
        destination. Traffic going in reply direction uses address A
        as destination.

I'd suggest a more simplified patch, attached.

--oml6zc4qn5a2zgkr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 506aaaf8151d..8680fc56cd7c 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -156,14 +156,14 @@ static int flow_offload_eth_dst(struct net *net,
 				enum flow_offload_tuple_dir dir,
 				struct nf_flow_rule *flow_rule)
 {
-	const struct flow_offload_tuple *tuple = &flow->tuplehash[dir].tuple;
+	const struct flow_offload_tuple *tuple = &flow->tuplehash[!dir].tuple;
 	struct flow_action_entry *entry0 = flow_action_entry_next(flow_rule);
 	struct flow_action_entry *entry1 = flow_action_entry_next(flow_rule);
 	struct neighbour *n;
 	u32 mask, val;
 	u16 val16;
 
-	n = dst_neigh_lookup(tuple->dst_cache, &tuple->dst_v4);
+	n = dst_neigh_lookup(tuple->dst_cache, &tuple->src_v4);
 	if (!n)
 		return -ENOENT;
 

--oml6zc4qn5a2zgkr--
