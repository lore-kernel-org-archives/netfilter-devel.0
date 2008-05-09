From: Eric Leblond <eric@inl.fr>
Subject: [RFC, PATCH] Dump conntrack ID in event messages.
Date: Fri,  9 May 2008 21:24:34 +0200
Message-ID: <1210361074-7548-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:52835 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764273AbYEITYf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2008 15:24:35 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Conntrack ID is not put (anymore ?) in event messages. This causes current ulogd2
code to fail because it uses the ID to build a hash in userspace. This hash is
used to be able to output the starting time of a connection.

Conntrack ID can be used in userspace application to maintain an easy match
between kernel connections list and userspace one. It may worth to add it if
there is no performance related issue.

BR,

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/netfilter/nf_conntrack_netlink.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 16774ec..0edefcf 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -472,6 +472,9 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 
+	if (ctnetlink_dump_id(skb, ct) < 0)
+		goto nla_put_failure;
+
 	if (events & IPCT_DESTROY) {
 		if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
 		    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
-- 
1.5.4.3

