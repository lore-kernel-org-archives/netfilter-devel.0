Return-Path: <SRS0=tkBW=2K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D05C43603
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 07:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06E52227BF
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 07:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfLTHEB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 02:04:01 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:46884 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfLTHEB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 02:04:01 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 7557141ABB;
        Fri, 20 Dec 2019 15:03:55 +0800 (CST)
Subject: Re: [PATCH nf] netfilter: flowtable: clean up entries for
 FLOW_BLOCK_UNBIND
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191219135620.350881-1-pablo@netfilter.org>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <d38552f8-8d61-e683-97d1-ecf6b41d205e@ucloud.cn>
Date:   Fri, 20 Dec 2019 15:03:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191219135620.350881-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQ01JS0tLSktMTE1OSVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBQ6HTo*Pzg8PUw3NFY*LFY8
        S0gKCRVVSlVKTkxNQ0lOT0hCTUtDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUlPSDcG
X-HM-Tid: 0a6f221eb5942086kuqy7557141abb
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 12/19/2019 9:56 PM, Pablo Neira Ayuso wrote:
> Call nf_flow_table_iterate_cleanup() to remove flowtable entries.
> This patch is implicitly handling the NETDEV_UNREGISTER and the
> flowtable removal cases (while there are still entries in place).

Hi Pablo,

I  test the flowtable meeting the same problem with flowtable delete.


For NETDEV_UNREGISTER case there is no necessary to do this.

The flow_offload_netdev_event in the nft_flow_offload with NETDEV_DOWN(

previous to UNREGISTER) will do nf_flow_table_cleanup(dev);


For flowtable delete case, it will  do cleanup things in nf_flow_table_free, but this is

later than UNBIND. First it make UNBIND call after the free operation.

But only UNBIND setup before flows cleanup can't guarantee the flows
delete in the hardware. The real delete in nf_flow_offload_work handler.


I fix it through adding a refcont for the flow_block to make sure the hardware
flows clean before UNBIND setup. I test my patch with mellaonx card.

This patch is http://patchwork.ozlabs.org/patch/1213936/

welcome some commends and other solution idea. Thx!


BR

wenxu



 
