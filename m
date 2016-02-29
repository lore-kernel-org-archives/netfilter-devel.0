From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] src: netlink_delinearize: Fix datatype for len
Date: Mon, 29 Feb 2016 11:06:32 +0100
Message-ID: <20160229100632.GA7277@breakpoint.cc>
References: <20160228194043.GA15021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45841 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126AbcB2KGf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Feb 2016 05:06:35 -0500
Content-Disposition: inline
In-Reply-To: <20160228194043.GA15021@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> Change the data type of len from unsigned int to int in order to make
> it valid for checks like
> 
> if (len < 0)
> 
> The issue was brought into attention by the unexplained behavior of
> frag with frag-off. Bugzilla entry:
> https://bugzilla.netfilter.org/show_bug.cgi?id=935
> 
> This patch fixes this bug, however there are still issues with frag
> that need to be fixed.

exthdr (frag) seems to have several issues:

- we should reject exthdr and only allow it with ipv6.
- for inet/bridge, we should also inject ipv6 dependency
- some exthdrs (frag for instance) have odd bit lengths
  and need mask/shift instructions.

For example, in your example rule we generate:
   [ exthdr load 1b @ 44 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00002100 ]

But thats not correct -- we truncated the load to one byte.
Instead we should have loaded 2 bytes and then masked off the extra 3bits.

I'll work on this.
