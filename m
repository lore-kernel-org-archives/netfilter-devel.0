Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A441E32CF
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Aug 2025 11:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754565300; cv=none; b=awOIBslBmftlMUoXwa8gfxwvqb+RGXHMvRv0k5HXxS4ZNLkPnhkxH+Ukf0HS/oz5NfzHhf62LVM/itD5ikF13Z212ZftkuyUEb5kPA/fACz8/Y4SAbik9Hvwz3L+TrAmqwO8KC46lNXNE/w6A3EXU++H4FmWuZKx8913LMceKws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754565300; c=relaxed/simple;
	bh=zb572mMGynRAjLBLmBtGqZuSOiRZ43YKHq3bS8wxnJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=syUUtemV+YyvTZeuE4JbuIDM/umSNIh5P/LRPzNFYt7czEb5Uc6T+6nSb3whxa2WEm+1uF7Olj4itL/+JBBVL2i8LoQnTK/ZhkQAU1bd3GD4kVUqKOzWdVqiFLkhyJztW6ta6MduC8IKLL6gQ/6z72S9pKk4eMWj3utbLuxn7/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=upYuA1G3; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=upYuA1G3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="upYuA1G3";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="upYuA1G3"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8B595605F3; Thu,  7 Aug 2025 13:14:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754565296;
	bh=NEfdj4PAFxbjpfZQW7WJIN7qNjDTMJwZL+w6AQu4m00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=upYuA1G3i/QSz57Y5mrZBxfOpispNFi6+p2wFrrUzHe58ZUubNoeNlmEF2lJuBWKT
	 bVhHoTWOVLTgkbFlwTbH1ycumuks1K74eu4wkbLU7LJ9eqTgfnyt5tkov12+yZZtvv
	 Sy6P2otkeTNI+r9lmedYYP3CVaaBnqfhYRLlglL75xZZmADUkTNNX7xVLfqq8n0k66
	 5dn3YEJTTZO+I+HaUE+kf7Ihc5vW0qQU2kAxmVWfioXtQyBXYy4Z3ugT7NwNclMg2S
	 LnD1FaCpy5wBxO1JDpn9fvKEi6j+4C4dvjvhl7p6khUW5izLJExxEnUPykgdOPHIIu
	 leDYKSBcZ3GEg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E1BB160289;
	Thu,  7 Aug 2025 13:14:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754565296;
	bh=NEfdj4PAFxbjpfZQW7WJIN7qNjDTMJwZL+w6AQu4m00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=upYuA1G3i/QSz57Y5mrZBxfOpispNFi6+p2wFrrUzHe58ZUubNoeNlmEF2lJuBWKT
	 bVhHoTWOVLTgkbFlwTbH1ycumuks1K74eu4wkbLU7LJ9eqTgfnyt5tkov12+yZZtvv
	 Sy6P2otkeTNI+r9lmedYYP3CVaaBnqfhYRLlglL75xZZmADUkTNNX7xVLfqq8n0k66
	 5dn3YEJTTZO+I+HaUE+kf7Ihc5vW0qQU2kAxmVWfioXtQyBXYy4Z3ugT7NwNclMg2S
	 LnD1FaCpy5wBxO1JDpn9fvKEi6j+4C4dvjvhl7p6khUW5izLJExxEnUPykgdOPHIIu
	 leDYKSBcZ3GEg==
Date: Thu, 7 Aug 2025 13:14:53 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_socket: remove WARN_ON_ONCE with giant
 cgroup tree
Message-ID: <aJSKrfLfML1CEYLk@calendula>
References: <20250807100516.1380006-1-pablo@netfilter.org>
 <aJSBzdY6FvFHvhZ9@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aJSBzdY6FvFHvhZ9@strlen.de>

On Thu, Aug 07, 2025 at 12:37:08PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > syzbot managed to reach this WARN_ON_ONCE with a giant cgroup tree,
> > remove it.
> > 
> >   WARNING: CPU: 0 PID: 5853 at net/netfilter/nft_socket.c:220 nft_socket_init+0x2f4/0x3d0 net/netfilter/nft_socket.c:220
> 
> I looked at the repro and as far as i could see it just passes
> a large NFTA_SOCKET_LEVEL attribute value.
> 
> I'd propose:
> 
> syzbot managed to reach this WARN_ON_ONCE by passing a huge level
> value, remove it.

I guess it is both, huge level value and giant cgroup tree.

Anyway, I take this description.

> Patch is correct though.
> 
> Acked-by: Florian Westphal <fw@strlen.de>
