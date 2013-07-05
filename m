From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: add xt compat support
Date: Fri, 5 Jul 2013 02:50:32 +0200
Message-ID: <20130705005032.GA4699@localhost>
References: <1372608125-28734-1-git-send-email-pablo@netfilter.org>
 <51D12B42.40806@linux.intel.com>
 <20130701222020.GA4082@localhost>
 <51D29794.9020301@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net, eric@regit.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52226 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756251Ab3GEAuk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jul 2013 20:50:40 -0400
Content-Disposition: inline
In-Reply-To: <51D29794.9020301@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tomasz,

On Tue, Jul 02, 2013 at 12:04:20PM +0300, Tomasz Bursztyka wrote:
[...] 
> nft add rule ip filter xt M [ <M match options> ] drop
> 
> But what's the user does not know, is that the xt match M will
> generate pure nft expressions, not using the xt compat expression
> (no memory blob etc...)
> Then: (let's say M matches tcp protocol, port 12345)
>
> nft list table filter
> 
> table global {
>     chain filter input {
>         ip protocol 6 tcp dport 12345 drop
>     }
> }
>
> It's misleading. The user is not retrieving his command here. I am
> pretty sure lots of users will complain about that.

We can document that xt commands from nft are translated to native
whenever possible.

[...]
> We have to force them ;) "Want iptables way of doing thing: use
> iptables-nftables. Want the new features and flexibility: use nft".

Many users have rule-sets with thousands of rules. Following this
approach you propose, they will have to rewrite their rule-set
*entirely* to native nft. That's a lot of work and a daunting task,
they won't happy about that.

With this patch, users that want to migrate to get the new features
can simply load their rule-set via iptables-nftables, then switch to
nft to obtain the translation. If there is no native replacement for
one of the rule selectors, they can *still* use the new nft. Thus,
they can *progressively* migrate to native nft as soon as native
replacements for existing features are provided.

Regards.
