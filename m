From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/3] netfilter: nf_tables: add generation mask to
 set objects
Date: Tue, 4 Aug 2015 11:12:05 +0200
Message-ID: <20150804091205.GB6033@acer.localdomain>
References: <1438679128-4146-1-git-send-email-pablo@netfilter.org>
 <1438679128-4146-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42603 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbbHDJMH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 05:12:07 -0400
Content-Disposition: inline
In-Reply-To: <1438679128-4146-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.08, Pablo Neira Ayuso wrote:
> -#define NFT_SET_INACTIVE	(1 << 15)
> +static inline bool
> +nft_set_is_active(struct net *net, const struct nft_set *set)
> +{
> +	return (set->genmask & nft_genmask_cur(net)) == 0;
> +}

Do we really want this set of basic functions for every object type? There will
still be cases where we need to open code the checks anyway, f.i. iterators
and callbacks.
