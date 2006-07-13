From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/10] updates for ctnetlink and conntrack core
Date: Thu, 13 Jul 2006 22:01:03 +0200
Message-ID: <44B6A67F.70102@netfilter.org>
References: <44ADC2EE.905@netfilter.org>
	<44ADED94.3010703@trash.net>	<44ADF800.80701@trash.net>
	<44ADFD1F.7050602@trash.net>	<44AE65C0.8030209@netfilter.org>
	<44B1DACC.5030309@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44B1DACC.5030309@trash.net>
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

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
> 
>>Patrick McHardy wrote:
>>
>>
>>>Patrick McHardy wrote:
>>>
>>>
>>>>[...]
>>
>>4% is not too much but it is something, anyway it is true that my
>>argument of bandwidth consumption is weak.
>>
>>But I still like patch 8, if the event cache works fine, I can't see why
>>we should force the dumping of all fields. BTW, patch 7 is a new feature
>>that I think that we need.
> 
> 
> Patch 7 is something we definitely want. For patch 8 we need to come
> to a conclusion on how ctnetlink should work first, I prefer to keep
> it similar to other network netlink protocols and have it send full
> update notifications, containing the entire current state.

If other network netlink protocols behave like that, I agree that we 
should send full update notifications, I like this argument. The only 
thing that annoys me is the limited netlink throughput, sending more 
data means that on stress situations an overflow could comes before.

> I also fail to see the difference it makes, of the four things that are
> dumped conditionally (status, refresh, protoinfo, helpinfo) the
> first three are always set for new conntracks. The last one only
> if we have a helper, but if we don't nothing is dumped anyway.

So, to keep consistency with other netlink subsystem, I can remake my 
patch based on this assumptions:

- NEW events dump everything but values that are unset like counters, 
mark, ...
- UPDATE events dump everything but unset fields and the counters, they 
don't provide very useful information AFAICS.
- DESTROY, dump everything, counters included.

Please let me know what you think.

>>>Some more unscientific tests: saving the netlink_trim call by using
>>>an allocation size of 200 reduces overhead for the entire notification
>>>function (including broadcasting) by about 13% (and also reduces
>>>the overruns experienced by conntrack -E for ~390000 packets with
>>>65536 new connections from 17 to 7, which I don't really understand
>>>since it shouldn't save any netlink bandwidth and this is a SMP system).
>>
>>
>>Who ever said that benchmarking can be scientific? :) I usually have to
>>redo my tests several times. These results are interesting but, in
>>previous discussions, I thought that we could not change current
>>allocation size because of memory fragmentation issues?
> 
> 
> I _decreased_ the size, the messages sent are about 150-200 bytes, yet
> we're allocating an entire page, which makes netlink clone the skb
> and shrink it to its actual size. We should just to it right ourselves.

OK, I see, sorry I misunderstood.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
