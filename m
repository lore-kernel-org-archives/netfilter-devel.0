Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5176C77B73
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 May 2023 21:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjEZVwz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 May 2023 17:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjEZVwx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 May 2023 17:52:53 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD17F3
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2023 14:52:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1q2fMh-0001Bo-9s; Fri, 26 May 2023 23:52:51 +0200
Date:   Fri, 26 May 2023 23:52:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v1 4/6] netfilter: nf_tables: add meta combo match
Message-ID: <20230526215251.GD2532@breakpoint.cc>
References: <20230525154024.222338-1-pablo@netfilter.org>
 <20230525154024.222338-5-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525154024.222338-5-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This patch allows to coalesce meta iifname,oifname + cmp into one combo
> expression.

Hmmm, I wonder how often "meta (o|i)fname "name") is used in practice.

Perhaps make this a noinline helper?

But, your call.  It compacts the ruleset representation which should
be a win as well.

I'm also asking because this grows the eval loop again after the initial
dieting in patch #2.
