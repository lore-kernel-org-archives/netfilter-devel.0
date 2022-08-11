Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8935C3F6B0
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Aug 2022 16:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbiHKQOE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Aug 2022 12:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237466AbiHKQNo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Aug 2022 12:13:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8FB62A6C32
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Aug 2022 08:58:06 -0700 (PDT)
Date:   Thu, 11 Aug 2022 17:57:59 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: fix scheduling-while-atomic
 splat
Message-ID: <YvUnB6q/lcDE1ZHz@salvia>
References: <20220811113039.218733-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220811113039.218733-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 11, 2022 at 01:30:39PM +0200, Florian Westphal wrote:
> nf_tables_check_loops() can be called from rhashtable list
> walk so cond_resched() cannot be used here.

Applied, thanks
