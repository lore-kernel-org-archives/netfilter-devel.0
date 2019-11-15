Return-Path: <SRS0=hXfx=ZH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33ECC432C3
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 11:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78DFA2072D
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 11:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfKOLkU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Nov 2019 06:40:20 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:64768 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfKOLkU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 06:40:20 -0500
Received: from [192.168.1.4] (unknown [116.234.5.178])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 4E15F5C1B89;
        Fri, 15 Nov 2019 19:39:25 +0800 (CST)
Subject: Re: [PATCH nf-next] netfilter: nf_tables: check the bind callback
 failed and unbind callback if hook register failed
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1573816886-2743-1-git-send-email-wenxu@ucloud.cn>
 <20191115112501.6xb5adufqxlb6vnu@salvia>
 <20191115112752.fqz7h7llwwfllkwy@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <2e89cd2a-3768-357c-0be4-24e20923c17b@ucloud.cn>
Date:   Fri, 15 Nov 2019 19:39:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191115112752.fqz7h7llwwfllkwy@salvia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVktVQ09LS0tLSUxKTEJMSkNZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MD46Nio4Kzg6CwpWMxI5TiMs
        NzoaCRVVSlVKTkxIQ0pMQk1OTUNNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SE9VTlVKTENZV1kIAVlBSUtDSjcG
X-HM-Tid: 0a6e6edc5b492087kuqy4e15f5c1b89
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2019/11/15 19:27, Pablo Neira Ayuso 写道:
> On Fri, Nov 15, 2019 at 12:25:01PM +0100, Pablo Neira Ayuso wrote:
>> On Fri, Nov 15, 2019 at 07:21:26PM +0800, wenxu@ucloud.cn wrote:
>>> From: wenxu <wenxu@ucloud.cn>
>>>
>>> Undo the callback binding before unregistering the existing hooks. It also
>>> should check err of the bind setup call
>>>
>>> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>>> ---
>>> This patch is based on:
>>> http://patchwork.ozlabs.org/patch/1195539/
>> This is actually like this one:
>>
>> https://patchwork.ozlabs.org/patch/1194046/
>>
>> right?
> I'm attaching the one I made based on yours that I posted yesterday.
yes it is include this one.
