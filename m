From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nftables PATCH] queue: More compact syntax for nft queue
Date: Tue, 10 Jun 2014 14:38:49 +0200
Message-ID: <20140610123848.GB4938@macbook.localnet>
References: <1402399703-11177-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, eric@regit.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37224 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaFJMix (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:38:53 -0400
Content-Disposition: inline
In-Reply-To: <1402399703-11177-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 10, 2014 at 01:28:23PM +0200, Alvaro Neira Ayuso wrote:
> This patch allows to use a new syntax more compact and break
> the last syntax. This new syntax is more similar than the nftables
> syntax that we use usually. We can use range like we have used in
> other case in nftables. Here, we have some examples:
> 
> Before, If we want to declare a queue, we have used a syntax like this:
> 
> nft add rule test input queue num 1 total 3 options bypass,fanout
> 
> If we want to use the queue number 1 and the two next (total 3),
> we use a range in the new syntax, for example:
> 
> nft add rule test input queue num 1-3 bypass fanout
> 
> Also if we want to use only one queue, the new rules are like:
> 
> nft add rule test input queue num 1	//queue 1
> or
> nft add rule test input queue	//queue 0
> 
> And if we want to add a specific flags we only need to put
> what flags we want to use:
> 
> nft add rule test input queue bypass
> 
> we don't need to use options and the comma for stablishing the
> flags.
> 

I like that. I already came up with something quite similar myself, but
your approach is even better.

Thanks :)
