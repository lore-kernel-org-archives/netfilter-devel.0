From: Patrick McHardy <kaber@trash.net>
Subject: Re: Netfilter problem with new 2.4.22
Date: Thu, 18 Sep 2003 23:40:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F6A2632.6030005@trash.net>
References: <3F697788.8080103@isfera.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040009000201000602020600"
Cc: netfilter-devel@lists.netfilter.org,  netfilter@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Diadon <diadon@isfera.ru>
In-Reply-To: <3F697788.8080103@isfera.ru>
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
--------------040009000201000602020600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Diadon wrote:

> > On 2.4.21 all works fine
> > In tcpdump on 2.4.21:
> > 14:41:41.752557 somehost.auth > somehost1.32825: R 0:0(0) ack 
> 217583467 win 0 (DF)
>
> > In tcpdump on 2.4.22:
> > nothing....... 


Hi Diadon,
the problem seems to be that a dst for local input doesn't carry pmtu 
information, the pmtu
is set by rt_set_nexthop which is skipped for local input. The packet is 
dropped by send_reset
because of this check:

        /* "Never happens" */
        if (nskb->len > nskb->dst->pmtu)
                goto free_nskb;

;)

I've attached two possible fixes for this. The first one restores 
behaviour from before the
routing changes for LOCAL_OUT, the other one removes the check since 
obviously
"Never happens" is not true anymore (and it is not an error). Another 
possibility would
be something like "if (nskb->dst->pmtu && nskb->len > nskb->dst->pmtu)  ..."
Someone from the coreteam should comment which solution is prefered.

Regards,
Patrick

--------------040009000201000602020600
Content-Type: text/plain;
 name="x.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x.diff"

===== net/ipv4/netfilter/ipt_REJECT.c 1.13 vs edited =====
--- 1.13/net/ipv4/netfilter/ipt_REJECT.c	Fri Jul 25 23:15:41 2003
+++ edited/net/ipv4/netfilter/ipt_REJECT.c	Thu Sep 18 23:00:58 2003
@@ -34,16 +34,17 @@
 		attach(new_skb, nfct);
 }
 
-static inline struct rtable *route_reverse(struct sk_buff *skb, int local)
+static inline struct rtable *route_reverse(struct sk_buff *skb, int hook)
 {
 	struct iphdr *iph = skb->nh.iph;
 	struct dst_entry *odst;
 	struct rt_key key = {};
 	struct rtable *rt;
 
-	if (local) {
+	if (hook != NF_IP_FORWARD) {
 		key.dst = iph->saddr;
-		key.src = iph->daddr;
+		if (hook == NF_IP_LOCAL_IN)
+			key.src = iph->daddr;
 		key.tos = RT_TOS(iph->tos);
 
 		if (ip_route_output_key(&rt, &key) != 0)
@@ -75,7 +76,7 @@
 }
 
 /* Send RST reply */
-static void send_reset(struct sk_buff *oldskb, int local)
+static void send_reset(struct sk_buff *oldskb, int hook)
 {
 	struct sk_buff *nskb;
 	struct tcphdr *otcph, *tcph;
@@ -104,7 +105,7 @@
 			 csum_partial((char *)otcph, otcplen, 0)) != 0)
 		return;
 
-	if ((rt = route_reverse(oldskb, local)) == NULL)
+	if ((rt = route_reverse(oldskb, hook)) == NULL)
 		return;
 
 	hh_len = (rt->u.dst.dev->hard_header_len + 15)&~15;
@@ -372,7 +373,7 @@
 		send_unreach(*pskb, ICMP_PKT_FILTERED);
 		break;
 	case IPT_TCP_RESET:
-		send_reset(*pskb, hooknum == NF_IP_LOCAL_IN);
+		send_reset(*pskb, hooknum);
 	case IPT_ICMP_ECHOREPLY:
 		/* Doesn't happen. */
 		break;

--------------040009000201000602020600
Content-Type: text/plain;
 name="y.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="y.diff"

===== net/ipv4/netfilter/ipt_REJECT.c 1.13 vs edited =====
--- 1.13/net/ipv4/netfilter/ipt_REJECT.c	Fri Jul 25 23:15:41 2003
+++ edited/net/ipv4/netfilter/ipt_REJECT.c	Thu Sep 18 23:28:49 2003
@@ -186,10 +186,6 @@
 	nskb->nh.iph->check = ip_fast_csum((unsigned char *)nskb->nh.iph, 
 					   nskb->nh.iph->ihl);
 
-	/* "Never happens" */
-	if (nskb->len > nskb->dst->pmtu)
-		goto free_nskb;
-
 	connection_attach(nskb, oldskb->nfct);
 
 	NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, nskb, NULL, nskb->dst->dev,

--------------040009000201000602020600--
