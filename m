Return-Path: <SRS0=EmoZ=5N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD27C2D0E7
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Mar 2020 00:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0927A2073B
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Mar 2020 00:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgC1A7c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Mar 2020 20:59:32 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:48208 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgC1A7c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Mar 2020 20:59:32 -0400
Received: from [192.168.1.5] (unknown [101.93.37.154])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id CD5E25C0F4F;
        Sat, 28 Mar 2020 08:59:27 +0800 (CST)
Subject: Re: [PATCH nf-next] netfilter: nf_flow_table_offload: fix kernel NULL
 pointer dereference in nf_flow_table_indr_block_cb
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1584528755-7969-1-git-send-email-wenxu@ucloud.cn>
 <ac599530-96aa-f562-87fb-3b5e24b7cb9e@ucloud.cn>
 <20200320125444.lo4xieofbqyobsqb@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <4546a3af-1bf3-12b8-7bef-4396ef08b0e8@ucloud.cn>
Date:   Sat, 28 Mar 2020 08:58:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200320125444.lo4xieofbqyobsqb@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQk9LS0tLSkxNT0lCTE5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mxg6UQw5Ezg2KBAtOE8vHjA5
        FhwKFBFVSlVKTkNOSE5MSk1MQk1MVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLSlVC
        SFVITFVKTk9ZV1kIAVlBSkxKTTcG
X-HM-Tid: 0a711ea69d1f2087kuqycd5e25c0f4f
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,


How about this crash fix?


BR

wenxu

在 2020/3/20 20:54, Pablo Neira Ayuso 写道:
> On Fri, Mar 20, 2020 at 08:42:37PM +0800, wenxu wrote:
>> Hi Pablo,
>>
>>
>> How about this bugfix?   I see the status of this patch is accepted.
>>
>> But it didn't apply to the master?
> My mistake: back to "Under review" state.
>
