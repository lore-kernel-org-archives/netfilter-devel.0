Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1B22ED842;
	Tue, 23 Sep 2025 11:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758627430; cv=none; b=COCXl4xoNivdgx5zGz2e8q21qAYW4oMCIy1Xia6tkal1uLwT33jzszU46g5lsorMcEfiBSKLCCCshp9wOGBn7QeQlTmlCyVSLGhsm+uGyT1fzUfkf7gil7NfQTNyvqgo9ACKjBMxLI9o77HxQObtTR+l0WAYxJXgLuvwjEEmObw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758627430; c=relaxed/simple;
	bh=uzUZxWdNwLXaq2vkcCdfykg45qz1g3WKbSfUMKaIkq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hxU7N5aRDuDCJstya27Zh6JyPJ2stwHT5PuI4NzC7NhK0Ju74erJqtRgn8XaGDiRBcza8ilfwhsaX+6/P6jr66TwEi5hjPzKnDL4MBpiavYnJtl9Ie07j4hr39NqY64H7SgA1vYWlq+10O0sG7DrbptGz4RLPfaAtuKbXGo2PNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 32F0E6061B; Tue, 23 Sep 2025 13:36:58 +0200 (CEST)
Date: Tue, 23 Sep 2025 13:36:57 +0200
From: Florian Westphal <fw@strlen.de>
To: Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc: Eric Dumazet <edumazet@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] netfilter/x_tables: go back to using vmalloc for
 xt_table_info
Message-ID: <aNKGWZSxY9RC0VWS@strlen.de>
References: <20250922194819.182809-1-d-tatianin@yandex-team.ru>
 <20250922194819.182809-2-d-tatianin@yandex-team.ru>
 <CANn89i+GoVZLcdHxuf33HpmgyPNKxGqEjXGpi=XiB-QOsAG52A@mail.gmail.com>
 <5f1ff52a-d2c2-40de-b00c-661b75c18dc7@yandex-team.ru>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f1ff52a-d2c2-40de-b00c-661b75c18dc7@yandex-team.ru>

Daniil Tatianin <d-tatianin@yandex-team.ru> wrote:
> > On Mon, Sep 22, 2025 at 12:48 PM Daniil Tatianin
> > <d-tatianin@yandex-team.ru> wrote:
> >> This code previously always used vmalloc for anything above
> >> PAGE_ALLOC_COSTLY_ORDER, but this logic was changed in
> >> commit eacd86ca3b036 ("net/netfilter/x_tables.c: use kvmalloc() in xt_alloc_table_info()").
> >>
> >> The commit that changed it did so because "xt_alloc_table_info()
> >> basically opencodes kvmalloc()", which is not actually what it was
> >> doing. kvmalloc() does not attempt to go directly to vmalloc if the
> >> order the caller is trying to allocate is "expensive", instead it only
> >> uses vmalloc as a fallback in case the buddy allocator is not able to
> >> fullfill the request.
> >>
> >> The difference between the two is actually huge in case the system is
> >> under memory pressure and has no free pages of a large order. Before the
> >> change to kvmalloc we wouldn't even try going to the buddy allocator for
> >> large orders, but now we would force it to try to find a page of the
> >> required order by waking up kswapd/kcompactd and dropping reclaimable memory
> >> for no reason at all to satisfy our huge order allocation that could easily
> >> exist within vmalloc'ed memory instead.
> > This would hint at an issue with kvmalloc(), why not fixing it, instead
> > of trying to fix all its users ?

I agree with Eric.  There is nothing special in xtables compared to
kvmalloc usage elsewhere in the stack.  Why "fix" xtables and not e.g.
rhashtable?

Please work with mm hackers to improve the situation for your use case.

Maybe its enough to raise __GFP_NORETRY in kmalloc_gfp_adjust() if size
results in >= PAGE_ALLOC_COSTLY_ORDER allocation.

> Thanks for the quick reply! From my understanding, there is a lot of 
> callers of kvmalloc
> who do indeed benefit from the physical memory being contiguous, because 
> it is then
> used for hardware DMA etc., so I'm not sure that would be feasible.

How can that work?  kvmalloc won't make vmalloc backed memory
physically contiguous.
