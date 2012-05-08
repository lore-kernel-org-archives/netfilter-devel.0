From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [v2 PATCH 2/6] netfilter: Change enqueue handlers return values
Date: Tue, 08 May 2012 15:14:07 +0530
Message-ID: <20120508094407.19531.62855.sendpatchset@localhost.localdomain>
References: <20120508094342.19531.51351.sendpatchset@localhost.localdomain>
Cc: vivk@us.ibm.com, svajipay@in.ibm.com, fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	Krishna Kumar <krkumar2@in.ibm.com>, sri@us.ibm.com
To: kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:45394 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab2EHJoq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 May 2012 05:44:46 -0400
Received: from /spool/local
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Tue, 8 May 2012 15:14:39 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q489iAdm64815160
	for <netfilter-devel@vger.kernel.org>; Tue, 8 May 2012 15:14:11 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q48FDO96003876
	for <netfilter-devel@vger.kernel.org>; Wed, 9 May 2012 01:13:26 +1000
In-Reply-To: <20120508094342.19531.51351.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since fail-open is designed to return >0 to upper layer,
change ipqueue to return 0 as success, instead of skb->len.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
Signed-off-by: Vivek Kashyap <vivk@us.ibm.com>
Signed-off-by: Sridhar Samudrala <samudrala@us.ibm.com>
---
 net/ipv4/netfilter/ip_queue.c  |    2 +-
 net/ipv6/netfilter/ip6_queue.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -ruNp org/net/ipv4/netfilter/ip_queue.c new/net/ipv4/netfilter/ip_queue.c
--- org/net/ipv4/netfilter/ip_queue.c	2012-05-08 09:15:36.435049552 +0530
+++ new/net/ipv4/netfilter/ip_queue.c	2012-05-08 09:39:53.808091036 +0530
@@ -262,7 +262,7 @@ ipq_enqueue_packet(struct nf_queue_entry
 	__ipq_enqueue_entry(entry);
 
 	spin_unlock_bh(&queue_lock);
-	return status;
+	return 0;
 
 err_out_free_nskb:
 	kfree_skb(nskb);
diff -ruNp org/net/ipv6/netfilter/ip6_queue.c new/net/ipv6/netfilter/ip6_queue.c
--- org/net/ipv6/netfilter/ip6_queue.c	2012-05-08 09:15:36.433050383 +0530
+++ new/net/ipv6/netfilter/ip6_queue.c	2012-05-08 09:39:45.828858720 +0530
@@ -262,7 +262,7 @@ ipq_enqueue_packet(struct nf_queue_entry
 	__ipq_enqueue_entry(entry);
 
 	spin_unlock_bh(&queue_lock);
-	return status;
+	return 0;
 
 err_out_free_nskb:
 	kfree_skb(nskb);

