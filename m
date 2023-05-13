Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E83C77B7C
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 May 2023 03:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjEMDZk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 May 2023 23:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjEMDZi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 May 2023 23:25:38 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9791FE6;
        Fri, 12 May 2023 20:25:37 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QJ9tW2dmjzLpQH;
        Sat, 13 May 2023 11:22:43 +0800 (CST)
Received: from [10.174.178.171] (10.174.178.171) by
 kwepemi500015.china.huawei.com (7.221.188.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 13 May 2023 11:25:34 +0800
Subject: Re: [PATCH netfilter -stable,4.14 0/6] stable fixes for 4.14
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>
CC:     <fw@strlen.de>, <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <stable@vger.kernel.org>
References: <20230511154143.52469-1-pablo@netfilter.org>
From:   "luwei (O)" <luwei32@huawei.com>
Message-ID: <0626ced5-75f3-57cf-c797-e84a808e8cd7@huawei.com>
Date:   Sat, 13 May 2023 11:25:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20230511154143.52469-1-pablo@netfilter.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.171]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi, Pablo, I followed up this CVE for several days but I can't figure 
out which commit caused this CVE, It seems the

kernel is affected from 4.0 version according: 
https://www.suse.com/security/cve/CVE-2023-32233.html.

So is there any fix patches for the lower versions ?

在 2023/5/11 11:41 PM, Pablo Neira Ayuso 写道:
> Hi Greg, Sasha,
>
> This is a backport of c1592a89942e ("netfilter: nf_tables: deactivate anonymous
> set from preparation phase") which fixes CVE-2023-32233. This patch requires
> dependency fixes which are not currently in the 4.14 branch.
>
> The following list shows the backported patches, I am using original commit IDs
> for reference:
>
> 1) cd5125d8f518 ("netfilter: nf_tables: split set destruction in deactivate and destroy phase")
>
> 2) f6ac85858976 ("netfilter: nf_tables: unbind set in rule from commit path")
>
> 3) 7f4dae2d7f03 ("netfilter: nft_hash: fix nft_hash_deactivate")
>
> 4) 6a0a8d10a366 ("netfilter: nf_tables: use-after-free in failing rule with bound set")
>
> 5) 273fe3f1006e ("netfilter: nf_tables: bogus EBUSY when deleting set after flush")
>
> 6) c1592a89942e ("netfilter: nf_tables: deactivate anonymous set from preparation phase")
>
> Please apply to 4.14-stable.
>
> Thanks.
>
> Florian Westphal (1):
>    netfilter: nf_tables: split set destruction in deactivate and destroy phase
>
> Pablo Neira Ayuso (5):
>    netfilter: nf_tables: unbind set in rule from commit path
>    netfilter: nft_hash: fix nft_hash_deactivate
>    netfilter: nf_tables: use-after-free in failing rule with bound set
>    netfilter: nf_tables: bogus EBUSY when deleting set after flush
>    netfilter: nf_tables: deactivate anonymous set from preparation phase
>
>   include/net/netfilter/nf_tables.h |  30 ++++++-
>   net/netfilter/nf_tables_api.c     | 139 +++++++++++++++++++++---------
>   net/netfilter/nft_dynset.c        |  22 ++++-
>   net/netfilter/nft_immediate.c     |   6 +-
>   net/netfilter/nft_lookup.c        |  21 ++++-
>   net/netfilter/nft_objref.c        |  21 ++++-
>   net/netfilter/nft_set_hash.c      |   2 +-
>   7 files changed, 194 insertions(+), 47 deletions(-)
>
-- 
Best Regards,
Lu Wei

