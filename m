Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B9FC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Apr 2022 15:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236586AbiDMPkA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Apr 2022 11:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236592AbiDMPj7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Apr 2022 11:39:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC3865484;
        Wed, 13 Apr 2022 08:37:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EFFBB824D9;
        Wed, 13 Apr 2022 15:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0CDC385A9;
        Wed, 13 Apr 2022 15:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649864255;
        bh=s/FDyPwXHSh1CfotSKYmbOJsOxj8JCVTCzl/FNi66hk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=KewYssnAORZMZAlFge+XFNsM/vkdOda+G0Z2OMj95NDl5tYeA/YTPCxMpdLgbUDXb
         hEJVKrfHmYjKbjNJQkYMxai5+oIxV4QMzHJe5+2BPkx1zOmax3ygan+Jv3lOh/AQyH
         qunNQt7aiPb6dAejH0lIzd46P0VwfZtSsHrWmGKJ5yEpANt2L/Gi/OnLEYrI41M6L9
         ydmZZU2K+IQTGDUORnfCc51mwpOTjdkEZ1wXA5C72fSz9txLsh0rTcZqJN5wfRhRvb
         4OsbRZs+tILYVGTwG6Za1sxyxXzNCdTb1rqrz5QtzSIZ3iFPrCjHLdTbDZ77t5ZRRB
         fOBwbMN56Whqg==
Message-ID: <8faa4219-9b67-7ba8-7058-e350623c437c@kernel.org>
Date:   Wed, 13 Apr 2022 09:37:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH nf] netfilter: Update ip6_route_me_harder to consider L3
 domain
Content-Language: en-US
To:     Martin Willi <martin@strongswan.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <20220412074639.1963131-1-martin@strongswan.org>
 <a64e1342-c953-40c5-2afb-0e9654e7d002@kernel.org>
 <5572c06750a388056001d1b460d5e67c18fa2836.camel@strongswan.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <5572c06750a388056001d1b460d5e67c18fa2836.camel@strongswan.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/13/22 3:05 AM, Martin Willi wrote:
> Hi David,
> 
>>> @@ -39,6 +38,13 @@ int ip6_route_me_harder(struct net *net, struct
>>> sock *sk_partial, struct sk_buff
>>>  	};
>>>  	int err;
>>>  
>>> +	if (sk && sk->sk_bound_dev_if)
>>> +		fl6.flowi6_oif = sk->sk_bound_dev_if;
>>> +	else if (strict)
>>> +		fl6.flowi6_oif = dev->ifindex;
>>> +	else
>>> +		fl6.flowi6_oif = l3mdev_master_ifindex(dev);
>>
>> For top of tree, this is now fl6.flowi6_l3mdev
> 
> Ah, I see, missed that.
> 
> Given that IPv4 should be converted to flowi4_l3mdev as well (?), what
> about:
> 
>  * Keep the IPv6 patch in this form, as this allows stable to pick it
>    up as-is
>  * I'll add a follow-up patch, which converts both to flowi[46]_l3mdev

sure, backport to stable will be easier.

> 
> This would avoid some noise for a separate stable patch, but let me
> know what you prefer.
> 
>>  and dev is only needed here so make this:
>> 	fl6.flowi6_l3mdev = l3mdev_master_ifindex(skb_dst(skb)->dev);
> 
> Actually it is used in that "strict" branch, this is why I've added
> "dev" as a local variable. I guess that is still needed
> with flowi6_l3mdev?

ah, missed the strict branch use.
