Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0376C77B73
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 May 2023 21:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjEZVt2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 May 2023 17:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjEZVt2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 May 2023 17:49:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C677BC
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2023 14:49:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1q2fJN-0001Au-MV; Fri, 26 May 2023 23:49:25 +0200
Date:   Fri, 26 May 2023 23:49:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v1 1/6] netfilter: nf_tables: remove expression
 reduce infrastructure
Message-ID: <20230526214925.GC2532@breakpoint.cc>
References: <20230525154024.222338-1-pablo@netfilter.org>
 <20230525154024.222338-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525154024.222338-2-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This infrastructure is disabled since 9e539c5b6d9c ("netfilter: nf_tables:
> disable expression reduction infra") and the combo match infrastructure
> provides an alternative to this approach, remove it.

Fine with me, we can bring this back if needed.
