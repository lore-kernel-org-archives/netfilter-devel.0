From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 05/06: ctnetlink: sleepable allocation with spin lock bh
Date: Mon, 18 Aug 2008 18:51:55 +0200 (MEST)
Message-ID: <20080818165154.18978.78109.sendpatchset@localhost.localdomain>
References: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59355 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbYHRQv4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:51:56 -0400
In-Reply-To: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: ctnetlink: sleepable allocation with spin lock bh

This patch removes a GFP_KERNEL allocation while holding a spin lock with
bottom halves disabled in ctnetlink_change_helper().

This problem was introduced in 2.6.23 with the netfilter extension
infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit be6e3721aa813e40f20d84d7925f9cf5cd8eef2d
tree ef2d78c9f5567c3a060b1d19f0b366726f6adf74
parent 3b198ff714ffc62115554f821e80f22d817b2b17
author Pablo Neira Ayuso <pablo@netfilter.org> Mon, 18 Aug 2008 13:17:04 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 18 Aug 2008 13:17:04 +0200

 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a5b95cc..a875203 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -968,7 +968,7 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nlattr *cda[])
 		/* need to zero data of old helper */
 		memset(&help->help, 0, sizeof(help->help));
 	} else {
-		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
+		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 		if (help == NULL)
 			return -ENOMEM;
 	}
