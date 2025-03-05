Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88B72571CF
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 21:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741209249; cv=none; b=GMDSnkgS2TDIr1ExspM2YKVHJT43oDFFVsLokZtzOQCuSCoBGiShyTH6e2wTiWXjzsYlMVU+uaO2fSkOUuD4oHvhnP17SljSNFcaLEIvUdZ9RyGv0N4DkZQCZVHCIHxRpggpb0AxNBH+dcTWFePIicHkNaL5gaBCq6gKxpvDVqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741209249; c=relaxed/simple;
	bh=x8ch53gU+quiiUQuCu7XBuhCHYjSS/N2fvxw8Jiiq08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bSfYB16zTkpS/UinQIdbGTJtD7qX9JimP0ENEIONNXdrppBllke5Ge8Ul9ePrTdv9hje+14PhhVzdnXMgsdnpZ/HFXzMsOvacNa1BRXCKd7IFlDSaGlVmcQGAOPaORZ0+V+eGP3qpEAgwtnn80pcvyws38GzTxOuvTMZ5PML0fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=h4ayyHZF; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=B61WccnG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="h4ayyHZF";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="B61WccnG"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 38F4A602AF; Wed,  5 Mar 2025 22:14:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741209246;
	bh=Ei3QcIlmUfrquHm47y+qv1PSOprlDrFak/2oIGsCi8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h4ayyHZFFHDCayQ6Ctmp2+UP/t6lJWw+wxwHTP+XggWfZfQTppknoPVPIDEiF9Azn
	 NPnjlCXQiQcze3ph6PheMgGPHKmiXkH+ltXN9wVYwjU1oNMCbqcSDTItM+FcZpUEw9
	 hyHVRi8xizJksIOAFlHyPTUPJi/PBhmRVSUM6oO1VHpVVZaKO4QExevXejeAhyZdr7
	 4O6lyWoFTS42v42jBrQH+ZI7War885ylet0cZcehqBjewg6sd3M7LhdH7CotgJTCv2
	 kd4vgkrGrwRfcHI+zBjMhj7AninxdKq5YeGzHtS/k+zl5U2WnDmm1r+e3lear00N0B
	 zsaz0RIsa6Hng==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 95A87602AF;
	Wed,  5 Mar 2025 22:14:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741209245;
	bh=Ei3QcIlmUfrquHm47y+qv1PSOprlDrFak/2oIGsCi8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B61WccnGOsqLsdkYiKeAQCzJcrWjh9wd+GGoQfSpPkeyqIYiTOAi+BBUBhM0wQIT1
	 SMzkfkeUZ5AEyNFwC/gvdSAydJmGixAIHYggQTc/FUcYYLRL3LhRLV6g3P3978O2kV
	 RjRKC5DAwrHJDDwqdjTACt13OJzi4yahpMuGjbdeE5bvOYy+lW9XaqXYOFaZ+UTPll
	 5wSQgd2MjzgznPRrYPENqqHW0CI1dU6WjehKaBWg4a83jWxlv4zsN5T1A7VIhWa7TY
	 PKBLRX2v18ORIgTOnD8yciG4QAOUd1KYgYvwnU3yz1V/+dTZqxUHI49nGhYavjXgVy
	 A26fZpJVSwIQw==
Date: Wed, 5 Mar 2025 22:14:02 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: remove temporary file
Message-ID: <Z8i-mktqESZPSs6m@calendula>
References: <20250304151202.2570205-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250304151202.2570205-1-fw@strlen.de>

On Tue, Mar 04, 2025 at 04:11:57PM +0100, Florian Westphal wrote:
> 0002-relative leaves a temporary file in the current working
> directory, at the time the "trap" argument is expanded, tmpfile2
> isn't set.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  tests/shell/testcases/include/0002relative_0 | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/shell/testcases/include/0002relative_0 b/tests/shell/testcases/include/0002relative_0
> index dbf11e7db171..ac8355475320 100755
> --- a/tests/shell/testcases/include/0002relative_0
> +++ b/tests/shell/testcases/include/0002relative_0
> @@ -7,9 +7,14 @@ if [ ! -w "$tmpfile1" ] ; then
>  	exit 77
>  fi
>  
> -trap "rm -rf $tmpfile1 $tmpfile2" EXIT # cleanup if aborted
> -set -e
> +cleanup()
> +{
> +	rm -f "$tmpfile1" "$tmpfile2"
> +}
> +
> +trap cleanup EXIT
>  
> +set -e
>  tmpfile2=$(mktemp -p .)
>  
>  RULESET1="add table x"
> -- 
> 2.48.1
> 
> 
