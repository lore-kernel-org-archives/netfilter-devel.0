From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c
 and optimization
Date: Thu, 29 Jul 2004 15:09:02 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407290609.PAA13928@toshiba.co.jp>
References: <200406250457.NAA07080@toshiba.co.jp>
	<Pine.LNX.4.33.0406251133230.11001-100000@blackhole.kfki.hu>
	<20040721213653.GR27487@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Thu_Jul_29_15:09:02_2004_793)--"
Content-Transfer-Encoding: 7bit
Cc: kadlec@blackhole.kfki.hu, yasuyuki.kozakai@toshiba.co.jp, kaber@trash.net,
        netfilter-devel@lists.netfilter.org, kisza@securityaudit.hu,
        usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20040721213653.GR27487@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Thu_Jul_29_15:09:02_2004_793)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

I got time to implement your idea. How about this ? (not tested)

BTW this code copies skb in the worst case. While implementing I got a idea
about this issue. How about introducing the function like that

	struct tcphdr hdr;
	struct tcphdr *tcph

	tcph = skb_get_bits(skb, &hdr, skb->nh.iph->ihl*4, sizeof(hdr));

If skb is neither shared nor cloned, this function linearize up to tcp header
and returns the pointer to tcp header in skb.

Otherwise, copies tcp header to "hdr" and return the pointer to it.
If error, return NULL.

This function will also eliminate the needs to linearization at nf_hook_slow()
but it is needed to modify all modules which read contents (but not write).

Do you think which is better ?

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


From: Harald Welte <laforge@netfilter.org>
Date: Wed, 21 Jul 2004 17:36:54 -0400

> On Fri, Jun 25, 2004 at 12:01:37PM +0200, Jozsef Kadlecsik wrote:
> 
> > - conntrack requires linearized protocol headers
> > 	- with the TCP window tracking code it means the complete
> > 	  TCP header, including the options due to the SACK support
> > - nat requires writable protocol headers, including the TCP options
> >   due to the SACK support
> > - raw/filter tables require linearized protocol headers in general (we can
> >   safely assume port matching rules :-)
> > - mark table requires writable protocol headers if we mangle the packet
> >   headers
> 
> yes, it's time to implement my old idea of a function like
> 	skb_linearize_partial(skb, len)
> 
> This could then be called by a skb_linearize_l4() function, that would
> linearize IP header, ip options, tcp header.
> 
> Ideally a hook-registering function should specify what it needs to have
> linearized. netfilter.c would then calculate the per-hook maximum and
> call the linearize function with that maximum.  
> 
> > So I think when any component of netfilter is enabled, we can assume that
> > at least linearized protocol headers are required. Therefore I suggested
> > to add such a function to nf_hook_slow.
> 
> yes, I agree.  Does anybody want to hack up a patch?  The most
> interesting part will be testing of that feature...
> 
> > Best regards,
> > Jozsef
> 
> -- 
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
> ============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie

----Next_Part(Thu_Jul_29_15:09:02_2004_793)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="linearize.patch"

diff -Nurp -X dontdiff linux-2.6.7/include/linux/netfilter.h linux-2.6.7-linearize/include/linux/netfilter.h
--- linux-2.6.7/include/linux/netfilter.h	2004-06-16 14:19:23.000000000 +0900
+++ linux-2.6.7-linearize/include/linux/netfilter.h	2004-07-29 10:58:55.000000000 +0900
@@ -53,8 +53,12 @@ struct nf_hook_ops
 	int hooknum;
 	/* Hooks are ordered in ascending priority. */
 	int priority;
+	int linearize_mode;
+	int linearize_layer;
 };
 
