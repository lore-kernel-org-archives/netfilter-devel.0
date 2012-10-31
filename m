From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next/nf_tables-experiments - PATCH 1/2] nf_tables: Add
 support for changing users chain's name
Date: Wed, 31 Oct 2012 16:38:15 +0100
Message-ID: <20121031153815.GA9558@1984>
References: <1351675709-14127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1351675709-14127-2-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20121031134924.GA1060@1984>
 <509135AD.4070007@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48750 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758023Ab2JaPiX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:38:23 -0400
Content-Disposition: inline
In-Reply-To: <509135AD.4070007@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 31, 2012 at 04:29:01PM +0200, Tomasz Bursztyka wrote:
> Hi,
> >> From net/netfilter/nf_tables_core.c:
> >
> >         case NFT_GOTO:
> >                 chain = data[NFT_REG_VERDICT].chain;
> >
> >In the GOTO case, we already point to the chain object. That chain
> >object is loaded in nft_immediate.c _eval(). However, the private data
> >of immediate is initialized in the _init() path. That means we would
> >need to refresh the entire rule-set to point to the correct new chain
> >object, otherwise we would crash.
> 
> Missed that one completely...
> 
> >I'd follow a simpler solution to avoid issues. Use a fixed chain name
> >length (the same length as iptables does, or just 32 bytes).
> >
> >We can revisit this later to see if we can support renaming and
> >dynamically allocated chain objects at the same time.
> 
> First solution is easy to implement, and do not imply any
> performance drop, only a bit of memory loss for short names.
> 
> Second one, I cannot see anything but a 2 pass system (a hash table
> handling unique handle related to a chain pointer).
> But then the gain of bytes - with variable name size - versus the
> size of the hash table etc... might be pointless.
> Maybe I am just wrong. Is there any other solution?

I don't see any at this moment.

> >Would you resend a new version of this patch?
> 
> Ok, I will go with first solution, unless you or someone else comes
> up with a better proposition.

Agreed. It's simple and we can still revisit this later.
