From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] tests: nft removes required payload protocol
 expressions
Date: Thu, 6 Apr 2017 20:45:47 +0200
Message-ID: <20170406184547.GA10969@breakpoint.cc>
References: <20170323081156.17727-1-fw@strlen.de>
 <20170406164100.GA7143@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48072 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932507AbdDFSqn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 14:46:43 -0400
Content-Disposition: inline
In-Reply-To: <20170406164100.GA7143@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Mar 23, 2017 at 09:11:56AM +0100, Florian Westphal wrote:
> > This test fails with
> > 'ip protocol tcp tcp dport 22' mismatches 'tcp dport 22'
> > 
> > ip protocol tcp tcp dport 22 is *ONLY* identical to
> > 'tcp dport 22' in the ip family.
> > 
> > For netdev/inet/bridge, the dependency is required because
> > we only want to match ipv4 packets.
> 
> This needs the C chunk to fix this, right? so I let you decide if you
> want to push out this test now or make it together with the fix.

I have no fix at the moment.

I will thus probably push this test when I get home so we don't forget
about it.
