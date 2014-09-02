From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf_tables PATCH 4/6 v5] netfilter: nf_tables: add helpers to
 schedule objects deletion
Date: Tue, 2 Sep 2014 16:20:01 +0100
Message-ID: <20140902152001.GD29716@acer.localdomain>
References: <1409668946-8168-1-git-send-email-arturo.borrero.glez@gmail.com>
 <1409668946-8168-5-git-send-email-arturo.borrero.glez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65066 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaIBPUG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:20:06 -0400
Content-Disposition: inline
In-Reply-To: <1409668946-8168-5-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 02, 2014 at 04:42:25PM +0200, Arturo Borrero Gonzalez wrote:
> This patch refactor the code to schedule objects deletion.
> 
> They are useful in follow-up patches.
> 
> In order to be able to use these new helper functions in all the code,
> they are placed in the top of the file, with all the dependant functions
> and symbols.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> v2: rebased: now, nft_del*() functions use list_del_rcu().
> v3: rebased on top of patch 1/5.
> v4: The v3 version had several issues due to the rebase. Fixed in this v4.
> v5: no changes, resending the series.


> +static inline void
> +nft_rule_disactivate_next(struct net *net, struct nft_rule *rule)
> +{
> +	rule->genmask = (1 << gencursor_next(net));
> +}

Since you're touching this anyway please get rid of the disactivate here as
well and use deactivate consistently.

> +static int
> +nf_tables_delrule_deactivate(struct nft_ctx *ctx, struct nft_rule *rule)
> +{
