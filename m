Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C5D1DA52;
	Fri,  8 Mar 2024 22:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709938033; cv=none; b=MKeBIYRW06oasYdJnj1C4/gofqDn4XH9O/YDmj5S1gt1PecHWo661G/b0gbSwxw6l9DjBChIsCtjUuRhifEcbcAZq4hFBCUWKX/jSRTu9fFjzjBUmoWLff5Wr/IfBpG6wLxFL1Smd62eG+mRXkJeUJ7hPCRAORsZYlxfKicHTho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709938033; c=relaxed/simple;
	bh=Qk/hdkYXqfzVF5bRt7Hb0RhYrHltEkqGeDNSTmo3iQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I2z5/RJCeLVfX8SLQWU24iBnTyYbZTp1LT3gRgTbY0aS6nk0ZS9rwYQHjAzApCx2YtU25RA9uUEb7JzbD+vTw+FB3XwPc+41WreEZQ0vnAZQV0ZnF3nEDZ/3xSAaZdkj4UWNNw79/Fz4UJHPL2oCkZSif7ZIIUL3wob5DTcNFvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1riizR-00033f-AX; Fri, 08 Mar 2024 23:46:57 +0100
Date: Fri, 8 Mar 2024 23:46:57 +0100
From: Florian Westphal <fw@strlen.de>
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, edumazet@google.com,
	pablo@netfilter.org, kadlec@netfilter.org, kuba@kernel.org,
	pabeni@redhat.com, davem@davemloft.net,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
Message-ID: <20240308224657.GO4420@breakpoint.cc>
References: <20240307090732.56708-1-kerneljasonxing@gmail.com>
 <20240307093310.GI4420@breakpoint.cc>
 <CAL+tcoAPi+greENaD8X6Scc97Fnhiqa62eUSn+JS98kqY+VA6A@mail.gmail.com>
 <20240307120054.GK4420@breakpoint.cc>
 <CAL+tcoBqBaHxSU9NQqVxhRzzsaJr4=0=imtyCo4p8+DuXPL5AA@mail.gmail.com>
 <20240307141025.GL4420@breakpoint.cc>
 <CAL+tcoDUyFU9wT8gzOcDqW7hWfR-7Sg8Tky9QsY_b05gP4uZ1Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL+tcoDUyFU9wT8gzOcDqW7hWfR-7Sg8Tky9QsY_b05gP4uZ1Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jason Xing <kerneljasonxing@gmail.com> wrote:
> > connection.  Feel free to send patches that replace drop with -accept
> > where possible/where it makes sense, but I don't think the
> > TCP_CONNTRACK_SYN_SENT one can reasonably be avoided.
> 
> Oh, are you suggesting replacing NF_DROP with -NF_ACCEPT in
> nf_conntrack_dccp_packet()?

It would be more consistent with what tcp and sctp trackers are
doing, but this should not matter in practice (the packet is malformed).

> > +       case NFCT_TCP_INVALID: {
> > +               verdict = -NF_ACCEPT;
> > +               if (ct->status & IPS_NAT_MASK)
> > +                       res = NF_DROP; /* skb would miss nat transformation */
> 
> Above line, I guess, should be 'verdict = NF_DROP'?

Yes.

> Great! I think your draft patch makes sense really, which takes NAT
> into consideration.

You could submit this officially and we could give it a try and see if
anyone complains down the road.
