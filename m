From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/7] netfilter: nf_tables: remove hook definitions from
 struct nft_af_info
Date: Thu, 10 Jan 2013 17:04:18 +0100
Message-ID: <20130110160409.GB2178@macbook.localnet>
References: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
 <1357831721-10182-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, tomasz.bursztyka@linux.intel.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58055 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3AJQEV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:04:21 -0500
Content-Disposition: inline
In-Reply-To: <1357831721-10182-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 10, 2013 at 04:28:37PM +0100, pablo@netfilter.org wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> They are now included in the filter chain definition.
> 

Ok should have looked at the entire series before responding.
I do still need the table hooks for the multi family tables,
so I'd suggest to keep the current state until I've come up
with a scheme that accomodates all our needs.
