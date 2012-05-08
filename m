From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [v2 PATCH 6/6] netfilter: Enable fail-open support.
Date: Tue, 08 May 2012 15:14:56 +0530
Message-ID: <20120508094456.19531.96964.sendpatchset@localhost.localdomain>
References: <20120508094342.19531.51351.sendpatchset@localhost.localdomain>
Cc: vivk@us.ibm.com, svajipay@in.ibm.com, fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	Krishna Kumar <krkumar2@in.ibm.com>, sri@us.ibm.com
To: kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:45990 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab2EHJpg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 May 2012 05:45:36 -0400
Received: from /spool/local
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Tue, 8 May 2012 15:15:34 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q489jBgt30801964
	for <netfilter-devel@vger.kernel.org>; Tue, 8 May 2012 15:15:11 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q48FFd8G026674
	for <netfilter-devel@vger.kernel.org>; Wed, 9 May 2012 01:15:41 +1000
In-Reply-To: <20120508094342.19531.51351.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Process NFQA_CFG_FAIL_OPEN and enable fail-open support.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
Signed-off-by: Vivek Kashyap <vivk@us.ibm.com>
Signed-off-by: Sridhar Samudrala <samudrala@us.ibm.com>
---
 net/netfilter/nfnetlink_queue.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -ruNp org/net/netfilter/nfnetlink_queue.c new/net/netfilter/nfnetlink_queue.c
--- org/net/netfilter/nfnetlink_queue.c	2012-05-08 12:58:49.844754291 +0530
+++ new/net/netfilter/nfnetlink_queue.c	2012-05-08 12:59:03.280923680 +0530
@@ -867,6 +867,19 @@ nfqnl_recv_config(struct sock *ctnl, str
 		spin_unlock_bh(&queue->lock);
 	}
 
+	if (nfqa[NFQA_CFG_FAIL_OPEN]) {
+		u_int8_t *fail_open;
+
+		if (!queue) {
+			ret = -ENODEV;
+			goto err_out_unlock;
+		}
+		fail_open = nla_data(nfqa[NFQA_CFG_FAIL_OPEN]);
+		spin_lock_bh(&queue->lock);
+		queue->fail_open = *fail_open;
+		spin_unlock_bh(&queue->lock);
+	}
+
 err_out_unlock:
 	rcu_read_unlock();
 	return ret;

