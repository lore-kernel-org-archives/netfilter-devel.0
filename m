Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B653C77B6C
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Apr 2023 09:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbjDFJXP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Apr 2023 05:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbjDFJXN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2023 05:23:13 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D5B01BC5;
        Thu,  6 Apr 2023 02:23:13 -0700 (PDT)
Date:   Thu, 6 Apr 2023 11:23:09 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Chen Aotian <chenaotian2@163.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kadlec@netfilter.org, edumazet@google.com, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, davem@davemloft.net
Subject: Re: [netfilter-core] [PATCH] netfilter: nf_tables: Modify
 nla_memdup's flag to GFP_KERNEL_ACCOUNT
Message-ID: <ZC6PfTJmIiAhiG6C@salvia>
References: <20230406040151.1676-1-chenaotian2@163.com>
 <ZC6PLsY0+WWW21wE@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZC6PLsY0+WWW21wE@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 06, 2023 at 11:21:50AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 06, 2023 at 12:01:51PM +0800, Chen Aotian wrote:
> > For memory alloc that store user data from nla[NFTA_OBJ_USERDATA], 
> > use GFP_KERNEL_ACCOUNT is more suitable.
> >
> 
> Fixes: 33758c891479 ("memcg: enable accounting for nft objects")
> 
> > Signed-off-by: Chen Aotian <chenaotian2@163.com>

BTW, this patch is intended for nf.git, I'll apply it now.