+#define NF_LINEARIZE_NONE	0
+
 struct nf_sockopt_ops
 {
 	struct list_head list;
diff -Nurp -X dontdiff linux-2.6.7/include/linux/netfilter_ipv4.h linux-2.6.7-linearize/include/linux/netfilter_ipv4.h
--- linux-2.6.7/include/linux/netfilter_ipv4.h	2004-06-16 14:19:52.000000000 +0900
+++ linux-2.6.7-linearize/include/linux/netfilter_ipv4.h	2004-07-29 14:48:11.073677304 +0900
@@ -78,6 +78,29 @@ void nf_debug_ip_loopback_xmit(struct sk
 void nf_debug_ip_finish_output2(struct sk_buff *skb);
 #endif /*CONFIG_NETFILTER_DEBUG*/
 
+/* linearize skb up to required header */
+extern int ip_linearize_headers(struct sk_buff **pskb, int mode, int layer);
+
+/* mode */
+
+/* not linearize */
+#define NF_IP_LINEARIZE_NONE			NF_LINEARIZE_NONE
+/* make skb readable without copying if possible */
+#define NF_IP_LINEARIZE_READABLE_NO_COPY	100
+/* make skb readable. skb is copied if needed */
+#define NF_IP_LINEARIZE_READABLE		200
+/* make skb readable. skb is copied if needed */
+#define NF_IP_LINEARIZE_WRITABLE		300
+/* linearize skb */
+#define NF_IP_LINEARIZE_ALL			65534
+
+/* layer */
+/* up to IP header */
+#define NF_IP_LINEARIZE_IPHDR			100
+/* up to transport header */
+#define NF_IP_LINEARIZE_TRANSPORT		200
+
+
 extern int ip_route_me_harder(struct sk_buff **pskb);
 
 /* Call this before modifying an existing IP packet: ensures it is
diff -Nurp -X dontdiff linux-2.6.7/net/core/netfilter.c linux-2.6.7-linearize/net/core/netfilter.c
--- linux-2.6.7/net/core/netfilter.c	2004-06-16 14:19:22.000000000 +0900
+++ linux-2.6.7-linearize/net/core/netfilter.c	2004-07-29 11:17:45.000000000 +0900
@@ -46,6 +46,18 @@
 static DECLARE_MUTEX(nf_sockopt_mutex);
 
 struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS];
+
+static struct {
+	struct {
+		int mode;	/* readable, writable, ... */
+		int layer;	/* protocol layer required to linearize */
+	} conf[NF_MAX_HOOKS];
+
+	/* linearization function per network protocol */
+	int (*fn)(struct sk_buff **pskb, int mode, int layer);
+
+} nf_linearize[NPROTO];
+
 static LIST_HEAD(nf_sockopts);
 static spinlock_t nf_hook_lock = SPIN_LOCK_UNLOCKED;
 
@@ -70,6 +82,21 @@ int nf_register_hook(struct nf_hook_ops 
 			break;
 	}
 	list_add_rcu(&reg->list, i->prev);
+
+	if (reg->linearize_mode != NF_LINEARIZE_NONE &&
+	    nf_linearize[reg->pf].fn == NULL) {
+		spin_unlock_bh(&nf_hook_lock);
+		return -1;
+	}
+
+	if (nf_linearize[reg->pf].conf[reg->hooknum].mode < reg->linearize_mode)
+		nf_linearize[reg->pf].conf[reg->hooknum].mode
+			= reg->linearize_mode;
+	if (nf_linearize[reg->pf].conf[reg->hooknum].layer
+	    < reg->linearize_layer)
+		nf_linearize[reg->pf].conf[reg->hooknum].layer
+			= reg->linearize_layer;
+
 	spin_unlock_bh(&nf_hook_lock);
 
 	synchronize_net();
