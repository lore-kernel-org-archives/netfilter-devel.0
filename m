Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EC6C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Apr 2022 23:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiDLXY4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiDLXY0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 19:24:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F176D0AAC
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2022 15:11:37 -0700 (PDT)
Date:   Wed, 13 Apr 2022 00:11:32 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jo-Philipp Wich <jo@mein.io>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC PATCH] datatype: accept abbrevs and ignore case on parsing
 symbolic constants
Message-ID: <YlX5FJaOOyYHUpbg@salvia>
References: <20220411080822.1801117-1-jo@mein.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220411080822.1801117-1-jo@mein.io>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Apr 11, 2022 at 10:08:22AM +0200, Jo-Philipp Wich wrote:
> Currently nftables does not accept abbreviated or lowercased weekday
> names as claimed in the nftables wiki [1]. This is due to the fact that
> symbolic_constant_parse() performs a strict equality check of the given
> constant value against the list of potential choices.
> 
> In order to implement the behaviour described by the wiki - which seems
> useful and intuitive in general - adjust the constant parsing function
> to to perform a case-insensitive prefix match of the user supplied value
> against the choice list.
> 
> The modified code does not check uniqueness of the prefix value, it will
> simply return the first matching item, but it will ensure to reject an
> empty string value.
> 
> 1: https://wiki.nftables.org/wiki-nftables/index.php/Matching_packet_metainformation#Matching_by_time
> 
> Signed-off-by: Jo-Philipp Wich <jo@mein.io>
> ---
>  src/datatype.c              |  5 +++--
>  tests/py/any/meta.t         |  4 ++++
>  tests/py/any/meta.t.payload | 18 ++++++++++++++++++
>  3 files changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/src/datatype.c b/src/datatype.c
> index 2e31c858..ce4a8aa8 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -149,9 +149,10 @@ struct error_record *symbolic_constant_parse(struct parse_ctx *ctx,
>  	const struct symbolic_constant *s;
>  	const struct datatype *dtype;
>  	struct error_record *erec;
> +	size_t idlen;
>  
> -	for (s = tbl->symbols; s->identifier != NULL; s++) {
> -		if (!strcmp(sym->identifier, s->identifier))

I'd suggest to add a flag for this:

DTYPE_F_ICASE

and set it on for the time datatype, I'd prefer to narrow down this
feature to this specific case and extend it to more usecases
progressively.

Would you send another patch version?

Thanks!

> +	for (s = tbl->symbols, idlen = strlen(sym->identifier); s->identifier != NULL; s++) {
> +		if (idlen > 0 && !strncasecmp(sym->identifier, s->identifier, idlen))
>  			break;
>  	}
>  
> diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
> index 12fabb79..4f130e7d 100644
> --- a/tests/py/any/meta.t
> +++ b/tests/py/any/meta.t
> @@ -212,7 +212,11 @@ meta time < "2022-07-01 11:00:00" accept;ok
>  meta time > "2022-07-01 11:00:00" accept;ok
>  meta day "Saturday" drop;ok
>  meta day 6 drop;ok;meta day "Saturday" drop
> +meta day "saturday" drop;ok;meta day "Saturday" drop
> +meta day "Sat" drop;ok;meta day "Saturday" drop
> +meta day "sat" drop;ok;meta day "Saturday" drop
>  meta day "Satturday" drop;fail
> +meta day "" drop;fail
>  meta hour "17:00" drop;ok
>  meta hour "17:00:00" drop;ok;meta hour "17:00" drop
>  meta hour "17:00:01" drop;ok
> diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
> index 16dc1211..b43c43c4 100644
> --- a/tests/py/any/meta.t.payload
> +++ b/tests/py/any/meta.t.payload
> @@ -1023,6 +1023,24 @@ ip test-ip4 input
>    [ cmp eq reg 1 0x00000006 ]
>    [ immediate reg 0 drop ]
>  
> +# meta day "saturday" drop
> +ip test-ip4 input
> +  [ meta load day => reg 1 ]
> +  [ cmp eq reg 1 0x00000006 ]
> +  [ immediate reg 0 drop ]
> +
> +# meta day "Sat" drop
> +ip test-ip4 input
> +  [ meta load day => reg 1 ]
> +  [ cmp eq reg 1 0x00000006 ]
> +  [ immediate reg 0 drop ]
> +
> +# meta day "sat" drop
> +ip test-ip4 input
> +  [ meta load day => reg 1 ]
> +  [ cmp eq reg 1 0x00000006 ]
> +  [ immediate reg 0 drop ]
> +
>  # meta day 6 drop
>  ip test-ip4 input
>    [ meta load day => reg 1 ]
> -- 
> 2.35.1
> 
