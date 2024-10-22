Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA0F154BE9;
	Tue, 22 Oct 2024 07:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729583877; cv=none; b=XZ7zDOBm1fjnE6zbn7RXAGZMTcsW0NU1Nio+rccSnQmP/x7W1svPcJRwoBO9U9H6REq9DbtmjVYHSxZ4kxdwMlYo00kTj6hYt2AIqX/+eIPtnQzIa7blzAANQOPvbR0uomucnWO1UkT+RYSPzRu5Pgk37iLaENntQGXNyyr+Mgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729583877; c=relaxed/simple;
	bh=Iqo4lzOBXmrv03GoOvT9l2S0oqCHH2VPeft4eUtSyx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CLRP9VHIsa/j8kQ79daO+9Y16VDAR4ZARLcHGyHmXcJo1J/UK/ax9dTnGPntZs/bh9wTCHVS+hR9vkuTJrjbbrsZr1DE2y2lDoksK5591TiHt85V2ktYHK5FOSQNPZVW5VN6SBxJ8/kiup0L+nMRY57f26g0c4rPwd7ppa5+oKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=51358 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t39m0-00D1hv-0e; Tue, 22 Oct 2024 09:57:50 +0200
Date: Tue, 22 Oct 2024 09:57:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux regressions mailing list <regressions@lists.linux.dev>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, fw@strlen.de,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH net 2/2] netfilter: xtables: fix typo causing some
 targets not to load on IPv6
Message-ID: <Zxda-7wzYe6WypX5@calendula>
References: <20241021094536.81487-1-pablo@netfilter.org>
 <20241021094536.81487-3-pablo@netfilter.org>
 <8cd31ad2-7351-4275-ab11-bca6494f408a@leemhuis.info>
 <2024102259-armadillo-riveter-0e7d@gregkh>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2024102259-armadillo-riveter-0e7d@gregkh>
X-Spam-Score: -1.7 (-)

Hi Greg,

On Tue, Oct 22, 2024 at 09:44:19AM +0200, Greg KH wrote:
> On Tue, Oct 22, 2024 at 09:39:38AM +0200, Linux regression tracking (Thorsten Leemhuis) wrote:
> > [CCing Greg and the stable list, to ensure he is aware of this, as well
> > as the regressions list]
> > 
> > On 21.10.24 11:45, Pablo Neira Ayuso wrote:
> > > - There is no NFPROTO_IPV6 family for mark and NFLOG.
> > > - TRACE is also missing module autoload with NFPROTO_IPV6.
> > > 
> > > This results in ip6tables failing to restore a ruleset. This issue has been
> > > reported by several users providing incomplete patches.
> > > 
> > > Very similar to Ilya Katsnelson's patch including a missing chunk in the
> > > TRACE extension.
> > > 
> > > Fixes: 0bfcb7b71e73 ("netfilter: xtables: avoid NFPROTO_UNSPEC where needed")
> > > [...]
> > 
> > Just FYI as the culprit recently hit various stable series (v6.11.4,
> > v6.6.57, v6.1.113, v5.15.168) quite a few reports came in that look like
> > issues that might be fixed by this to my untrained eyes. I suppose they
> > won't tell you anything new and maybe you even have seen them, but on
> > the off-chance that this might not be the case you can find them here:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=219397
> > https://bugzilla.kernel.org/show_bug.cgi?id=219402
> > https://bugzilla.kernel.org/show_bug.cgi?id=219409
> 
> Is this commit in linux-next yet?  I looked yesterday but couldn't find
> it anywhere...

Not yet, there is a pending PR to reach netdev.git at this moment.
