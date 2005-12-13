From: Giacomo <delleceste@gmail.com>
Subject: Re: execution context in netfilter hooks.
Date: Tue, 13 Dec 2005 09:06:26 +0100
Message-ID: <885896af0512130006q23359049o@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>,
	netfilter devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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

Thank you very much for the answer.
The thing that confused me was that i had some
functions that registered with netfilter hooks.
I thought that processing was serialized, as you said
'in a queue'...
One of those functions was consulting a linked list, each
entry in such list had a timer attached. When timer expired, the entry
was freed.
After millions of packets processed by my function, a
crash happened. I solved the problem putting
'read_lock/unlock_bh' around linked list search and around timer
expiry handler function.
I thought it was not possible that my function was interrupted, while
instead things revealed that probably
i was unsafely freeing an entry in list which still had been
used by another function.

read_locks during list_for_each while consulting list, together with
write_locks around timeout handlers and
list_add solved.

So i'm trying to understand the reason why this happened, and if i am
right to use read/write locks (_bh)
or if i would better use spin_locks (_bh) or spin locks together with
_rcu version of lists.

When i said 'is it concerned with tasklets' i meant: after
hardirq when receiving a packet, is the packet processing (and
netfilter hook functions) registered as a tasklet to run later?

As to software timers, i thought  they were interrupting the other
routine scanning the linked list, as it resulted in the crash. But
probably this was due to 'kernel on behalf of process' context in
local output packets, as you said. (->does this mean no softirq
context -> routine interruptible?)

I read a lot of documents, but they talk a lot about
bottom halves, softirqs and tasklets, but perhaps some
things have changed in 2.6.x, and then i thought that new kernel
preemption would have made processing resemble SMP processing also un
UP systems.

Excuse my many questions, but i would like to clarify those important issue=
s...

Thanks a lot!

Giacomo
--

Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

Running `IPFIRE-wall` on debian GNU/Linux
http://www.giacomos.it/ipfire
http://www.debian.org

mailto:
delleceste@gmail.com
giacomo.strangolino@elettra.trieste.it
jacum@libero.it

- - - - - - - - - - - - - - - - - - - - - -
