Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486341B85C2;
	Mon, 14 Oct 2024 18:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728930555; cv=none; b=L1WdtWq3uBHvhcQVS4e3io5vYP/wXaWnswa3mH5EeNtTiF/D7kpP0sYwZyZGLH3wbz826UBXxibPCVEmazLqa+YdZzCDRjzRnF33OmoKSVBmYilKzaELhU/xHR0AXQ3KqYbiXtc1buJktZU3IGvTqdWpyrfFhbWCEdFHugGLX1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728930555; c=relaxed/simple;
	bh=YdSNSZiYhLJAGb49SZ1o5DnuzbdzPsZNyJNQt7oBen0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gU7pzYaDNISMgdfq8i5ssQhhceHs4+nBQdBH8ezm40X2S3ewi1I81rPkk4rypV56/udqU2hPad4d6x+3dVb//VXVJ6XCgtiGga/LVKCpotHPvWBlt9ZaYD5FI3KkzSNLpe2aLSBQgReBvKkUAxCyy7ksXLMxKZdn2ZWuBEq6eA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fy7774lI; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fy7774lI"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a9a01810fffso247491166b.3;
        Mon, 14 Oct 2024 11:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728930552; x=1729535352; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D81y7fKwRxdQsGqZVOlIH9RZC5XB7EL1pIKoTfjy1Kg=;
        b=Fy7774lIWiAHMFFejMS74DU2LtY65f/Q/snpqQN4GdRFTmpSvfC89lWYLvHx5/iCbi
         q6hfuAXLJVGk6DK4u8QYXWwE8ooo4PMgBeM2B4BBE2WV2n0xg8KsFHNN881CQWbMWi6/
         S34usH+1roJZlHgUyUjFcgQJ6CjjQgiKd4dMq1ZPewtluG4RmUQk/rKeFm8AA4q0nGzT
         wcpyRhOFyZTcJYV+wG2kI4/iMmdJrZ8CvtqegDtSZ98s8TEIMO4igwFqOc1GXAQ6kEX3
         EBGJXgc4FGOblXmyvZcsWmeQrpHPzVfcNxMeVSmOeMGFUuL+lqpAmuOmYx7vH96tyIPN
         NOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728930552; x=1729535352;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D81y7fKwRxdQsGqZVOlIH9RZC5XB7EL1pIKoTfjy1Kg=;
        b=m4RlBR8QXJS+KIk5jkdyzZmQEJH75wtWvvgLlx7riblW6OfGIqb/vXQWRg8VDjYB32
         i3+9zuXwb7IAWgT9LPk7gS3Tx14kMnTB+1IsrBxmNMQNDQJ1p9aXDvKnl0ODQVkZLGtc
         3Rlt1NxbmYqrqez4y2yOy06iWOE23X47eSEs09LkYhn2200QgT2OeIFBUTaKklXjTrIy
         SNjecQvqIv+opUE1T+5XccDtcTUldSNjfeMr1apeU278sJAFI7NGk7pVfjr0EIOPtg6R
         5KU19fl6qFEw0IGsj0QUOuHOQZJGtmMJdwiLPYht8pDMzUcVVQ7lzHmMsASRxVMMoBdq
         c1DA==
X-Forwarded-Encrypted: i=1; AJvYcCUtG7Z8m5wOwRuHJYJPpbYA7KEPWBfBWA+GhqaMYNtvzJ+Y5URL4VJ3TYfMN9Wa+2yEnPWY7AGQHfR4gq6WRX/1@vger.kernel.org, AJvYcCVm3GVa8r0kKzu3TqgWPepiFcvyUc5OG9VAUP/kYi6JJQhLtfIgghCD1Bx8libfB3fdtpbNaXzqftGlBeg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBDxdMuLW0P4qprjtq61aKTFVnHEGaaBxLyUvOA3vTm0BDMUDP
	6TL5WeVqnN/3Ae5VrD0nfJtnnMD3/PfbMceURSlE117HUVGfX/TJOCnPomR2
X-Google-Smtp-Source: AGHT+IG2fUbfuh5wkGWZbcGbeW+oiKoSliAYbpoN9TVWJ2yiOiQqFWSM3p/oEnVvn3XUKpbClxQrlw==
X-Received: by 2002:a17:907:f70a:b0:a99:40e6:157c with SMTP id a640c23a62f3a-a99e39e5061mr856384766b.4.1728930551244;
        Mon, 14 Oct 2024 11:29:11 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a06169946sm247327066b.204.2024.10.14.11.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2024 11:29:10 -0700 (PDT)
Message-ID: <a07cadd3-a8ff-4d1c-9dca-27a5dba907c3@gmail.com>
Date: Mon, 14 Oct 2024 20:29:09 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 net-next 00/12] bridge-fastpath and related
 improvements
To: Nikolay Aleksandrov <razor@blackwall.org>,
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
 Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 bridge@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20241013185509.4430-1-ericwouds@gmail.com>
 <9f9f3cf0-7a78-40f1-b8d5-f06a2d428210@blackwall.org>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <9f9f3cf0-7a78-40f1-b8d5-f06a2d428210@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/14/24 8:35 AM, Nikolay Aleksandrov wrote:
