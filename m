Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065E818950F;
	Wed, 28 Aug 2024 14:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724856499; cv=none; b=TgrUOSVMddRak8J0LAKMFkUnlm7IPyu0vQS8kOgS7t0XkAkX/5VMzQpjlDDgFMN4YZp4apDlbSw1/eFfBiAezynpHhQqdJX4M6HOkoJzleUecVWCfFRhqnkCvtaOLc6n3AOyNI7uV17dnFqSfmYeS0Fvbm0dSS+C3RtFCyWMoUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724856499; c=relaxed/simple;
	bh=udLDLVhkq46Qt9DHf04u4ABYNrg6/v89T/27K1UtEio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CwKjoE7PfshxkXmPrt3SI3MFPi7mkxL/4Nh4H7lqk0ce6OwUogJFp0vaclSWcznbs5+ms7CSQxz2tC3sWDLnIvBJ/KrduGQ/ATg+d3VXaOEPjDGx314POw2+jSCm8E0w1S6+BuvAdEd3msurGF1yzpS1aoqylnefDEcQbMKW7Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=33600 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sjJxz-001bvs-At; Wed, 28 Aug 2024 16:48:13 +0200
Date: Wed, 28 Aug 2024 16:48:10 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] selftests: netfilter: nft_queue.sh: reduce test
 file size for debug build
Message-ID: <Zs84qoMn0Axy-c1d@calendula>
References: <20240826192500.32efa22c@kernel.org>
 <20240827090023.8917-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240827090023.8917-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Tue, Aug 27, 2024 at 11:00:12AM +0200, Florian Westphal wrote:
> The sctp selftest is very slow on debug kernels.
> 
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Closes: https://lore.kernel.org/netdev/20240826192500.32efa22c@kernel.org/
> Fixes: 4e97d521c2be ("selftests: netfilter: nft_queue.sh: sctp coverage")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  Lets see if CI is happy after this tweak.
> 
>  tools/testing/selftests/net/netfilter/nft_queue.sh | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
> index f3bdeb1271eb..9e5f423bff09 100755
> --- a/tools/testing/selftests/net/netfilter/nft_queue.sh
> +++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
> @@ -39,7 +39,9 @@ TMPFILE2=$(mktemp)
>  TMPFILE3=$(mktemp)
>  
>  TMPINPUT=$(mktemp)
> -dd conv=sparse status=none if=/dev/zero bs=1M count=200 of="$TMPINPUT"
> +COUNT=200
> +[ "$KSFT_MACHINE_SLOW" = "yes" ] && COUNT=25
> +dd conv=sparse status=none if=/dev/zero bs=1M count=$COUNT of="$TMPINPUT"
>  
>  if ! ip link add veth0 netns "$nsrouter" type veth peer name eth0 netns "$ns1" > /dev/null 2>&1; then
>      echo "SKIP: No virtual ethernet pair device support in kernel"
> -- 
> 2.46.0
> 
> 
