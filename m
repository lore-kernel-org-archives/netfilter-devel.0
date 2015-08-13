From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: validate generated netlink instructions
Date: Thu, 13 Aug 2015 11:53:28 +0200
Message-ID: <20150813095328.GA4502@salvia>
References: <1437096699-8832-1-git-send-email-fw@strlen.de>
 <20150720125004.GA7402@salvia>
 <20150720151046.GD11985@breakpoint.cc>
 <20150720170538.GA22735@salvia>
 <20150720183536.GE11985@breakpoint.cc>
 <20150812173453.GA30926@salvia>
 <20150812174624.GA31166@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38922 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbbHMJrT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Aug 2015 05:47:19 -0400
Content-Disposition: inline
In-Reply-To: <20150812174624.GA31166@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 12, 2015 at 07:46:24PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I found a problem in your change to validate the netlink instructions
> > from the python infrastructure that we have for nft.
> > 
> > The set elements are not always displayed in the same order depending
> > on the hash seed, so we get bogus warnings in that case.
> 
> Did that change recently?
> I run the tests quite extensively at the moment and I did not see
> failures in the set parts yet.

I remember Ana had this problem, currently the script is placing the
elements in a python set to make sure the comparison doesn't break.

> > I think the fix for the test infrastructure will require something a
> > bit more complicated that a simple string comparison as we'll need to
> > interpret the set element part.
> > 
> > Probably it would be good to wrap the netlink instruction generation
> > code under some option until this is resolved, instead of having it
> > enabled by default.
> > 
> > Let me know if you come up with any better idea. Thanks!
> 
> I'm currently in the process of finalizing a first draft of vlan
> matching, i think i have patches ready next week.

Good to know, thanks.

> This will also make "nft add rule bridge filter input ip version 4"
> work since it adds support for sub-byte sized header elements.

Are you using bitwise for that?

> I plan to work on the test suite again after I get v1 out (add BE support
> so we can also check nft on s390 etc).
> 
> I haven't thought about it yet, first plan was to record separate traces
> for LE and BE architectures, think thats better than trying to normalize
> the endianess in the output (might also mask errors...).

My concern is that this might replicate the number of files to
maintain.

> I'll try to figure out a way to cure the set part.

Thanks.

[...]
> I don't mind if you add a quick patch that disables the payload
> comparision for now, we can reenable it later by default once BE + set
> works correctly.

I'm currently disabling this manually here, I can wait a while until
this is fixed.
