Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D12C2FE071
	for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 23:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779753087; cv=none; b=lPNVH2YZEBdZFohz9qw84+E1NW/jPN/oxqSbjqHUb3zbVfcW32sbpKv/J+XRX6Y3cfE8KdtG6a088pBTfnvJHVJif4fBg5qh8SpceGv34OrPBgxupqe9xnHWOBMuXTnHp9YTCtbfw5PPjnLw/h1PXjxfz0dja13taWCPUTIOVbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779753087; c=relaxed/simple;
	bh=v20gcXoz4sYDQeqXUYzUY2wNXj9uKQre8gB66TcuXWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MuyM8L0KaqxBAhQL6cutMd7Dyal4aUX45SddQug2/A8xUJPH1vEXLxolaeVKFQuapd63S95UO3mQJykJ/WfeSeIAqFyH7MAiufU0JhcdJ9WbFzNGrxI0eJFLvaqREAnniQ3pnGOCGNaQ+9jUW7puw7c23FYEk4VoxgC6GDvce0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o+BfKQS8; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o+BfKQS8"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b4583f0a1aso70904355ad.3
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 16:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779753085; x=1780357885; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SkB5JQWfeL7TfyD8Kima3mYgYZupJEetSj6r7c0uD2s=;
        b=o+BfKQS8X5bQQh5flJzq12AOBx/2aVngmFzO3fmsxiCYk1DMVqsQkqByg32k6KFAco
         DT7jjZb/OJd7L1JKRVn8DblgrDhtvPvkpSzAGbsf7wvyT9mXFcoLo5k/ObUKPdDeB0+U
         zGcDbQARgrDdbKymLABDGZ5gQkj8NlQYWahFcSu18UjtNGI/d/1yGQvgdrhXuOobzKXz
         5A/p2vcqkZntC3q6IJ13Dvr/83KKM5vu2/B2+LPPJWolpAc2wERIjW8YE2/SOCG4l24H
         HlA1rf6McQ3M7FSp7u03wNzamGeM9Kd25iSv7R7AoY6kge1wXQKSMDd9qKSBdlm4AM2R
         4AgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779753085; x=1780357885;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SkB5JQWfeL7TfyD8Kima3mYgYZupJEetSj6r7c0uD2s=;
        b=JvXMmR7KNoQftB64Hl+DxCCk9oOmFTTujR30cwsHaAX//T0mYSi+zm9ZkSXq0JeoNE
         Yf60WC11FYUoRwKfAEWh6ui9z/VCfBggnGEzgTavbVh10V1f1EoD0PGlyHktL7ivW3b8
         eCTSlCjOL9RH5cQVVLD3FXl0GVlhD4ZfNWzOUsM916cmqbMCMq0WaEIDAV5fAKwQ2qFP
         5MoRr05Lk/jw5bwmMtW2kd4SGLoXBrgyHvZjmyNrYml1cttdMdriTCvbbomGeMtFKajL
         cCqGFarTLDQsoZJe4njhC0VTs5w4+9kqWyosPTsSGTowZVf3xX4sgPqkuhCie9bsee7L
         ixfw==
X-Forwarded-Encrypted: i=1; AFNElJ8823LLQHVMdJf6siIMGzq1MNI2+GdmSENlEduNb6F29QEJ1ggesnch72aVkIkkNhFyVMbpyQRWx7SyuklqxZs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLks+DjTuKnZIN032K524IWoNS19tpMRTGVMor7/PPqJA+swi3
	NfRz2kgLQwuqO8DNIbBC95X5FoaDwulcj1uB4nR6QtSl1/myi+kk8Qhb
X-Gm-Gg: Acq92OGP3Pli0lLxEuSD09acKRo38G6K01Z29xXnyQ5zaOC+hRF3DOUJKwtUsU0UUvG
	tJiy71+Q2U4NC8fuyt41CtX6dJmdapSfqBCYloH0ZwdAs6oCc0+Jz8kru0ny/p8lTBgh0U3lGn9
	feIh1Y0wAOhPBhx8ITe+j7Wyh3+JonT5ewAJxXziT4HWKqhXqd8/6V8/+GIZfyrBnVIgTDHxxY4
	BcJWaJEZD2xFsiLcLGuZASQdrx0VySgIpFpVOQ1u7h2Uaeg/7JMfZ7f/AfzYWapOlImxmJ9uUsC
	ANiyqrEPx1dqeWqzKOzdVTjMOr29DYceu6csvTU2RWt977M6nmZgNMdpMhS+BUoD0+le6N9lsoW
	Nng0IBJ3t2K7Q2xhIuK79LsHyOKS7reOuvnH5uvlr70j1E+hdPaTWwpirIMxFpvuxSyhcPZP0h0
	6OeczolT8OLbHrHgaj5ZC11Gteys6qkg==
