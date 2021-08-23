Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37D1C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Aug 2021 19:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3F76613CF
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Aug 2021 19:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhHWTLW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Aug 2021 15:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhHWTLV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 15:11:21 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1A4C061575;
        Mon, 23 Aug 2021 12:10:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mIFL7-0004q7-4Q; Mon, 23 Aug 2021 21:10:33 +0200
Date:   Mon, 23 Aug 2021 21:10:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: Suspicious pattern for use of function xt_register_template()
Message-ID: <20210823191033.GA23869@breakpoint.cc>
References: <CAKXUXMzdGdyQg9CXJ2AZStrBk3J10r5r=gyiAuU4WimnoQNyvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKXUXMzdGdyQg9CXJ2AZStrBk3J10r5r=gyiAuU4WimnoQNyvA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
> Dear Florian, dear netfilter maintainers,
> 
> Commit fdacd57c79b ("netfilter: x_tables: never register tables by
> default") on linux-next
> introduces the function xt_register_template() and in all cases but
> one, the calls to that function are followed by:
> 
>     if (ret < 0)
>         return ret;
> 
> All these checks were also added with the commit above.
> 
> In the one case, for iptable_mangle_init() in
> ./net/ipv4/netfilter/iptable_mangle.c, this pattern was not followed.

Thats a bug, the error test is missing.
