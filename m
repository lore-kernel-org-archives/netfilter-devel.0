From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [v2 PATCH 1/6] netfilter: Add new netlink NFQA_CFG_FAIL_OPEN
Date: Tue, 08 May 2012 15:13:54 +0530
Message-ID: <20120508094354.19531.92149.sendpatchset@localhost.localdomain>
References: <20120508094342.19531.51351.sendpatchset@localhost.localdomain>
Cc: vivk@us.ibm.com, svajipay@in.ibm.com, fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	Krishna Kumar <krkumar2@in.ibm.com>, sri@us.ibm.com
To: kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:40690 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2EHJoS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 May 2012 05:44:18 -0400
Received: from /spool/local
	by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Tue, 8 May 2012 09:35:49 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q489b0sD20971570
	for <netfilter-devel@vger.kernel.org>; Tue, 8 May 2012 19:37:00 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q489hvaR001965
	for <netfilter-devel@vger.kernel.org>; Tue, 8 May 2012 19:43:58 +1000
In-Reply-To: <20120508094342.19531.51351.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Define a new netlink message: NFQA_CFG_FAIL_OPEN

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
Signed-off-by: Vivek Kashyap <vivk@us.ibm.com>
Signed-off-by: Sridhar Samudrala <samudrala@us.ibm.com>
---
 include/linux/netfilter/nfnetlink_queue.h |    1 +
 1 file changed, 1 insertion(+)

diff -ruNp org/include/linux/netfilter/nfnetlink_queue.h new/include/linux/netfilter/nfnetlink_queue.h
--- org/include/linux/netfilter/nfnetlink_queue.h	2012-05-08 09:16:41.969050136 +0530
+++ new/include/linux/netfilter/nfnetlink_queue.h	2012-05-08 09:39:10.334761077 +0530
@@ -84,6 +84,7 @@ enum nfqnl_attr_config {
 	NFQA_CFG_CMD,			/* nfqnl_msg_config_cmd */
 	NFQA_CFG_PARAMS,		/* nfqnl_msg_config_params */
 	NFQA_CFG_QUEUE_MAXLEN,		/* __u32 */
+	NFQA_CFG_FAIL_OPEN,		/* __u8 */
 	__NFQA_CFG_MAX
 };
 #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)

