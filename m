From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink questions
Date: Sun, 15 Feb 2004 11:01:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <402F4366.7020302@trash.net>
References: <Pine.LNX.4.33.0310200909590.12485-100000@blackhole.kfki.hu> <Pine.LNX.4.44.0310201107510.23768-100000@filer.marasystems.com> <20040206185242.GM2312@obroa-skai.de.gnumonks.org> <4028D0E5.8000003@trash.net> <20040214200326.GQ7756@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040214200326.GQ7756@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> On Tue, Feb 10, 2004 at 01:39:01PM +0100, Patrick McHardy wrote:
>
>>but the other use for IDs was to continue an interrupted
>>dump at the right place, how can we solve this ? The problematic case
>>is when a single hash-chain doesn't fit into an skb. We need to remember
>>the last one dumped somehow, and be able to continue at the next one
>>not dumped even when the last one dumped is gone when the dump
>>continues.
> 
> 
> We'd have to ensure that a single hash chain is not longer than what we
> could put into one skb.  This can be done by limiting the maximum number
> of entries in a bucket (and then rehash).  Also, we should increase the
> default number of hash buckets to reduce the probability that this might
> happen.

I like the idea. So assuming that long hash chains are a result of "bad
luck" with the jenkins hash, we would just change the secret, rehash,
and repeat if some chains are still too long ? At what point do you
propose rehashing, at the moment the chain length exceeds some threshold
(or thereafter, defered to occur out of packet processing context), or
when dumping over netlink ?

> 
> Also, Jozsef proposed a flip/flop bit mechanism that would solve that
> problem.  What do you say to his proposal?
> 

Can I find his proposal somewhere ?

> 
>>Patrick
> 
> 
