From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] netfilter: conntrack: clamp timeouts to INT_MAX
Date: Tue, 28 Nov 2017 01:14:57 +0100
Message-ID: <20171128001457.GA1805@salvia>
References: <1510786873-60834-1-git-send-email-jelliott@arista.com>
 <20171127232429.GA29199@salvia>
 <20171128001244.GE23412@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jay Elliott <jelliott@arista.com>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48926 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752493AbdK1APC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Nov 2017 19:15:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9166AE2C42
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 01:15:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80AF3DA804
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 01:15:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171128001244.GE23412@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 28, 2017 at 01:12:44AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Nov 15, 2017 at 03:01:13PM -0800, Jay Elliott wrote:
> > > When the conntracking code multiplies a timeout by HZ, it can overflow
> > > from positive to negative; this causes it to instantly expire.  To
> > > protect against this the multiplication is done in 64-bit so we can
> > > prevent it from exceeding INT_MAX.
> > 
> > This is something you must be observing via conntrack utility or
> > conntrackd?
> 
> nf_ct_is_expired() will consider a ct as expired if the delta
> between current time and the (future) timeout is > 2**31.
> 
> This triggers when ctnetlink configures a timeout larger than 2**31.
> 
> The patch looks correct to me.
> 
> Acked-by: Florian Westphal <fw@strlen.de>

I'll pass this to net instead, this is likely breaking conntrackd.

Thanks.
