From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/3] netfilter: nf_tables cleanups
Date: Fri, 6 Mar 2015 01:13:18 +0100
Message-ID: <20150306001318.GA18260@salvia>
References: <1425413406-6804-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54463 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbbCFAJh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2015 19:09:37 -0500
Content-Disposition: inline
In-Reply-To: <1425413406-6804-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 03, 2015 at 08:10:03PM +0000, Patrick McHardy wrote:
> These patches for -next contain some cleanups which are not directly
> related to the following set patches, so I'm sending them seperately
> for easier review:
> 
>  * move the reoccuring checks for skb->nf_trace to an inline function
>  * consolidate similar invocations of nft_trace_packet()
>  * rearrange nf_tables.h so related things are next to each other

Applied, thanks Patrick.

I'll send another net-next batch with accumulated patches just after
David gets the pending fixes. Then ask for net to go into net-next,
sorry I cannot go any faster.
