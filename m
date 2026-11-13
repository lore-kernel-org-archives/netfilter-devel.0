Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564290;
	b=cVwXmjFFWXdTlOOVi23IMHvm2FAJAjdZMWG+U3J5Wh7iDek5vZONKxJSqIJu6EQ1YW1c
	 TDRX6JX78LsPbxhpg8Ca8fvsqjBr7YH6X0SPsTxMt3AK53gbGCUP6Rbb3Wh8t/wyr3Ylp
	 E3E3uDZur8z2qetLhi6QqLBvGySQViQ+yRcK9hqK5aCsnjf3ECO1JrUmpEv6n5P/Ep9rc
	 ouJ2l/GHEcI85q/Jb4wOby5L1aXTwae9kPS+fzQEF4a2DbDcipIERmSE3ceaGd8+4gXIz
	 gztLXRLSpPLLbWQNsaiVeAc/y3HYIPalwmfwcM/2g/ZRkSPlSow3pXB97fdv03ZJSvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564290;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=NcgEK1IpJO2NTB6PfZTNL85QOAIJKDJXCxuZa8U2ams=;
	b=j8P0nOJ/VE6s1PF+LXTxshah6DrRsdnMlYvJG8D94dgW6XDDdWQOPWl9uhBTv3BjqPd6
	 2MOH4Q0RunPK3yoZQeuMyyPK2L5nSVxxhfJV7NHuWxiveP8o8dRZwMw+t30Fgk/TMou15
	 JtGNWVcFWen3qpNr16rRJ9qMEnFLiJOZMr/UlCowQcm77M+uR9iFtIjSEj5a0K/AFFhhv
	 btYbc+9SV69p2PzrBFb6ksyLg7yM2bJTgjhMHwS1tuyRfXvvYjGjiQic+pY9e2hVU8fhM
	 hmAAKwUVF8kMmoMsMoO+JbnT7mDUZ2CAYupWBUITrLImn6cnTwhV7JYfa1RddaSrLwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=TRn3wh4N;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 1F95A606A327
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:04:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F95A606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=TRn3wh4N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794564287;
	bh=NcgEK1IpJO2NTB6PfZTNL85QOAIJKDJXCxuZa8U2ams=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TRn3wh4NYzGciacRwD1wvPXnHJzK6yCiGAH9Bv/x1y2Krt2JDQERYKwokK+ADhjLK
	 VyQe3rd7MKpjbonxNARaeNN27zXZ/SeY9oQvqdBIxbr7FiJcsKLBjzu+eg6ZYUPAxr
	 kJPbqa2/6ISckgkD6LzOJ5z1DeIOh6PNeyp9zUMerjK8Uc26nJR/D/CwNY24ZJheBj
	 VvttTAPPM7KexYGVK73aoywk5MrUo9EX8N3YCZby9QmoA3cdaf94SkVb9JiGnbPWDT
	 t4fJphQT16orOLxbO4GqSB6O96TZXsdQtOY7Q2ObfwD4pCUi3Hx2xFF5gf8YqeJ4Py
	 ICFSXl/T/7SNg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 558D060055;
	Fri, 13 Nov 2026 11:04:47 +0100 (CET)
Date: Fri, 13 Nov 2026 11:04:44 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
	phil@nwl.cc, matttbe@kernel.org
Subject: Re: [PATCH nf-next RFC] netfilter: nft_exthdr: add inner option type
 search for MPTCP
Message-ID: <avbgvAmjCnfHL1IJ@chamomile>
References: <20261008174030.6536-1-fmancera@suse.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261008174030.6536-1-fmancera@suse.de>

