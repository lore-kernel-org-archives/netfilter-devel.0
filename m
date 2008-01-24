From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 8/8] nf_conntrack ipv6: unused code and sparse fix
Date: Thu, 24 Jan 2008 10:15:44 -0800
Message-ID: <20080124181628.545931850@vyatta.com>
References: <20080124181536.446214111@vyatta.com>
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([216.93.170.194]:48256 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804AbYAXSYU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:24:20 -0500
Content-Disposition: inline; filename=nf-ipv6.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Comment out unused code, and include header so function prototypes are checked.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/net/ipv6/netfilter/nf_conntrack_reasm.c	2008-01-23 14:19:41.000000000 -0800
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c	2008-01-23 14:23:39.000000000 -0800
@@ -42,6 +42,7 @@
 #include <linux/sysctl.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv6.h>
+#include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
@@ -680,6 +681,7 @@ void nf_ct_frag6_output(unsigned int hoo
 	nf_conntrack_put_reasm(skb);
 }
 
+#ifdef notused
 int nf_ct_frag6_kfree_frags(struct sk_buff *skb)
 {
 	struct sk_buff *s, *s2;
@@ -694,6 +696,7 @@ int nf_ct_frag6_kfree_frags(struct sk_bu
 
 	return 0;
 }
+#endif
 
 int nf_ct_frag6_init(void)
 {

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>

