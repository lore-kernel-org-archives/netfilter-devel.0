Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50CC69DFD;
	Wed, 31 Jan 2024 11:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706700168; cv=none; b=kPqyZbldHFGJpRFAK3cyx3+lETt01q/fwc6edaflUJcrJA3ddWCaFrz07Qw0pi8RhpqKbPJqU/u6n8AToINPJ4NSS+XSkb0OmBmcnQZXfjhVTLl8kx+C8mc4gLowuUmXFnw/ism5/Um/DTvkurKbCMnlL98RyY4ZHejvBGhU0ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706700168; c=relaxed/simple;
	bh=kIcKX12zPKoVcrRmauHy5r15bYlG4J7HoTqZyLhhMws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KYBO9VJqlI9HttyIyl0w32FY7SvWa3rB7OLiOC4EGOugLcc37EvpqzQc4APrUghU5QNhYYJxAs1ebNLmKNpyxFbHOyb43GnX2XFjhSWELDcfwzsM2mZ5MDC1+Lcc0Z6wbRtRafspNlfNVzs1ph89AUC7bU2R7vBtrVZQTLZCHnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rV8fl-00010D-Tw; Wed, 31 Jan 2024 12:22:29 +0100
Date: Wed, 31 Jan 2024 12:22:29 +0100
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/9] netfilter updates for -next
Message-ID: <20240131112229.GA9524@breakpoint.cc>
References: <20240129145807.8773-1-fw@strlen.de>
 <20240130183729.5925c86d@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130183729.5925c86d@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 29 Jan 2024 15:57:50 +0100 Florian Westphal wrote:
> > Hello,
> > 
> > This batch contains updates for your *next* tree.
> 
> The nf-next in the subject is a typo, right? It's for net-next?
> Looks like it but better safe than sorry :)

Yes, should've been *net-next*,  used to typing 'nf-next'...

I've updated local plumbing to refuse sending if cover letter
is absent or lacks PATCH net(-next) in subject, so this should
not happen again.
