Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06109C7EE22
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 May 2023 06:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbjEJGdV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 May 2023 02:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjEJGdT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2023 02:33:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18BB73A93
        for <netfilter-devel@vger.kernel.org>; Tue,  9 May 2023 23:33:19 -0700 (PDT)
Date:   Wed, 10 May 2023 08:33:14 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: fix possible bug_on with enable_hooks=1
Message-ID: <ZFs6qpQB8rfK0kPd@calendula>
References: <20230504125502.22512-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230504125502.22512-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 04, 2023 at 02:55:02PM +0200, Florian Westphal wrote:
> I received a bug report (no reproducer so far) where we trip over
> 
> 712         rcu_read_lock();
> 713         ct_hook = rcu_dereference(nf_ct_hook);
> 714         BUG_ON(ct_hook == NULL);  // here
> 
> In nf_conntrack_destroy().
> 
> First turn this BUG_ON into a WARN.  I think it was triggered
> via enable_hooks=1 flag.
> 
> When this flag is turned on, the conntrack hooks are registered
> before nf_ct_hook pointer gets assigned.
> This opens a short window where packets enter the conntrack machinery,
> can have skb->_nfct set up and a subsequent kfree_skb might occur
> before nf_ct_hook is set.
> 
> Call nf_conntrack_init_end() to set nf_ct_hook before we register the
> pernet ops.

Applied to nf, thanks
