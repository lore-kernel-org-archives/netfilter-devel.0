From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] BUG: libiptc chain references bug
Date: Mon, 17 Jul 2006 00:31:39 +0200
Message-ID: <44BABE4B.70008@netfilter.org>
References: <Pine.LNX.4.61.0607121722360.13610@ask.diku.dk>
	<Pine.LNX.4.61.0607131303220.29013@tyr.diku.dk>
	<Pine.LNX.4.61.0607141427230.31153@tyr.diku.dk>
	<44BA54E1.1000908@netfilter.org>
	<Pine.LNX.4.61.0607162125500.31595@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: hawk@comx.dk, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jesper Dangaard Brouer <hawk@diku.dk>
In-Reply-To: <Pine.LNX.4.61.0607162125500.31595@ask.diku.dk>
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

Jesper Dangaard Brouer wrote:
> On Sun, 16 Jul 2006, Pablo Neira Ayuso wrote:
>> Jesper Dangaard Brouer wrote:
>>>
>>> Correcting a chain references increment bug in libiptc.
>>>
>>> The bug lies in function iptc_delete_entry() / TC_DELETE_ENTRY.  The
>>> problem is the construction of "r" the rule entry, that is used for
>>> comparison. The problem is that the function iptcc_map_target()
>>> increase the target chains references count.
>>>
>>> The fix is to use function iptcc_delete_rule() to delete the "r" rule
>>> (as it decrement the counter again). To make it work a small NULL
>>> pointer check is also added iptcc_delete_rule().
>>>
>>> Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
>>
>>
>> I don't like too much the is-the-rule-in-list checking in 
>> delete_entry, please, could you tell me what you think about the patch 
>> attached? I think it's cleaner. Thanks.
> 
> First of all, (no offence) your patch will not work, as it does not 
> catch all control-flow cases. That is, if no match was found your patch 
> does not decrement the refcount. Hint, look at the places free(r) is 
> called.

You are right, I missed that exit path.

> I have attached a patch, that does catch all cases.  This is achived by 
> adding a else statement to the if statement where iptcc_map_target is 
> called.

I think I prefer this one, let see what Patrick thinks.

> I did consider, your strategy, but the reason I decided not to, was that 
> I though it was cleaner to always call "iptcc_delete_rule" when we want 
> to delete a rule, instead of free'ing it manually.
> 
> Well, I think Patrick should make the decision. As long as we fix the 
> bug, I don't care which patch goes in.
> 
> Cheers,
>   Jesper Brouer
> 
> p.s. Pablo, I was not going to piss in the bush... I was just discussing 
> with Gert Hansen about how dry the plant was... Perhaps the plant would 
> have preferred that I would have taken a leak... See you around ;-)

That bush surely would prefer it these damned hot days of summer 8)

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
