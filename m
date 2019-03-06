Return-Path: <SRS0=WT5G=RJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E95C43381
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 16:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3D5420663
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 16:55:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="bEFiB69c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfCFQzG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Mar 2019 11:55:06 -0500
Received: from mx1.riseup.net ([198.252.153.129]:56730 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbfCFQzG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Mar 2019 11:55:06 -0500
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 6ED871A5691;
        Wed,  6 Mar 2019 08:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1551891305; bh=dX+FeDlGS7laqQMJn+Mztn8LArF1jyvCVNkKCJNgbjk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=bEFiB69c5cWB4Pbgu+iZj36KdHbWIBtCSK3JkKSCPLAacr56+OLFBQQgosgM30LH/
         OwTKKcBkzQ0PGjooyKjtsWdoPVyipW39b8zibwppEiiqBChZ46DDJCNXLrU7HMs/np
         u4oRGTTREhz/tkUwNyR3U9/wiy4yZaMmiDA1L2NQ=
X-Riseup-User-ID: 22DF00B45030ECD0536A44B56278B9FDDFCC9F1580D944C0BFB4123AE9837215
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id B0E1F222311;
        Wed,  6 Mar 2019 08:55:04 -0800 (PST)
Subject: Re: [PATCH nf-next] netfilter: nft_osf: Add version option support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190306124435.708-1-ffmancera@riseup.net>
 <20190306161502.ur4zm3arcdcfc6bn@salvia>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <805cae0b-3458-5bf0-9be0-2698b90d097f@riseup.net>
Date:   Wed, 6 Mar 2019 17:55:11 +0100
MIME-Version: 1.0
In-Reply-To: <20190306161502.ur4zm3arcdcfc6bn@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sorry about the wrong mailing list, it was a mistake. I am fine with
your comments so I am going to send a v2. Thanks.

On 3/6/19 5:15 PM, Pablo Neira Ayuso wrote:
> Ups, wrong mailing list. For patches use
> netfilter-devel@vger.kernel.org, so patchwork catches these patches:
> 
> http://patchwork.ozlabs.org/project/netfilter-devel/list/
> 
> Anyway, no worries, comments below.
> 
> On Wed, Mar 06, 2019 at 01:44:35PM +0100, Fernando Fernandez Mancera wrote:
>> Add version option support to the nftables "osf" expression.
>>
>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
>> ---
>>  include/linux/netfilter/nfnetlink_osf.h  | 11 ++++++---
>>  include/uapi/linux/netfilter/nf_tables.h |  6 +++++
>>  net/netfilter/nfnetlink_osf.c            | 14 +++++------
>>  net/netfilter/nft_osf.c                  | 31 ++++++++++++++++++++----
>>  4 files changed, 47 insertions(+), 15 deletions(-)
>>
>> diff --git a/include/linux/netfilter/nfnetlink_osf.h b/include/linux/netfilter/nfnetlink_osf.h
>> index c6000046c966..788613f36935 100644
>> --- a/include/linux/netfilter/nfnetlink_osf.h
>> +++ b/include/linux/netfilter/nfnetlink_osf.h
>> @@ -21,13 +21,18 @@ struct nf_osf_finger {
>>  	struct nf_osf_user_finger	finger;
>>  };
>>  
>> +struct nf_osf_data {
>> +	const char *genre;
>> +	const char *version;
>> +};
>> +
>>  bool nf_osf_match(const struct sk_buff *skb, u_int8_t family,
>>  		  int hooknum, struct net_device *in, struct net_device *out,
>>  		  const struct nf_osf_info *info, struct net *net,
>>  		  const struct list_head *nf_osf_fingers);
>>  
>> -const char *nf_osf_find(const struct sk_buff *skb,
>> -			const struct list_head *nf_osf_fingers,
>> -			const int ttl_check);
>> +bool nf_osf_find(const struct sk_buff *skb,
>> +		 const struct list_head *nf_osf_fingers,
>> +		 const int ttl_check, struct nf_osf_data *data);
>>  
>>  #endif /* _NFOSF_H */
>> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
>> index a66c8de006cc..39bbb79ef4c2 100644
>> --- a/include/uapi/linux/netfilter/nf_tables.h
>> +++ b/include/uapi/linux/netfilter/nf_tables.h
>> @@ -1522,15 +1522,21 @@ enum nft_flowtable_hook_attributes {
>>   *
>>   * @NFTA_OSF_DREG: destination register (NLA_U32: nft_registers)
>>   * @NFTA_OSF_TTL: Value of the TTL osf option (NLA_U8)
>> + * @NFTA_OSF_FLAGS: flags (NLA_U8)
> 
> Please, use NLA_U32 for this.
> 
>>   */
>>  enum nft_osf_attributes {
>>  	NFTA_OSF_UNSPEC,
>>  	NFTA_OSF_DREG,
>>  	NFTA_OSF_TTL,
>> +	NFTA_OSF_FLAGS,
>>  	__NFTA_OSF_MAX,
>>  };
>>  #define NFTA_OSF_MAX (__NFTA_OSF_MAX - 1)
>>  
>> +enum nft_osf_flags {
>> +	NFT_OSF_F_VERSION = (1 << 0),
>> +};
>> +
>>  /**
>>   * enum nft_device_attributes - nf_tables device netlink attributes
>>   *
>> diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
>> index 1f1d90c1716b..7b827bcb412c 100644
>> --- a/net/netfilter/nfnetlink_osf.c
>> +++ b/net/netfilter/nfnetlink_osf.c
>> @@ -255,9 +255,9 @@ nf_osf_match(const struct sk_buff *skb, u_int8_t family,
>>  }
>>  EXPORT_SYMBOL_GPL(nf_osf_match);
>>  
>> -const char *nf_osf_find(const struct sk_buff *skb,
>> -			const struct list_head *nf_osf_fingers,
>> -			const int ttl_check)
>> +bool nf_osf_find(const struct sk_buff *skb,
>> +		 const struct list_head *nf_osf_fingers,
>> +		 const int ttl_check, struct nf_osf_data *data)
>>  {
>>  	const struct iphdr *ip = ip_hdr(skb);
>>  	const struct nf_osf_user_finger *f;
>> @@ -265,24 +265,24 @@ const char *nf_osf_find(const struct sk_buff *skb,
>>  	const struct nf_osf_finger *kf;
>>  	struct nf_osf_hdr_ctx ctx;
>>  	const struct tcphdr *tcp;
>> -	const char *genre = NULL;
>>  
>>  	memset(&ctx, 0, sizeof(ctx));
>>  
>>  	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts);
>>  	if (!tcp)
>> -		return NULL;
>> +		return false;
>>  
>>  	list_for_each_entry_rcu(kf, &nf_osf_fingers[ctx.df], finger_entry) {
>>  		f = &kf->finger;
>>  		if (!nf_osf_match_one(skb, f, ttl_check, &ctx))
>>  			continue;
>>  
>> -		genre = f->genre;
>> +		data->genre = f->genre;
>> +		data->version = f->version;
>>  		break;
>>  	}
>>  
>> -	return genre;
>> +	return true;
>>  }
>>  EXPORT_SYMBOL_GPL(nf_osf_find);
>>  
>> diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
>> index b13618c764ec..b7fe8df7b6cc 100644
>> --- a/net/netfilter/nft_osf.c
>> +++ b/net/netfilter/nft_osf.c
>> @@ -7,11 +7,13 @@
>>  struct nft_osf {
>>  	enum nft_registers	dreg:8;
>>  	u8			ttl;
>> +	u8			flags;
>>  };
>>  
>>  static const struct nla_policy nft_osf_policy[NFTA_OSF_MAX + 1] = {
>>  	[NFTA_OSF_DREG]		= { .type = NLA_U32 },
>>  	[NFTA_OSF_TTL]		= { .type = NLA_U8 },
>> +	[NFTA_OSF_FLAGS]	= { .type = NLA_U8 },
>>  };
>>  
>>  static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
>> @@ -20,9 +22,10 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
>>  	struct nft_osf *priv = nft_expr_priv(expr);
>>  	u32 *dest = &regs->data[priv->dreg];
>>  	struct sk_buff *skb = pkt->skb;
>> +	char os_match[NFT_OSF_MAXGENRELEN + 1];
>>  	const struct tcphdr *tcp;
>> +	struct nf_osf_data data;
>>  	struct tcphdr _tcph;
>> -	const char *os_name;
>>  
>>  	tcp = skb_header_pointer(skb, ip_hdrlen(skb),
>>  				 sizeof(struct tcphdr), &_tcph);
>> @@ -35,11 +38,18 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
>>  		return;
>>  	}
>>  
>> -	os_name = nf_osf_find(skb, nf_osf_fingers, priv->ttl);
>> -	if (!os_name)
>> +	if (!nf_osf_find(skb, nf_osf_fingers, priv->ttl, &data)) {
>>  		strncpy((char *)dest, "unknown", NFT_OSF_MAXGENRELEN);
>> -	else
>> -		strncpy((char *)dest, os_name, NFT_OSF_MAXGENRELEN);
>> +	} else {
>> +		if (priv->flags & NFT_OSF_F_VERSION) {
>> +			strlcpy(os_match, data.genre, NFT_OSF_MAXGENRELEN);
>> +			strlcat(os_match, ":", NFT_OSF_MAXGENRELEN);
>> +			strlcat(os_match, data.version, NFT_OSF_MAXGENRELEN);
> 
> Probably use snprintf for this?
> 
>         snprintf(os_match, NFT_OSF_MAXGENRELEN, "%s:%s", data.genre, data.version);
> 
>> +		} else {
>> +			strlcpy(os_match, data.genre, NFT_OSF_MAXGENRELEN);
>> +		}
>> +		strncpy((char *)dest, os_match, NFT_OSF_MAXGENRELEN);
>> +	}
>>  }
>>  
>>  static int nft_osf_init(const struct nft_ctx *ctx,
>> @@ -47,6 +57,7 @@ static int nft_osf_init(const struct nft_ctx *ctx,
>>  			const struct nlattr * const tb[])
>>  {
>>  	struct nft_osf *priv = nft_expr_priv(expr);
>> +	u8 flags;
>>  	int err;
>>  	u8 ttl;
>>  
>> @@ -57,6 +68,13 @@ static int nft_osf_init(const struct nft_ctx *ctx,
>>  		priv->ttl = ttl;
>>  	}
>>  
>> +	if (tb[NFTA_OSF_FLAGS]) {
>> +		flags = nla_get_u8(tb[NFTA_OSF_FLAGS]);
> 
> If you turn this into a NLA_U32, then you have to use here.
> 
>                 flags = ntohl(nla_get_be32(tb[NFTA_OSF_FLAGS]));
> 
>> +		if (flags != NFT_OSF_F_VERSION && flags != 0)
> 
> No need to restrict flags != 0, remove that part of the check.
> 
>> +			return -EINVAL;
>> +		priv->flags = flags;
>> +	}
>> +
>>  	priv->dreg = nft_parse_register(tb[NFTA_OSF_DREG]);
>>  	err = nft_validate_register_store(ctx, priv->dreg, NULL,
>>  					  NFT_DATA_VALUE, NFT_OSF_MAXGENRELEN);
>> @@ -73,6 +91,9 @@ static int nft_osf_dump(struct sk_buff *skb, const struct nft_expr *expr)
>>  	if (nla_put_u8(skb, NFTA_OSF_TTL, priv->ttl))
>>  		goto nla_put_failure;
>>  
>> +	if (nla_put_u8(skb, NFTA_OSF_FLAGS, priv->flags))
> 
> And
>         if (nla_put_be32(skb, NFTA_OSF_FLAGS, ntohl(priv->flags))
> 
> here.
> 
> Other than that, patch looks good!
> 
>> +		goto nla_put_failure;
>> +
>>  	if (nft_dump_register(skb, NFTA_OSF_DREG, priv->dreg))
>>  		goto nla_put_failure;
>>  
>> -- 
>> 2.20.1
>>
