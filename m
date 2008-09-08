From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 25/33] netns ct: H323 conntracking in netns
Date: Mon,  8 Sep 2008 07:03:02 +0400
Message-ID: <1220842990-30500-25-git-send-email-adobriyan@gmail.com>
References: <48C01046.2070704@trash.net>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	containers@lists.linux-foundation.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.190]:60034 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbYIHDDD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Sep 2008 23:03:03 -0400
Received: by mu-out-0910.google.com with SMTP id g7so1162882muf.1
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Sep 2008 20:03:02 -0700 (PDT)
In-Reply-To: <48C01046.2070704@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

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
