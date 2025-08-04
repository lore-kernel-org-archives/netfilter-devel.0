Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F044424C68D
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Aug 2025 10:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754304221; cv=none; b=NPSHoI+FpTfy8WRJO3wfLGEO3SAeLP8s04Lx4289rvXrzrnWdHhpY9gIkMlQ6kX9DMHeBPGDmZ2pXzL21pSQn2Lzgem+P26ghQ6EiA0s6DlsZMkewlvC55Q7YMCgbkI8k5IcCXx2VF0wA1UlOzELrEJnWTVEMM1jF5Up/zDnErE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754304221; c=relaxed/simple;
	bh=LB96+Di3hQ5fF0sNfSgu5Q5TIk/SywkEtrDB5PxcLII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jslTQVjA1swp1d/CLB0YxYXbu/L1unN69xjI2KPthG09Ue7W2qo/paDvhCK7Tzr75db7gC7hoHyrp8Wr5yjSnzZrvZez8L1cGFvTaatzCVVOBAI4BA2RYwwATrjpha8icSpbJl5nYuuQRT+NEm29JsuzZSaZmrwDZKGZ6gLg8pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eksKNcVu; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eksKNcVu"
Message-ID: <db583c33-3726-487c-a58f-d57f9a7c5b9c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754304204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OoNroIT4bEA4dsp0NfXJH1mI1a/u9RF3xG7r3lDLIMQ=;
	b=eksKNcVutLIW4IP3WdZEebZ1zO+hbJYr8F/8QM5wvvzWy3nTBtAcYlSdSyuJtSP4BWgMHl
	t0EEosaOTTAkfLs5BxlcQBuqNn1jYWHXUTfAOF5Uh84zkC4klw5TYUTXDDOCXF8k4BMoRD
	zjNKwHkH4A0xr0TEG3njz4mkDb5CxUU=
Date: Mon, 4 Aug 2025 18:43:16 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH net-next] netfilter: clean up returns in
 nf_conntrack_log_invalid_sysctl()
Content-Language: en-US
To: Dan Carpenter <dan.carpenter@linaro.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 kernel-janitors@vger.kernel.org
References: <aJCM48RFXO6hjgGm@stanley.mountain>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aJCM48RFXO6hjgGm@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2025/8/4 18:35, Dan Carpenter wrote:
> Smatch complains that these look like error paths with missing error
> codes, especially the one where we return if nf_log_is_registered() is
> true:
> 
>      net/netfilter/nf_conntrack_standalone.c:575 nf_conntrack_log_invalid_sysctl()
>      warn: missing error code? 'ret'
> 
> In fact, all these return zero deliberately.  Change them to return a
> literal instead which helps readability as well as silencing the warning.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

LGTM, feel free to add:

Acked-by: Lance Yang <lance.yang@linux.dev>

> ---
>   net/netfilter/nf_conntrack_standalone.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 9b8b10a85233..1f14ef0436c6 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -567,16 +567,16 @@ nf_conntrack_log_invalid_sysctl(const struct ctl_table *table, int write,
>   		return ret;
>   
>   	if (*(u8 *)table->data == 0)
> -		return ret;
> +		return 0;
>   
>   	/* Load nf_log_syslog only if no logger is currently registered */
>   	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
>   		if (nf_log_is_registered(i))
> -			return ret;
> +			return 0;
>   	}
>   	request_module("%s", "nf_log_syslog");
>   
> -	return ret;
> +	return 0;
>   }
>   
>   static struct ctl_table_header *nf_ct_netfilter_header;

