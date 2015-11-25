From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 2/2] src: add ecn support
Date: Wed, 25 Nov 2015 20:02:36 +0000
Message-ID: <20151125200236.GI30712@macbook.localdomain>
References: <1448480362-12411-1-git-send-email-pablo@netfilter.org>
 <1448480362-12411-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:60952 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751495AbbKYUCk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 15:02:40 -0500
Content-Disposition: inline
In-Reply-To: <1448480362-12411-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.11, Pablo Neira Ayuso wrote:
> diff --git a/src/proto.c b/src/proto.c
> index 0e5932d..a1f5e75 100644
> --- a/src/proto.c
> +++ b/src/proto.c
> @@ -523,6 +523,27 @@ static const struct datatype dscp_type = {
> +...
> +static const struct datatype ecn_type = {
> +	.type		= TYPE_ECN,
> +	.name		= "ecn_type",

Same here (_type).

Otherwise looks good to me, thanks.
