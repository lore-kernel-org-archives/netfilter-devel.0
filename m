From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v4] netfilter: conntrack: clamp timeouts to INT_MAX
Date: Tue, 28 Nov 2017 01:12:44 +0100
Message-ID: <20171128001244.GE23412@breakpoint.cc>
References: <1510786873-60834-1-git-send-email-jelliott@arista.com>
 <20171127232429.GA29199@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jay Elliott <jelliott@arista.com>, fw@strlen.de,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45614 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752493AbdK1ANx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Nov 2017 19:13:53 -0500
Content-Disposition: inline
In-Reply-To: <20171127232429.GA29199@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Nov 15, 2017 at 03:01:13PM -0800, Jay Elliott wrote:
> > When the conntracking code multiplies a timeout by HZ, it can overflow
> > from positive to negative; this causes it to instantly expire.  To
> > protect against this the multiplication is done in 64-bit so we can
> > prevent it from exceeding INT_MAX.
> 
> This is something you must be observing via conntrack utility or
> conntrackd?

nf_ct_is_expired() will consider a ct as expired if the delta
between current time and the (future) timeout is > 2**31.

This triggers when ctnetlink configures a timeout larger than 2**31.

The patch looks correct to me.

Acked-by: Florian Westphal <fw@strlen.de>
