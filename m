Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793469007;
	b=D5oRgAYSd/JuUqR0qAga5O+G1c6+x+a8MV+WlP7jq1YKRCqUdn5i/1XYkK61+tVS7E+8
	 do38af2ywxntuU2hdvMvGf6nafvEVpT1fvPsju9ikSWEOfVZAgkJosivsLlukiz2JsCeW
	 RsBQ+cmGsBygZMGjl/DxDR0hfHihBslkv0wzNTHj4f4C+OAKJm8PC/ou6GCvg3GA1UwnM
	 yNCOKxlXPNSTM38eaynZUwWo3M7Hj87sfXhfZLufKMs2nN5K2H3d97ZvuwiJzpfaMgIYd
	 X66p1jZh/Kbhw2obU1FpBQlJZa+Mv0mqRH3i8Pao7cyKcDC27/oLOQlwJbfXm8XxgeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793469007;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=a6S6zBkzaXWw79IkNdAVgoQcByVNihqtZsvrPAeoS6Q=;
	b=lgD5ybxJBMil+dUnDmnh9S8YXrTikcpVdP5hcPXL85nmgFsPJv881BxRTIzjFZUvmfcd
	 Fk+il2TnzwqoIeaJ36Vxne6PPHi+ZDko+9Q5fX6bTDI1OzhUGo3Jq73GFIY9CbEymrqnG
	 0jPd2A48F694/XuFdsC9qxYGO/UhaqX0xSUhU13ZbN4AJLQeofYgPwIgAt9MAnjZocjS5
	 yVGFREmzgZNHXdbq93UIn/ut0XiMwDUmWJv8Huh6/R4LD7uQalrRCOAQjGSzGEy7HDhKz
	 vBl3n0IXhprjJJPtgsmItYjSV75DSX352sLJr9jV38/FQxuANMiTERe7Y//f+dpZ46A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=GZ3a7I38;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CEC0D606A323;
	Sat, 31 Oct 2026 17:50:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEC0D606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=GZ3a7I38
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793469004;
	bh=a6S6zBkzaXWw79IkNdAVgoQcByVNihqtZsvrPAeoS6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GZ3a7I38eKFp561vuK/AXhasrUP+s7dSRtqh05f2QJWxzo/kuHQZdTcYJQg4gD587
	 pJPihY0p/mXlSkYcEE+z/vfltlZglXFsufYDfR1BVamzp8s0iYvZFgeVqx3HM2BJIp
	 3LJmYEIcm/0bROUm7RZuExGue9L4P5++P2jxLxNYjMcnhtket2iq2BHbIZ/zoRhYT8
	 Lw5D3e/EOh83AdB8rqpzLQQrDhzOy9jzmEjsHej2+3QWX391Gr6r9fi4buh196ckm1
	 B0K1hiNxIK45JvtHJeBzHicO9G3k8vKbVFYXc44nW/ICF1rbOeCU/bM8fkC3m/BGtP
	 kKdGHPTdDc73w==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 460A96007C;
	Sat, 31 Oct 2026 18:50:04 +0100 (CET)
Date: Sat, 31 Oct 2026 18:50:02 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: joasantonio108@gmail.com
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: do not pair an expired
 start with another interval's end
Message-ID: <auYqSpBFtC0nTDDd@chamomile>
References: <20261031-b4-nft-rbtree-gc-v1-1-51d087c187a6@gmail.com>
 <auYpCzdrOsoWr84Z@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <auYpCzdrOsoWr84Z@chamomile>

