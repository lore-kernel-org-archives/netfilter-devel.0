Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077B934C124
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2026 20:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782332367; cv=none; b=WvIsD7LVi3d9dCQfng7xUfqM7WbE/G53Rp/aSwVXkU+U0h0LsAUePzRSyR1tlfPtc8WwEHryefCaJ1gcsqBI7vh/gvPlqaI7A7Xg6jFR+9eOp2yhJQu3HX/CfzyGNMj1dZYgzT8SKCeNKn+AZ4REGmM9VHWzVkI68O3w4ArsSM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782332367; c=relaxed/simple;
	bh=FlMDeQb9K4k/vE6w2o4uc4zqjjnhOAX4IM+gP9H4wL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dWua59ino8CyYw0SErkOzz7OUIE4wzE0OZ54gmsV5gZucBfeEtljoRlkbNO7Hdj1TZBFedeDuuW0ZX1+ptKiBwOfwJeI2XEgOZe6cAu5Aa5vJbhybFc00AIaDcwSmPKtBhPmYMBBKTj4yac3qDbQRI9I32zd4GkLIjn/cN0/5Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 694CA60491; Wed, 24 Jun 2026 22:19:23 +0200 (CEST)
Date: Wed, 24 Jun 2026 22:19:23 +0200
From: Florian Westphal <fw@strlen.de>
To: Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [BUG] netfilter: nft_fib: NULL-ptr-deref (GPF) in nft_fib6_eval
 on netdev egress hook
Message-ID: <ajw7y1y7E8yyasOy@strlen.de>
References: <CAEZyMPC0BQ=FO80mi3BVZaL4=T9y6=MYVL32St=Ck4w53hASqg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEZyMPC0BQ=FO80mi3BVZaL4=T9y6=MYVL32St=Ck4w53hASqg@mail.gmail.com>

Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com> wrote:
> A `fib' expression in a netdev `egress' base chain dereferences the input
> device nft_in(pkt), which is NULL on the transmit path, so any IPv6 packet
> leaving the chain's device hits a GPF / KASAN NULL-ptr-deref. An unprivileged
> user can set this up in a user+net namespace.

Please just send a patch to disable fib on egress.
