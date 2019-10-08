Return-Path: <SRS0=bnKo=YB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34136C4360C
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 05:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B85F2067B
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 05:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbfJHFlb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Oct 2019 01:41:31 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:34932 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729568AbfJHFlb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Oct 2019 01:41:31 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id D4603417B0;
        Tue,  8 Oct 2019 13:41:27 +0800 (CST)
Subject: Re: [PATCH nf-next v6 0/8] netfilter: nf_tables_offload: support
 tunnel offload
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1568386990-29660-1-git-send-email-wenxu@ucloud.cn>
 <ff59a395-b823-6e49-8241-8f2841523a87@ucloud.cn>
 <20190919091503.v4tfdmk7av2g2q3o@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <4dca30fc-6948-0cdd-1c88-4f62c5202dd6@ucloud.cn>
Date:   Tue, 8 Oct 2019 13:41:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190919091503.v4tfdmk7av2g2q3o@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkhNQkJCQk1PTEpPS05ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MQg6CCo*FTgzLSwUNCMeMz0h
        ClYaCgJVSlVKTkxLTkpISUNDS0tMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSk1JTzcG
X-HM-Tid: 0a6da9e2fb122086kuqyd4603417b0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 9/19/2019 5:15 PM, Pablo Neira Ayuso wrote:
> On Wed, Sep 18, 2019 at 04:02:51PM +0800, wenxu wrote:
>> Hi pablo,
>>
>> Any comments for this series?
> Merge window is closed since Sunday. Last pull request was sent last
> friday. Will get back to this one merge window reopens. Sorry.
Pablo,  any comments for this one?  Thx.
>
