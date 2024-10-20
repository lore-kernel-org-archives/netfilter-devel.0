Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A6831A89;
	Sun, 20 Oct 2024 09:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729416204; cv=none; b=B+G/CPXbF6ZVptaRcz2acavIRahvKOqEU2CQNMvDSRHKpqI81vjKvDP/3Np5CWxmWapkPMT2JILziee9VWdCh4msJxV5f/pFp6eJJWA9lMAiZHqWSMk5VWUEU2Lk6lFDTCsBQUBtSMlQsp6Bs152u+QeEWbvEfyuTUzWoOkWhR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729416204; c=relaxed/simple;
	bh=IOLDDDAMLkVvvupnIBQBFYkE1xhR1NVHMOuSMXzNNDw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=JVkEuIiCWvBAhbDgBUddhfZio1Lvn+k9OgDdAQhjMYT02Tlxg6TYquwT2Nq0lfIwrBLtbEgo9on07QIoCDTdc+Kewu96DXDp1WZxEJ/2f380HiH8W8WumM+zeS6LgeCpvjV+yJ6hPSD+rx3eWZ0iLqeUf4T8eCGrx+ao00QyGik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ivDpdqJa; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ivDpdqJa"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9a0c7abaa6so401768166b.2;
        Sun, 20 Oct 2024 02:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729416201; x=1730021001; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W4Y2KUB+hbtJn19jSvIIFOnWpC0zAHFrReVOA/qxdR4=;
        b=ivDpdqJa8NRyjWzZ5zmCJQ35u/UisbgGWmXGPbAOLv3gl6JEUEwd0ciSVODheANNde
         MWLGZ39SixgnG+1e6GjOwlTzAM73wiRT1HqTYBOinYPJH+Bz48q0GD/vvopWSe29lV6x
         Jqxto1FQ3toY4TUq9VonbLqmpAfKVew6vVKS28U08rsOLOSOGJSN6OslK5V/u9mKWSpO
         jLFZhap9mhbvW3yicHVtBM29Z7V8SNRvy8Lwq77od1PtN5w9z/aPzQTHxXBXnUtsNM6f
         xOgBkFY4tg66CRDRTpSUKtteEfH4MPcwrHf3VtejFeCpfmp5BvA1TX18bCqzy6l0FYYB
         +Onw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729416201; x=1730021001;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W4Y2KUB+hbtJn19jSvIIFOnWpC0zAHFrReVOA/qxdR4=;
        b=MDsrMq7wqdD1poWD7Dn+Sqg+1vzKrx+kaT6GHniNqfNtS63JRDuB2t9JMhRa03EFVt
         l2ysnNwMGP+iIFuXDoRm58H1dSup038nm1ysKFm0NdiuMNjiuGBEdsgjCMTB//eAUIh1
         SEkgYPEdLzg2ZrVgwsAQ9hPMbyNwgWR2qVuHtWm7xJIV7c6KWNol+8h584mjco4yhmUD
         lmNeQlAIxQobagP0x2G1gA2ZAkOr5kfZsGWZl5kNBKqjtyZA6D151eQ9aQXaCOOT2RrD
         akZeUmIOtOS7fQgjF9na/+Yxj9KUaBifHOfRiivzvjy1+TAI9QTDLUyxNrSsXdHF9blH
         0xTQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/XKQ8Dl7CBa5DxpFcbb8uv27yrlBeDoTpKXygMJCofvcWZ/X4GZ+E4NKFnyhyDcV/tb5wpkkt@vger.kernel.org, AJvYcCVQD/W5OV+9rxJwu8T8BDZV7pnvIdCAf6b/b5dYfA14Dheq7Q9+1+EAWCKfAgF9dUYA2EvDqrRSn5sLNiABUnEE@vger.kernel.org, AJvYcCWGIFOr1ijipbVPalKcVNfjFi3AjmJrcHbHtf2gxYRkyNlBFPCaGgk6v4mQzmgQ6nKvdXvqAglmGGI5Jrg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2+SbSLJvfGmc5v0l67AzlfN8arRrl2M28MJz5z0X2K92UOnZA
	6bVV9V39MCT++Fb+PLsdovkRrlwIEmPfdBsxEWn79xoJqEmnsavS
