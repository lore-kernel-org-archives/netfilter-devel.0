From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Resend: Add inversion to multiport match
Date: Sat, 22 Jan 2005 09:41:23 -0800
Message-ID: <20050122174123.GA9269@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/9DWx/yDrRhgMJTb"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

2.6.11 is theoretically around the corner, and I'd
like to get inversion added to multiport rev1.  Could
I get an ack/nack/i'm an idiot regarding the patch below?

Thanks,
Phil



--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-mport-ipt

diff -ru iptables-orig/extensions/libipt_multiport.c iptables-new/extensions/libipt_multiport.c
--- iptables-orig/extensions/libipt_multiport.c	2005-01-03 04:51:58.000000000 -0500
+++ iptables-new/extensions/libipt_multiport.c	2005-01-07 20:08:07.000000000 -0500
@@ -31,13 +31,13 @@
 {
 	printf(
 "multiport v%s options:\n"
-" --source-ports port[,port:port,port...]\n"
+" --source-ports [!] port[,port:port,port...]\n"
 " --sports ...\n"
 "				match source port(s)\n"
-" --destination-ports port[,port:port,port...]\n"
+" --destination-ports [!] port[,port:port,port...]\n"
 " --dports ...\n"
 "				match destination port(s)\n"
-" --ports port[,port:port,port]\n"
+" --ports [!] port[,port:port,port]\n"
 "				match both source and destination port(s)\n",
 IPTABLES_VERSION);
 }
@@ -255,8 +255,7 @@
 	}
 
 	if (invert)
-		exit_error(PARAMETER_PROBLEM,
-			   "multiport does not support invert");
+		multiinfo->invert = 1;
 
 	if (*flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -362,6 +361,9 @@
 		break;
 	}
 
+	if (multiinfo->invert)
+		printf("! ");
+
 	for (i=0; i < multiinfo->count; i++) {
 		printf("%s", i ? "," : "");
 		print_port(multiinfo->ports[i], ip->proto, numeric);
diff -ru iptables-orig/include/linux/netfilter_ipv4/ipt_multiport.h iptables-new/include/linux/netfilter_ipv4/ipt_multiport.h
--- iptables-orig/include/linux/netfilter_ipv4/ipt_multiport.h	2005-01-03 04:37:07.000000000 -0500
+++ iptables-new/include/linux/netfilter_ipv4/ipt_multiport.h	2005-01-06 20:37:38.000000000 -0500
@@ -24,5 +24,6 @@
 	u_int8_t count;				/* Number of ports */
 	u_int16_t ports[IPT_MULTI_PORTS];	/* Ports */
 	u_int8_t pflags[IPT_MULTI_PORTS];	/* Port flags */
+	u_int8_t invert;			/* Invert flag */
 };
 #endif /*_IPT_MULTIPORT_H*/

--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-mport-kern

diff -ru linux-orig/include/linux/netfilter_ipv4/ipt_multiport.h linux-mport/include/linux/netfilter_ipv4/ipt_multiport.h
--- linux-orig/include/linux/netfilter_ipv4/ipt_multiport.h	2005-01-07 20:51:06.293435976 -0500
+++ linux-mport/include/linux/netfilter_ipv4/ipt_multiport.h	2005-01-06 19:55:28.000000000 -0500
@@ -25,5 +25,6 @@
 	u_int8_t count;				/* Number of ports */
 	u_int16_t ports[IPT_MULTI_PORTS];	/* Ports */
 	u_int8_t pflags[IPT_MULTI_PORTS];	/* Port flags */
+	u_int8_t invert;			/* Invert flag */
 };
 #endif /*_IPT_MULTIPORT_H*/
diff -ru linux-orig/net/ipv4/netfilter/ipt_multiport.c linux-mport/net/ipv4/netfilter/ipt_multiport.c
--- linux-orig/net/ipv4/netfilter/ipt_multiport.c	2005-01-07 20:51:06.404419104 -0500
+++ linux-mport/net/ipv4/netfilter/ipt_multiport.c	2005-01-07 20:53:23.468582184 -0500
@@ -64,30 +64,31 @@
 
 			if (minfo->flags == IPT_MULTIPORT_SOURCE
 			    && src >= s && src <= e)
-				return 1;
+				return 1 ^ minfo->invert;
 			if (minfo->flags == IPT_MULTIPORT_DESTINATION
 			    && dst >= s && dst <= e)
-				return 1;
+				return 1 ^ minfo->invert;
 			if (minfo->flags == IPT_MULTIPORT_EITHER
 			    && ((dst >= s && dst <= e)
 				|| (src >= s && src <= e)))
-				return 1;
+				return 1 ^ minfo->invert;
 		} else {
 			/* exact port matching */
 			duprintf("src or dst matches with %d?\n", s);
+
 			if (minfo->flags == IPT_MULTIPORT_SOURCE
 			    && src == s)
-				return 1;
+				return 1 ^ minfo->invert;
 			if (minfo->flags == IPT_MULTIPORT_DESTINATION
 			    && dst == s)
-				return 1;
+				return 1 ^ minfo->invert;
 			if (minfo->flags == IPT_MULTIPORT_EITHER
 			    && (src == s || dst == s))
-				return 1;
+				return 1 ^ minfo->invert;
 		}
 	}
  
- 	return 0;
+ 	return minfo->invert;
 }
 
 static int

--/9DWx/yDrRhgMJTb--
