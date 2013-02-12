From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] netfilter: ctnetlink: don't permit ct creation with random tuple
Date: Tue, 12 Feb 2013 10:22:38 +0100
Message-ID: <1360660958-29494-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38728 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932740Ab3BLJUq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Feb 2013 04:20:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Userspace can cause kernel panic by not specifying orig/reply
tuple: kernel will create a tuple with random stack values.

Problem is that tuple.dst.dir will be random, too, which
causes nf_ct_tuplehash_to_ctrack() to return garbage.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7bbfb3d..e592281 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1596,6 +1596,9 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		if (nlh->nlmsg_flags & NLM_F_CREATE) {
 			enum ip_conntrack_events events;
 
+			if (!cda[CTA_TUPLE_ORIG] ||
+			    !cda[CTA_TUPLE_REPLY])
+				return -EINVAL;
 			ct = ctnetlink_create_conntrack(net, zone, cda, &otuple,
 							&rtuple, u3);
 			if (IS_ERR(ct))
-- 
1.7.8.6

