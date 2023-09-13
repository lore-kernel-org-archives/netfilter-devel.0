Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64AC5EE0207
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 20:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbjIMUiW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 16:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbjIMUiR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 16:38:17 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29E11BCD;
        Wed, 13 Sep 2023 13:38:12 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qgWcj-000358-Ak; Wed, 13 Sep 2023 22:38:09 +0200
Date:   Wed, 13 Sep 2023 22:38:09 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, audit@vger.kernel.org,
        paul@paul-moore.com, rgb@redhat.com
Subject: Re: [nf PATCH v3 1/2] netfilter: nf_tables: Fix entries val in rule
 reset audit log
Message-ID: <ZQIdsZ6fsR+7kS1l@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, audit@vger.kernel.org,
        paul@paul-moore.com, rgb@redhat.com
References: <20230913135137.15154-1-phil@nwl.cc>
 <20230913135137.15154-2-phil@nwl.cc>
 <20230913193146.GA25164@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230913193146.GA25164@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 13, 2023 at 09:31:46PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > The value in idx and the number of rules handled in that particular
> > __nf_tables_dump_rules() call is not identical. The former is a cursor
> > to pick up from if multiple netlink messages are needed, so its value is
> > ever increasing. Fixing this is not just a matter of subtracting s_idx
> > from it, though: When resetting rules in multiple chains,
> > __nf_tables_dump_rules() is called for each and cb->args[0] is not
> > adjusted in between. Introduce a dedicated counter to record the number
> > of rules reset in this call in a less confusing way.
> > 
> > While being at it, prevent the direct return upon buffer exhaustion: Any
> > rules previously dumped into that skb would evade audit logging
> > otherwise.
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>
> 
> We can investigate ways to compress/coalesce (read: make this more
> complicated) in case somebody complains about too many audit messages.

It is only about reset command. Anything following the transaction path
is coalesced already (on a per-table basis, so there's more work needed
if consistent per-chain logging is desired).

> But I would not go ahead and keep it simple for now.

I just want to avoid a second rhbz#2001815[1]. As we both know,
OpenShift likes to have both excessively big chains and excessively many
small ones. %)

Cheers, Phil

[1] https://bugzilla.redhat.com/show_bug.cgi?id=2001815
