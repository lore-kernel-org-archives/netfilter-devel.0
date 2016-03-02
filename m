From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3] extensions: libxt_statistic: Add translation to nft
Date: Wed, 2 Mar 2016 16:29:46 +0100
Message-ID: <20160302152946.GH4348@breakpoint.cc>
References: <20160301204042.GA15382@sonyv>
 <20160302114611.GA3008@salvia>
 <20160302121033.GA4348@breakpoint.cc>
 <alpine.LSU.2.20.1603021409540.15745@nerf40.vanv.qr>
 <20160302145016.GF4348@breakpoint.cc>
 <20160302151724.GB5844@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Jan Engelhardt <jengelh@inai.de>,
	Laura Garcia Liebana <nevola@gmail.com>,
	netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52559 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753360AbcCBP3t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 10:29:49 -0500
Content-Disposition: inline
In-Reply-To: <20160302151724.GB5844@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> In all this thread you talk all the time on probability semantics,
> however the selector name is 'random'.
> 
> Why don't you rename this to 'meta probability' instead?
> 
> No changes in the semantics then, just use:
> 
>         meta probability 0.1
> 
> and when expressing the opposite:
> 
>         meta probability 0.9

I have no preferences one way or another, i'd
be fine with using probability for this.

In future you might want to allow something like

nft add rule filter input meta mark set meta random
or
nft add rule filter input queue num meta random

Perhaps we should use probability for now and later
alias is to random for these cases?
