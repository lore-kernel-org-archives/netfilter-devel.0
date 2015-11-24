From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Tue, 24 Nov 2015 11:28:41 +0100
Message-ID: <20151124102841.GD1740@breakpoint.cc>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
 <20151124102245.GD2683@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58445 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753917AbbKXK2n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:28:43 -0500
Content-Disposition: inline
In-Reply-To: <20151124102245.GD2683@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> BTW, do we really want to use the default NFNLGRP_NFTABLES group?
> 
> multicast group provide a simple way for filtering out what you don't
> need from kernelspace. And you can still subscribe both groups
> NFNLGRP_NFTABLES and NFNLGRP_NFTABLES_TRACE.
> 
> I'm telling this when thinking of nft-sync. Why should it be receiving
> this spamming tracing events when it only cares about ruleset updates?

I can add a new group but nftables will need to subscribe to both
in trace mode since we need to see new rules...
