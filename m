Return-Path: <SRS0=/Ma8=VD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84CEFC0650E
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Jul 2019 12:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 490CB2089C
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Jul 2019 12:02:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="EQ3u+Arf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfGFMCs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Jul 2019 08:02:48 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33991 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfGFMCr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Jul 2019 08:02:47 -0400
Received: by mail-wr1-f65.google.com with SMTP id u18so12380321wru.1
        for <netfilter-devel@vger.kernel.org>; Sat, 06 Jul 2019 05:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4EbNExg+eeJy8G4OPlBwKsMIGrrWxQfyRl+kvZT6XoE=;
        b=EQ3u+Arfn+T84bTpym4AoPrymvvWZgkDFzNQq0a/dq5Q4pDylnihfnFR1E6gfGNurD
         02tqdOt0ntAaUasXpwZQqY9RLJ2GVNCk0S71PSrO4wD1AsJS6Hxr5q0wgorXbKqxjjYU
         t8QvpnnsweerViwwVx1ZnuH1gHwkGhUFf2QzU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4EbNExg+eeJy8G4OPlBwKsMIGrrWxQfyRl+kvZT6XoE=;
        b=KdyZ5urJinHCkNk1HYnxXs3gpoPylJ4JyWd2dXtZ8JVOz/tq7t1D43a+IpHgtxAlYg
         m2ohgI4zDK5RQ9BxCGG0jXEZ29ZfgVhjMT262rBXsS30v8bdIv5hUqmohpK2YRMid3sQ
         WSnAtvq2eTOZMxzukbnqtAbozluDX6OUkE3V9eqi4Ugtr3HNu9xvQG0gWbPVoz5OGbrG
         LvUveXbU73j0zoX+n92g67/cTShPlKZ0FzulHJ9cB6SwnTwQtuYNz/OCCHfiLkpFLHfi
         gXn11/qUP3FtNdRYrJbyLgJ+6nW+niLrTE4GDOIlrSSIFMSXaKLCcspcbpglK/Luh76Q
         2UHQ==
X-Gm-Message-State: APjAAAWj6InoGg4n58iDuExVumljpZIgS6qtpKKTo9FBTp+yZpMeZbbG
        LdjNIpkpHnIqswvSCTu/GYTbuzKBKlQ=
X-Google-Smtp-Source: APXvYqwrND7Z7euDzBteINY2CyuK2aTxQFWf1dlkZ0Y1miBSdPadDvgU0QLveKN1v2Rydj+kRqqecw==
X-Received: by 2002:adf:ecc4:: with SMTP id s4mr9651980wro.331.1562414563602;
        Sat, 06 Jul 2019 05:02:43 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x6sm5674002wrt.63.2019.07.06.05.02.42
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 05:02:42 -0700 (PDT)
Subject: Re: [PATCH nf-next v2] netfilter:nft_meta: add NFT_META_VLAN support
To:     wenxu@ucloud.cn, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1562332598-17415-1-git-send-email-wenxu@ucloud.cn>
 <1562332598-17415-7-git-send-email-wenxu@ucloud.cn>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <caaaa242-6bb8-9d5e-af66-a0cd6592f81d@cumulusnetworks.com>
Date:   Sat, 6 Jul 2019 15:02:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562332598-17415-7-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 05/07/2019 16:16, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This patch provide a meta vlan to set the vlan tag of the packet.
> 
> for q-in-q outer vlan id 20:
> meta vlan set 0x88a8:20
> 
> set the default 0x8100 vlan type with vlan id 20
> meta vlan set 20
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/net/netfilter/nft_meta.h         |  5 ++++-
>  include/uapi/linux/netfilter/nf_tables.h |  4 ++++
>  net/netfilter/nft_meta.c                 | 25 +++++++++++++++++++++++++
>  3 files changed, 33 insertions(+), 1 deletion(-)
> 

