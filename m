Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0A21607BD;
	Wed,  1 May 2024 20:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714594162; cv=none; b=ZWXq+h0Sw/5PWleA5ymsyW1MaB4HFto0Ac1Q3Xc2AfAYmtl0UJJQK3HmrmnzDaqvM6Ls9kXcDV0Q5PA8j93Sz9rsSYsrtAPO/WCO1eId3odgDD3o/LkCtuhHaGSpjbVVc375ScyUgLzXn1c+j1R3I6PoSgxrTC7XITfHt+3k3fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714594162; c=relaxed/simple;
	bh=11GMfyacO/V3AJ5Zzbk/inKMzfB5AhpTUojNys8ow5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ofv58OCzRiLoxcaJ8nZDI4F2FuiDbcLoKUeLUE5ufgn8tgLyvig0fGIIONP0OcSwPWhuhf3CTHb04MrYHcLjuUg+zHdsquqQlbqlS3o4biob1ckOK0z+8kdqu7iKlm233ZvcAEzDqIZbjI5mRcarI2/P++vdSm0Q41KfXJ6Wqk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V2Gr0diT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V2Gr0diT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853F4C072AA;
	Wed,  1 May 2024 20:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714594161;
	bh=11GMfyacO/V3AJ5Zzbk/inKMzfB5AhpTUojNys8ow5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V2Gr0diTOxX0iQ2UfjZ23jIP3nLVnzSDTkzwq7zJPdHrVpmo98wQuNY1ODz5keTNK
	 0Sj8f+ueS0ufaWGU+4wwyoC7ydF+E0VTZyi5s/UuZqcebyDUzqCkhWDc02pGZ/vPup
	 7+xw0wrlR6r/A8bHQliGfDCjg6M6ix5E7bxEwE7ZSlhkFAQ9D3T8zau2OI0oGUdEsr
	 1GaIS7ggyqvqpe5I/yclgNsTviEKpLHPPplVq/waghOhASERTzpwnA8vq5DJtk+11M
	 L//WQ01h8l7dZ0RrSdr13Fn/Bn6DSRHVwIgFR0jTmb7s919OZ7vOm2lJUXvSLFbNtx
	 f86evON9wMVLw==
Date: Wed, 1 May 2024 21:09:17 +0100
From: Simon Horman <horms@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next] selftests: netfilter: nft_concat_range.sh:
 reduce debug kernel run time
Message-ID: <20240501200917.GL516117@kernel.org>
References: <20240430145810.23447-1-fw@strlen.de>
 <20240501155920.GV2575892@kernel.org>
 <20240501194153.GA8667@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501194153.GA8667@breakpoint.cc>

On Wed, May 01, 2024 at 09:41:53PM +0200, Florian Westphal wrote:
> Simon Horman <horms@kernel.org> wrote:
> > On Tue, Apr 30, 2024 at 04:58:07PM +0200, Florian Westphal wrote:
> > 
> > ...
> > 
> > > diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
> > 
> > ...
> > 
> > > @@ -1584,10 +1594,16 @@ for name in ${TESTS}; do
> > >  			continue
> > >  		fi
> > >  
> > > -		printf "  %-60s  " "${display}"
> > > +		[ "$KSFT_MACHINE_SLOW" = "yes" ] && count=1
> > > +
> > > +		printf "  %-32s  " "${display}"
> > > +		tthen=$(date +%s)
> > >  		eval test_"${name}"
> > >  		ret=$?
> > >  
> > > +		tnow=$(date +%s)
> > > +		printf "%5ds%-30s" $((tnow-tthen))
> > > + 
> > 
> > Hi Florian,
> > 
> > A minor nit: the format string above expects two variables, but only one
> > is passed.
> 
> Its intentional, I thought this was better than "%5ds                 "
> or similar.

Understood, thanks.
