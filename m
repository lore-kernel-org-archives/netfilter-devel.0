Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC93C2D0CE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 13:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90488206DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 13:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfL3N1q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 08:27:46 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:35048 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbfL3N1q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 08:27:46 -0500
Received: from [192.168.1.8] (unknown [116.226.202.48])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 21757418E9;
        Mon, 30 Dec 2019 21:27:38 +0800 (CST)
Subject: Re: [PATCH nf v3 0/3] netfilter: nf_flow_table_offload: something
 fixes
From:   wenxu <wenxu@ucloud.cn>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
References: <1576815278-1283-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <515b1bd5-eb59-559d-039e-c354e523042b@ucloud.cn>
Date:   Mon, 30 Dec 2019 21:27:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1576815278-1283-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVT0hLS0tLSEtOSkxOTENZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MxQ6NTo*KDg9LDlLPBUqDjxI
        Di5PCRVVSlVKTkxMTEpJT05DT0hLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SU1VSUtJVU9DWVdZCAFZQUpNSEs3Bg++
X-HM-Tid: 0a6f56fd9a682086kuqy21757418e9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi pablo,


Any idea for this series?


BR

wenxu

ÔÚ 2019/12/20 12:14, wenxu@ucloud.cn Ð´µÀ:
> From: wenxu <wenxu@ucloud.cn>
>
> This version just modify the description of  patch 1 and 3
>
> wenxu (3):
>    netfilter: nf_flow_table_offload: fix incorrect ethernet dst address
>    netfilter: nf_flow_table_offload: check the status of dst_neigh
>    netfilter: nf_flow_table_offload: fix the nat port mangle.
>
>   net/netfilter/nf_flow_table_offload.c | 46 ++++++++++++++++++++++++++---------
>   1 file changed, 34 insertions(+), 12 deletions(-)
>
