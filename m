From: Stephen Hemminger <shemminger@osdl.org>
Subject: Re: help with linux kernel timers
Date: Sat, 29 Oct 2005 12:51:25 -0700
Message-ID: <20051029125125.66562457@localhost.localdomain>
References: <885896af0510291112k23458e55y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Giacomo <delleceste@gmail.com>
In-Reply-To: <885896af0510291112k23458e55y@mail.gmail.com>
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

On Sat, 29 Oct 2005 20:12:17 +0200
Giacomo <delleceste@gmail.com> wrote:

> Good morning, in my kernel code, which handles timeouts for connection
> tables in a linked list, i do:
> 
> inline void update_timer_of_state_entry(struct state_table *sttable)
> {
>  if (sttable->state.state == ESTABLISHED)
>   mod_timer(&sttable->timer_statelist,
>      jiffies + HZ * state_lifetime);
>  else
>   mod_timer(&sttable->timer_statelist,
>      jiffies + HZ * setup_shutd_state_lifetime);
> }
> 
> sttable is a structure which contains a struct timer_list.
> 
> In:
> 
> mod_timer(&sttable->timer_statelist,
>      jiffies + HZ * state_lifetime);
> 
> i update the timeout for the structures, so that when timer expires,
> structure is removed from linked list.
> 
> The problem is that when state lifetime is long, let's say 2592000 for
> instance, kernel goes in panic!
> 
> If the value is low, say 300, or higher 259200000, ok!
> 
> I suspect a problem of overflow .. is it possible?
> 
> What can be wrong?
> 
> Thanks a lot for any hint!
> 
> OTHER THINGS:
> 
> My data structures are accessed in atomic context, since they contain data
> regarding internet packets. When timer expires, the function handler simply
> removes the structure from the linked list, i suppose when out of the atomic
> context.
> 
> This happens:
> 
> 1. a packet is received from the network;
> 2. If packet is allowed to pass through the filter, a data structure is
> allocated
> and contains the data related to the socket.
> 3. A timer is initialized, and updated every time a new packet matches the
> data stored in the structure.
> 4. When no more packets of that kind are received, timer expires and table
> is deleted from linked list.
> 
> But, in my scenario, 4 in theory does not happen since timeout is very long,
> as i said in my first mail.
> 
> Things worked ok for months, until i changed timeout to some million of
> seconds... (example 2592000)..
> but if i increase it again (25920000) things go well again.. this makes me
> think of some
> overflow...
> 
> Structures affected are only accessed in kernel space in softirq context
> (network reception).
> 
> Thanks a lot!
> 
> Giacomo.
>

Maximum value for kernel timeouts (on 32 bit machine), is 
	2^32 / 2 / HZ
and HZ can be 1000,  The divide by two is because it needs
to use subtraction for comparison.

Do you really need timeouts of 24 days or more?  if so you use
a shorter timeout and recheck and go back to sleep.
