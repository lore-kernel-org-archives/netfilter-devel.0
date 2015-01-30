From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 2/4 v2] src: add support to import json/xml with
 the new syntax
Date: Fri, 30 Jan 2015 19:38:18 +0100
Message-ID: <20150130183818.GB22598@salvia>
References: <1422628525-28109-1-git-send-email-alvaroneay@gmail.com>
 <1422628525-28109-2-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43750 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759727AbbA3SfM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2015 13:35:12 -0500
Content-Disposition: inline
In-Reply-To: <1422628525-28109-2-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 30, 2015 at 03:35:23PM +0100, Alvaro Neira Ayuso wrote:
> diff --git a/src/libnftnl.map b/src/libnftnl.map
> index be7b998..d999046 100644
> --- a/src/libnftnl.map
> +++ b/src/libnftnl.map
> @@ -182,8 +182,13 @@ global:
>    nft_ruleset_attr_unset;
>    nft_ruleset_attr_set;
>    nft_ruleset_attr_get;
> +  nft_ruleset_ctx_is_set;
> +  nft_ruleset_ctx_get;
> +  nft_ruleset_ctx_get_u32;
>    nft_ruleset_parse;
>    nft_ruleset_parse_file;
> +  nft_ruleset_parse_file_cb;
> +  nft_ruleset_parse_buffer_cb;
>    nft_ruleset_snprintf;
>    nft_ruleset_fprintf;

You cannot place these new symbols here. You have to add new symbols
to a new section as I explained in patch 1/4.
