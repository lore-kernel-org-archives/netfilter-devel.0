Return-Path: <SRS0=A3Nh=UF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF56C28EB3
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 09:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C1FE2064A
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 09:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfFFJuX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jun 2019 05:50:23 -0400
Received: from m97188.mail.qiye.163.com ([220.181.97.188]:1234 "EHLO
        m97188.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbfFFJuX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 05:50:23 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m97188.mail.qiye.163.com (Hmail) with ESMTPA id CDC0A967866;
        Thu,  6 Jun 2019 17:50:20 +0800 (CST)
Subject: Re: [PATCH net-next v2] netfilter: ipv6: Fix undefined symbol
 nf_ct_frag6_gather
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1559483366-12371-1-git-send-email-wenxu@ucloud.cn>
 <20190603092128.47omjnvbqxzealst@salvia>
 <20190603141357.3pf6y55sf3elw654@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <d44e125a-0328-3130-1ae2-a575ebad9de4@ucloud.cn>
Date:   Thu, 6 Jun 2019 17:50:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190603141357.3pf6y55sf3elw654@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kIGBQJHllBWVZKVUhMQ0tLS0pPS0pCS0pJWVdZKFlBSUI3V1ktWUFJV1
        kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PzI6Tzo4Ejg8OhhNTkoPFSwU
        AUgaCQtVSlVKTk5CQ0pPTUlLQkxDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUtDTjcG
X-HM-Tid: 0a6b2c3246f520bckuqycdc0a967866
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,


Are there any idea for this patch?


BR

wenxu

On 6/3/2019 10:13 PM, Pablo Neira Ayuso wrote:
> On Mon, Jun 03, 2019 at 11:21:28AM +0200, Pablo Neira Ayuso wrote:
>> On Sun, Jun 02, 2019 at 09:49:26PM +0800, wenxu@ucloud.cn wrote:
>>> From: wenxu <wenxu@ucloud.cn>
>>>
>>> CONFIG_NETFILTER=m and CONFIG_NF_DEFRAG_IPV6 is not set
> Just noted that this should be:
>
> CONFIG_IPV6=m
>
>>> ERROR: "nf_ct_frag6_gather" [net/ipv6/ipv6.ko] undefined!
>>>
>>> Fixes: c9bb6165a16e ("netfilter: nf_conntrack_bridge: fix CONFIG_IPV6=y")
>>> Reported-by: kbuild test robot <lkp@intel.com>
>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> nf-next is already in sync with net-next, so I can apply this patch
> here, as an alternative path.
>
