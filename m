Return-Path: <SRS0=1PIt=XE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4FDC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Sep 2019 03:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 297CF2084D
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Sep 2019 03:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387860AbfIIDwe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Sep 2019 23:52:34 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:49196 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfIIDwe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Sep 2019 23:52:34 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 634EF417DB;
        Mon,  9 Sep 2019 11:52:32 +0800 (CST)
Subject: Re: [PATCH nf-next v4 4/4] netfilter: nf_offload: clean offload
 things when the device unregister
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1567952336-23669-1-git-send-email-wenxu@ucloud.cn>
 <1567952336-23669-5-git-send-email-wenxu@ucloud.cn>
 <20190908162148.eble5o6zuo7k5zx4@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <ff25e42a-a6b3-8445-047e-82ffe8e50ed3@ucloud.cn>
Date:   Mon, 9 Sep 2019 11:52:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190908162148.eble5o6zuo7k5zx4@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSENNS0tLSk5NT0tJTkJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NC46Phw5FDg6HzU2LC0yKQsa
        LjBPCRRVSlVKTk1DS0tKSk5JTUpOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUhMQjcG
X-HM-Tid: 0a6d1426d5d52086kuqy634ef417db
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 9/9/2019 12:21 AM, Pablo Neira Ayuso wrote:
> On Sun, Sep 08, 2019 at 10:18:56PM +0800, wenxu@ucloud.cn wrote:
>> +static int nft_offload_netdev_event(struct notifier_block *this,
>> +				    unsigned long event, void *ptr)
>> +{
>> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>> +	struct net *net = dev_net(dev);
>> +	struct nft_chain *chain;
>> +
>> +	mutex_lock(&net->nft.commit_mutex);
>> +	chain = __nft_offload_get_chain(dev);
>> +	if (chain)
>> +		nft_offload_chain_clean(chain);
>> +	mutex_unlock(&net->nft.commit_mutex);
>> +
>> +	return NOTIFY_DONE;
>> +}
> Please, could you update nft_indr_block_cb() to use
> __nft_offload_get_chain() in this series?
Patch 3/4 in this series already  update nft_indr_block_cb() to use __nft_offload_get_chain()
>
> Like this, you fix all the problems already in the tree (missing
> mutex, missing check for offload hardware flag...) in one single go?
So you means drop the missing mutex and offload flags patches. And put all in the __nft_offload_get_chain patch?
