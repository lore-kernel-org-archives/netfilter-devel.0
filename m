From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] pkttype match mismatches on locally generated packets
Date: Mon, 17 Jul 2006 18:08:49 -0700
Message-ID: <20060718010849.GA1221@linuxace.com>
References: <20060718010642.GA1203@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20060718010642.GA1203@linuxace.com>
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


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 17, 2006 at 06:06:42PM -0700, Phil Oester wrote:
> Locally generated broadcast and multicast packets have pkttype set to
> PACKET_LOOPBACK instead of PACKET_BROADCAST or PACKET_MULTICAST.  This
> causes the pkttype match to fail to match packets of either type.
> 
> The below patch remedies this by using the daddr as a hint as to
> broadcast|multicast.  While not pretty, this seems like the only way
> to solve the problem short of just noting this as a limitation of the match.
> 
> This resolves bug #484
> 
> Phil
> 
> Signed-off-by: Phil Oester <kernel@linuxace.com>

And this time the patch is attached...

Phil

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-pkttype

--- linux-dellfw/net/netfilter/xt_pkttype.c	2006-06-17 21:49:35.000000000 -0400
+++ linux-po/net/netfilter/xt_pkttype.c	2006-07-17 20:56:39.000000000 -0400
@@ -9,6 +9,8 @@
 #include <linux/skbuff.h>
 #include <linux/if_ether.h>
 #include <linux/if_packet.h>
+#include <linux/in.h>
+#include <linux/ip.h>
 
 #include <linux/netfilter/xt_pkttype.h>
 #include <linux/netfilter/x_tables.h>
@@ -28,9 +30,17 @@
       unsigned int protoff,
       int *hotdrop)
 {
+	u_int8_t type;
 	const struct xt_pkttype_info *info = matchinfo;
 
-	return (skb->pkt_type == info->pkttype) ^ info->invert;
+	if (skb->pkt_type == PACKET_LOOPBACK)
+		type = (MULTICAST(skb->nh.iph->daddr)
+			? PACKET_MULTICAST
+			: PACKET_BROADCAST);
+	else
+		type = skb->pkt_type;
+
+	return (type == info->pkttype) ^ info->invert;
 }
 
 static struct xt_match pkttype_match = {

--FL5UXtIhxfXey3p5--
