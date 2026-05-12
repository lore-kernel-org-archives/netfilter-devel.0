Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5528518FDBE;
	Tue, 12 May 2026 22:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625298; cv=none; b=au3oBThFBpyJiLkiWhPyxIqtoaZNNOVGFooesWbZFoEjEfpzqRqLwFX9jZmeiJ7mCtzf5eZ0IJtKZc7/B8Erg2QHg+I0Vw+5dpXnDIcNPQjdxKcy6QEHD+lxCYxJQjFGkPvqGu0mP+gBLb8PiW8+Y3+zrmipCKms5epH1vB2pHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625298; c=relaxed/simple;
	bh=yM4EY2MtDT2Zz5c/4rjQGXadlJdTbzZk3De04r3eydw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=duWNW/NmG+NjaLPZHKZHi3IGw9DGiAKzY4BPtX4++u2sJTwTuG2hyUhy4czEbd277qwDsTZB3+WgIfGiMrjAj0XT7ESsaJVjaORai5wqwMPFQOFUZj5Ma+QlvWo46rVUX7/cFRWFyqjwohDWj5KK+Gsayy9NAZGuMgHHw+pw7D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MwpfKNJC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MwpfKNJC"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 80B3D6017E;
	Wed, 13 May 2026 00:34:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778625293;
	bh=vJK2MYl96uRINNgCn5RvCAPzOnNEEK3vqFvq4ILrQcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MwpfKNJCSVrjPQUiQArFjwN6xjLt0mrhF0/yDq/8NSckN90yp937w2GCapZErfxd0
	 146y3OMmEKwoZBiv8pQGJSFaSbLYBNsPsYv0rzjdIqH8RV1u1XEjkYteQeoDQRDgt1
	 p3+7E9rY01rQD46BaxFjbu1IwmPXRyPk3B93bj91uc/ZjfCrqimf1rYc/1TSL58ihk
	 FdLyaTocDdgbzq3oi8uVygRdsVViUKSwF+FNq4f9WDEeaSMVzLDeC+9T0JCy6H7ROk
	 E/LIX8kVzCj8hoYfoicGWP7I8Tc282J2gjS/l1o7AbBUjLgWbhrlf92EmuL4eQbIQM
	 Qdmaz5rZ0GSCQ==
Date: Wed, 13 May 2026 00:34:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Maciej Zenczykowski <maze@google.com>, Kees Cook <kees@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] ipv4: harden against ihl < 5 IP_HDRINCL packets
Message-ID: <agOrCj3YoMAxsxYf@chamomile>
References: <cover.1778614451.git.michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1778614451.git.michael.bommarito@gmail.com>

On Tue, May 12, 2026 at 04:51:13PM -0400, Michael Bommarito wrote:
[...]
> Open question for netfilter / netdev
> ------------------------------------
> 
> After patch 1/2 lands, a caller with CAP_NET_ADMIN can still
> deliver an ihl < 5 packet into the post-LOCAL_OUT in-stack path by
> attaching an nftables payload-set rule on NF_INET_LOCAL_OUT (or an
> NFQUEUE reinject on the same hook) that rewrites byte 0 of the
> IPv4 header after the raw_send_hdrinc / __ip_local_out validation
> has run.

There are possibly more ways to mangle ihl in the kernel in 2026, not
only NFQUEUE and nft_payload.

> Construction:
> 
>     nft add table ip mangle
>     nft add chain ip mangle output { type filter hook output \
>                                      priority -150 \; }
>     nft add rule ip mangle output ip daddr <victim> \
>                                   @nh,0,8 set 0x40
> 
> I reproduced this separately with nftables payload-set delivering an
> ihl = 0 packet to xfrm4_output() and onward.  Patch 2/2 covers the
> AH consumer; other consumers that read iph->ihl after the LOCAL_OUT
> hook may be similarly exposed and I have not enumerated them.
> 
> Direction question rather than a fix proposal: does basic iphdr
> re-sanitization after a header-mangling hook belong in the netfilter
> machinery, in each in-stack consumer, or both?

Your patches LGTM, are you suggesting more patches?
