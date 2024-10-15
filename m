Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3871E3790;
	Tue, 15 Oct 2024 10:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728987993; cv=none; b=tcRL8W1Yl8rH1bZzVjn3n8MAyTVEezpOoSJAE0cliiUSX5nA1mr7xfI/3qqFUEW0Xlon8dSDANNQu7wEmvAFeU4il/h2WzAXnAu9NrpQSdmBM4ZNbRfEo9tjyeW499ALQaVX8dcEbsxtukGxMtwia0rG09uVUtEcppoifPGBHQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728987993; c=relaxed/simple;
	bh=ReAIk4ZKygT7WqBsCGUp5VNvyTZbveGy2NaHPBHqn6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FtfzofJJkz76nKxR9XWgvCMGhPJ9qtmMUiTAuJZoe3Dl/9A3JvZe0/qc5rB45EYp8NZrSZn9mqJ1BBthTUNlf7ZDRCWbMYPKmCNPwEuVEC8UlPj6QcUoo3QqaF7DstmHI+RDc/4+vQ8t9N1qep5HYApDVT6yxoOI9nfuuZu5UqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B2ELZHFe; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B2ELZHFe"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2f7657f9f62so50281881fa.3;
        Tue, 15 Oct 2024 03:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728987989; x=1729592789; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2OEZSManMbDy+6XUNveh1qOkExWxjzK6ls7MTgzx6HM=;
        b=B2ELZHFe+7L7pgpXOIvf4ffeP5gSLMgAUcN4iQZitlWNLu28Nb3iy6mWLSNAaNnYJm
         mQi5P/AJoJWupKlA7Nrh8/JDo1O277T+OH4RC7AEWqiw0ya6VPag8Hswi4J+8hcrzyOl
         Unwoj6FEnvLu2ngAu3pRtEb0m3bptjbtDohl7JB3SeUggJaGtaYEwaae5B1YOVFCxAwR
         pLsWsnkiIhI+QD2OpcEKmgJ3J1I1+dH2xfGXJcB6Msw4d8y58wm7e1MQRAhAiEQ4bhhY
         LlmtE49DjzSvVX31P4iLAdu68WqJIDVunHY074kQx2yuaGcjQWei2HeVGBW0+15MgQBr
         fEkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728987989; x=1729592789;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2OEZSManMbDy+6XUNveh1qOkExWxjzK6ls7MTgzx6HM=;
        b=fw3VDvvXaepKMHcwqoNwkLpD4fsek7/C5nh4n/zuvPwzstYV5AbOk9/7X8tlq9HEjY
         M/JWt4JGafw66pnAC6dQrYotQwjt6IAKXV3O2gx8US89vQjgDlmryVp+Nio4f5vCZ0Y0
         +89IVQCP3vwHQxuuYyS/bcelCdC56QoUzw5+/lCogshKOh377SJwR4Ndft94gEsL6s/q
         ObOgl2wa/JJV///3CaH0Y7+0x8WB4c8lnzYrCfAOz2WCyx5uzvE9Oht2FSaBsHI72ZAa
         B6oibIiqjSWVleH9q3augwpN7kuljtIkK3wpuCkuP6Y+21LYDTHP4e7lPe+EXN5dfFAD
         mYFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVaY3WQ/QWILf3NMweKtJ2nR6Palh4l/0INaOr77QYVYWOjzkB2364Bhb73tJVWyxDA8ep/oKBJ+XDa56bENT0@vger.kernel.org, AJvYcCX0LYzY0/QlipjrPAkhdZUA9c4By44guUJsXpS2MviIzSSKkcRFRGYwigLGOk/h7tEhycvUGJnlI4BE+rc=@vger.kernel.org, AJvYcCX3wPEpt1KffJpf6OeIbZ5nKHOtWiXjgD9fLmT+fqlT4x1obxU/N6WMq3sfFqcOk+CwIumCRKy6@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+qv547ioCM0xZVDRVpQZAzBOIsHs9Ft6fsE9Q9qY9U4s0cEI4
	PIIcqmRmoHXarMJtPYBz2TSOjWI0N0DL/Y9Wn9FJ2v8X57vTDxYc
X-Google-Smtp-Source: AGHT+IG0LiZB9HnhbCpZVWzqC6TRdvuR7h3XUUllI7Bu0NEUbFWH+GXR3fi/dRhYBz6E26VF5ntuQA==
X-Received: by 2002:a2e:4e11:0:b0:2fb:5060:7037 with SMTP id 38308e7fff4ca-2fb506070e0mr27373511fa.41.1728987988831;
        Tue, 15 Oct 2024 03:26:28 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c98d77996asm529535a12.74.2024.10.15.03.26.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 03:26:28 -0700 (PDT)
