From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 8/9] netfilter: ctnetlink: reject new conntrack request with different l4proto
Date: Wed, 10 Aug 2016 20:56:33 +0200
Message-ID: <1470855394-7234-9-git-send-email-pablo@netfilter.org>
References: <1470855394-7234-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54934 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938799AbcHJS4t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 14:56:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 66F0F1F18CD
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 20:56:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 56512100A65
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 20:56:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D2551100A5D
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 20:56:44 +0200 (CEST)
In-Reply-To: <1470855394-7234-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Currently, user can add a conntrack with different l4proto via nfnetlink.
For example, original tuple is TCP while reply tuple is SCTP. This is
invalid combination, we should report EINVAL to userspace.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b9bfe64..fdfc71f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1894,6 +1894,8 @@ static int ctnetlink_new_conntrack(struct net *net, struct sock *ctnl,
 
 			if (!cda[CTA_TUPLE_ORIG] || !cda[CTA_TUPLE_REPLY])
 				return -EINVAL;
+			if (otuple.dst.protonum != rtuple.dst.protonum)
+				return -EINVAL;
 
 			ct = ctnetlink_create_conntrack(net, &zone, cda, &otuple,
 							&rtuple, u3);
-- 
2.1.4

