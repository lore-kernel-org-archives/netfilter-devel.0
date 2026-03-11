Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB1B32720C
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 16:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773245475; cv=none; b=UCVdTfn/inpXSKbwMwYwzBmX4iJhq9htjZEELLsrdUtZPobb4B3vy+xm5OcvzTsg6gUaq8u64bSuIEzQ0gEA9xKRls5pKBNx38xEknEU9gyIU7Se3JDX3zF38Pek3OWr4O3gJPGdcMOutF8azavMEUY2txR1RMNO9WaTlitTyes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773245475; c=relaxed/simple;
	bh=ZXJw0/WwAuHp1Eot1/pghvdqbvlcl2XqmQs+Dr/JbaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uE/SExO5Vk7Pc5ar07G5+IaK/A9H/ot8CDlzpeHNW7UTEkOJob8VuYUDiGBOsEqTmyFmpW8XNrPHDofbLHEeRuV87eAhrtX57Ikd6j4D0kioNg1OdCy5wrl/BGaLU2Yl4IPPpqiVbO3bvZXn2ITPXmzOM9EpOAg6H/Mqm7N6jz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=F2RTeDav; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="F2RTeDav"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id AA3E2603C4;
	Wed, 11 Mar 2026 17:11:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773245470;
	bh=iBrXZ7Ir8U1IospeUqCMetA9mZR0M5BukVUrOWJyqCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F2RTeDavaE9292Z/TtjWCZpt73YluRkoN5rHVaU5Yw+aP0L+dFzoGHbLAJw3Tcxfl
	 ZnFDQ3Y3gBW6+6IMfcQ7cnjMKtTT0HW7PJMlA7tz2bbgg1xiE78Y3MyiN8XiKVNC3d
	 qsEBKVOlKUi0/AAJkxAfsl24OgS8HeTPOdlA2d4p7eqHWRBjXVLQufK8OXdRfJQIVQ
	 IhDeNr5zCC32saCiidGR+rus8yk7b5JknKOAb/lg9qN2eLR5mCaF09KcC0cBRQ2bRJ
	 hfUaQzPS37h9wrRc3DCMj7THbuf76dSpEiR79tgWSuoxxo02qRRWNy4K6zj9PeiDgz
	 tOVv+MfxpUTlQ==
Date: Wed, 11 Mar 2026 17:11:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: revert nft_set_rbtree: validate open
 interval overlap
Message-ID: <abGUHMhlXQDdVr2V@chamomile>
References: <20260311152916.17696-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260311152916.17696-1-fw@strlen.de>

On Wed, Mar 11, 2026 at 04:29:12PM +0100, Florian Westphal wrote:
> This reverts commit 648946966a08 ("netfilter: nft_set_rbtree: validate
> open interval overlap").
> 
> There have been reports of nft failing to laod valid rulesets after this
> patch was merged into -stable.
>
> I can reproduce several such problem with recent nft versions, including
> nft 1.1.6 which is widely shipped by distributions.

The culprit is this bug in userspace:

  e83e32c8d1cd mnl: restore create element command with large batches

At the same time, 1.1.6 is broken because of this bug _regardless_
this patch.

> We currently have little choice here.
> This commit can be resurrected at some point once the nftables fix that
> triggers the false overlap positive has appeared in common distros
> (see e83e32c8d1cd ("mnl: restore create element command with large batches" in
>  nftables.git).

Yes, we can just wait for the userspace fix to propagate, then merge
this in again.

It is very unfortunate that this userspace bug in the way.

> Fixes: 648946966a08 ("netfilter: nft_set_rbtree: validate open interval overlap")
> Signed-off-by: Florian Westphal <fw@strlen.de>
>
> ---
>  Pablo, if you prefer a different approach, e.g. just axing
>  the relevant check instead of full revert please let me know.

I can think of workaround such as adding a temporary sysctl knob
to disable this... but it is ugly.

Probably it is more sensible to revert temporarily and wait for a bit
of time for the e83e32c8d1cd userspace bugfix to propagate downstream.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