The patch looks fine, just a note: you'll only be able to work with the
outer tag, so guessing to achieve a double-tagged frame you'll have to
add another NFT_META_VLAN_INNER(?) and will have to organize them one
after another.

Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
> index 5c69e9b..cb0f1e8 100644
> --- a/include/net/netfilter/nft_meta.h
> +++ b/include/net/netfilter/nft_meta.h
> @@ -6,7 +6,10 @@ struct nft_meta {
>  	enum nft_meta_keys	key:8;
>  	union {
>  		enum nft_registers	dreg:8;
> -		enum nft_registers	sreg:8;
> +		struct {
> +			enum nft_registers	sreg:8;
> +			enum nft_registers	sreg2:8;
> +		};
>  	};
>  };
>  
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index a0d1dbd..699524a 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -797,6 +797,7 @@ enum nft_exthdr_attributes {
>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
>   * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
>   * @NFT_META_BRI_IIFVPROTO: packet input bridge vlan proto
> + * @NFT_META_VLAN: packet vlan metadata
>   */
>  enum nft_meta_keys {
>  	NFT_META_LEN,
> @@ -829,6 +830,7 @@ enum nft_meta_keys {
>  	NFT_META_OIFKIND,
>  	NFT_META_BRI_IIFPVID,
>  	NFT_META_BRI_IIFVPROTO,
> +	NFT_META_VLAN,
>  };
>  
>  /**
> @@ -895,12 +897,14 @@ enum nft_hash_attributes {
>   * @NFTA_META_DREG: destination register (NLA_U32)
>   * @NFTA_META_KEY: meta data item to load (NLA_U32: nft_meta_keys)
>   * @NFTA_META_SREG: source register (NLA_U32)
> + * @NFTA_META_SREG2: source register (NLA_U32)
>   */
>  enum nft_meta_attributes {
>  	NFTA_META_UNSPEC,
>  	NFTA_META_DREG,
>  	NFTA_META_KEY,
>  	NFTA_META_SREG,
> +	NFTA_META_SREG2,
>  	__NFTA_META_MAX
>  };
>  #define NFTA_META_MAX		(__NFTA_META_MAX - 1)
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index 18a848b..fb3d12e 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -271,6 +271,20 @@ void nft_meta_set_eval(const struct nft_expr *expr,
>  		skb->secmark = value;
>  		break;
>  #endif
> +	case NFT_META_VLAN: {
> +		u32 *sreg2 = &regs->data[meta->sreg2];
> +		u16 vlan_proto;
> +		u16 vlan_tci;
> +
> +		vlan_tci = nft_reg_load16(sreg);
> +		vlan_proto = nft_reg_load16(sreg2);
> +
> +		if (vlan_proto != ETH_P_8021Q && vlan_proto != ETH_P_8021AD)
> +			return;
> +
> +		__vlan_hwaccel_put_tag(skb, htons(vlan_proto), vlan_tci & VLAN_VID_MASK);
> +		break;
> +	}
>  	default:
>  		WARN_ON(1);
>  	}
> @@ -281,6 +295,7 @@ void nft_meta_set_eval(const struct nft_expr *expr,
>  	[NFTA_META_DREG]	= { .type = NLA_U32 },
>  	[NFTA_META_KEY]		= { .type = NLA_U32 },
>  	[NFTA_META_SREG]	= { .type = NLA_U32 },
> +	[NFTA_META_SREG2]	= { .type = NLA_U32 },
>  };
>  EXPORT_SYMBOL_GPL(nft_meta_policy);
>  
> @@ -432,6 +447,13 @@ int nft_meta_set_init(const struct nft_ctx *ctx,
>  	case NFT_META_PKTTYPE:
>  		len = sizeof(u8);
>  		break;
> +	case NFT_META_VLAN:
> +		len = sizeof(u16);
> +		priv->sreg2 = nft_parse_register(tb[NFTA_META_SREG2]);
> +		err = nft_validate_register_load(priv->sreg2, len);
> +		if (err < 0)
> +			return err;
> +		break;
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> @@ -457,6 +479,9 @@ int nft_meta_get_dump(struct sk_buff *skb,
>  		goto nla_put_failure;
>  	if (nft_dump_register(skb, NFTA_META_DREG, priv->dreg))
>  		goto nla_put_failure;
> +	if (priv->key == NFT_META_VLAN &&
> +	    nft_dump_register(skb, NFTA_META_SREG2, priv->sreg2))
> +		goto nla_put_failure;
>  	return 0;
>  
>  nla_put_failure:
> 

