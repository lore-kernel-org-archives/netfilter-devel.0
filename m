From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH net-next] nfnetlink_log: Use GFP_NOWARN for skb allocation
Date: Fri, 7 Oct 2016 14:02:16 -0700
Message-ID: <1b50152e3ea7c3e18995349126d4352e4fc73933.1475873569.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Calvin Owens <calvinowens@fb.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43920 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753989AbcJGVCV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2016 17:02:21 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u97Kwd5Q024665
        for <netfilter-devel@vger.kernel.org>; Fri, 7 Oct 2016 14:02:20 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 25xh87gmck-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Oct 2016 14:02:20 -0700
Received: from facebook.com (2401:db00:11:d0be:face:0:1b:0)     by
 mx-out.facebook.com (10.102.107.97) with ESMTP id
 55b203ae8cd111e6a4490002c99331b0-c51e3a50 for
 <netfilter-devel@vger.kernel.org>;     Fri, 07 Oct 2016 14:02:19 -0700
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since the code explicilty falls back to a smaller allocation when the
large one fails, we shouldn't complain when that happens.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 net/netfilter/nfnetlink_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index eb086a1..7435505 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -330,7 +330,7 @@ nfulnl_alloc_skb(struct net *net, u32 peer_portid, unsigned int inst_size,
 	 * message.  WARNING: has to be <= 128k due to slab restrictions */
 
 	n = max(inst_size, pkt_size);
-	skb = alloc_skb(n, GFP_ATOMIC);
+	skb = alloc_skb(n, GFP_ATOMIC | __GFP_NOWARN);
 	if (!skb) {
 		if (n > pkt_size) {
 			/* try to allocate only as much as we need for current
-- 
2.9.3

