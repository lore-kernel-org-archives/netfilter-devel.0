From: Patrick McHardy <kaber@trash.net>
Subject: Re: [H.323 Helper 1/3]: Add support for Call Forwarding
Date: Wed, 26 Apr 2006 22:21:35 +0200
Message-ID: <444FD64F.5020002@trash.net>
References: <BAY109-DAV265AE2E1870989462F689B3BE0@phx.gbl>
	<444F7A3F.9080507@trash.net>
	<BAY109-DAV1099B645E5820953632189B3BC0@phx.gbl>
	<444FA4A7.7060105@trash.net>
	<BAY109-DAV107DE91F0E0B272EC778E4B3BC0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb18030
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
In-Reply-To: <BAY109-DAV107DE91F0E0B272EC778E4B3BC0@phx.gbl>
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

Jing Min Zhao wrote:
>>>>I definitely don't like the internal_net module option. I know its not
>>>>strictly required, more an optimization, but still limiting this to only
>>>>one network is not a good idea. We may be able to use the routing
>>>>information as indication whether we need an expectation or not .. but
>>>>I need think about it some more.
>>>>
>>>>
>>>
>>>I also want such a solution deadly, but I can't figure out a way. 
>>>Actually, the only question is how can a firewall tell that any two 
>>>endpoints can talk with each other directly without passing though it.
>>>Any suggestion for this will be greatly appreciated.
>>
>>There is no general way to do this, but we I think we can take a good
>>guess for the common case of no weird NATing etc based on the nexthop
>>information we get from fib_lookup(). I think an assumption that is
>>true for most cases is that if the nexthop information is identical,
>>the two endpoints can reach each other without our help. It needs to
>>be optional of course. What do you think about this?
>>
>>
> 
> This is a good idea, and it's probably the best that a firewall can do.
> I'll think about it.

BTW, I can give you some help implementing this if you need.