@@ -80,6 +107,24 @@ void nf_unregister_hook(struct nf_hook_o
 {
 	spin_lock_bh(&nf_hook_lock);
 	list_del_rcu(&reg->list);
+
+	if (nf_linearize[reg->pf].fn) {
+		struct list_head *i;
+
+		int linearize_mode = NF_LINEARIZE_NONE;
+		int linearize_layer = 0;
+
+		list_for_each(i, &nf_hooks[reg->pf][reg->hooknum]) {
+			if (linearize_mode < reg->linearize_mode)
+				linearize_mode = reg->linearize_mode;
+			if (linearize_layer < reg->linearize_layer)
+				linearize_layer = reg->linearize_layer;
+		}
+
+		nf_linearize[reg->pf].conf[reg->hooknum].mode = linearize_mode;
+		nf_linearize[reg->pf].conf[reg->hooknum].layer = linearize_layer;
+	}
+
 	spin_unlock_bh(&nf_hook_lock);
 
 	synchronize_net();
@@ -515,6 +560,21 @@ int nf_hook_slow(int pf, unsigned int ho
 	skb->nf_debug |= (1 << hook);
 #endif
 
+	if (nf_linearize[pf].conf[hook].mode > NF_LINEARIZE_NONE &&
+	    nf_linearize[pf].fn != NULL) {
+		ret = nf_linearize[pf].fn(&skb,
+					  nf_linearize[pf].conf[hook].mode,
+					  nf_linearize[pf].conf[hook].layer);
+
+		if (ret < 0) {
+			if (net_ratelimit())
+				printk("can't linearize. pf = %d, hook = %d\n",
+				       pf, hook);
+
+			goto out;
+		}
+	}
+
 	elem = &nf_hooks[pf][hook];
  next_hook:
 	verdict = nf_iterate(&nf_hooks[pf][hook], &skb, hook, indev,
@@ -536,6 +596,7 @@ int nf_hook_slow(int pf, unsigned int ho
 		break;
 	}
 
+out:
 	rcu_read_unlock();
 	return ret;
 }
@@ -808,10 +869,16 @@ EXPORT_SYMBOL(nf_log_packet);
    with it. */
 void (*ip_ct_attach)(struct sk_buff *, struct nf_ct_info *);
 
+#ifdef CONFIG_INET
+extern int ip_linearize_headers(struct sk_buff **pskb, int mode, int layer);
+#endif
 void __init netfilter_init(void)
 {
 	int i, h;
 
+#ifdef CONFIG_INET
+	nf_linearize[PF_INET].fn = ip_linearize_headers;
+#endif
 	for (i = 0; i < NPROTO; i++) {
 		for (h = 0; h < NF_MAX_HOOKS; h++)
 			INIT_LIST_HEAD(&nf_hooks[i][h]);
diff -Nurp -X dontdiff linux-2.6.7/net/ipv4/netfilter/Makefile linux-2.6.7-linearize/net/ipv4/netfilter/Makefile
--- linux-2.6.7/net/ipv4/netfilter/Makefile	2004-06-16 14:19:01.000000000 +0900
+++ linux-2.6.7-linearize/net/ipv4/netfilter/Makefile	2004-07-29 10:58:55.000000000 +0900
@@ -96,3 +96,5 @@ obj-$(CONFIG_IP_NF_COMPAT_IPCHAINS) += i
 obj-$(CONFIG_IP_NF_COMPAT_IPFWADM) += ipfwadm.o
 
 obj-$(CONFIG_IP_NF_QUEUE) += ip_queue.o
+
+obj-y += ip_linearize.o
diff -Nurp -X dontdiff linux-2.6.7/net/ipv4/netfilter/ip_linearize.c linux-2.6.7-linearize/net/ipv4/netfilter/ip_linearize.c
--- linux-2.6.7/net/ipv4/netfilter/ip_linearize.c	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.7-linearize/net/ipv4/netfilter/ip_linearize.c	2004-07-29 11:02:16.000000000 +0900
@@ -0,0 +1,87 @@
+#include <linux/skbuff.h>
+#include <linux/in.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <linux/icmp.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/errno.h>
+
+#include <asm/bug.h>
+
+/* linearize skb up to specified layer. */
+
+int
+ip_linearize_headers(struct sk_buff **pskb, int mode, int layer)
+{
+	struct sk_buff *nskb;
+	unsigned int totlen;
+
+	if (mode == NF_IP_LINEARIZE_WRITABLE &&
+	    (skb_shared(*pskb) || skb_cloned(*pskb)))
+		goto copy_skb;
+
+	if (layer == NF_IP_LINEARIZE_IPHDR)
+		return 0;
+
+	totlen = (*pskb)->nh.iph->ihl*4;
+
+	if (layer == NF_IP_LINEARIZE_TRANSPORT) {
+		switch ((*pskb)->nh.iph->protocol) {
+		case IPPROTO_TCP: {
+			struct tcphdr hdr;
+			if (skb_copy_bits(*pskb, (*pskb)->nh.iph->ihl*4,
+					  &hdr, sizeof(hdr)) != 0) {
+				if (mode == NF_IP_LINEARIZE_READABLE_NO_COPY)
+					return 0;
+				else
+					goto copy_skb;
+			}
+			totlen += hdr.doff*4;
+			break;
+		}
+		case IPPROTO_UDP:
+			totlen += sizeof(struct udphdr);
+			break;
+		case IPPROTO_ICMP:
+			totlen += sizeof(struct icmphdr);
+			break;
+		/* Insert other cases here as desired */
+		}
+	} else if (layer == NF_IP_LINEARIZE_ALL)
+		totlen = (*pskb)->len;
+
+	if (totlen > (*pskb)->len)
+		totlen = (*pskb)->len;
+
+	if (totlen <= skb_headlen(*pskb))
+		return 0;
+
+	if (skb_shared(*pskb) || skb_cloned(*pskb)) {
+		if (mode == NF_IP_LINEARIZE_READABLE_NO_COPY)
+			return 0;
+		else
+			goto copy_skb;
+	}
+
+	if (pskb_may_pull(*pskb, totlen))
+		return -ENOMEM;
+	else
+		return 0;
+
+copy_skb:
+	nskb = skb_copy(*pskb, GFP_ATOMIC);
+	/* How should be handled ? */
+	if (!nskb)
+		return -ENOMEM;
+
+	BUG_ON(skb_is_nonlinear(nskb));
+
+	if ((*pskb)->sk)
+		skb_set_owner_w(nskb, (*pskb)->sk);
+	kfree_skb(*pskb);
+	*pskb = nskb;
+	return 0;
+}
+
+EXPORT_SYMBOL(ip_linearize_headers);

----Next_Part(Thu_Jul_29_15:09:02_2004_793)----
