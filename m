From: Phil Oester <kernel@linuxace.com>
Subject: Re: [ANNOUNCE] Release of iptables-1.3.0rc1
Date: Wed, 2 Feb 2005 08:04:44 -0800
Message-ID: <20050202160444.GC30465@linuxace.com>
References: <20050202154449.GA30465@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050202154449.GA30465@linuxace.com>
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


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 02, 2005 at 07:44:49AM -0800, Phil Oester wrote:
> > The netfilter coreteam proudly presents:
> >	iptables version 1.3.0rc1
> 
> One note: the userspace side of multiport inversion has not yet
> been merged (while the kernel side has).
> 
> Phil

Err...included again here for easy patching :)



--d6Gm4EdcadzBjdND
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

--d6Gm4EdcadzBjdND--
