Received: from mta0.migadu.com (out-44.mta0.migadu.com [91.218.175.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5BB47A0D8
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 08:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548103; cv=none; b=M0nYELDEyu8dfiG9+HVEEvN+hEsldXtPRdrxANZ54Enb3XkG1/r54l8fJuXXRX/DnMUNLQHjWMa6Mr2V4PzYx7KkbJa3hao42ZSfATL6oxATIk5Ckr97gAf/iueEdIA9A9+a6gD+Gro4L8V+ePWF9ztG37WtfSS4Ebd17tBaRnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548103; c=relaxed/simple;
	bh=9QxL4Gb1UAhoBwy3DBUFXQ+YjM+gNoib2VJGzBio/Qc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j1UGk6V8eNzsATU5gsWCfV6rip0YAvTI1EOX9AN+B36eoiH/wfmrq4PCMieeET5tAMfhIjrIlEyQlvjd1BVaOm9WKPC3+erhPZg84LA0kd3TaDSfN9t+w3u33cxqNgMuSocrlWHt7ZgLFMst3ZY5ADr1vCzeYbWPBG41eLOAvhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vYJNJ4Wu; arc=none smtp.client-ip=91.218.175.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vYJNJ4Wu"
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9QxL4Gb1UAhoBwy3DBUFXQ+YjM+gNoib2VJGzBio/Qc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789548092; v=1; x=1790152892;
 b=vYJNJ4WuHE3PjnNGDmf/ESwJ3dvOHEBqzKZMGpfwHmY9P/r3LQW2Aclk1Ksq5mTGyZFQtvO7
 5jqw9lUMQGENtmrYqlSy7RtSRgCeSc97y7ET7+ruVVRjsDrLsqSOg0NhiqgDXCNNtZZEUd9sAbP
 IeZl5tSy9p6T3JXPQg4Q1nKg=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e6d426d6e7280090;
	Wed, 16 Sep 2026 08:41:32 +0000
X-Mizu-Trace-ID: e6d426d6e7280090
X-Migadu-Flow: FLOW_OUT
Message-ID: <047c05f7-be17-4dc5-8774-db6f9c84ae07@linux.dev>
Date: Wed, 16 Sep 2026 16:41:24 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: nf_dup_netdev: Fix net_device reference leak
 in nft_fwd_dup_netdev_offload()
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: davem@davemloft.net, edumazet@google.com, fw@strlen.de, horms@kernel.org,
 kuba@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org,
 phil@nwl.cc, wenxu@ucloud.cn, stable@vger.kernel.org, coreteam@netfilter.org
References: <20260916073627.1971921-1-vulab@iscas.ac.cn>
From: Xuanqiang Luo <xuanqiang.luo@linux.dev>
In-Reply-To: <20260916073627.1971921-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/9/16 15:36, Wentao Liang 写道:
> In nft_fwd_dup_netdev_offload(), dev_get_by_index() gets a reference to
> the net_device corresponding to oif. When nft_flow_action_entry_next()
> fails (returning NULL), the function returns -E2BIG directly without
> dropping the net_device reference via dev_put(), causing a reference
> leak.
> 
> Add dev_put(dev) before returning -E2BIG on failure.
> 
> Fixes: be2861dc36d7 ("netfilter: nft_{fwd,dup}_netdev: add offload support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>   net/netfilter/nf_dup_netdev.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
> index 3b0a70e154cd..dd627b7d72d9 100644
> --- a/net/netfilter/nf_dup_netdev.c
> +++ b/net/netfilter/nf_dup_netdev.c
> @@ -80,8 +80,10 @@ int nft_fwd_dup_netdev_offload(struct nft_offload_ctx *ctx,
>   		return -EOPNOTSUPP;
>   
>   	entry = nft_flow_action_entry_next(ctx, flow);
> -	if (!entry)
> +	if (!entry) {
> +		dev_put(dev);
>   		return -E2BIG;
> +	}
>   
>   	entry->id = id;
>   	entry->dev = dev;

Please update your local tree.

Florian Westphal has already fixed this issue:

https://lore.kernel.org/all/20260605114715.11297-1-fw@strlen.de/

Thanks!
