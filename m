Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3EE9C433E6
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Jan 2021 12:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F38623A1C
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Jan 2021 12:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbhAIMNT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Jan 2021 07:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbhAIMNT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Jan 2021 07:13:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F87C061786;
        Sat,  9 Jan 2021 04:12:39 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kyD6M-0005Tk-Dv; Sat, 09 Jan 2021 13:12:14 +0100
Date:   Sat, 9 Jan 2021 13:12:14 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: Fix memleak in nf_nat_init
Message-ID: <20210109121214.GD19605@breakpoint.cc>
References: <20210109120121.15938-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109120121.15938-1-dinghao.liu@zju.edu.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dinghao Liu <dinghao.liu@zju.edu.cn> wrote:
> When register_pernet_subsys() fails, nf_nat_bysource
> should be freed just like when nf_ct_extend_register()
> fails.

Acked-by: Florian Westphal <fw@strlen.de>
