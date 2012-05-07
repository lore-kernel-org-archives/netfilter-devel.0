From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [RFC] [PATCH 4/4] netfilter: Enable fail-open
Date: Mon, 07 May 2012 11:34:22 +0530
Message-ID: <20120507060422.19528.20723.sendpatchset@localhost.localdomain>
References: <20120507060338.19528.29403.sendpatchset@localhost.localdomain>
Cc: svajipay@in.ibm.com, vivk@us.ibm.com,
	Krishna Kumar <krkumar2@in.ibm.com>, sri@us.ibm.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:38130 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab2EGGE2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 02:04:28 -0400
Received: from /spool/local
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Mon, 7 May 2012 11:34:26 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q4764O6A2949572
	for <netfilter-devel@vger.kernel.org>; Mon, 7 May 2012 11:34:24 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q47BY34X012463
	for <netfilter-devel@vger.kernel.org>; Mon, 7 May 2012 17:04:04 +0530
In-Reply-To: <20120507060338.19528.29403.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Define xt_NFQ_info_v3 to get fail-open argument from iptables. Also
enable FAIL_OPEN.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---
 include/linux/netfilter/xt_NFQUEUE.h |    7 +++++++
 net/netfilter/xt_NFQUEUE.c           |   19 +++++++++++++++++++
 2 files changed, 26 insertions(+)

diff -ruNp org/include/linux/netfilter/xt_NFQUEUE.h new/include/linux/netfilter/xt_NFQUEUE.h
--- org/include/linux/netfilter/xt_NFQUEUE.h	2012-05-07 10:17:28.117870787 +0530
+++ new/include/linux/netfilter/xt_NFQUEUE.h	2012-05-07 09:20:53.783813702 +0530
@@ -26,4 +26,11 @@ struct xt_NFQ_info_v2 {
 	__u16 bypass;
 };
 
+struct xt_NFQ_info_v3 {
+	__u16 queuenum;
+	__u16 queues_total;
+	__u16 bypass;
+	__u16 fail_open;
+};
+
 #endif /* _XT_NFQ_TARGET_H */
diff -ruNp org/net/netfilter/xt_NFQUEUE.c new/net/netfilter/xt_NFQUEUE.c
--- org/net/netfilter/xt_NFQUEUE.c	2012-05-07 09:20:53.871815019 +0530
+++ new/net/netfilter/xt_NFQUEUE.c	2012-05-07 09:20:53.808751034 +0530
@@ -94,6 +94,17 @@ nfqueue_tg_v2(struct sk_buff *skb, const
 	return ret;
 }
 
+static unsigned int
+nfqueue_tg_v3(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_NFQ_info_v3 *info = par->targinfo;
+	unsigned int ret = nfqueue_tg_v1(skb, par);
+
+	if (info->fail_open)
+		ret |= NF_VERDICT_FLAG_FAIL_OPEN;
+	return ret;
+}
+
 static int nfqueue_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_NFQ_info_v2 *info = par->targinfo;
@@ -144,6 +155,14 @@ static struct xt_target nfqueue_tg_reg[]
 		.targetsize	= sizeof(struct xt_NFQ_info_v2),
 		.me		= THIS_MODULE,
 	},
+	{
+		.name		= "NFQUEUE",
+		.revision	= 3,
+		.family		= NFPROTO_UNSPEC,
+		.target		= nfqueue_tg_v3,
+		.targetsize	= sizeof(struct xt_NFQ_info_v3),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init nfqueue_tg_init(void)

