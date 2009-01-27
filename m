From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: ctnetlink: fix echo if not subscribed to any
	multicast group
Date: Tue, 27 Jan 2009 22:15:19 +0100
Message-ID: <20090127211519.10412.96490.stgit@Decadence>
References: <20090127211457.10412.29085.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60066 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753130AbZA0VPr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:15:47 -0500
In-Reply-To: <20090127211457.10412.29085.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes echoing if the socket that has sent the request to
create/update/delete an entry is not subscribed to any multicast
group. With the current code, ctnetlink would not send the echo
message via unicast as nfnetlink_send() would be skip.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2424005..132207f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -535,7 +535,7 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 	} else
 		return NOTIFY_DONE;
 
-	if (!nfnetlink_has_listeners(group))
+	if (!item->report && !nfnetlink_has_listeners(group))
 		return NOTIFY_DONE;
 
 	skb = alloc_skb(ctnetlink_calculate_room_size(ct, events), GFP_ATOMIC);
@@ -1609,7 +1609,8 @@ static int ctnetlink_expect_event(struct notifier_block *this,
 	} else
 		return NOTIFY_DONE;
 
-	if (!nfnetlink_has_listeners(NFNLGRP_CONNTRACK_EXP_NEW))
+	if (!item->report &&
+	    !nfnetlink_has_listeners(NFNLGRP_CONNTRACK_EXP_NEW))
 		return NOTIFY_DONE;
 
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);

