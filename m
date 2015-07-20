From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: validate generated netlink instructions
Date: Mon, 20 Jul 2015 14:50:04 +0200
Message-ID: <20150720125004.GA7402@salvia>
References: <1437096699-8832-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50851 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbbGTMoT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2015 08:44:19 -0400
Content-Disposition: inline
In-Reply-To: <1437096699-8832-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 17, 2015 at 03:31:39AM +0200, Florian Westphal wrote:
> Don't apply -- this patch is intentionally incomplete;
> I don't want to spam this list with 350k patch.
> 
> If you think this is worthwile to have in nft I'll push the full
> changeset (this patch + 64 test files with recorded netlink debug output).

I like the idea of having more regression tests.

We can probably kill the old .t files and move the 'regression' to
'tests'.

It would be good to add tests for the 'nft -f' path in some automated
way at some point.
