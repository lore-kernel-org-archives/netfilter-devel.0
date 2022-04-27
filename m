Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF628C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Apr 2022 16:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242895AbiD0Qec (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 12:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243168AbiD0Qdz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 12:33:55 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F7225A15B
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 09:30:33 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.218:57790.29048770
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-101.229.163.22 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 84D802800B1;
        Thu, 28 Apr 2022 00:30:24 +0800 (CST)
X-189-SAVE-TO-SEND: wenxu@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 67ebe97e88784fe7828638a70c8c1286 for pablo@netfilter.org;
        Thu, 28 Apr 2022 00:30:25 CST
X-Transaction-ID: 67ebe97e88784fe7828638a70c8c1286
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
Message-ID: <63fdb211-60f9-9d16-44c2-b65a0921b8f8@chinatelecom.cn>
Date:   Thu, 28 Apr 2022 00:30:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH nf-next] nf_flow_table_offload: offload the vlan encap in
 the flowtable
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1649169515-4337-1-git-send-email-wenx05124561@163.com>
 <YmlO009uqhJNnBq7@salvia>
 <42afa9bb-e265-33e7-c0dc-75d40689ade1@chinatelecom.cn>
 <YmlnaJ2ELDhALNz8@salvia>
From:   wenxu <wenxu@chinatelecom.cn>
In-Reply-To: <YmlnaJ2ELDhALNz8@salvia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 2022/4/27 23:55, Pablo Neira Ayuso wrote:
> On Wed, Apr 27, 2022 at 11:28:16PM +0800, wenxu wrote:
>> On 2022/4/27 22:10, Pablo Neira Ayuso wrote:
>>> On Tue, Apr 05, 2022 at 10:38:35AM -0400, wenx05124561@163.com wrote:
>>>> From: wenxu <wenxu@chinatelecom.cn>
>>>>
>>>> This patch put the vlan dev process in the FLOW_OFFLOAD_XMIT_DIRECT
>>>> mode. Xmit the packet with vlan can offload to the real dev directly.
>>>>
>>>> It can support all kinds of VLAN dev path:
>>>> br0.100-->br0(vlan filter enable)-->eth
>>>> br0(vlan filter enable)-->eth
>>>> br0(vlan filter disable)-->eth.100-->eth
>>> I assume this eth is a bridge port.
>> Yes it is. And it also can support the case without bridge as following.
>>
>> eth.100-->eth.
>>
>>>> The packet xmit and recv offload to the 'eth' in both original and
>>>> reply direction.
>>> This is an enhancement or fix?
>> It's an enhancement and  it make the vlan packet can offload through the real dev.
> What's the benefit from the existing approach?

For the simplest case

eth.100 base on eth


eth.100  and ethx are route interface.

Without this patch.

The packet outgoing path from eth   --- >  ethx

The packet incoming path from ethx ---->  eth.100---> eth

 With this patch

The packet incoming path from ethx   (direct to)---> eth, it is the same with outgoing.

>
>>> Is this going to work for VLAN + PPP?
>>>
>>> Would you update tools/testing/selftests/netfilter/nft_flowtable.sh to
>>> cover bridge filtering usecase? It could be done in a follow up patch.
>> I will do for both  if this patch reivew ok .
> OK.
