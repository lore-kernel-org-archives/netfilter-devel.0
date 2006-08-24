From: Patrick McHardy <kaber@trash.net>
Subject: Re: new ABI
Date: Thu, 24 Aug 2006 18:47:24 +0200
Message-ID: <44EDD81C.8030006@trash.net>
References: <200608142312.41851.max@nucleus.it>
	<20060816121653.GA31235@kriss.csbnet.se>
	<Pine.LNX.4.58.0608220901120.4038@blackhole.kfki.hu>
	<44EBE13E.9020605@trash.net>
	<Pine.LNX.4.58.0608240940130.8098@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0608240940130.8098@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> What makes me uneasy is that we want to control the network traffic (do
> firewalling) over a protocol which is managed by the network core itself.
> Somehow it hurts compartmentalization.

I don't really worry about that.

>>Reliability is not hard to achieve on the userspace->kernel path if you
>>don't mind eating one RTT for each rule update (which is not very
>>large), just send the update and wait for an ACK or an error, then
>>handle it.
> 
> 
> And how should the error be handled? Re-send the same request immediately
> and thus hammering the system? Or should we use a linear/exponential
> backoff? :-)

That depends on the error. For an error indicating receive buffer
overflow (which can only happen with multiple concurrent senders
on the userspace->kernel path) you can usually try to retransmit
immediately. As long as messages are queued one of the other
senders will stay in the kernel working off the netlink queue
(without beeing able to add any messages during that time),
so it shouldn't last long. Alternatively you can simply use blocking
IO. In the end there's no difference to setsockopt, you have
a maximum throughput and once you've hit it you run into problems.

> What if it's a RESTORE operation and we are in the middle of
> adding thousands of rules to the kernel. Should we then implement
> transactions and all successfully added rules be removed in the case of a
> fatal failure? (Allowing multiple alternate tables can solve it of
> course.)

We could do that. Thats the price of a non-atomic interface (on
the ruleset level). And I think we've learned what the price of
an atomic one is :)

>>>Yes. And I'd add one more priciple:
>>>
>>>+ All parts must be designed to take into account rule- and
>>>  (match/target) state-replication between firewalls in active-active
>>>  setups.
>>
>>Agreed, that would be nice to have (and not very hard).
> 
> 
> + Match/target versioning support, i.e. be able to specify
>   version-dependent features. That might require OR operation
>   support at some level in one rule:
> 
> # Handle two versions of the same module:
> -m foo --foo-version 2 <flags 2> --OR --foo-version 1 <flags 1>
> # Handle new or possibly missing module
> -m bar --bar-version 1 <flags 1> --OR --false|true|fatal-error|ignore-rule

Thats more of a userspace thing. Modules will always have to be
backwards compatible, so if new attributes are not understood,
use the old ones if the user is fine with it.
