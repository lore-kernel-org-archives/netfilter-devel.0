Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94024EC664;
	Wed, 14 Oct 2026 10:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974703; cv=none; b=M456h3upOCBaHa63MaWgMM1B2YMDXMeqZPW8CK/VZeVYMbcz8sX0fVm8HRYsLp1k+sy6aqEGJNC48qays2TEZ3Zc6tEeiM7cc1ZXZ3Ryokhk7Q5uiVpPkAxqUOF3xYVgepfwPqVgvUp1dFSypROkpWRGNuWhjWXnLYHSU0623Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974703; c=relaxed/simple;
	bh=RzqwBJgFsxmYybYe613gu6VMn3xueocRAPkL9ec/kOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m3qIQxHvnkmHVre2aDbpEnGeMVsJaLg1EqQ0o0QAoeTQpnL2zA8LkEbyRZOIlbfvto+d5dYzoi10xkPcByGmOBkgiKoiVZb0gJ5fjsyywFiHVP3WFk0Vv7Gz3HDlcBg8Zxc115T/RUB8p6rh7TJfXzi4JoLVetUGpcLLiLIwt3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 734D76062D; Wed, 14 Oct 2026 12:44:59 +0200 (CEST)
Date: Wed, 14 Oct 2026 12:44:58 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, ja@ssi.bg,
	lorenzo@kernel.org
Subject: Re: [PATCH net-next 00/15] Netfilter/IPVS updates for net-next
Message-ID: <as9dKnQPk5xy92M8@strlen.de>
References: <20261011215953.1334630-1-pablo@netfilter.org>
 <as66prsWCk1qlQpm@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as66prsWCk1qlQpm@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> sashiko reports:
> 
> "If an IPv4 packet from an AF_INET socket is encapsulated by an IPv6 tunnel,
> the tunnel preserves the AF_INET socket in skb->sk while transmitting the
> outer IPv6 packet on the LOCAL_OUT path."
> 
> This sounds like an unrelated issue, I don't know yet how that can
> happen TBH.

I'm stupid and I don't understand why this would be a regression.

This change makes things stricter, so it doesn't enable anything that
wasn't allowed before, how does this add a new crash regression? :-(