X-Received: by 2002:a17:902:ce88:b0:2bd:a3c5:6d96 with SMTP id d9443c01a7336-2beb0756707mr174326985ad.14.1779753084809;
        Mon, 25 May 2026 16:51:24 -0700 (PDT)
Received: from [192.168.89.2] ([119.214.48.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56f9100sm101033355ad.37.2026.05.25.16.51.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 16:51:24 -0700 (PDT)
Message-ID: <094bfd7a-f214-4291-a15d-cb35246c6ba4@gmail.com>
Date: Tue, 26 May 2026 08:51:21 +0900
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: flowtable: resolve LAG slave for direct HW
 offload
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260525162417.366556-1-hurryman2212@gmail.com>
 <da748e80-450f-42bd-a3bd-fde52c1c7d90@gmail.com> <ahSGCBw-fRq_oF-Q@chamomile>
Content-Language: en-US
From: Jihong Min <hurryman2212@gmail.com>
In-Reply-To: <ahSGCBw-fRq_oF-Q@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/26/26 02:25, Pablo Neira Ayuso wrote:
> On Tue, May 26, 2026 at 01:33:09AM +0900, Jihong Min wrote:
>> Sorry for the noise.
>>
>> While preparing the git-send-email command, I noticed that the subject
>> prefix was not set correctly. This should have been sent with the
>> nf-next prefix.
>>
>> I also noticed that the Assisted-by trailer was missing. Most of the
>> patch was written by me, but I did get help from GPT-5.5 for some of
>> the RCU and lifetime details, so the patch should have included:
>>
>> Assisted-by: Codex:gpt-5.5
>>
>> Also, this change was tested on a Lumen W1700K2 with a Linux 6.18
>> OpenWrt-based image, where it enabled flow offload in a bonding setup.
>> I have also applied the same diff on top of nf-next and completed a
>> compile test there. I checked that the relevant infrastructure for
>> bonding flow offload support is identical between the tested tree and
>> nf-next.
> 
> Can you make this work with fill_forward_path in the bonding device?
> 

Hi Pablo,

Sure, I will do that.

The scope became a bit wider than I initially expected, since this now
needs the generic forward path extension, bonding support, and the
netfilter flowtable change to fit together cleanly.

I will send the next submission against net-next, with netdev as the
main target list.


Sincerely,
Jihong Min

>> I will be more careful in the next submission and will correct this
>> there.
>>
>> Best regards,
>> Jihong
>>
>> On 5/26/26 01:24, Jihong Min wrote:
>>> FLOW_OFFLOAD_XMIT_DIRECT path discovery can stop at a LAG master because
>>> the real egress port is selected later through ndo_get_xmit_slave().
>>> Hardware flow offload drivers that program per-port redirects need the
>>> selected lower device, while software forwarding must still transmit
>>> through the LAG master.
>>>
>>> Keep the route tuple software egress ifindex on the LAG master and carry
>>> a separate hardware redirect ifindex. When the direct egress device is a
>>> LAG master, resolve the selected slave with netdev_get_xmit_slave(),
>>> verify that it belongs to the flowtable, and store it as the hardware
>>> redirect device.
>>>
>>> Signed-off-by: Jihong Min <hurryman2212@gmail.com>
>>> ---
>>>  include/net/netfilter/nf_flow_table.h |  1 +
>>>  net/netfilter/nf_flow_table_core.c    |  1 +
>>>  net/netfilter/nf_flow_table_offload.c |  2 +-
>>>  net/netfilter/nf_flow_table_path.c    | 34 ++++++++++++++++++++++++++-
>>>  4 files changed, 36 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
>>> index 7b23b245a5a8..ada9db7e5c38 100644
>>> --- a/include/net/netfilter/nf_flow_table.h
>>> +++ b/include/net/netfilter/nf_flow_table.h
>>> @@ -163,6 +163,7 @@ struct flow_offload_tuple {
>>>  		};
>>>  		struct {
>>>  			u32		ifidx;
>>> +			u32		hw_ifidx;
>>>  			u8		h_source[ETH_ALEN];
>>>  			u8		h_dest[ETH_ALEN];
>>>  		} out;
>>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>>> index 785d8c244a77..bc329420f882 100644
>>> --- a/net/netfilter/nf_flow_table_core.c
>>> +++ b/net/netfilter/nf_flow_table_core.c
>>> @@ -132,6 +132,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
>>>  		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
>>>  		       ETH_ALEN);
>>>  		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
>>> +		flow_tuple->out.hw_ifidx = route->tuple[dir].out.hw_ifindex;
>>>  		dst_release(dst);
>>>  		break;
>>>  	case FLOW_OFFLOAD_XMIT_XFRM:
>>> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
>>> index 002ec15d988b..7c46baa1546d 100644
>>> --- a/net/netfilter/nf_flow_table_offload.c
>>> +++ b/net/netfilter/nf_flow_table_offload.c
>>> @@ -596,7 +596,7 @@ static int flow_offload_redirect(struct net *net,
>>>  	switch (this_tuple->xmit_type) {
>>>  	case FLOW_OFFLOAD_XMIT_DIRECT:
>>>  		this_tuple = &flow->tuplehash[dir].tuple;
>>> -		ifindex = this_tuple->out.ifidx;
>>> +		ifindex = this_tuple->out.hw_ifidx;
>>>  		break;
>>>  	case FLOW_OFFLOAD_XMIT_NEIGH:
>>>  		other_tuple = &flow->tuplehash[!dir].tuple;
>>> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
>>> index 9e88ea6a2eef..10f38ca27a6f 100644
>>> --- a/net/netfilter/nf_flow_table_path.c
>>> +++ b/net/netfilter/nf_flow_table_path.c
>>> @@ -5,6 +5,7 @@
>>>  #include <linux/etherdevice.h>
>>>  #include <linux/netlink.h>
>>>  #include <linux/netfilter.h>
>>> +#include <linux/netdevice.h>
>>>  #include <linux/spinlock.h>
>>>  #include <linux/netfilter/nf_conntrack_common.h>
>>>  #include <linux/netfilter/nf_tables.h>
>>> @@ -76,6 +77,7 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
>>>  struct nft_forward_info {
>>>  	const struct net_device *indev;
>>>  	const struct net_device *outdev;
>>> +	const struct net_device *hw_outdev;
>>>  	struct id {
>>>  		__u16	id;
>>>  		__be16	proto;
>>> @@ -179,6 +181,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
>>>  		}
>>>  	}
>>>  	info->outdev = info->indev;
>>> +	info->hw_outdev = info->indev;
>>>  
>>>  	if (nf_flowtable_hw_offload(flowtable) &&
>>>  	    nft_is_valid_ether_device(info->indev))
>>> @@ -250,6 +253,7 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
>>>  	struct net_device_path_stack stack;
>>>  	struct nft_forward_info info = {};
>>>  	unsigned char ha[ETH_ALEN];
>>> +	struct net_device *lag_slave = NULL;
>>>  	int i;
>>>  
>>>  	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) >= 0)
>>> @@ -258,9 +262,34 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
>>>  	if (info.outdev)
>>>  		route->tuple[dir].out.ifindex = info.outdev->ifindex;
>>>  
>>> -	if (!info.indev || !nft_flowtable_find_dev(info.indev, ft))
>>> +	if (!info.indev)
>>>  		return;
>>>  
>>> +	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT &&
>>> +	    netif_is_lag_master(info.hw_outdev)) {
>>> +		rcu_read_lock();
>>> +		lag_slave = netdev_get_xmit_slave((struct net_device *)info.hw_outdev,
>>> +						  pkt->skb, false);
>>> +		if (lag_slave)
>>> +			dev_hold(lag_slave);
>>> +		rcu_read_unlock();
>>> +
>>> +		if (!lag_slave)
>>> +			return;
>>> +
>>> +		if (!nft_is_valid_ether_device(lag_slave)) {
>>> +			dev_put(lag_slave);
>>> +			return;
>>> +		}
>>> +
>>> +		info.hw_outdev = lag_slave;
>>> +	}
>>> +
>>> +	if (!nft_flowtable_find_dev(info.hw_outdev, ft)) {
>>> +		dev_put(lag_slave);
>>> +		return;
>>> +	}
>>> +
>>>  	route->tuple[!dir].in.ifindex = info.indev->ifindex;
>>>  	for (i = 0; i < info.num_encaps; i++) {
>>>  		route->tuple[!dir].in.encap[i].id = info.encap[i].id;
>>> @@ -281,9 +310,12 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
>>>  	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
>>>  		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
>>>  		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
>>> +		route->tuple[dir].out.hw_ifindex = info.hw_outdev->ifindex;
>>>  		route->tuple[dir].xmit_type = info.xmit_type;
>>>  	}
>>>  	route->tuple[dir].out.needs_gso_segment = info.needs_gso_segment;
>>> +
>>> +	dev_put(lag_slave);
>>>  }
>>>  
>>>  int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
>>

