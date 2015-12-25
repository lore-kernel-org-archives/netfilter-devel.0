From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_MARK: Add translation to nft
Date: Fri, 25 Dec 2015 13:14:33 +0100
Message-ID: <20151225121433.GB4822@salvia>
References: <20151223153353.GA17748@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46785 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbbLYMOh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 07:14:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9D82A7B550
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:14:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 90F26DA801
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:14:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B92D6DA804
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:14:34 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151223153353.GA17748@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 09:03:53PM +0530, Shivani Bhardwaj wrote:
>  static struct xtables_target mark_tg_reg[] = {
> @@ -259,6 +276,7 @@ static struct xtables_target mark_tg_reg[] = {
>  		.x6_parse      = MARK_parse_v0,
>  		.x6_fcheck     = MARK_check,
>  		.x6_options    = MARK_opts,
> +		.xlate	       = mark_tg_xlate,
>  	},
>  	{
>  		.family        = NFPROTO_IPV4,
> @@ -273,6 +291,7 @@ static struct xtables_target mark_tg_reg[] = {
>  		.x6_parse      = MARK_parse_v1,
>  		.x6_fcheck     = MARK_check,
>  		.x6_options    = MARK_opts,
> +		.xlate	       = mark_tg_xlate,
>  	},
>  	{
>  		.version       = XTABLES_VERSION,
> @@ -287,6 +306,7 @@ static struct xtables_target mark_tg_reg[] = {
>  		.x6_parse      = mark_tg_parse,
>  		.x6_fcheck     = mark_tg_check,
>  		.x6_options    = mark_tg_opts,
> +		.xlate	       = mark_tg_xlate,
>  	},

Same comment as for connmark. Please send v2.
