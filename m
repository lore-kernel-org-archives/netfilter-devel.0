Received: from mta0.migadu.com (out-140.mta0.migadu.com [91.218.175.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC96228B4FA
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Sep 2026 08:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201403; cv=none; b=K20BN06E1VWFL/p1RnPJFsYfrTJiJZ5ed443AaTbu9VaifiG20EBWPvSe21M4Zpm8fzeQwasus72UnIH/b2S1jSvxmDlDF5nUBZZFQ0xOWVgs84eDH5LAEWh4SmReONCuy1G8R4OmZdS1pMZ94QvGepO712GknuuyMNQch16v8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201403; c=relaxed/simple;
	bh=igEj8RPLwQPyMHnv2SC7ObRdK97a2D0npY35e/NupFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X3h3n8Vtcm9O2MFoAPw23FgIFsVYTtZPYVnDpttttv2lRrgs4tW5Sdiur/m5ojmJGb/O7Goh5IszWqhCbEXz3n/Wnpq+b0E+uy+xQDZYBzAdj9EE+dkgoYbdlB1laT0Phcaa+4j5p1e1x86MnADUhxQPrHTnH7n7lmn8ahY4UY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ACfWwPsv; arc=none smtp.client-ip=91.218.175.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ACfWwPsv"
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=igEj8RPLwQPyMHnv2SC7ObRdK97a2D0npY35e/NupFM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789201396; v=1; x=1789806196;
 b=ACfWwPsvQGOidLgWTwYlrFVjLSOOBa8uPvHR4ZQSaObAUiz+cWaUuzd8GHCBBNVUT82oF1Q0
 2f09f9+Oz0d9OGL0AibHdzQ+wesRioC4lwOxiucaHUbxjK2WHvH/X5CkZnsluAN+ZGJwf7TyQLb
 wrQFF/au27qyBFBI+xrhzMXQ=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0a6468d533e65ccd;
	Sat, 12 Sep 2026 08:23:06 +0000
X-Mizu-Trace-ID: 0a6468d533e65ccd
X-Migadu-Flow: FLOW_OUT
Message-ID: <1ab732d7-393e-4acc-8ed9-80a4366062a8@linux.dev>
Date: Sat, 12 Sep 2026 16:22:56 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] net: remove WARN_ON_ONCE() from the
 dev_fill_forward_path() loop check
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: falemi@asu.edu, Simon Horman <horms@kernel.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Lorenzo Bianconi <lorenzo@kernel.org>, netfilter-devel@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
References: <CA+0ovCgKDOk+Bg6Gh5Lwx94u_jJjQ30-vY1JcY2BYfhnWJJbPA@mail.gmail.com>
From: luoxuanqiang <xuanqiang.luo@linux.dev>
In-Reply-To: <CA+0ovCgKDOk+Bg6Gh5Lwx94u_jJjQ30-vY1JcY2BYfhnWJJbPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/9/12 15:40, Farhad Alemi 写道:
> ipip_fill_forward_path() and ip6_tnl_fill_forward_path() look up the
> route to the tunnel's remote endpoint and set ctx->dev to its device,
> which is the tunnel itself when that route resolves back to the tunnel.
> dev_fill_forward_path() then makes no progress and trips
> WARN_ON_ONCE(last_dev == ctx->dev) as soon as a flowtable tries to
> offload a flow through the tunnel. That routing loop is a configuration
> any CAP_NET_ADMIN user can set up, and ip_tunnel_xmit() and
> ip6_tnl_xmit() already treat it as a tx error, so remove the warning and
> just fail the walk, as commit 008e7a7c293b ("net: remove WARN_ON_ONCE
> when accessing forward path array") did for the path stack overflow.
> 
> Fixes: ab427db17885 ("netfilter: flowtable: Add IPIP rx sw acceleration")
> Fixes: d98103575dcd ("netfilter: flowtable: Add IP6IP6 rx sw acceleration")
> Closes: https://lore.kernel.org/all/CA+0ovCgaRvbd0Udj70b2xxG8Cx3CaCpNhnf1V4RWQuDveZYZhA@mail.gmail.com/
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Assisted-by: Claude:claude-opus-5 syzkaller
> Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>

Reviewed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

Thanks,
Xuanqiang

> ---
> v2:
>   - Remove the WARN_ON_ONCE() in dev_fill_forward_path() instead of
>     rejecting the looping route in the tunnel drivers (Pablo Neira Ayuso).
>   - Add the Fixes: tags (Xuanqiang Luo).
> 
> v1: https://lore.kernel.org/all/CA+0ovCj+Pd5owGH+51rA8-RDu9YFx5oYUv8bV0zOE72QgVfY0A@mail.gmail.com/
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index ecfbd72d5d1a..c67900354fa6 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -789,7 +789,7 @@ int dev_fill_forward_path(struct net_device_path_ctx
>   			goto err_out;
> 
>   		stack->num_paths++;
> -		if (WARN_ON_ONCE(last_dev == ctx->dev))
> +		if (last_dev == ctx->dev)
>   			goto err_out;
>   	}
> 

