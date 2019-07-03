Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7D9C0650E
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D44EA218A3
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:58:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="ALqwCP2g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfGCM6K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 08:58:10 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40502 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCM6K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:58:10 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so2272739wmj.5
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Jul 2019 05:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+MSJ8g+/dnXpSUMhjnJv5IQm8OrAJX3Wk4TQq7okxSU=;
        b=ALqwCP2gVd5VcVxJD6z5Jv9C1Zo9zHXWPW7oNNVodHZHJVy6/oY2LZqGZXv0ONk/yy
         uDuzfbTyHCfgpYucZGs472x8tV18ZcqgLkeGyxrELHO6eaKwy/RH0PjwaQTZ6h/4bbeR
         rhlIxAHwIDhOT7N8pLLa8hHarv/F8wu9/S/ps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+MSJ8g+/dnXpSUMhjnJv5IQm8OrAJX3Wk4TQq7okxSU=;
        b=Iu6MhYoSvuPXGWPVT9DiYPhKs85iYpV0NEKMHqO0J885del+3VqVYRmnYfcqKq7DOf
         9RWsY1+75+Q53+HprtlsjEsay4L0i2//TVLUVsl58pZ/ECOD9mlY8USxP08FOIvq49x8
         eVsoQAlnPvniUAMMclr+yjIf9GAI+KiJu6RFK3qe4ikVymKliHTxxD0rzTTKv/RBzI/P
         leGzCuQyaEhuqozOPVWnuYbxTOTZJXQ1aevQVKrkWECUMkSIcg1N8szD3v9FbEwEWh6S
         rryl0PqTNKMuZsYkMzkt9ucD5AoSkuMd7sfXDDwuCWtDoifHYW38catSulhOQ4zu5uwC
         n99g==
X-Gm-Message-State: APjAAAXjTgeomm0Hf6DNnCZsGuj69meIqwgLr82YRoyOuTvosVzH3Elc
        0lQglrg32Gaau/bot5qzQ3aU1w==
X-Google-Smtp-Source: APXvYqyYMNYv0I4z1OXZwUl47W3nRpud1I/NMj1ClwAox7ibjJU0jQMvvHZlwfxIhoFthOFIj9fb8Q==
X-Received: by 2002:a7b:c455:: with SMTP id l21mr8206556wmi.114.1562158687811;
        Wed, 03 Jul 2019 05:58:07 -0700 (PDT)
Received: from [192.168.51.243] ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id u25sm2812103wmc.3.2019.07.03.05.58.06
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 05:58:07 -0700 (PDT)
Subject: Re: [PATCH] netfilter: nft_meta: fix bridge port vlan ID selector
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     wenxu@ucloud.cn, bridge@lists.linux-foundation.org
References: <20190703124040.19279-1-pablo@netfilter.org>
 <a5c31aff-669f-072e-b0f9-499edf6361a8@cumulusnetworks.com>
 <36eb3c84-0874-ff18-dfb8-02a907aaccdb@cumulusnetworks.com>
