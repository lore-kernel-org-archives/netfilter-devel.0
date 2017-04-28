From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 2/2] masquerade: Complain if no prerouting chain
 exists
Date: Fri, 28 Apr 2017 10:28:24 +0200
Message-ID: <20170428082824.GJ20805@orbyte.nwl.cc>
References: <20170427132439.9443-1-phil@nwl.cc>
 <20170427132439.9443-2-phil@nwl.cc>
 <CAOkSjBjdnywsFENgBLQfQr2aXMTDpU9ztXm_Y4V1==E61hH05g@mail.gmail.com>
 <20170428080523.GI20805@orbyte.nwl.cc>
 <CAOkSjBjtJ0_xymJ_iMuKwxtqArEh_dHs=Tgjo271PnLy4K84ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:56597 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968001AbdD1I20 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2017 04:28:26 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBjtJ0_xymJ_iMuKwxtqArEh_dHs=Tgjo271PnLy4K84ng@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 28, 2017 at 10:11:51AM +0200, Arturo Borrero Gonzalez wrote:
> On 28 April 2017 at 10:05, Phil Sutter <phil@nwl.cc> wrote:
> >>
> >> This warning will be printed even in rulesets loaded with '-f'
> >> which first creates the masq rule an then the other chain.
> >
> > Hmm. I tested it with the following config and it works fine:
> >
> > | table ip nat {
> > |       chain post {
> > |               type nat hook postrouting priority 0; policy accept;
> > |               oifname "veth2" masquerade
> > |       }
> > |
> > |       chain pre {
> > |               type nat hook prerouting priority 0; policy accept;
> > |       }
> > | }
> >
> > OK, with a config consisting of several 'add' commands, it indeed warns.
> >
> >> I think is just a matter of documenting *everywhere* that this is the
> >> expected behaviour, not a bug.
> >
> > Yeah, I should indeed have done that first, also because masquerade
> > statement is not documented at all yet.
> >
> 
> The best current documentation is this:
> 
> https://wiki.nftables.org/wiki-nftables/index.php/Performing_Network_Address_Translation_(NAT)

Ah, thanks for the pointer! I tend to ignore anything that's not in the
man page. :)

Cheers, Phil
