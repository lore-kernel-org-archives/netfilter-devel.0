Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5514B4483BF
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786982258; cv=none; b=KgGPEiI0cRN0YYoURQgLb/q8oryVjth9KKt+JuWrl8lfNOZ3iAGuukczfrQyJDFo0ZUqGKlk357V/5fEz9apuoDjU/fFV8hhJjzCgVSvBAjjG3T500aGEykdLrBehqJGH68A5QzX+GPjO7V/4wn13Zy9qMW5KIRZjHF1vk5xHg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786982258; c=relaxed/simple;
	bh=ZvxYDswWchpWz8dKCj2MTgYrmGIxrQUlRxB1+UYv1w4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nbI2/fg8zaGGo3o2SV6hujxbl5PChxHmSYzo0tB0seHVVhaFsgGEzkeHyklDhebB6q4TjDUVc78nWnsIfO5rHrUXU/OmGFcwOvfl8+kQK4D8kCc0ne3ywfkV3hv1+JLFWzDg0eyC7HJJP46Mn0SNWyK8iyBMv1PvqyZZ2zUeUHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BBA556027F; Mon, 17 Aug 2026 17:57:33 +0200 (CEST)
Date: Mon, 17 Aug 2026 17:57:33 +0200
From: Florian Westphal <fw@strlen.de>
To: ZhilingZouzhilinz@nebusec.ai
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	horms@kernel.org, bazsi@balabit.hu, kaber@trash.net,
	hidden@balabit.hu, vega@nebusec.ai, zhilinz@nebusec.ai
Subject: Re: [PATCH nf 1/1] netfilter: xt_TPROXY: require IPv6 protocol match
Message-ID: <aoMvba90k7F4nCp0@strlen.de>
References: <cover.1786968834.git.zhilinz@nebusec.ai>
 <6ca536c61d358bfb1bdfd20aafe3cc16acfd45db.1786968834.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ca536c61d358bfb1bdfd20aafe3cc16acfd45db.1786968834.git.zhilinz@nebusec.ai>

ZhilingZouzhilinz@nebusec.ai <ZhilingZouzhilinz@nebusec.ai> wrote:
> From: Zhiling Zou <zhilinz@nebusec.ai>
> 
> tproxy_tg6_check() verifies the protocol field value but does not
> require IP6T_F_PROTO. A crafted ip6tables rule can set the field to
> TCP or UDP while leaving the protocol matching flag clear.
> 
> ip6_packet_match() treats such a rule as protocol agnostic and can
> invoke tproxy_tg6_v1() for ICMPv6. nf_tproxy_get_sock_v6() warns for
> protocols other than TCP and UDP.
> 
> Reject rules without IP6T_F_PROTO so TPROXY is invoked only for the
> protocols it supports.

Reviewed-by: Florian Westphal <fw@strlen.de>

Looks like l2tp_mt_check6() has same problem.
Would you mind sending a second patch for xt_l2tp.c ?  Else I can
do it.
