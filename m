From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: tcp match silently drops packets
Date: Mon, 17 Oct 2005 21:30:21 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0510172114290.23546@filer.marasystems.com>
References: <E1ERGOc-0008Hg-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <E1ERGOc-0008Hg-00@gondolin.me.apana.org.au>
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

On Mon, 17 Oct 2005, Herbert Xu wrote:

>> The reason why this match hotdrops such packets is to deal with attacks
>> using fragmented packets in a reasonably secure manner without having to
>> rely on "UNCLEAN" or similar. A TCP packet so small that it does not even
>> include the TCP header is below the minimum MTU allowed and you should not
>> see any such fragments in normal traffic.
>
> Not having any TCP header at all or not having the complete TCP header?

Not having the complete TCP header (excluding TCP options unless you 
also match for options).

> The latter is possible because the minimum fragment payload length is
> 8 bytes.

Yes, but not if the minimum allowed MTU of the available transports (not 
including ATM) is accounted for. If you account for the minimum allowed 
MTU on these transports then the smallest possible fragment is a bit 
larger and these very small fragments is only seen if explicitly created 
by "hacker" or similar trying to avoid packet filters (and quite 
succesfully so in many simpler implementations).

Regards
Henrik
