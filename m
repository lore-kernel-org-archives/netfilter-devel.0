From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] evaluate: Fix debug output
Date: Fri, 6 Oct 2017 14:36:13 +0200
Message-ID: <20171006123613.GA4713@salvia>
References: <20171004135932.20773-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:41586 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751807AbdJFMgR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Oct 2017 08:36:17 -0400
Content-Disposition: inline
In-Reply-To: <20171004135932.20773-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 04, 2017 at 03:59:32PM +0200, Phil Sutter wrote:
> When introducing output_fp, debug output in src/evaluate.c was not
> adjusted and therefore broke.
> 
> This patch restores eval debug output by applying the following changes:
> 
> - Change erec_print() and erec_print_list() to take a struct output_ctx
>   pointer as first argument and use output_fp field as destination to
>   print to.
> - Drop octx_debug_dummy variable and instead use octx pointer from
>   struct eval_ctx for debug output.
> - Add missing calls to erec_destroy() in eval debug output which should
>   eliminate another mem leak.

OK, I'll pick this one and we go for release.

Applied, thanks.
