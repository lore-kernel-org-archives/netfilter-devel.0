Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6342262A3;
	Thu, 14 Nov 2024 15:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731596462; cv=none; b=OYa5eUbKwSsIsyL+D2UemLKooheZwOaig+BlnBZrGfMwr8sYpodfg1lGZG75nS2u6Cj0Hu6X/fA6oxQW2cQjQNCdmvipG7Gbkohvq+0SAsUHXyv2Qj5yvEYZnWjgnYBb7C8zZvsey58mimGt/WhaUNX0ZQsZz3muUHW2lPx+bEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731596462; c=relaxed/simple;
	bh=t3gPktpLQTya+caO8QcpEEaNmKna3f3/23XVHPHOGi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SqCtPBgbmoXHpFyV8fZGW1srJ6C5cHhDWUjQgsxg1nCwAGyP5scB3ekk72WrSYEN1QoSStp5Ng3PASjpN+mYEc2JY1AjgyNxDusqsSaoujV2va6Ts2kAJR0l9SVByM6B4kVbKwXJgO9+ZwGCA4cfir16FLGHvn9ODnN1iiM4Nc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=50634 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tBbL4-002pt9-Em; Thu, 14 Nov 2024 16:00:56 +0100
Date: Thu, 14 Nov 2024 16:00:53 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
	fw@strlen.de
Subject: Re: [PATCH net 0/3] Netfilter fixes for net
Message-ID: <ZzYQpRTItgINeyg4@calendula>
References: <20241114125723.82229-1-pablo@netfilter.org>
 <119bdb03-3caf-4a1a-b5f1-c43b0046bf37@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <119bdb03-3caf-4a1a-b5f1-c43b0046bf37@redhat.com>
X-Spam-Score: -1.8 (-)

On Thu, Nov 14, 2024 at 03:54:56PM +0100, Paolo Abeni wrote:
> On 11/14/24 13:57, Pablo Neira Ayuso wrote:
> > The following patchset contains Netfilter fixes for net:
> > 
> > 1) Update .gitignore in selftest to skip conntrack_reverse_clash,
> >    from Li Zhijian.
> > 
> > 2) Fix conntrack_dump_flush return values, from Guan Jing.
> > 
> > 3) syzbot found that ipset's bitmap type does not properly checks for
> >    bitmap's first ip, from Jeongjun Park.
> > 
> > Please, pull these changes from:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-11-14
> 
> Almost over the air collision, I just sent the net PR for -rc8. Do any
> of the above fixes have a strong need to land into 6.12?

selftests fixes are trivial.

ipset fix would be good to have.

But if this is pushing things too much too the limit on your side,
then skip.
