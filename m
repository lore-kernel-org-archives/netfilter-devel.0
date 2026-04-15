Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1622336885;
	Wed, 15 Apr 2026 09:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776245277; cv=none; b=FAyzdrRAmQIdr2eG2a+xiO7h5OVePAov3vD7KChmxd6kP76uqEp8c4OUIBp0BXZelZxhGts1rtLTzyQLvIuxj5S1njtzvkWYDbDM7wQdKsMHUFvmKETVXrsAUET4Tl6ZXfDAQOjPcbBwPby5GW9J675aVuLnEM62inQEEy0DsZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776245277; c=relaxed/simple;
	bh=dBNjQpcGVzZmyySbeD6As/Vlll3k5aPtVy+af3LGChw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8G8ZRqmCagE4q8HyMMl2sjSXdyQjXJElvrmed0BZszI7JIogp/f8/k/OwWbVKfQQS+hEGSSr5x9UcZw1PZ1RPHkOmu0EE6JXbzek+pej3ZsylICCNzenQpmaMxANp62iEl9O9Yz++hxc5BQmZD8sPbowon3k+1lApxqBsKTjkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=f4mFmVei; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="f4mFmVei"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5D21060177;
	Wed, 15 Apr 2026 11:27:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776245266;
	bh=I52o/2B0lRR/NgWzkPZzO+TvuXHI3Zo6Deb7BqjgfZo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f4mFmVein2DchFlYoWmmu6Ajn4aQHXOijnksTtIGAmLl6MmO2JfkRM0Dfs35/HhKB
	 3GzOtwKIf4AYT3pVEC/Umesu85K5+nAnBM3PCM2fMam7LRQ36Zjr8ebINsw37qpZpi
	 r4vs5cXrxjl3QX+DKbI1l0u35Go9CwtsvaM2s8sQ4GAsA1XWXohYIN7bcHz0RfHWDe
	 1uUU33lBS8kkr/bs8Uq/oZZllXFzkh4U7e27Nm+0qQsHorlle1hbknGNK0IaWds3RN
	 +sH/Pn7RCAb8F2/AzrZ2kuP0VJHGRSOvkrg9dVRpIx3JF52Co+NO6MHzHG9NhbFCfH
	 Zf16+wgOW0Hsg==
Date: Wed, 15 Apr 2026 11:27:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: "Kito Xu (veritas501)" <hxzene@gmail.com>, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, jengelh@medozas.de,
	kaber@trash.net, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: xt_realm: fix null-ptr-deref in realm_mt()
Message-ID: <ad9aDziQEBR0h3U8@chamomile>
References: <20260415034343.107920-1-hxzene@gmail.com>
 <ad9UF5Cr12YGJnbi@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ad9UF5Cr12YGJnbi@strlen.de>

On Wed, Apr 15, 2026 at 11:02:15AM +0200, Florian Westphal wrote:
> Kito Xu (veritas501) <hxzene@gmail.com> wrote:
> > realm_mt() unconditionally dereferences skb_dst(skb) without a NULL
> > check. The xt_realm match registers with .family = NFPROTO_UNSPEC,
> > making it available to all netfilter protocol families. Through the
> > nftables compat layer (nft_compat), an unprivileged user inside a
> > user/net namespace can load this match into a bridge-family chain.
> 
> I do not think this bug is related to nft_compat.
> You can also use ebtables setsockopt api to request xt_realm, no?
> 
> > Fixes: ab4f21e6fb1c ("netfilter: xtables: use NFPROTO_UNSPEC in more extensions")
> 
> Looks correct.  Alternatively we could revert the xt_realm.c change.
> But I don't have a strong opinion here, patch looks correct.

Maybe partial revert makes sense, since in ab4f21e6fb1c:

- xt_MARK: OK
- xt_NOTRACK: OK
- xt_comment: OK
- xt_mac: There is a better way to do this in bridge.
- xt_owner, no sockets in bridge.
- xt_physdev, which makes no sense in bridge, this is for br_netfilter
  only.
- xt_realm (as already mentioned).

That is, a partial revert of this patch for:

- xt_mac
- xt_owner
- xt_physdev
- xt_realm
