From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH] tests: py: Test TCP flags match with parentheses
Date: Wed, 30 Nov 2016 22:35:19 +0100
Message-ID: <20161130213519.GB26507@breakpoint.cc>
References: <20161130210714.29530-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49326 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754014AbcK3Vjb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2016 16:39:31 -0500
Content-Disposition: inline
In-Reply-To: <20161130210714.29530-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Sutter <phil@nwl.cc> wrote:
> This should test the fix in commit 7222680eb328b ("parser_bison: Allow
> parens on RHS of relational_expr").

applied.
