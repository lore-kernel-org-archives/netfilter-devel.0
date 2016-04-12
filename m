From: Florian Westphal <fw@strlen.de>
Subject: Re: Seeking help for implementing CT HELPER in nftables
Date: Tue, 12 Apr 2016 15:51:55 +0200
Message-ID: <20160412135155.GA27975@breakpoint.cc>
References: <56DAC502.2060809@c-s.fr>
 <20160307132011.GA7620@macbook.localdomain>
 <56DF5F61.2060000@c-s.fr>
 <570CFAB1.6090409@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37004 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008AbcDLNwD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 09:52:03 -0400
Content-Disposition: inline
In-Reply-To: <570CFAB1.6090409@c-s.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Christophe Leroy <christophe.leroy@c-s.fr> wrote:

[ nft_ct helper set support ]

> Patrick, can you help ?

I have a few pending patches, one of them adds an immediate
attr for ctlabel set support.

Lets see if that approach is sane enough to be reused for helper
support.

I will post it soon.
