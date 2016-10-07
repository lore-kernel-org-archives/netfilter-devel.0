From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 0/2] netfilter: autoload NAT support for
 non-builtin L4 protocols
Date: Fri, 7 Oct 2016 16:20:52 +0200
Message-ID: <20161007142052.GB7063@breakpoint.cc>
References: <cover.1475773632.git.dcaratti@redhat.com>
 <CAOkSjBiQ0p+jP8tEq78Fighdhj34uoaLvTvn205ZsN8btmNJqg@mail.gmail.com>
 <1475834369.3103.14.camel@redhat.com>
 <CAOkSjBi8zZCyZ-7pqpiboK5HcnTohtx0vscA73wjHNzH-r5FHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Davide Caratti <dcaratti@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52618 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751974AbcJGOVf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2016 10:21:35 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBi8zZCyZ-7pqpiboK5HcnTohtx0vscA73wjHNzH-r5FHw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
> Unlike in iptables, in nftables we don't know the expected l4 protocol
> at rule setup time.
> 
> In the iptables<->nftables compat layer, we have an expression
> attribute which is filled from userspace with the l4 protocol
> (NFTA_RULE_COMPAT_PROTO).
> 
> Not sure if it's worth adding a new netlink attribute for nft_nat to
> tell the expression about the expected l4 NAT protocol.

Right, it might more sense to handle this in nft frontend
instead.
