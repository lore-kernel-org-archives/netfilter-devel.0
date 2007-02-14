From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.20 07/10] nfnetlink_log: fix module
	reference	counting
Date: Wed, 14 Feb 2007 17:46:38 +0100
Message-ID: <45D33CEE.6050404@trash.net>
References: <20070212003956.GH8262@rere.qmqm.pl> <45D1B383.5060400@trash.net>
	<20070213162535.GA10544@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060402040009020900050809"
Cc: netfilter-devel@lists.netfilter.org
To: mirq-linux@rere.qmqm.pl
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070213162535.GA10544@rere.qmqm.pl>
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

This is a multi-part message in MIME format.
--------------060402040009020900050809
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Micha=B3 Miros=B3aw wrote:
> On Tue, Feb 13, 2007 at 01:48:03PM +0100, Patrick McHardy wrote:
>=20
>>I think we should just cancel the timer on destruction.
>=20
>=20
> It won't solve a race between destroying the instance and logging a
> packet. It could happen that:
>=20
> CPU1				CPU2
> 				nfulnl_log_packet()
> 				 -> instance_lookup_get()
> 				 -> lock inst
> 				 ** got lock on inst
> _instance_destroy(inst)
>  -> remove inst from list
>  -> remove timer and unref inst
>  -> lock inst
>  				 -> start a timer
> 				 -> unlock inst
>  ** got lock on inst
>  -> clear the skb
>  -> unlock inst
>  -> unref inst
>  -> unref module... but we still have a timer pending!


This is easily fixable by adding a synchronize_rcu() call
after removing the instance from the global list.
nfulnl_log_packet() is called within a RCU read-side
critical section, so once synchronize_rcu() returns we're
guaranteed no CPU is within nfulnl_log_packet anymore with
this instance. And I think it is really preferable to having
the timer armed after destroying the instance.

This patch should take care of both the module reference
problem and the refcount leak.


--------------060402040009020900050809
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 8a460b1..1d45ff6 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -213,6 +213,9 @@ _instance_destroy2(struct nfulnl_instanc
 	if (lock)
 		write_unlock_bh(&instances_lock);
 
+	sychronize_rcu();
+	if (del_timer_sync(&inst->timer))
+		instance_put(inst);
 	/* then flush all pending packets from skb */
 
 	spin_lock_bh(&inst->lock);
@@ -363,9 +366,6 @@ __nfulnl_send(struct nfulnl_instance *in
 {
 	int status;
 
-	if (timer_pending(&inst->timer))
-		del_timer(&inst->timer);
-
 	if (!inst->skb)
 		return 0;
 
@@ -676,6 +676,9 @@ #endif
 		 * enough room in the skb left. flush to userspace. */
 		UDEBUG("flushing old skb\n");
 
+		if (del_timer(&inst->timer))
+			instance_put(inst);
+
 		__nfulnl_send(inst);
 	}
 

--------------060402040009020900050809--
