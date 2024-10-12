Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7A3288D1;
	Sat, 12 Oct 2024 17:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728753925; cv=none; b=IXd6p0gJjoS7QNybuZHdJEY5r37ADTva2aq2KsYSZ+zYSRpcKn8IfUuUPDE10BNb+vzTmr2nenpPNnglzzAxqqq/T36sWIsjrCH3frmMuS0L4Vi/dwhc3K1kZSleEGmSDLi64lz2q7gzPgmvF4owXzDLO9kBumhXF5CwaAfBZ9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728753925; c=relaxed/simple;
	bh=hN3yW09dTYTaAm2PBdbduDnflAutXpKoyA1DizezECk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RVKRdZ5PODmFGu+Jlcdad71fir0VRsKTkZLi+2QKtPoZtqB67cjB8kwBxGf/82e90UeZsahl8E6gXUnUjkDdrMgLtdEM+ReWRtLa9Jvz+Y0QFV/nEA5mVWvT64wWd3J1YTCVWGS3LWHQiQRoxYAhJw4EM2kM+dWZDtboIpW5CAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=55420 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1szfrf-001f9L-Ec; Sat, 12 Oct 2024 19:25:17 +0200
Date: Sat, 12 Oct 2024 19:25:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Breno Leitao <leitao@debian.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, Jozsef Kadlecsik <kadlec@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	David Ahern <dsahern@kernel.org>, rbc@meta.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	"open list:NETFILTER" <coreteam@netfilter.org>,
	"open list:ETHERNET BRIDGE" <bridge@lists.linux.dev>
Subject: Re: [PATCH nf-next v6] netfilter: Make legacy configs user selectable
Message-ID: <Zwqw-pL7LGFtMJQq@calendula>
References: <20240930095855.453342-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240930095855.453342-1-leitao@debian.org>
X-Spam-Score: -1.9 (-)

On Mon, Sep 30, 2024 at 02:58:54AM -0700, Breno Leitao wrote:
> This option makes legacy Netfilter Kconfig user selectable, giving users
> the option to configure iptables without enabling any other config.
> 
> Make the following KConfig entries user selectable:
>  * BRIDGE_NF_EBTABLES_LEGACY
>  * IP_NF_ARPTABLES
>  * IP_NF_IPTABLES_LEGACY
>  * IP6_NF_IPTABLES_LEGACY

Applied, thanks
