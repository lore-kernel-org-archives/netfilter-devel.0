From: Olaf Kirch <okir@suse.de>
Subject: ip6t_REJECT dst underflow
Date: Thu, 25 Mar 2004 14:43:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040325134340.GC8500@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="dc+cDN39EJAMEtIO"
Cc: usagi-users@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline

Hi,

the ip6t_REJECT module currently produces dst underruns when used.
The problem is that it assigns the dst pointer to the new skb without
bumping its reference count. The attached patch fixes this.

A second issue I came across isn't really a bug but more of
a minor nuisance.

When I configured ip6t_REJECT to reject packets to ::1 and then pinged
::1, I would get in my syslog

	Mar 25 14:16:05 hammer kernel: printk: 2 messages suppressed.

without telling me what message got suppressed. The problem is that the
code does the following in two locations:

	if (net_ratelimit())
		DEBUGP(....)

So with debugging off, all you get is the above mentioned messages
from net_ratelimit but nothing else. Either the DEBUGP needs to be
converted to a printk, or the entire if() statement needs to be
enclosed in an #if/#endif pair.

Olaf
-- 
Olaf Kirch     |  Stop wasting entropy - start using predictable
okir@suse.de   |  tempfile names today!
---------------+ 

--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: attachment; filename=ip6t_reject

--- ip6t_REJECT.c.orig	2004-03-25 14:09:50.000000000 +0100
+++ ip6t_REJECT.c	2004-03-25 14:22:18.000000000 +0100
@@ -145,6 +145,7 @@
 	}
 
 	nskb->dst = dst;
+	dst_hold(dst);
 
 	skb_reserve(nskb, hh_len + dst->header_len);
 
@@ -242,7 +243,7 @@
 
 		if (!(type & ICMPV6_INFOMSG_MASK)) {
 			if (net_ratelimit())
-				DEBUGP("ip6t_REJECT: no reply to icmp error\n");
+				printk(KERN_DEBUG "ip6t_REJECT: no reply to icmp error\n");
 			return;
 		}
         } else if (proto == IPPROTO_UDP) {
@@ -279,7 +280,5 @@
 
 	if (ip6_dst_lookup(NULL, &dst, &fl)) {
-		if (net_ratelimit())
-			DEBUGP("can't find dst");
 		return;
 	}
 
@@ -316,6 +317,7 @@
 
 	nskb->priority = 0;
 	nskb->dst = dst;
+	dst_hold(dst);
 
 	skb_reserve(nskb, hh_len + dst->header_len);
 

--dc+cDN39EJAMEtIO--
