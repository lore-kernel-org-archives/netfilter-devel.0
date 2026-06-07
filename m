Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E6E28688C;
	Sun,  7 Jun 2026 09:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780823385; cv=none; b=gBP7ic1iLcrILT2ZIUqQEATlb49vnuxLuCHABqxbaGhOPOfoKyMYtmP1csq6kFmlKCUIYtESOBQZjeYPStltNMSsiMXZrT3TvgiQlbInstq+XqMHnEuFogaUz5jQFB9rfqyPiSVSCyPZgaHcvj0YB4dP5oXo8tza1lpJTqDuEBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780823385; c=relaxed/simple;
	bh=/dv+pK7wygIsPiDdifs1ezn8Jmw/4XZbYCMGnahwaNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZWpX4zT/XSM2QkudrqEEQir43Q/gD4UatRyLrlOluVao4c2aF7+A2A076pAefrqV7piqt245zNZP+eKibk8d3rLtCk2wnJEYEfkTwXvAKjkJfNYh53pVdRxmsL8YoHF9bJk/5nWJmhcCElSk8t6os2wIdmitJgUDWLUhHsQEBcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=n+z1bJ9R; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="n+z1bJ9R"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 61B0C6019C;
	Sun,  7 Jun 2026 11:09:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780823382;
	bh=3+27+2awH327HBFWFocRrBFsO5N2n1447+bZy2reVeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n+z1bJ9Ru6tl4hndWAhxYMHu9ouktUO328dsiXwdvkgHWxnxqbSBLc5yK5QWJ3tLW
	 UUrT7wjhDs7dpe0UA4YRpZM4LTBbiAxa2YZSQbTK3Sikz9Ve6MTNdtz2s65c+LAxx0
	 sZ3Gr+IKrvQQt14nQR3a8TwS4Vc2pdCP8bee9A61KZYYC/QD9ijhjPeLm/L3i2nki9
	 qqV0pdkFvVsOuA+capEBqRJr4V30vvHN7Hm1Ve1jIOBTsuqi0J3TXZ2l2Om/wn5Hlv
	 0E+0CAuhB5qXtCHc2d+wUXvnqeIvPxBXxhXNmVmBjQlEJs27N6keZkzM2ptHt6Q2Tv
	 wGugdJd6nJtsQ==
Date: Sun, 7 Jun 2026 11:09:39 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Rosen Penev <rosenp@gmail.com>
Cc: netfilter-devel@vger.kernel.org, linusw@kernel.org,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	"open list:NETFILTER" <coreteam@netfilter.org>,
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: nf_conntrack: use get_unaligned_be32() in
 tcp_sack()
Message-ID: <aiU1U36QUMBgQCfa@chamomile>
References: <20260525215840.93217-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260525215840.93217-1-rosenp@gmail.com>

On Mon, May 25, 2026 at 02:58:40PM -0700, Rosen Penev wrote:
> The timestamp-only fast path dereferences the option stream as
> *(__be32 *)ptr, which assumes 4-byte alignment that the TCP option
> stream does not guarantee. Use get_unaligned_be32() instead, which
> reads the value safely and already returns host byte order, so the
> htonl() on the comparison constant can be dropped.
> 
> This matches the existing get_unaligned_be32() use later in the same
> function.
> 
> Assisted-by: Claude:Opus-4.7
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  net/netfilter/nf_conntrack_proto_tcp.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index b67426c2189b..8993374c9df2 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -405,11 +405,11 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
>  		return;
>  
>  	/* Fast path for timestamp-only option */
> -	if (length == TCPOLEN_TSTAMP_ALIGNED
> -	    && *(__be32 *)ptr == htonl((TCPOPT_NOP << 24)
> -				       | (TCPOPT_NOP << 16)
> -				       | (TCPOPT_TIMESTAMP << 8)
> -				       | TCPOLEN_TIMESTAMP))
> +	if (length == TCPOLEN_TSTAMP_ALIGNED &&
> +	    get_unaligned_be32(ptr) == ((TCPOPT_NOP << 24) |
> +					(TCPOPT_NOP << 16) |
> +					(TCPOPT_TIMESTAMP << 8) |
> +					TCPOLEN_TIMESTAMP))

Missing put_unaligned_be32(), BTW.

>  		return;
>  
>  	while (length > 0) {
> -- 
> 2.54.0
> 
