Return-Path: <SRS0=w/jS=XG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB74C49ED9
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Sep 2019 00:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2871D2171F
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Sep 2019 00:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfIKACy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Sep 2019 20:02:54 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:4312 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfIKACy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 20:02:54 -0400
Received: from [192.168.1.4] (unknown [116.234.3.9])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 7242541180;
        Wed, 11 Sep 2019 08:02:51 +0800 (CST)
Subject: Re: [PATCH nf-next v5 0/4] netfilter: nf_tables_offload: clean
 offload things when the device unregister
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1568010126-3173-1-git-send-email-wenxu@ucloud.cn>
 <20190910200206.t222zrsvfakrpi6t@salvia>
 <20190910203415.2jb7c437kk3wxq5e@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <a7420f29-9c21-a899-4c8d-66c3b71defca@ucloud.cn>
Date:   Wed, 11 Sep 2019 08:02:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190910203415.2jb7c437kk3wxq5e@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVTENKS0tLS0pDSkpCQ0pZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OAg6USo4DjgrHzQTEDo2Kx8d
        Mj8wCTdVSlVKTk1DSk1LSkxKTkxCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SE9VSFVCWVdZCAFZQUlKSEI3Bg++
X-HM-Tid: 0a6d1da146082086kuqy7242541180
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2019/9/11 4:34, Pablo Neira Ayuso 写道:
> On Tue, Sep 10, 2019 at 10:02:06PM +0200, Pablo Neira Ayuso wrote:
>> On Mon, Sep 09, 2019 at 02:22:02PM +0800, wenxu@ucloud.cn wrote:
>>> From: wenxu <wenxu@ucloud.cn>
>>>
>>> This series clean the offload things for both chain and rules when the
>>> related device unregister
>>>
>>> This version just rebase the master and make __nft_offload_get_chain
>>> fixes mutex and offload flag problem
>> applied.
> Sorry, I have to keep this back, compilation breaks if I remove patch
> 3/4 and 4/4. It would be good not to add new code that goes over the
> 80-chars per column boundary.


The orignal nft_flow_offload_rule and nft_flow_offload_chain used struct nft_ctx, but

in the device event notify there is no nft_ctx. that's why I need the 2/4 and 3/4 patches.

Any suggestion?

>
