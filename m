From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Resend: Add inversion to multiport match
Date: Sat, 22 Jan 2005 12:45:21 -0800
Message-ID: <20050122204521.GA1176@linuxace.com>
References: <20050122174123.GA9269@linuxace.com>
	<1106421939.20995.28.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1106421939.20995.28.camel@tux.rsn.bth.se>
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


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 22, 2005 at 08:25:39PM +0100, Martin Josefsson wrote:
> Phil, the userspace part only adds inverted printout to print_v1() not
> to save_v1()
> Either send an updated patch or I'll fix that up when applying it after
> Patrick has submitted the kernel part.

Indeed -- appologies.  Attached is corrected userspace patch.

Phil



--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-mport-ipt2

diff -ru iptables-orig/extensions/libipt_multiport.c iptables-new/extensions/libipt_multiport.c
--- iptables-orig/extensions/libipt_multiport.c	2005-01-03 04:51:58.000000000 -0500
+++ iptables-new/extensions/libipt_multiport.c	2005-01-22 15:33:44.637388800 -0500
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
@@ -422,6 +424,9 @@
 		break;
 	}
 
+	if (multiinfo->invert)
+		printf("! ");
+
 	for (i=0; i < multiinfo->count; i++) {
 		printf("%s", i ? "," : "");
 		print_port(multiinfo->ports[i], ip->proto, 1);
diff -ru iptables-orig/include/linux/netfilter_ipv4/ipt_multiport.h iptables-new/include/linux/netfilter_ipv4/ipt_multiport.h
--- iptables-orig/include/linux/netfilter_ipv4/ipt_multiport.h	2005-01-03 04:37:07.000000000 -0500
+++ iptables-new/include/linux/netfilter_ipv4/ipt_multiport.h	2005-01-22 15:30:21.372289792 -0500
@@ -24,5 +24,6 @@
 	u_int8_t count;				/* Number of ports */
 	u_int16_t ports[IPT_MULTI_PORTS];	/* Ports */
 	u_int8_t pflags[IPT_MULTI_PORTS];	/* Port flags */
+	u_int8_t invert;			/* Invert flag */
 };
 #endif /*_IPT_MULTIPORT_H*/

--k1lZvvs/B4yU6o8G--
