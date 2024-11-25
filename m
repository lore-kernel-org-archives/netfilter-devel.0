Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4CF18D65F;
	Mon, 25 Nov 2024 10:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732531687; cv=none; b=WDu7ybHaw0ox61X39/93rEwz/9LHCTipD1R0zTz8PjbmwDsPgmpJQjQihjpKsL6qa1dJVKZDR7XDTvspjQoujUry7G/9jiVVMYH5bPluI7lEO6wf7ok8zaICNW/MLUwgIspj7Px12GKHseI2EeBT+r4kxX4339c2nWIVRal7KrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732531687; c=relaxed/simple;
	bh=BFFPZ8nqU8FgHWZ4iXI1A1nZPX1IUI1ki6amxqJpdoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OXCzMyTluysyUaAJuryOtpirNGGY16DgZ6koB5woPRbh06en0kUODhYSDKL95vrldOdF4s3ywyYykWU2xfrvkqk6z38+tolinLSpCnKIZ7dEt+qTcjHKZxmY11Va3aiuMmmUTDxQV3VCuNh/VYJ2yERgbSQgB5PjTG7abe+eIlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=49948 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tFWdK-007ydn-Do; Mon, 25 Nov 2024 11:48:00 +0100
Date: Mon, 25 Nov 2024 11:47:57 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: syzbot <syzbot+57bac0866ddd99fe47c0@syzkaller.appspotmail.com>,
	coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] WARNING in nft_socket_init
Message-ID: <Z0RV3ebHXHe8kppu@calendula>
References: <67443b01.050a0220.1cc393.006f.GAE@google.com>
 <Z0RRutRfeaWVs63d@calendula>
 <20241125104031.GA28648@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241125104031.GA28648@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Mon, Nov 25, 2024 at 11:40:31AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > At quick glance, cgroup maximum depth seems INT_MAX.
> 
> The WARN needs to be removed, thats all.

OK, I'll take of this, thanks
