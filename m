Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF39C1DF724;
	Mon,  7 Apr 2025 14:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744037390; cv=none; b=s3gyz/Lk1H67HtntjlkM2jfNgqhnshNE+JzAZi7S19Azo7YO8CdgsdwmtpiWVHeBB+qaNirD7g8AYWP09vYF8pE1WnVT/dis9vrGh03ZkLXtb78u0w86iK2uX9adweuOCVFdL3XG26yRW/xiSQz8wqV1V91dd906ctqpEFMHU1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744037390; c=relaxed/simple;
	bh=t8MuHn26ogD3YZ+VawM4zCp0dmjmSqrLzD4RK6IAnnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UCJyr6WOTepnR4dTxncuWUp9q4TvObvhetMZMxfAPkA/U7KUaqMVN0ZWcOO0/lOSrtqRYMt0hV2oWpLR8PlUOXk9VpSqw6p+meFlQnqKU35iVCmNBUA5AfEBZSVnMyJcP85wWDcqrg36TupLQ53fwNaOxgH347EQVDE9UTHXMxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bKZns8XN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bKZns8XN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2196C4CEDD;
	Mon,  7 Apr 2025 14:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744037390;
	bh=t8MuHn26ogD3YZ+VawM4zCp0dmjmSqrLzD4RK6IAnnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bKZns8XNwkKsKzJPMlf2XX8Via/GsVSFkbr+ESGP7e6nbkTaIxe7sZeKDWDbDcpG7
	 aELCLqK4H0PbRNAw8q6tm7A9oc51U5WbGGOlV+UVWk2lAnwBDPOXUKisl+irN6274r
	 xj087zQXaX7QoibvX1pcx/yDr+nD1LBf8pMjfKS/1q3oiBoiJZSBjCAXnzlNemFd9a
	 P+pZ5sNz5t+/Yw/QpIkc8XKsKfeVJeltASy3gEDPkivg9UESVhKJOYvmq7J1a1aHyP
	 1r4LRbgr018FlojmYZqVaO5nl21sw9pXpde0avYSxSjslaBlWgppBnDC0TDy+vlEBQ
	 fxyhQ0c7GYOzA==
Date: Mon, 7 Apr 2025 15:49:45 +0100
From: Simon Horman <horms@kernel.org>
To: Chen Linxuan <chenlinxuan@uniontech.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] docs: tproxy: fix formatting for nft code block
Message-ID: <20250407144945.GL395307@horms.kernel.org>
References: <CFD0AAF9D7040B1E+20250407031727.1615941-1-chenlinxuan@uniontech.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CFD0AAF9D7040B1E+20250407031727.1615941-1-chenlinxuan@uniontech.com>

+ Pablo, Jozsef, netfilter-devel, coreteam

On Mon, Apr 07, 2025 at 11:17:27AM +0800, Chen Linxuan wrote:

Hi Chen,

A description of why this change is being made should go here.

As this is a patch for Netfilter documentation, it should probably be
targeted at nf-next like this:

  Subject: [PATCH nf-next] ...

And Pablo, Jozsef, netfilter-devel and coreteam should be CCed.

If you do post a follow-up, please do allow 24h between it and your
original post as per:

https://docs.kernel.org/process/maintainer-netdev.html

The documentation update itself looks good to me.


Pablo and Jozef,

Should we add tproxy.rst to the MAINTAINERS entry for NETFILTER
so that get_maintainer.pl does the right thing?

> Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>
> ---
>  Documentation/networking/tproxy.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/networking/tproxy.rst b/Documentation/networking/tproxy.rst
> index 7f7c1ff6f159..75e4990cc3db 100644
> --- a/Documentation/networking/tproxy.rst
> +++ b/Documentation/networking/tproxy.rst
> @@ -69,9 +69,9 @@ add rules like this to the iptables ruleset above::
>      # iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY \
>        --tproxy-mark 0x1/0x1 --on-port 50080
>  
> -Or the following rule to nft:
> +Or the following rule to nft::
>  
> -# nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
> +    # nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
>  
>  Note that for this to work you'll have to modify the proxy to enable (SOL_IP,
>  IP_TRANSPARENT) for the listening socket.
> -- 
> 2.48.1
> 
