Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77118EB64DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jul 2023 07:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjGSHTj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jul 2023 03:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjGSHTi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2023 03:19:38 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD68172B;
        Wed, 19 Jul 2023 00:19:36 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 40B72CC00FE;
        Wed, 19 Jul 2023 09:19:30 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed, 19 Jul 2023 09:19:28 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 47C81CC010D;
        Wed, 19 Jul 2023 09:19:24 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 0B3093431A9; Wed, 19 Jul 2023 09:19:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 099CB343155;
        Wed, 19 Jul 2023 09:19:24 +0200 (CEST)
Date:   Wed, 19 Jul 2023 09:19:24 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
cc:     Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 1/2] netlink: allow be16 and be32 types in all
 uint policy checks
In-Reply-To: <20230719025323.GA27896@breakpoint.cc>
Message-ID: <1216984-c384-461e-2744-eb261be8cb1e@netfilter.org>
References: <20230718075234.3863-1-fw@strlen.de> <20230718075234.3863-2-fw@strlen.de> <20230718115633.3a15062d@kernel.org> <20230719025323.GA27896@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 19 Jul 2023, Florian Westphal wrote:

> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 18 Jul 2023 09:52:29 +0200 Florian Westphal wrote:
> > > __NLA_IS_BEINT_TYPE(tp) isn't useful.  NLA_BE16/32 are identical to
> > > NLA_U16/32, the only difference is that it tells the netlink validation
> > > functions that byteorder conversion might be needed before comparing
> > > the value to the policy min/max ones.
> > > 
> > > After this change all policy macros that can be used with UINT types,
> > > such as NLA_POLICY_MASK() can also be used with NLA_BE16/32.
> > > 
> > > This will be used to validate nf_tables flag attributes which
> > > are in bigendian byte order.
> > 
> > Semi-related, how well do we do with NLA_F_NET_BYTEORDER?
> 
> Looks incomplete at best.
> 
> > On a quick grep we were using it in the kernel -> user
> > direction but not validating on input. Is that right?
> 
> Looks like ipset is the only user, it sets it for kernel->user
> dir.
> 
> I see ipset userspace even sets it on user -> kernel dir but
> like you say, its not checked and BE encoding is assumed on
> kernel side.
> 
> From a quick glance in ipset all Uxx types are always treated as
> bigendian, which would mean things should not fall apart if ipset
> stops announcing NLA_F_NET_BYTEORDER.  Not sure its worth risking
> any breakage though.

Yes, ipset treats all uxx types as netorder.

It checks the presence of the NLA_F_NET_BYTEORDER, see the 
ip_set_attr_netorder() and ip_set_optattr_netorder() functions in 
include/linux/netfilter/ipset/ip_set.h which are then used at input 
validation.

The userspace tool also uses and checks the flag in lib/session.c, but it 
accepts hostorder as well.

> I suspect that in practice, given both producer and consumer need
> to agree of the meaning of type "12345" anyway its easier to just
> agree on the byte ordering as well.
> 
> Was there a specific reason for the question?
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
