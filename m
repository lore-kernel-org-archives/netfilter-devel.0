Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1B386250;
	Tue, 16 Apr 2024 09:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261466; cv=none; b=NI03QTVDfUEMJ8ZnO+KDY0jJrMR6jCBQWxRK/RaY5cyOZHS9OFbD/z6uv+JUY2a1rwyAHgyI340yEIY1tVoyE5IBAKq05l4yHhbm1viXf1kJfGWvqG39Q8kE784LmFste5yMKGE9BmOa3CXUSQsXn0GlTHuUe84X4ItQtjI3XzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261466; c=relaxed/simple;
	bh=C4buNi5HQaB9xUouhHdqLHIvKmxLD2IZol+trZBEkBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LgTzRZgZJVFQfthw/iRAHHIGwVNTKEo6jqzzsU/QUQE5Oqq7Dd13W9G6YykT/sH5kCdhhveUIogUL7yljYc3T6WFmzvDFBQCTNEDVZEbgV3mdjFuUNsrGr5mjLuQVuNLoPBHpSHk8IAIQg9s7gw835uX51AHy4o1PCjALRdOFJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rwfZD-0005fV-8Q; Tue, 16 Apr 2024 11:57:31 +0200
Date: Tue, 16 Apr 2024 11:57:31 +0200
From: Florian Westphal <fw@strlen.de>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next 01/12] selftests: netfilter:
 conntrack_icmp_related.sh: move to lib.sh infra
Message-ID: <20240416095731.GD27869@breakpoint.cc>
References: <20240414225729.18451-1-fw@strlen.de>
 <20240414225729.18451-2-fw@strlen.de>
 <ce433aee-b478-4fcf-b8e1-3b38bfca795a@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce433aee-b478-4fcf-b8e1-3b38bfca795a@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Matthieu Baerts <matttbe@kernel.org> wrote:
> According to the patch title and description, it looks like something is
> missing from the diff below where on the 'config' file is modified, no?
> 
> Same for patch 2/12 where we have the opposite modification.

Rebase artifact.  Jakub/netdev maintainers, please toss this series,
it needs more work, I can use this opportunity to also update a few
scripts to skip instead of failing when requirements are not met.
