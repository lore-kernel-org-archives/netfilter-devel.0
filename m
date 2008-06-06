From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 09/11: ctnetlink: include conntrack status in destroy event message
Date: Fri,  6 Jun 2008 17:17:59 +0200 (MEST)
Message-ID: <20080606151758.25286.44553.sendpatchset@localhost.localdomain>
References: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48158 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160AbYFFPSB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:18:01 -0400
In-Reply-To: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: ctnetlink: include conntrack status in destroy event message

When a conntrack is destroyed, the connection status does not get
exported to netlink. I don't see a reason for not doing so. This patch
exports the status on all conntrack events.

Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ddafe2d8dec88f9fb0c9de1f9eea0dd994d97a95
tree 671e33e68095744e53d9592395c0f3b4d5cf9692
parent 1b6e77c24870f9932eacedb0e59a3182711b1980
author Fabian Hugelshofer <hugelshofer2006@gmx.ch> Fri, 06 Jun 2008 17:11:05 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 06 Jun 2008 17:11:05 +0200

 net/netfilter/nf_conntrack_netlink.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ab655f6..63c4e1f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -475,14 +475,14 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 	if (ctnetlink_dump_id(skb, ct) < 0)
 		goto nla_put_failure;
 
+	if (ctnetlink_dump_status(skb, ct) < 0)
+		goto nla_put_failure;
+
 	if (events & IPCT_DESTROY) {
 		if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
 		    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
 			goto nla_put_failure;
 	} else {
-		if (ctnetlink_dump_status(skb, ct) < 0)
-			goto nla_put_failure;
-
 		if (ctnetlink_dump_timeout(skb, ct) < 0)
 			goto nla_put_failure;
 
