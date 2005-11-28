From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH 2.4] raw table and NOTRACK support
Date: Mon, 28 Nov 2005 10:11:29 +0100
Message-ID: <438AC9C1.2060405@tac.ch>
References: <4381A0C3.7020406@tac.ch>	<438327D2.5090506@tac.ch>	<43833BE3.8060909@tac.ch>	<43833F1D.3060309@tac.ch>	<438468E8.4090309@tac.ch>
	<4389D26A.8070904@trash.net>	<4389F974.5060405@drugphish.ch>
	<4389FFB6.8000705@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Willy Tarreau <willy@w.ods.org>,
	Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Roberto Nibali <ratz@drugphish.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4389FFB6.8000705@trash.net>
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

> One of the things it broke was SO_ORIGINAL_DST support for
> transparent proxying, which also affects 2.4.

Ok.

>> That would be perfect, could you point me to the git reference to this
>> patch, please?
> 
> It was commit 84531c24f27b02daa8e54e2bb6dc74a730fdf0a5, titled
> "[NETFILTER]: Revert nf_reset change".

Hmmm, so how about the following approach?

--- linux-2.4.32-orig/include/net/dst.h 2005-04-04 03:42:20 +0200
+++ linux-2.4.32-pab2/include/net/dst.h 2005-11-28 09:42:59 +0100
@@ -105,6 +105,7 @@
  void dst_release(struct dst_entry * dst)
  {
         if (dst) {
+               WARN_ON(atomic_read(&dst->__refcnt) < 1);
                 smp_mb__before_atomic_dec();
                 atomic_dec(&dst->__refcnt);
         }
diff -X dontdiff -Nur linux-2.4.32-orig/net/packet/af_packet.c 
linux-2.4.32-pab2/net/packet/af_packet.c
--- linux-2.4.32-orig/net/packet/af_packet.c    2004-11-17 12:54:22 +0100
+++ linux-2.4.32-pab2/net/packet/af_packet.c    2005-11-28 10:00:27 +0100
@@ -272,6 +272,11 @@
         if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL)
                 goto oom;

+       /* drop any routing info and conntrack reference */
+       dst_release(skb->dst);
+       skb->dst = NULL;
+       nf_reset(skb);
+
         spkt = (struct sockaddr_pkt*)skb->cb;

         skb_push(skb, skb->data-skb->mac.raw);
@@ -507,6 +512,12 @@

         skb_set_owner_r(skb, sk);
         skb->dev = NULL;
+
+       /* drop any routing info and conntrack reference */
+       dst_release(skb->dst);
+       skb->dst = NULL;
+       nf_reset(skb);
+
         spin_lock(&sk->receive_queue.lock);
         po->stats.tp_packets++;
         __skb_queue_tail(&sk->receive_queue, skb);

I'm compiling it now and will be running test, so long as the thing even 
boots ;).

I think the WARN_ON could be submitted to 2.4.x anyway since it helps 
finding other occurances of wrong refcnt decreasing. Why is the routing 
entry dropped in 2.6.x and not in 2.4.x? Maybe I should also cc netdev 
as well.

Thanks and best regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Kasinostrasse 30, CH-5001 Aarau tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
