Return-Path: <SRS0=TrSD=ZT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A9EAC432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 11:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAC94206BF
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 11:03:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DJwz/PWU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfK0LDE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 06:03:04 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56395 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726194AbfK0LDE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 06:03:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574852582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wytKnxajhBIlkHLOUiCqpVErG0d9EUbgIZI2N/deSyg=;
        b=DJwz/PWUFX3Jm+jMah48dE4LZiQ4MjIH5aTctxMmyxKun4BrYECQbKGX5BNwu+BlSq+QIG
        JoWyuHlSb759H+XB0bdshf3cQw9l6eweqAd4XsVKMci10Rvw42AqLlgMIdIHEg35J1h29M
        uLrV29Cxz9JTz5ZiAP5RuxGzUgKfRWg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-zQw-COFYPxCNN116U7DSyA-1; Wed, 27 Nov 2019 06:02:59 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9F2E800D4E;
        Wed, 27 Nov 2019 11:02:57 +0000 (UTC)
Received: from elisabeth (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CBC275C219;
        Wed, 27 Nov 2019 11:02:54 +0000 (UTC)
Date:   Wed, 27 Nov 2019 12:02:49 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v2 3/8] nf_tables: Add set type for arbitrary
 concatenation of ranges
Message-ID: <20191127120249.292d4a69@elisabeth>
In-Reply-To: <20191127092945.kp25vjfwxcrbjapx@salvia>
References: <cover.1574428269.git.sbrivio@redhat.com>
        <5e7c454e030a8ad581a12d88881f96374e96da68.1574428269.git.sbrivio@redhat.com>
        <20191127092945.kp25vjfwxcrbjapx@salvia>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: zQw-COFYPxCNN116U7DSyA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 27 Nov 2019 10:29:45 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Hi Stefano,
> 
> Just started reading, a few initial questions.
> 
> On Fri, Nov 22, 2019 at 02:40:02PM +0100, Stefano Brivio wrote:
> [...]
>
> > +static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
> > +			     const struct nft_set_elem *elem,
> > +			     struct nft_set_ext **ext2)
> > +{
> > +	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
> > +	const u8 *data = (const u8 *)elem->key.val.data, *start, *end;
> > +	union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
> > +	struct nft_pipapo *priv = nft_set_priv(set);
> > +	struct nft_pipapo_match *m = priv->clone;
> > +	struct nft_pipapo_elem *e = elem->priv;
> > +	struct nft_pipapo_field *f;
> > +	int i, bsize_max, err = 0;
> > +	void *dup;
> > +
> > +	dup = nft_pipapo_get(net, set, elem, 0);
> > +	if (PTR_ERR(dup) != -ENOENT) {
> > +		priv->start_elem = NULL;
> > +		if (IS_ERR(dup))
> > +			return PTR_ERR(dup);
> > +		*ext2 = dup;  
> 
> dup should be of nft_set_ext type. I just had a look at
> nft_pipapo_get() and I think this returns nft_pipapo_elem, which is
> almost good, since it contains nft_set_ext, right?

Right, it returns nft_pipapo_elem which contains that.

> I think you also need to check if the object is active in the next
> generation via nft_genmask_next() and nft_set_elem_active(), otherwise
> ignore it.

I guess I should actually do this in nft_pipapo_get(), also because we
don't want to return inactive elements when userspace "gets" them.

I just noticed this is currently inconsistent with the lookup, because
nft_pipapo_lookup() correctly does:

--
next_match:
		b = pipapo_refill(res_map, f->bsize, f->rules, fill_map, f->mt,
				  last);
		if (b < 0) {
			raw_cpu_write(nft_pipapo_scratch_index, map_index);
			local_bh_enable();

			return false;
		}

		if (last) {
			*ext = &f->mt[b].e->ext;
			if (unlikely(nft_set_elem_expired(*ext) ||
				     !nft_set_elem_active(*ext, genmask)))
				goto next_match;
--

but I forgot to implement the same check in pipapo_get():

--
next_match:
		b = pipapo_refill(res_map, f->bsize, f->rules, fill_map, f->mt,
				  last);
		if (b < 0)
			goto out;

		if (last) {
			if (nft_set_elem_expired(&f->mt[b].e->ext))
				goto next_match;
--

this check should simply include || !nft_set_elem_active(...), and then
I wouldn't need any further check in nft_pipapo_init(). I'd fix this in
v3.

I'm actually not sure if I need to report these elements to
nft_pipapo_remove(). If it's needed, I would add some kind of
"get_inactive" flag to pipapo_get(), which is true on the call from
nft_pipapo_remove(), and false on other paths. If the flag is true, the
nft_set_elem_active() check is then skipped.

> Note that the datastructure needs to temporarily deal with duplicates,
> ie. one inactive object (just deleted) and one active object (just
> added) for the next generation.

Yes, this is taken care of (except for the problem described above),
specifically, there can be n inactive objects, and a single active
object that are entirely overlapping.

This makes some optimisations harder to implement, namely, step 5.2.1
from:
	https://pipapo.lameexcu.se/pipapo/tree/pipapo.c#n337

because we need to allow entirely overlapping entries and map them to
possibly distinct elements.

Now, I think this would all be easier if the API implemented
transactions and commit in a way that appears more natural to me.

When I started working on this, I initially thought activate() would be
called once per transaction, not per element, so that insert() and
remove() would add or remove elements pending for a given transaction,
and activate() would commit it. Same for flush().

At that point, we would have a copy of lookup data with pending
insertions and without pending deletions, and on transaction commit,
this copy would become active, with no inactive elements into it.
Hence, no overlapping elements in live data.

This way we could also make transactions atomic. If activate() is
called once for each element in the transaction, that can't be atomic.

I plan to work on this (if it makes sense), but it looks rather
complicated to match this with existing set implementations and
especially current UAPI, that's the main reason why I "worked around"
this aspect for the moment being. I guess that having at least one set
implementation that can play along with this model would help later.

> > +		return -EEXIST;
> > +	}
> > +
> > +	if (!nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) ||
> > +	    !(*nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)) {
> > +		priv->start_elem = e;
> > +		*ext2 = &e->ext;
> > +		memcpy(priv->start_data, data, priv->width);
> > +		return 0;
> > +	}
> > +
> > +	if (!priv->start_elem)
> > +		return -EINVAL;  
> 
> I'm working on a sketch patch to extend the front-end code to make
> this easier for you, will post it asap, so you don't need this special
> handling to collect both ends of the interval.

Nice, thanks. Mind that I think this is actually a bit ugly but fine.
As I was mentioning to Florian, it doesn't present any particular race
with bad consequences (at least in v2).

Right now I was trying to get the NFTA_SET_DESC_CONCAT >
NFTA_LIST_ELEM > NFTA_SET_FIELD_LEN nesting implemented in libnftnl in
a somewhat acceptable way. Let me know if the front-end changes would
affect this significantly, I'll wait for your patch in that case.

> So far, just spend a bit of time on this, will get back to you with
> more feedback.
> 
> Thanks for working on this!

And thanks for reviewing it!

-- 
Stefano

