Return-Path: <SRS0=/Ma8=VD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A1AC0650E
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Jul 2019 13:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A073C20863
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Jul 2019 13:35:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="SYPnTWfJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfGFNfq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Jul 2019 09:35:46 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41091 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfGFNfq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Jul 2019 09:35:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so12478598wrm.8
        for <netfilter-devel@vger.kernel.org>; Sat, 06 Jul 2019 06:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oeVwek081rLU3IzKc3eCX1wPmnlFaPnb3DNXz6UkpRk=;
        b=SYPnTWfJuAaCVAJE/69OMS6YDHiaLT4ce+AZxEH3cq3wjvE9/1QBGPeKccvlBMXgJg
         eGPlCnEL//DKnZwL/yi+2W0oyl50TzcJ6FtVFM7Xa4UeG9ygaPrDY8hv9tX/CI5pNT5o
         kl8YjepI0vKhNdI6aNnLFjAd5X2r+6Hjc7OU4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oeVwek081rLU3IzKc3eCX1wPmnlFaPnb3DNXz6UkpRk=;
        b=ktgNXDzB8D0iZrtSKtqx/CpTT+U9pAZhIaTJSK6TT08PKD3QOsSGFHh7ZyaZRad5Ca
         oWWR23l8LENP/iNzfgtu/KyC7xVmZ3xnYgkU2CIzSk6nWN2Hz3N4dUF90AGJTd9ct06D
         W7g0VBT/nNSJty55iCiozTfAl/3WSb47mln/ZcT1vNA6Ku5i3pT0jV591YcS/83VfYJa
         57OzlbkdH6EuCSl08W1p5JKksZpcX9/Evodey+U3YoQ8OB8+JCEC0VOVfEtLhfm6F5Am
         NgBKOPzzSizrQ/l3gTeFGcMOF88YNCReKJouwwltqMdwLAlQxP6PHeECcPTR14oQvt08
         S1kg==
X-Gm-Message-State: APjAAAVcRzU8UUN+ce8uYk59aDD/da2iLk/uWmeqSXTbyCG6cB8bCGeq
        46EYmJBBruS0r7C556hR7gOOohAMXVg=
X-Google-Smtp-Source: APXvYqzShFZq9QD4LtSeO1pw7PLziWgzO2+kYReupELaPx/6XLAfUqK6NeEFo2+eD8NemIXu4Mvb1A==
X-Received: by 2002:adf:e588:: with SMTP id l8mr7571526wrm.139.1562420144391;
        Sat, 06 Jul 2019 06:35:44 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s10sm14998307wmf.8.2019.07.06.06.35.43
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 06:35:43 -0700 (PDT)
Subject: Re: [PATCH 3/5 nf-next v3] bridge: add br_vlan_get_info_rcu()
To:     wenxu <wenxu@ucloud.cn>, pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1562364550-16974-1-git-send-email-wenxu@ucloud.cn>
 <1562364550-16974-3-git-send-email-wenxu@ucloud.cn>
 <114db8d1-2267-a338-688a-61f7f6db53ac@cumulusnetworks.com>
 <7b25d1ff-c527-5b79-d5de-6db13fdd8157@ucloud.cn>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <becc1445-f6af-9f43-de62-41d4c4a4b2e2@cumulusnetworks.com>
