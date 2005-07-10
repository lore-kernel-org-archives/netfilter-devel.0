From: Phil Oester <kernel@linuxace.com>
Subject: Re: SO_ORIGINAL_DST does not work in nat/OUTPUT anymore
Date: Sun, 10 Jul 2005 15:20:06 -0700
Message-ID: <20050710222006.GA11812@linuxace.com>
References: <42D12E28.7020707@hoelldampf.net>
	<20050710153234.GM20465@sunbeam.de.gnumonks.org>
	<42D14A6D.4000900@trash.net>
	<Pine.LNX.4.61.0507101822200.9759@filer.marasystems.com>
	<42D1608C.7040909@trash.net>
	<20050710202359.GA6874@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	Henrik Nordstrom <hno@marasystems.com>,
	netfilter-devel@lists.netfilter.org, jens@hoelldampf.net
Content-Disposition: inline
In-Reply-To: <20050710202359.GA6874@sunbeam.de.gnumonks.org>
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


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 10, 2005 at 10:24:00PM +0200, Harald Welte wrote:
> On Sun, Jul 10, 2005 at 07:53:16PM +0200, Patrick McHardy wrote:
> 
> > Thanks for the hint. Harald, if I can't think of anything else (seems
> > likely) I'll revert the patch.
> 
> Yes, I'm also in favour of reverting the patch.  The number of functional bugs
> it has caused by far outweigh the gain of save 'rmmod' without loops.

I humbly re-resubmit my original patch.  The problem occurs (most frequently)
in the case of raw sockets, which my patch addresses.  Patrick will point out
that stopped qdiscs are not handled by this patch, and I concur.  However, it
would seem that fixing the most common cause of module unload problems is
better than the plethora of problems the alternative patch has caused...

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-unload

diff -purN linux-orig/net/ipv4/ip_output.c linux-new/net/ipv4/ip_output.c
--- linux-orig/net/ipv4/ip_output.c	2005-06-17 15:48:29.000000000 -0400
+++ linux-new/net/ipv4/ip_output.c	2005-06-20 14:47:58.000000000 -0400
@@ -196,8 +196,6 @@ static inline int ip_finish_output2(stru
 	nf_debug_ip_finish_output2(skb);
 #endif /*CONFIG_NETFILTER_DEBUG*/
 
-	nf_reset(skb);
-
 	if (hh) {
 		int hh_alen;
 
diff -purN linux-orig/net/ipv4/netfilter/ip_conntrack_standalone.c linux-new/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-06-17 15:48:29.000000000 -0400
+++ linux-new/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-06-20 14:47:58.000000000 -0400
@@ -432,6 +432,13 @@ static unsigned int ip_conntrack_defrag(
 				        const struct net_device *out,
 				        int (*okfn)(struct sk_buff *))
 {
+#if !defined(CONFIG_IP_NF_NAT) && !defined(CONFIG_IP_NF_NAT_MODULE)
+	/* Previously seen (loopback)?  Ignore.  Do this before
+           fragment check. */
+	if ((*pskb)->nfct)
+		return NF_ACCEPT;
+#endif
+
 	/* Gather fragments. */
 	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
 		*pskb = ip_ct_gather_frags(*pskb,
diff -purN linux-orig/net/packet/af_packet.c linux-new/net/packet/af_packet.c
--- linux-orig/net/packet/af_packet.c	2005-06-17 15:48:29.000000000 -0400
+++ linux-new/net/packet/af_packet.c	2005-06-20 14:48:38.000000000 -0400
@@ -274,6 +274,9 @@ static int packet_rcv_spkt(struct sk_buf
 	dst_release(skb->dst);
 	skb->dst = NULL;
 
+	/* drop conntrack reference */
+	nf_reset(skb);
+
 	spkt = (struct sockaddr_pkt*)skb->cb;
 
 	skb_push(skb, skb->data-skb->mac.raw);
@@ -517,6 +520,9 @@ static int packet_rcv(struct sk_buff *sk
 	dst_release(skb->dst);
 	skb->dst = NULL;
 
+	/* drop conntrack reference */
+	nf_reset(skb);
+
 	spin_lock(&sk->sk_receive_queue.lock);
 	po->stats.tp_packets++;
 	__skb_queue_tail(&sk->sk_receive_queue, skb);

--x+6KMIRAuhnl3hBn--
