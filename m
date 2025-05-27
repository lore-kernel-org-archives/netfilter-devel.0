Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9451F4CB7;
	Tue, 27 May 2025 09:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748339189; cv=none; b=cHqoAh538KrSqkPKT99PHFKKGpJ5t2OIyOofzZTu0sUAUt+wwrGQUj14C/US1omI232FZ4JNtK02akz+yUhl8H7eKgV+IIW31EyViDJ/IGs1STwfVugvGDzeX4xM2h9Im7apFiuVk8dnVVOAXLEF95ym/tpLu9gW72YI2vhnPZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748339189; c=relaxed/simple;
	bh=TfFXZn1dpHStIOf7lIR/pkhMML543UI/3a9XGnlT5A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TcwV0EnC79iDHSnN9+DsVI4t5wgouwm83AwDQNQ+U/lJswuUrfVBdFsFZeuQklLbxt+d4YiV4SxBQuo6c/IFQ82QCmE3XTRKqRMIPqJMfOz0zJNCdGL92MiM1dh5xJ3YPa3tith4FGvUt/cvINfY0Uca+nFqJ4J7b/2Qht8n3HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nkYzepnj; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=q4cc8D7g; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nkYzepnj";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="q4cc8D7g"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id EA8046075B; Tue, 27 May 2025 11:46:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748339183;
	bh=wF8+725t9IjvreKoJRB1cw+hQ1FFw/9YT1HOity+xK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nkYzepnjfWHqMvpMsJMuoGZKNpXatdSQ+nknUhMmq+xyh8OAyP/9+kSEUN7k+oKZp
	 l5Mq9tEU3yIXJ8QO/x0UoldsAMB+ANyqNH323KGKyfD6M9NCyNVvgK/59iMsDXwA/E
	 0aCqUyD3nSUWSyvKKqXkoIBY0a+dPWrAFMDOp5jRWS+HdAB/cU7NnNNTEYvyadRlyU
	 Q6opkIMV409rjnh793dkudYOXMsV3Juw2mnZypEcfzfSaY1lcyb/VwaqJIGEjnDdfK
	 L6fUap9aVGw31RC/DtiU4f9AtZQVCCgIv7Ib+nDlUIswPC6h69ven9hdOYocpLnFZQ
	 mKTn6tzNSGhUA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F222C60272;
	Tue, 27 May 2025 11:46:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748339182;
	bh=wF8+725t9IjvreKoJRB1cw+hQ1FFw/9YT1HOity+xK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q4cc8D7g3M7INkK1mkvp+K9Us8ysAJ4YBLFitV8UK01f8CW++CzHfSfHy5ZryjVvr
	 3/biMTOrvc+YPt+z/Sh5xNrWQ8fkxmhFRnNHLf4ahFEj6KV8mE4Za0CkGEoDZI0mbP
	 SmARPgWZVVV7SAdROTAWrm+SVLDPgfHzAf86g0xwcMgX3O9kSrE7ZGKDN+SfV9zPf8
	 x22y/WN7E7NuIuVgRh4Rth9077ekscMoP1fo+ERsO+8icFgZApE6BT2gYEo/xs952C
	 CV+2V2QU6czEMocIrsq3A+au41+cl/K8sxgU52DC9nI7JpO4Lwjxzjt1iMdtmTwEtC
	 wGtgb6W+1N50Q==
Date: Tue, 27 May 2025 11:46:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Paolo Abeni <pabeni@redhat.com>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	edumazet@google.com, fw@strlen.de, horms@kernel.org
Subject: Re: [net-next PATCH] selftests: netfilter: Fix skip of wildcard
 interface test
Message-ID: <aDWJ7DyVyt3Rq-Gc@calendula>
References: <20250527094117.18589-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250527094117.18589-1-phil@nwl.cc>

On Tue, May 27, 2025 at 11:41:17AM +0200, Phil Sutter wrote:
> The script is supposed to skip wildcard interface testing if unsupported
> by the host's nft tool. The failing check caused script abort due to
> 'set -e' though. Fix this by running the potentially failing nft command
> inside the if-conditional pipe.

Thanks Phil, this is an easy fix for this.

> Fixes: 73db1b5dab6f ("selftests: netfilter: Torture nftables netdev hooks")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Paolo, you can take this now to calm down CI. Thanks

> ---
>  .../selftests/net/netfilter/nft_interface_stress.sh        | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/netfilter/nft_interface_stress.sh b/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
> index 11d82d11495e..5ff7be9daeee 100755
> --- a/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
> +++ b/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
> @@ -97,7 +97,8 @@ kill $nft_monitor_pid
>  kill $rename_loop_pid
>  wait
>  
> -ip netns exec $nsr nft -f - <<EOF
> +wildcard_prep() {
> +	ip netns exec $nsr nft -f - <<EOF
>  table ip t {
>  	flowtable ft_wild {
>  		hook ingress priority 0
> @@ -105,7 +106,9 @@ table ip t {
>  	}
>  }
>  EOF
> -if [[ $? -ne 0 ]]; then
> +}
> +
> +if ! wildcard_prep; then
>  	echo "SKIP wildcard tests: not supported by host's nft?"
>  else
>  	for ((i = 0; i < 100; i++)); do
> -- 
> 2.49.0
> 
