From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Re: Unique rule ID?!
Date: Mon, 8 Nov 2004 22:32:50 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411082226010.21933@filer.marasystems.com>
References: <20041108134743.217B817BE5@grasshopper.anduras.de>
	<418FD708.3030302@anduras.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
In-Reply-To: <418FD708.3030302@anduras.de>
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

On Mon, 8 Nov 2004, Sven Anders wrote:

> | Only for patch-o-matic modules and intentionally so as there is good
> | reasons why these are not (yet) in mainline. Every breakage of what is in
> | mainline is a bug and gets fixed pretty quickly should it occur.
>
> Ok, thats correct. But I need many of the POM modules and so it does occure
> often.

Which you should expect when using work in progress (which is what POM 
represents).

> As I read, a new iptables version (1.3?) is comming, don't you think, now
> is the time to rethink the design and implement (or accept) new features
> to the API?

The API is being redesigned in pkttables.

> There are so many interesting new match and target modules in the POM,
> many are stable and could be taken to the mainline...

Many are being taken to mainline.

> My idea is to collect all necessary changes (or wishes) and discuss them.

This is what this list is intended for.

> Which POM modules should be taken to the mainline, should be discussed too...

You are welcome, so are any other subscribers here.

Please note that the pom inventory was quite recently discussed on the 
netfilter developer workshop, deciding which of the additions should go 
mainline and which not, with some motivations on each. The summary can be 
found in the workshop notes available in the documentation section of the 
web site.

Regards
Henrik
