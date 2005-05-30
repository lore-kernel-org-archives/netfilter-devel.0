From: Damon Gray <dgray@internap.com>
Subject: Re: module access to conntrack tcp timeouts
Date: Mon, 30 May 2005 14:16:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0505301410540.25941@dgray-test.acs.internap.com>
References: <Pine.LNX.4.62.0505271238130.2297@dgray-test.acs.internap.com>
	<20050530180012.GW22760@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050530180012.GW22760@sunbeam.de.gnumonks.org>
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


I'm writing an enhancement to the connlimit module that will allow for an 
"over limit" timeout. This will allow you to have a very long tcp 
established timeout until you go over the limit of number of connections, 
it will then delete the conntrack entry if it has been idle for the 
timeout you set in connlimit. To calculate how long it has been idle you 
can do the calculation:

idle=ip_ct_tcp_timeout_established-(found_ct->timeout.expires - jiffies)

I'm open to other suggestions for calculating the idle time on a tcp 
established conntrack entry.

Thanks

-Damon-

On Mon, 30 May 2005, Harald Welte wrote:

> On Fri, May 27, 2005 at 12:43:12PM -0400, Damon Gray wrote:
>>
>> A module I'm working on needs to know what the current conntrack timeout for
>> tcp established is. The variable is ip_ct_tcp_timeout_established in
>> ip_conntrack_proto_tcp.c. What is the best way to go about getting access to
>> this information from another kernel module? Sysctl? Proc? Can you access
>> sysctl information from the kernel?
>
> As usual, the first question would be: Why do you need that kind of
> information in the first place?  Understanding this will help us to
> recommend possible options.
>
> -- 
> - Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
> ============================================================================
>  "Fragmentation is like classful addressing -- an interesting early
>   architectural error that shows how much experimentation was going
>   on while IP was being designed."                    -- Paul Vixie
>
