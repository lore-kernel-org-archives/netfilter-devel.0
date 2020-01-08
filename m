Return-Path: <SRS0=uN83=25=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDE0C282DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 23:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E16220692
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 23:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbgAHXRd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jan 2020 18:17:33 -0500
Received: from correo.us.es ([193.147.175.20]:43172 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbgAHXR0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jan 2020 18:17:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D7B49FF9BA
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 00:17:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CCDB4DA70F
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 00:17:24 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C2B3FDA709; Thu,  9 Jan 2020 00:17:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B1ACFDA705;
        Thu,  9 Jan 2020 00:17:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 09 Jan 2020 00:17:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8DBCA426CCB9;
        Thu,  9 Jan 2020 00:17:22 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 9/9] netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO is present
Date:   Thu,  9 Jan 2020 00:17:13 +0100
Message-Id: <20200108231713.100458-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200108231713.100458-1-pablo@netfilter.org>
References: <20200108231713.100458-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The set uadt functions assume lineno is never NULL, but it is in
case of ip_set_utest().

syzkaller managed to generate a netlink message that calls this with
LINENO attr present:

general protection fault: 0000 [#1] PREEMPT SMP KASAN
RIP: 0010:hash_mac4_uadt+0x1bc/0x470 net/netfilter/ipset/ip_set_hash_mac.c:104
Call Trace:
 ip_set_utest+0x55b/0x890 net/netfilter/ipset/ip_set_core.c:1867
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563

pass a dummy lineno storage, its easier than patching all set
implementations.

This seems to be a day-0 bug.

Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Reported-by: syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com
Fixes: a7b4f989a6294 ("netfilter: ipset: IP set core support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 169e0a04f814..cf895bc80871 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1848,6 +1848,7 @@ static int ip_set_utest(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 	struct ip_set *set;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX + 1] = {};
 	int ret = 0;
+	u32 lineno;
 
 	if (unlikely(protocol_min_failed(attr) ||
 		     !attr[IPSET_ATTR_SETNAME] ||
@@ -1864,7 +1865,7 @@ static int ip_set_utest(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 		return -IPSET_ERR_PROTOCOL;
 
 	rcu_read_lock_bh();
-	ret = set->variant->uadt(set, tb, IPSET_TEST, NULL, 0, 0);
+	ret = set->variant->uadt(set, tb, IPSET_TEST, &lineno, 0, 0);
 	rcu_read_unlock_bh();
 	/* Userspace can't trigger element to be re-added */
 	if (ret == -EAGAIN)
-- 
2.11.0

