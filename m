Return-Path: <SRS0=QRwA=YQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B7BCA9EB6
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 14:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EF6221906
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 14:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406165AbfJWOBY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 10:01:24 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:30588 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfJWOBY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 10:01:24 -0400
Received: from [192.168.1.6] (unknown [180.157.106.45])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 8CA9641602;
        Wed, 23 Oct 2019 22:01:17 +0800 (CST)
Subject: Re: [PATCH nf-next,RFC 0/2] nf_tables encapsulation/decapsulation
 support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20191022154733.8789-1-pablo@netfilter.org>
 <10ad5a64-f9cb-0ee6-2daa-5b88884fd224@ucloud.cn>
 <20191023101658.onmzadkop7vqfrgj@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <6406c9c8-6f02-d639-6cb7-839b7c3eb996@ucloud.cn>
Date:   Wed, 23 Oct 2019 22:00:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191023101658.onmzadkop7vqfrgj@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUtJS0tLSU1LSE5IS0JZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBg6GCo4Gjg0Ex8ITT8tTgkr
        TAxPCz9VSlVKTkxKQ0hCSUxMTEhMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpDS1VK
        TkxVSktNVU9OWVdZCAFZQUlJTEk3Bg++
X-HM-Tid: 0a6df8ebfa6b2086kuqy8ca9641602
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2019/10/23 18:16, Pablo Neira Ayuso 写道:

>>> 2) VLAN encapsulation:
>>>
>>> 	add vlan "network0" { type push; id 100; proto 0x8100; }
>>>         add vlan "network1" { type update; id 101; }
>>> 	... encap vlan set ip daddr map { 192.168.0.0/24 : "network0",
>>> 					  192.168.1.0/24 : "network1" }
>>>
>>> The idea is that the user specifies the vlan policy through object
>>> definition, eg. "network0" and "network1", then it applies this policy
>>> via the "encap vlan set" statement.
>>>
>>> This infrastructure should allow for more encapsulation protocols
>>> with little work, eg. MPLS.
>> So the tunnel already exist in nft_tunnel also can add in this encapsulation protocols
>> as ip.
>>
>> like ip-route
>>
>> encap ip id 100 dst 10.0.0.1?
> Not sure what you mean, please, extend your coment.

For the future there maybe can add a new nft_encap_type NFT_ENCAP_IP which contain all

the ip tunnels such as vxlan, gre etc. This type of encap already in the nft_tunnel.

>
