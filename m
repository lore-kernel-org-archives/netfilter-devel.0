From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] [PATCH] ctnetlink updates
Date: Sun, 03 Apr 2005 20:01:49 +0200
Message-ID: <42502F8D.5030504@trash.net>
References: <424747E3.7000300@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <424747E3.7000300@eurodev.net>
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

Pablo Neira wrote:
> I've ported nfnetlink-ctnetlink to 2.6 ip_conntrack to make the 
> transition easier. So my intentions are porting it to nfconntrack once 
> it gets pushed forward. My work is done on top of the ct-event-API.
> 
> There are some issues I'd like to discuss:
> 
> o Declaring ID as unsigned int. I think it's just fine.
> 
>     - A conntrack must be identified with one of the tuples (original or 
> reply) and its id. That way it can be uniquely identified.

Good idea, although I'm not completely convinced.

>     - Using u_int64_t just reduces the possibility of the wrapping 
> around but such possible problem is still there.

The time until a wrap is many many years even if you assume very
high connection rate and many CPUs, so its not a practical problem.
The difference to your solution is that you can tell for sure that
clashes won't occur until a date under known conditions. I dislike
the idea of an unreliable API that has no possibilty of even noticing
and/or handling the error, so I'm not sure about this.

> o dump_table() has problems once wrapping around happens.
> 
>     - The ordered list isn't ordered anymore once id wrapping around 
> happens. New conntracks with low id's are inserted at the end. While 
> dumping the table, the branch that compares that ct->id <= cb->args[0] 
> returns true and those new conntracks aren't dumped.
> 
> I've introduced a function that inserts conntrack ordered by id in the 
> buckets.

I don't like this, but lets talk about the other problem first,
maybe it will just go away :)

Regards
Patrick
