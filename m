From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-compat PATCH 0/3] ebtables compat layer
Date: Sun, 24 Aug 2014 16:18:15 +0200
Message-ID: <20140824141815.GA8186@salvia>
References: <1408699755-17785-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35398 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbaHXORg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:17:36 -0400
Content-Disposition: inline
In-Reply-To: <1408699755-17785-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 22, 2014 at 11:29:12AM +0200, Giuseppe Longo wrote:
> Hi Pablo,
> the btables-compat is almost ready,

At quick glance the approach looks correct to me. The parser and the
specific bridge code is well-encapsulated.

> I've fixed the issues with flags, there are two small issues
> to be fixed yet:
> 
> - rules with logical interfaces are not deleted
> - when listing rule, the mask is printed when it's not set
> 
> The filter table is working properly except these issues,
> that I'm going to fix in these days.

Great, I'm looking forward to having fixes for these. Please, let us
know if we can help.

On top of that, please, also rebase your patches to use the new
nft_xt_ctx structure so it remains consistent with the ip, ip6 and arp
compat code.

I'd like to see a v2 round soon.

> There is no support yet for nat and brouting,
> I'm working on checksum expr.

OK, I guess you mean the enhancement for payload to mangle packets.

> I would know what you have in mind for these patches,
> if you want to accept them when the issues are fixed
> even if there is no nat support yet or or what else?

I would like to see the filter code already in mainstream.

The bridge "NAT" (which is actually a simple stateless packet
mangling) will have to wait until we have support for this in the
kernel anyway.

> So I can organize the work to do.
> 
> There are still some extensions that have to be moved
> to libxtables.

Please, make a short summary of those.

Thanks for your work.
