From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nftables] rt: update test scripts and fix documentation
Date: Sat, 29 Oct 2016 03:22:03 +0200
Message-ID: <20161029012203.GA30951@breakpoint.cc>
References: <1477682729.1059.60.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38432 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935196AbcJ2BXg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2016 21:23:36 -0400
Content-Disposition: inline
In-Reply-To: <1477682729.1059.60.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anders K. Pedersen | Cohaesio <akp@cohaesio.com> wrote:
> Replace tests/files/expr-rt with Python based tests, and replace ether type
> with meta nfproto, which generates a bit fewer instructions.
> 
> Signed-off-by: Anders K. Pedersen <akp@cohaesio.com>
> ---
>  doc/nft.xml                |  6 +++---
>  src/evaluate.c             |  4 ++--
>  tests/files/expr-rt        | 21 ---------------------
>  tests/py/any/rt.t          |  7 +++++++
>  tests/py/any/rt.t.payload  |  5 +++++
>  tests/py/inet/rt.t         |  8 ++++++++
>  tests/py/inet/rt.t.payload | 14 ++++++++++++++
>  tests/py/ip/rt.t           |  6 ++++++
>  tests/py/ip/rt.t.payload   |  5 +++++
>  tests/py/ip6/rt0.t         |  6 ++++++
>  tests/py/ip6/rt0.t.payload |  5 +++++

Why rt0.t and not ip6/rt.t?  (I can fix this locally, no need to resend)

