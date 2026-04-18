Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB3536EAA5;
	Sat, 18 Apr 2026 07:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498809; cv=none; b=VgFqlIP9E5ZMVDrcWegDH3FsCgzN4HarQc2T+aHsWcG5iIH5Hyi7pMRctYlsErvYzkrOrbuhDxXI1HhfqAXy3kEs8X9+dWzhv618Orxv61T8StvJGlv75PI0UPkqTu1z/OX+3GrB/1+/7dAaAhPA/1BVwgCq2KD1FHpG92zFBnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498809; c=relaxed/simple;
	bh=6zZ1a+qKZhdClvAuRQmWHwCcbSkt7cijHxe0eO17cBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SRKHTiru5FHRVmLGhT0BvhXyt/nX0IvyJM6M2eSorC6+8WOLivRWBpjiY8UdiOvD2+ujXfWIZpjj8YG4yBE72bmy9JUGlTVBQPaRVOjlrPh0F+82cvZ3t1T/cV5C8vszcFcuiClNJg22TnOBr8WhCRXKgjKJUPzB9KWqIgg+nCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ATjZEqTT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ATjZEqTT"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E56F16026E;
	Sat, 18 Apr 2026 09:53:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776498805;
	bh=khR9e0VtESCyMdhpmmjtB0hEbrS9fbM/06QAeE528iw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ATjZEqTTJhJYx+zU81xTIR6glPBnGfqlX5fQjI92wa0IZSUK6L4ezjLS000h8F8Df
	 jISXEk17TnyW1QC5oUCQSW35uXQyv22u+cBtj/Q+NsdkjEvrS7iEUPe7viH3YAI1t5
	 5dF7p4CzJTRIOHV4DC0VIXvMDcQqnhd2n3TtTw6bh8XOGvp+R00wtGrlcQKUFwqo2M
	 HzJUZK5oYfANslC6sjpmxY2wNHo6GCGRlKprWd1IProHFFr4HbIoY5GhfmMUqH2RF9
	 ahJscvvZbrVLoRuMm6jduSnX/ZkwY0WmxZZ7G2QSWHwDZT6Eu01kFtv1ZmMPxDgvaP
	 tY7LK2KZUtjDQ==
Date: Sat, 18 Apr 2026 09:53:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	coreteam@netfilter.org, fw@strlen.de, phil@nwl.cc,
	"Kito Xu (veritas501)" <hxzene@gmail.com>
Subject: Re: [PATCH 2/2 nf] netfilter: nfnetlink_osf: fix potential NULL
 dereference in ttl check
Message-ID: <aeM4ctFJOxAttIrk@chamomile>
References: <20260417162057.3732-1-fmancera@suse.de>
 <20260417162057.3732-2-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260417162057.3732-2-fmancera@suse.de>

On Fri, Apr 17, 2026 at 06:20:57PM +0200, Fernando Fernandez Mancera wrote:
> The nf_osf_ttl() function accessed skb->dev to perform a local interface
> address lookup without verifying that the device pointer was valid.
> 
> Additionally, the implementation utilized an in_dev_for_each_ifa_rcu
> loop to match the packet source address against local interface
> addresses. It assumed that packets from the same subnet should not see a
> decrement on the initial TTL. A packet might appear it is from the same
> subnet but it actually isn't especially in modern environments with
> containers and virtual switching.
> 
> Remove the device dereference and interface loop. Replace the logic with
> a switch statement that evaluates the TTL according to the ttl_check.
> 
> Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
> Reported-by: Kito Xu (veritas501) <hxzene@gmail.com>
> Closes: https://lore.kernel.org/netfilter-devel/20260414074556.2512750-1-hxzene@gmail.com/
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
> Note: if some help is needed during the backport I can assist.
> ---
>  net/netfilter/nfnetlink_osf.c | 22 +++++++---------------
>  1 file changed, 7 insertions(+), 15 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
> index f58267986453..f0d1e596e146 100644
> --- a/net/netfilter/nfnetlink_osf.c
> +++ b/net/netfilter/nfnetlink_osf.c
> @@ -31,26 +31,18 @@ EXPORT_SYMBOL_GPL(nf_osf_fingers);
>  static inline int nf_osf_ttl(const struct sk_buff *skb,
>  			     int ttl_check, unsigned char f_ttl)
>  {
> -	struct in_device *in_dev = __in_dev_get_rcu(skb->dev);
>  	const struct iphdr *ip = ip_hdr(skb);
> -	const struct in_ifaddr *ifa;
> -	int ret = 0;
>  
> -	if (ttl_check == NF_OSF_TTL_TRUE)
> +	switch (ttl_check) {
> +	case NF_OSF_TTL_TRUE:
>  		return ip->ttl == f_ttl;
> -	if (ttl_check == NF_OSF_TTL_NOCHECK)
> -		return 1;
> -	else if (ip->ttl <= f_ttl)
> +		break;
> +	case NF_OSF_TTL_NOCHECK:
>  		return 1;
> -
> -	in_dev_for_each_ifa_rcu(ifa, in_dev) {
> -		if (inet_ifa_match(ip->saddr, ifa)) {
> -			ret = (ip->ttl == f_ttl);
> -			break;
> -		}
> +	case NF_OSF_TTL_LESS:
> +	default:
> +		return ip->ttl <= f_ttl;
>  	}
> -
> -	return ret;
>  }
>  
>  struct nf_osf_hdr_ctx {
> -- 
> 2.53.0
> 
