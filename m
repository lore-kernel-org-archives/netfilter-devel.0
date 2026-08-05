Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2313911DD;
	Wed,  5 Aug 2026 07:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785913918; cv=none; b=Ohu8cNYHEzB7zf/VLrX4ZLGbcbwdvjWk33VEWqitYzZfeJjV/cHZBxYDPl/WdHOX7VFmpAkJhL2ivTzoaxEIHbuk3DJJJvTdeRokNpT3gRyjs24GM6+s3ZMTM/TEmiIPtqNSJoe0PQGao8jlm18ZtkcQDe8a4G7IRwsocGyO+Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785913918; c=relaxed/simple;
	bh=Pk5L6Twl0FWSRvCe739DtyGesnF4cZgfc2xqWqurSFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OY+0zC0Xrvz3Blu9YRbyabY/RdeM6kq5zyW11XOgkHulXy+WsvJLE734zjAk4y6kUZb8uWFmeI89yJAouqFBRneCXgNyQ4Ej1DoaPkWvtcdvf/8tb8lNTatMdzqhIfIq6M6J8Bmz3A0XRt+X32MPWSNg/119xYU9/QDhUCC6uOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 419006051B; Wed, 05 Aug 2026 09:11:54 +0200 (CEST)
Date: Wed, 5 Aug 2026 09:11:53 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org
Subject: Re: [PATCH net 02/10] netfilter: ebt_nflog: pin the NFLOG backend
Message-ID: <anLiOdg5xYKNoNLL@strlen.de>
References: <20260731151806.849724-3-pablo@netfilter.org>
 <20260805001529.3978646-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805001529.3978646-1-kuba@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: ebt_nflog: pin the NFLOG backend

We need a way to annotate patches that they have known followups.

Either that or we will have to start sending much larger diffs that
change multiple things at once or we have to send much larger batches.
