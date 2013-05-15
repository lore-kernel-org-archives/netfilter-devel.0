From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [libnftables PATCH 7/7] chain: handle attribute is relevant if
 only there is no name to use
Date: Wed, 15 May 2013 16:06:26 +0300
Message-ID: <51938852.1070705@linux.intel.com>
References: <519216B6.7060701@linux.intel.com> <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1368528682-10041-8-git-send-email-tomasz.bursztyka@linux.intel.com> <20130514222051.GB10082@localhost> <5193265B.3050605@linux.intel.com> <20130515124330.GA1349@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21528 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab3EONG3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 09:06:29 -0400
In-Reply-To: <20130515124330.GA1349@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
> But the handle number is built into the netlink message if the client
> sets the NFT_CHAIN_ATTR_HANDLE. Looking at iptables-nftables, that
> only happens in nft_chain_user_rename.
>
> This seems to me like the client needs to be fixed not to set both
> attributes at the same time (unless it wants a chain rename).
>
> Where are you hitting this?
>

I was actually playing on my own with libnftables.
It's easy: dump the chain list, then change the policy on one chain for 
instance, build the message to apply this change, send it...

We haven't hit the bug yet anywhere, because no code does such settings 
change after a dump, but we - or whatever app - surely will at some point.


Tomasz
