Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E3FEE020A
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 19:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbjIMTby (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 15:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjIMTbx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 15:31:53 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886DB83;
        Wed, 13 Sep 2023 12:31:49 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qgVaU-0006aH-B8; Wed, 13 Sep 2023 21:31:46 +0200
Date:   Wed, 13 Sep 2023 21:31:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org, paul@paul-moore.com, rgb@redhat.com
Subject: Re: [nf PATCH v3 1/2] netfilter: nf_tables: Fix entries val in rule
 reset audit log
Message-ID: <20230913193146.GA25164@breakpoint.cc>
References: <20230913135137.15154-1-phil@nwl.cc>
 <20230913135137.15154-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230913135137.15154-2-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> The value in idx and the number of rules handled in that particular
> __nf_tables_dump_rules() call is not identical. The former is a cursor
> to pick up from if multiple netlink messages are needed, so its value is
> ever increasing. Fixing this is not just a matter of subtracting s_idx
> from it, though: When resetting rules in multiple chains,
> __nf_tables_dump_rules() is called for each and cb->args[0] is not
> adjusted in between. Introduce a dedicated counter to record the number
> of rules reset in this call in a less confusing way.
> 
> While being at it, prevent the direct return upon buffer exhaustion: Any
> rules previously dumped into that skb would evade audit logging
> otherwise.

Reviewed-by: Florian Westphal <fw@strlen.de>

We can investigate ways to compress/coalesce (read: make this more
complicated) in case somebody complains about too many audit messages.

But I would not go ahead and keep it simple for now.
