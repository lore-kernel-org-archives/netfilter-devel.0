From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft,RFC] rule: introduce new option to print set elements per
 line
Date: Tue, 25 Apr 2017 11:20:10 +0200
Message-ID: <20170425092010.GA21171@breakpoint.cc>
References: <149277062417.14594.14270713486442491994.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47770 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1177301AbdDYJUO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 05:20:14 -0400
Content-Disposition: inline
In-Reply-To: <149277062417.14594.14270713486442491994.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arturo Borrero Gonzalez <arturo@debian.org> wrote:
> Add a new option to nft to print set elements per line instead
> of all in a single line.
> This is useful when printing a ruleset with very big sets.
> 
> The new option is -t/--elements.
> 
> Annonymous sets/maps/concats are not affected by this. The default
> behaviour is not changed.

Nice patch, thanks Arturo!
Why make this an option in first place?

> % nft list ruleset -t -nn
> table ip t {
> 	set s {
> 		type inet_service
> 		elements = { 1,
> 				2,
> 				3,
> 				4,
> 				12345 }
> 	}

How hard would it be to make it so that this is still
printed in single line (enough space left)?

> 	set s2 {
> 		type ipv4_addr . inet_service
> 		elements = { 1.1.1.1 . 22,
> 				1.1.1.1 . 222,
> 				1.1.1.1 . 2222,
> 				2.1.1.1 . 22222 }
> 	}

But not this?

Printing all addresses in a single line is unreadable, it seems
strange to have an option to make it nice and then make 'unreadable'
the default :)
