Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D2F1E898;
	Tue, 23 Apr 2024 16:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713891045; cv=none; b=IhMiawxBzt+5ou6v2xIDGJW6BM1vqjCUjstwBMlgxFzuChuJ4Ll2zYzy30PpMLwyVubEXQcgkyoMt1c5TjaVpj9PjNjOazoPHqvonNBMv6U+Qt2BJXDKMDrwsGWFgK4gXlUo+zo5nE4DWss9WMxPwd5x5bVIvdoRaEiVRBU1VHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713891045; c=relaxed/simple;
	bh=OoFN4ZOKy/U5nSpkW3eeRgNHP0I9KlzPXkLoR0ErUj8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GoHfzZ5e9cbvpZWWfih2ixaFi/TtUUXXpzi2+r3xvrXUSMPjvFxL/ss8Sj3vcpNxG9UlneoXRA1vS+WTU9ez4BjdFnBxlgBDZCj6AVX5tL9/BAZesJzoHSDpExbp4Og92Xw/SKY0pGb7KIu/T45WOdOAncsPCjDgPXvFtzrnCig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TlbQh0Yw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TlbQh0Yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41722C116B1;
	Tue, 23 Apr 2024 16:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713891044;
	bh=OoFN4ZOKy/U5nSpkW3eeRgNHP0I9KlzPXkLoR0ErUj8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TlbQh0YwZ0ar/Pb74ud2VCkm5g0errfvUMWGJeUulDJekjZu8u70+uVgcLCOc9orx
	 iSijrJxOuH335G2nnwAfCYl2k/ixUJ8OZsnkx67RS7tsE1Ax1Az3OR/y8x5ZN606Qr
	 tEWwAFdHcFsDjomwcy0ePzwOyKrdgtrknck6U7K5hq/RQ39dtQlFMuCbKtkUQ6VJ7e
	 8e5UbglZISKlx+MqJf4/LGI/DzhHLgj12KNVwZbgmX7hGdg6+tkrh11CEmfyLNjWgl
	 SXBoSpvYlEf+AaOa1Br9fq0MXrycjIM2Og9rxQ7GCdK786e87Fpir4sQ1ByfLJAeL+
	 Zbhc1f5a8oukA==
Date: Tue, 23 Apr 2024 09:50:43 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netfilter-devel@vger.kernel.org>, pablo@netfilter.org
Subject: Re: [PATCH net-next 0/7] selftest: netfilter: additional cleanups
Message-ID: <20240423095043.2f8d46fc@kernel.org>
In-Reply-To: <20240423130604.7013-1-fw@strlen.de>
References: <20240423130604.7013-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Apr 2024 15:05:43 +0200 Florian Westphal wrote:
> This is the last planned series of the netfilter-selftest-move.
> It contains cleanups (and speedups) and a few small updates to
> scripts to improve error/skip reporting.
> 
> I intend to route future changes, if any, via nf(-next) trees
> now that the 'massive code churn' phase is over.

Got it.

The main thing that seems to be popping up in the netdev runner is:

# TEST: performance
#   net,port                                                      [SKIP]
#   perf not supported

What is "perf" in this case? Some NFT module? the perf tool is
installed, AFAICT..
