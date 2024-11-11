Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577A042A87;
	Mon, 11 Nov 2024 18:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731350097; cv=none; b=LDt/TeUd3dt7yZqT6T7ShbjRSNr5tAPmK6Qd61QHUUbWHMPLZDHlH1GcHPGf0RXw4zZ/kRbbEx30MMwm11wMc0ivn60ukKkfCZT87dfcsesMF2kKL9OSgTg9Yp19abUXQnxDRNzhEU7GEYK21wWwO6dAZg7ScPyd1Oro3KT1Tp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731350097; c=relaxed/simple;
	bh=RNRTCdj0i8ASl1t9XSLkvPMr6DBjYhJK/hLXjobirTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mzMFD8hIdznmWF/zdmOJInQFkoAZhqUfPIf8CdTvdYE6wEZXeSmh2MxPp3eduHJrS+/gqxaZBoFYLzURBeurlggZoMUciUMtYPV2s6xmArSYJNbSvVQ1imScujt9qsvGTzrtCr2HWTlFl4FZDbXkI+V0ncYIi4un9L7k/8epkaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=58682 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tAZFP-003TKC-7W; Mon, 11 Nov 2024 19:34:49 +0100
Date: Mon, 11 Nov 2024 19:34:45 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: egyszeregy@freemail.hu
Cc: Florian Westphal <fw@strlen.de>, kadlec@netfilter.org,
	davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: uapi: Fix file names for case-insensitive
 filesystem.
Message-ID: <ZzJORY4eWl4xEiMG@calendula>
References: <20241111163634.1022-1-egyszeregy@freemail.hu>
 <20241111165606.GA21253@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241111165606.GA21253@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Mon, Nov 11, 2024 at 05:56:06PM +0100, Florian Westphal wrote:
> egyszeregy@freemail.hu <egyszeregy@freemail.hu> wrote:
> >  rename net/ipv4/netfilter/{ipt_ECN.c => ipt_ECN_TARGET.c} (98%)
> >  rename net/netfilter/{xt_DSCP.c => xt_DSCP_TARGET.c} (98%)
> >  rename net/netfilter/{xt_HL.c => xt_HL_TARGET.c} (100%)
> >  rename net/netfilter/{xt_RATEEST.c => xt_RATEEST_TARGET.c} (99%)
> >  rename net/netfilter/{xt_TCPMSS.c => xt_TCPMSS_TARGET.c} (99%)
> 
> No, please, if we have to do this, then lets merge the targets
> (uppercase name) into the match (lowercase), i.e. most of the contents
> of xt_DSCP.c go into xt_dscp.c.

Agreed, please don't do this.

We have seen people sending patches like this one for several years,
this breaks stuff.
