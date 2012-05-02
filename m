From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [PATCH] netfilter: Fix error in ipq_enqueue_packet
Date: Wed, 02 May 2012 12:21:50 +0530
Message-ID: <20120502065150.4651.70099.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@vger.kernel.org,
	Krishna Kumar <krkumar2@in.ibm.com>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:60749 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2EBGwc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 May 2012 02:52:32 -0400
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Wed, 2 May 2012 12:22:29 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q426pqqu19333182
	for <netfilter-devel@vger.kernel.org>; Wed, 2 May 2012 12:21:52 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q42CL6nK005987
	for <netfilter-devel@vger.kernel.org>; Wed, 2 May 2012 22:21:06 +1000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ipq_enqueue_packet sets status=-EINVAL and calls
ipq_build_packet_message(entry, &status). This can
set status=0 while returning an skb. The next line:
	if (!peer_pid)
		goto err_out_free_nskb;
which wrongly returns success.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---
 net/ipv4/netfilter/ip_queue.c  |    6 ++++--
 net/ipv6/netfilter/ip6_queue.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -ruNp org/net/ipv4/netfilter/ip_queue.c new/net/ipv4/netfilter/ip_queue.c
--- org/net/ipv4/netfilter/ip_queue.c	2012-04-23 08:28:23.000000000 +0530
+++ new/net/ipv4/netfilter/ip_queue.c	2012-05-02 11:28:33.899790397 +0530
@@ -227,7 +227,7 @@ nlmsg_failure:
 static int
 ipq_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 {
-	int status = -EINVAL;
+	int status;
 	struct sk_buff *nskb;
 
 	if (copy_mode == IPQ_COPY_NONE)
@@ -239,8 +239,10 @@ ipq_enqueue_packet(struct nf_queue_entry
 
 	spin_lock_bh(&queue_lock);
 
-	if (!peer_pid)
+	if (!peer_pid) {
+		status = -EINVAL;
 		goto err_out_free_nskb;
+	}
 
 	if (queue_total >= queue_maxlen) {
 		queue_dropped++;
diff -ruNp org/net/ipv6/netfilter/ip6_queue.c new/net/ipv6/netfilter/ip6_queue.c
--- org/net/ipv6/netfilter/ip6_queue.c	2012-04-23 08:28:23.000000000 +0530
+++ new/net/ipv6/netfilter/ip6_queue.c	2012-05-02 11:30:21.199578311 +0530
@@ -227,7 +227,7 @@ nlmsg_failure:
 static int
 ipq_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 {
-	int status = -EINVAL;
+	int status;
 	struct sk_buff *nskb;
 
 	if (copy_mode == IPQ_COPY_NONE)
@@ -239,8 +239,10 @@ ipq_enqueue_packet(struct nf_queue_entry
 
 	spin_lock_bh(&queue_lock);
 
-	if (!peer_pid)
+	if (!peer_pid) {
+		status = -EINVAL;
 		goto err_out_free_nskb;
+	}
 
 	if (queue_total >= queue_maxlen) {
 		queue_dropped++;

