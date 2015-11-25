From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 1/2] src: add dscp support
Date: Wed, 25 Nov 2015 20:01:25 +0000
Message-ID: <20151125200124.GH30712@macbook.localdomain>
References: <1448480362-12411-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:60943 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752218AbbKYUB3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 15:01:29 -0500
Content-Disposition: inline
In-Reply-To: <1448480362-12411-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.11, Pablo Neira Ayuso wrote:
>  #define TYPE_MAX		(__TYPE_MAX - 1)
> diff --git a/include/proto.h b/include/proto.h
> index a43bf98..41af0c1 100644
> --- a/include/proto.h
> +++ b/include/proto.h
> @@ -176,7 +176,7 @@ enum ip_hdr_fields {
>  	IPHDR_INVALID,
>  	IPHDR_VERSION,
>  	IPHDR_HDRLENGTH,
> -	IPHDR_TOS,
> +	IPHDR_DSCP,

Shouldn't we keep both? I think it should work to do that or at least not be
difficult to make it work.

> diff --git a/src/proto.c b/src/proto.c
> index 28b93cb..0e5932d 100644
> --- a/src/proto.c
> +++ b/src/proto.c
> ...
> +static const struct datatype dscp_type = {
> +	.type		= TYPE_DSCP,
> +	.name		= "dscp_type",

We usually only add a _type suffix if that's really a part of the name,
pkt dccp_pkttype.
