From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]Re: NAT before IPsec with 2.6
Date: Wed, 18 Feb 2004 15:57:39 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40337D63.6080602@trash.net>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com> <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org> <401777B4.9020000@trash.net> <20040128103000.GP11761@sunbeam.de.gnumonks.org> <401D12B6.5030707@trash.net> <40301AB2.2030103@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030808050803030000030802"
Cc: Harald Welte <laforge@netfilter.org>,
 Henrik Nordstrom <hno@marasystems.com>,
 Willy Tarreau <willy@w.ods.org>, Tom Eastep <teastep@shorewall.net>,
 Michal Ludvig <mludvig@suse.cz>,
  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <40301AB2.2030103@trash.net>
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
--------------030808050803030000030802
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Here is another patch on top of the last ones, it makes
incoming packets from transport mode SAs visible to
netfilter hooks and emulates normal behaviour. With this
patch you can share a transport-mode SA between an entire
network using MASQUERADE, but also do weird stuff like
DNAT packets coming from a transport mode SA to remote
hosts ;)

The patch is not exactly nice, but with it, everything should
be working fine except for nested tunnels. I would really
appreciate if I can get some comments for this part and the
other ones so I can prepare some final patches to discuss
with davem.

Regards
Patrick

Patrick McHardy wrote:

> There are 4 patches:
> 
> 01-nf_reset.diff
>     Move common nf_conntrack_put/nfct=NULL/nf_debug=0 code to
>     new inline function nf_reset.
> 
> 02-hooks.diff
>     Make packets to be encrypted visible on POST_ROUTING hook
>     and encrypted packets on LOCAL_OUT. Reset nfct etc. before
>     reposting the packet into the stack on reception.
> 
> 03-nat-policy-lookup.diff
>     Add policy lookups to ip_route_me_harder and change NAT to
>     reroute for any change that affects routing or policy lookups
> 
> 04-nat-policy-checks.diff
>     Make xfrm_policy_check find correct policy for NATed packets

--------------030808050803030000030802
Content-Type: text/plain;
 name="05-transport-mode-hooks.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05-transport-mode-hooks.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/02/18 15:42:49+01:00 kaber@trash.net 
#   Emulate netfilter hooks for transport mode packets
# 
# net/ipv4/xfrm4_input.c
#   2004/02/18 15:42:42+01:00 kaber@trash.net +46 -1
#   Emulate netfilter hooks for transport mode packets
# 
diff -Nru a/net/ipv4/xfrm4_input.c b/net/ipv4/xfrm4_input.c
--- a/net/ipv4/xfrm4_input.c	Wed Feb 18 15:45:17 2004
+++ b/net/ipv4/xfrm4_input.c	Wed Feb 18 15:45:17 2004
@@ -9,10 +9,53 @@
  * 	
  */
 
+#include <linux/config.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
 #include <net/inet_ecn.h>
 #include <net/ip.h>
 #include <net/xfrm.h>
 
+#ifdef CONFIG_NETFILTER
+static inline int emulate_nf_done(struct sk_buff *skb)
+{
+	return 0;
+}
+
+static inline int emulate_nf_hooks2(struct sk_buff *skb)
+{
+	if (inet_addr_type(skb->nh.iph->daddr) != RTN_LOCAL) {
+		if (ip_route_me_harder(&skb) == 0)
+			dst_input(skb);
+		else
+			kfree_skb(skb);
+		return -1;
+	}
+		
+	return NF_HOOK(PF_INET, NF_IP_LOCAL_IN, skb, skb->dev, NULL,
+	               emulate_nf_done);
+}
+
+static inline int emulate_nf_hooks(struct sk_buff *skb)
+{
+	int off = skb->data - skb->nh.raw;
+		
+	skb_push(skb, off);
+	skb->nh.iph->tot_len = htons(skb->len);
+	ip_send_check(skb->nh.iph);
+
+	if (NF_HOOK(PF_INET, NF_IP_PRE_ROUTING, skb, skb->dev, NULL,
+	            emulate_nf_hooks2) != 0)
+		return -1;
+
+	skb_pull(skb, off);
+	return 0;
+}
+#else /* CONFIG_NETFILTER */
+static inline int emulate_nf_hooks(struct sk_buff *skb) {}
+#endif /* CONFIG_NETFILTER */
+
 int xfrm4_rcv(struct sk_buff *skb)
 {
 	return xfrm4_rcv_encap(skb, 0);
@@ -125,15 +168,17 @@
 	memcpy(skb->sp->x+skb->sp->len, xfrm_vec, xfrm_nr*sizeof(struct sec_decap_state));
 	skb->sp->len += xfrm_nr;
 
+	nf_reset(skb);
 	if (decaps) {
 		if (!(skb->dev->flags&IFF_LOOPBACK)) {
 			dst_release(skb->dst);
 			skb->dst = NULL;
 		}
-		nf_reset(skb);
 		netif_rx(skb);
 		return 0;
 	} else {
+		if (emulate_nf_hooks(skb) != 0)
+			return 0;
 		return -skb->nh.iph->protocol;
 	}
 

--------------030808050803030000030802--
