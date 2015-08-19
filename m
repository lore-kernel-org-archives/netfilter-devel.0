From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: validate generated netlink instructions
Date: Wed, 19 Aug 2015 02:49:06 +0200
Message-ID: <20150819004906.GA19954@salvia>
References: <1437096699-8832-1-git-send-email-fw@strlen.de>
 <20150720125004.GA7402@salvia>
 <20150720151046.GD11985@breakpoint.cc>
 <20150720170538.GA22735@salvia>
 <20150720183536.GE11985@breakpoint.cc>
 <20150812173453.GA30926@salvia>
 <20150812174624.GA31166@breakpoint.cc>
 <20150816181439.GD17659@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37792 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbbHSAmz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 20:42:55 -0400
Content-Disposition: inline
In-Reply-To: <20150816181439.GD17659@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 16, 2015 at 07:14:40PM +0100, Patrick McHardy wrote:
[...]
> I actually think we should sort it in nft since we might also see duplicate
> netlink messages and should eleminate them from the output since they will
> cause errors on reload.

Right, we need that --sort option so the user always get the same
output when saving the ruleset. The removal of duplicates is also an
issue given the way netlink dumps things.

But the issue with tests is related to --debug=netlink output, so you
suggest we address both sorting and duplication removal from libnftnl, right?

Thanks!
