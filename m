Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9264CC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Jul 2022 15:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237532AbiGSPrl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Jul 2022 11:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236955AbiGSPrk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Jul 2022 11:47:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7A5C54673
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2022 08:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658245658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NOQSnYNWtNwKVsCZ4mVNAS7O6pjyrN18QYcF00yAN0U=;
        b=NR5168nQ+61tBqgSqeQ2SpbeOF3v06lTPXcU7AUG7pekqR6ZZheVNBEU/pu7lJUxlQxA/D
        OiDMK6FQq9TeqBIPspgaeTUErGBpzloW7y4XzuAVhDtoXndARnsgT8nNQF+9tMRTAqfvFF
        qcnFZkOdigZY50ulzZI13AyO8bkNFPA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-Pk0rJFgZOuS7J821r44EVw-1; Tue, 19 Jul 2022 11:47:28 -0400
X-MC-Unique: Pk0rJFgZOuS7J821r44EVw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A664C29AA3BC;
        Tue, 19 Jul 2022 15:47:28 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FCFA492C3B;
        Tue, 19 Jul 2022 15:47:28 +0000 (UTC)
Date:   Tue, 19 Jul 2022 17:47:25 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Switch to node list walk for overlap
 detection
Message-ID: <20220719174725.31999b32@elisabeth>
In-Reply-To: <YtFL8OWnViZGma3g@salvia>
References: <20220614010704.1416375-1-sbrivio@redhat.com>
        <Yrnh2lqhvvzrT2ii@salvia>
        <20220702015510.08ee9401@elisabeth>
        <YsQmS4+qdFz8s+sN@salvia>
        <20220706231242.492ba5d1@elisabeth>
        <YtFL8OWnViZGma3g@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 15 Jul 2022 13:13:52 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Wed, Jul 06, 2022 at 11:12:42PM +0200, Stefano Brivio wrote:
> > On Tue, 5 Jul 2022 13:53:47 +0200
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:  
> [...]
> > This simplifies the handling of those cases, we wouldn't need all those
> > clauses anymore, but I really think that the existing problem comes from
> > the fact we can *not* descend the tree just by selecting key values.  
> 
> Thanks for explaining.
> 
> The traversal rbtree via rb_first() and rb_next() is like an ordered
> linear list walk, maybe it is possible to reduce the number of
> elements to find an overlap?
> 
> I'm attaching an incremental patch on top of yours, idea is:
> 
> 1) find the closest element whose key is less than the new element
>    by descending the tree. This provides the first node to walk.

I think this is almost correct, but we need to modify it slightly.
Consider this tree:

      A: 1 (s, a)
       /        \
      /          \
B: 1 (s, i)    C: 3 (e, i)

where, again, 's': starts, 'e': ends, 'a': active, 'i': inactive. Nodes
are additionally named.

We want to insert 2 as a start element, and 'first' in your patch
becomes leaf B, "1 (s, i)" -- not the A node, "1 (s, a)".

Now, depending on the red-black tree insertion implementation (I didn't
bother to check, I guess it should be independent), in the list walk,
A might come before or after B.

If B is before A, fine, we'll meet A and mark it as "rbe_le" (closest
from left).

If A comes before B, we won't meet A, and we won't have a closest
element from the left. This affects the overlapping decision.

The only ambiguity here is represented by elements having the same key,
and a set of such elements is allowed in the tree iff at most one is
active. So we just need to avoid replacing an active "first" by an
inactive node with the same key. Eventually, we'll visit all the nodes
having the same keys, if any:

> +	parent = NULL;
> +	p = &priv->root.rb_node;
> +	while (*p != NULL) {
> +		parent = *p;
> +		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
> +		d = nft_rbtree_cmp(set, rbe, new);
> +
> +		if (d < 0)
> +			p = &parent->rb_left;
> +		else if (d > 0) {
> +			first = &rbe->node;

			if (!first || nft_rbtree_cmp(set, rbe, first) ||
			    nft_set_elem_expired(&first->ext)) ||
			    !nft_set_elem_active(&first->ext, genmask))
				first = &rbe->node;

> +			p = &parent->rb_right;
> +		} else {
> +			first = &rbe->node;

...and the same here. Maybe we should re-introduce the "expired or
inactive" helper.

> +			if (nft_rbtree_interval_end(rbe))
> +				p = &parent->rb_left;
> +			else
> +				p = &parent->rb_right;
> +		}
> +	}
> +
> +	if (!first)
> +		first = rb_first(&priv->root);

> 2) annotate closest active element that is less than the new element,
>    walking over the ordered list.

The description looks correct to me, but I'm not sure why you add a
break here:

> -		if (d <= 0 && (!rbe_le || nft_rbtree_cmp(set, rbe, rbe_le) > 0))
> +		/* annotate element coming before new element. */
> +		if (d < 0 && (!rbe_le || nft_rbtree_cmp(set, rbe, rbe_le) > 0)) {
>  			rbe_le = rbe;
> +			break;
> +		}

we should stop here iff rbe_ge is already set, right? Otherwise we are
skipping step 3) below.

> 3) annotate closest active element that is more than the new element,
>    Stop walking the ordered list.
> 
> 4) if new element is an exact match, then EEXIST.
> 
> 5) if new element is end and closest less than element is end, or
>    if new element is start and closest less than element is start, or
>    if new element is end and closest more than element is end,
>    Then ENOTEMPTY.
> 
> Inactive/expired elements are skipped while walking the ordered linear
> list as usual.
> 
> With this incremental patch, I don't observe longer time to load
> interval sets.

Everything else looks good to me, thanks a lot, I hope we're finally
sorting this for good :)

-- 
Stefano

