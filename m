From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] new match extension `flow'
Date: Wed, 10 Nov 2004 19:12:11 +0100
Message-ID: <419259FB.9080008@eurodev.net>
References: <20041028020550.GA10097@wsc.edu> <41829ADC.2090708@eurodev.net>
	<20041031063813.GA29402@wsc.edu> <4184F9AD.9040902@eurodev.net>
	<20041104022039.GA25749@wsc.edu> <418CEB7A.9080505@eurodev.net>
	<20041108025241.GA4850@wsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Josh Samuelson <josamue1@wsc.edu>
In-Reply-To: <20041108025241.GA4850@wsc.edu>
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

Josh,

Josh Samuelson wrote:

>>Some comments:
>>
>>    
>>
>>>diff -Pru linux-2.6.9/include/linux/netfilter_ipv4/ip_cte_flow.h 
>>>linux-2.6.9-flow/include/linux/netfilter_ipv4/ip_cte_flow.h
>>>--- linux-2.6.9/include/linux/netfilter_ipv4/ip_cte_flow.h	1969-12-31 
>>>18:00:00.000000000 -0600
>>>+++ linux-2.6.9-flow/include/linux/netfilter_ipv4/ip_cte_flow.h 2004-11-03 
>>>19:10:13.000000000 -0600
>>>
>>>
>>>      
>>>
>>I see two possibilities here:
>>
>>a) move ip_cte_flow.[h|c] to ipt_flow.[h|c], matches always fit in a file.
>>b) rename ip_cte_flow to ip_conntrack_flow_stats, this could be a module 
>>which generates stats about current connections going through the firewall.
>>
>>I need to give more spins to this issue.
>>
>>Any comments?
>>
>>Pablo
>>    
>>
>
>In regards to ip_cte_flow.[h|c], I wasn't sure how to handle this module
>with respect to the filesystem namespace.  Those files don't provide
>any of the match functionality; it just tracks the flows from the CTE
>API, exports a few functions, the linked list of flows and provides
>"/proc/net/ip_cte_flow" file.  All of which I'm sure you know by the
>source, but just to provide some context for those who perhaps haven't
>glanced at it.  The main reason I called ip_cte_flow was because it's
>built on/requires 'CTE' functionality.  I figure there is the
>potential for a lot of modules needing the CTE API
>

At this moment I can't imagine any other match/target which could use 
this CTE API, do you have anything in mind? I mean, I think that if only 
the flow match uses it (and noone else could benefit of it), it should 
go inside the flow match. In case that someone else could use it, then 
it makes sense for me to provide such API.

> and perhaps the need
>to separate those files that require it into a differing filesystem
>namespace that can't really be classified as a match/target, etc?
>If you prefer ip_conntrack_flow_stats, I'm really not partial to
>anything.
>  
>

I don't mind about the name either. I think that maybe it could be used 
to generate statistics about the current connections going through the 
firewall, in that case it makes sense creating a module in the namespace 
of ip_conntrack_whatever.

But I think that those statistics could be done with an user space 
program via ctnetlink API (netlink sockets), so this makes me thinks 
that we should put all the stuff in a single ipt_flow file.

>The ipt_flow.[h|c] file builds on top of the prior module to provide the
>match functionality and to track network/mask based flows.  I separated the
>two because I can see the need to track the flows via /proc outside of the
>iptables match.  I.e. to just have a quick glance at who may be responsible
>for a sudden burst of flows.  Or to allow for other match modules
>to build on top of it in ways that my simple match module lacks, etc.
>
>Those are my thoughts on why I did things the way I did.  :)
>  
>

nice, see your next email :)

Pablo
