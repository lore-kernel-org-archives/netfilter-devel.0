Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6151A76AE
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2025 15:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749829225; cv=none; b=YxloSucifyV74mQwuk3NtmqOAqEaXoRhCaGY9CSzkouIYMgA2ztghRLEeB4g/WmAxVUFdRabdcUpPpVQ5IDeug/75f2lkSRCWWUw8rOAQkhq7iNT/7Qax8+DVgvUPoqz+soGWeDHA4hVO4xngUNNBZcSwRr/EI5K5J9fuhVAbdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749829225; c=relaxed/simple;
	bh=JraeLhcpmurukWKYjGVcQbCHkp3it0eoGwoU+dkPSro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t6vqkgyi9ihpctrgSb2CPfRg1Fdq0c6pObOdm6U2oIewaCtdB0yfNVURi5pS0IRcxjMQY10OKsmmBHQ0TMnp+Xa4BGRHGN5BLd7bLOe5cDPWs5H2W628K6scT++4/8WsZkHvA4USa8ASUGo2rCD/2wMBS9jfYGMKlKgANwhslFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=h9AL9dDi; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="h9AL9dDi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=veuPu81wynLDQeOKfspL6eziAMZsk6CqFKgbszrnZ5A=; b=h9AL9dDi5b9YDzljRuKMhRX3c3
	/7Wu4kYb9Te/2eN7sYD1wrtuUY4Ay7c4IRAfq1QSnniB6O9QKrFnqSXkToyNgQfAELy2JM11IiuKN
	EKhCTRH0TSuX5yso/Kb8qGepMJW+bJCClEuZhhjUhWjA8V8GIMq8c4R9ozfCL67rA7iUPx2xKuE/j
	olY8QxKtDdkYkqOOJGc5yYkaEZbplE7WAM6I5nZ/koKK6P8LqaW5hrRAkB7Qwx2OjcyqvG9akHDkS
	wgrbmuWzBgcAKTR/gJEDQo/7qI8yZ5ARm4W8pBeCiCdH2rI0J1uBa+elVrlApjX4I2gD0IrJGWhjN
	gf2QwmuA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uQ6Vw-000000006U5-1piE;
	Fri, 13 Jun 2025 17:40:20 +0200
Date: Fri, 13 Jun 2025 17:40:20 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] evalute: don't BUG on unexpected base datatype
Message-ID: <aExGZDqWdNgG0_BD@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
References: <20250613144612.67704-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613144612.67704-1-fw@strlen.de>

On Fri, Jun 13, 2025 at 04:46:06PM +0200, Florian Westphal wrote:
> Included bogo will cause a crash but this is the evaluation
> stage where we can just emit an error instead.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  I wonder if we should just replace all BUGs in evaluate.c
>  with expr_error() calls, it avoids constant whack-a-mole.

I guess the expectation was that bison catches these but I fear JSON
parser has weakened that quite a bit.

I wish libnftables to well-behave in error cases unless critical ones
like ENOMEM.

Cheers, Phil
