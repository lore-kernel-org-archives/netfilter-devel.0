Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC90C4320E
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Aug 2021 22:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 408BD61368
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Aug 2021 22:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbhHWW1T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Aug 2021 18:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbhHWW1O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 18:27:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEDFC06175F;
        Mon, 23 Aug 2021 15:26:31 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mIIOf-0005pk-Qx; Tue, 24 Aug 2021 00:26:26 +0200
Date:   Tue, 24 Aug 2021 00:26:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: x_tables: handle xt_register_template()
 returning an error value
Message-ID: <20210823222625.GB23869@breakpoint.cc>
References: <20210823202729.2009-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823202729.2009-1-lukas.bulwahn@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
> Commit fdacd57c79b7 ("netfilter: x_tables: never register tables by
> default") introduces the function xt_register_template(), and in one case,
> a call to that function was missing the error-case handling.
> 
> Handle when xt_register_template() returns an error value.
> 
> This was identified with the clang-analyzer's Dead-Store analysis.

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by > default")
Reviewed-by: Florian Westphal <fw@strlen.de>

This needs to go to nf-next.
