Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664F428FFDE;
	Wed,  6 Aug 2025 16:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754498383; cv=none; b=MW6R1O6a9GdctOrmd92X4d7fgiJl1IhyG5V4BplSqSNjoJe5pOO9uGfxCvKcRwhGGFehXvyreeXGSBu0jRRwdPLAnldx61J1RBqq4Ja0dkX8ApdyWXGs57nptQFCj/DEWUI8YLMiNtbFplG7H4P/ic45MJVpVuwZfPZ0QAEhejg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754498383; c=relaxed/simple;
	bh=SsBFv/HG7bkAP20xuAtmPeTd6ipuiJeHlSVdpTPwvn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GvxxbQbm6AbTXnzsC6jC0Sg7fUB6oSVHQnig5Jfgw3ETRmyJ6d8uq6dtH+ReNQkYLS+3E9qdAV95HvJCsBnQ2OSXYefGZtNVIHhC0xmyLjeg4qaBOc7oCMeRcznLmDOXZbzVfbEA+OIx0RsLgdEc+U6nO7riueVTrDkk3s/3iEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=K6xM19r7; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KOQhnP/R; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="K6xM19r7";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KOQhnP/R"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id BEDA8608AA; Wed,  6 Aug 2025 18:39:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754498379;
	bh=OQUvT0lZ6uFXOihrLMfEnqsXPyA1dh9FPXFfn+E18XQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K6xM19r7FIf7CrDtdpgEIDcCbX22Ca71saL3iNUEdrzUqC22it9NMqqTLxmxsnBeI
	 RuHoFGxTvtOU1RkZzfTvctdcLe8osg0NdNr0WoYxIWH5IX9Udb/r89KGTuyTx5pC2t
	 IeWNUNBq80i6nr6o9zYO41/mKR0R6/L0jclsS8rQwjPsf83GZNir0fpM/+uVp5KGAl
	 3ibK0V+pgEciEubFsG6Bd3eTRvFI4jhbg0Df8IPdPbzLnr8aKPLsWvcRTPjHNUnz3v
	 5/yzbp/rjhUQGA/gcKxwRriTMYT2urdcZW7AH1ah0b13TBr/M/Q0JOHgQiYd50mmTB
	 +/nfmzPfh7GGQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C6B77608AA;
	Wed,  6 Aug 2025 18:39:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754498378;
	bh=OQUvT0lZ6uFXOihrLMfEnqsXPyA1dh9FPXFfn+E18XQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KOQhnP/R11wdYPmcgqgV5vWUeyoHJZWXQPjSkbmKMHkCkndFIdww6n7byKKZkWaU6
	 2tqm96PXAB8J8W/JT8t5MEgdU0EtNn9k0EANhjlg7lGlx9URZaa1ge7ndPvdug9hlv
	 0b/B5saxW42KIxr/rSffrvjEEQKpdDiI4aAY4RbHm9iRI4sjOIEM78kTc+KA3gLvRx
	 smx7FlpYLXoJnl7yYf6c3spKgXatno/3ahf0Ty2Z3y1qC/l1BBKwaIFGDGuEPTmg8U
	 WIuZVezEMjEsunDrJBtO3eRuHCjxFVgKlf+a68neXgE+xIWphMAMDkZ/AuwsQKhVUt
	 UrJ55yCfX1fBA==
Date: Wed, 6 Aug 2025 18:39:36 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	netfilter-announce@lists.netfilter.org, lwn@lwn.net
Subject: Re: [ANNOUNCE] libnftnl 1.3.0 release
Message-ID: <aJOFSMkbcVznTuVq@calendula>
References: <aJM8ZPySLNObX5r8@calendula>
 <54r4586n-9q20-2np0-rs68-4p5444sr78sr@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54r4586n-9q20-2np0-rs68-4p5444sr78sr@vanv.qr>

On Wed, Aug 06, 2025 at 05:47:07PM +0200, Jan Engelhardt wrote:
> 
> On Wednesday 2025-08-06 13:28, Pablo Neira Ayuso wrote:
> >
> >https://www.netfilter.org/projects/libnftnl/downloads.html
> 
> Signature missing from http://ftp.netfilter.org/pub/libnftnl/
> 
> I guess one of those download locations should be retired.

Now fixed, thanks.