> On 13/10/2024 21:54, Eric Woudstra wrote:
>> This patchset makes it possible to set up a (hardware offloaded) fastpath
>> for bridged interfaces.
>>
> 
> The subject and this sentence are misleading, you're talking about netfilter bridge
> fastpath offload, please mention it in both places. When you just say bridge fast
> path, I think of the software fast path.
> 

Hello Nikolay,

It would be no problem for me to change the subject and body, if you
think that is better.

The thing is, these patches actually make it possible to set up a fully
functional software fastpath between bridged interfaces. Only after the
software fastpath is set up and functional, it can be offloaded, which
happens to by my personal motivation to write this patch-set.

If the offload flag is set in the flowtable, the software fastpath will
be offloaded. But in this patch-set, there is nothing that changes
anything there, the existing code is used unchanged.

>> To set up the fastpath with offloading, add this extra flowtable:
>>
>> table bridge filter {
>>         flowtable fb {
>>                 hook ingress priority filter
>>                 devices = { lan0, lan1, lan2, lan3, lan4, wlan0, wlan1 }
>>                 flags offload
>>         }
>>         chain forward {
>>                 type filter hook forward priority filter; policy accept;
>> 		ct state established flow add @fb
>>         }
>> }
>>
>> Creating a separate fastpath for bridges.
>>
>>          forward fastpath bypass
>>  .----------------------------------------.
>> /                                          \
>> |                        IP - forwarding    |
>> |                       /                \  v
>> |                      /                  wan ...
>> |                     /
>> |                     |
>> |                     |
>> |                   brlan.1
>> |                     |
>> |    +-------------------------------+
>> |    |           vlan 1              |
>> |    |                               |
>> |    |     brlan (vlan-filtering)    |
>> |    +---------------+               |
>> |    |  DSA-SWITCH   |               |
>> |    |               |    vlan 1     |
>> |    |               |      to       |
>> |    |   vlan 1      |   untagged    |
>> |    +---------------+---------------+
>> .         /                   \
>>  ------>lan0                 wlan1
>>         .  ^                 ^
>>         .  |                 |
>>         .  \_________________/
>>         .  bridge fastpath bypass
>>         .
>>         ^
>>      vlan 1 tagged packets
>>
>> To have the ability to handle xmit direct with outgoing encaps in the
>> bridge fastpass bypass, we need to be able to handle them without going
>> through vlan/pppoe devices. So I've applied, amended and squashed wenxu's
>> patchset. This patch also makes it possible to egress from vlan-filtering
>> brlan to lan0 with vlan tagged packets, if the bridge master port is doing
>> the vlan tagging, instead of the vlan-device. Without this patch, this is
>> not possible in the bridge-fastpath and also not in the forward-fastpath,
>> as seen in the figure above.
>>
>> There are also some more fixes for filling in the forward path. These
>> fixes also apply to for the forward-fastpath. They include handling
>> DEV_PATH_MTK_WDMA in nft_dev_path_info() and avoiding
>> DEV_PATH_BR_VLAN_UNTAG_HW for bridges with ports that use dsa.
>>
>> Conntrack bridge only tracks untagged and 802.1q. To make the bridge
>> fastpath experience more similar to the forward fastpath experience,
>> I've added double vlan, pppoe and pppoe-in-q tagged packets to bridge
>> conntrack and to bridge filter chain.
>>
>> Eric Woudstra (12):
>>   netfilter: nf_flow_table_offload: Add nf_flow_encap_push() for xmit
>>     direct
>>   netfilter: bridge: Add conntrack double vlan and pppoe
>>   netfilter: nft_chain_filter: Add bridge double vlan and pppoe
>>   bridge: br_vlan_fill_forward_path_pvid: Add port to port
>>   bridge: br_fill_forward_path add port to port
>>   net: core: dev: Add dev_fill_bridge_path()
>>   netfilter :nf_flow_table_offload: Add nf_flow_rule_bridge()
>>   netfilter: nf_flow_table_inet: Add nf_flowtable_type flowtable_bridge
>>   netfilter: nft_flow_offload: Add NFPROTO_BRIDGE to validate
>>   netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to
>>     nft_dev_path_info()
>>   bridge: br_vlan_fill_forward_path_mode no _UNTAG_HW for dsa
>>   netfilter: nft_flow_offload: Add bridgeflow to nft_flow_offload_eval()
>>
>>  include/linux/netdevice.h                  |   2 +
>>  include/net/netfilter/nf_flow_table.h      |   3 +
>>  net/bridge/br_device.c                     |  20 ++-
>>  net/bridge/br_private.h                    |   2 +
>>  net/bridge/br_vlan.c                       |  24 +++-
>>  net/bridge/netfilter/nf_conntrack_bridge.c |  86 ++++++++++--
>>  net/core/dev.c                             |  77 +++++++++--
>>  net/netfilter/nf_flow_table_inet.c         |  13 ++
>>  net/netfilter/nf_flow_table_ip.c           |  96 ++++++++++++-
>>  net/netfilter/nf_flow_table_offload.c      |  13 ++
>>  net/netfilter/nft_chain_filter.c           |  20 ++-
>>  net/netfilter/nft_flow_offload.c           | 154 +++++++++++++++++++--
>>  12 files changed, 463 insertions(+), 47 deletions(-)
>>
> 