Message-ID: <b919a6b1-1c07-4fc9-b3dc-a7ac2f3645bf@gmail.com>
Date: Tue, 15 Oct 2024 12:26:25 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 net-next 11/12] bridge:
 br_vlan_fill_forward_path_mode no _UNTAG_HW for dsa
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Nikolay Aleksandrov <razor@blackwall.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Roopa Prabhu <roopa@nvidia.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Jiri Pirko <jiri@resnulli.us>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>
References: <20241013185509.4430-1-ericwouds@gmail.com>
 <20241013185509.4430-12-ericwouds@gmail.com>
 <281cce27-c832-41c8-87d0-fbac05b8e802@blackwall.org>
 <6209405e-7100-43f9-b415-3be8fbcc6352@blackwall.org>
 <20241014144613.mkc62dvfzp3vr7rj@skbuf>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <20241014144613.mkc62dvfzp3vr7rj@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/14/24 4:46 PM, Vladimir Oltean wrote:
> Keeping the full email body untrimmed for extra context for the newly
> added people.
> 
> On Mon, Oct 14, 2024 at 09:22:07AM +0300, Nikolay Aleksandrov wrote:
>> On 14/10/2024 09:18, Nikolay Aleksandrov wrote:
>>> On 13/10/2024 21:55, Eric Woudstra wrote:
>>>> In network setup as below:
>>>>
>>>>              fastpath bypass
>>>>  .----------------------------------------.
>>>> /                                          \
>>>> |                        IP - forwarding    |
>>>> |                       /                \  v
>>>> |                      /                  wan ...
>>>> |                     /
>>>> |                     |
>>>> |                     |
>>>> |                   brlan.1
>>>> |                     |
>>>> |    +-------------------------------+
>>>> |    |           vlan 1              |
>>>> |    |                               |
>>>> |    |     brlan (vlan-filtering)    |
>>>> |    |               +---------------+
>>>> |    |               |  DSA-SWITCH   |
>>>> |    |    vlan 1     |               |
>>>> |    |      to       |               |
>>>> |    |   untagged    1     vlan 1    |
>>>> |    +---------------+---------------+
>>>> .         /                   \
>>>>  ----->wlan1                 lan0
>>>>        .                       .
>>>>        .                       ^
>>>>        ^                     vlan 1 tagged packets
>>>>      untagged packets
>>>>
>>>> Now that DEV_PATH_MTK_WDMA is added to nft_dev_path_info() the forward
>>>> path is filled also when ending with the mediatek wlan1, info.indev not
>>>> NULL now in nft_dev_forward_path(). This results in a direct transmit
>>>> instead of a neighbor transmit. This is how it should be, But this fails.
>>>>
>>>> br_vlan_fill_forward_path_mode() sets DEV_PATH_BR_VLAN_UNTAG_HW when
>>>> filling in from brlan.1 towards wlan1. But it should be set to
>>>> DEV_PATH_BR_VLAN_UNTAG in this case. Using BR_VLFLAG_ADDED_BY_SWITCHDEV
>>>> is not correct. The dsa switchdev adds it as a foreign port.
>>>>
>>>> Use BR_VLFLAG_TAGGING_BY_SWITCHDEV to make sure DEV_PATH_BR_VLAN_UNTAG is
>>>> set when there is a dsa-switch inside the bridge.
>>>>
>>>> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
>>>> ---
>>>>  net/bridge/br_private.h |  1 +
>>>>  net/bridge/br_vlan.c    | 18 +++++++++++++++++-
>>>>  2 files changed, 18 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>>>> index 8da7798f9368..7d427214cc7c 100644
>>>> --- a/net/bridge/br_private.h
>>>> +++ b/net/bridge/br_private.h
>>>> @@ -180,6 +180,7 @@ enum {
>>>>  	BR_VLFLAG_MCAST_ENABLED = BIT(2),
>>>>  	BR_VLFLAG_GLOBAL_MCAST_ENABLED = BIT(3),
>>>>  	BR_VLFLAG_NEIGH_SUPPRESS_ENABLED = BIT(4),
>>>> +	BR_VLFLAG_TAGGING_BY_SWITCHDEV = BIT(5),
>>>>  };
>>>>  
>>>>  /**
>>>> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
>>>> index 1830d7d617cd..b7877724b969 100644
>>>> --- a/net/bridge/br_vlan.c
>>>> +++ b/net/bridge/br_vlan.c
>>>> @@ -3,6 +3,7 @@
>>>>  #include <linux/netdevice.h>
>>>>  #include <linux/rtnetlink.h>
>>>>  #include <linux/slab.h>
>>>> +#include <net/dsa.h>
>>>>  #include <net/switchdev.h>
>>>>  
>>>>  #include "br_private.h"
>>>> @@ -100,6 +101,19 @@ static void __vlan_flags_commit(struct net_bridge_vlan *v, u16 flags)
>>>>  	__vlan_flags_update(v, flags, true);
>>>>  }
>>>>  
>>>> +static inline bool br_vlan_tagging_by_switchdev(struct net_bridge *br)
>>>
>>> no inline in .c files and also constify br
>>>
>>>> +{
>>>> +#if IS_ENABLED(CONFIG_NET_DSA)
>>>> +	struct net_bridge_port *p;
>>>> +
>>>> +	list_for_each_entry(p, &br->port_list, list) {
>>>> +		if (dsa_user_dev_check(p->dev))
>>>
>>> I don't think this can change at runtime, so please keep a counter in
>>> the bridge and don't walk the port list on every vlan add.
>>>
>>
>> you can use an internal bridge opt (check br_private.h) with a private opt
>> that's set when such device is added as a port, no need for a full counter
>> obviously
> 
> To continue on Nikolay's line of thought...
> 
> Can you abstractly describe which functional behavior do you need the
> bridge port to perform, rather than "it needs to be a DSA user port"?

Hello Vladimir,

This has to do with the sequence of events, when dealing with vlan
tagging in a bridge. When looking at the ingress of untaggged packets,
that will be tagged by a certain port of that bridge, it depends when
this tagging happens, in respect to the netfilter hook. This describes
the existing code:

Because we are using dev_fill_forward_path(), we know in all cases that
untagged packets arive and are tagged by the bridge.

In the case (#1) off a switchdev, the tagging is done before the packet
reaches the netfilter hook. Then the software fastpath code needs to
handle the packet, as if it is incoming tagged, remembering that this
tag was tagged at ingress (tuple->in_vlan_ingress). We need to remember
this, because dealing with hardware offloaded fastpath we then need to
skip this vlan tag in the hardware offloaded fastpath in
nf_flow_rule_match() and nf_flow_rule_route_common().

In all other cases (#2), 'normal' ports (ports without switchdev and
dsa-user-ports) the tagging is done after packet reaches the
netfilter-hook. Then the software fastpath code needs to handle the
packet, as incoming untagged.

(Of course the dsa-user-port is more complicated, but it all handled by
the dsa architecture so that it can be used as a 'normal' port.)

In both cases #1 and #2 also the other direction is taken into account.

To decide which case to apply, the code looks at
BR_VLFLAG_ADDED_BY_SWITCHDEV, which was actually used for something
else, but it is easily available in the code at that point and seemed to
work, so far...

But as it turns out, this flag is also set for foreign ports added to
the dsa-switchdev. This means that case #1 is applied to the foreign dsa
port. This breaks the software fastpath and, with packets not reaching
their destination, also the hardware offloaded fastpath does not start.
We need to apply case #2.

So actually we need to know, inside br_vlan_fill_forward_path_mode(),
whether or not net_bridge_port *dst is a foreign port added to the dsa
switchdev. Or perhaps there is another way to find out we have to apply
case #2.

> switchdev_bridge_port_offload() has a mechanism to inform the bridge
> core of extra abilities (like tx_fwd_offload). Perhaps you could modify
> the DSA drivers you need to set a similar bit to inform the bridge of
> their presence and ability. That would also work when the bridge port is
> a LAG over a DSA user port.
> 
> Also, please also CC DSA maintainers when you use DSA API outside
> net/dsa/ and drivers/net/dsa/. I am in the process of revamping the
> public DSA API and would like to be in touch with changes as they are
> made.
> 
>>>> +			return false;
>>>> +	}
>>>> +#endif
>>>> +	return true;
>>>> +}
>>>> +
>>>>  static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
>>>>  			  struct net_bridge_vlan *v, u16 flags,
>>>>  			  struct netlink_ext_ack *extack)
>>>> @@ -113,6 +127,8 @@ static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
>>>>  	if (err == -EOPNOTSUPP)
>>>>  		return vlan_vid_add(dev, br->vlan_proto, v->vid);
>>>>  	v->priv_flags |= BR_VLFLAG_ADDED_BY_SWITCHDEV;
>>>> +	if (br_vlan_tagging_by_switchdev(br))
>>>> +		v->priv_flags |= BR_VLFLAG_TAGGING_BY_SWITCHDEV;
>>>>  	return err;
>>>>  }
>>>>  
>>>> @@ -1491,7 +1507,7 @@ int br_vlan_fill_forward_path_mode(struct net_bridge *br,
>>>>  
>>>>  	if (path->bridge.vlan_mode == DEV_PATH_BR_VLAN_TAG)
>>>>  		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
>>>> -	else if (v->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
>>>> +	else if (v->priv_flags & BR_VLFLAG_TAGGING_BY_SWITCHDEV)
>>>>  		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG_HW;
>>>>  	else
>>>>  		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG;
>>>
