From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 4/7] nf: ipv4 defragmentation users counter changes in nf_conntrack_ipv4
 module
Date: Mon, 05 May 2014 16:56:12 +0400
Message-ID: <53678A6C.9000600@parallels.com>
References: <20140503233908.GA6297@localhost> <cover.1399292146.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:16690 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214AbaEEM5t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 May 2014 08:57:49 -0400
In-Reply-To: <cover.1399292146.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 8127dc8..1376055 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -432,6 +432,7 @@ static int ipv4_net_init(struct net *net)
 		pr_err("nf_conntrack_ipv4: pernet registration failed\n");
 		goto out_ipv4;
 	}
+	inc_br_defrag_ipv4_users_count(net);
 	return 0;
 out_ipv4:
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmp);
@@ -445,6 +446,7 @@ out_tcp:
 
 static void ipv4_net_exit(struct net *net)
 {
+	dec_br_defrag_ipv4_users_count(net);
 	nf_ct_l3proto_pernet_unregister(net, &nf_conntrack_l3proto_ipv4);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmp);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp4);
-- 
1.7.5.4

