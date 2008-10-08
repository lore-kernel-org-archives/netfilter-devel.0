From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 36/79: netns nf_conntrack: H323 conntracking in netns
Date: Wed,  8 Oct 2008 12:47:09 +0200 (MEST)
Message-ID: <20081008104709.10423.27972.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45970 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbYJHKrL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:11 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 84541cc13a3bb31a58c096dde3517461e3ad91c2
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Oct 8 11:35:09 2008 +0200

    netfilter: netns nf_conntrack: H323 conntracking in netns
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index dfb826c..c1504f7 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1210,6 +1210,7 @@ static struct nf_conntrack_expect *find_expect(struct nf_conn *ct,
 					       union nf_inet_addr *addr,
 					       __be16 port)
 {
+	struct net *net = nf_ct_net(ct);
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple tuple;
 
@@ -1219,7 +1220,7 @@ static struct nf_conntrack_expect *find_expect(struct nf_conn *ct,
 	tuple.dst.u.tcp.port = port;
 	tuple.dst.protonum = IPPROTO_TCP;
 
-	exp = __nf_ct_expect_find(&init_net, &tuple);
+	exp = __nf_ct_expect_find(net, &tuple);
 	if (exp && exp->master == ct)
 		return exp;
 	return NULL;
