From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nftables PATCH] src: proto: fix byteorder for ip headers.
Date: Wed, 4 Jun 2014 18:44:13 +0200
Message-ID: <20140604164412.GA30746@macbook.localnet>
References: <1401885989-9162-1-git-send-email-yshuiv7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Yuxuan Shui <yshuiv7@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49701 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaFDQoS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:44:18 -0400
Content-Disposition: inline
In-Reply-To: <1401885989-9162-1-git-send-email-yshuiv7@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 04, 2014 at 08:46:29PM +0800, Yuxuan Shui wrote:
> Add a new datatype for ip headers which specify the byteorder, this
> fixes bug 918.
> 
> Signed-off-by: Yuxuan Shui <yshuiv7@gmail.com>
> ---
>  src/proto.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/src/proto.c b/src/proto.c
> index 0a37a65..f1556db 100644
> --- a/src/proto.c
> +++ b/src/proto.c
> @@ -184,13 +184,21 @@ void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
>  	proto_ctx_debug(ctx, base);
>  }
>  
> +const struct datatype net_integer = {
> +	.type = TYPE_INTEGER,
> +	.byteorder = BYTEORDER_BIG_ENDIAN,
> +	.name = "net_integer",
> +	.desc = "network integer",
> +	.basetype = &integer_type,
> +};
> +
>  #define HDR_TEMPLATE(__name, __dtype, __type, __member)			\
>  	PROTO_HDR_TEMPLATE(__name, __dtype,				\
>  			   offsetof(__type, __member) * 8,		\
>  			   field_sizeof(__type, __member) * 8)
>  
>  #define HDR_FIELD(__name, __struct, __member)				\
> -	HDR_TEMPLATE(__name, &integer_type, __struct, __member)
> +	HDR_TEMPLATE(__name, &net_integer, __struct, __member)
>  #define HDR_BITFIELD(__name, __dtype,  __offset, __len)			\
>  	PROTO_HDR_TEMPLATE(__name, __dtype, __offset, __len)
>  #define HDR_TYPE(__name, __dtype, __struct, __member)			\

While this does make some sense, I would rather change
byteorder_conversion_op() to return immediately for expressions of size <= 8.
There is obviously no byteorder in this case, so this seems more like
working around incorrect behaviour of that function.
