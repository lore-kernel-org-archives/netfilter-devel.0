Return-Path: <SRS0=J2Vc=4L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39557C35670
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 23:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08554206E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 23:04:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SqKi8a+x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgBWXEm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 18:04:42 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45784 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726302AbgBWXEm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 18:04:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582499081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CwS5KG6OqfMYAdG9Fn57aiBa0v5i7MRDITNaSBVf8YE=;
        b=SqKi8a+xJdvimw4ozgMFu8j5mLSiV7RK1Hhg2P6AE1S5jUXAXwdHNpbwHvLWfuc0LLsYaz
        SuVs/KPU+C69Z/qhwii2OcmP6VXZIyi4Ter0Cp5K/XvLmVv8laxU5tAGDf/XGdx9T7CpIu
        G9OevGKeSdVnd/xWgrmghwNmMmzoG+4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-XqVtZSy6OVCJWrbRGXZ2qg-1; Sun, 23 Feb 2020 18:04:37 -0500
X-MC-Unique: XqVtZSy6OVCJWrbRGXZ2qg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57CE4800D50;
        Sun, 23 Feb 2020 23:04:36 +0000 (UTC)
Received: from localhost (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 005DA85F13;
        Sun, 23 Feb 2020 23:04:34 +0000 (UTC)
Date:   Mon, 24 Feb 2020 00:04:29 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 3/5] nft_set_pipapo: Prepare for vectorised
 implementation: alignment
Message-ID: <20200224000429.7997696b@redhat.com>
In-Reply-To: <20200223221435.GX19559@breakpoint.cc>
References: <cover.1582488826.git.sbrivio@redhat.com>
        <2723f85da2cd9d6b7158c7a2514c6b22f044b1b6.1582488826.git.sbrivio@redhat.com>
        <20200223221435.GX19559@breakpoint.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, 23 Feb 2020 23:14:35 +0100
Florian Westphal <fw@strlen.de> wrote:

> Stefano Brivio <sbrivio@redhat.com> wrote:
> >  struct nft_pipapo_field {
> > @@ -439,6 +456,9 @@ struct nft_pipapo_field {
> >  	unsigned long rules;
> >  	size_t bsize;
> >  	int bb;
> > +#ifdef NFT_PIPAPO_ALIGN
> > +	unsigned long *lt_aligned;
> > +#endif
> >  	unsigned long *lt;
> >  	union nft_pipapo_map_bucket *mt;
> >  };  
> 
> I wonder if these structs can be compressed.
> AFAICS bsize is in sizes of longs, so when this number is
> large then we also need to kvmalloc a large blob of memory.
> 
> I think u32 would be enough?

Hm, yes, it is. I just thought it was a "good idea" to use size_t for
"sizes", but this is so implementation-specific that u32 would make
total sense (it's enough for 32GiB), and avoid holes on 64-bit archs.

> nft_pipapo_field is probably the most relevant one wrt. to size.

Right. I forgot about that when I added 'bb'.

> >  struct nft_pipapo_match {
> >  	int field_count;
> > +#ifdef NFT_PIPAPO_ALIGN
> > +	unsigned long * __percpu *scratch_aligned;
> > +#endif
> >  	unsigned long * __percpu *scratch;
> >  	size_t bsize_max;  
> 
> Same here (bsize_max -- could fit with hole after field_count)?

Yes, makes sense.

> Also, since you know the size of nft_pipapo_match (including the
> dynamically allocated array at the end), you could store the
> original memory (*scratch) and the rcu_head at the end, since
> they are not needed at lookup time and a little overhead to calculate
> their storage offset is fine.
> 
> Not sure its worth it, just an idea.

'*scratch' is actually needed at lookup time for implementations that
don't need stricter alignment than natural one, but I could probably
use some macro trickery and "move" it as needed.

I'm not sure how to deal with fields after f[0], syntactically. Do you
have some, er, pointers?

-- 
Stefano

