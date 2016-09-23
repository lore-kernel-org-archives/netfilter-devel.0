From: Florian Westphal <fw@strlen.de>
Subject: Re: Seeking help for implementing CT HELPER in nftables
Date: Fri, 23 Sep 2016 17:46:53 +0200
Message-ID: <20160923154653.GB17240@breakpoint.cc>
References: <56DAC502.2060809@c-s.fr>
 <20160307132011.GA7620@macbook.localdomain>
 <56DF5F61.2060000@c-s.fr>
 <570CFAB1.6090409@c-s.fr>
 <20160412135155.GA27975@breakpoint.cc>
 <2cfbf6f4-0031-36da-6d56-10f919d9eaf8@c-s.fr>
 <20160920153846.GB22503@breakpoint.cc>
 <c93e2f7e-fe6b-b43d-c1d4-0c57287ff06c@c-s.fr>
 <20160923142435.GA17227@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: Christophe Leroy <christophe.leroy@c-s.fr>,
        Florian Westphal <fw@strlen.de>,
        Patrick McHardy <kaber@trash.net>,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50454 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965090AbcIWPq5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Sep 2016 11:46:57 -0400
Content-Disposition: inline
In-Reply-To: <20160923142435.GA17227@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Sep 23, 2016 at 12:45:06PM +0200, Christophe Leroy wrote:
> > Le 20/09/2016 à 17:38, Florian Westphal a écrit :
> [...]
> > >nft will need to populate this (or rather, libnftnl will do this on
> > >behalf of nft).
> > >
> > >Currently we do this:
> > >nft --debug=netlink add rule filter i ct helper set foo
> > >ip filter i
> > >  [ immediate reg 1 0x006f6f66 0x00000000 0x00000000 0x00000000 ]
> 
> Florian, Christophe, sorry for this late jump on this.
> 
> If we pass the helper name as string, then helper autoload will not
> work as we don't have a way to solve this from the packet path.
> 
> To solve this, I'm considering a different approach. Basically,
> explicit preload the helpers and pass a helper handle through
> register instead.
> 
> In the ruleset file, this would look like this:
> 
>         table ip x {
>                 helper ftp protocol tcp                 #1

This would also allow to support helper specific configuration from the
nft frontend rather than via modprobe args (e.g. ftp loose mode).
