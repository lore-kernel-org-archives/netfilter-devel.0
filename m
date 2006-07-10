From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/10][CTNETLINK] dump counters iif connection ended or
 counters filled up
Date: Mon, 10 Jul 2006 06:47:32 +0200
Message-ID: <44B1DBE4.7010109@trash.net>
References: <44ADC3BD.3050609@netfilter.org> <44ADE7BA.4030406@trash.net>
	<44AE66CA.8030705@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
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
> 
>> Pablo Neira Ayuso wrote:
>>
>>> I think that this patch should also reset counters upon fill up event,
>>> comments?
>>
>>
>> Not sure, do you know any users of the counters besides conntrackd?
> 
> 
> I don't know any ctnetlink user of the counters. Thinking it well this
> "counters fill up" issue is tricky. Since netlink is unreliable, what if
> the fill up event gets lost? we could reset counters and nobody would
> apparently notice. I think that we need an overflow bit in the conntrack
> that must be set whenever and overflow happens and unset such bit once
> the overflow event has been caught.


If a message is lost userspace simply _must_ resync if it wants
reliability. If we reset the counter its impossible for userspace
to reconstruct the value at which it overflowed, so I don't think
we should do that. But you raise a good point, how should userspace
react to lost DESTROY messages that contain new information (like
counter values)? I don't see how it could reliable handle that case.
