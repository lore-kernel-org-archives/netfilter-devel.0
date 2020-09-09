Return-Path: <SRS0=paBM=CS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58B2C433E2
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Sep 2020 09:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9651F21973
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Sep 2020 09:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgIIJo6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Sep 2020 05:44:58 -0400
Received: from correo.us.es ([193.147.175.20]:34972 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729161AbgIIJme (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Sep 2020 05:42:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EF3D82EFECE
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Sep 2020 11:42:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E37B8DA8EC
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Sep 2020 11:42:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D5918DA57A; Wed,  9 Sep 2020 11:42:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A98BDDA78D;
        Wed,  9 Sep 2020 11:42:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Sep 2020 11:42:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 738184301DE5;
        Wed,  9 Sep 2020 11:42:26 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/13] netfilter: conntrack: do not increment two error counters at same time
Date:   Wed,  9 Sep 2020 11:42:10 +0200
Message-Id: <20200909094219.17732-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200909094219.17732-1-pablo@netfilter.org>
References: <20200909094219.17732-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The /proc interface for nf_conntrack displays the "error" counter as
"icmp_error".

It makes sense to not increment "invalid" when failing to handle an icmp
packet since those are special.

For example, its possible for conntrack to see partial and/or fragmented
packets inside icmp errors.  This should be a separate event and not get
mixed with the "invalid" counter.

Likewise, remove the "error" increment for errors from get_l4proto().
After this, the error counter will only increment for errors coming from
icmp(v6) packet handling.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 5b97d233f89b..3cfbafdff941 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1725,10 +1725,8 @@ nf_conntrack_handle_icmp(struct nf_conn *tmpl,
 	else
 		return NF_ACCEPT;
 
-	if (ret <= 0) {
+	if (ret <= 0)
 		NF_CT_STAT_INC_ATOMIC(state->net, error);
-		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
-	}
 
 	return ret;
 }
@@ -1813,7 +1811,6 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 	dataoff = get_l4proto(skb, skb_network_offset(skb), state->pf, &protonum);
 	if (dataoff <= 0) {
 		pr_debug("not prepared to track yet or error occurred\n");
-		NF_CT_STAT_INC_ATOMIC(state->net, error);
 		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
 		ret = NF_ACCEPT;
 		goto out;
-- 
2.20.1

