Return-Path: <SRS0=7PQj=WB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F39C433FF
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Aug 2019 06:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 773B42182B
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Aug 2019 06:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfHEG0i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Aug 2019 02:26:38 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:59137 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbfHEG0i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Aug 2019 02:26:38 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id DD6A6419F1;
        Mon,  5 Aug 2019 14:26:33 +0800 (CST)
Subject: Re: [PATCH net-next 3/6] cls_api: add flow_indr_block_call function
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     pablo@netfilter.org, fw@strlen.de, jakub.kicinski@netronome.com,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
 <1564628627-10021-4-git-send-email-wenxu@ucloud.cn>
 <20190805060238.GB2349@nanopsycho.orion>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <28de8cda-6264-0440-ad96-dcc1f607fce2@ucloud.cn>
Date:   Mon, 5 Aug 2019 14:26:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805060238.GB2349@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUhIS0tLSk5CSU1ITUpZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OT46Myo5CDg0Kk4MFBEPTDEQ
        EwgaCRlVSlVKTk1PQkNNSEJPSUNDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSkxCSTcG
X-HM-Tid: 0a6c6075466b2086kuqydd6a6419f1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

v5 contain this patch but with non-version tag,

I used --subject-prefix in git-format-patch. I am sorry to  make a mistake when modify the

commit log. So should I repost the v6?


On 8/5/2019 2:02 PM, Jiri Pirko wrote:
> Re subject. You don't have "v5" in this patch. I don't understand how
> that happened. Do you use --subject-prefix in git-format-patch?
>
