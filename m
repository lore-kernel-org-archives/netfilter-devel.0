Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62619C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jun 2022 09:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376431AbiFPJIo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jun 2022 05:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359431AbiFPJIo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jun 2022 05:08:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9873D4AE2D
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2022 02:08:43 -0700 (PDT)
Date:   Thu, 16 Jun 2022 11:08:40 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Move clauses for expired nodes, last
 active node as leaf
Message-ID: <YqrzGBGCUlfd63O0@salvia>
References: <20220512183421.712556-1-sbrivio@redhat.com>
 <YoKVFRR1gggECpiZ@salvia>
 <20220517145709.08694803@elisabeth>
 <20220520174524.439b5fa2@elisabeth>
 <YouhUq09zfcflOnz@salvia>
 <20220525141507.69c37709@elisabeth>
 <YpdKM/mArNz/vh/m@salvia>
 <20220603150445.3d797c87@elisabeth>
 <Yp3CYfbdHH1lm945@salvia>
 <20220614115814.61f8c667@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220614115814.61f8c667@elisabeth>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 14, 2022 at 11:58:14AM +0200, Stefano Brivio wrote:
> On Mon, 6 Jun 2022 11:01:21 +0200
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > That sounds an incremental fix, I prefer this too.
> 
> ...finally posted now.

Thanks.

[...]
> > I don't see how we can obsolete "activate" operation, though, the
> > existing approach works at set element granularity.
> 
> Yes, and that's what I'm arguing against: it would be more natural, in
> a transaction, to have a single commit operation for all the elements
> at hand -- otherwise it's not so much of a transaction.
> 
> To the user it's atomic (minus bugs) because we have tricks to ensure
> it, but to the set back-ends it's absolutely not. I think we have this
> kind of situation:
> 
> 
> nft            <->     core       <->   set back-end    <->    storage
>                 |                  |                     |
> 
> hash:   transaction commit    element commit       element commit
> 
> rbtree: transaction commit    element commit       element commit
>                                                    ^ problematic to the
>                                                    point we're
>                                                    considering a
>                                                    transaction approach
> 
> pipapo: transaction commit    element commit       transaction commit
> 
> The single advantage I see of the current approach is that with the
> hash back-ends we don't need two copies of the hash table, but that
> also has the downside of the nft_set_elem_active(&he->ext, genmask)
> check in the lookup function, which should be, in relative terms, even
> more expensive than it is in the pipapo implementation, given that hash
> back-ends are (in most cases) faster.

There is also runtime set updates from packet path. In that case, we
cannot keep a copy of the data structure that is being updated from
the control plane while the packet path is also adding/deleting
entries from it.
