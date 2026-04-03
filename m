Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9883B7B80;
	Fri,  3 Apr 2026 11:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775215913; cv=none; b=skyn8OQuCtTo54Mwk1LgFlhrQkcevjdOVRVDh/y8CZmkKvhXRWXuYSl3rE5gmPMg87lMcx25t5tctZ8DKN1+QGIsyozTOCdAvAZqwc7ziLJB4Y/6rMqqSdqBG1JgwNWrpike+7gy+OllRMxL4BB2o9TMicNpGd8nq7d1ym5fjws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775215913; c=relaxed/simple;
	bh=hw9vVJ/9ofYm7xcOtSUi3kDUj/K6JiJZWSWNvpjo6SM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ea6VnP8mlTIJMkKQkog+q16BH4GhfhSTozs8cQZ32/E1XqKPPbGXPDYPpz30t23xETK84uK5kK/EfPAXFULifN4D1kW3JNZMQWcZsZlmYsdwPcdg0Eh5K9ggFAEvyQ5j5qZ2VGckfx/BfcCrG6mT1ukunVw6UP+4tpd5Q4AJH2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Drw526LX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Drw526LX"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DB77F60263;
	Fri,  3 Apr 2026 13:31:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775215905;
	bh=f2Ze/DFrB8iHp4LQ1YCD1tHzYUC4hCcRW+FKgOT532A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Drw526LXxLn+vnzboYmZuPfsGy1xJngDeu13z5ivmayIuIrbI7JMFAcbTFlMoYEx2
	 4xs0Hvr5Kn96xk5KxUJplOaoCajHeUHZ/DzyQI4Cs0YFn6LYeo4GWl55tCWydWpK/e
	 SqWBU27Q9XbX+bJ/GChReF9Y9dYKP+lpODk49ww8sAqoItV4891YmfsJ3KnUkreHD9
	 gtDOG1C0xCFpMIvGUBMusQpq+LxVDf2YGew1hmqhYpYOGxtna/SGRJAVyMh+UPicyD
	 b5uXsLJI/FcjJrhuFYJULAtm1WKpkgdd3MYgZhGzOCO126BmA6crIMgjIKPtqpxBxG
	 n39c3NHZmGqDw==
Date: Fri, 3 Apr 2026 13:31:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, fw@strlen.de,
	phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	yasuyuki.kozakai@toshiba.co.jp, kaber@trash.net,
	yifanwucs@gmail.com, tomapufckgml@gmail.com, yuantan098@gmail.com,
	bird@lzu.edu.cn, z1652074432@gmail.com
Subject: Re: [PATCH v3] netfilter: xt_multiport: validate range encoding in
 checkentry
Message-ID: <ac-lHcg6NTg9sWGY@lemonverbena>
References: <cover.1774624314.git.n05ec@lzu.edu.cn>
 <d5c0d106e724c732436b985dd694272bcb813bb1.1775153311.git.n05ec@lzu.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d5c0d106e724c732436b985dd694272bcb813bb1.1775153311.git.n05ec@lzu.edu.cn>

On Fri, Apr 03, 2026 at 02:21:17AM +0800, Ren Wei wrote:
> ports_match_v1() treats any non-zero pflags entry as the start of a
> port range and unconditionally consumes the next ports[] element as
> the range end.
> 
> The checkentry path currently validates protocol, flags and count, but
> it does not validate the range encoding itself. As a result, malformed
> rules can mark the last slot as a range start or place two range starts
> back to back, leaving ports_match_v1() to step past the last valid
> ports[] element while interpreting the rule.
> 
> Reject malformed multiport v1 rules in checkentry by validating that
> each range start has a following element and that the following element
> is not itself marked as another range start.
> 
> Fixes: a89ecb6a2ef7 ("[NETFILTER]: x_tables: unify IPv4/IPv6 multiport match")
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Co-developed-by: Yuan Tan <yuantan098@gmail.com>
> Signed-off-by: Yuan Tan <yuantan098@gmail.com>
> Suggested-by: Xin Liu <bird@lzu.edu.cn>
> Tested-by: Yuhang Zheng <z1652074432@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
> Changes in v2:
> - drop the selftest patch
> - send the fix publicly to netfilter-devel
> 
> Changes in v3:
> - drop datatype cleanup from the fix
> - keep the original check() interface unchanged
> - validate malformed range encoding in checkentry
> 
>  net/netfilter/xt_multiport.c | 30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
> index 44a00f5acde8..07a0f2a3fc75 100644
> --- a/net/netfilter/xt_multiport.c
> +++ b/net/netfilter/xt_multiport.c
> @@ -105,6 +105,24 @@ multiport_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  	return ports_match_v1(multiinfo, ntohs(pptr[0]), ntohs(pptr[1]));
>  }
>  
> +static inline bool
> +multiport_valid_ranges(const struct xt_multiport_v1 *multiinfo)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < multiinfo->count; i++) {
> +		if (!multiinfo->pflags[i])
> +			continue;
> +
> +		if (i + 1 >= multiinfo->count || multiinfo->pflags[i + 1])
> +			return false;
> +
> +		i++;
> +	}
> +
> +	return true;
> +}

I'd suggest:

static inline bool
multiport_valid_ranges(const struct xt_multiport_v1 *multiinfo)
{
        unsigned int i;
 
        for (i = 0; i < multiinfo->count; i++) {
                if (!multiinfo->pflags[i])
                        continue;

                if (++i >= multiinfo->count)
                        return false;
         
                if (multiinfo->pflags[i])
                        return false;
         
                if (multiinfo->ports[i - 1] > multiinfo->ports[i])
                        return false;
        }
 
        return true;
}

Then, this validate non-sense ports array too.
