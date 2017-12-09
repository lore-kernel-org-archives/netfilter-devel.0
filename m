From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH] tests/py: trivial: Fix error message
Date: Sat, 9 Dec 2017 20:47:28 +0100
Message-ID: <20171209194728.GJ24449@breakpoint.cc>
References: <20171209155310.21920-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54926 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751115AbdLITs5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Dec 2017 14:48:57 -0500
Content-Disposition: inline
In-Reply-To: <20171209155310.21920-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Sutter <phil@nwl.cc> wrote:
> The error message for failed chain creation quotes the chain's name but
> lacked the closing tick.

applied, thanks Phil.
