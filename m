From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables 6/6] src: add trace support to nft monitor mode
Date: Tue, 24 Nov 2015 12:01:45 +0100
Message-ID: <20151124110145.GA3421@salvia>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-7-git-send-email-fw@strlen.de>
 <20151124102553.GE2310@macbook.localdomain>
 <20151124104834.GF1740@breakpoint.cc>
 <20151124105816.GL2310@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53708 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387AbbKXLBx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 06:01:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E64A6DA85E
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 12:01:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CE980DA804
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 12:01:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 727DFDA868
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 12:01:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151124105816.GL2310@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 24, 2015 at 10:58:16AM +0000, Patrick McHardy wrote:
> On 24.11, Florian Westphal wrote:
> > > An alternative would be to use our internal datatypes, IOW parse the
> > > attributes, associate the values with an internal type and use the regular
> > > printing functions. The benefit would be fully consistent output, also
> > > with respect to output options like numerical output.
> > 
> > Yes, right now virtually all of the printing is in libnftnl
> > (called from nftables via nftnl_trace_fprintf() ).
> 
> The downside is that we're stuck to fprintf. I'm working on moving nft to
> printing to buffers for pretty printing, intending set contents, sorting
> flow tables in different dimensions etc. If we have external printing we'll
> be missing some flexibilty in handling it, also regarding logging to other
> outputs than stdout.

What we did do far is to have the fprintf variant for quick printing,
but this should be based on the printing to buffers. Both approaches
would be exported.

Does this sound good to you?