X-Google-Smtp-Source: AGHT+IEgeEWzgpPx3nVPIrbqvcrJAh2HUIJo7F0NyWd9SDpb4MuFwKVVJY7MiRPCxJBECDErYIC58A==
X-Received: by 2002:a17:907:7da0:b0:a99:5ad9:b672 with SMTP id a640c23a62f3a-a9a69a63330mr775176966b.10.1729416200400;
        Sun, 20 Oct 2024 02:23:20 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91599362sm69317566b.197.2024.10.20.02.23.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2024 02:23:19 -0700 (PDT)
Message-ID: <785f6b7a-1de1-46fe-aa6f-9b20feee5973@gmail.com>
Date: Sun, 20 Oct 2024 11:23:18 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 net-next 11/12] bridge:
 br_vlan_fill_forward_path_mode no _UNTAG_HW for dsa
From: Eric Woudstra <ericwouds@gmail.com>
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
 <b919a6b1-1c07-4fc9-b3dc-a7ac2f3645bf@gmail.com>
Content-Language: en-US
In-Reply-To: <b919a6b1-1c07-4fc9-b3dc-a7ac2f3645bf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/15/24 12:26 PM, Eric Woudstra wrote:
> 
> 
> On 10/14/24 4:46 PM, Vladimir Oltean wrote:
>> Keeping the full email body untrimmed for extra context for the newly
>> added people.
>>
>> On Mon, Oct 14, 2024 at 09:22:07AM +0300, Nikolay Aleksandrov wrote:
>>> On 14/10/2024 09:18, Nikolay Aleksandrov wrote:
>>>> On 13/10/2024 21:55, Eric Woudstra wrote:
>>>>> In network setup as below:
>>>>>
>>>>>              fastpath bypass
>>>>>  .----------------------------------------.
>>>>> /                                          \
>>>>> |                        IP - forwarding    |
>>>>> |                       /                \  v
>>>>> |                      /                  wan ...
>>>>> |                     /
>>>>> |                     |
>>>>> |                     |
>>>>> |                   brlan.1
>>>>> |                     |
>>>>> |    +-------------------------------+
>>>>> |    |           vlan 1              |
>>>>> |    |                               |
>>>>> |    |     brlan (vlan-filtering)    |
>>>>> |    |               +---------------+
>>>>> |    |               |  DSA-SWITCH   |
>>>>> |    |    vlan 1     |               |
>>>>> |    |      to       |               |
>>>>> |    |   untagged    1     vlan 1    |
>>>>> |    +---------------+---------------+
>>>>> .         /                   \
>>>>>  ----->wlan1                 lan0
>>>>>        .                       .
>>>>>        .                       ^
>>>>>        ^                     vlan 1 tagged packets
>>>>>      untagged packets
>>>>>
>>>>> Now that DEV_PATH_MTK_WDMA is added to nft_dev_path_info() the forward
>>>>> path is filled also when ending with the mediatek wlan1, info.indev not
>>>>> NULL now in nft_dev_forward_path(). This results in a direct transmit
>>>>> instead of a neighbor transmit. This is how it should be, But this fails.
>>>>>
>>>>> br_vlan_fill_forward_path_mode() sets DEV_PATH_BR_VLAN_UNTAG_HW when
>>>>> filling in from brlan.1 towards wlan1. But it should be set to
>>>>> DEV_PATH_BR_VLAN_UNTAG in this case. Using BR_VLFLAG_ADDED_BY_SWITCHDEV
>>>>> is not correct. The dsa switchdev adds it as a foreign port.
>>>>>
>>>>> Use BR_VLFLAG_TAGGING_BY_SWITCHDEV to make sure DEV_PATH_BR_VLAN_UNTAG is
>>>>> set when there is a dsa-switch inside the bridge.
>>>>>
>>>>> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
>>>>> ---
>>>>>  net/bridge/br_private.h |  1 +
>>>>>  net/bridge/br_vlan.c    | 18 +++++++++++++++++-
>>>>>  2 files changed, 18 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>>>>> index 8da7798f9368..7d427214cc7c 100644
>>>>> --- a/net/bridge/br_private.h
>>>>> +++ b/net/bridge/br_private.h
>>>>> @@ -180,6 +180,7 @@ enum {
>>>>>  	BR_VLFLAG_MCAST_ENABLED = BIT(2),
>>>>>  	BR_VLFLAG_GLOBAL_MCAST_ENABLED = BIT(3),
>>>>>  	BR_VLFLAG_NEIGH_SUPPRESS_ENABLED = BIT(4),
>>>>> +	BR_VLFLAG_TAGGING_BY_SWITCHDEV = BIT(5),
>>>>>  };
>>>>>  
>>>>>  /**
>>>>> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
>>>>> index 1830d7d617cd..b7877724b969 100644
>>>>> --- a/net/bridge/br_vlan.c
>>>>> +++ b/net/bridge/br_vlan.c
>>>>> @@ -3,6 +3,7 @@
>>>>>  #include <linux/netdevice.h>
>>>>>  #include <linux/rtnetlink.h>
>>>>>  #include <linux/slab.h>
>>>>> +#include <net/dsa.h>
>>>>>  #include <net/switchdev.h>
>>>>>  
>>>>>  #include "br_private.h"
>>>>> @@ -100,6 +101,19 @@ static void __vlan_flags_commit(struct net_bridge_vlan *v, u16 flags)
>>>>>  	__vlan_flags_update(v, flags, true);
>>>>>  }
>>>>>  
>>>>> +static inline bool br_vlan_tagging_by_switchdev(struct net_bridge *br)
>>>>
>>>> no inline in .c files and also constify br
>>>>
>>>>> +{
>>>>> +#if IS_ENABLED(CONFIG_NET_DSA)
>>>>> +	struct net_bridge_port *p;
>>>>> +
>>>>> +	list_for_each_entry(p, &br->port_list, list) {
>>>>> +		if (dsa_user_dev_check(p->dev))
>>>>
>>>> I don't think this can change at runtime, so please keep a counter in
>>>> the bridge and don't walk the port list on every vlan add.
>>>>
>>>
>>> you can use an internal bridge opt (check br_private.h) with a private opt
>>> that's set when such device is added as a port, no need for a full counter
>>> obviously
>>
>> To continue on Nikolay's line of thought...
>>
>> Can you abstractly describe which functional behavior do you need the
>> bridge port to perform, rather than "it needs to be a DSA user port"?
> 
> Hello Vladimir,
> 
> This has to do with the sequence of events, when dealing with vlan
> tagging in a bridge. When looking at the ingress of untaggged packets,
> that will be tagged by a certain port of that bridge, it depends when
> this tagging happens, in respect to the netfilter hook. This describes
> the existing code:
> 
> Because we are using dev_fill_forward_path(), we know in all cases that
> untagged packets arive and are tagged by the bridge.
> 
> In the case (#1) off a switchdev, the tagging is done before the packet
> reaches the netfilter hook. Then the software fastpath code needs to
> handle the packet, as if it is incoming tagged, remembering that this
> tag was tagged at ingress (tuple->in_vlan_ingress). We need to remember
> this, because dealing with hardware offloaded fastpath we then need to
> skip this vlan tag in the hardware offloaded fastpath in
> nf_flow_rule_match() and nf_flow_rule_route_common().
> 
> In all other cases (#2), 'normal' ports (ports without switchdev and
> dsa-user-ports) the tagging is done after packet reaches the
> netfilter-hook. Then the software fastpath code needs to handle the
> packet, as incoming untagged.
> 
> (Of course the dsa-user-port is more complicated, but it all handled by
> the dsa architecture so that it can be used as a 'normal' port.)
> 
> In both cases #1 and #2 also the other direction is taken into account.
> 
> To decide which case to apply, the code looks at
> BR_VLFLAG_ADDED_BY_SWITCHDEV, which was actually used for something
> else, but it is easily available in the code at that point and seemed to
> work, so far...
> 
> But as it turns out, this flag is also set for foreign ports added to
> the dsa-switchdev. This means that case #1 is applied to the foreign dsa
> port. This breaks the software fastpath and, with packets not reaching
> their destination, also the hardware offloaded fastpath does not start.
> We need to apply case #2.
> 
> So actually we need to know, inside br_vlan_fill_forward_path_mode(),
> whether or not net_bridge_port *dst is a foreign port added to the dsa
> switchdev. Or perhaps there is another way to find out we have to apply
> case #2.
> 

So after doing some more reading, at creation of the code using
BR_VLFLAG_ADDED_BY_SWITCHDEV would have been without problems.

After the switchdev was altered so that objects from foreign devices can
be added, it is problematic in br_vlan_fill_forward_path_mode(). I have
tested and indeed any foreign device does have this problem.

So we need a way to distinguish in br_vlan_fill_forward_path_mode()
whether or not we are dealing with a (dsa) foreign device on the switchdev.

I have come up with something, but this is most likely to crude to be
accepted, but for the sake of 'rfc' discussing it may lead to a proper
solution. So what does work is the following patch, so that
netif_has_dsa_foreign_vlan() can be used inside
br_vlan_fill_forward_path_mode().

Any suggestions on how this could be implemented properly would be
greatly appreciated.

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9d80f650345e75..3fb67312428a1f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1839,6 +1839,7 @@ enum netdev_reg_state {
  *
  *	@vlan_info:	VLAN info
  *	@dsa_ptr:	dsa specific data
+ *	@dsa_foreign_vlan:	Counter, number of dsa foreign vlans added
  *	@tipc_ptr:	TIPC specific data
  *	@atalk_ptr:	AppleTalk link
  *	@ip_ptr:	IPv4 specific data
@@ -2214,6 +2215,7 @@ struct net_device {
 #endif
 #if IS_ENABLED(CONFIG_NET_DSA)
 	struct dsa_port		*dsa_ptr;
+	unsigned int		dsa_foreign_vlan;
 #endif
 #if IS_ENABLED(CONFIG_TIPC)
 	struct tipc_bearer __rcu *tipc_ptr;
@@ -5135,6 +5137,15 @@ static inline bool netif_is_lag_port(const struct
net_device *dev)
 	return netif_is_bond_slave(dev) || netif_is_team_port(dev);
 }

+static inline bool netif_has_dsa_foreign_vlan(const struct net_device *dev)
+{
+#if IS_ENABLED(CONFIG_NET_DSA)
+	return !!dev->dsa_foreign_vlan;
+#else
+	return false;
+#endif
+}
+
 static inline bool netif_is_rxfh_configured(const struct net_device *dev)
 {
 	return dev->priv_flags & IFF_RXFH_CONFIGURED;
diff --git a/net/dsa/user.c b/net/dsa/user.c
index 74eda9b30608e6..775f6346120ed6 100644
--- a/net/dsa/user.c
+++ b/net/dsa/user.c
@@ -737,6 +737,8 @@ static int dsa_user_host_vlan_add(struct net_device
*dev,
 		return 0;
 	}

+	obj->orig_dev->dsa_foreign_vlan++;
+
 	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);

 	/* Even though drivers often handle CPU membership in special ways,
@@ -824,6 +826,8 @@ static int dsa_user_host_vlan_del(struct net_device
*dev,
 	if (dsa_port_skip_vlan_configuration(dp))
 		return 0;

+	obj->orig_dev->dsa_foreign_vlan--;
+
 	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);

 	return dsa_port_host_vlan_del(dp, vlan);



>> switchdev_bridge_port_offload() has a mechanism to inform the bridge
>> core of extra abilities (like tx_fwd_offload). Perhaps you could modify
>> the DSA drivers you need to set a similar bit to inform the bridge of
>> their presence and ability. That would also work when the bridge port is
>> a LAG over a DSA user port.
>>
>> Also, please also CC DSA maintainers when you use DSA API outside
>> net/dsa/ and drivers/net/dsa/. I am in the process of revamping the
>> public DSA API and would like to be in touch with changes as they are
>> made.
>>
>>>>> +			return false;
>>>>> +	}
>>>>> +#endif
>>>>> +	return true;
>>>>> +}
>>>>> +
>>>>>  static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
>>>>>  			  struct net_bridge_vlan *v, u16 flags,
>>>>>  			  struct netlink_ext_ack *extack)
>>>>> @@ -113,6 +127,8 @@ static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
>>>>>  	if (err == -EOPNOTSUPP)
>>>>>  		return vlan_vid_add(dev, br->vlan_proto, v->vid);
>>>>>  	v->priv_flags |= BR_VLFLAG_ADDED_BY_SWITCHDEV;
>>>>> +	if (br_vlan_tagging_by_switchdev(br))
>>>>> +		v->priv_flags |= BR_VLFLAG_TAGGING_BY_SWITCHDEV;
>>>>>  	return err;
>>>>>  }
>>>>>  
>>>>> @@ -1491,7 +1507,7 @@ int br_vlan_fill_forward_path_mode(struct net_bridge *br,
>>>>>  
>>>>>  	if (path->bridge.vlan_mode == DEV_PATH_BR_VLAN_TAG)
>>>>>  		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
>>>>> -	else if (v->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
>>>>> +	else if (v->priv_flags & BR_VLFLAG_TAGGING_BY_SWITCHDEV)
>>>>>  		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG_HW;
>>>>>  	else
>>>>>  		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG;
>>>>
