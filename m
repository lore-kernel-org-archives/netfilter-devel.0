From: Alex Riesen <Alexander.Riesen@synopsys.com>
Subject: circular dependency in netfilter headers (ip_conntrack.h)
Date: Fri, 29 Nov 2002 17:21:36 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021129162136.GB26745@riesen-pc.gr05.synopsys.com>
Reply-To: Alexander.Riesen@synopsys.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Netfilter Coreteam <coreteam@netfilter.org>
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

gmake[2]: Circular /export/home/riesen-pc0/riesen/compile/v2.4.20/include/linux/netfilter_ipv4/ip_conntrack_helper.h <- /export/home/riesen-pc0/riesen/compile/v2.4.20/include/linux/netfilter_ipv4/ip_conntrack.h dependency dropped.


I remember someone fixing it, but couldn't find the patch.
FWIW:

--- 2.4.20/include/linux/netfilter_ipv4/ip_conntrack.h	2002-08-13 06:01:49.000000000 +0200
+++ 2.4.20+/include/linux/netfilter_ipv4/ip_conntrack.h	2002-11-29 17:09:16.000000000 +0100
@@ -148,7 +148,8 @@ struct ip_conntrack_expect
 	union ip_conntrack_expect_help help;
 };
 
-#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+struct ip_conntrack_helper;
+
 struct ip_conntrack
 {
 	/* Usage count in here is 1 for hash table/destruct timer, 1 per skb,
