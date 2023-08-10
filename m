Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78484C001DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 10:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbjHJK3V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 06:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbjHJK3U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 06:29:20 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA8D11F;
        Thu, 10 Aug 2023 03:29:16 -0700 (PDT)
Received: from [78.30.34.192] (port=33176 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qU2ul-009Krh-D2; Thu, 10 Aug 2023 12:29:13 +0200
Date:   Thu, 10 Aug 2023 12:29:10 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, stable@vger.kernel.org
Subject: Re: [PATCH net 0/5] Netfilter fixes for net
Message-ID: <ZNS79p44qv1zpl+X@calendula>
References: <20230810070830.24064-1-pablo@netfilter.org>
 <2023081006-nurture-landside-fb56@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2023081006-nurture-landside-fb56@gregkh>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 10, 2023 at 09:49:11AM +0200, Greg KH wrote:
> On Thu, Aug 10, 2023 at 09:08:25AM +0200, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > The following patchset contains Netfilter fixes for net.
> > 
> > The existing attempt to resolve races between control plane and GC work
> > is error prone, as reported by Bien Pham <phamnnb@sea.com>, some places
> > forgot to call nft_set_elem_mark_busy(), leading to double-deactivation
> > of elements.
> > 
> > This series contains the following patches:
> > 
> > 1) Do not skip expired elements during walk otherwise elements might
> >    never decrement the reference counter on data, leading to memleak.
> > 
> > 2) Add a GC transaction API to replace the former attempt to deal with
> >    races between control plane and GC. GC worker sets on NFT_SET_ELEM_DEAD_BIT
> >    on elements and it creates a GC transaction to remove the expired
> >    elements, GC transaction could abort in case of interference with
> >    control plane and retried later (GC async). Set backends such as
> >    rbtree and pipapo also perform GC from control plane (GC sync), in
> >    such case, element deactivation and removal is safe because mutex
> >    is held then collected elements are released via call_rcu().
> > 
> > 3) Adapt existing set backends to use the GC transaction API.
> > 
> > 4) Update rhash set backend to set on _DEAD bit to report deleted
> >    elements from datapath for GC.
> > 
> > 5) Remove old GC batch API and the NFT_SET_ELEM_BUSY_BIT.
> > 
> > Florian Westphal (1):
> >   netfilter: nf_tables: don't skip expired elements during walk
> > 
> > Pablo Neira Ayuso (4):
> >   netfilter: nf_tables: GC transaction API to avoid race with control plane
> >   netfilter: nf_tables: adapt set backend to use GC transaction API
> >   netfilter: nft_set_hash: mark set element as dead when deleting from packet path
> >   netfilter: nf_tables: remove busy mark and gc batch API
> > 
> > Please, pull these changes from:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-08-10
> > 
> > Thanks.
> > 
> > ----------------------------------------------------------------
> > 
> > The following changes since commit c5ccff70501d92db445a135fa49cf9bc6b98c444:
> > 
> >   Merge branch 'net-sched-bind-logic-fixes-for-cls_fw-cls_u32-and-cls_route' (2023-07-31 20:10:39 -0700)
> > 
> > are available in the Git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-08-10
> > 
> > for you to fetch changes up to a2dd0233cbc4d8a0abb5f64487487ffc9265beb5:
> > 
> >   netfilter: nf_tables: remove busy mark and gc batch API (2023-08-10 08:25:27 +0200)
> > 
> > ----------------------------------------------------------------
> > netfilter pull request 23-08-10
> > 
> > ----------------------------------------------------------------
> > Florian Westphal (1):
> >       netfilter: nf_tables: don't skip expired elements during walk
> > 
> > Pablo Neira Ayuso (4):
> >       netfilter: nf_tables: GC transaction API to avoid race with control plane
> >       netfilter: nf_tables: adapt set backend to use GC transaction API
> >       netfilter: nft_set_hash: mark set element as dead when deleting from packet path
> >       netfilter: nf_tables: remove busy mark and gc batch API
> > 
> >  include/net/netfilter/nf_tables.h | 120 ++++++---------
> >  net/netfilter/nf_tables_api.c     | 307 ++++++++++++++++++++++++++++++--------
> >  net/netfilter/nft_set_hash.c      |  85 +++++++----
> >  net/netfilter/nft_set_pipapo.c    |  66 +++++---
> >  net/netfilter/nft_set_rbtree.c    | 146 ++++++++++--------
> >  5 files changed, 476 insertions(+), 248 deletions(-)
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.

I will re-submit this once this hit upstream.

Thanks.
