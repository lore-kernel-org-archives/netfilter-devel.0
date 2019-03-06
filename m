Return-Path: <SRS0=WT5G=RJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBC2C43381
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 11:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05FEF20675
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 11:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfCFLji (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Mar 2019 06:39:38 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52246 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725267AbfCFLji (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Mar 2019 06:39:38 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1h1Utd-0006DX-3b; Wed, 06 Mar 2019 12:39:37 +0100
Date:   Wed, 6 Mar 2019 12:39:37 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: misleading error reporting
Message-ID: <20190306113937.y4mpqnh3hvvtb2yp@breakpoint.cc>
References: <20190306110051.22974-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190306110051.22974-1-pablo@netfilter.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> When trying to list a map content, if set is used, error reporting reports:
> 
>  # nft list set filter group_7933
>  Error: No such file or directory; did you mean set ‘group_7933’ in table ip ‘filter’?
>  list set filter group_7933
>                  ^^^^^^^^^^

Thanks for fixing this, I hit this myself too while looking at this bug
report.
