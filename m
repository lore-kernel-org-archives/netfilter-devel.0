From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [2.6.14-rt1] slowdown / oops.
Date: Thu, 03 Nov 2005 13:09:01 +1100
Message-ID: <1130983742.8734.19.camel@localhost.localdomain>
References: <200511021420.28104.pluto@agmk.net>
	<20051102134723.GB13468@elte.hu> <20051102135516.GA16175@elte.hu>
	<20051102140025.GA17385@elte.hu> <20051102142533.GA18453@elte.hu>
	<20051102151242.GA23809@elte.hu>  <20051102153352.GA26115@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	linux kernel mailing list <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20051102153352.GA26115@elte.hu>
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

On Wed, 2005-11-02 at 16:33 +0100, Ingo Molnar wrote:
> local_bh_disable()/enable() is a NOP under PREEMPT_RT, and the 
> ip_ct_deliver_cached_events PER_CPU code relies on not being preempted 
> by the net_rx_action softirq handler. So this is a bug in PREEMPT_RT and 
> the upstream code should be fine.
> 
> 	Ingo
> 
> Index: linux/net/ipv4/netfilter/ip_conntrack_core.c
> ===================================================================
> --- linux.orig/net/ipv4/netfilter/ip_conntrack_core.c
> +++ linux/net/ipv4/netfilter/ip_conntrack_core.c
> @@ -105,11 +105,11 @@ void ip_ct_deliver_cached_events(const s
>  {
>  	struct ip_conntrack_ecache *ecache;
>  	
> -	local_bh_disable();
> +	read_lock_bh(&ip_conntrack_lock);
>  	ecache = &__get_cpu_var(ip_conntrack_ecache);
>  	if (ecache->ct == ct)
>  		__ip_ct_deliver_cached_events(ecache);
> -	local_bh_enable();
> +	read_unlock_bh(&ip_conntrack_lock);

This kind of change is troubling.  I suppose we could go to per-cpu
locks, but it's still a loss.

Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
