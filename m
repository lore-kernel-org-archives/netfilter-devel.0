Return-Path: <SRS0=D85U=VG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DE3C606CF
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 02:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CC6421537
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 02:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfGIC4J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 22:56:09 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:26956 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfGIC4J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 22:56:09 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id AA198415E4;
        Tue,  9 Jul 2019 10:56:06 +0800 (CST)
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_nat_proto: add
 nf_nat_bridge_ops support
To:     Florian Westphal <fw@strlen.de>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1562574567-8293-1-git-send-email-wenxu@ucloud.cn>
 <20190708141730.ozycgmtrub7ok2qs@breakpoint.cc>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <0a4cf910-6c87-34b6-3018-3e25f6fecdce@ucloud.cn>
Date:   Tue, 9 Jul 2019 10:56:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190708141730.ozycgmtrub7ok2qs@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEtMS0tLS09KS0tDWVdZKFlBSU
        I3V1ktWUFJV1kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kz46LQw4FzgzKg48HjhCAzAL
        GiMaCU5VSlVKTk1JTU9LQk1NQklJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSU1LTTcG
X-HM-Tid: 0a6bd4a8e4ae2086kuqyaa198415e4
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 7/8/2019 10:17 PM, Florian Westphal wrote:
> wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> Add nf_nat_bridge_ops to do nat in the bridge family
> Whats the use case for this?
>
> The reason I'm asking is that a bridge doesn't know about IP,
> Bridge netfilter (the call-iptables thing) has a lot of glue code
> to detect dnat rewrites and updates target mac address, including
> support for redirect (suddently packet has to be pushed up the stack)
> or changes in the oif to non-bridge ports (it even checks forward sysctl
> state ..) and so on.
>
> Thats something that I don't want to support in nftables.
>
> For NAT on bridge, it should be possible already to push such packets
> up the stack by
>
> bridge input meta iif eth0 ip saddr 192.168.0.0/16 \
>        meta pkttype set unicast ether daddr set 00:11:22:33:44:55

yes, packet can be push up to IP stack to handle the nat through bridge device. 


In my case dnat 2.2.1.7 to 10.0.0.7, It assume the mac address of the two address

is the same known by outer. So The bridge can just do nat( without modify mac address or oif).

But in This case modify the packet dmac to bridge device, the packet push up through bridge device

Then do nat and route send back to bridge device.








