From: Patrick McHardy <kaber@trash.net>
Subject: Re: bloom filter in netfilter?
Date: Tue, 20 Mar 2007 16:43:30 +0100
Message-ID: <46000122.2030005@trash.net>
References: <45FFF8C3.9050606@info.ucl.ac.be>
	<45FFFCE5.6030705@netfilter.org>	<45FFFD2A.9080508@trash.net>
	<20070320153402.GA28954@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070320153402.GA28954@oknodo.bof.de>
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

Patrick Schaaf wrote:
>>>We can't just get rid of it since bloom filters have false positives, so
>>>it could happen that we could miss some new connections that are not
>>>actually in the conntrack table.
>>
>>That wouldn't be a big problem in my opinion, you can freely tune the
>>probability.
> 
> 
> Wouldn't two conntrack entries in the hash for the same tuples be
> catastrophic somewhere? (I have no idea, actually)


Yes, but bloom filters only have false positives (already in
hash, so skip confirmation), never false negatives, so that
would still not happen.

> The other thing about bloom filters that worries me, having read
> the wikipedia entry, is that you cannot remove elements. Probability
> of false positives thus increases as conntracks are added. And a
> future repetition of exactly the same tuple would certainly be
> a false positive. Tuples repeat pretty fast with things like BGP,
> and a filter regeneration seems to involve shuffling all current
> conntracks into a fresh bloom filter.
> 
> Either I misunderstand something fundamental, which is not
> unlikely, or that kills the idea.


You're right, tuple reuse is a problem, it seems counting bloom
filters would be needed to deal with that, which are a lot less
memory efficient. The increasing probabilities of false positives
with increasing number of entries could be dealt with by using a
second bloom filter that is filled with new entries once a low
threshold is exceeded and replaces the active one once a high
threshold is exceeded.

I have to admit that I'm a huge fan of bloom filters and always
wanted to use them for something cool :)
