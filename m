Return-Path: <SRS0=Edk1=AR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8022C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jul 2020 15:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C299D20724
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jul 2020 15:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgGFPR1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jul 2020 11:17:27 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:7047 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbgGFPRZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jul 2020 11:17:25 -0400
X-Greylist: delayed 528 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2020 11:17:18 EDT
Received: from [192.168.1.8] (unknown [116.237.151.97])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 055425C11D3;
        Mon,  6 Jul 2020 23:08:26 +0800 (CST)
Subject: Re: [PATCH net-next 1/3] netfilter: nf_defrag_ipv4: Add
 nf_ct_frag_gather support
To:     Florian Westphal <fw@strlen.de>
Cc:     davem@davemloft.net, pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
References: <1593959312-6135-1-git-send-email-wenxu@ucloud.cn>
 <1593959312-6135-2-git-send-email-wenxu@ucloud.cn>
 <20200706143826.GA32005@breakpoint.cc>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <06700aee-f62f-7b83-de21-4f5b4928978e@ucloud.cn>
Date:   Mon, 6 Jul 2020 23:08:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200706143826.GA32005@breakpoint.cc>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVTUJJS0tLSU1CQ0NCQ0hZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXMjULOBw4Mz8RDworHDUdMRBMNDocVlZVSE5MKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OVE6Nww4FD5WHk0aGSkoLRQs
        LkMaCzVVSlVKTkJPS09DSktMSENNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SExVSk5KVUJMWVdZCAFZQUlLQ0w3Bg++
X-HM-Tid: 0a7324abd3292087kuqy055425c11d3
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


ÔÚ 2020/7/6 22:38, Florian Westphal Ð´µÀ:
> wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> Add nf_ct_frag_gather for conntrack defrag and it will
>> elide the CB clear when packets are defragmented by
>> connection tracking
> Why is this patch required?
> Can't you rework ip_defrag to avoid the cb clear if you need that?

The ip_defrag used by ip stack and can work with the cb setting.

Defragment case only for conntrack maybe need to avoid the cb

clear. So it is more clear to nf_ct_frag_gather for conntrack like the

function nf_ct_frag6_gather for ipv6.


But this patch should reused some function in ip_defrag like Wang Cong's

suggestion

>
