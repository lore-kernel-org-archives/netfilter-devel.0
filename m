From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: Re: remove usage of __MOD_XXX_USAGE_COUNT and derivatives
Date: Mon, 13 Jan 2003 23:21:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E233BE7.7010205@fugmann.dhs.org>
References: <3E1DEF2D.4080703@fugmann.dhs.org> <200301122314.17191.bdschuym@pandora.be> <3E22F02E.8060800@fugmann.dhs.org> <200301132356.32182.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@gnumonks.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <200301132356.32182.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Bart De Schuymer wrote:
> On Monday 13 January 2003 17:58, Anders Fugmann wrote:
> 
>>Take two on conversion from MOD_INC/DEC_USAGE_COUNT.
>>
>>This version removes all MOD_INC_USAGE_COUNT and MOD_DEC_USAGE_COUNT, as
>>this is done automatically by the kernel itself.
>>
>>Whenever a module count is incremented and error can arise if the module
>>is currently beeing loaded or unloaded. I treat this error by returning
>>-EAGAIN, to signal that the operation should be retried.
>>
>>Attached it the patch against 2.5.56. It's only for IPv4, and will await
>>comment on this before convering IPv6.
> 
> 
> I see that other files than ip_tables.c use MOD_{INC,DEC}_USE_COUNT. I can 
> only say that for ip_tables.c (and arp_tables.c I guess) these are no longer 
> needed.

>It could be that simply removing these from another file (like 
> ip_nat_standalone.c) could cause kernel panics. For example, the bridge code
> uses these two macro's too and just removing them will cause a kernel panic 
> when removing a bridge device that is still used...
I see. The question is if it is actually a problem. If the bridging code 
uses anything from ip_nat_standalone, then module count would be 
automatically incremented? This needs to be examined.

> These changes should be well-thought of...
> Also, use correct spelling and don't overcomment stuff...
Overcommit? Please elaborate on that.

> You seem to be adding/changing code too, f.e. in arp_tables.c:
> 
> -           (newinfo->number > oldinfo->initial_entries))
> -               __MOD_INC_USE_COUNT(t->me);
> -       else if (t->me && (oldinfo->number > oldinfo->initial_entries) &&
> -                (newinfo->number <= oldinfo->initial_entries))
> -               __MOD_DEC_USE_COUNT(t->me);
> +
> +       /* Now decrement count by two if nessesary. */
> +       if ((oldinfo->number > oldinfo->initial_entries) || 
> +           (newinfo->number <= oldinfo->initial_entries)) 
> +               module_put(t->me);
> +       if ((oldinfo->number > oldinfo->initial_entries) &&
> +           (newinfo->number <= oldinfo->initial_entries))
> +               module_put(t->me);
> 
> Is that equivalent?
> 
No. In the old code __MOD_INC_USE_COUNT would always succeed. As 
try_module_get can return an error, the module count is incremented 
before the above code in order to handle the posibility of not beeing 
able to increment the module count. The logic decrements the module 
count after the operation by one, if the number of new rules is equal to 
or lower than the number of old rules, and decrement again if it's 
actually lower. So the logic is changed in order to handle possible 
errors from try_module_put. If all suceeds the module_count is set 
correctly, othervice module count is not touched at all.

Thanks for the comments.
Anders Fugmann
