From: Duncan Palmer <dunk_palmer@yahoo.com>
Subject: Re: [PATCH] Get icmp ratelimit from sysctl in ipt_REJECT.c
Date: Mon, 7 Feb 2005 20:47:11 -0800 (PST)
Message-ID: <20050208044711.47125.qmail@web60607.mail.yahoo.com>
References: <20050208042943.7284.qmail@web60602.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-516701590-1107838031=:45811"
To: Duncan Palmer <dunk_palmer@yahoo.com>, netfilter-devel@lists.netfilter.org
In-Reply-To: <20050208042943.7284.qmail@web60602.mail.yahoo.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

--0-516701590-1107838031=:45811
Content-Type: text/plain; charset=us-ascii
Content-Id: 
Content-Disposition: inline

--- Duncan Palmer <dunk_palmer@yahoo.com> wrote:

> fixed in the attached patch (against 2.6.11-rc2-mm1,
> but applies cleanly to rc3-mm1 as well).

Bugger - yahoo has mangled the patch - sorry. I've
attached it instead...

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
--0-516701590-1107838031=:45811
Content-Type: text/x-patch; name="sysctl.patch"
Content-Description: sysctl.patch
Content-Disposition: inline; filename="sysctl.patch"

diff -ur linux-2.6.11-rc2-mm1.orig/net/ipv4/icmp.c linux-2.6.11-rc2-mm1/net/ipv4/icmp.c
--- linux-2.6.11-rc2-mm1.orig/net/ipv4/icmp.c	2005-01-28 13:01:17.000000000 +1100
+++ linux-2.6.11-rc2-mm1/net/ipv4/icmp.c	2005-02-08 15:07:11.000000000 +1100
@@ -208,6 +208,8 @@
 int sysctl_icmp_ratelimit = 1 * HZ;
 int sysctl_icmp_ratemask = 0x1818;
 
+EXPORT_SYMBOL(sysctl_icmp_ratelimit);
+
 /*
  *	ICMP control array. This specifies what to do with each ICMP.
  */
diff -ur linux-2.6.11-rc2-mm1.orig/net/ipv4/netfilter/ipt_REJECT.c linux-2.6.11-rc2-mm1/net/ipv4/netfilter/ipt_REJECT.c
--- linux-2.6.11-rc2-mm1.orig/net/ipv4/netfilter/ipt_REJECT.c	2005-01-28 13:01:18.000000000 +1100
+++ linux-2.6.11-rc2-mm1/net/ipv4/netfilter/ipt_REJECT.c	2005-02-08 15:02:42.000000000 +1100
@@ -234,8 +234,7 @@
 	if (!rt)
 		return;
 
-	/* FIXME: Use sysctl number. --RR */
-	if (!xrlim_allow(&rt->u.dst, 1*HZ))
+	if (!xrlim_allow(&rt->u.dst, sysctl_icmp_ratelimit))
 		return;
 
 	iph = skb_in->nh.iph;
diff -ur linux-2.6.11-rc2-mm1.orig/net/ipv4/sysctl_net_ipv4.c linux-2.6.11-rc2-mm1/net/ipv4/sysctl_net_ipv4.c
--- linux-2.6.11-rc2-mm1.orig/net/ipv4/sysctl_net_ipv4.c	2004-12-25 08:35:23.000000000 +1100
+++ linux-2.6.11-rc2-mm1/net/ipv4/sysctl_net_ipv4.c	2005-02-08 15:07:54.000000000 +1100
@@ -15,6 +15,7 @@
 #include <net/ip.h>
 #include <net/route.h>
 #include <net/tcp.h>
+#include <net/icmp.h>
 
 /* From af_inet.c */
 extern int sysctl_ip_nonlocal_bind;
@@ -34,7 +35,6 @@
 extern int sysctl_ip_dynaddr;
 
 /* From icmp.c */
-extern int sysctl_icmp_ratelimit;
 extern int sysctl_icmp_ratemask;
 
 /* From igmp.c */
diff -ur linux-2.6.11-rc2-mm1.orig/include/net/icmp.h linux-2.6.11-rc2-mm1/include/net/icmp.h
--- linux-2.6.11-rc2-mm1.orig/include/net/icmp.h	2005-01-28 13:01:11.000000000 +1100
+++ linux-2.6.11-rc2-mm1/include/net/icmp.h	2005-02-08 15:07:04.000000000 +1100
@@ -38,6 +38,8 @@
 #define ICMP_INC_STATS_BH(field)	SNMP_INC_STATS_BH(icmp_statistics, field)
 #define ICMP_INC_STATS_USER(field) 	SNMP_INC_STATS_USER(icmp_statistics, field)
 
+extern int sysctl_icmp_ratelimit;
+
 extern void	icmp_send(struct sk_buff *skb_in,  int type, int code, u32 info);
 extern int	icmp_rcv(struct sk_buff *skb);
 extern int	icmp_ioctl(struct sock *sk, int cmd, unsigned long arg);

--0-516701590-1107838031=:45811--
