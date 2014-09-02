From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: nft_hash: no need for rcu in the hash set
 destroy path
Date: Tue, 2 Sep 2014 11:14:41 +0100
Message-ID: <20140902101440.GA12450@acer.localdomain>
References: <1409650721-9621-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, tgraf@suug.ch
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63015 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaIBKOq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:14:46 -0400
Content-Disposition: inline
In-Reply-To: <1409650721-9621-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 02, 2014 at 11:38:39AM +0200, Pablo Neira Ayuso wrote:
> The sets are released from the rcu callback, after the rule is removed
> from the chain list, which implies that nfnetlink cannot update the
> hashes (thus, no resizing may occur) and no packets are walking on the
> set anymore.

Unrelated to your patch, but to the RCU destruction: how does that make
sure that nfnetlink notifications are received in the proper order?
I mean, theoretically a new set with the same name could exist at that
time. The same problem exists for all objects that have user defined
identifiers or refer to them.
