From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 04/06: ctnetlink: fix sleep in read-side lock section
Date: Mon, 18 Aug 2008 18:51:54 +0200 (MEST)
Message-ID: <20080818165153.18978.28019.sendpatchset@localhost.localdomain>
References: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59345 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbYHRQvy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:51:54 -0400
In-Reply-To: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: ctnetlink: fix sleep in read-side lock section

Fix allocation with GFP_KERNEL in ctnetlink_create_conntrack() under
read-side lock sections.

This problem was introduced in 2.6.25.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3b198ff714ffc62115554f821e80f22d817b2b17
tree 48aa718f0375e5a110357682f789800c85516969
parent 4a58ff2a369c6020ece596812f819641f9d19820
author Pablo Neira Ayuso <pablo@netfilter.org> Mon, 18 Aug 2008 13:17:04 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 18 Aug 2008 13:17:04 +0200

 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d1fb2f8..a5b95cc 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1139,7 +1139,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 	rcu_read_lock();
 	helper = __nf_ct_helper_find(rtuple);
 	if (helper) {
-		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
+		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 		if (help == NULL) {
 			rcu_read_unlock();
 			err = -ENOMEM;
