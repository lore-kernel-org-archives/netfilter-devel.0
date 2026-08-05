Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29961F09A5;
	Wed,  5 Aug 2026 17:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785950377; cv=none; b=t4NeM9trnrAKMWMhRnWqW6uv7z3NAGQCM5WwsnjMDPFsJ5qUE9DXohQXrhbZlmGGOcJqARwyf+1SM6VQK3L4eiDFsw7oPaosk3jH4SBTLBlGGR12eInwzLV71jxZShOiJsFqMkIQly7H2XhyicKHT9mKvKyFYJFVlC3xKQQyjLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785950377; c=relaxed/simple;
	bh=CEt6nLJEKwR0/qOzap0ZG2vzS92Fkf+f6IETzWawfvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E8lzkNdq5dIcEpxBVW9prgvBtKYDsOnZthSU7lpNKWksx8xqslN/jVGxWn4pAJ6n/JgD0MFwlL/nSpRDxG82iDtBhq0nIc6uhpWYf6qWZ4pxhheeMCrzYdWT4Xtrnyd5t6AXI+rIT55VVfjmI48FGxqxZqCCJWmIYRGgN+ovXjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Zus6X5v3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Zus6X5v3"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CDD4F601A7;
	Wed,  5 Aug 2026 19:19:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785950374;
	bh=3D9SEFgX/A0nraUayIIrKMfy//g/27Rh48xOOf6cf8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zus6X5v3kT5Y2rJGPDV06QaMN5pgau9UMb2sOpJuU/A6/7enqFB8HNMB52pdIsDB+
	 e8IAv4qwXpbSplnmNWu4+XKQ9GedpD9UrkjcmF3S9T3mOp8KJAKU7r1svJurbPJRDI
	 1AYS1gIshR61beqy3rGBV6Ze9l+0F7si//cI/zhQyW/7UDWuL+1JS+2PBY96dalCs0
	 4Fl+qtCuTOt6bhyH5rHylTrXq8WbHvMCXFbCvsrURHDbuD/mAaMG+fHUZYVN1WPf3M
	 NpcgUmt79r0+r/dkXA6yXLSmAA9O6KaTLiYzepv2x/ggboakU8CfBQUXuU2/DsgLUR
	 2Si+KVHsLHtmg==
Date: Wed, 5 Aug 2026 19:19:31 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net 03/10] netfilter: ipset: rework cidr bookkeeping
Message-ID: <anNwo7eKRm5HqOOD@chamomile>
References: <20260731151806.849724-4-pablo@netfilter.org>
 <20260805001531.3978750-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260805001531.3978750-1-kuba@kernel.org>

On Tue, Aug 04, 2026 at 05:15:31PM -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: ipset: rework cidr bookkeeping
> 
> The prefix bookkeeping of the hash:net* set types is moved out of struct
> htype into separately allocated, RCU published struct net_prefixes arrays.
> The in-place shifting of the cidr array is replaced by allocate-copy-publish,
> with a documented fallback to leaving holes when the allocation fails.

Florian needs these starter ipset patches to follow with more fixes to
move ipset hash to use rhashtable.

For his workflow, he considers it better to do this incrementally.

While this is not perfect, we prefer this path to address the existing
issues that LLMs have reported in ipset.
