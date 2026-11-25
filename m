Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795603771;
	b=UMj5dZr/AjPON3tZIJLjmyDtqhmdkB4qZ/KRH2Xma0ndStjY+khfKWicBQE/79Sr3bkR
	 I0WESZU9gal5snHMsdetWS0MRPObLwu9YMTW2GFBuniHIGJX1eQ8NR2eYynny8sN3rvyp
	 /a1UstqLx96BNp2Rj4PwVfwqNdQW4/3ZWz7Bg4CTS4z528w/wwfc+2Os2/OMAJBji0mO5
	 tPmbpHSl0uBY2JbNHZNTfIS+DqgIrHfjqLj/+18odLz/eRNd80XQej3Oi6JqLPNuPqbr3
	 YvUlKQ7Rvg8vLktc8xQJbqkBaI52lpRhdrIWxpV7R1p2eax6H1T3dUu6Y5/8ncC7W/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795603771;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=9KW+/2sWGL89uMYwvSRgygbk3q80jPWRoGibEmxDZkY=;
	b=jKMgkMZRx/Gbk2ONXL3ZdM5SHk0WM8le2NA6eSVstU1Yjt3o0YJij5E9x10Hi6N9fPNd
	 Zt0ONQsGUcXOV2accAtU/rwySAruaeffdRmq2aQudnHzayCy3ijIAY1Fu5t88BJBbfuLn
	 SWZjokd6kWnsxgymcqK4/v9Or3hTSKBjfxkMu7lwZVDMqfulw2CxHt4FUufjJuCQJQZpO
	 MdSw398qi9zYDpTzVlnFPbLLTYzfKKNLzODhM2wPuBUS74GKiGjinFfRX0KP1Jh/Ty2HM
	 p6WJ/KUi92rwI3dFsC2Elrb1xhQHMGukuVAms2NvZq4R50xhd8p2KJVerT/9OonrnxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=b+YiCEfH;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA979606A31E
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 10:49:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA979606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=b+YiCEfH
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9KW+/2sWGL89uMYwvSRgygbk3q80jPWRoGibEmxDZkY=; b=b+YiCEfHTgIt+V4E7wgfL0OeDu
	FVdt3n5y8D8bzlkUZyeYnZ59iSkMgzmMZsHE5JWJqUnsznnHSRl3b1ZidKSPaxgR+i6bahcbu85Pv
	Pfw0/KdR0GXwFWGK9y6aRQavIy3WfjdgOZgUC5sWgh7FveKnzQCfKiWSsDvXrrnqyFPqgqkc7eq6i
	CLAj4gBpszTgEsPvPULW0AANBL+TX3YIuCya9MUn4l0nGsJKwmzQVF9QpBjDxklAQFhTjSdYxP15/
	Joxg5KSqj9t1GxcYhS2SU4jOUQcfLFfPZ1MvXOPCDeZJqL2qVIh/3rDZC+8BbhyRqWcJaFno1DeTi
	ZGDOsBkQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xWAZ6-000000004WB-2fxw;
	Wed, 25 Nov 2026 11:49:28 +0100
Date: Wed, 25 Nov 2026 11:49:28 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/7] src: normalize set element with EXPR_MAPPING
Message-ID: <awa9OPt8pbWg6fol@orbyte.nwl.cc>
References: <20250905153627.1315405-1-pablo@netfilter.org>
 <20250905153627.1315405-2-pablo@netfilter.org>
 <awXRzNwL7JIR8InP@orbyte.nwl.cc>
 <awYpSv50FCy3yFhV@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awYpSv50FCy3yFhV@chamomile>

Hi Pablo,

On Wed, Nov 25, 2026 at 01:18:18AM +0100, Pablo Neira Ayuso wrote:
> On Tue, Nov 24, 2026 at 07:05:00PM +0100, Phil Sutter wrote:
[...]
> > The key seems to be in wrong byte order. It is not just a display issue:
> > nft_zones_many.sh kselftest is failing due to it which performs lookups
> > in such a set.
> 
> Yes, wrong byteorder. TYPE_INTEGER (integer_type) uses
> BYTEORDER_INVALID in this case, which is handled as
> BYTEORDER_BIG_ENDIAN for historical reasons.

Ah yes, I reached that spot yesterday evening already but wasn't sure
how things were supposed to be.

> > Can you quickly point at where we lost some byteorder conversion (or got
> > an extra one?) by your patch? I guess it missed to adjust a check. I'll
> > start digging through the code meanwhile, but tracing expression
> > manipulation in eval phase is tedious. :(
> 
> Patch:
> https://lore.kernel.org/netfilter-devel/20261124235306.1777-1-pablo@netfilter.org/
> 
> This rework uncovered this underlying bug.
> 
> BTW, nft --debug=netlink does not help to find endianness bugs anymore.

You know we disagree on that. ;P

The endianness-aware netlink debug output actually uncovered Big
Endian-specific bugs (due to py test suite becoming useful on Big Endian
systems).

It's just that we don't notice if a value is in wrong byteorder but also
marked as such (and therefore "corrected" when printing). To make up for
that, I tried the following in libnftnl:

| --- a/src/expr/data_reg.c
| +++ b/src/expr/data_reg.c
| @@ -70,6 +70,12 @@ nftnl_data_reg_value_snprintf_default(char *buf, size_t remain,
|                         SNPRINTF_BUFFER_SIZE(ret, remain, offset);
|                 }
|  
| +               if (flags & DATA_F_HNPFX) {
| +                       ret = snprintf(buf + offset, remain, "%c:",
| +                                      reg->byteorder & (1 << i) ? 'n' : 'h');
| +                       SNPRINTF_BUFFER_SIZE(ret, remain, offset);
| +               }
| +
|                 ret = __reg_value_snprintf(buf + offset, remain,
|                                            (void *)&reg->val[pos],
|                                            curlen, reverse, pfx);

Then we could add --debug=byteorder option in nft tool to set the flag.
We could also permanently add the prefix, but that would need a bulk
update of payload files. What do you think?

Cheers, Phil
