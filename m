From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] convert mport to multiport
Date: Mon, 27 Sep 2004 01:23:10 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41574F5E.1020409@eurodev.net>
References: <415748E8.60000@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
In-Reply-To: <415748E8.60000@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi again Patrick,

I think that some comments about the patch could help you to review it, 
so here we go :-)

Pablo Neira wrote:

>===== net/ipv4/netfilter/ipt_multiport.c 1.8 vs edited =====
>--- 1.8/net/ipv4/netfilter/ipt_multiport.c	Thu Aug 19 02:14:53 2004
>+++ edited/net/ipv4/netfilter/ipt_multiport.c	Sun Sep 26 00:22:25 2004
>@@ -29,18 +29,38 @@
> 
> /* Returns 1 if the port is matched by the test, 0 otherwise. */
> static inline int
>-ports_match(const u_int16_t *portlist, enum ipt_multiport_flags flags,
>-	    u_int8_t count, u_int16_t src, u_int16_t dst)
>+ports_match(const struct ipt_multiport *minfo, u_int16_t src, u_int16_t dst)
> {
>-	unsigned int i;
>-	for (i=0; i<count; i++) {
>-		if (flags != IPT_MULTIPORT_DESTINATION
>-		    && portlist[i] == src)
>-			return 1;
>-
>-		if (flags != IPT_MULTIPORT_SOURCE
>-		    && portlist[i] == dst)
>-			return 1;
>+	unsigned int i, m;
>+	u_int16_t pflags = minfo->pflags;
>+	u_int8_t count = minfo->count;
>+	u_int16_t s, e;
>+
>+	for (i=0, m=1; i < count; i++, m<<=1) {
>+		s = minfo->ports[i];
>+
>+		if (pflags & m) {
>+			/* range port matching */
>+			e = minfo->ports[++i];
>+			m <<= 1;
>+			duprintf("src or dst matches with %d-%d?\n", s, e);
>+
>+			if (minfo->flags & IPT_MULTIPORT_SOURCE
>+			    && src >= s && src <= e)
>+				return 1;
>+			if (minfo->flags & IPT_MULTIPORT_DESTINATION
>+			    && dst >= s && dst <= e)
>+				return 1;
>+		} else {
>+			/* exact port matching */
>+			duprintf("src or dst matches with %d?\n", s);
>+			if (minfo->flags & IPT_MULTIPORT_SOURCE
>+			    && src == s)
>+				return 1;
>+			if (minfo->flags & IPT_MULTIPORT_DESTINATION
>+			    && dst == s)
>+				return 1;
>+		}
>  
>
           ^^^
This is the part that I've cleaned up. mport way of doing this is also ok.

> 	}
> 
> 	return 0;
>@@ -69,15 +89,11 @@
> 		/* We've been asked to examine this packet, and we
> 		 * can't.  Hence, no choice but to drop.
> 		 */
>-		duprintf("ipt_multiport:"
>-			 " Dropping evil offset=0 tinygram.\n");
>+		duprintf("ipt_multiport: Dropping evil offset=0 tinygram.\n");
> 		*hotdrop = 1;
> 		return 0;
> 	}
>-
>-	return ports_match(multiinfo->ports,
>-			   multiinfo->flags, multiinfo->count,
>-			   ntohs(pptr[0]), ntohs(pptr[1]));
>+	return ports_match(multiinfo, ntohs(pptr[0]), ntohs(pptr[1]));
> }
> 
> /* Called when user tries to insert an entry of this type. */
>@@ -89,9 +105,6 @@
> 	   unsigned int hook_mask)
> {
> 	const struct ipt_multiport *multiinfo = matchinfo;
>-
>-	if (matchsize != IPT_ALIGN(sizeof(struct ipt_multiport)))
>-		return 0;
>  
>
                  ^^^
Hm this check is done in the return, it's duplicated.

> 
> 	/* Must specify proto == TCP/UDP, no unknown flags or bad count */
> 	return (ip->proto == IPPROTO_TCP || ip->proto == IPPROTO_UDP)
>===== include/linux/netfilter_ipv4/ipt_multiport.h 1.1 vs edited =====
>--- 1.1/include/linux/netfilter_ipv4/ipt_multiport.h	Tue Feb  5 18:39:43 2002
>+++ edited/include/linux/netfilter_ipv4/ipt_multiport.h	Sun Sep 26 00:23:48 2004
>@@ -2,20 +2,30 @@
> #define _IPT_MULTIPORT_H
> #include <linux/netfilter_ipv4/ip_tables.h>
> 
>-enum ipt_multiport_flags
>-{
>-	IPT_MULTIPORT_SOURCE,
>-	IPT_MULTIPORT_DESTINATION,
>-	IPT_MULTIPORT_EITHER
>+enum ipt_multiport_flags {
>+	IPT_MULTIPORT_SOURCE_BIT = 0,
>+	IPT_MULTIPORT_SOURCE = (1 << IPT_MULTIPORT_SOURCE_BIT),
>+	
>+	IPT_MULTIPORT_DESTINATION_BIT = 1,
>+	IPT_MULTIPORT_DESTINATION = (1 << IPT_MULTIPORT_DESTINATION_BIT),
>+
>+	IPT_MULTIPORT_EITHER = IPT_MULTIPORT_SOURCE|IPT_MULTIPORT_DESTINATION,
>  
>
                 ^^^
flags like in ip_conntrack.h.


> };
> 
> #define IPT_MULTI_PORTS	15
> 
>-/* Must fit inside union ipt_matchinfo: 16 bytes */
>+/* Must fit inside union ipt_matchinfo: 32 bytes */
>  
>
     ^^^
Actually I just took this from mport, I found this Harald's email 
explaining this issue (actually I got stuck there some time because i 
didn't understand that comment :-))

http://lists.netfilter.org/pipermail/netfilter-devel/2003-January/010187.html

>+/* every entry in ports[] except for the last one has one bit in pflags
>+ * associated with it. If this bit is set, the port is the first port of
>+ * a portrange, with the next entry being the last.
>+ * End of list is marked with pflags bit set and port=65535.
>+ * If 14 ports are used (last one does not have a pflag), the last port
>+ * is repeated to fill the last entry in ports[] */
> struct ipt_multiport
> {
>-	u_int8_t flags;				/* Type of comparison */
>-	u_int8_t count;				/* Number of ports */
>+	u_int8_t flags:2;			/* Type of comparison */
>+	u_int16_t pflags:14;			/* Port flags */
> 	u_int16_t ports[IPT_MULTI_PORTS];	/* Ports */
>+	u_int8_t count;                         /* Number of ports */
>  
>
                  ^^^
use count instead of 65535+flag as ending

> };
> #endif /*_IPT_MULTIPORT_H*/
>  
>

regards,
Pablo
