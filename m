Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61939C0650E
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2398E218A3
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:53:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="ac6Mu4EU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfGCMxx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 08:53:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50332 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfGCMxx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:53:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id n9so2112812wmi.0
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Jul 2019 05:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qtexCTmj4D40HhwTp/1r/SooWOwkZLUmcojNDt6MvGY=;
        b=ac6Mu4EUiBh5aj1zFrZDFG6i8K4V2881lvLM4SLRuFzQkLxmo1KfvFQiDu9SJsDqkN
         KF1UP/SPXLSwwtF87qAr0jVrbOGz9m3pibvdw/vJwSMPoWybVFmYJc1PzBB/WmJj3h66
         DexrC39lI1K0y/Fj5vq5U1mseRqQZiwXcAg4U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qtexCTmj4D40HhwTp/1r/SooWOwkZLUmcojNDt6MvGY=;
        b=I2XDYu0qvpt5Y9PfsvfEXRl6l5xki623s9fQbZbvtyQ/PXPWo1DWDl3xl8IlZ4IspW
         5DGw55ttDntZXoF4OMatra3ynz263xEIGSz9WxWjr4uxwJrcIPoBF+hm0u4AT7NyE4gd
         ePEnXUdok1vIe9/4d67kMawW7/itfProBm8ffq11LwEvjEENV83cp0zPBO29aKbvUWdi
         7E6IXFDGQ0av3wpMvHOjdEWvmGscAKh5b60PNlkykQTHlqeugDUNW8mrxk5ja2Z3wbJ6
         BE77gfGFPZQ7c7NoWBwFubV0GiGlXm75wKg/w6+71RvPM5wNUUSxKC9ApMjJpI0DPs7o
         GsaQ==
X-Gm-Message-State: APjAAAXvB+/Na/fxfL73mg4+c+yhyCcCaWbyxgZUqipvEZ+oS4K9AL4o
        WdULL1V2MhYPXgqSVQH7Ww/5kdlZ5xw7gQ==
X-Google-Smtp-Source: APXvYqzeZdOf5vuC3TehuH14c0muO+3+QU4emQQVntQI1i2ESnFOm9uznix3W8AV8rP9AC935mHEcw==
X-Received: by 2002:a1c:7217:: with SMTP id n23mr8184522wmc.47.1562158431221;
        Wed, 03 Jul 2019 05:53:51 -0700 (PDT)
Received: from [192.168.51.243] ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id t6sm2761195wmb.29.2019.07.03.05.53.50
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 05:53:50 -0700 (PDT)
Subject: Re: [PATCH] netfilter: nft_meta: fix bridge port vlan ID selector
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     wenxu@ucloud.cn, bridge@lists.linux-foundation.org
References: <20190703124040.19279-1-pablo@netfilter.org>
 <a5c31aff-669f-072e-b0f9-499edf6361a8@cumulusnetworks.com>
Message-ID: <36eb3c84-0874-ff18-dfb8-02a907aaccdb@cumulusnetworks.com>
Date:   Wed, 3 Jul 2019 15:53:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a5c31aff-669f-072e-b0f9-499edf6361a8@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 03/07/2019 15:48, Nikolay Aleksandrov wrote:
> On 03/07/2019 15:40, Pablo Neira Ayuso wrote:
>> Use br_vlan_enabled() and br_vlan_get_pvid() helpers as Nikolay
>> suggests.
>>
>> Rename NFT_META_BRI_PVID to NFT_META_BRI_IIFPVID before this patch hits
>> the 5.3 release cycle, to leave room for matching for the output bridge
>> port in the future.
>>
>> Reported-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>> Fixes: da4f10a4265b ("netfilter: nft_meta: add NFT_META_BRI_PVID support")
>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> ---
>>  include/uapi/linux/netfilter/nf_tables.h |  4 ++--
>>  net/netfilter/nft_meta.c                 | 17 ++++++++++-------
>>  2 files changed, 12 insertions(+), 9 deletions(-)
>>
> 
> Ah actually I might've hurried too much with the suggestion, we don't have a helper to
> check through a port if vlan filtering has been enabled. The helper assumes that
> the device is a bridge. So below you'll have to use p->br->dev with br_vlan_enabled().
> And in fact the proper way would be to get the "upper" device via netdev_master_upper_dev_get()
> and then to use that in order to avoid direct dereferencing.
> 

Sorry for the multiple replies, I just noticed this is running from fast-path so you'll
have to use the _rcu variant and check for null since they are unlinked before the port
flag is removed in del_nbp() (bridge/bf_if.c).

>> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
>> index 8859535031e2..8a1bd0b1ec8c 100644
>> --- a/include/uapi/linux/netfilter/nf_tables.h
>> +++ b/include/uapi/linux/netfilter/nf_tables.h
>> @@ -795,7 +795,7 @@ enum nft_exthdr_attributes {
>>   * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
>>   * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
>>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
>> - * @NFT_META_BRI_PVID: packet input bridge port pvid
>> + * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
>>   */
>>  enum nft_meta_keys {
>>  	NFT_META_LEN,
>> @@ -826,7 +826,7 @@ enum nft_meta_keys {
>>  	NFT_META_SECPATH,
>>  	NFT_META_IIFKIND,
>>  	NFT_META_OIFKIND,
>> -	NFT_META_BRI_PVID,
>> +	NFT_META_BRI_IIFPVID,
>>  };
>>  
>>  /**
>> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
>> index 4f8116de70f8..b8d8adc0852e 100644
>> --- a/net/netfilter/nft_meta.c
>> +++ b/net/netfilter/nft_meta.c
>> @@ -240,14 +240,17 @@ void nft_meta_get_eval(const struct nft_expr *expr,
>>  			goto err;
>>  		strncpy((char *)dest, p->br->dev->name, IFNAMSIZ);
>>  		return;
>> -	case NFT_META_BRI_PVID:
>> +	case NFT_META_BRI_IIFPVID: {
>> +		u16 p_pvid;
>> +
>>  		if (in == NULL || (p = br_port_get_rtnl_rcu(in)) == NULL)
>>  			goto err;
>> -		if (br_opt_get(p->br, BROPT_VLAN_ENABLED)) {
>> -			nft_reg_store16(dest, br_get_pvid(nbp_vlan_group_rcu(p)));
>> -			return;
>> -		}
>> -		goto err;
>> +		if (!br_vlan_enabled(in))
>> +			goto err;
>> +		br_vlan_get_pvid(in, &p_pvid);
>> +		nft_reg_store16(dest, p_pvid);
>> +		return;
>> +	}
>>  #endif
>>  	case NFT_META_IIFKIND:
>>  		if (in == NULL || in->rtnl_link_ops == NULL)
>> @@ -375,7 +378,7 @@ static int nft_meta_get_init(const struct nft_ctx *ctx,
>>  			return -EOPNOTSUPP;
>>  		len = IFNAMSIZ;
>>  		break;
>> -	case NFT_META_BRI_PVID:
>> +	case NFT_META_BRI_IIFPVID:
>>  		if (ctx->family != NFPROTO_BRIDGE)
>>  			return -EOPNOTSUPP;
>>  		len = sizeof(u16);
>>
> 

