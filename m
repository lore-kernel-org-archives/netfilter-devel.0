Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2420FC47089
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 18:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF9BF613C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 18:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbhE0SNq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 May 2021 14:13:46 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38140 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbhE0SNp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 May 2021 14:13:45 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2C00864502;
        Thu, 27 May 2021 20:11:09 +0200 (CEST)
Date:   Thu, 27 May 2021 20:12:08 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] netfilter: Remove redundant assignment to ret
Message-ID: <20210527181208.GA8886@salvia>
References: <1619774710-119962-1-git-send-email-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1619774710-119962-1-git-send-email-yang.lee@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 30, 2021 at 05:25:10PM +0800, Yang Li wrote:
> Variable 'ret' is set to zero but this value is never read as it is
> overwritten with a new value later on, hence it is a redundant
> assignment and can be removed
> 
> Clean up the following clang-analyzer warning:
> 
> net/netfilter/xt_CT.c:175:2: warning: Value stored to 'ret' is never
> read [clang-analyzer-deadcode.DeadStores]

I overlook this small patch, now applied to nf-next. Thanks.
