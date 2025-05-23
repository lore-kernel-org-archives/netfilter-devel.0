Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36562920A8;
	Fri, 23 May 2025 13:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006974; cv=none; b=pu/wV/4kq0AJwHFLTercJZ7++rOxVttescuwcqYuA2nX9zVRMQJR6X0iJhULxgkaxbTfD8hbMUeZ9QlNy646GNvodlV8SzFMo8ENMAMzbfIqodApAj5W3wHkJxeNoGqfuiCO0GIhzIscSm6K2LPggnGzeodg5n0DVRPLeEQnjxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006974; c=relaxed/simple;
	bh=7NXjrp29mUmox4itaEVPI85BSQTn9BygzWCj75Oui6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f1ocFroqiXY7F9LpaMMeGB7dcPj0akRpR/AojrxX+pvh1Ovtz+4d511KwXOxJ4Yx57Y3vPQoyDtJVedlLZnJGxmm46MvMKGETQJG/HCgbkAsxJJXcQIj1MQWbVTDUCnP960471pt0nuSiM7zmoSfqzYUgcbRG13iYewN06xJtw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tvF2knvX; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RkUSubey; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tvF2knvX";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RkUSubey"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 81FBB6073C; Fri, 23 May 2025 15:29:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006971;
	bh=k+yxpRas456PaqkSHX/6T++TdugnTfOdWSiU/ebjjSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tvF2knvXEO/VLLlyT43P1hJlKvDrXVIXFXhR41/DYXmYlkPU5LF7AS3zo/31FqW+A
	 Dm/5MfaCyDE+Q8PpSHGGE67EAhnoo1H4Ezs6srfObo98GXNHIxSosPByxbcKIp0cha
	 rJkTXxRuv/7WwPYA+Ikcwmydol30osb8asOAFGrtppqKY9BNiRn/3ak3BzvQIIoZTk
	 rrssiAjaVGzA/bd8V0Ns0Sgh1/CeVYSdHVjprtUcGgikVkxxA55wZOMuSpsAbvkBWC
	 uYqxFEDICgxdHgi6Ch9riZ4K2AfnZ8afkFSvSTshEDELjcvooDx4fdYpLtDC+m2h3z
	 g40qAT3EaU2dQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C62256073C;
	Fri, 23 May 2025 15:29:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006969;
	bh=k+yxpRas456PaqkSHX/6T++TdugnTfOdWSiU/ebjjSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RkUSubeyZ6W2NTH7L7KmwlN7QOmjCDpIKIBQrXvw3v95x2SfDujjviuCVa+3H7+Of
	 bTSJM/mVkEGFAyJohYI6wCf0jFujvS3rks4BK0YlsVa9W1bOO4k9h05BagMv/oCbFv
	 RxEA3HtzBaw8Qq+TuLXN3M5An16Q1Zbm780n3NFFF6xkyGa+ntscmuAOf4uujXkyTA
	 1rwx7a3y+WgqjBTz3Ts5kZ95uc69CJOmEZp3Dwh9TdPHF3fljyj6Z8QGLtdUNMS+G1
	 b+dRjzj/92N4+P28MKIqpgANNwReA6WZSHKtlKqTcIYabhq+f7uO5r6MZiZxXzOEGa
	 jqaW98/moFxSg==
Date: Fri, 23 May 2025 15:29:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH net-next 06/26] netfilter: nf_tables: nft_fib: consistent
 l3mdev handling
Message-ID: <aDB4NniR09nI2rjp@calendula>
References: <20250522165238.378456-1-pablo@netfilter.org>
 <20250522165238.378456-7-pablo@netfilter.org>
 <20250523073524.GR365796@horms.kernel.org>
 <aDAmMUGwlvMoEYE0@calendula>
 <20250523132610.GV365796@horms.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250523132610.GV365796@horms.kernel.org>

On Fri, May 23, 2025 at 02:26:10PM +0100, Simon Horman wrote:
> On Fri, May 23, 2025 at 09:39:29AM +0200, Pablo Neira Ayuso wrote:
> > On Fri, May 23, 2025 at 08:35:24AM +0100, Simon Horman wrote:
> > > On Thu, May 22, 2025 at 06:52:18PM +0200, Pablo Neira Ayuso wrote:
> > > > @@ -39,6 +40,21 @@ static inline bool nft_fib_can_skip(const struct nft_pktinfo *pkt)
> > > >  	return nft_fib_is_loopback(pkt->skb, indev);
> > > >  }
> > > >  
> > > > +/**
> > > > + * nft_fib_l3mdev_get_rcu - return ifindex of l3 master device
> > > 
> > > Hi Pablo,
> > > 
> > > I don't mean to hold up progress of this pull request. But it would be nice
> > > if at some point the above could be changed to
> > > nft_fib_l3mdev_master_ifindex_rcu so it matches the name of the function
> > > below that it documents.
> > > 
> > > Flagged by ./scripts/kernel-doc -none
> > 
> > Thanks for letting me know, I can resubmit the series, let me know.
> 
> I'd lean towards fixing it later unless there is another reason to
> resubmit the series.

I did not read this email and I resubmitted. I hope this is also fine with you.

Thanks Simon.
