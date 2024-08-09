Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1931940AA;
	Fri,  9 Aug 2024 15:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723217600; cv=none; b=nTRGXeHHA+3lycRHWfAuCbvoPXWt3HtKP9CaD7spSjYn3Jdp36zuRFI9A6aUQWRcBdrYnADw5umabb7+u272WW2IXkHD0qh9rrZHlgWT03OcRHtnvnDUJJG1DXLFkcQcd3I8LrBYlg1s1Wvg/LmmrSP1WvqpWQeqEDDlcHWMIlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723217600; c=relaxed/simple;
	bh=LLATHC40aB4O6Tlta9sOqjyjUh0MDvWpmXSUKdbn63U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sCj0J+9TDbHnrokxihWZy3Sh2OQM1iQNcTGhYvd2kO26IOs+OipUcHWQTomu4/u3cta62HlKIpR20FLKLFQolBQfl2EhTM61waVxLqapXugmv8iwVFcciFkI/59OnIoPBKwJUTleHe9h1zx3DhPv7hJyZvfpHxfvHhCgMfCSxMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pAWuV5u9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pAWuV5u9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606EEC32782;
	Fri,  9 Aug 2024 15:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723217599;
	bh=LLATHC40aB4O6Tlta9sOqjyjUh0MDvWpmXSUKdbn63U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pAWuV5u9nLxT1XU3Tw5pQMzzs/HwvUBlgltHzqBuusOVH7lJlfGEZY6fUGXyuHnnj
	 0BH9zVIFk8R78xiRFZTSWCoOTvZ/q79JZ8AF8s/+sK7XwdKoXxcd/Nw0naD8KDyxwh
	 dpzjeb8Uzy2fUqilBRS67T+ZdzvYCRPI8vm28vi9G+d6U2i2QExdtW8tJ6zBhtCl2i
	 mUjLfO62fIE30qyRI4gvLrztC10YZG3Nfe9XAXeBm8o45BoZV9v0YFpswiBfdvS/wL
	 YxwCWo0VohojzwY2OjCDwHrGOnQ12Dx8CQ2c5fQ0tojoFu7rHawsK6zMu2vYkMJf63
	 CfaLXjIit4xLA==
Date: Fri, 9 Aug 2024 16:33:15 +0100
From: Simon Horman <horms@kernel.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	donald.hunter@redhat.com
Subject: Re: [PATCH nf v1] netfilter: nfnetlink: Initialise extack before use
 in ACKs
Message-ID: <20240809153315.GC1951@kernel.org>
References: <20240806154324.40764-1-donald.hunter@gmail.com>
 <20240809090238.GF3075665@kernel.org>
 <m25xsaq74k.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m25xsaq74k.fsf@gmail.com>

On Fri, Aug 09, 2024 at 12:15:55PM +0100, Donald Hunter wrote:
> Simon Horman <horms@kernel.org> writes:
> 
> > On Tue, Aug 06, 2024 at 04:43:24PM +0100, Donald Hunter wrote:
> >> Add missing extack initialisation when ACKing BATCH_BEGIN and BATCH_END.
> >> 
> >> Fixes: bf2ac490d28c ("netfilter: nfnetlink: Handle ACK flags for batch messages")
> >> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
> >
> > Hi Donald,
> >
> > I see two other places that extack is used in nfnetlink_rcv_batch().
> > Is it safe to leave them as-is?
> 
> There is a memset at the start of the main while loop that zeroes extack
> for those two cases.

Thanks Donald,

I missed that.

I was wondering if it might be best to clear extack at the beginning of
the function. But if the loop needs to clear it on each iteration, then
I think your solution is good.

Reviewed-by: Simon Horman <horms@kernel.org>

