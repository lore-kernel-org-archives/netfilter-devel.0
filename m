From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH v2 5/5] src: get rid of printf
Date: Fri, 29 Sep 2017 12:57:35 +0200
Message-ID: <20170929105735.GE32305@orbyte.nwl.cc>
References: <20170928151745.28426-1-phil@nwl.cc>
 <20170928151745.28426-6-phil@nwl.cc>
 <20170929103815.GA4789@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:37488 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751830AbdI2K5h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2017 06:57:37 -0400
Content-Disposition: inline
In-Reply-To: <20170929103815.GA4789@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Fri, Sep 29, 2017 at 12:38:15PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Sep 28, 2017 at 05:17:45PM +0200, Phil Sutter wrote:
> > This patch introduces nft_print()/nft_gmp_print() functions which have
> > to be used instead of printf to output information that were previously
> > send to stdout. These functions print to a FILE pointer defined in
> > struct output_ctx. It is set by calling:
> > 
> > | old_fp = nft_ctx_set_output(ctx, new_fp);
> > 
> > Having an application-defined FILE pointer is actually quite flexible:
> > Using fmemopen() or even fopencookie(), an application gains full
> > control over what is printed and where it should go to.
> 
> Applied, thanks a lot for taking over this work.

Cool, thanks!

Note that I missed two spots when reviewing the patches:

* nft_gmp_print() lacks a call to fflush(). This is not a problem in
  practice, but inconsistent with regards to nft_print(). I'll send a
  follow-up fixing it.

* Did you notice how my patch changes main() to move stdout to another
  file descriptor? I used that to make sure I didn't miss a spot when
  converting the code. In theory, we could just drop it again since
  everything's working. What do you suggest?

Cheers, Phil
