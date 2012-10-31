From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nf-next/nf_tables-experiments - PATCH 1/2] nf_tables: Add support
 for changing users chain's name
Date: Wed, 31 Oct 2012 16:29:01 +0200
Message-ID: <509135AD.4070007@linux.intel.com>
References: <1351675709-14127-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1351675709-14127-2-git-send-email-tomasz.bursztyka@linux.intel.com> <20121031134924.GA1060@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63009 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934348Ab2JaO3E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:29:04 -0400
In-Reply-To: <20121031134924.GA1060@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
> > From net/netfilter/nf_tables_core.c:
>
>          case NFT_GOTO:
>                  chain = data[NFT_REG_VERDICT].chain;
>
> In the GOTO case, we already point to the chain object. That chain
> object is loaded in nft_immediate.c _eval(). However, the private data
> of immediate is initialized in the _init() path. That means we would
> need to refresh the entire rule-set to point to the correct new chain
> object, otherwise we would crash.

Missed that one completely...

> I'd follow a simpler solution to avoid issues. Use a fixed chain name
> length (the same length as iptables does, or just 32 bytes).
>
> We can revisit this later to see if we can support renaming and
> dynamically allocated chain objects at the same time.

First solution is easy to implement, and do not imply any performance 
drop, only a bit of memory loss for short names.

Second one, I cannot see anything but a 2 pass system (a hash table 
handling unique handle related to a chain pointer).
But then the gain of bytes - with variable name size - versus the size 
of the hash table etc... might be pointless.
Maybe I am just wrong. Is there any other solution?

> Would you resend a new version of this patch?

Ok, I will go with first solution, unless you or someone else comes up 
with a better proposition.

Tomasz
