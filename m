From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix addition/deletion of
 elements from commit/abort
Date: Sat, 21 Feb 2015 10:39:18 +0000
Message-ID: <20150221103917.GA1683@acer.localdomain>
References: <1424448670-4458-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48893 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbbBUKjW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Feb 2015 05:39:22 -0500
Content-Disposition: inline
In-Reply-To: <1424448670-4458-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20.02, Pablo Neira Ayuso wrote:
> We have several problems in this path:
> 
> 1) There is a use-after-free when removing individual elements from
>    the commit path.
> 
> 2) We have to uninit() the data part of the element from the abort
>    path to avoid a chain refcount leak.
> 
> 3) We have to check for set->flags to see if there's a mapping, instead
>    of the element flags.
> 
> 4) We have to check for !(flags & NFT_SET_ELEM_INTERVAL_END) to skip
>    elements that are part of the interval that have no data part, so
>    they don't need to be uninit().

Just wondering, in the delete case, don't we need to set the flags in
the sets' ->get() function for this to work?
