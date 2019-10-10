Return-Path: <SRS0=6wcg=YD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4BD9C4360C
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Oct 2019 22:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0A4820B7C
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Oct 2019 22:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfJJWyi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 18:54:38 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:53600 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726358AbfJJWyi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 18:54:38 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iIhKL-00068a-Vv; Fri, 11 Oct 2019 00:54:35 +0200
Date:   Fri, 11 Oct 2019 00:54:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next] netfilter: add and use nf_hook_slow_list()
Message-ID: <20191010225433.GK25052@breakpoint.cc>
References: <20191010223037.10811-1-fw@strlen.de>
 <2d9864c9-95d2-02c2-b256-85a07c2b2232@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d9864c9-95d2-02c2-b256-85a07c2b2232@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Edward Cree <ecree@solarflare.com> wrote:
> On 10/10/2019 23:30, Florian Westphal wrote:
> > NF_HOOK_LIST now only works for ipv4 and ipv6, as those are the only
> > callers.
> ...
> > +
> > +     rcu_read_lock();
> > +     switch (pf) {
> > +     case NFPROTO_IPV4:
> > +             hook_head = rcu_dereference(net->nf.hooks_ipv4[hook]);
> > +             break;
> > +     case NFPROTO_IPV6:
> > +             hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
> > +             break;
> > +     default:
> > +             WARN_ON_ONCE(1);
> > +             break;
> >       }
> Would it not make sense instead to abstract out the switch in nf_hook()
>  into, say, an inline function that could be called from here?  That
>  would satisfy SPOT and also save updating this code if new callers of
>  NF_HOOK_LIST are added in the future.

Its a matter of taste I guess.  I don't really like having all these
inline wrappers for wrappers wrapped in wrappers.

Pablo, its up to you.  I could add __nf_hook_get_hook_head() or similar
and use that instead of open-coding.
