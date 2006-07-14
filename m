From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/10][CTNETLINK] dump counters iif connection ended or
 counters filled up
Date: Fri, 14 Jul 2006 11:43:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0607141142290.17298@x2>
References: <44ADC3BD.3050609@netfilter.org> <44ADE7BA.4030406@trash.net>
	<44AE66CA.8030705@netfilter.org> <44B1DBE4.7010109@trash.net>
	<44B6A885.1010903@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44B6A885.1010903@netfilter.org>
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

On Thu, 13 Jul 2006, Pablo Neira Ayuso wrote:

> Patrick McHardy wrote:
>> If a message is lost userspace simply _must_ resync if it wants
>> reliability. If we reset the counter its impossible for userspace
>> to reconstruct the value at which it overflowed, so I don't think
>> we should do that. But you raise a good point, how should userspace
>> react to lost DESTROY messages that contain new information (like
>> counter values)? I don't see how it could reliable handle that case.
>
> I can't see any either at the moment :(
>
> BTW, something related to the overflow issue: what I'm currently doing in 
> conntrackd is the following thing, if an overflow is detected, the size of 
> socket buffer is duplicated via RCVBUFFFORCE and then it resyncs. I'll add a 
> clause to limit the socket buffer maximum growth. Can you see any problem 
> with this?

No, that seems reasonable as long as you place an upper limit on the
size.
