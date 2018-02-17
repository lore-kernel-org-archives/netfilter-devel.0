From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH RFC 0/4] net: add bpfilter
Date: Sat, 17 Feb 2018 13:21:49 +0100
Message-ID: <20180217122149.GJ7843@nataraja>
References: <20180216134023.15536-1-daniel@iogearbox.net>
 <20180216145727.GC32618@breakpoint.cc>
 <20180216161408.GA3776@breakpoint.cc>
 <20180216.173354.347842978561257782.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, daniel@iogearbox.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, alexei.starovoitov@gmail.com
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:44278 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbeBQMaH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Feb 2018 07:30:07 -0500
Content-Disposition: inline
In-Reply-To: <20180216.173354.347842978561257782.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi David,

On Fri, Feb 16, 2018 at 05:33:54PM -0500, David Miller wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> > Any particular reason why translating iptables rather than nftables
> > (it should be possible to monitor the nftables changes that are
> >  announced by kernel and act on those)?
> 
> As Daniel said, iptables is by far the most deployed of the two
> technologies.  Therefore it provides the largest environment for
> testing and coverage.

As I outlined earlier, this way you are perpetuating the architectural
mistakes and constraints that were created ~ 18 years ago without any
benefit from the lessons learned ever since.  In netfilter, we already
wanted to replace it as early as 2006 (AFAIR) with nfnetlink based
pkttables (which never materialized).

I would strongly suggest to focus on nftables (or even some other way of
configuration / userspace interaction) to ensure that the iptables
userspace interface can at some point be phased out eventually.  Like we
did with ipchains before, and before that with ipfwadm.

By making a new implementation dependant on the oldest interface you are
perpetuating it.  Sure, one can go that way, but I would suggest this to
be a *very* carefully weighed decision after a detailed
analysis/discusison.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
