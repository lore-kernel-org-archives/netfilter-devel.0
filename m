From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables-kernel PATCH 0/7] API minor fixes and improvement
 proposals
Date: Mon, 14 Oct 2013 14:58:14 +0200
Message-ID: <20131014125814.GA31411@localhost>
References: <1381754816-28472-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46756 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab3JNM6U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:58:20 -0400
Content-Disposition: inline
In-Reply-To: <1381754816-28472-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 14, 2013 at 03:46:49PM +0300, Tomasz Bursztyka wrote:
> Hi, 
> 
> First 2 minor fixes:
> -------------------
> 
> patch 1: don't know why I messed up here in my previous documentation patch, my mistake anyway.
> patch 2: an old left-over. Why has priv->len been corrupted before?

Will pick these two.

> And 5 proposals:
> ---------------
> 
> patch 3: Let's expose table's usage (so user might decide if it's worth dumping table's content, it can useful info finally)

Call it _USE.

> patch 4: That one is debatable: NFTA_CHAIN_USE is - imho - not enough self-explanatory.
> NFTA_CHAIN_REFS (or NFTA_CHAIN_REFERENCES?) is much better. If there is a time to change such minor details, it's now or never.

We're using _USE in other parts of the netfilter code, that can be
document, really I don't think it's worth to discuss this renaming
thing.

> patch 5: add a meta key to get dev->addr_len
> 
> patch 6: add lshift/rshift to bitwise expression. It's a first shot, which should work pretty well already. Maybe there are improvments which could be done, depending on data length (2 or 4: we could cast to u64 thus reducing shifts by 2).
> 	At least I tried to keep the API sane, and c/p the byteorder way. sreg, dreg, op, len, mask are mandatory. xor and shift are related to the selected op.
> 
> patch 7: patch's commit message says all.

Code for user-space is missing, won't take these until finished.
