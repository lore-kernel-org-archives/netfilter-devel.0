From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: New iptables structure (was: [PATCH 1/2] ipt_MARK extension with
 backwards compatibilty...)
Date: Mon, 29 Nov 2004 13:27:57 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411291322050.17340@filer.marasystems.com>
References: <1101358191.5842.26.camel@localhost.localdomain>
	<41A7B514.9030703@eurodev.net> <41A85AC4.5080006@anduras.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
In-Reply-To: <41A85AC4.5080006@anduras.de>
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

On Sat, 27 Nov 2004, Sven Anders wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
>
> Once again, we need a field more...

Yes, but in a completely different place, this time in a manner which can 
be done without too much disturbance, and at the same time building a good 
framework to allow targets & matches to evolve (which has not been 
possible up to now).

> Wasn't there an suggestion to reuse the 'nfcache' field too??

this because the core kernel does not allow us to add more skb fields than 
there are today. Not related to what is being discussed now. Modifying the 
SKB structure is simply not an option unless there is extremely good 
reasons why.

> Wasn't the need to an unique rule id posted?

It was, and as a compromise we now have the COMMENT match.

> Why not break compatibilty, if it hamper the development?

We can within POM, but not that easily in the main kernel.

> Admit it, the design has some flaws, why not eliminating them? You can 
> not preserve the compatibility forever!

This is what is being done with the pkttables design. Just takes a bit 
longer to get there than desireable..

Regards
Henrik
