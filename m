From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft RFC PATCH 0/6] events
Date: Tue, 18 Feb 2014 01:43:49 +0000
Message-ID: <20140218014348.GD12893@macbook.localnet>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54687 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaBRBnx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:43:53 -0500
Content-Disposition: inline
In-Reply-To: <20140217231654.19943.18736.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 18, 2014 at 12:18:06AM +0100, Arturo Borrero Gonzalez wrote:
> This series implements basic event reporting in the nftables CLI tool.

Nice.

> The first patches are some neccesary code factorization changes.
> The last patch is the event reporting itself.
> 
> Its quite simple, the syntax is:
>  % nft event <all|table|chain|rule|set> [xml|json]

So far we're pretty much (except for shortcuts like default "add rule")
following the scheme "nft action object". "event" doesn't fit in this
scheme, so I'd propose to change this to "monitor". Also I guess object
specification could be optional so "all" wouldn't be needed, but that's
not too important.

> To quit, fire CTRL+C (^C).
> 
> Currently, 3 possible output formats:
>  * A basic XML, provided by libnftnl.
>  * A basic JSON, provided by libnftnl.
>  * nft default-like syntax.
> 
> About this last format:
> 
> Rules are hard to print exactly as the user typed because sets and other
> nuances. Possible solutions I've found:
>  - assume that an anonymous set event will happen always before a new rule event.
>  Cache the anon-set for the following rule event.
>  Maybe there are many anon-sets per rule.

That should work fine. But why only cache one set? Basically you can assume
all anonymous sets to be constant once they have been bound.

>  - when a rule event happens, query for sets inside the event cb.
>  - for this to run smoothly, we need to keep tables info in sync with the
>  kernel, so in each relevant event, the netlink_ctx is needed to be updated and
>  this allows to reuse netlink_delinearize_rule().
> 
> But I think this first approach is valid.
> 
> So, the format with this series is as follow:
> 
>  % nft event all
> delete table ip6 filter
> add table ip6 filter
> add chain ip6 filter input { type filter hook input priority 0;}
> add chain ip6 filter forward { type filter hook forward priority 0;}
> add chain ip6 filter output { type filter hook output priority 0;}
> add rule ip6 filter input handle 4

No expressions in the output? Why the set caching then?

> delete rule ip6 filter input handle 4
> add set ip6 filter set1 {type ipv6_address}

Inconsistent wrt. chain blocks. We should have spaces between {} and
the content and too make things parsable it should contain a statement
separator (;) in the single line output.

> delete chain ip6 filter input
> delete set ip6 filter set1
