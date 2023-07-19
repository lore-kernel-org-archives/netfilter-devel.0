Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBD4EB64DC
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jul 2023 02:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjGSCxp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jul 2023 22:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjGSCxo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2023 22:53:44 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D3C1BC9;
        Tue, 18 Jul 2023 19:53:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qLxJb-00043q-Tk; Wed, 19 Jul 2023 04:53:23 +0200
Date:   Wed, 19 Jul 2023 04:53:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 1/2] netlink: allow be16 and be32 types in all
 uint policy checks
Message-ID: <20230719025323.GA27896@breakpoint.cc>
References: <20230718075234.3863-1-fw@strlen.de>
 <20230718075234.3863-2-fw@strlen.de>
 <20230718115633.3a15062d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718115633.3a15062d@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 18 Jul 2023 09:52:29 +0200 Florian Westphal wrote:
> > __NLA_IS_BEINT_TYPE(tp) isn't useful.  NLA_BE16/32 are identical to
> > NLA_U16/32, the only difference is that it tells the netlink validation
> > functions that byteorder conversion might be needed before comparing
> > the value to the policy min/max ones.
> > 
> > After this change all policy macros that can be used with UINT types,
> > such as NLA_POLICY_MASK() can also be used with NLA_BE16/32.
> > 
> > This will be used to validate nf_tables flag attributes which
> > are in bigendian byte order.
> 
> Semi-related, how well do we do with NLA_F_NET_BYTEORDER?

Looks incomplete at best.

> On a quick grep we were using it in the kernel -> user
> direction but not validating on input. Is that right?

Looks like ipset is the only user, it sets it for kernel->user
dir.

I see ipset userspace even sets it on user -> kernel dir but
like you say, its not checked and BE encoding is assumed on
kernel side.

From a quick glance in ipset all Uxx types are always treated as
bigendian, which would mean things should not fall apart if ipset
stops announcing NLA_F_NET_BYTEORDER.  Not sure its worth risking
any breakage though.

I suspect that in practice, given both producer and consumer need
to agree of the meaning of type "12345" anyway its easier to just
agree on the byte ordering as well.

Was there a specific reason for the question?
