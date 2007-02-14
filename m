From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCH 2.6.20 13/14] nfnetlink_log: fix reference counting
Date: Wed, 14 Feb 2007 12:38:41 +0100
Message-ID: <20070214113841.GA3005@rere.qmqm.pl>
References: <20070212003738.GA8262@rere.qmqm.pl> <20070212202052.GA28704@rere.qmqm.pl> <20070212202255.GD28704@rere.qmqm.pl> <45D1B5FA.5050704@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932222AbXBNLjB@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45D1B5FA.5050704@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Feb 13, 2007 at 01:58:34PM +0100, Patrick McHardy wrote:
> Micha=C2=B3 Miros=C2=B3aw wrote:
> > Fix reference counting (memory leak) problem in __nfulnl_send() and=
 callers
> > related to packet queueing.
> >=20
> > Signed-off-by: Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl>
> >=20
> > --- linux-2.6.20/net/netfilter/nfnetlink_log.c.11	2007-02-12 17:35:=
50.000000000 +0100
> > +++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-12 17:58:01.=
000000000 +0100
> > @@ -223,6 +223,11 @@ _instance_destroy2(struct nfulnl_instanc
> > =20
> >  	spin_lock_bh(&inst->lock);
> >  	if (inst->skb) {
> > +		/* timer "holds" one reference (we have one more) */
> > +		if (timer_pending(&inst->timer)) {
> > +			del_timer(&inst->timer);
> > +			instance_put(inst);
> This should be done outside of the locked section and using
> del_timer_sync to make sure the timer is not already active
> and waiting for the lock.

I found another solution, as this won't work (I explained the case in m=
y
reply to your comment on 07/10). I noticed that we should just check
what del_timer() returns instead of timer_pending().

Heres the patch:

=46ix reference counting (memory leak) problem in __nfulnl_send() and c=
allers
related to packet queueing.

Signed-off-by: Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.11	2007-02-12 17:35:50.0=
00000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c.12	2007-02-14 12:27:09.0=
00000000 +0100
@@ -223,6 +223,9 @@ _instance_destroy2(struct nfulnl_instanc
=20
 	spin_lock_bh(&inst->lock);
 	if (inst->skb) {
+		/* timer "holds" one reference (we have one more) */
+		if (del_timer(&inst->timer))
+			instance_put(inst);
 		if (inst->qlen)
 			__nfulnl_send(inst);
 		if (inst->skb) {
@@ -370,9 +373,6 @@ __nfulnl_send(struct nfulnl_instance *in
 {
 	int status;
=20
-	if (timer_pending(&inst->timer))
-		del_timer(&inst->timer);
-
 	if (!inst->skb)
 		return 0;
=20
@@ -683,6 +683,9 @@ nfulnl_log_packet(unsigned int pf,
 		 * enough room in the skb left. flush to userspace. */
 		UDEBUG("flushing old skb\n");
=20
+		/* timer "holds" one reference (we have another one) */
+		if (del_timer(&inst->timer))
+			instance_put(inst);
 		__nfulnl_send(inst);
 	}
=20
