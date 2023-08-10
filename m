Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55787C04A94
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 07:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbjHJHtS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 03:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234038AbjHJHtR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 03:49:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8DC211E;
        Thu, 10 Aug 2023 00:49:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F04665221;
        Thu, 10 Aug 2023 07:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3EFC433C7;
        Thu, 10 Aug 2023 07:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1691653754;
        bh=e7MEa/R7xR4Wky+nEP3+CKBKXMOoeInQccy4b2OpW7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2RYiO6BHui3lLTY2qbfObRvRrIsw2Tqu8L7uhIvPFScH/TtiWLmNlE9H9FdLpS5L2
         LfL5fZzXbCZ50T2GQMx0wOrrCRUlHUxXkRZDB1bwEjsh8WFbVeaIisz0+a0J8zn9tc
         GuJzL8ncjUNG4Fo4zuvrkVctpy3qGP81LR1+b5e0=
Date:   Thu, 10 Aug 2023 09:49:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, stable@vger.kernel.org
Subject: Re: [PATCH net 0/5] Netfilter fixes for net
Message-ID: <2023081006-nurture-landside-fb56@gregkh>
References: <20230810070830.24064-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230810070830.24064-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 10, 2023 at 09:08:25AM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains Netfilter fixes for net.
> 
> The existing attempt to resolve races between control plane and GC work
> is error prone, as reported by Bien Pham <phamnnb@sea.com>, some places
> forgot to call nft_set_elem_mark_busy(), leading to double-deactivation
> of elements.
> 
> This series contains the following patches:
> 
> 1) Do not skip expired elements during walk otherwise elements might
>    never decrement the reference counter on data, leading to memleak.
> 
> 2) Add a GC transaction API to replace the former attempt to deal with
>    races between control plane and GC. GC worker sets on NFT_SET_ELEM_DEAD_BIT
>    on elements and it creates a GC transaction to remove the expired
>    elements, GC transaction could abort in case of interference with
>    control plane and retried later (GC async). Set backends such as
>    rbtree and pipapo also perform GC from control plane (GC sync), in
>    such case, element deactivation and removal is safe because mutex
>    is held then collected elements are released via call_rcu().
> 
> 3) Adapt existing set backends to use the GC transaction API.
> 
> 4) Update rhash set backend to set on _DEAD bit to report deleted
>    elements from datapath for GC.
> 
> 5) Remove old GC batch API and the NFT_SET_ELEM_BUSY_BIT.
> 
> Florian Westphal (1):
>   netfilter: nf_tables: don't skip expired elements during walk
> 
> Pablo Neira Ayuso (4):
>   netfilter: nf_tables: GC transaction API to avoid race with control plane
>   netfilter: nf_tables: adapt set backend to use GC transaction API
>   netfilter: nft_set_hash: mark set element as dead when deleting from packet path
>   netfilter: nf_tables: remove busy mark and gc batch API
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-08-10
> 
> Thanks.
> 
> ----------------------------------------------------------------
> 
> The following changes since commit c5ccff70501d92db445a135fa49cf9bc6b98c444:
> 
>   Merge branch 'net-sched-bind-logic-fixes-for-cls_fw-cls_u32-and-cls_route' (2023-07-31 20:10:39 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-08-10
> 
> for you to fetch changes up to a2dd0233cbc4d8a0abb5f64487487ffc9265beb5:
> 
>   netfilter: nf_tables: remove busy mark and gc batch API (2023-08-10 08:25:27 +0200)
> 
> ----------------------------------------------------------------
> netfilter pull request 23-08-10
> 
> ----------------------------------------------------------------
> Florian Westphal (1):
>       netfilter: nf_tables: don't skip expired elements during walk
> 
> Pablo Neira Ayuso (4):
>       netfilter: nf_tables: GC transaction API to avoid race with control plane
>       netfilter: nf_tables: adapt set backend to use GC transaction API
>       netfilter: nft_set_hash: mark set element as dead when deleting from packet path
>       netfilter: nf_tables: remove busy mark and gc batch API
> 
>  include/net/netfilter/nf_tables.h | 120 ++++++---------
>  net/netfilter/nf_tables_api.c     | 307 ++++++++++++++++++++++++++++++--------
>  net/netfilter/nft_set_hash.c      |  85 +++++++----
>  net/netfilter/nft_set_pipapo.c    |  66 +++++---
>  net/netfilter/nft_set_rbtree.c    | 146 ++++++++++--------
>  5 files changed, 476 insertions(+), 248 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
