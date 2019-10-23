Return-Path: <SRS0=QRwA=YQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E10B0CA9EB6
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 14:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B591F2086D
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 14:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390045AbfJWOpy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 10:45:54 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:9677 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389989AbfJWOpy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 10:45:54 -0400
Received: from [192.168.1.6] (unknown [180.157.106.45])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 4A915416E1;
        Wed, 23 Oct 2019 22:45:50 +0800 (CST)
Subject: Re: [PATCH nf-next,RFC 0/2] nf_tables encapsulation/decapsulation
 support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20191022154733.8789-1-pablo@netfilter.org>
 <10ad5a64-f9cb-0ee6-2daa-5b88884fd224@ucloud.cn>
 <20191023101658.onmzadkop7vqfrgj@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <6b37142f-c59e-90c2-4c86-6f4740abe071@ucloud.cn>
Date:   Wed, 23 Oct 2019 22:45:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191023101658.onmzadkop7vqfrgj@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJMS0tLSU1OSklKT01ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mk06Mgw6Czg5MR8MCDA9Vjoz
        TEMwChxVSlVKTkxKQ09KQk5LT0xKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpDS1VK
        TkxVSktNVU9OWVdZCAFZQUlJSE43Bg++
X-HM-Tid: 0a6df914c2d42086kuqy4a915416e1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2019/10/23 18:16, Pablo Neira Ayuso 写道:
> On Wed, Oct 23, 2019 at 11:49:57AM +0800, wenxu wrote:
>> On 10/22/2019 11:47 PM, Pablo Neira Ayuso wrote:
>>> Hi,
>>>
>>> This is a RFC patchset, untested, to introduce new infrastructure to
>>> specify protocol decapsulation and encapsulation actions. This patchset
>>> comes with initial support for VLAN, eg.
>>>
>>> 1) VLAN decapsulation:
>>>
>>> 	... meta iif . vlan id { eth0 . 10, eth1 . 11} decap vlan
>>>
>>> The decapsulation is a single statement with no extra options.
>> Currently there is no vlan meta match expr.  So it is better to
>> extend the meta expr or add new ntf_vlan_get_expr?
> There's nft_payload to get the vlan information.
>
There are some limtaion for geting the vlan information through nft_payload

1. It can't get the inner vlan(cvlan) information

2. geting the vlan information is based on offset on link header, There is no good way

to offload the vlan match expr.

