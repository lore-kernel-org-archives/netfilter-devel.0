From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: [PATCH v4 3/3] Make use of pr_fmt where applicable
Date: Wed, 29 Oct 2014 10:51:15 -0200
Message-ID: <40d37c4aa802e3ad7572b6818624f36abefc1791.1414586968.git.mleitner@redhat.com>
References: <7be00bf663b212d4984414346da216cf17d3443d.1414586968.git.mleitner@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932776AbaJ2Mvd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:51:33 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9TCpWQM011464
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2014 08:51:33 -0400
Received: from localhost.localdomain.com (vpn1-7-3.gru2.redhat.com [10.97.7.3])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s9TCpTjZ016877
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2014 08:51:31 -0400
In-Reply-To: <7be00bf663b212d4984414346da216cf17d3443d.1414586968.git.mleitner@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

And also remove PRINTR macro, as it was used only once, wasn't helping
much and was actually making it harder to use pr_err().

Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
---
 net/netfilter/nfnetlink_log.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 045c5956611f61a3f5dad3e15ca7cf19365e5afa..cb8088729b83b159fa99640aa5e149d9dba6e129 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -12,6 +12,8 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/if_arp.h>
@@ -45,9 +47,6 @@
 #define NFULNL_QTHRESH_DEFAULT 	100	/* 100 packets */
 #define NFULNL_COPY_RANGE_MAX	0xFFFF	/* max packet size is limited by 16-bit struct nfattr nfa_len field */
 
-#define PRINTR(x, args...)	do { if (net_ratelimit()) \
-				     printk(x, ## args); } while (0);
-
 struct nfulnl_instance {
 	struct hlist_node hlist;	/* global list of instances */
 	spinlock_t lock;
@@ -335,8 +334,7 @@ nfulnl_alloc_skb(struct net *net, u32 peer_portid, unsigned int inst_size,
 			skb = nfnetlink_alloc_skb(net, pkt_size,
 						  peer_portid, GFP_ATOMIC);
 			if (!skb)
-				pr_err("nfnetlink_log: can't even alloc %u bytes\n",
-				       pkt_size);
+				pr_err("can't even alloc %u bytes\n", pkt_size);
 		}
 	}
 
@@ -583,7 +581,6 @@ __build_packet_message(struct nfnl_log_net *log,
 	return 0;
 
 nla_put_failure:
-	PRINTR(KERN_ERR "nfnetlink_log: error creating log nlmsg\n");
 	nlmsg_cancel(skb, nlh);
 	return -1;
 }
@@ -1077,19 +1074,19 @@ static int __init nfnetlink_log_init(void)
 	netlink_register_notifier(&nfulnl_rtnl_notifier);
 	status = nfnetlink_subsys_register(&nfulnl_subsys);
 	if (status < 0) {
-		pr_err("log: failed to create netlink socket\n");
+		pr_err("failed to create netlink socket\n");
 		goto cleanup_netlink_notifier;
 	}
 
 	status = nf_log_register(NFPROTO_UNSPEC, &nfulnl_logger);
 	if (status < 0) {
-		pr_err("log: failed to register logger\n");
+		pr_err("failed to register logger\n");
 		goto cleanup_subsys;
 	}
 
 	status = register_pernet_subsys(&nfnl_log_net_ops);
 	if (status < 0) {
-		pr_err("log: failed to register pernet ops\n");
+		pr_err("failed to register pernet ops\n");
 		goto cleanup_logger;
 	}
 	return status;
-- 
1.9.3

