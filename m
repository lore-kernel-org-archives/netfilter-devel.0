Return-Path: <SRS0=xASF=3C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3C3C33CA9
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 21:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A20A21569
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 21:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbgAMV7c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jan 2020 16:59:32 -0500
Received: from correo.us.es ([193.147.175.20]:49906 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728733AbgAMV7c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 16:59:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E4DA1E8E8A
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 22:59:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D43C3DA714
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 22:59:28 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C9E1ADA703; Mon, 13 Jan 2020 22:59:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 856E6DA703;
        Mon, 13 Jan 2020 22:59:26 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 Jan 2020 22:59:26 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6796D42EF52A;
        Mon, 13 Jan 2020 22:59:26 +0100 (CET)
Date:   Mon, 13 Jan 2020 22:59:25 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 3/3] netfilter: bitwise: add support for shifts.
Message-ID: <20200113215925.uh5ir5ntcrtuh7qq@salvia>
References: <20200110123312.106438-1-jeremy@azazel.net>
 <20200110123312.106438-4-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110123312.106438-4-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jeremy,

On Fri, Jan 10, 2020 at 12:33:12PM +0000, Jeremy Sowden wrote:
> Currently nft_bitwise only supports boolean operations: NOT, AND, OR and
> XOR.  Extend it to do shifts as well.
> 
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  9 ++-
>  net/netfilter/nft_bitwise.c              | 84 ++++++++++++++++++++++--
>  2 files changed, 86 insertions(+), 7 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index dd4611767933..8f244ada0ad3 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -492,12 +492,15 @@ enum nft_immediate_attributes {
>   * @NFTA_BITWISE_LEN: length of operands (NLA_U32)
>   * @NFTA_BITWISE_MASK: mask value (NLA_NESTED: nft_data_attributes)
>   * @NFTA_BITWISE_XOR: xor value (NLA_NESTED: nft_data_attributes)
> + * @NFTA_BITWISE_LSHIFT: left shift value (NLA_U32)
> + * @NFTA_BITWISE_RSHIFT: right shift value (NLA_U32)

I'd suggest you add:

NFTA_BITWISE_OP

possible values are:

NFT_BITWISE_XOR (or _BOOL, you pick the more appropriate name for me)
NFT_BITWISE_RSHIFT
NFT_BITWISE_LSHIFT

You can introduce the NFTA_BITWISE_OP attribute in a initial
preparation patch.

If NFTA_BITWISE_OP is not specified, then default to NFT_BITWISE_XOR
to ensure backward compatibility with old userspace tooling.

>   *
> - * The bitwise expression performs the following operation:
> + * The bitwise expression supports boolean and shift operations.  It implements
> + * the boolean operations by performing the following operation:
>   *
>   * dreg = (sreg & mask) ^ xor
>   *
> - * which allow to express all bitwise operations:
> + * with these mask and xor values:
>   *
>   * 		mask	xor
>   * NOT:		1	1
> @@ -512,6 +515,8 @@ enum nft_bitwise_attributes {
>  	NFTA_BITWISE_LEN,
>  	NFTA_BITWISE_MASK,
>  	NFTA_BITWISE_XOR,
> +	NFTA_BITWISE_LSHIFT,
> +	NFTA_BITWISE_RSHIFT,

On top of NFTA_BITWISE_OP.

I'd suggest you add NFTA_BITWISE_DATA instead of NFTA_BITWISE_{R,L}SHIFT.

>  	__NFTA_BITWISE_MAX
>  };
>  #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
> diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
> index d7724250be1f..e4db77057b0e 100644
> --- a/net/netfilter/nft_bitwise.c
> +++ b/net/netfilter/nft_bitwise.c
> @@ -15,12 +15,20 @@
>  #include <net/netfilter/nf_tables.h>
>  #include <net/netfilter/nf_tables_offload.h>
>  
> +enum nft_bitwise_ops {
> +	OP_BOOL,
> +	OP_LSHIFT,
> +	OP_RSHIFT,
> +};
> +
>  struct nft_bitwise {
>  	enum nft_registers	sreg:8;
>  	enum nft_registers	dreg:8;
> +	enum nft_bitwise_ops	op:8;
>  	u8			len;
>  	struct nft_data		mask;
>  	struct nft_data		xor;
> +	u8			shift;
>  };
>  
>  void nft_bitwise_eval(const struct nft_expr *expr,
> @@ -31,6 +39,26 @@ void nft_bitwise_eval(const struct nft_expr *expr,
>  	u32 *dst = &regs->data[priv->dreg];
>  	unsigned int i;
>  
> +	if (priv->op == OP_LSHIFT) {

I'd suggest you turn this into something like:

        switch (priv->op) {
        case NFT_BITWISE_RSHIFT:
                nft_bitwise_rshift(...);
                break;
        case NFT_BITWISE_LSHIFT:
                nft_bitwise_lshift(...);
                break;
        case ...
        }

so these code below is store in a function.

> +		u32 carry = 0;
> +
> +		for (i = DIV_ROUND_UP(priv->len, sizeof(u32)); i > 0; i--) {
> +			dst[i - 1] = (src[i - 1] << priv->shift) | carry;
> +			carry = src[i - 1] >> (32 - priv->shift);
> +		}
> +		return;
> +	}
> +
> +	if (priv->op == OP_RSHIFT) {
> +		u32 carry = 0;
> +
> +		for (i = 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++) {
> +			dst[i] = carry | (src[i] >> priv->shift);
> +			carry = src[i] << (32 - priv->shift);
> +		}
> +		return;
> +	}
> +
>  	for (i = 0; i < DIV_ROUND_UP(priv->len, 4); i++)
>  		dst[i] = (src[i] & priv->mask.data[i]) ^ priv->xor.data[i];

Probably an initial preparation patch to move this code to a function
would be fine.

>  }
> @@ -41,6 +69,8 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
>  	[NFTA_BITWISE_LEN]	= { .type = NLA_U32 },
>  	[NFTA_BITWISE_MASK]	= { .type = NLA_NESTED },
>  	[NFTA_BITWISE_XOR]	= { .type = NLA_NESTED },
> +	[NFTA_BITWISE_LSHIFT]	= { .type = NLA_U32 },
> +	[NFTA_BITWISE_RSHIFT]	= { .type = NLA_U32 },
>  };
>  
>  static int nft_bitwise_init(const struct nft_ctx *ctx,
> @@ -52,11 +82,9 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
>  	u32 len;
>  	int err;
>  
> -	if (tb[NFTA_BITWISE_SREG] == NULL ||
> -	    tb[NFTA_BITWISE_DREG] == NULL ||
> -	    tb[NFTA_BITWISE_LEN] == NULL ||
> -	    tb[NFTA_BITWISE_MASK] == NULL ||
> -	    tb[NFTA_BITWISE_XOR] == NULL)
> +	if (!tb[NFTA_BITWISE_SREG] ||
> +	    !tb[NFTA_BITWISE_DREG] ||
> +	    !tb[NFTA_BITWISE_LEN])
>  		return -EINVAL;
>  
>  	err = nft_parse_u32_check(tb[NFTA_BITWISE_LEN], U8_MAX, &len);
> @@ -76,6 +104,36 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
>  	if (err < 0)
>  		return err;
>  
> +	if (tb[NFTA_BITWISE_LSHIFT]) {
> +		u32 shift;
> +
> +		err = nft_parse_u32_check(tb[NFTA_BITWISE_LSHIFT], U8_MAX,
> +					  &shift);
> +		if (err < 0)
> +			return err;
> +
> +		priv->shift = shift;
> +		priv->op = OP_LSHIFT;
> +		return 0;
> +	}
> +
> +	if (tb[NFTA_BITWISE_RSHIFT]) {
> +		u32 shift;
> +
> +		err = nft_parse_u32_check(tb[NFTA_BITWISE_RSHIFT], U8_MAX,
> +					  &shift);
> +		if (err < 0)
> +			return err;
> +
> +		priv->shift = shift;
> +		priv->op = OP_RSHIFT;
> +		return 0;
> +	}

I would like to see that the netlink interface really bails out for
combinations this does not support. That will make it easier later on
to extend it from userspace.

Therefore, something like:

        switch (priv->op) {
        case NFT_BITWISE_RSHIFT:
        case NFT_BITWISE_LSHIFT:
                if (!tb[NFTA_BITWISE_SHIFT])
                        return -EINVAL;

                if (tb[NFTA_BITWISE_MASK] ||
                    tb[NFTA_BITWISE_XOR])
                        return -EINVAL;

                break;
        case NFT_BITWISE_BOOL:
                if (!tb[NFTA_BITWISE_MASK] ||
                    !tb[NFTA_BITWISE_XOR])
                        return -EINVAL;

                if (tb[NFTA_BITWISE_SHIFT)
                        return -EINVAL;
                break;

> +	if (!tb[NFTA_BITWISE_MASK] ||
> +	    !tb[NFTA_BITWISE_XOR])
> +		return -EINVAL;
> +
>  	err = nft_data_init(NULL, &priv->mask, sizeof(priv->mask), &d1,
>  			    tb[NFTA_BITWISE_MASK]);
>  	if (err < 0)
> @@ -94,6 +152,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
>  		goto err2;
>  	}
>  
> +	priv->op = OP_BOOL;
>  	return 0;
>  err2:
>  	nft_data_release(&priv->xor, d2.type);
> @@ -113,6 +172,18 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
>  	if (nla_put_be32(skb, NFTA_BITWISE_LEN, htonl(priv->len)))
>  		return -1;
>  
> +	if (priv->op == OP_LSHIFT) {
> +		if (nla_put_be32(skb, NFTA_BITWISE_LSHIFT, htonl(priv->shift)))
> +			return -1;
> +		return 0;
> +	}
> +
> +	if (priv->op == OP_RSHIFT) {
> +		if (nla_put_be32(skb, NFTA_BITWISE_RSHIFT, htonl(priv->shift)))
> +			return -1;
> +		return 0;
> +	}

With one single NFTA_BITWISE_SHIFT, this will be consolidated.

Thanks for working on this.
