Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C64AC3A5AB
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 19:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E71FB22CED
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 19:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732542AbfIDThF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 15:37:05 -0400
Received: from correo.us.es ([193.147.175.20]:37928 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731819AbfIDThC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 15:37:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D6367303D07
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Sep 2019 21:36:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB0312DC7B
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Sep 2019 21:36:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C0AA5DA840; Wed,  4 Sep 2019 21:36:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B602CB8001;
        Wed,  4 Sep 2019 21:36:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Sep 2019 21:36:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 871624265A5A;
        Wed,  4 Sep 2019 21:36:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/5] netfilter: ctnetlink: honor IPS_OFFLOAD flag
Date:   Wed,  4 Sep 2019 21:36:45 +0200
Message-Id: <20190904193646.23830-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190904193646.23830-1-pablo@netfilter.org>
References: <20190904193646.23830-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If this flag is set, timeout and state are irrelevant to userspace.

Fixes: 90964016e5d3 ("netfilter: nf_conntrack: add IPS_OFFLOAD status bit")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6aa01eb6fe99..e2d13cd18875 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -553,10 +553,8 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 		goto nla_put_failure;
 
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_timeout(skb, ct) < 0 ||
 	    ctnetlink_dump_acct(skb, ct, type) < 0 ||
 	    ctnetlink_dump_timestamp(skb, ct) < 0 ||
-	    ctnetlink_dump_protoinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_mark(skb, ct) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
@@ -568,6 +566,11 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	    ctnetlink_dump_ct_synproxy(skb, ct) < 0)
 		goto nla_put_failure;
 
+	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status) &&
+	    (ctnetlink_dump_timeout(skb, ct) < 0 ||
+	     ctnetlink_dump_protoinfo(skb, ct) < 0))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return skb->len;
 
-- 
2.11.0

