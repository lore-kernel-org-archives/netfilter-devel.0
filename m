From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH 6/10][CTNETLINK] dump counters iif connection ended or
 counters filled up
Date: Fri, 07 Jul 2006 09:25:24 +0100
Message-ID: <44AE1A74.2000503@ufomechanic.net>
References: <44ADC3BD.3050609@netfilter.org> <44ADE7BA.4030406@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44ADE7BA.4030406@trash.net>
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
>> This patch makes ctnetlink to dump counters iif connection reaches the
>> destroy state or altenatively if counters filled up.
>>
>> AFAICS counters on NEW and UPDATE events doesn't provide interesting
>> information, they just consume the limited netlink bandwidth.
>>
>> Upcoming conntrackd release in statistics mode uses counters from
>> DESTROY events to keep the contability of traffic that the firewall has
>> processed.
>>
>> I think that this patch should also reset counters upon fill up event,
>> comments?
> 
> Not sure, do you know any users of the counters besides conntrackd?
> I would like to look at how they're used.

I have a client daemon that reads the output of conntrackd, I would
prefer overflow rather than zero-ing. A main advantage is that "missing"
and event (netlink packet dropped) would not loose any information as
the overflow is visible by the fact that the counters are less than the
previous logged value and presuming they didn't overflow twice, its
obvious how much data passed in the mean time.

We could effectively increase the counter size by making the
counter-filled mask be the top few bits instead of just the top bit.
Then to actually wrap sooner (nearest thing to resetting that I like) we
just clear these top few bits.

Sam
