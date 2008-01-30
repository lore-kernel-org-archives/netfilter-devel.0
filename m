From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 33/69]: nf_conntrack_netlink: fix unbalanced locking
Date: Wed, 30 Jan 2008 21:17:45 +0100 (MET)
Message-ID: <20080130201743.29874.42569.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60716 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761724AbYA3URq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:46 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_netlink: fix unbalanced locking

Properly drop nf_conntrack_lock on tuple parsing error.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9813002a577062723e68ac1da712de25f7998f1e
tree 3e9798a85beddb21ab8410d63050fa0567dfd6f4
parent ec8971e984194b97af037d06dc40a23f9581276b
author Patrick McHardy <kaber@trash.net> Tue, 29 Jan 2008 16:22:10 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:05 +0100

 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 38141f1..bdae292 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1237,7 +1237,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 						    CTA_TUPLE_MASTER,
 						    u3);
 			if (err < 0)
-				return err;
+				goto out_unlock;
 
 			master_h = __nf_conntrack_find(&master, NULL);
 			if (master_h == NULL) {
