From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 30/31] netns nat: fix NAT interaction with NOTRACK code
Date: Mon, 21 Jul 2008 20:57:04 +0400
Message-ID: <20080721165704.GP13390@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	dev@openvz.org, xemul@openvz.org, ebiederm@xmission.com,
	dlezcano@fr.ibm.com, benjamin.thery@bull.net
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:30031 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbYGUQ6w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:58:52 -0400
Received: by fg-out-1718.google.com with SMTP id 19so691519fgg.17
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Jul 2008 09:58:50 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When NAT module loads, set NAT-done flag for untracked conntrack in
every netns.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/ipv4/netfilter/nf_nat_core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -588,6 +588,10 @@ static int __net_init nf_nat_net_init(struct net *net)
 						      &net->ipv4.nat_vmalloced);
 	if (!net->ipv4.nat_bysource)
 		return -ENOMEM;
+
+	/* Initialize fake conntrack so that NAT will skip it */
+	net->ct.untracked.status |= IPS_NAT_DONE_MASK;
+
 	return 0;
 }
 
@@ -645,9 +649,6 @@ static int __init nf_nat_init(void)
 	rcu_assign_pointer(nf_nat_protos[IPPROTO_ICMP], &nf_nat_protocol_icmp);
 	spin_unlock_bh(&nf_nat_lock);
 
-	/* Initialize fake conntrack so that NAT will skip it */
-	init_net.ct.untracked.status |= IPS_NAT_DONE_MASK;
-
 	l3proto = nf_ct_l3proto_find_get((u_int16_t)AF_INET);
 
 	BUG_ON(nf_nat_seq_adjust_hook != NULL);
-- 
1.5.4.5


