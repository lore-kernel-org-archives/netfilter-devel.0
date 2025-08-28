Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63F3264623
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 12:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756385900; cv=none; b=Tc4zby+J5iUJ4ruh4z3Z1EmBtIXtLCKnbwVqP+FHmFdQUGwQuF0oG0r7aHXwvcwGml/XDQirzZALtD404kyYvN+jtxruau2rBdIOo0z9yW+dEooyhjVh00EoLtwiYH6mcgXHsikpqHlPtya7M3ZTy4u/d/xudLw02zhUisSnRIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756385900; c=relaxed/simple;
	bh=9Yw5sHFf2UPjnDBpShxJYa4EM4/5T0TzrIG6a3kSlUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QnWH8KedbwzOjngyVwdDLUClZWHQTey8f3kk/65wjNxSaRGoCXgiOPnICiZHwYsXRtlrtoL4POx4V0nWvtdEceeeAbvtB3FjKvx2UD6t506az3cdxIsqJ0o8Wgh4oEoSfScBmHSAH6/RZ3K3t+Z0CXUSohI9xw4G1MLyP2roJh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nk5qsmze; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=a9pr0U7Y; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nk5qsmze";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="a9pr0U7Y"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id EA24A60655; Thu, 28 Aug 2025 14:58:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756385893;
	bh=97cjfUtjreN1E8ScMwUGufwGMsWLpZJ8YuuWzCG88Nk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nk5qsmzeaTWNZgL2R4C8scS+6+0a0Nx9Pe0KVyFgq8em6s/ITpbARJi1AMMeBCpsG
	 xcP/V7VcslDt7zsvPDSodKkEl4ex8oRFk6i3HEJvYyF3ggPPVtOlBAIyzenkO2B+ZE
	 J5ENyv9rvwEYeutqOt2JxoGptj0qLF1MP8G4hUlryFGwLUhpLUodGRSMFqJwWg51G9
	 MiECT0fVNgWD246gr6b108zEJ7+AURmprV/0tXcHpwmUOj9DTgbfwIZyYulHUTCkhF
	 GxJ5tz8R8rN6jsic8tXU23lJM4lC9hkQYwLSWcpe4GI56GWtjGgBhVYgUeY3qfglvN
	 F38Zpp81pLMag==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7706560655;
	Thu, 28 Aug 2025 14:58:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756385892;
	bh=97cjfUtjreN1E8ScMwUGufwGMsWLpZJ8YuuWzCG88Nk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a9pr0U7Yrs0x2k71MlDVl3qsnERrquI7DyRarCkobyHRvt5SifD9eYEGockM/DOBz
	 N7GYbQM8yfx07aSuuFsiwIgrpe0JE3b04n0M3aQbvY3et6W2agwKr0pIJvEXNwQi+F
	 1liPCyHsegZrVesHgQiqpJbCpMz9aE/01gxMu/oiLYpUP49UNUya6dP9YBF0FHuwhJ
	 f5p8JwLE5DY/ZeMkBIlio1xTYAYRLeAhFGuK4VT76Q00c/xsg69n3I/4/9lTSqL32h
	 nPazhHzaAFYie8URUcjuJnA323x4IRwb/1UJOmUgHNePxhJcVd/UrhzqvgeR86efKb
	 dQH4HYm4Ltgew==
Date: Thu, 28 Aug 2025 14:58:09 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nf-next] netfilter: nft_payload: extend offset to 65535
 bytes
Message-ID: <aLBSYUfiL_HR_BJK@calendula>
References: <20250828124831.4093-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250828124831.4093-1-fmancera@suse.de>

