From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [v2 PATCH 3/6] netfilter: Add support for per-queue fail-open
Date: Tue, 08 May 2012 15:14:19 +0530
Message-ID: <20120508094419.19531.63643.sendpatchset@localhost.localdomain>
References: <20120508094342.19531.51351.sendpatchset@localhost.localdomain>
Cc: vivk@us.ibm.com, svajipay@in.ibm.com, fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	Krishna Kumar <krkumar2@in.ibm.com>, sri@us.ibm.com
To: kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:59662 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab2EHJtZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 May 2012 05:49:25 -0400
Received: from /spool/local
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Tue, 8 May 2012 15:15:11 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q489iMSv4718908
	for <netfilter-devel@vger.kernel.org>; Tue, 8 May 2012 15:14:22 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q48FEwWC006438
	for <netfilter-devel@vger.kernel.org>; Wed, 9 May 2012 01:14:59 +1000
In-Reply-To: <20120508094342.19531.51351.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for per-queue fail-open

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
Signed-off-by: Vivek Kashyap <vivk@us.ibm.com>
Signed-off-by: Sridhar Samudrala <samudrala@us.ibm.com>
---
 net/netfilter/nfnetlink_queue.c |    1 +
 1 file changed, 1 insertion(+)

diff -ruNp org/net/netfilter/nfnetlink_queue.c new/net/netfilter/nfnetlink_queue.c
--- org/net/netfilter/nfnetlink_queue.c	2012-05-08 09:15:36.442049628 +0530
+++ new/net/netfilter/nfnetlink_queue.c	2012-05-08 09:56:41.274129649 +0530
@@ -52,6 +52,7 @@ struct nfqnl_instance {
 
 	u_int16_t queue_num;			/* number of this queue */
 	u_int8_t copy_mode;
+	u_int8_t fail_open;			/* whether fail-open enabled */
 /*
  * Following fields are dirtied for each queued packet,
  * keep them in same cache line if possible.

