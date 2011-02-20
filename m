From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 2/2] netfilter: ctnetlink: fix missing refcount increment
 during dumps
Date: Sun, 20 Feb 2011 12:51:31 -0800
Message-ID: <20110220125131.435737b4@nehalam>
References: <20110123231602.3383.31480.stgit@decadence>
 <20110220124814.2e89da91@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, kaber@trash.net, stable@kernel.org
To: Greg KH <greg@kroah.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:60469 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab1BTUvn convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Feb 2011 15:51:43 -0500
In-Reply-To: <20110220124814.2e89da91@nehalam>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>From Pablo Neira Ayuso <pablo@netfilter.org>

In 13ee6ac netfilter: fix race in conntrack between dump_table and
destroy, we recovered spinlocks to protect the dump of the conntrack
table according to reports from Stephen and acknowledgments on the
issue from Eric.

In that patch, the refcount bump that allows to keep a reference
to the current ct object was removed. However, we still decrement
the refcount for that object in the output path of
ctnetlink_dump_table():

        if (last)
                nf_ct_put(last)

Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
(cherry picked from commit c71caf4114a0e1da3451cc92fba6a152929cd4c2)
---
 Patch against v2.6.37.1

 net/netfilter/nf_conntrack_netlink.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d57dcdb..742a6dc 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -664,6 +664,7 @@ restart:
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
 						cb->nlh->nlmsg_seq,
 						IPCTNL_MSG_CT_NEW, ct) < 0) {
+				nf_conntrack_get(&ct->ct_general);
 				cb->args[1] = (unsigned long)ct;
 				goto out;
 			}
-- 
1.7.1

