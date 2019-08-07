Return-Path: <SRS0=iSAz=WD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174B1C31E40
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 01:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7BAE2173C
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 01:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfHGBLc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 21:11:32 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:58394 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727538AbfHGBLc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 21:11:32 -0400
Received: from [192.168.1.3] (unknown [101.93.38.113])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 57B9F416EF;
        Wed,  7 Aug 2019 09:11:29 +0800 (CST)
Subject: Re: [PATCH net-next v6 5/6] flow_offload: support get multi-subsystem
 block
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     jakub.kicinski@netronome.com, jiri@resnulli.us,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <1564925041-23530-1-git-send-email-wenxu@ucloud.cn>
 <1564925041-23530-6-git-send-email-wenxu@ucloud.cn>
 <20190806161000.3csoy3jlpq6cletq@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <c3aec20d-359e-ca54-5ab1-bb16c439feb8@ucloud.cn>
Date:   Wed, 7 Aug 2019 09:11:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190806161000.3csoy3jlpq6cletq@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEhJS0tLSkhNSExOT0hZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pi46ATo6HTgzMk0rIwEYExFJ
        PkMwCUhVSlVKTk1OSk9LSUNCQ09CVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLSlVC
        SFVIQ1VKSkhZV1kIAVlBSkNDTjcG
X-HM-Tid: 0a6c69a1881b2086kuqy57b9f416ef
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2019/8/7 0:10, Pablo Neira Ayuso 写道:
>
>>  
>> +void flow_indr_add_block_ing_cb(struct flow_indr_block_ing_entry *entry)
>> +{
> ... but registration does not protect the list with a mutex.
>
>> +	list_add_tail_rcu(&entry->list, &block_ing_cb_list);
>> +}
>> +EXPORT_SYMBOL_GPL(flow_indr_add_block_ing_cb);
yes, I think the  flow_indr_add_block_ing_cb and flow_indr_del_block_ing_cb maybe used for

more subsystem in the future. Both of them should add a mutex lock

