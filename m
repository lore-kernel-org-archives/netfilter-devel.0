Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6DE5C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 11:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F6C860EB5
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 11:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240080AbhHYLH7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 07:07:59 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51422 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbhHYLH5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 07:07:57 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id BF77F60102;
        Wed, 25 Aug 2021 13:06:15 +0200 (CEST)
Date:   Wed, 25 Aug 2021 13:07:06 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: x_tables: handle xt_register_template()
 returning an error value
Message-ID: <20210825110706.GA3515@salvia>
References: <20210823202729.2009-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210823202729.2009-1-lukas.bulwahn@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 23, 2021 at 10:27:29PM +0200, Lukas Bulwahn wrote:
> Commit fdacd57c79b7 ("netfilter: x_tables: never register tables by
> default") introduces the function xt_register_template(), and in one case,
> a call to that function was missing the error-case handling.
> 
> Handle when xt_register_template() returns an error value.
> 
> This was identified with the clang-analyzer's Dead-Store analysis.

Applied, thanks.
