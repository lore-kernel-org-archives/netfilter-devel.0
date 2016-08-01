From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC nft] meta: deprecate unqualified meta statements
Date: Mon, 1 Aug 2016 14:48:03 +0200
Message-ID: <20160801124803.GA14981@salvia>
References: <1469585853-6207-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56293 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbcHAMsJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Aug 2016 08:48:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D805C1683AB
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 14:48:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C5EC8FC61A
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 14:48:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9F3427E077
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 14:48:05 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469585853-6207-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 27, 2016 at 04:17:33AM +0200, Florian Westphal wrote:
> During NFWS we discussed reducing the number of keywords in nftables.
> 
> Obviously keywords are required for the parser to know what to expect.
> 
> But always requiring the 'meta' keyword would allow us to handle
> iif, oif, iifname etc without defining them in the scanner, i.e. we
> could later use 'meta STRING' and resolve/map the keyword at run time
> based on the meta template pseudo-header.
> 
> Note that this change does not yet reject 'iif eth0', this only makes
> nft always print the 'meta' keyword when listing and updates the test
> cases as required.

The main problem I have hit with this unqualified meta statements is
that I cannot reuse selectors from other statements, eg.

        dup to 1.2.3.4 device eth0

I had to use device here, when oif would have fit more naturally.

Apart from that, I remember that the intention was to get the command
line syntax more compact, that also results in more compact listings.

If the main argument is to reduce the number of keywords, it would be
good to see the patch that helps you reduce them after getting rid of
this.
