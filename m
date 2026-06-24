Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D4421638D
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2026 21:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782336669; cv=none; b=gk6y+uFxSGfUpqSSfcPzGDXJsfS9XBY9PhROaqAXG2bhdotlt9EpDC7VmcIbo+itRqA48YKyyZ3Q/yUjjlpL9E/zdKXvraHGRhiO50uYqVLlVxZVjARkXCSzLflVY3P3rs8Cl9qkfhU19MyYv6qpWtZDyFqqO1p/OSwnaNDCs2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782336669; c=relaxed/simple;
	bh=qdKt4kcQAAO76syqAJp3aVoqgd1BbTa+r4iaXaObROs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJrsmsuEswGvKjIS4ckTlBdReisSpP2affiZai4n6l8Z0ngb4evNcoQe0efOdF56hV9FRNgK2loRJMZUDoM1/0+I17pPowD26FZI/2t+bejRwfJlKwGKON3droAHvSHXia1kBX7eDl8EiO2QGhUnUcLit2LTa/Qzz+HdjNXlXg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6916360491; Wed, 24 Jun 2026 23:31:05 +0200 (CEST)
Date: Wed, 24 Jun 2026 23:31:04 +0200
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: netfilter-devel@vger.kernel.org, Seesee <cjc000013@gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: don't leak bad clone into
 future transaction
Message-ID: <ajxMmKGdInWPhe3b@strlen.de>
References: <20260616191938.2875-1-fw@strlen.de>
 <20260617075123.7a62e22c@elisabeth>
 <ajJUklUUmvafRVi9@strlen.de>
 <ajxEbCY0yNsrsxx6@strlen.de>
 <20260624232234.27a3a883@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624232234.27a3a883@elisabeth>

Stefano Brivio <sbrivio@redhat.com> wrote:
> I've been working on it on and off but it's more complicated than I
> thought (and I could find less time than I thought). Sorry. A v2 would
> be very appreciated for the moment (but even v1 was okay I think).

Understood, thanks Stefano.  We can followup later, lets go with this v1
then.
