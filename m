From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 7/7] chain: handle attribute is relevant if
 only there is no name to use
Date: Wed, 15 May 2013 16:28:02 +0200
Message-ID: <20130515142802.GA3537@localhost>
References: <519216B6.7060701@linux.intel.com>
 <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1368528682-10041-8-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20130514222051.GB10082@localhost>
 <5193265B.3050605@linux.intel.com>
 <20130515124330.GA1349@localhost>
 <51938852.1070705@linux.intel.com>
 <20130515134010.GA1577@localhost>
 <519393A6.7090301@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55377 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759167Ab3EOO2I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 10:28:08 -0400
Content-Disposition: inline
In-Reply-To: <519393A6.7090301@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 15, 2013 at 04:54:46PM +0300, Tomasz Bursztyka wrote:
> Hi Pablo,
>
> >>>I was actually playing on my own with libnftables.
> >>>It's easy: dump the chain list, then change the policy on one chain
> >>>for instance, build the message to apply this change, send it...
> >>>
> >>>We haven't hit the bug yet anywhere, because no code does such
> >>>settings change after a dump, but we - or whatever app - surely will
> >>>at some point.
> >
> >We should document that. I have a patch to add the doxygen doc to
> >libnftables. I prefer that user is in control of this, instead of
> >adding internal workarounds to avoid tricky situations.
> 
> As you want, but it will complicate things for the user a bit.

Going back to the kernel code (line 882):

       if (nla[NFTA_CHAIN_HANDLE] && name)
                nla_strlcpy(chain->name, name, NFT_CHAIN_MAXNAMELEN);

We can check in the chain name in the kernel and the name passed are
the same, in that case we skip nla_strlcpy.
