From: "Giacomo" <delleceste@gmail.com>
Subject: Fw: timers in linux kernel
Date: Sat, 29 Oct 2005 14:05:26 +0200
Message-ID: <001701c5dc81$0deffa10$0300a8c0@giacomino>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter devel" <netfilter-devel@lists.netfilter.org>
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


----- Original Message ----- 
From: "Giacomo" <delleceste@gmail.com>
To: <netfilter-devel-request@lists.netfilter.org>
Sent: Saturday, October 29, 2005 10:56 AM
Subject: timers in linux kernel


> Good morning, in my kernel code, which handles timeouts for connection 
> tables in a linked list, i do:
> 
> inline void update_timer_of_state_entry(struct state_table *sttable)
> {
> if (sttable->state.state == ESTABLISHED)
>  mod_timer(&sttable->timer_statelist,
>     jiffies + HZ * state_lifetime);
> else
>  mod_timer(&sttable->timer_statelist,
>     jiffies + HZ * setup_shutd_state_lifetime);
> }
> 
> sttable is a structure which contains a struct timer_list.
> 
> In:
> 
> mod_timer(&sttable->timer_statelist,
>     jiffies + HZ * state_lifetime);
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
> Giacomo.
> 
>
