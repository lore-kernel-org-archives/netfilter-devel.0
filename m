From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Fri, 10 Apr 2015 01:59:16 +0200
Message-ID: <20150409235916.GA6449@salvia>
References: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
 <1428598514-1915-3-git-send-email-pablo@netfilter.org>
 <20150409203616.GA27610@acer.localdomain>
 <20150409205135.GG20653@breakpoint.cc>
 <20150409223417.GA3205@salvia>
 <20150409223622.GI20653@breakpoint.cc>
 <20150409225626.GA4215@salvia>
 <20150409232341.GD13473@acer.localdomain>
 <20150409234012.GA6169@salvia>
 <20150409234504.GE13473@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	arturo.borrero.glez@gmail.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36444 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270AbbDIXzK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 19:55:10 -0400
Content-Disposition: inline
In-Reply-To: <20150409234504.GE13473@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 10, 2015 at 12:45:05AM +0100, Patrick McHardy wrote:
[...]:
> I want this decision to be made based on what users actually need and
> on what they need it for. Not basically pull in everything from iptables
> in one go without even thinking about it.
> 
> As a middle ground, I think I could agree to adding the xt compat
> framework, but only allow selective extensions to be used where we
> are sure we need them.

The framework fully supports this, imposing an artificial limitation
makes no sense to me at all.

And more importantly, without this patch nft breaks when users
load their ruleset throught iptables-compat-restore.

With that artificial limitation, some rulesets will break, some other
not.

Admit it, there is no way we can control what users will do in the
future. The only way out is to move forward in an evolutionary
fashion.
