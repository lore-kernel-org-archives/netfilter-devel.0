Return-Path: <SRS0=H9P1=4W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 151D6C3F2D1
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 20:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0626207FD
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 20:35:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DFPV7rbP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgCEUf1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 15:35:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31531 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725991AbgCEUf1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 15:35:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583440526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SVtB9IH2OKA1aC5kBjeSQ3ccnBg5C0LcosjOVEiTCWo=;
        b=DFPV7rbPv46PIBZxmzFN3BatlICbixoBt67DRZJJhZLlvBPdtjxYma1Mu/Tg0InagEnJ6N
        TUUtLSgQ1HDSYRAua8AVbmkQOoN4pEjcWRhUmnoaybw49UlSAJPDlyMq7hceFXFlvDg3I6
        vW6M+094G2JW6R3QPT4E+hUAXGccQDQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-5k9ZZXPlPUuEsDvilgNQgw-1; Thu, 05 Mar 2020 15:35:23 -0500
X-MC-Unique: 5k9ZZXPlPUuEsDvilgNQgw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCF691005509;
        Thu,  5 Mar 2020 20:35:21 +0000 (UTC)
Received: from elisabeth (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A30191D9E;
        Thu,  5 Mar 2020 20:35:20 +0000 (UTC)
Date:   Thu, 5 Mar 2020 21:35:13 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 3/5] nft_set_pipapo: Prepare for vectorised
 implementation: alignment
Message-ID: <20200305213513.504171de@elisabeth>
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

Hi Florian,

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
> 
> nft_pipapo_field is probably the most relevant one wrt. to size.

...so I tried rearranging that struct. The results (on both x86_64 and
aarch64) are rather disappointing: the hole (that we get on 64-bit
architectures) seems to actually be beneficial.

If I turn the 'unsigned long' and 'size_t' members to u32, matching
rates drop very slightly (1-3% depending on the case in the usual
kselftest).

I then tried to shrink it more aggressively ('bb' and 'groups' can be
u8, 'bsize' can probably even be u16), and there the performance hit is
much more apparent (> 10%) -- but this is something I can easily explain
with word masks and shifts.

I'm not sure exactly what happens with the pair of u32's. The assembly
looks clean. I would probably need some micro-benchmarking to
clearly relate this to execution pipeline "features" and to, perhaps,
find a way to shuffle accesses to fields to actually speed this up
while fitting two fields in the same word.

However, I'm not so sure it's worth it at this stage.

> >  struct nft_pipapo_match {
> >  	int field_count;
> > +#ifdef NFT_PIPAPO_ALIGN
> > +	unsigned long * __percpu *scratch_aligned;
> > +#endif
> >  	unsigned long * __percpu *scratch;
> >  	size_t bsize_max;  
> 
> Same here (bsize_max -- could fit with hole after field_count)?
> 
> Also, since you know the size of nft_pipapo_match (including the
> dynamically allocated array at the end), you could store the
> original memory (*scratch) and the rcu_head at the end, since
> they are not needed at lookup time and a little overhead to calculate
> their storage offset is fine.
> 
> Not sure its worth it, just an idea.

I actually bothered with this: even without the trick you explained,
struct field f[0] can safely become f[16] (NFT_REG32_COUNT), and I can
move it to the top, and then push the rcu_head down. This, again, hits
lookup rates quite badly. With f[4] lookup rates are the same as the
current case.

So, well, I wouldn't touch this either -- maybe some micro-benchmarking
might suggest a better way, but I doubt it's worth it right now.

-- 
Stefano

