Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233C167A0D;
	Fri, 30 Aug 2024 17:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725037635; cv=none; b=U23fuxX1zhzK+njGEifJofSURYVwgu7/PVBGfZISePtb8bDGrwhX2D1yb5EDOanpYM2W8L1ycKRj1ztm+jdtVFTTT2b6eh/OdggEeNwyGW0BZvwiN12OSWlEVz3VPaUX5CtrNsQx4GqWgPxMZ5UU5Q66RiIOx+8ZiRPbgxxoC9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725037635; c=relaxed/simple;
	bh=p+Aly1DCwQO242o2hNdvPiR0AFUre9Qn/CBGycQGrE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kq0dhhu3m8pJTID9P9YftNrXhnkxTcZ934k+rjbwpskOzss26jANzgb27uX7OfMooRWYIDnq8emlR1njVb182GiN9o7F85c/qIanaIogPboMDFftsKf0xQODoTjNkLhUn3c0E40eSn1cKFkPGLUibZ2zZCLSY2bT2RemmwdhzHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eDyINtfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eDyINtfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BF6C4CEC2;
	Fri, 30 Aug 2024 17:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725037635;
	bh=p+Aly1DCwQO242o2hNdvPiR0AFUre9Qn/CBGycQGrE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eDyINtfOeCGJ6cfK1pHUonXeQLxxzVHt/17IG55AcijK/lP57HSBFGnNPfGOxf2pq
	 aSjxElzllC4+c3Q4SYKRI7yeA2RPAPkfCP7WUBEgV2hoY/OMy6gjFHzC9j8oWpwAWV
	 vLNdUwkOCP6pJPVXTbbidnCMfP4ua1KIlpt5xTIkHkbRjPJ0nklujWkSOQhLfkAiR3
	 VfQckiRUc073M9Aphvpj21NFXIYcap2fUJbbLdRK0lGzG9ZDIEGO+d7YRyXLv93zro
	 kateg7YGXENpJ1ogJNLUpS5dckvD/PuZ7bkntNXRyP4AIsQAoedUETCpeutUBhpcr/
	 MB2fauSGn3eDA==
Date: Fri, 30 Aug 2024 18:07:10 +0100
From: Simon Horman <horms@kernel.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 2/2] netfilter: nf_tables: Fix percpu address space
 issues in nf_tables_api.c
Message-ID: <20240830170710.GY1368797@kernel.org>
References: <20240829154739.16691-1-ubizjak@gmail.com>
 <20240829154739.16691-3-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829154739.16691-3-ubizjak@gmail.com>

On Thu, Aug 29, 2024 at 05:29:32PM +0200, Uros Bizjak wrote:
> Compiling nf_tables_api.c results in several sparse warnings:
> 
> nf_tables_api.c:2077:31: warning: incorrect type in return expression (different address spaces)
> nf_tables_api.c:2080:31: warning: incorrect type in return expression (different address spaces)
> nf_tables_api.c:2084:31: warning: incorrect type in return expression (different address spaces)
> 
> nf_tables_api.c:2740:23: warning: incorrect type in assignment (different address spaces)
> nf_tables_api.c:2752:38: warning: incorrect type in assignment (different address spaces)
> nf_tables_api.c:2798:21: warning: incorrect type in argument 1 (different address spaces)
> 
> Use {ERR_PTR,IS_ERR,PTR_ERR}_PCPU() macros when crossing between generic
> and percpu address spaces and add __percpu annotation to *stats pointer
> to fix these warnings.
> 
> Found by GCC's named address space checks.
> 
> There were no changes in the resulting object files.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> ---
> v2: Also use {ERR_PTR,IS_ERR,PTR_ERR}_PCPU() macros.

Reviewed-by: Simon Horman <horms@kernel.org>

