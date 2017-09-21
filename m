From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH v2 2/2] src: get rid of printf
Date: Thu, 21 Sep 2017 17:43:09 +0200
Message-ID: <20170921154309.GD15946@breakpoint.cc>
References: <20170903223441.GB12383@salvia>
 <20170904075558.10129-1-eric@regit.org>
 <20170904075558.10129-3-eric@regit.org>
 <20170904204348.GB14434@salvia>
 <20170904205304.GA14816@salvia>
 <20170921153745.GX30364@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38718 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751436AbdIUPqe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2017 11:46:34 -0400
Content-Disposition: inline
In-Reply-To: <20170921153745.GX30364@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Sutter <phil@nwl.cc> wrote:
> With the proposed implementation of nft_print(), this will be
> problematic: nft_run_cmd_from_buffer() waits for the command to finish
> before printing all the output at once. This obviously breaks monitor
> which runs endlessly.
> 
> Maybe we should reference nft_print via a function pointer in
> output_ctx? This would allow to configure a different nft_print
> implementation which flushes the buffer to stdout immediately.
> 
> What do you think?

I wondered the same thing.

I have following issue: When using new typeof keyword then listing
a set definition should output something like

set foo { type typeof(meta iifname) }

Because the kernel has no notion of 'meta iifname', we have to
store this information in the kernel so we can read it back during
delinearization.

One way to do this would be to store the 'meta iifname' string in the
sets userdata.

For that, expr_print() would have to be able to print to a buffer
(or we would need an expr_snprintf or something similar) to extract
the convert struct *expr back to its original name.

The other solution would be to stash this in the expression
during parsing but that seems weird as we need to be able to do such
conversion anyway when printing the ruleset, so we merely need
to make this accessible outside of plain printf() to stdout.
