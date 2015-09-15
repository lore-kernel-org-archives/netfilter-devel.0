From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl 0/3] use nftnl_ prefix
Date: Tue, 15 Sep 2015 17:35:59 +0200
Message-ID: <20150915153559.GA13955@salvia>
References: <1441205064-9240-1-git-send-email-pablo@netfilter.org>
 <20150902150255.GA10168@salvia>
 <20150907181428.GA16080@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, fw@strlen.de, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42712 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbbIOP3X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Sep 2015 11:29:23 -0400
Content-Disposition: inline
In-Reply-To: <20150907181428.GA16080@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 07, 2015 at 08:14:28PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Wed, Sep 02, 2015 at 05:02:55PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Sep 02, 2015 at 04:44:23PM +0200, Pablo Neira Ayuso wrote:
> > > This patchset renames the existing functions and definitions to use the nftnl_
> > > prefix to prepare the introduction of the higher level library, which will use
> > > the nft_ prefix.
> > > 
> > > The patchset does not break backward compatibility: Neither compilation not
> > > existing binaries.
> > > 
> > > The patchset keeps the nft_ symbols around as aliases for the nftnl_ symbols.
> > > Moreover, the header files contain the old nft_ definitions so clients of this
> > > library don't break all of a sudden.
> > > 
> > > Please, let me know if you observe any problem with this. I would like that
> > > this changes are pushed to master before the next release.
> > 
> > Just pushed out this branch:
> > 
> > http://git.netfilter.org/libnftnl/log/?h=nftnl
> 
> I'm pushing four more patches into this branch before we make the next
> release on top of the brand new patches to use the nftnl_ prefix
> instead as Patrick suggested.

I have pushed these two patches to the 'nftnl' branch in both cases:

http://git.netfilter.org/nftables/commit/?h=nftnl&id=830693fe7b02aae554178dfd7220b6e779434eef
http://git.netfilter.org/iptables/commit/?h=nftnl&id=7babe09c9cfaa288c8502613340c9b35b29617bc

They are adapting the code to use the new symbols in libnftnl. They
are slightly large, so I preferred to send it in this way.
