Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13815C432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 16:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3A2C20674
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 16:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732258AbfKTQIK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:08:10 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:39018 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731008AbfKTQIK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 11:08:10 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iXSWO-0003op-Dl; Wed, 20 Nov 2019 17:08:00 +0100
Date:   Wed, 20 Nov 2019 17:08:00 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Jay Ligatti <ligatti@usf.edu>,
        Ori Rottenstreich <or@cs.technion.ac.il>,
        Kirill Kogan <kirill.kogan@gmail.com>
Subject: Re: [PATCH nf-next 8/8] nft_set_pipapo: Introduce AVX2-based lookup
 implementation
Message-ID: <20191120160800.GN8016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>,
        Sabrina Dubroca <sd@queasysnail.net>, Jay Ligatti <ligatti@usf.edu>,
        Ori Rottenstreich <or@cs.technion.ac.il>,
        Kirill Kogan <kirill.kogan@gmail.com>
References: <cover.1574119038.git.sbrivio@redhat.com>
 <367e77e2a0097a0c1b715919b8d21f7a51a10429.1574119038.git.sbrivio@redhat.com>
 <20191120151653.GD20235@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120151653.GD20235@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 20, 2019 at 04:16:53PM +0100, Florian Westphal wrote:
> Stefano Brivio <sbrivio@redhat.com> wrote:
> > If the AVX2 set is available, we can exploit the repetitive
> > characteristic of this algorithm to provide a fast, vectorised
> > version by using 256-bit wide AVX2 operands for bucket loads and
> > bitwise intersections.
> > 
> > In most cases, this implementation consistently outperforms rbtree
> > set instances despite the fact they are configured to use a given,
> > single, ranged data type out of the ones used for performance
> > measurements by the nft_concat_range.sh kselftest.
> 
> I think in that case it makes sense to remove rbtree once this new
> set type has had some upstream exposure and let pipapo handle the
> range sets.
> 
> Stefano, if I understand this right then we could figure out which
> implementation (C or AVX) is used via "grep avx2 /proc/cpuinfo".
> 
> If not, I think we might want to expose some additional debug info
> on set dumps.

I once submitted a patch introducing NFTA_SET_OPS, an attribute holding
set type's name in dumps. Maybe we can reuse that? It is message ID
20180403211540.23700-3-phil@nwl.cc (Subject: [PATCH v2 2/2] net:
nftables: Export set backend name via netlink).

Cheers, Phil