On Thu, Oct 08, 2026 at 07:40:30PM +0200, Fernando Fernandez Mancera wrote:
> MPTCP carries each of its suboptions as a separate TCP option of kind
> 30. The suboption type is stored in the upper four bits of the third
> byte of the option. A single packet can therefore carry several kind 30
> options, for example a dss followed by an mp-prio.
> 
> nft_exthdr_tcp_eval() stops at the first option whose kind equals
> NFTA_EXTHDR_TYPE. A rule such as:
> 
>   tcp option mptcp subtype mp-prio drop
> 
> only ever sees the first MPTCP suboption. If that is a dss, the subtype
> comparison fails and the rule never matches, even though an mp-prio is
> present later in the same header.
> 
> Add NFTA_EXTHDR_INNER_TYPE. When present, the expression keeps walking
> the options of the requested kind until one carries the requested inner
> type.  If the end of the options area is reached without a match, the
> expression behaves as if the option was not found: NFT_BREAK, or 0 when
> NFT_EXTHDR_F_PRESENT is set.
> 
> See the generated bytecodes below:
> 
> - Bytecode for matching mp-join without using NFT_EXTHDR_F_PRESENT flag.
> 
> ip mptcp_exthdr input 3 2
>   [ exthdr load tcpopt 1b @ 30 + 2 inner 1 => reg 1 ]
>   [ bitwise reg 1 = ( reg 1 & 0xf0 ) ^ 0x00 ]
>   [ cmp eq reg 1 0x10 ]
> 
> - Bytecode for matching mp-join using the NFT_EXTHDR_F_PRESENT flag.
> 
> ip mptcp_exthdr input 8 7
>   [ exthdr load tcpopt 1b @ 30 + 0 present inner 1 => reg 1 ]
>   [ cmp eq reg 1 0x01 ]
> 
> Note that while using the present flag is more efficient, if we decide
> to use it in nftables command line tool it would change the behavior
> when using old kernels reverting from false negatives to false
> positives.

Could you add a new NFT_EXTHDR_F_INNER_TYPE flag so this fails on
older kernels as Matthieu suggest?

For simplicity, the idea would be to set on this new flag if
the new NFTA_EXTHDR_INNER_TYPE attribute is used.

These are flags, setting NFT_EXTHDR_F_PRESENT and the new
NFT_EXTHDR_F_INNER_TYPE should be fine. This flag is an artifact that
would be only used in the control plane, so older kernels will reject
this rule since they do not support it.

> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
> Note: I have tested this with a libnftnl patch too and the code needs to
> be polished for the final version as more checks are required on init
> functions.
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  2 +
>  net/netfilter/nft_exthdr.c               | 50 +++++++++++++++++++-----
>  2 files changed, 43 insertions(+), 9 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 0b708153469c..99c977c72641 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -910,6 +910,7 @@ enum nft_exthdr_op {
>   * @NFTA_EXTHDR_FLAGS: extension header flags (NLA_U32)
>   * @NFTA_EXTHDR_OP: option match type (NLA_U32)
>   * @NFTA_EXTHDR_SREG: source register (NLA_U32: nft_registers)
> + * @NFTA_EXTHDR_INNER_TYPE: header inner type (NLA_U32)
>   */
>  enum nft_exthdr_attributes {
>  	NFTA_EXTHDR_UNSPEC,
> @@ -920,6 +921,7 @@ enum nft_exthdr_attributes {
>  	NFTA_EXTHDR_FLAGS,
>  	NFTA_EXTHDR_OP,
>  	NFTA_EXTHDR_SREG,
> +	NFTA_EXTHDR_INNER_TYPE,
>  	__NFTA_EXTHDR_MAX
>  };
>  #define NFTA_EXTHDR_MAX		(__NFTA_EXTHDR_MAX - 1)
> diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
> index 861bab93f435..984b54d2c6dd 100644
> --- a/net/netfilter/nft_exthdr.c
> +++ b/net/netfilter/nft_exthdr.c
> @@ -24,6 +24,8 @@ struct nft_exthdr {
>  	u8			dreg;
>  	u8			sreg;
>  	u8			flags;
> +	u8			inner_type;
> +	bool			has_inner;
>  };
>  
>  static unsigned int optlen(const u8 *opt, unsigned int offset)
> @@ -207,7 +209,15 @@ static void nft_exthdr_tcp_eval(const struct nft_expr *expr,
>  		if (priv->type != opt[i])
>  			continue;
>  
> -		if (i + optl > tcphdr_len || priv->len + priv->offset > optl)
> +		if (i + optl > tcphdr_len)
> +			goto err;
> +
> +		if (priv->has_inner && priv->type == TCPOPT_MPTCP) {
> +			if (!(optl >= 3 && (opt[i + 2] >> 4) == priv->inner_type))
> +				continue;
> +		}
> +
> +		if (priv->len + priv->offset > optl)
>  			goto err;
>  
>  		offset = i + priv->offset;
> @@ -507,14 +517,15 @@ static const struct nla_policy nft_exthdr_policy[NFTA_EXTHDR_MAX + 1] = {
>  	[NFTA_EXTHDR_FLAGS]		= NLA_POLICY_MASK(NLA_BE32, NFT_EXTHDR_F_PRESENT),
>  	[NFTA_EXTHDR_OP]		= NLA_POLICY_MAX(NLA_BE32, 255),
>  	[NFTA_EXTHDR_SREG]		= NLA_POLICY_MAX(NLA_BE32, NFT_REG32_MAX),
> +	[NFTA_EXTHDR_INNER_TYPE]	= NLA_POLICY_MAX(NLA_BE32, 255),
>  };
>  
>  static int nft_exthdr_init(const struct nft_ctx *ctx,
>  			   const struct nft_expr *expr,
>  			   const struct nlattr * const tb[])
>  {
> +	u32 offset, len, inner_type, flags = 0, op = NFT_EXTHDR_OP_IPV6;
>  	struct nft_exthdr *priv = nft_expr_priv(expr);
> -	u32 offset, len, flags = 0, op = NFT_EXTHDR_OP_IPV6;
>  	int err;
>  
>  	if (!tb[NFTA_EXTHDR_DREG] ||
> @@ -546,14 +557,27 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
>  			return err;
>  	}
>  
> +	if (tb[NFTA_EXTHDR_INNER_TYPE]) {
> +		if (op != NFT_EXTHDR_OP_TCPOPT)
> +			return -EOPNOTSUPP;
> +
> +		err = nft_parse_u32_check(tb[NFTA_EXTHDR_INNER_TYPE],
> +					  U8_MAX, &inner_type);
> +		if (err < 0)
> +			return err;
> +
> +		priv->has_inner = true;
> +	}
> +
>  	if ((flags & NFT_EXTHDR_F_PRESENT) && len != 1)
>  		return -EINVAL;
>  
> -	priv->type   = nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
> -	priv->offset = offset;
> -	priv->len    = len;
> -	priv->flags  = flags;
> -	priv->op     = op;
> +	priv->type		= nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
> +	priv->offset		= offset;
> +	priv->len		= len;
> +	priv->flags		= flags;
> +	priv->op		= op;
> +	priv->inner_type	= inner_type;
>  
>  	return nft_parse_register_store(ctx, tb[NFTA_EXTHDR_DREG],
>  					&priv->dreg, NULL, NFT_DATA_VALUE,
> @@ -574,7 +598,9 @@ static int nft_exthdr_tcp_set_init(const struct nft_ctx *ctx,
>  	    !tb[NFTA_EXTHDR_LEN])
>  		return -EINVAL;
>  
> -	if (tb[NFTA_EXTHDR_DREG] || tb[NFTA_EXTHDR_FLAGS])
> +	if (tb[NFTA_EXTHDR_DREG] ||
> +	    tb[NFTA_EXTHDR_FLAGS] ||
> +	    tb[NFTA_EXTHDR_INNER_TYPE])
>  		return -EINVAL;
>  
>  	err = nft_parse_u32_check(tb[NFTA_EXTHDR_OFFSET], U8_MAX, &offset);
> @@ -615,7 +641,8 @@ static int nft_exthdr_tcp_strip_init(const struct nft_ctx *ctx,
>  	    tb[NFTA_EXTHDR_DREG] ||
>  	    tb[NFTA_EXTHDR_FLAGS] ||
>  	    tb[NFTA_EXTHDR_OFFSET] ||
> -	    tb[NFTA_EXTHDR_LEN])
> +	    tb[NFTA_EXTHDR_LEN] ||
> +	    tb[NFTA_EXTHDR_INNER_TYPE])
>  		return -EINVAL;
>  
>  	if (!tb[NFTA_EXTHDR_TYPE])
> @@ -679,6 +706,11 @@ static int nft_exthdr_dump_common(struct sk_buff *skb, const struct nft_exthdr *
>  		goto nla_put_failure;
>  	if (nla_put_be32(skb, NFTA_EXTHDR_OP, htonl(priv->op)))
>  		goto nla_put_failure;
> +	if (priv->has_inner) {
> +		if (nla_put_be32(skb, NFTA_EXTHDR_INNER_TYPE,  htonl(priv->inner_type)))
> +			goto nla_put_failure;
> +	}
> +
>  	return 0;
>  
>  nla_put_failure:
> -- 
> 2.55.0
> 
