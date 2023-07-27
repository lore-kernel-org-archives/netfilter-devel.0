Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C477C001DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jul 2023 16:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbjG0Qwt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jul 2023 12:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjG0Qws (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2023 12:52:48 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D729E
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2023 09:52:45 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qP4EE-0003MH-Ta; Thu, 27 Jul 2023 18:52:42 +0200
Date:   Thu, 27 Jul 2023 18:52:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nvt v3 PATCH 2/4] src: add input flag NFT_CTX_INPUT_NO_DNS to
 avoid blocking
Message-ID: <ZMKg2pzM0fhJLYZY@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20230720143147.669250-1-thaller@redhat.com>
 <20230720143147.669250-3-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720143147.669250-3-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 20, 2023 at 04:27:01PM +0200, Thomas Haller wrote:
[...]
> diff --git a/src/datatype.c b/src/datatype.c
> index da802a18bccd..8629a38da56a 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -599,27 +599,33 @@ static struct error_record *ipaddr_type_parse(struct parse_ctx *ctx,
>  					      const struct expr *sym,
>  					      struct expr **res)
>  {
> -	struct addrinfo *ai, hints = { .ai_family = AF_INET,
> -				       .ai_socktype = SOCK_DGRAM};
> -	struct in_addr *addr;
> -	int err;
> +	struct in_addr addr;
>  
> -	err = getaddrinfo(sym->identifier, NULL, &hints, &ai);
> -	if (err != 0)
> -		return error(&sym->location, "Could not resolve hostname: %s",
> -			     gai_strerror(err));
> +	if (ctx->input->flags & NFT_CTX_INPUT_NO_DNS) {

There are a bunch of getters defined in include/nftables.h for output
flags. I'd keep things consistent by introducing the same for input
flags, so the above becomes 'if (nft_input_no_dns(ctx->input))'.

In this spot it doesn't quite matter, but in the next patch you
introduce mixed use of a getter (for output flags) and the binary op as
seen here which is confusing.

Cheers, Phil
