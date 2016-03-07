From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_connlabel: Add translation to nft
Date: Mon, 7 Mar 2016 14:05:24 +0100
Message-ID: <20160307130524.GA26624@salvia>
References: <20160305214746.GA16464@gmail.com>
 <20160306000703.GA31513@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shivani Bhardwaj <shivanib134@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36294 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbcCGNFe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 08:05:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7A1B74B0F7
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 14:05:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6AB9F28D239
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 14:05:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 10E0ACA105
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 14:05:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160306000703.GA31513@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 06, 2016 at 01:07:03AM +0100, Florian Westphal wrote:
> Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> > Add translation for connlabel to nftables.
> > Full translation for this match awaits the support for --set option.
> 
> Hmm, I sent patches for that a while ago, don't know why they were
> not applied... Pablo?

Please, push the the connlabel support to nft.

We can probably introduce something like:

        ct connlabel bitset bar

instead of:

        ct connlabel set ct connlabel | bar

in a follow up patch, which looks more compact to me. We can accept
both syntax I'd say so we can introduce this without breaking
backward.
