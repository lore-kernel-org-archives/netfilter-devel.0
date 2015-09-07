From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl 0/3] use nftnl_ prefix
Date: Mon, 7 Sep 2015 20:14:28 +0200
Message-ID: <20150907181428.GA16080@salvia>
References: <1441205064-9240-1-git-send-email-pablo@netfilter.org>
 <20150902150255.GA10168@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, fw@strlen.de, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55257 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbbIGSIK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Sep 2015 14:08:10 -0400
Content-Disposition: inline
In-Reply-To: <20150902150255.GA10168@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wed, Sep 02, 2015 at 05:02:55PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 02, 2015 at 04:44:23PM +0200, Pablo Neira Ayuso wrote:
> > This patchset renames the existing functions and definitions to use the nftnl_
> > prefix to prepare the introduction of the higher level library, which will use
> > the nft_ prefix.
> > 
> > The patchset does not break backward compatibility: Neither compilation not
> > existing binaries.
> > 
> > The patchset keeps the nft_ symbols around as aliases for the nftnl_ symbols.
> > Moreover, the header files contain the old nft_ definitions so clients of this
> > library don't break all of a sudden.
> > 
> > Please, let me know if you observe any problem with this. I would like that
> > this changes are pushed to master before the next release.
> 
> Just pushed out this branch:
> 
> http://git.netfilter.org/libnftnl/log/?h=nftnl

I'm pushing four more patches into this branch before we make the next
release on top of the brand new patches to use the nftnl_ prefix
instead as Patrick suggested.

Not sending them to the mailing list, they are large as the previous
and they are renaming things:

1) src: rename nftnl_rule_expr to nftnl_expr

The nftnl_rule_expr is not restricted anymore to the scope of rules
since it can be used from sets, so let's get rid of the _rule_ infix
to get it shorter.

2) src: rename NFTNL_RULE_EXPR_ATTR to NFTNL_EXPR_

Same as 1, but for constants.

3) src: get rid of _ATTR_ infix in new nfntl_ definitions

Remove the infix _ATTR_, the constant definitions have a large name,
so let's reduce it a bit.

4) src: get rid of _attr_ infix in new nftnl_ definitions

Similar to 3. Note that after this we've got things like:

        nft_set_set_u32(...)

Please, let me know if you have more renaming suggestions since
libnftnl will be out soon and it would be great if we can avoid this
stuff in the future.

Thanks.
