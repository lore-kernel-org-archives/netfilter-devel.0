From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: MARK target extension
Date: Mon, 14 Jun 2004 22:59:56 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406142151150.1405-100000@filer.marasystems.com>
References: <20040614171913.M38596@metal.art.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
   Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Grzegorz Nosek <blackfire@metal.art.pl>
In-Reply-To: <20040614171913.M38596@metal.art.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 14 Jun 2004, Grzegorz Nosek wrote:

> S - a bit of the mask
> R - a bit of the mark value
> 
> SR |   | operation
> ---+---+-----------
> 00 | C | clear
> 01 | S | set
> 10 | N | no-op
> 11 | I | invert

Interesting encoding with a very nice kernel side algorithm.

> But still, I don't see how it allows for anything more than a simple
> 
>    newvalue = (oldvalue & mask) ^ value;

It doesn't. AND+XOR is logically complete and can represent all the 
bitwise logic operations in a very efficient manner in both space and 
time.

Note: The ~mask in CONNMARK was from the mask representing the bits to
modify, not the bits to save.

Regards
Henrik
