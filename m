From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [-stable-3.8.y 7/9] netfilter: ctnetlink: don't permit ct creation with random tuple
Date: Tue,  7 May 2013 01:05:26 +0200
Message-ID: <1367881528-15524-7-git-send-email-pablo@netfilter.org>
References: <1367881528-15524-1-git-send-email-pablo@netfilter.org>
Cc: stable@vger.kernel.org, davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52143 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759801Ab3EFXGC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 May 2013 19:06:02 -0400
In-Reply-To: <1367881528-15524-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

Userspace can cause kernel panic by not specifying orig/reply
tuple: kernel will create a tuple with random stack values.

Problem is that tuple.dst.dir will be random, too, which
causes nf_ct_tuplehash_to_ctrack() to return garbage.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@gnumonks.org>

[ git cherry-pick 442fad9 ]
---
 net/netfilter/nf_conntrack_netlink.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 627b0e5..a081915 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1705,6 +1705,9 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		if (nlh->nlmsg_flags & NLM_F_CREATE) {
 			enum ip_conntrack_events events;
 
+			if (!cda[CTA_TUPLE_ORIG] || !cda[CTA_TUPLE_REPLY])
+				return -EINVAL;
+
 			ct = ctnetlink_create_conntrack(net, zone, cda, &otuple,
 							&rtuple, u3);
 			if (IS_ERR(ct))
-- 
1.7.10.4

