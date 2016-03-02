From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3] extensions: libxt_statistic: Add translation to nft
Date: Wed, 2 Mar 2016 13:37:38 +0100
Message-ID: <20160302123738.GB4348@breakpoint.cc>
References: <20160301204042.GA15382@sonyv>
 <20160302114611.GA3008@salvia>
 <20160302121033.GA4348@breakpoint.cc>
 <20160302123339.GA4930@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Laura Garcia Liebana <nevola@gmail.com>,
	netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52121 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755155AbcCBMhk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 07:37:40 -0500
Content-Disposition: inline
In-Reply-To: <20160302123339.GA4930@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:

[ nft meta random ]

> I'm fine with the probability scaling, but I think we should keep this
> consistent with other selectors, so I would use lt and gte instead
> here.
> 
> We can potentially use ranges here too and other available operations
> such as prefixes (although this one I don't know use case for this).

Ok, so just to clarify.  You want me to submit v2 of nft meta random
patch set that turns:

meta random value
into
meta random lt value

... and ...

meta random ne value
into
meta random ge value

Is that correct?

Sorry, I am a bit confused :)
