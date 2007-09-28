From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 17/19]: nfnetlink_log: fix some constants
Date: Fri, 28 Sep 2007 18:31:01 +0200 (MEST)
Message-ID: <20070928163100.8394.83982.sendpatchset@localhost.localdomain>
References: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55976 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820AbXI1QbC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:31:02 -0400
In-Reply-To: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nfnetlink_log: fix some constants

Fix timeout (one second is 1 * HZ) and convert max packet copy length
to #defined constant.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit caf9b335ee5b5e1c755170c85952b28208512489
tree 37e44cd0a6977e91b2055f5708274ffa9c414667
parent 57a86b3a876463c836eff7cd75c77fef5f16c773
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Fri, 28 Sep 2007 18:09:18 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:18 +0200

 net/netfilter/nfnetlink_log.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 16ae539..2135926 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -37,8 +37,9 @@
 #endif
 
 #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
-#define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
+#define NFULNL_TIMEOUT_DEFAULT 	HZ	/* every second */
 #define NFULNL_QTHRESH_DEFAULT 	100	/* 100 packets */
+#define NFULNL_COPY_RANGE_MAX	0xFFFF	/* max packet size is limited by 16-bit struct nfattr nfa_len field */
 
 #define PRINTR(x, args...)	do { if (net_ratelimit()) \
 				     printk(x, ## args); } while (0);
@@ -171,7 +172,7 @@ instance_create(u_int16_t group_num, int pid)
 	inst->flushtimeout 	= NFULNL_TIMEOUT_DEFAULT;
 	inst->nlbufsiz 		= NFULNL_NLBUFSIZ_DEFAULT;
 	inst->copy_mode 	= NFULNL_COPY_PACKET;
-	inst->copy_range 	= 0xffff;
+	inst->copy_range 	= NFULNL_COPY_RANGE_MAX;
 
 	hlist_add_head(&inst->hlist,
 		       &instance_table[instance_hashfn(group_num)]);
@@ -235,11 +236,8 @@ nfulnl_set_mode(struct nfulnl_instance *inst, u_int8_t mode,
 
 	case NFULNL_COPY_PACKET:
 		inst->copy_mode = mode;
-		/* we're using struct nlattr which has 16bit nfa_len */
-		if (range > 0xffff)
-			inst->copy_range = 0xffff;
-		else
-			inst->copy_range = range;
+		inst->copy_range = min_t(unsigned int,
+					 range, NFULNL_COPY_RANGE_MAX);
 		break;
 
 	default:
