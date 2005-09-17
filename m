From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
Subject: ip{,6}t_random / fix build warnings.
Date: Sat, 17 Sep 2005 13:30:59 +0200
Message-ID: <200509171330.59410.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_z5/KDFZtUN33QOm"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

--Boundary-00=_z5/KDFZtUN33QOm
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Attached patch fixes gcc warnings:

(...)
net/ipv4/netfilter/ipt_random.c: In function `ipt_rand_checkentry':
net/ipv4/netfilter/ipt_random.c:55: warning: unsigned int format,
                                    different type arg (arg 3)

net/ipv6/netfilter/ip6t_random.c: In function `ip6t_rand_checkentry':
net/ipv6/netfilter/ip6t_random.c:58: warning: unsigned int format,
                                     different type arg (arg 3)

net/ipv6/netfilter/ip6t_random.c: At top level:
net/ipv6/netfilter/ip6t_random.c:76: warning: initialization
                                     from incompatible pointer type

Regards,
Pawe=C5=82.

--=20
The only thing necessary for the triumph of evil
  is for good men to do nothing.
                                           - Edmund Burke

--Boundary-00=_z5/KDFZtUN33QOm
Content-Type: text/x-diff;
  charset="utf-8";
  name="random.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="random.diff"

Index: patchlets/random/linux-2.6/net/ipv4/netfilter/ipt_random.c
===================================================================
--- patchlets/random/linux-2.6/net/ipv4/netfilter/ipt_random.c	(revision 4262)
+++ patchlets/random/linux-2.6/net/ipv4/netfilter/ipt_random.c	(working copy)
@@ -52,7 +52,7 @@
 
 	if (matchsize != IPT_ALIGN(sizeof(struct ipt_rand_info))) {
 		printk("ipt_random: matchsize %u != %u\n", matchsize,
-		       IPT_ALIGN(sizeof(struct ipt_rand_info)));
+		       (unsigned)IPT_ALIGN(sizeof(struct ipt_rand_info)));
 		return 0;
 	}
 
Index: patchlets/random/linux-2.6/net/ipv6/netfilter/ip6t_random.c
===================================================================
--- patchlets/random/linux-2.6/net/ipv6/netfilter/ip6t_random.c	(revision 4262)
+++ patchlets/random/linux-2.6/net/ipv6/netfilter/ip6t_random.c	(working copy)
@@ -25,8 +25,7 @@
 	       const struct net_device *out,
 	       const void *matchinfo,
 	       int offset,
-	       const void *hdr,
-	       u_int16_t datalen,
+	       unsigned int protoff,
 	       int *hotdrop)
 {
 	/* Parameters from userspace */
@@ -55,7 +54,7 @@
 
 	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_rand_info))) {
 		printk("ip6t_random: matchsize %u != %u\n", matchsize,
-		       IP6T_ALIGN(sizeof(struct ip6t_rand_info)));
+		       (unsigned)IP6T_ALIGN(sizeof(struct ip6t_rand_info)));
 		return 0;
 	}
 

--Boundary-00=_z5/KDFZtUN33QOm--
