From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] Fix ip_queue for bridged packets
Date: Tue, 28 Oct 2003 06:56:10 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031028065610.499a5b01.davem@redhat.com>
References: <200310251709.13913.bdschuym@pandora.be>
	<20031027000447.417915d0.davem@redhat.com>
	<200310280002.12023.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <200310280002.12023.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 28 Oct 2003 00:02:11 +0100
Bart De Schuymer <bdschuym@pandora.be> wrote:

> One could argue that this makes the iptables ip_queue module a tiny bit slower 
> when dealing with non-bridged traffic, but if the user compiled her kernel 
> with bridge_netfilter support one would think she needs it.

Ok, there are other parts of netfilter (both ipv4 and ipv6) that
call skb_copy_expand() like this and I suspect we'll be copying
this bridging hack over to those places as well.  Not good.

skb_copy_expand() is not exactly a fast path, so let's just make
it copy the header area too.

Bart, does this fix your bug too?  Please test it, thanks.

--- net/core/skbuff.c.~1~	Tue Oct 28 06:54:49 2003
+++ net/core/skbuff.c	Tue Oct 28 06:58:38 2003
@@ -591,8 +591,8 @@
 	/* Set the tail pointer and length */
 	skb_put(n, skb->len);
 
-	/* Copy the data only. */
-	if (skb_copy_bits(skb, 0, n->data, skb->len))
+	/* Copy the linear data and header. */
+	if (skb_copy_bits(skb, -newheadroom, n->head, newheadroom + skb->len))
 		BUG();
 
 	copy_skb_header(n, skb);
