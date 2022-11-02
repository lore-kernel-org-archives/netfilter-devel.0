Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0E4C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Nov 2022 09:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiKBJrG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Nov 2022 05:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKBJrF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Nov 2022 05:47:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1476823BEE;
        Wed,  2 Nov 2022 02:47:03 -0700 (PDT)
Date:   Wed, 2 Nov 2022 10:47:00 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, lorenzo@kernel.org,
        john.fastabend@gmail.com
Subject: Re: [PATCH net v2] netfilter: nf_nat: Fix possible memory leak in
 nf_nat_init()
Message-ID: <Y2I8lIldVgo7f3Tc@salvia>
References: <20221101115252.17340-1-chenzhongjin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221101115252.17340-1-chenzhongjin@huawei.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 01, 2022 at 07:52:52PM +0800, Chen Zhongjin wrote:
> In nf_nat_init(), register_nf_nat_bpf() can fail and return directly
> without any error handling.
> Then nf_nat_bysource will leak and registering of &nat_net_ops,
> &follow_master_nat and nf_nat_hook won't be reverted.
> 
> This leaves wild ops in linkedlists and when another module tries to
> call register_pernet_operations() or nf_ct_helper_expectfn_register()
> it triggers page fault:
> 
>  BUG: unable to handle page fault for address: fffffbfff81b964c
>  RIP: 0010:register_pernet_operations+0x1b9/0x5f0
>  Call Trace:
>  <TASK>
>   register_pernet_subsys+0x29/0x40
>   ebtables_init+0x58/0x1000 [ebtables]
>   ...
> 
> Fixes: 820dc0523e05 ("net: netfilter: move bpf_ct_set_nat_info kfunc in nf_nat_bpf.c")
> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
> ---
> Also revert the operation for &follow_master_nat and nf_nat_hook,
> then slightly fix commit msg for it.

Applied, thanks
