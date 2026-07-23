Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189513D810D;
	Thu, 23 Jul 2026 19:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784835670; cv=none; b=krxEWFpvW91YgLPzTh9oA+ofOAo3ozEj98xK2BSRUOE2d3RRTXTYK08m3UeOiRX1CmVD13a6rQHTuPIg+hEYEOtzsq9rEIITzK37BNCFDiTpKQCFobSejpHiBDubzLC6WSpL1Z368NzyyD117WA5X8RfSACspKE9v3Btyf9HII4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784835670; c=relaxed/simple;
	bh=sD2YWSUj7wzNdTpoX39NRTKQKbedMotn10NHWytgupU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ryaqzfgPcphG0Sj7sE0uJeIBjgaZUFvAClMqpkB2y8ZQqGJ06HVCEB47pu1ZLrt4QRWcmuxX0UzatmKyylFx8XSwryR1F1frH/CbDUB9YIkfMmaRjARG8Wn5/RJemXXlmqwmJ+sT11CvHlOx1MoMrL5wG/Ix8XZC7t9SHVN0Q+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=O1HEGFNO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="O1HEGFNO"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C660B60195;
	Thu, 23 Jul 2026 21:41:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784835662;
	bh=8X1z3bysMmPGcTut0/quhoS6/ib3wobKTW3FBdjv8Vk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O1HEGFNOifzE+qnbOtGPoyquIPESkJYhqpZUJ/qCAnCseBG0LdUJqlJAYS1z2w1QN
	 8QqNyTRe1c8RLDRhKti3YewLEV5ltQ/zWMjiZrZ+AHAEoVbiCeqCmyBsg1r4dt575M
	 nMarRYiCMi9HYaB72/aGTmMGlB7vjhqTCwTUJB3ZeATIzXthuQahLGdJzdNXscYhU/
	 3/IK9LbflNy99notD/TyuH6GH/G7OiQRISMLt3Jmwi8tcZ15Scp/aCQ4ic0A18Y9LI
	 xmb1BN3MjfBBTp3bE+ZaVGJxY9oykpFsykwZqTtmWhBmRLoA3wvBN8FRDbtOyeoP1E
	 Wry/7gIT8fwSA==
Date: Thu, 23 Jul 2026 21:40:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net 09/13] ipvs: fix the checksum validations
Message-ID: <amJuS7oDeYoDJNTh@chamomile>
References: <20260722211420.153933-1-pablo@netfilter.org>
 <20260722211420.153933-10-pablo@netfilter.org>
 <20260723070845.7855a0f1@kernel.org>
 <amI1logAep3vSkfF@chamomile>
 <20260723113726.225a92a7@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260723113726.225a92a7@kernel.org>

On Thu, Jul 23, 2026 at 11:37:26AM -0700, Jakub Kicinski wrote:
> On Thu, 23 Jul 2026 17:39:02 +0200 Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > On Thu, Jul 23, 2026 at 07:08:45AM -0700, Jakub Kicinski wrote:
> > > On Wed, 22 Jul 2026 23:14:16 +0200 Pablo Neira Ayuso wrote:  
> > > > +/**
> > > > + * ip_vs_checksum_common_check - validate checksum for TCP/UDP/ICMP
> > > > + */  
> > > 
> > > this not-really-kdoc comment causes a bunch of new warnings,
> > > and this file was previously warning free. Which in turn
> > > makes our AI reviewer ignore the series. Could you respin?  
> > 
> > Yes, I can drop the patches that have the kdoc issues and respin.
> 
> Thanks! We're seeing extra delays due to lore outage overnight
> and a lot of submissions suddenly appearing in the pipeline.
> Looks like this will have to wait for rc6 :(

OK, no problem, thanks for explaining.
