From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [Patch 0/2] Avoid direct connections between NATed hosts
Date: Fri, 12 Jan 2007 23:53:36 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701122350230.19224@yvahk01.tjqt.qr>
References: <1168621167.28615.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1168621167.28615.14.camel@localhost.localdomain>
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


>This patches against kernel and iptables add the capability to randomize
>the source port used when doing SNAT.

You might also want to patch MASQUERADE and SAME.


>+			if (!(range->flags & IP_NAT_RANGE_PROTO_RANDOM)) {
>+				if (!ip_nat_used_tuple(tuple, conntrack))
>+					return;
>+			}
> 		}
> 	}
>

Drop the extra { } - various places.

>@@ -18,6 +18,8 @@ #include <linux/netfilter_ipv4/ip_nat_co
> #include <linux/netfilter_ipv4/ip_nat_rule.h>
> #include <linux/netfilter_ipv4/ip_nat_protocol.h>
>
>+#include <linux/random.h>
>+
> static int
> udp_in_range(const struct ip_conntrack_tuple *tuple,
> 	     enum ip_nat_manip_type maniptype,
>@@ -74,6 +76,10 @@ udp_unique_tuple(struct ip_conntrack_tup
> 		range_size = ntohs(range->max.udp.port) - min + 1;
> 	}
>
>+	/* Start from random port to avoid prediction */
>+	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM) {
>+		get_random_bytes(&port,sizeof(port));
>+	}
> 	for (i = 0; i < range_size; i++, port++) {
> 		*portptr = htons(min + port % range_size);
> 		if (!ip_nat_used_tuple(tuple, conntrack))

Do we want get_random_bytes(), or would net_random() suffice?



	-`J'
-- 
