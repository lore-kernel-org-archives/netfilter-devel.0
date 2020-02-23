Return-Path: <SRS0=J2Vc=4L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFD0C35673
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 22:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B48E206ED
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 22:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgBWWOi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 17:14:38 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45740 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726302AbgBWWOi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 17:14:38 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j5zWF-0004Bw-B8; Sun, 23 Feb 2020 23:14:35 +0100
Date:   Sun, 23 Feb 2020 23:14:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 3/5] nft_set_pipapo: Prepare for vectorised
 implementation: alignment
Message-ID: <20200223221435.GX19559@breakpoint.cc>
References: <cover.1582488826.git.sbrivio@redhat.com>
 <2723f85da2cd9d6b7158c7a2514c6b22f044b1b6.1582488826.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2723f85da2cd9d6b7158c7a2514c6b22f044b1b6.1582488826.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Stefano Brivio <sbrivio@redhat.com> wrote:
>  struct nft_pipapo_field {
> @@ -439,6 +456,9 @@ struct nft_pipapo_field {
>  	unsigned long rules;
>  	size_t bsize;
>  	int bb;
> +#ifdef NFT_PIPAPO_ALIGN
> +	unsigned long *lt_aligned;
> +#endif
>  	unsigned long *lt;
>  	union nft_pipapo_map_bucket *mt;
>  };

I wonder if these structs can be compressed.
AFAICS bsize is in sizes of longs, so when this number is
large then we also need to kvmalloc a large blob of memory.

I think u32 would be enough?

nft_pipapo_field is probably the most relevant one wrt. to size.

>  struct nft_pipapo_match {
>  	int field_count;
> +#ifdef NFT_PIPAPO_ALIGN
> +	unsigned long * __percpu *scratch_aligned;
> +#endif
>  	unsigned long * __percpu *scratch;
>  	size_t bsize_max;

Same here (bsize_max -- could fit with hole after field_count)?

Also, since you know the size of nft_pipapo_match (including the
dynamically allocated array at the end), you could store the
original memory (*scratch) and the rcu_head at the end, since
they are not needed at lookup time and a little overhead to calculate
their storage offset is fine.

Not sure its worth it, just an idea.
