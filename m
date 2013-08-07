From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3, -next] netfilter: ctnetlink: attach expectations to
 unconfirmed conntracks
Date: Wed, 7 Aug 2013 16:40:17 +0200
Message-ID: <20130807144017.GB29345@breakpoint.cc>
References: <1375883010-21852-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>,
	Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60640 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757487Ab3HGOkT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:40:19 -0400
Content-Disposition: inline
In-Reply-To: <1375883010-21852-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This patch adds the capability to attach expectations to unconfirmed
> conntrack entries. I'm using this from nfqueue, in that case the packet
> is retained until the user-space application returns the verdict on it.
> This patch is required by conntrack helpers that trigger expectations
> based on the first packet seen like the TFTP and the DHCPv6 user-space
> helpers.
> 
> I don't see any practical use for this out of the nfqueue context as
> you won't likely find what you look for. But if that ever happens,
> we have to bump the refcount to avoid holding a reference to an
> invalid conntrack.

[..]

> +	hlist_nulls_for_each_entry_rcu(h, n, &net->ct.unconfirmed, hnnode) {

Its possible that "h" has just been moved to the conntrack hash table.
In this case, on nf_ct_tuple_equal() mismatch, then next element might
be a bucket NULLs value, i.e., __nf_ct_unconfirmed_find() might only
have checked 2 out of 1000 entries on the unconfirmed list.

Theoretically, you could avoid this by checking if the nulls

> +		if (nf_ct_tuple_equal(tuple, &h->tuple) &&
> +		    nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)) == zone) {
> +			ret = h;
> +			break;
> +		}
> +	}

value is the right one in the "no match found" case, and restart the
search again.

But I have concerns about the expected run-time behaviour on when
you machine has a high new-connections-per-second rate.

If this is only used from nfqueue, can't you re-use skb->nfct?
It would avoid the unconfirmed list traversal.
