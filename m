From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/7] netfilter: nf_tables: better encapsulation for the
 rule transaction code
Date: Fri, 28 Mar 2014 12:53:09 +0000
Message-ID: <20140328125308.GD7895@macbook.localnet>
References: <1395957197-4899-1-git-send-email-pablo@netfilter.org>
 <1395957197-4899-5-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55392 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaC1MxN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:53:13 -0400
Content-Disposition: inline
In-Reply-To: <1395957197-4899-5-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 27, 2014 at 10:53:14PM +0100, Pablo Neira Ayuso wrote:
> Another cleanup to accomodate set, chain and table transaction support.
> Move the rule transaction code to several functions to avoid too large
> commit and abort routines.
> 

> +static void nft_rule_commit_update(struct net *net, struct sk_buff *skb,
> +				   struct nft_trans *trans)

Just wondering, why aren't we using the net and skb from the context?

> +static void nft_rule_abort_undo(struct net *net, struct sk_buff *skb,
> +				struct nft_trans *trans)

In this case neither net nor skb are used.
