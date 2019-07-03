Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40334C0650E
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 15:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1498620828
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 15:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfGCPAx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 11:00:53 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:38378 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCPAx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 11:00:53 -0400
Received: from [192.168.1.5] (unknown [116.234.0.230])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A7FB24186E;
        Wed,  3 Jul 2019 22:59:58 +0800 (CST)
Subject: Re: [PATCH] netfilter: nft_meta: fix bridge port vlan ID selector
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, nikolay@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
References: <20190703124040.19279-1-pablo@netfilter.org>
 <ecb6d9e8-7923-07ba-8940-c69fc251f4c3@ucloud.cn>
 <20190703141507.mnhzqapu4iaan5d7@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <4f3561be-adec-bda4-0e4f-d23ed82acf0f@ucloud.cn>
Date:   Wed, 3 Jul 2019 22:59:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190703141507.mnhzqapu4iaan5d7@salvia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVT0xCS0tLS0JKTk5JTEhZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ok06Iio4Ezg3GAlDNzc#LSwN
        IywaCiJVSlVKTk1JSk1OQkJDQk1CVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SE9VS1VJSEtZV1kIAVlBSUpMTzcG
X-HM-Tid: 0a6bb859752e2086kuqya7fb24186e
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Agree with you, After add the rcu patch I will resent the series fo nft_meta_bridge!.

在 2019/7/3 22:15, Pablo Neira Ayuso 写道:
> Hi,
>
> I'm planning to revert from nf-next
>
>         da4f10a4265b netfilter: nft_meta: add NFT_META_BRI_PVID support
>
> because:
>
> * Nikolay wants us to use the helpers, however, through the existing
>   approach this creates a dependency between nft_meta and the bridge
>   module. I think I suggested this already, but it seems there is a
>   need for nft_meta_bridge, otherwise nft_meta pulls in the bridge
>   modules as a dependency.
>
> * NFT_META_BRI_PVID needs to be rename to NFT_META_BRI_IIFPVID.
>
> * We need new helpers to access this information from rcu path, I'm
>   attaching a patch for such helper for review.
>
> so we take the time to get this right :-)
