From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [Bridge] Re:  Any way of knowing a packet's been defragmented
Date: Thu, 5 Aug 2004 18:01:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200408051801.25373.bdschuym@pandora.be>
References: <C0170D0AF1277849A4B4518034F855DD0CFC55@aiexchange.ai.aiinet.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: bridge <bridge@osdl.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	shemminger@osdl.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Eble, Dan" <DanE@aiinet.com>,
	"Henrik Nordstrom" <hno@marasystems.com>
In-Reply-To: <C0170D0AF1277849A4B4518034F855DD0CFC55@aiexchange.ai.aiinet.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thursday 05 August 2004 16:58, Eble, Dan wrote:
> > The check should be after all
> > netfilter hooks just before the packet is given to the NIC
> > driver, dropped
> > on transmit because it can not be sent out on the target media, not
> > dropped in "bridge forwarding" because it seems to be bigger than the
> > intended target device.
>
> That makes sense.

I agree.

Stephen, how about this patch?

cheers,
Bart

--- linux-2.6.8-rc2-bk9/net/bridge/br_forward.c.old	2004-08-02 23:15:42.000000000 +0200
+++ linux-2.6.8-rc2-bk9/net/bridge/br_forward.c	2004-08-05 17:57:52.000000000 +0200
@@ -23,7 +23,6 @@ static inline int should_deliver(const s
 				 const struct sk_buff *skb)
 {
 	if (skb->dev == p->dev ||
-	    skb->len > p->dev->mtu ||
 	    p->state != BR_STATE_FORWARDING)
 		return 0;
 
@@ -32,6 +31,10 @@ static inline int should_deliver(const s
 
 int br_dev_queue_push_xmit(struct sk_buff *skb)
 {
+	if (skb->len > skb->dev->mtu) {
+		kfree_skb(skb);
+		return 0;
+	}
 #ifdef CONFIG_BRIDGE_NETFILTER
 	/* ip_refrag calls ip_fragment, which doesn't copy the MAC header. */
 	nf_bridge_maybe_copy_header(skb);
