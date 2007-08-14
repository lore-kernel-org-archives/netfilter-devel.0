From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH][CTNETLINK] Include the id in conntrack netlink events.
Date: Tue, 14 Aug 2007 08:34:06 +0200
Message-ID: <46C14CDE.5030803@trash.net>
References: <46C138AC.1000106@snapgear.com> <46C1451C.5040107@trash.net>
	<46C14B05.2000200@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46C14B05.2000200@snapgear.com>
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

Philip Craig wrote:
> Patrick McHardy wrote:
>   
>> Philip Craig wrote:
>>     
>>> I need the id in ctnetlink events for my application, so here's a
>>> patch to add it in case this wasn't left out intentionally.
>>>   
>> It was, we have plans to remove it. What for do you need it
>> exactly?
>
> So it won't be needed for dumping either?

No, I removed that in 2.6.23-rc.

>
> It's just a simple way of matching up events, so that I can log both
> start and finish time, as well as the other details.
>
> The alternative is to cache the tuples in userspace and match on them,
> but that is significantly more complicated.  And caching requires
> more memory usage than having an id in the kernel.
>   

True, but its quite a waste in the kernel as well when considering
that almost nobody needs this. I was thinking about derriving a
unique ID just for userspace from the conntrack address (in memory).
Its not unique over time, just as tuples aren't, but when combined
with the tuples it should only clash very rarely, and you'll always
get a DESTROY + NEW event before a clash. Would that work for you?
