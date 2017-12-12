From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH] Fix protocol context update on big-endian systems
Date: Tue, 12 Dec 2017 13:26:07 +0100
Message-ID: <20171212122607.GM24449@breakpoint.cc>
References: <20171209155229.21809-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34398 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750731AbdLLM1k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Dec 2017 07:27:40 -0500
Content-Disposition: inline
In-Reply-To: <20171209155229.21809-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Sutter <phil@nwl.cc> wrote:
> There is an obscure bug on big-endian systems when trying to list a rule
> containing the expression 'ct helper tftp' which triggers the assert()
> call in mpz_get_type().

Applied, thanks Phil.
