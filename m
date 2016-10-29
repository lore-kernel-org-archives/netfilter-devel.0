From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] Correct manpage description of -n / --numeric option
Date: Sat, 29 Oct 2016 04:47:40 +0200
Message-ID: <20161029024740.GC30951@breakpoint.cc>
References: <1477707863-19649-1-git-send-email-jon@endpoint.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jon Jensen <jon@endpoint.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38492 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751900AbcJ2CtN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2016 22:49:13 -0400
Content-Disposition: inline
In-Reply-To: <1477707863-19649-1-git-send-email-jon@endpoint.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jon Jensen <jon@endpoint.com> wrote:
> "When used twice" was used twice. :) Make it match the description in
> main.c instead.
 
>  						Numeric output: Addresses and other information
>  						that might need network traffic to resolve to symbolic names
> -						are shown numerically (default behaviour). When used twice,
> +						are shown numerically (default behaviour). When used once,
>  						internet services are translated. When used twice, internet
>  						services and UIDs/GIDs are also shown numerically. When used
>  						three times, protocol numbers are also shown numerically.

That paragraph doesn't match what nft is doing:

nft list table filter
ip saddr 127.0.0.1 tcp dport ssh skuid "root"
nft -n list table filter
ip saddr 127.0.0.1 tcp dport ssh skuid "root"
nft -nn list table filter
ip saddr 127.0.0.1 tcp dport 22 skuid "root" // doc says this would be 'skuid 0'
src/nft -nnn list table filter
ip saddr 127.0.0.1 tcp dport 22 skuid 0

So I suggest a rewrite of that section, e.g.

Numeric output: Addresses and other information
that might need network traffic to resolve to symbolic names
are shown numerically (default behaviour).  When used twice, internet
services (port numbers) are shown numerically. When used
three times, protocol numbers and UIDs/GIDs are also shown numerically.

(I don't like the repeated use of 'shown numerically', but I don't have
a better idea at the moment, and also don't care that much about this ..)
