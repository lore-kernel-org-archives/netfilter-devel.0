From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft] regarding sets names length
Date: Thu, 8 Oct 2015 12:55:24 +0100
Message-ID: <20151008115524.GA20598@macbook.localdomain>
References: <CAOkSjBiv1M9QE2bjTBTh9Yr1n_5w2c69Rg1ZpoxUroga7oncgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38150 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbbJHLz3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2015 07:55:29 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBiv1M9QE2bjTBTh9Yr1n_5w2c69Rg1ZpoxUroga7oncgA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08.10, Arturo Borrero Gonzalez wrote:
> Hi,
> 
> I'm trying to migrate a iptables/ip6tables ruleset to nftables.
> 
> I've found that the current IFNAMSIZ limitation for set names is
> annoying because there are lots of ipset sets which needs to move to
> nftables which cannot do it straight forward.
> Also, the error reporting for this is very poor (reported by the
> kernel in a generic way).
> 
> This example illustrates both issues:
> 
>  % nft add set inet filter external_services { type ipv4_addr\; }
> <cmdline>:1:1-57: Error: Could not process rule: Numerical result out of range
> add set inet filter external_services { type ipv4_addr; }
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Also, I don't find any documentation apart of the source code itself :-)
> 
> I would suggest:
>  * check names length also in userspace to show a better error message

Sure. The root cause is the IMO poorly chosen errno code for nla policy
checks when the size is exceeded. Unfortunately that's something outside
of nf_tables and also something other applications possibly depend on.

>  * enlarge set names sizes

Agreed, I think its a good idea to use 32 as for the other object types.
