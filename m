Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33641474B9;
	Wed,  1 May 2024 19:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714592529; cv=none; b=IZXzSuaoyqpd090vthpvFwgGAIBN0EXpcYAlgr2jFQaNbGgSEIMeF0yGlwFG6B363iRjGBoxsq8uvZn9LQA6ZzX3MgORf1VLhFa039L0BGmGQo7bvGbgYGVcAeD69aupJm/O57z1EbWd12XDEtTC1psb+hAYH+pfrC4PysayBM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714592529; c=relaxed/simple;
	bh=OIi/SMAraOm8dXKoXQi90WpKl86oyoijbk7WNHyHhrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GWJ+YyqyJ5Z2GXBnSddydQbxYBwU2C03Y/P0aBKza7zOA2JP7xQAr3zRApv3AQvrWWWz2NbDGhpMcYSYJsW9XqzuQ/7ijyrBCZxjAPbSFk4tNsdJtbBnllR6lbOIKeFItKaC4l2GYTJ0d48Irw1P+Sl0lzGoL4nXYO/aCYWoVSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s2Fpx-0005O5-7S; Wed, 01 May 2024 21:41:53 +0200
Date: Wed, 1 May 2024 21:41:53 +0200
From: Florian Westphal <fw@strlen.de>
To: Simon Horman <horms@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next] selftests: netfilter: nft_concat_range.sh:
 reduce debug kernel run time
Message-ID: <20240501194153.GA8667@breakpoint.cc>
References: <20240430145810.23447-1-fw@strlen.de>
 <20240501155920.GV2575892@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501155920.GV2575892@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Simon Horman <horms@kernel.org> wrote:
> On Tue, Apr 30, 2024 at 04:58:07PM +0200, Florian Westphal wrote:
> 
> ...
> 
> > diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
> 
> ...
> 
> > @@ -1584,10 +1594,16 @@ for name in ${TESTS}; do
> >  			continue
> >  		fi
> >  
> > -		printf "  %-60s  " "${display}"
> > +		[ "$KSFT_MACHINE_SLOW" = "yes" ] && count=1
> > +
> > +		printf "  %-32s  " "${display}"
> > +		tthen=$(date +%s)
> >  		eval test_"${name}"
> >  		ret=$?
> >  
> > +		tnow=$(date +%s)
> > +		printf "%5ds%-30s" $((tnow-tthen))
> > + 
> 
> Hi Florian,
> 
> A minor nit: the format string above expects two variables, but only one
> is passed.

Its intentional, I thought this was better than "%5ds                 "
or similar.
