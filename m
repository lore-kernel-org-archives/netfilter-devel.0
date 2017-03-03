From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nat: remove incorrect debug assert
Date: Fri, 3 Mar 2017 13:44:04 +0100
Message-ID: <20170303124404.GB29213@breakpoint.cc>
References: <20170208221429.3555-1-fw@strlen.de>
 <20170221140909.GA3286@salvia>
 <20170221144019.GD9708@breakpoint.cc>
 <20170303115534.GA13931@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49536 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751468AbdCCMps (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 07:45:48 -0500
Content-Disposition: inline
In-Reply-To: <20170303115534.GA13931@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > However, changing test to if (iph->frag_off) return -NF_ACCEPT seems
> > wrong too because we have enough info to track. OTOH, this only happens
> > with HDRINCL+raw socket so perhaps we shouldn't care about this and
> > just change ipv4 l3 tracker to ignore all packets w. iph->frag_off set.
> 
> Florian, unless you rise your hand, I'm going to take this patch so we
> at least fix splats here. I still have the impression that this
> setsockopt() option and its interaction with netfilter is broken at
> many levels.

Hmmm, I think we should disable tracking of all fragmented packets,
or at least disable NAT of all fragmented packets.

If we NAT 1st packet only then frag reasm won't complete anyway.
