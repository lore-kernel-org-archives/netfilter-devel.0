Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798171FECD1
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Feb 2025 17:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740072004; cv=none; b=M86sXDY5v2AebVaHxXpM6KXkIhewsCJSvHuJ2zmNeZ0xcSXcO7kjwLNLldwlUUok9jH8l/fTaa6b2QrW5dom5YAkWAFv4+cl0lHOR39GqBVG7dBAUO+RYe+XLYlKNv7COCHJWZRLEtmyc232Owl3JN8kfbt4lKjbwdRD71fpDTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740072004; c=relaxed/simple;
	bh=vSax9I9Oefz2XEtiof+hQSgRBwjiaf8D9pGvRU9/ufE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RILeg9NNbwJkIucmksCgF4ZSxUFmL5y4FAD4/+kxeeuQc8BgozdWmKLeAMij6C242Z7KwJ++ZubaGKzJA+yEqkQ1b7YCYCd8jZHrk46BukmiKTSH6xN+Itp7KMryZ+IIvAf/s7p/UB8HjJkM3ERpH4vvvXjT7VTgtUwuivq3+os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jvbA3JTV; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jvbA3JTV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jvbA3JTV";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jvbA3JTV"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 96BD7602F5; Thu, 20 Feb 2025 18:19:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740071999;
	bh=AlM5X6xxfCccOJr5avIUfOoTCjn2LxViV49CV2z4wak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jvbA3JTVxNSIMTLHrFTWtxpdBnFtyQ+Mpoz6xqya85vDO7Xe14b1OEpS3XjwWW+Yr
	 zG72B2VCC5cEhowWLFVfqdfJplUdBSw5UiDzJGcZE1SrIjSTkEnOfv/Q0/J8b6n2ag
	 NbZDJOFkr9dKULFMJJ91xWuJ2q9hKB9w7g46jSyDTO54jX7RP9UdpISWaD0d0I9e36
	 UKhBjkr7iE8EhZGwGmAHSXWbOYX1tSZVs8WdUPE1M8T4x1oAYqUiDXGo4+80nZQgwu
	 H7WDXfHf8Mdmc6LF4eOesZaXEx5xdmJ3rqRMkw7G5PQ24/plokGnuAjzjKy+FNZAI1
	 CSCztaRY98J9w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 23682602F4;
	Thu, 20 Feb 2025 18:19:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740071999;
	bh=AlM5X6xxfCccOJr5avIUfOoTCjn2LxViV49CV2z4wak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jvbA3JTVxNSIMTLHrFTWtxpdBnFtyQ+Mpoz6xqya85vDO7Xe14b1OEpS3XjwWW+Yr
	 zG72B2VCC5cEhowWLFVfqdfJplUdBSw5UiDzJGcZE1SrIjSTkEnOfv/Q0/J8b6n2ag
	 NbZDJOFkr9dKULFMJJ91xWuJ2q9hKB9w7g46jSyDTO54jX7RP9UdpISWaD0d0I9e36
	 UKhBjkr7iE8EhZGwGmAHSXWbOYX1tSZVs8WdUPE1M8T4x1oAYqUiDXGo4+80nZQgwu
	 H7WDXfHf8Mdmc6LF4eOesZaXEx5xdmJ3rqRMkw7G5PQ24/plokGnuAjzjKy+FNZAI1
	 CSCztaRY98J9w==
Date: Thu, 20 Feb 2025 18:19:56 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] parser_bison: compact and simplify list and reset
 syntax
Message-ID: <Z7dkPDLhCTgsqJqg@calendula>
References: <20250116083210.250064-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250116083210.250064-1-fw@strlen.de>

Hi Florian,

On Thu, Jan 16, 2025 at 09:32:01AM +0100, Florian Westphal wrote:
> Works:
> list sets
> list sets inet
> list sets table inet foo
> 
> Doesn't work:
> list sets inet foo
[...]
> Compact this to unify the syntax so it becomes possible to omit the "table"
> keyword for either reset or list mode.
[...]

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks Florian.
