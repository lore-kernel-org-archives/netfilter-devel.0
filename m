From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/8] netfilter: ipset: Fix static checker warning in ip_set_core.c
Date: Mon, 15 Sep 2014 23:02:47 +0200
Message-ID: <1410814974-9918-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1410814974-9918-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:39085 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725AbaIOVCh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:02:37 -0400
In-Reply-To: <1410814974-9918-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dan Carpenter reported the following static checker warning:

        net/netfilter/ipset/ip_set_core.c:1414 call_ad()
        error: 'nlh->nlmsg_len' from user is not capped properly

The payload size is limited now by the max size of size_t.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 5593e97..4ca4e5c 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1397,7 +1397,8 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 		struct nlmsghdr *rep, *nlh = nlmsg_hdr(skb);
 		struct sk_buff *skb2;
 		struct nlmsgerr *errmsg;
-		size_t payload = sizeof(*errmsg) + nlmsg_len(nlh);
+		size_t payload = min(SIZE_MAX,
+				     sizeof(*errmsg) + nlmsg_len(nlh));
 		int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
 		struct nlattr *cda[IPSET_ATTR_CMD_MAX+1];
 		struct nlattr *cmdattr;
-- 
1.8.5.1

