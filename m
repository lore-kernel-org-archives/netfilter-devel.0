From: sandr8@crocetta.org
Subject: Re: adding field into conntrack
Date: Mon,  2 Aug 2004 10:12:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1091434360.410df7789a879@mail.crocetta.org>
References: <1091042173.4107fb7d2cabf@mail.crocetta.org> <1091060982.28111.30.camel@bach> <20040801171930.GD14539@sunbeam2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Rusty Russell <rusty@rustcorp.com.au>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040801171930.GD14539@sunbeam2>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I've had a look, thank you. If i understood it in the right way, this patch is
really similar to what i've done on my own, billing separately each side of a
connection or stream. Hence i'm very glad to see that it is pending for
inclusion so that i could simply rely on it instead of mine.

There's just one little change i would really desire... tell me if you agree and
i will jot it down and submit a patch...

Around line 1320 of net/core/dev.c, the packet is fed to the queueing discipline
associated with the egressing interface. The enqueuing operation might not be
succesful or even being succesful it could have made the queueing discipline
drop an other packet (possibly belonging to an other stream).

The error we made could be huge with respect to open loop streams (such as UDP),
while with closed loop ones we could imagine that there will be not that much
difference between the throughput seen before the enqueuing and the goodput seen
after the deuqueuing.

As i said, the packet dropped could be not the enqueued one but any packet
already present in the queue.

8<-----------
         if (q->enqueue) {
                 rc = q->enqueue(skb, q);
8<-----------

would then become something like

8<-----------
         if (q->enqueue) {
                 rc = q->enqueue(&skb, q);
8<-----------

and would be followed by some code that

8<-----------
                 if( (rc!=NET_XMIT_SUCCESS) && (rc!=NET_XMIT_BYPASS) ){
                           /* do un-bill the tracked connection *skb
                            * belongs to, for the data that has been
                            * dropped right now... */
                                //...
                           skb_free(*skb);
                 }
8<-----------

then i should introduce some trivial changes in the queueing disciplines for the
by-reference argument and to remove the many skb_free()s.

A quicker alternative would be to bill a connection only after a dequeue
operation, but then in most uses the accounting information would have been
updated too late and it would become too tricky to use it to handle the other
packets enqueued while the dequeued one was waiting to be served.

Just tell me "it's ok" or "you'd better do it in this other way" and i'll go for it.
Alessandro

Quoting Harald Welte <laforge@netfilter.org>:

> On Thu, Jul 29, 2004 at 10:29:43AM +1000, Rusty Russell wrote:
> > On Thu, 2004-07-29 at 05:16, sandr8@crocetta.org wrote:
> 
> > > would you mind if i add two 32 bits fields to the cnntrack structure?
> > > i can surround them with an ifdef to have them only if the module i
> > > am writing is configured. Their aim would be to count how many bytes
> > > were transmitted on each side of the connection.
> > 
> > 	I believe there's already a patch like that, or one in progress. 
> > You're not the only one who want this.
> 
> Yes, please see the 'conntrack-acct' patch in patch-o-matic-ng CVS.
> 
> > Rusty.
> 
> -- 
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
> ============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
