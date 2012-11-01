From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next/nf_tables-experiments - v2 PATCH 0/4] fixed chain
 name, chain rename and rule replacement
Date: Thu, 1 Nov 2012 16:40:10 +0100
Message-ID: <20121101154010.GA10655@1984>
References: <1351769913-5851-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36005 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992456Ab2KAPkP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:40:15 -0400
Content-Disposition: inline
In-Reply-To: <1351769913-5851-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tomasz,

On Thu, Nov 01, 2012 at 01:38:29PM +0200, Tomasz Bursztyka wrote:
> Hi,
> 
> Here a second version of the previous patchset, now taking care of
> chain's name issue. The name is fixed, same size as in iptables.
> 
> About an alternative, it could be possible to store a variable chain
> name in a separate allocated memory, kept in hash table: not the
> chain object itself, just the name. The key would be the chain's
> object pointer.  At least, from execution point of view it would not
> affect anything since the name is necessary only for the user. The
> only issue is the memory occupied by such hash table.

We can declare a const char * inside nft_chain and kmalloc the area
for the name dynamically. If renamed, we can reallocation it. It's
simple, but we increase memory fragmentation.

> I was looking quickly at the linux helpers, could not find a
> hashtable/map api, is there any? If so, I could try this idea of
> names stored like that.

There have been some discussion regarding generic hashtable API since
long time.

http://www.spinics.net/lists/linux-nfs/msg33526.html

It seems Linus is going to take it.

> Tomasz Bursztyka (4):
>   nf_tables: Change chain's name to be fixed sized
>   nf_tables: Add missing policy for NFTA_CHAIN_USE
>   nf_tables: Add support for changing users chain's name
>   nf_tables: Add support for replacing a rule by another one.

I've taken these three to nf_tables-experiments branch.

Thanks a lot.
