Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794502193;
	b=IYgmbrnfdc5+Xu0bm5pcdy7GoJ8rZDA/5px8PFv1cVDG25ceOvxB+G5wqWXvSV2TK99W
	 k5jgwKr+dwQ3Qr/U3VGSidUkVxPw0z8AMylC6z+u359O496IeMiR/b0g6cXJXg8Jxbecr
	 zyOVllWm3Z4OZ/Hb/HCOURUvp5iKjs0MhQfAyJ0Ton5buVDTNgFsIbC6AY7DsZh1l7bFb
	 jNgdYczNZk1gbFdIQsu7FXS6zX6E6k53YbqY3tdRUZOifTUxKIK/81sUqx6xiZU7QAHv2
	 8MCoS59GvZV9RR6xEMQvOlx+keH+I1Qurxiv4qfOLGVCqwUA7vGPKu8UO8KvFaQRuSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794502193;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Lp1IM8/kp/DawyqAus9VFvByLW/NMJN/SUOFGEsMQmI=;
	b=SAdjeaCt/3y/GroOfLc/vk6xlmoBoiqkaUc9o2BmeMS7M/nyI1L73zB4oENiCmNwYIU/
	 KaRyicfD4hDj9l+MSXbQHv0r/ewu5jdpS7v6b1XBD59ZeTBjGXdtjp9qIEj3QDCUy7OEc
	 o3xvK7lIWJY5VySQh2QIHThHr96dCXjxI+RpiiSdqp74zD98oc37hktCvE9yrzat/8oBj
	 77IUGNx5mXi6/qMOHLcBsCeXwlqL+EvSR6HR/CzBSmcBx4z1WX8iuM9SbkJk7Ov+kfVqj
	 SnRi1813QsQeZrcm3i40o5EMCbHdLYfuUm9cB1CubMJKpp08HtQJ7FC1oehq3DclS9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25D4606A323
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 16:49:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C25D4606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 38CAE6028B; Thu, 12 Nov 2026 17:49:50 +0100 (CET)
Date: Thu, 12 Nov 2026 17:49:43 +0100
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v10 0/6] ipset: replace internal hash table with
 rhashtable
Message-ID: <avXuJ0GBdzyxK-_w@strlen.de>
References: <20261112143818.30638-1-fw@strlen.de>
 <9a882426-58aa-c14d-fe99-64538c98d293@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a882426-58aa-c14d-fe99-64538c98d293@netfilter.org>

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> In my opinion the patches should be applied to nf-next: the new method 
> passes all the tests, no functionality lost and it evicts all the issues 
> in the old code. There's no point for further tuning.
> 
> I'm absolutely grateful for your hard work, Florian!

Thanks Jozsef!

I pushed a few of the test updates to ipset.git, but not this
3-part-series:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20261111101603.22698-1-fw@strlen.de/

First one passes on either rhashtable branch or main, but I'm not sure
it should :-)

Resp. I'm not sure what the contract/expected behavior of net,iface set
type is when the address matches the net/mask entry, but the interface
doesn't.  I followed existing behaviour, so that test would enshrine
that: it stops matching more candidates.

I'd prefer if you could double-check that the semantics that the test
is checking are sensible/correct.

2 and 3 fail on main, in both cases I think these are bugs in
the existing implementation.

Thanks Jozsef for your help!
