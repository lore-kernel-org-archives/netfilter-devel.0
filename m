Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C82C48BCD
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Jun 2021 22:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D31613E6
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Jun 2021 22:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhFIWEx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Jun 2021 18:04:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60794 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhFIWEw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Jun 2021 18:04:52 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2987563087;
        Thu, 10 Jun 2021 00:01:43 +0200 (CEST)
Date:   Thu, 10 Jun 2021 00:02:53 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Jun 9 (net/netfilter/nfnetlink_hook.c)
Message-ID: <20210609220253.GA7342@salvia>
References: <20210609225703.56bfcc12@canb.auug.org.au>
 <7b172e41-f483-bfc1-4f41-f92ea0b3b19d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b172e41-f483-bfc1-4f41-f92ea0b3b19d@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 09, 2021 at 03:00:42PM -0700, Randy Dunlap wrote:
> On 6/9/21 5:57 AM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20210608:
> > 
> 
> on i386:
> 
> ../net/netfilter/nfnetlink_hook.c: In function ‘nfnl_hook_put_nft_chain_info’:
> ../net/netfilter/nfnetlink_hook.c:76:7: error: implicit declaration of function ‘nft_is_active’; did you mean ‘sev_es_active’? [-Werror=implicit-function-declaration]
>   if (!nft_is_active(net, chain))
>        ^~~~~~~~~~~~~
>        sev_es_active
> ../net/netfilter/nfnetlink_hook.c: In function ‘nfnl_hook_entries_head’:
> ../net/netfilter/nfnetlink_hook.c:175:21: warning: unused variable ‘netdev’ [-Wunused-variable]
>   struct net_device *netdev;
>                      ^~~~~~
> cc1: some warnings being treated as errors
> 
> 
> Full randconfig file is attached.

Upstream fix already in nf-next.

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/?id=d4fb1f954fc7e2044b64b7d690400b99a6d5775c

Thanks for reporting.
