From: Patrick McHardy <kaber@trash.net>
Subject: Re: [linuximq] Re: [PATCH] pom-ng version of IMQ target (file is
 attached this time)
Date: Sat, 05 Jun 2004 14:56:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40C1C310.7070605@trash.net>
References: <40A29E4A.94165870@info-link.net> <40A2D9D8.2050201@trash.net> <40A39C34.639DC30E@info-link.net> <40BB2C43.90704@dsl.pipex.com> <40BD0E6E.7040608@trash.net> <40BD1CC7.7080605@dsl.pipex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050605050703030809040605"
Cc: linuximq@yahoogroups.com,  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andy Furniss <andy.furniss@dsl.pipex.com>
In-Reply-To: <40BD1CC7.7080605@dsl.pipex.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050605050703030809040605
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Andy Furniss wrote:
> Patrick McHardy wrote:
>
>> Your mail made me realize I need patch for exactly the same issue
>> with ESFQ for work, so if you need it I can send it to you.
> 
> 
> Yea - it would be nice to see the right way to do it :-)

With this patch esfq uses the original source address if the packet has
been SNATed. It's a hack, but it solves the problem without IMQ.

> 
> I guessed using the example of the ingress NAT patch and changed egress 
> postrouting hook to NF_IP_PRI_NAT_SRC - 1.
> 
> It seems to be OK for me - are there other safe places where IMQ is OK 
> or any to be avoided?

I don't know about the current patches, you better ask the people
maintaining them.

Regards
Patrick

> 
> Andy.
> 


--------------050605050703030809040605
Content-Type: text/x-patch;
 name="esfq-source.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="esfq-source.diff"

diff -urN a/net/sched/sch_esfq.c b/net/sched/sch_esfq.c
--- a/net/sched/sch_esfq.c	2004-06-05 15:45:19.000000000 +0200
+++ b/net/sched/sch_esfq.c	2004-06-05 15:47:21.000000000 +0200
@@ -34,6 +34,7 @@
 #include <linux/etherdevice.h>
 #include <linux/notifier.h>
 #include <linux/init.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <net/ip.h>
 #include <linux/ipv6.h>
 #include <net/route.h>
@@ -109,6 +110,18 @@
 	return h & (q->hash_divisor-1);
 }
 
+static inline u32 esfq_get_source(struct sk_buff *skb)
+{
+	struct ip_conntrack *ct;
+	int dir;
+
+	if (skb->nfct == NULL)
+		return skb->nh.iph->saddr;
+	ct = (struct ip_conntrack *)skb->nfct->master;
+	dir = CTINFO2DIR(skb->nfct - ct->infos);
+	return ct->tuplehash[dir].tuple.src.ip;
+}
+
 static unsigned esfq_hash(struct esfq_sched_data *q, struct sk_buff *skb)
 {
 	u32 h, h2;
@@ -119,7 +132,7 @@
 	{
 		struct iphdr *iph = skb->nh.iph;
 		h = iph->daddr;
-		hs = iph->saddr;
+		hs = esfq_get_source(skb);
 		h2 = hs^iph->protocol;
 		if (!(iph->frag_off&htons(IP_MF|IP_OFFSET)) &&
 		    (iph->protocol == IPPROTO_TCP ||

--------------050605050703030809040605--
