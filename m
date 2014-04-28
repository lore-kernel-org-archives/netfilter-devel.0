From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: ctnetlink: don't add null bindings if no nat requested
Date: Mon, 28 Apr 2014 21:07:31 +0200
Message-ID: <1398712051-1684-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47138 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932085AbaD1TMm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:12:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 0eba801b64cc8284d9024c7ece30415a2b981a72 tried to fix a race
where nat initialisation can happen after ctnetlink-created conntrack
has been created.

However, it causes the nat module(s) to be loaded needlessly on
systems that are not using NAT.

Fortunately, we do not have to create null bindings in that case.

conntracks injected via ctnetlink always have the CONFIRMED bit set,
which prevents addition of the nat extension in nf_nat_ipv4/6_fn().

We only need to make sure that either no nat extension is added
or that we've created both src and dst manips.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ccc46fa..5857963 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1336,6 +1336,9 @@ ctnetlink_setup_nat(struct nf_conn *ct, const struct nlattr * const cda[])
 #ifdef CONFIG_NF_NAT_NEEDED
 	int ret;
 
+	if (!cda[CTA_NAT_DST] && !cda[CTA_NAT_SRC])
+		return 0;
+
 	ret = ctnetlink_parse_nat_setup(ct, NF_NAT_MANIP_DST,
 					cda[CTA_NAT_DST]);
 	if (ret < 0)
-- 
1.8.1.5

