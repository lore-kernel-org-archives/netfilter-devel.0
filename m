Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD76C31E5D
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 15:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99AE2208CB
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 15:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbfFQP5J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 11:57:09 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:33400 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727333AbfFQP5J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 11:57:09 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hcu0J-0001bx-ED; Mon, 17 Jun 2019 17:57:07 +0200
Date:   Mon, 17 Jun 2019 17:57:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft 3/5] src: add cache level flags
Message-ID: <20190617155707.GR31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20190617122518.10486-1-pablo@netfilter.org>
 <20190617122518.10486-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617122518.10486-3-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Jun 17, 2019 at 02:25:16PM +0200, Pablo Neira Ayuso wrote:
> The score approach based on command type is confusing.
> 
> This patch introduces cache level flags, each flag specifies what kind
> of object type is needed. These flags are set on/off depending on the
> list of commands coming in this batch.
> 
> cache_is_complete() now checks if the cache contains the objects that
> are needed in the cache through these new flags.

Thanks for committing to getting the cache stuff right!

[...]
> +enum cache_level_flags {
> +	NFT_CACHE_EMPTY		= 0,
> +	NFT_CACHE_TABLE		= (1 << 0),
> +	NFT_CACHE_CHAIN 	= (1 << 1),
> +	NFT_CACHE_SET 		= (1 << 2),
> +	NFT_CACHE_FLOWTABLE	= (1 << 3),
> +	NFT_CACHE_OBJECT	= (1 << 4),
> +	NFT_CACHE_SETELEM 	= (1 << 5),
> +	NFT_CACHE_RULE		= (1 << 6),
> +	NFT_CACHE_FULL		= (NFT_CACHE_TABLE	|
> +				   NFT_CACHE_CHAIN	|
> +				   NFT_CACHE_SET	|
> +				   NFT_CACHE_FLOWTABLE	|
> +				   NFT_CACHE_OBJECT	|
> +				   NFT_CACHE_SETELEM	|
> +				   NFT_CACHE_RULE),
> +};

I think we can do this in a way which reflects the implicit dependencies
when fetching ruleset elements. I think of something like:

| enum nft_cache_bits {
| 	NFT_CACHE_TABLE_BIT	= (1 << 0),
| 	NFT_CACHE_CHAIN_BIT	= (1 << 1),
| 	NFT_CACHE_SET_BIT	= (1 << 2),
| 	NFT_CACHE_FLOWTABLE_BIT	= (1 << 3),
| 	NFT_CACHE_OBJECT_BIT	= (1 << 4),
| 	NFT_CACHE_SETELEM_BIT	= (1 << 5),
| 	NFT_CACHE_RULE_BIT	= (1 << 6),
| 	__NFT_CACHE_MAX_BIT	= (1 << 7),
| };
| 
| enum cache_level_flags {
| 	NFT_CACHE_EMPTY		= 0,
| 	NFT_CACHE_TABLE		= NFT_CACHE_TABLE_BIT,
| 	NFT_CACHE_CHAIN		= NFT_CACHE_TABLE_BIT
| 				| NFT_CACHE_CHAIN_BIT,
| 	NFT_CACHE_SET		= NFT_CACHE_TABLE_BIT
| 				| NFT_CACHE_SET_BIT,
| 	NFT_CACHE_FLOWTABLE	= NFT_CACHE_TABLE_BIT
| 				| NFT_CACHE_FLOWTABLE_BIT,
| 	NFT_CACHE_OBJECT	= NFT_CACHE_TABLE_BIT
| 				| NFT_CACHE_OBJECT_BIT,
| 	NFT_CACHE_SETELEM	= NFT_CACHE_TABLE_BIT
| 				| NFT_CACHE_SET_BIT
| 				| NFT_CACHE_SETELEM_BIT,
| 	NFT_CACHE_RULE		= NFT_CACHE_TABLE_BIT
| 				| NFT_CACHE_CHAIN_BIT
| 				| NFT_CACHE_SETELEM_BIT
| 				| NFT_CACHE_RULE_BIT,
| 	NFT_CACHE_FULL		= __NFT_CACHE_MAX_BIT - 1,
| };

This removes these dependency details from cache_evaluate() functions.
What do you think?

Cheers, Phil

