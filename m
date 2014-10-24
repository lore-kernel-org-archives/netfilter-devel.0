From: Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH netfilter] Fix Unknown symbols in nf_reject_ipvX modules
Date: Fri, 24 Oct 2014 15:28:52 +0800
Message-ID: <1414135732.19476.10.camel@TP420>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:47447 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJXH3B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:29:01 -0400
Received: from /spool/local
	by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <zhong@linux.vnet.ibm.com>;
	Fri, 24 Oct 2014 08:28:59 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 25D691B0805F
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2014 08:28:59 +0100 (BST)
Received: from d06av10.portsmouth.uk.ibm.com (d06av10.portsmouth.uk.ibm.com [9.149.37.251])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s9O7SwZg11731340
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2014 07:28:58 GMT
Received: from d06av10.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av10.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s9O7Sv4o007792
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2014 01:28:57 -0600
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit c8d7b98bec43 moved nf_send_resetX() to modules without module
license, which causes following errors seen on my system: 

[   26.926014] nf_reject_ipv4: Unknown symbol rcu_read_lock_bh_held (err 0)
[   26.926022] nf_reject_ipv4: Unknown symbol rcu_read_lock_held (err 0)
[   26.926030] nf_reject_ipv4: Unknown symbol ip_local_out_sk (err 0)

The code below adds MODULE_LICENSE("GPL") to fix this issue. 

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 3 +++
 net/ipv6/netfilter/nf_reject_ipv6.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index b023b4e..d5df20d 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -11,6 +11,9 @@
 #include <net/route.h>
 #include <net/dst.h>
 #include <linux/netfilter_ipv4.h>
+#include <linux/module.h>
+
+MODULE_LICENSE("GPL");
 
 /* Send RST reply */
 void nf_send_reset(struct sk_buff *oldskb, int hook)
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 5f5f043..e3e5683 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -10,6 +10,9 @@
 #include <net/ip6_fib.h>
 #include <net/ip6_checksum.h>
 #include <linux/netfilter_ipv6.h>
+#include <linux/module.h>
+
+MODULE_LICENSE("GPL");
 
 void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
 {



