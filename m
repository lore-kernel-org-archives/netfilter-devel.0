Return-Path: <SRS0=uYLw=7H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA56CC433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 21:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD60120776
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 21:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389373AbgEYVya (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 May 2020 17:54:30 -0400
Received: from correo.us.es ([193.147.175.20]:47316 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388613AbgEYVy3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 May 2020 17:54:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BE9BFF8EF6
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 23:54:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA3AADA716
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 23:54:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9EE65DA712; Mon, 25 May 2020 23:54:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85E10DA701;
        Mon, 25 May 2020 23:54:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 May 2020 23:54:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 50BC742EE38E;
        Mon, 25 May 2020 23:54:25 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 2/5] netfilter: ipset: Fix subcounter update skip
Date:   Mon, 25 May 2020 23:54:17 +0200
Message-Id: <20200525215420.2290-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200525215420.2290-1-pablo@netfilter.org>
References: <20200525215420.2290-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

If IPSET_FLAG_SKIP_SUBCOUNTER_UPDATE is set, user requested to not
update counters in sub sets. Therefore IPSET_FLAG_SKIP_COUNTER_UPDATE
must be set, not unset.

Fixes: 6e01781d1c80e ("netfilter: ipset: set match: add support to match the counters")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_list_set.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index cd747c0962fd..5a67f7966574 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -59,7 +59,7 @@ list_set_ktest(struct ip_set *set, const struct sk_buff *skb,
 	/* Don't lookup sub-counters at all */
 	opt->cmdflags &= ~IPSET_FLAG_MATCH_COUNTERS;
 	if (opt->cmdflags & IPSET_FLAG_SKIP_SUBCOUNTER_UPDATE)
-		opt->cmdflags &= ~IPSET_FLAG_SKIP_COUNTER_UPDATE;
+		opt->cmdflags |= IPSET_FLAG_SKIP_COUNTER_UPDATE;
 	list_for_each_entry_rcu(e, &map->members, list) {
 		ret = ip_set_test(e->id, skb, par, opt);
 		if (ret <= 0)
-- 
2.20.1