On Thu, Aug 28, 2025 at 02:48:31PM +0200, Fernando Fernandez Mancera wrote:
> In some situations 255 bytes offset is not enough to match or manipulate
> the desired packet field. Increase the offset limit to 65535 or U16_MAX.
> 
> In addition, the nla policy maximum value is not set anymore as it is
> limited to s16. Instead, the maximum value is checked during the payload
> expression initialization function.
> 
> Tested with the nft command line tool.
> 
> table ip filter {
> 	chain output {
> 		@nh,2040,8 set 0xff
> 		@nh,524280,8 set 0xff
> 		@nh,524280,8 0xff
> 		@nh,2040,8 0xff
> 	}
> }
> 
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
>  include/net/netfilter/nf_tables_core.h |  2 +-
>  net/netfilter/nft_payload.c            | 18 +++++++++++-------
>  2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
> index 6c2f483d9828..7644cfe9267d 100644
> --- a/include/net/netfilter/nf_tables_core.h
> +++ b/include/net/netfilter/nf_tables_core.h
> @@ -73,7 +73,7 @@ struct nft_ct {
>  
>  struct nft_payload {
>  	enum nft_payload_bases	base:8;
> -	u8			offset;
> +	u16			offset;
>  	u8			len;
>  	u8			dreg;
>  };
> diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
> index 7dfc5343dae4..728a4c78775c 100644
> --- a/net/netfilter/nft_payload.c
> +++ b/net/netfilter/nft_payload.c
> @@ -40,7 +40,7 @@ static bool nft_payload_rebuild_vlan_hdr(const struct sk_buff *skb, int mac_off,
>  
>  /* add vlan header into the user buffer for if tag was removed by offloads */
>  static bool
> -nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
> +nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u16 offset, u8 len)
>  {
>  	int mac_off = skb_mac_header(skb) - skb->data;
>  	u8 *vlanh, *dst_u8 = (u8 *) d;
> @@ -212,7 +212,7 @@ static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
>  	[NFTA_PAYLOAD_SREG]		= { .type = NLA_U32 },
>  	[NFTA_PAYLOAD_DREG]		= { .type = NLA_U32 },
>  	[NFTA_PAYLOAD_BASE]		= { .type = NLA_U32 },
> -	[NFTA_PAYLOAD_OFFSET]		= NLA_POLICY_MAX(NLA_BE32, 255),
> +	[NFTA_PAYLOAD_OFFSET]		= { .type = NLA_BE32 },

Should this be

                                        NLA_POLICY_MAX(NLA_BE32, 65535),

?

IIRC, NLA_POLICY_MAX(NLA_BE32, X) deprecates nft_parse_u32_check.

>  	[NFTA_PAYLOAD_LEN]		= NLA_POLICY_MAX(NLA_BE32, 255),
>  	[NFTA_PAYLOAD_CSUM_TYPE]	= { .type = NLA_U32 },
>  	[NFTA_PAYLOAD_CSUM_OFFSET]	= NLA_POLICY_MAX(NLA_BE32, 255),
> @@ -797,7 +797,7 @@ static int nft_payload_csum_inet(struct sk_buff *skb, const u32 *src,
>  
>  struct nft_payload_set {
>  	enum nft_payload_bases	base:8;
> -	u8			offset;
> +	u16			offset;
>  	u8			len;
>  	u8			sreg;
>  	u8			csum_type;
> @@ -812,7 +812,7 @@ struct nft_payload_vlan_hdr {
>  };
>  
>  static bool
> -nft_payload_set_vlan(const u32 *src, struct sk_buff *skb, u8 offset, u8 len,
> +nft_payload_set_vlan(const u32 *src, struct sk_buff *skb, u16 offset, u8 len,
>  		     int *vlan_hlen)
>  {
>  	struct nft_payload_vlan_hdr *vlanh;
> @@ -940,14 +940,18 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
>  				const struct nft_expr *expr,
>  				const struct nlattr * const tb[])
>  {
> +	u32 csum_offset, offset, csum_type = NFT_PAYLOAD_CSUM_NONE;
>  	struct nft_payload_set *priv = nft_expr_priv(expr);
> -	u32 csum_offset, csum_type = NFT_PAYLOAD_CSUM_NONE;
>  	int err;
>  
>  	priv->base        = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
> -	priv->offset      = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
>  	priv->len         = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
>  
> +	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U16_MAX, &offset);
> +	if (err < 0)
> +		return err;
> +	priv->offset = offset;

Then, this nft_parse_u32_check() can go away.

IIRC, nft_parse_u32_check() was added before  NLA_POLICY_MAX(NLA_BE32, X)
existed.

Can anyone please validate this claims?

> +
>  	if (tb[NFTA_PAYLOAD_CSUM_TYPE])
>  		csum_type = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_CSUM_TYPE]));
>  	if (tb[NFTA_PAYLOAD_CSUM_OFFSET]) {
> @@ -1069,7 +1073,7 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
>  	if (tb[NFTA_PAYLOAD_DREG] == NULL)
>  		return ERR_PTR(-EINVAL);
>  
> -	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U8_MAX, &offset);
> +	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U16_MAX, &offset);
>  	if (err < 0)
>  		return ERR_PTR(err);
>  
> -- 
> 2.51.0
> 
