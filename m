From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/2] evaluate: prepare to store expr key rather than
 datatype
Date: Wed, 27 Sep 2017 14:19:51 +0200
Message-ID: <20170927121951.GA26052@salvia>
References: <20170919124954.26852-1-fw@strlen.de>
 <20170919124954.26852-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:35710 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752104AbdI0MTz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 08:19:55 -0400
Content-Disposition: inline
In-Reply-To: <20170919124954.26852-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 19, 2017 at 02:49:53PM +0200, Florian Westphal wrote:
> currently set definitions store a datatype rather than
> an expression.
> 
> In order to support use of unqualified data types (string in particular),
> this prepares implicit set definition helper to expect an expression instead
> of plain data type.  This also has the advantage that we can use EXPR_CONCAT
> to retain the original expressions when key concatentation is used, e.g.
> 'meta iifname . tcp dport'.  The netlink serialization code can use
> this info to store individual key lengths independently of data types.
> 
> Would also allow later on to store the original names of the
> expressions, e.g. "ip daddr", in the kernel to support a future
> typeof keyword, e.g. 'type typeof(ip daddr)' instead of 'type ipv4_addr'.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
