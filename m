From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 35/79: netns nf_conntrack: SIP conntracking in netns
Date: Wed,  8 Oct 2008 12:47:08 +0200 (MEST)
Message-ID: <20081008104708.10423.98705.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45966 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbYJHKrJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:09 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit a5c3a8005cb7a36ebcc5b849f6045069ce4f7ca8
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Oct 8 11:35:09 2008 +0200

    netfilter: netns nf_conntrack: SIP conntracking in netns
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index a006080..6813f1c 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -736,6 +736,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 	struct nf_conntrack_expect *exp, *rtp_exp, *rtcp_exp;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	struct net *net = nf_ct_net(ct);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	union nf_inet_addr *saddr;
 	struct nf_conntrack_tuple tuple;
@@ -775,7 +776,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 
 	rcu_read_lock();
 	do {
-		exp = __nf_ct_expect_find(&init_net, &tuple);
+		exp = __nf_ct_expect_find(net, &tuple);
 
 		if (!exp || exp->master == ct ||
 		    nfct_help(exp->master)->helper != nfct_help(ct)->helper ||
