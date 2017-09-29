From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 5/5] src: get rid of printf
Date: Fri, 29 Sep 2017 12:38:15 +0200
Message-ID: <20170929103815.GA4789@salvia>
References: <20170928151745.28426-1-phil@nwl.cc>
 <20170928151745.28426-6-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [213.95.27.120] ([213.95.27.120]:59129 "EHLO
        ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751800AbdI2Kj2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2017 06:39:28 -0400
Content-Disposition: inline
In-Reply-To: <20170928151745.28426-6-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 28, 2017 at 05:17:45PM +0200, Phil Sutter wrote:
> This patch introduces nft_print()/nft_gmp_print() functions which have
> to be used instead of printf to output information that were previously
> send to stdout. These functions print to a FILE pointer defined in
> struct output_ctx. It is set by calling:
> 
> | old_fp = nft_ctx_set_output(ctx, new_fp);
> 
> Having an application-defined FILE pointer is actually quite flexible:
> Using fmemopen() or even fopencookie(), an application gains full
> control over what is printed and where it should go to.

Applied, thanks a lot for taking over this work.
