Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA371A5BB2
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 21:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741209207; cv=none; b=o5RQ2v13xDyHFRdQQNI3iHmtbCMtjLFm3cegXZU4ajAjDMWI8iYMEKTCvjBUz3TQXRUWQC+RSQeoVamomH8SeQPqyX0uvzOPODMcx3qTojq0N6tbT/MVoNrO/CZUOlJObPrjJHX8wi3Hb/aEuqMkc2rjFCEaf9qIvK8UzTKw8UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741209207; c=relaxed/simple;
	bh=9aqiFss/UhDJXWrN43jFj9t8l3C81wAZkyjl0QclQs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eeh7oBby74OrAqJRPxQAc+BJJ1GzFYbjVpVmsfutfLHwvupE39O+LJDNJkV4PvxzkRZoXNrBQOnBP9h+eBftlUw/U9eT2kIOIG+ssxw4bNjeAepDupWZqkB1pAAy7DkUaqd7dl6PAvZPeqy6nDI8YC9giIyZhd+7n4pnsFRvtDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kdnL0nxZ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kdnL0nxZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kdnL0nxZ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kdnL0nxZ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B83FE6029C; Wed,  5 Mar 2025 22:13:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741209202;
	bh=7tmip8yQspmK3oAR+K9aeL4mJodesfwOAf5IUln8KTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kdnL0nxZA1WZKgOyGc3yG57e1ebzeBO/xEvDWDMECS6OJoUXkEaqW7FBltNzm0RXj
	 0LxJEajz4cltgupv8BAQF4booaQirUevM5lEscje1mp63f4SsY2Im0KwZRH62JeV+J
	 hxZdawmKYu7hOiGquF4zBg/wOOeR4IrfDI4x5ltp1JTuXcS5Zqh8AlYuRgleoDYyFE
	 cmV0NGYTeaOFnbNXMOkHGVajprnOqUirMIsapSt4xIZkfrOHBFLi0ttXocfR74du7Q
	 uLHRnEI+ADpsa9S8b2PXS8K+o0pBXQ/OpucaqyxvYcvRv4FZSop10wRta+rKj1NlCd
	 8sYfAWn4HvJZQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 01BF46029C;
	Wed,  5 Mar 2025 22:13:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741209202;
	bh=7tmip8yQspmK3oAR+K9aeL4mJodesfwOAf5IUln8KTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kdnL0nxZA1WZKgOyGc3yG57e1ebzeBO/xEvDWDMECS6OJoUXkEaqW7FBltNzm0RXj
	 0LxJEajz4cltgupv8BAQF4booaQirUevM5lEscje1mp63f4SsY2Im0KwZRH62JeV+J
	 hxZdawmKYu7hOiGquF4zBg/wOOeR4IrfDI4x5ltp1JTuXcS5Zqh8AlYuRgleoDYyFE
	 cmV0NGYTeaOFnbNXMOkHGVajprnOqUirMIsapSt4xIZkfrOHBFLi0ttXocfR74du7Q
	 uLHRnEI+ADpsa9S8b2PXS8K+o0pBXQ/OpucaqyxvYcvRv4FZSop10wRta+rKj1NlCd
	 8sYfAWn4HvJZQ==
Date: Wed, 5 Mar 2025 22:13:19 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: add atomic chain replace test
Message-ID: <Z8i-b2-7a7xMl1Nr@calendula>
References: <20250303193829.570630-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250303193829.570630-1-fw@strlen.de>

On Mon, Mar 03, 2025 at 08:38:20PM +0100, Florian Westphal wrote:
> Add a test that replaces one base chain and check that no
> filtered packets make it through, i.e. that the 'old chain'
> doesn't disappear before new one is active.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  .../testcases/transactions/atomic_replace.sh  | 73 +++++++++++++++++++
>  .../dumps/atomic_replace.sh.nodump            |  0
>  2 files changed, 73 insertions(+)
>  create mode 100755 tests/shell/testcases/transactions/atomic_replace.sh
>  create mode 100644 tests/shell/testcases/transactions/dumps/atomic_replace.sh.nodump
> 
> diff --git a/tests/shell/testcases/transactions/atomic_replace.sh b/tests/shell/testcases/transactions/atomic_replace.sh
> new file mode 100755
> index 000000000000..dce178602a6f
> --- /dev/null
> +++ b/tests/shell/testcases/transactions/atomic_replace.sh
> @@ -0,0 +1,73 @@
> +#!/bin/bash
> +
> +set -e
> +
> +rnd=$(mktemp -u XXXXXXXX)
> +ns="nft-atomic-$rnd"
> +pid1=""
> +pid2=""
> +duration=8
> +
> +cleanup()
> +{
> +	kill "$pid1" "$pid2"
> +	ip netns del "$ns"
> +}
> +
> +trap cleanup EXIT
> +
> +ip netns add "$ns" || exit 111
> +ip -net "$ns" link set lo up
> +
> +ip netns exec "$ns" ping 127.0.0.1 -q -c 1
> +
> +ip netns exec "$ns" $NFT -f - <<EOF
> +table ip t {
> +	set s {
> +		type ipv4_addr
> +		elements = { 127.0.0.1 }
> +	}
> +
> +	chain input {
> +		type filter hook input priority 0; policy accept;
> +		ip protocol icmp counter
> +	}
> +
> +	chain output {
> +		type filter hook output priority 0; policy accept;
> +		ip protocol icmp ip daddr @s drop
> +	}
> +}
> +EOF
> +
> +ip netns exec "$ns" ping -f 127.0.0.1 &
> +pid1=$!
> +ip netns exec "$ns" ping -f 127.0.0.1 &
> +pid2=$!
> +
> +time_now=$(date +%s)
> +time_stop=$((time_now + duration))
> +repl=0
> +
> +while [ $time_now -lt $time_stop ]; do
> +ip netns exec "$ns" $NFT -f - <<EOF
> +flush chain ip t output
> +table ip t {
> +	chain output {
> +		type filter hook output priority 0; policy accept;
> +		ip protocol icmp ip daddr @s drop
> +	}
> +}
> +EOF
> +	repl=$((repl+1))
> +
> +	# do at least 100 replaces and stop after $duration seconds.
> +	if [ $((repl % 101)) -eq 100 ];then
> +		time_now=$(date +%s)
> +	fi
> +done
> +
> +# must match, all icmp packets dropped in output.
> +ip netns exec "$ns" $NFT list chain ip t input | grep "counter packets 0"
> +
> +echo "Completed $repl chain replacements"
> diff --git a/tests/shell/testcases/transactions/dumps/atomic_replace.sh.nodump b/tests/shell/testcases/transactions/dumps/atomic_replace.sh.nodump
> new file mode 100644
> index 000000000000..e69de29bb2d1
> -- 
> 2.48.1
> 
> 
