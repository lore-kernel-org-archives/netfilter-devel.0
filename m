From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] update raw patch in POM
Date: Mon, 27 Jun 2005 12:57:37 +0200
Message-ID: <42BFDBA1.7060002@trash.net>
References: <42A6AB19.2040106@tac.ch>	<42A6E685.3060408@eurodev.net>	<42AEF774.8060300@tac.ch>	<42B67BEC.1090105@tac.ch>	<20050621003441.GI8335@postel.suug.ch>	<42B76474.8080209@eurodev.net>	<20050621111328.GK8335@postel.suug.ch>	<42B81D75.8090205@trash.net>	<20050621215027.GP8335@postel.suug.ch>	<42B8B181.4020607@trash.net>	<20050622005243.GQ8335@postel.suug.ch>	<42B8DA09.9080406@eurodev.net>	<42B8E141.1080902@trash.net>
	<42B94DFE.2070205@tac.ch> <42B9B00F.90601@trash.net>
	<42BF9E5D.4000705@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <42BF9E5D.4000705@tac.ch>
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

Roberto Nibali wrote:

>>>Jun 22 15:12:48 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
>>>Jun 22 15:12:53 s_int@sem-arbeit ip_conntrack version 2.1 (8192
>>
>>buckets, 65536 max) - 324 bytes per conntrack
>>
>>This actually looks good, no leak, no crash. Not sure where the 30
>>second delay comes from, my guess is that packets are queued while
>>the neighbour is resolved, although its pretty long.
> 
> 
> What neighbour needs to be resolved? The neighbour cache is full, only 4
> addresses are involved, gc threshold is high, so no trashing. Or are we talking
> different issues?

It was just a guess, I can't think of anywhere else where packets
might have been queued for 30s, given that you have no packet
sockets and probably don't have a long enough device queue that
it would take 30s.

>>To confirm that
>>theory you could play with the values in
>>/proc/sys/net/ipv4/neigh/default and see if it changes anything.
> 
> 
> I'll do that. How do you think I should instrument these values? And what does
> the neighbour stuff have to do with conntrack timeouts?

Try halving all values and see if it has any effects on the time
it takes to unload the module.

>>How long did you wait that time?
> 
> 
> Shoot, I really don't remember, sorry. I thought it was more than 30 seconds but
> I really can't tell.
> 
> I'll run some more tests and see if this 30 seconds delay can be reduced.

I'm pretty sure the nf_reset + the wait-for-untracked-refs patches
should take care of the problem, but to be sure it would be good
to know where the delay came from.

Regards
Patrick
