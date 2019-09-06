Return-Path: <SRS0=fPey=XB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9111DC43331
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Sep 2019 03:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96A75206DE
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Sep 2019 03:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732303AbfIFDPI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:15:08 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:27141 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731938AbfIFDPH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Sep 2019 23:15:07 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Sep 2019 23:15:06 EDT
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 5FB375C18D0;
        Fri,  6 Sep 2019 11:09:50 +0800 (CST)
Subject: Re: [PATCH nf-next v3 0/4] netfilter: nf_tables_offload: clean
 offload things when the device unregister
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1567656019-6881-1-git-send-email-wenxu@ucloud.cn>
 <20190906002754.34ge3qjx3qtu7ao5@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <b2a6f0fb-1155-2384-c880-a7d9ce08bc4f@ucloud.cn>
Date:   Fri, 6 Sep 2019 11:09:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190906002754.34ge3qjx3qtu7ao5@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEJKS0tLSk5KTUhPSUlZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6ODo6MBw5GTg*EzcJHxQhHx8J
        MQ4aCjRVSlVKTk1MTEhCSEJLTkpKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUtDSDcG
X-HM-Tid: 0a6d048ca9fb2087kuqy5fb375c18d0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 9/6/2019 8:27 AM, Pablo Neira Ayuso wrote:
> On Thu, Sep 05, 2019 at 12:00:15PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> This series clean the offload things for both chain and rules when the
>> related device unregister
>>
>> This version add a nft_offload_netdev_iterate common function
>>
>> wenxu (4):
>>   netfilter: nf_tables_offload: refactor the nft_flow_offload_chain
>>     function
>>   netfilter: nf_tables_offload: refactor the nft_flow_offload_rule
>>     function
> 1/4 and 2/4 are not required anymore after adding the registration
> logic to nf_tables_offload.

Maybe it also need the 1/4 and 2/4 patches.  The nft_flow_offload_chain/rule need

get some inform from the nft_trans. There is no this struct in the netdev notify event,.

So it better to refactor it more common?


>
