From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH 13/18] Netfilter: Multiport revision with port ranges
	(replaces "mport")
Date: Fri, 7 Jan 2005 18:03:22 -0800
Message-ID: <20050108020322.GA11903@linuxace.com>
References: <1104896159.20582.79.camel@localhost.localdomain>
	<20050105043027.GA23546@linuxace.com>
	<1104904015.20582.91.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <1104904015.20582.91.camel@localhost.localdomain>
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


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 05, 2005 at 04:46:54PM +1100, Rusty Russell wrote:
> On Tue, 2005-01-04 at 20:30 -0800, Phil Oester wrote:
> > On Wed, Jan 05, 2005 at 02:35:59PM +1100, Rusty Russell wrote:
> > > The multiport match doesn't support ranges of ports, so a new match
> > > called "mport" was written.  Now we have versioning of matches and
> > > targets, we can simply put this extension in multiport revision 1.
> > 
> > While I agree the above is a useful change, why not also add inversion
> > to multiport in the process -- as long as you're making a new revision?
> > Or should that be done in revision 2?
> 
> If you put it in before 2.6.11 is released, it can go in the current
> revision, otherwise we want a new one (where do we put the invert
> flags?).

OK, how about the below which adds inversion?

(note: didn't update manpage, but then again, wasn't updated with previous
changes)

Phil



--y0ulUmNC+osPPQO6
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

--y0ulUmNC+osPPQO6
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

--y0ulUmNC+osPPQO6--