On Sat, Oct 31, 2026 at 06:44:43PM +0100, Pablo Neira Ayuso wrote:
> On Sat, Oct 31, 2026 at 03:54:05PM +0000, Joas Antonio dos Santos via B4 Relay wrote:
> > From: Joas Antonio dos Santos <joasantonio108@gmail.com>
> > 
> > Garbage collection of an expired interval start element also removes its
> > end element. Both the insertion path, nft_rbtree_gc_elem(), and the
> > commit path, nft_rbtree_gc_scan(), find that end element by its position
> > in the tree, and both can pick the end element of a different, live
> > interval:
> >
> > - nft_rbtree_gc_elem() walks towards higher keys and skips end elements
> >   that are not active in both generations. If the end element of the
> >   expired interval is being deleted in the same transaction, the walk
> >   skips it, passes the start element of the next interval and takes that
> >   interval's end element instead.
> > 
> > - nft_rbtree_gc_scan() remembers the last end element it visited in
> >   rbe_end, but does not clear it when it visits a live start element. An
> >   expired start element without an end element (a start-only element, or
> >   an interval whose end element was already removed) then takes the end
> >   element of the live interval above it.
> > 
> > In both cases the live interval [S, E) loses E: the set no longer holds
> > the interval that userspace added, and deleting [S, E) later fails with
> > ENOENT.
> > 
> > In the insertion path, stop the walk at the first element that is active
> > in the current generation. Elements added by this transaction are still
> > skipped, as intended by commit 60c0c230c6f0 ("netfilter: nft_set_rbtree:
> > skip end interval element from gc"). If that element is a start element,
> > the expired interval has no end element. If it is an end element that
> > this transaction is removing, leave it to the transaction. In the commit
> > path, clear rbe_end when a live start element is visited.
> > 
> > Reproduced on current mainline under QEMU (arm64, KASAN), from an
> > unprivileged user in a new user and network namespace:
> > 
> > - insertion path: add [10,20) with a 50ms timeout and [30,40), wait,
> >   then in one batch delete the end element 20 and add [12,13).
> 
> I don't follow.
> 
> You add [10,20) with 50ms...
> 
> and [30,40) with... what timeout?
> 
> you wait how long?
> 
> You follow up with another batch an you only delete 20?
> 
> >   Before: a GET for 45 finds an element, the end element 40 is gone and
> >   deleting [30,40) fails with ENOENT. After: 45 is not found, 40 is
> >   present and the delete succeeds.
> > 
> > - commit path: add [30,40) and a start-only element 10 with a 50ms
> >   timeout to a set with a 100ms gc interval, wait, then add [200,201),
> >   whose insertion walk stops at the highest element, so only the
> >   commit-time scan reaches 10. Before: the end element 40 is gone and
> >   deleting [30,40) fails with ENOENT. After: both work.
> > 
> > Normal expiry, and a new interval whose end element shares the key of an
> > expired start element (the case handled by 60c0c230c6f0), behave the same
> > before and after. About 39000 random batches on interval sets with
> > timeouts, with and without slab/page allocation fault injection, showed
> > no KASAN, lockdep or WARN reports with the patch applied.

Hm, no KASAN, no splat, what's the issue, really?

> > The insertion path issue was found with a small nfnetlink fuzzer. Both
> > paths had been pointed out earlier by the netdev AI review of commit
> > 86b6471e690c ("netfilter: nft_set_rbtree: skip transaction elements
> > during GC"), see the Link below.
> > 
> > Fixes: f718863aca46 ("netfilter: nft_set_rbtree: fix overlap expiration walk")
> > Fixes: 8d8540c4f5e0 ("netfilter: nft_set_rbtree: add timeout support")
> > Link: https://lore.kernel.org/all/179063970372.3145.17414936987144600093@kernel.org/
> > Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
> > ---
> > Tool-use note: the fuzzer, the directed tests and the analysis were
> > prepared with help from an LLM-based assistant; I reviewed the change
> > and built and ran all tests myself. Test harness available on request.
> > 
> > This is a resend through the kernel.org web endpoint: my earlier
> > submission of this patch was blocked by my mail provider and never
> > reached the lists.
> > ---
> >  net/netfilter/nft_set_rbtree.c | 23 +++++++++++++++++++----
> >  1 file changed, 19 insertions(+), 4 deletions(-)
> > 
> > diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> > index fbe1750f1..086823067 100644
> > --- a/net/netfilter/nft_set_rbtree.c
> > +++ b/net/netfilter/nft_set_rbtree.c
> > @@ -215,17 +215,25 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
> >  	struct nft_set *set = (struct nft_set *)__set;
> >  	struct rb_node *prev = rb_prev(&rbe->node);
> >  	struct net *net = read_pnet(&set->net);
> > +	u8 cur_genmask = nft_genmask_cur(net);
> >  	struct nft_rbtree_elem *rbe_prev;
> >  
> >  	/* search for end interval coming before this element.
> >  	 * end intervals don't carry a timeout extension, they
> >  	 * are coupled with the interval start element.
> > +	 *
> > +	 * Skip elements added in this transaction. The first element
> > +	 * that is active in the current generation is either the end
> > +	 * element of this interval or the start element of another
> > +	 * interval, in which case this interval has no end element.
> >  	 */
> >  	while (prev) {
> >  		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
> > -		if (nft_rbtree_interval_end(rbe_prev) &&
> > -		    nft_set_elem_active(&rbe_prev->ext, NFT_GENMASK_ANY))
> > +		if (nft_set_elem_active(&rbe_prev->ext, cur_genmask)) {
> > +			if (!nft_rbtree_interval_end(rbe_prev))
> > +				prev = NULL;
> >  			break;
> > +		}
> >  
> >  		prev = rb_prev(prev);
> >  	}
> > @@ -233,7 +241,11 @@ nft_rbtree_gc_elem(const struct nft_set *__set, struct nft_rbtree *priv,
> >  	rbe_prev = NULL;
> >  	if (prev) {
> >  		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
> > -		nft_rbtree_gc_elem_move(net, set, priv, rbe_prev);
> > +		/* end element is being removed by this transaction */
> > +		if (nft_set_elem_active(&rbe_prev->ext, NFT_GENMASK_ANY))
> > +			nft_rbtree_gc_elem_move(net, set, priv, rbe_prev);
> > +		else
> > +			rbe_prev = NULL;
> >  	}
> >  
> >  	nft_rbtree_gc_elem_move(net, set, priv, rbe);
> > @@ -911,8 +923,11 @@ static void nft_rbtree_gc_scan(struct nft_set *set)
> >  			rbe_end = rbe;
> >  			continue;
> >  		}
> > -		if (!__nft_set_elem_expired(&rbe->ext, tstamp))
> > +		if (!__nft_set_elem_expired(&rbe->ext, tstamp)) {
> > +			/* rbe_end belongs to this live interval */
> > +			rbe_end = NULL;
> >  			continue;
> > +		}
> >  
> >  		/* end element needs to be removed first, it has
> >  		 * no timeout extension.
> > 
> > ---
> > base-commit: c339f4010dea8b0d754f84ace70cd1b089878ef8
> > change-id: 20261031-b4-nft-rbtree-gc-1d9c72dba2bd
> > 
> > Best regards,
> > -- 
> > Joas Antonio dos Santos <joasantonio108@gmail.com>
> > 
> > 
> 
