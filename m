Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 039A3C76186
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 22:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8B7322387
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 22:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730559AbfGWWdO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 18:33:14 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33342 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728738AbfGWWdO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 18:33:14 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hq3LG-0005JX-1V; Wed, 24 Jul 2019 00:33:06 +0200
Date:   Wed, 24 Jul 2019 00:33:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: nf_tables: Make nft_meta expression more
 robust
Message-ID: <20190723223306.ahfi5o5roumncm2u@breakpoint.cc>
References: <20190723132753.13781-1-phil@nwl.cc>
 <20190723184321.of7uo36tymvhccwx@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723184321.of7uo36tymvhccwx@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Changes since v1:
> > - Apply same fix to net/bridge/netfilter/nft_meta_bridge.c as well.
> > 
> > Changes since v2:
> > - Limit this fix to address only expressions returning an interface
> >   index or name. As Florian correctly criticized, these changes may be
> >   problematic as they tend to change nftables' behaviour. Hence fix only
> >   the cases needed to establish iptables-nft compatibility.
> 
> This leaves things in an inconsistent situation.
> 
> What's the concern here? Matching iifgroup/oifgroup from the wrong
> packet path?

There is no solution for this problem -- thats the core issue.

Purely from a technical p.o.v., we're asking to match oif, but its not
there, so to me, the current behaviour is the right one: break, because
we can't provide the requested information.

On the other hand, this makes things rather un-intuitive when asking for
not eq "foo" -- and not getting a match.

Plus, there is the "compat" angle.

For iifname and ifindex we're safe because "" is not a valid interface
name and 0 is not a valid ifindex.  But for everything else, I'd be
extra careful.

One alternative is to add the "compat" netlink attribute for
iptables-nft and only change behaviour for iptables-nft sake.

But I feel that noone has real evidence in this matter, just hunches.

If in doubt, I would even prefer to keep things as-is and add the
compat attr for meta so we get iptables-nft to behave like
iptables-legacy and keep nft as-is.

This will become relevant once we get a saner behaviour for non-matching
sets (such as a default action):

meta iifname vmap { "foo" : jump foochain, "bar" : accept, default : jump "rest" }

Would you expect the "packet has no incoming interface" to hit the
default action or not?

If we change things now (set ifindex 0 / "" name), I do not think
we can't revert it later.