Date:   Sat, 6 Jul 2019 16:35:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <7b25d1ff-c527-5b79-d5de-6db13fdd8157@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 06/07/2019 16:27, wenxu wrote:
> 
> 在 2019/7/6 20:11, Nikolay Aleksandrov 写道:
>> On 06/07/2019 01:09, wenxu@ucloud.cn wrote:
>>> From: wenxu <wenxu@ucloud.cn>
>>>
>>> This new function allows you to fetch vlan info from packet path.
>>>
>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>>> ---
>>>  include/linux/if_bridge.h |  7 +++++++
>>>  net/bridge/br_vlan.c      | 23 ++++++++++++++++++-----
>>>  2 files changed, 25 insertions(+), 5 deletions(-)
>>>
>> Hi,
>> This patch will need more work, comments below.
>>
>>> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
>>> index 9e57c44..5c85608 100644
>>> --- a/include/linux/if_bridge.h
>>> +++ b/include/linux/if_bridge.h
>>> @@ -92,6 +92,8 @@ static inline bool br_multicast_router(const struct net_device *dev)
>>>  int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto);
>>>  int br_vlan_get_info(const struct net_device *dev, u16 vid,
>>>  		     struct bridge_vlan_info *p_vinfo);
>>> +int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
>>> +			 struct bridge_vlan_info *p_vinfo);
>>>  #else
>>>  static inline bool br_vlan_enabled(const struct net_device *dev)
>>>  {
>>> @@ -118,6 +120,11 @@ static inline int br_vlan_get_info(const struct net_device *dev, u16 vid,
>>>  {
>>>  	return -EINVAL;
>>>  }
>>> +static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
>>> +				       struct bridge_vlan_info *p_vinfo)
>>> +{
>>> +	return -EINVAL;
>>> +}
>>>  #endif
>>>  
>>>  #if IS_ENABLED(CONFIG_BRIDGE)
>>> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
>>> index 021cc9f66..2799a88 100644
>>> --- a/net/bridge/br_vlan.c
>>> +++ b/net/bridge/br_vlan.c
>>> @@ -1267,15 +1267,13 @@ int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid)
>>>  }
>>>  EXPORT_SYMBOL_GPL(br_vlan_get_pvid_rcu);
>>>  
>>> -int br_vlan_get_info(const struct net_device *dev, u16 vid,
>>> -		     struct bridge_vlan_info *p_vinfo)
>>> +static int __br_vlan_get_info(const struct net_device *dev, u16 vid,
>>> +			      struct net_bridge_port *p,
>>> +			      struct bridge_vlan_info *p_vinfo)
>>>  {
>>>  	struct net_bridge_vlan_group *vg;
>>>  	struct net_bridge_vlan *v;
>>> -	struct net_bridge_port *p;
>>>  
>>> -	ASSERT_RTNL();
>> Removing the assert here doesn't make the function proper for RCU usage.
>>  Also note that for the RCU version you need to check if vg
>> is null.
> Why need check if vg is null?  The br_vlan_find already check it.

Ah, right. Fair enough, drop that part.

>>
>>> -	p = br_port_get_check_rtnl(dev);
>>>  	if (p)
>>>  		vg = nbp_vlan_group(p);
>>>  	else if (netif_is_bridge_master(dev))
>>> @@ -1291,8 +1289,23 @@ int br_vlan_get_info(const struct net_device *dev, u16 vid,
>>>  	p_vinfo->flags = v->flags;
>>>  	return 0;
>>>  }
>>> +
>>> +int br_vlan_get_info(const struct net_device *dev, u16 vid,
>>> +		     struct bridge_vlan_info *p_vinfo)
>>> +{
>>> +	ASSERT_RTNL();
>>> +
>>> +	return __br_vlan_get_info(dev, vid, br_port_get_check_rtnl(dev), p_vinfo);
>>> +}
>>>  EXPORT_SYMBOL_GPL(br_vlan_get_info);
>>>  
>>> +int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
>>> +			 struct bridge_vlan_info *p_vinfo)
>>> +{
>>> +	return __br_vlan_get_info(dev, vid, br_port_get_check_rtnl(dev), p_vinfo);
>>> +}
>>> +EXPORT_SYMBOL_GPL(br_vlan_get_info_rcu);
>>> +
>> This should use br_port_get_check_rcu().
>>
>>>  static int br_vlan_is_bind_vlan_dev(const struct net_device *dev)
>>>  {
>>>  	return is_vlan_dev(dev) &&
>>>
>>

