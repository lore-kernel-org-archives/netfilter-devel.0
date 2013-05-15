From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 7/7] chain: handle attribute is relevant if
 only there is no name to use
Date: Wed, 15 May 2013 14:43:31 +0200
Message-ID: <20130515124330.GA1349@localhost>
References: <519216B6.7060701@linux.intel.com>
 <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1368528682-10041-8-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20130514222051.GB10082@localhost>
 <5193265B.3050605@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37353 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416Ab3EOMnf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 08:43:35 -0400
Content-Disposition: inline
In-Reply-To: <5193265B.3050605@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 15, 2013 at 09:08:27AM +0300, Tomasz Bursztyka wrote:
[...]
> >The kernel will ignore the name if the handle is set. So no need to
> >make this artificial restriction in user-space.
> 
> No this not the case, have a look at net/netfilter/nf_tables_api.c
> in nf_tables_newchain(), lines 858-860:
> 
> if (nla[NFTA_CHAIN_HANDLE] && name &&
>     !IS_ERR(nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME])))
>         return -EEXIST;
> 
> When handle and name are both present it means user wants to change
> the chain's name. (see line 882)
> But in our case, when changing only the policy we don't touch the
> name, but libnftables provides it anyway thus failing on that
> test.||||

But the handle number is built into the netlink message if the client
sets the NFT_CHAIN_ATTR_HANDLE. Looking at iptables-nftables, that
only happens in nft_chain_user_rename.

This seems to me like the client needs to be fixed not to set both
attributes at the same time (unless it wants a chain rename).

Where are you hitting this?

> My patch is bogus anyway: I should add a marker that name has been
> changed first (and if only it was really different), and then handle
> it when building the message.
