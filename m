From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH 6/10][CTNETLINK] dump counters iif connection ended or
 counters filled up
Date: Fri, 07 Jul 2006 17:03:01 +0100
Message-ID: <44AE85B5.90108@ufomechanic.net>
References: <44ADC3BD.3050609@netfilter.org> <44ADE7BA.4030406@trash.net>
	<44AE66CA.8030705@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44AE66CA.8030705@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>
>>> This patch makes ctnetlink to dump counters iif connection reaches the
>>> destroy state or altenatively if counters filled up.
>>>
>>> AFAICS counters on NEW and UPDATE events doesn't provide interesting
>>> information, they just consume the limited netlink bandwidth.
>>>
>>> Upcoming conntrackd release in statistics mode uses counters from
>>> DESTROY events to keep the contability of traffic that the firewall has
>>> processed.
>>>
>>> I think that this patch should also reset counters upon fill up event,
>>> comments?
>>
>> Not sure, do you know any users of the counters besides conntrackd?
> 
> I don't know any ctnetlink user of the counters. Thinking it well this
> "counters fill up" issue is tricky. Since netlink is unreliable, what if
> the fill up event gets lost? we could reset counters and nobody would
> apparently notice. I think that we need an overflow bit in the conntrack
> that must be set whenever and overflow happens and unset such bit once
> the overflow event has been caught.
> 

What does it mean to "catch" the overflow even, esp as there may be
multiple clients each catching it (or not) for themselves.

A straight overflow is more simple. For clients that don't want to track
all counters, they can watch when the counter gets high, and then only
track counters that get so high, to count the number of wraps.

Sam
