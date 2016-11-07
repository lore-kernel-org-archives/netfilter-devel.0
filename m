From: Florian Westphal <fw@strlen.de>
Subject: Re: nfqueue: Get pid of socket owner
Date: Mon, 7 Nov 2016 18:09:33 +0100
Message-ID: <20161107170933.GC24908@breakpoint.cc>
References: <71D00C03-A2AD-4836-8F5F-724AECE75DE6@jazznetworks.com>
 <20161107163832.GB24908@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Buchmann <david@jazznetworks.com>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38880 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753554AbcKGRLc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Nov 2016 12:11:32 -0500
Content-Disposition: inline
In-Reply-To: <20161107163832.GB24908@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> David Buchmann <david@jazznetworks.com> wrote:
> > I've started work to add support in the nfnetlink_queue kernel module for
> > sending the pid of the process owning the socket triggering nfqueue, and I
> > want to add the userspace support in libnetfilter_queue, but before I get
> > too invested in that work I just want to check whether there are any
> > objections to such a feature in either the kernel or in the
> > libnetfilter_queue library?
> > 
> > https://github.com/wuurrd/linux/commit/79d12e93ca2a28c0939937a5a690943311e4bf6c
> 
> I think this should just be added to nfqnl_put_sk_uidgid(), and just use
> the new sk->sk_uid that got added to net-next recently:

Grrr, too late, sorry :/

I think you should add this to nfqnl_put_sk_uidgid though, no need to
grab the locks twice.

We'd also have to add appropriate warnings that this pid isn't reliable.
