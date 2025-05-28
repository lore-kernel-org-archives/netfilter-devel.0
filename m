Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042562D052
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 11:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748430025; cv=none; b=QSshN4/TOndl6vsJvrhDNAHLQv2sw+yKSMH+pB/eYgkSBnislFF+lvRp2GjGRbrn1mw34C3EncxjpiK9YavHQNsVRiTa8XCP82irdbgZ81COzHu3O4u0qw3g/3Dp/aT50x0chbPYeSIYIBADcwiVhtEI+N6rPjKrWupJ8cuQjc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748430025; c=relaxed/simple;
	bh=/utpcydco5Mkw5PYHVxvF1yySsC2Hw01wHkza1JDQBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e0metE3YhrOJ3z4GnI95G+Tvo17ynAMw1OWIPwYjvdDLWfofUlLA+DRQIe5U+Ws1hioAAfgeJQDWVYLzp2tIfjSLkvWVKbztue9dHsrUVsAtNd2gLDRUwUaLsW2J4ZgjiwSHZHLoQkfv7bj4lqVlIjXFGmKLSzVSccWsJ+jYEjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1A0DA603F8; Wed, 28 May 2025 13:00:20 +0200 (CEST)
Date: Wed, 28 May 2025 12:59:41 +0200
From: Florian Westphal <fw@strlen.de>
To: Shaun Brady <brady.1345@gmail.com>
Cc: netfilter-devel@vger.kernel.org, ppwaskie@kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH v5 1/2] netfilter: nf_tables: Implement jump limit for
 nft_table_validate
Message-ID: <aDbsnUr2u4PLq82Q@strlen.de>
References: <20250520030842.3072235-1-brady.1345@gmail.com>
 <aCxTJcL2DnSsquNe@strlen.de>
 <aDZ3RUtjD3rHjgUc@fedora>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aDZ3RUtjD3rHjgUc@fedora>

Shaun Brady <brady.1345@gmail.com> wrote:
> On Tue, May 20, 2025 at 12:02:13PM +0200, Florian Westphal wrote:
> > LGTM, thanks.
> > Acked-by: Florian Westphal <fw@strlen.de>
> 
> Much thanks to you for your feedback and patience.
> 
> Double checking... is there anything else for me to do in regards to
> this patch at this time, or is it in the hands of the merge process of
> the team(s)?

I don't think there is anyhing left do do here except waiting.
As 6.15 was just released I'd expect that there will be a backlog until
the development trees have been re-synced with linus tree.