Message-ID: <8021c567-5ed5-037a-d177-8de4557ae359@cumulusnetworks.com>
Date:   Wed, 3 Jul 2019 15:58:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <36eb3c84-0874-ff18-dfb8-02a907aaccdb@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 03/07/2019 15:53, Nikolay Aleksandrov wrote:
> On 03/07/2019 15:48, Nikolay Aleksandrov wrote:
>> On 03/07/2019 15:40, Pablo Neira Ayuso wrote:
>>> Use br_vlan_enabled() and br_vlan_get_pvid() helpers as Nikolay
>>> suggests.
>>>
>>> Rename NFT_META_BRI_PVID to NFT_META_BRI_IIFPVID before this patch hits
>>> the 5.3 release cycle, to leave room for matching for the output bridge
>>> port in the future.
>>>
>>> Reported-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>>> Fixes: da4f10a4265b ("netfilter: nft_meta: add NFT_META_BRI_PVID support")
>>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>>> ---
>>>  include/uapi/linux/netfilter/nf_tables.h |  4 ++--
>>>  net/netfilter/nft_meta.c                 | 17 ++++++++++-------
>>>  2 files changed, 12 insertions(+), 9 deletions(-)
>>>
>>
>> Ah actually I might've hurried too much with the suggestion, we don't have a helper to
>> check through a port if vlan filtering has been enabled. The helper assumes that
>> the device is a bridge. So below you'll have to use p->br->dev with br_vlan_enabled().
>> And in fact the proper way would be to get the "upper" device via netdev_master_upper_dev_get()
>> and then to use that in order to avoid direct dereferencing.
>>
> 
> Sorry for the multiple replies, I just noticed this is running from fast-path so you'll
> have to use the _rcu variant and check for null since they are unlinked before the port
> flag is removed in del_nbp() (bridge/bf_if.c).
> 

And then just scratch all of that and use p->br->dev directly, I saw it's already dereferenced before. :)
Apologies for the noise.

>>> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
>>> index 8859535031e2..8a1bd0b1ec8c 100644
>>> --- a/include/uapi/linux/netfilter/nf_tables.h
>>> +++ b/include/uapi/linux/netfilter/nf_tables.h
>>> @@ -795,7 +795,7 @@ enum nft_exthdr_attributes {
>>>   * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
>>>   * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
>>>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
>>> - * @NFT_META_BRI_PVID: packet input bridge port pvid
>>> + * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
>>>   */
>>>  enum nft_meta_keys {
>>>  	NFT_META_LEN,
>>> @@ -826,7 +826,7 @@ enum nft_meta_keys {
>>>  	NFT_META_SECPATH,
>>>  	NFT_META_IIFKIND,
>>>  	NFT_META_OIFKIND,
>>> -	NFT_META_BRI_PVID,
>>> +	NFT_META_BRI_IIFPVID,
>>>  };
>>>  
>>>  /**
>>> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
>>> index 4f8116de70f8..b8d8adc0852e 100644
>>> --- a/net/netfilter/nft_meta.c
>>> +++ b/net/netfilter/nft_meta.c
>>> @@ -240,14 +240,17 @@ void nft_meta_get_eval(const struct nft_expr *expr,
>>>  			goto err;
>>>  		strncpy((char *)dest, p->br->dev->name, IFNAMSIZ);
>>>  		return;
>>> -	case NFT_META_BRI_PVID:
>>> +	case NFT_META_BRI_IIFPVID: {
>>> +		u16 p_pvid;
>>> +
>>>  		if (in == NULL || (p = br_port_get_rtnl_rcu(in)) == NULL)
>>>  			goto err;
>>> -		if (br_opt_get(p->br, BROPT_VLAN_ENABLED)) {
>>> -			nft_reg_store16(dest, br_get_pvid(nbp_vlan_group_rcu(p)));
>>> -			return;
>>> -		}
>>> -		goto err;
>>> +		if (!br_vlan_enabled(in))
>>> +			goto err;
>>> +		br_vlan_get_pvid(in, &p_pvid);
>>> +		nft_reg_store16(dest, p_pvid);
>>> +		return;
>>> +	}
>>>  #endif
>>>  	case NFT_META_IIFKIND:
>>>  		if (in == NULL || in->rtnl_link_ops == NULL)
>>> @@ -375,7 +378,7 @@ static int nft_meta_get_init(const struct nft_ctx *ctx,
>>>  			return -EOPNOTSUPP;
>>>  		len = IFNAMSIZ;
>>>  		break;
>>> -	case NFT_META_BRI_PVID:
>>> +	case NFT_META_BRI_IIFPVID:
>>>  		if (ctx->family != NFPROTO_BRIDGE)
>>>  			return -EOPNOTSUPP;
>>>  		len = sizeof(u16);
>>>
>>
> 

