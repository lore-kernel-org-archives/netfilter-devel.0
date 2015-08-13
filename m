From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] tests: validate generated netlink instructions
Date: Thu, 13 Aug 2015 16:45:24 +0200
Message-ID: <20150813144524.GB31166@breakpoint.cc>
References: <1437096699-8832-1-git-send-email-fw@strlen.de>
 <20150720125004.GA7402@salvia>
 <20150720151046.GD11985@breakpoint.cc>
 <20150720170538.GA22735@salvia>
 <20150720183536.GE11985@breakpoint.cc>
 <20150812173453.GA30926@salvia>
 <20150812174624.GA31166@breakpoint.cc>
 <20150813095328.GA4502@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58399 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138AbbHMOp0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Aug 2015 10:45:26 -0400
Content-Disposition: inline
In-Reply-To: <20150813095328.GA4502@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This will also make "nft add rule bridge filter input ip version 4"
> > work since it adds support for sub-byte sized header elements.
> 
> Are you using bitwise for that?

yes: input ip version 4
 [ payload load 1b @ network header + 0 => reg 1 ]
 [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
 [ cmp eq reg 1 0x00000040 ]

relational_binop_postprocess() is responsible to zap such implicit binops
again when listing a table.

> > I plan to work on the test suite again after I get v1 out (add BE support
> > so we can also check nft on s390 etc).
> > 
> > I haven't thought about it yet, first plan was to record separate traces
> > for LE and BE architectures, think thats better than trying to normalize
> > the endianess in the output (might also mask errors...).
> 
> My concern is that this might replicate the number of files to
> maintain.

Yes, thats true, when adding new rule to test suite one would need to
run nft on both LE and BE system to get the generated instructions for
both...

Not sure if there is a better solution though.
