From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: New API / POM modules to merge.... (was: Unique rule ID?!)
Date: Tue, 9 Nov 2004 20:09:07 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411092003470.7243@filer.marasystems.com>
References: <20041108134743.217B817BE5@grasshopper.anduras.de>
	<418FD708.3030302@anduras.de>
	<Pine.LNX.4.61.0411082226010.21933@filer.marasystems.com>
	<4190E80C.8020106@anduras.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
In-Reply-To: <4190E80C.8020106@anduras.de>
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

On Tue, 9 Nov 2004, Sven Anders wrote:

> | The API is being redesigned in pkttables.
>
> Is there documentation for the new API available?

It is "currently" being designed from what I know. Harald?

> Some question:
>
> ~ 1. "TTL or HOPLIMIT: no, it's dangerous"
>
> ~    Why? Don't use it, if it's dangerous - or does it crash the kernel?

It (TTL) in it's current form violates fundamental aspects of IP, easily 
allowing the administrator to "accidently" create configurations which 
will crash the network.

In case of the TTL match it should be sufficient to change

         if (new_ttl != iph->ttl) {

to

         if (new_ttl < iph->ttl) {

and remove the increase option to make it safe, but at the same time you 
loose a lot of the powers of this target so it may not be desireable to 
make this change..

Regards
Henrik
