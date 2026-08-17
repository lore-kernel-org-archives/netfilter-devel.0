Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9327243964
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 16:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786982893; cv=none; b=QMFSZZFqdZQs2a/tctdDTxixR9CNPS3EJh1VBNIX3VAmUHDlmCfJiZx0PNHkBxTmaYAPrj7iIKzYbN93ixx7DE3IByjITMqP8nWfEjhd2n9SIrAmdZR6/Utmbvm45YIDFpRuPACBJ/g8ycadhEtMEB4ECrBNT51UbSrqpQWb/t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786982893; c=relaxed/simple;
	bh=qR2ZwUWeWn/sj+xBvwY62cR/S40RRpvSjblbOyUdzWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ek7IUAL/ISxt5fKpVyl3Z9qrvrgUQLGSMJhNG2YrPStzQ7OJGNhDDB106n012y4OtJ/6zXDtKxmaJLxhTqLuX7ihIR9DshdVX1Gcye5zh2y1bgQ9+cV3/lHqv8k5rT2mn8xtFGHh5FJuTX00XoB8ML76q1IpfT0iDm6aXj3ewUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bVXOSspy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bVXOSspy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786982888;
	bh=YfuKqyC+0on9oMeM0boteQBAKWCNcQnwJHeGYdiPM7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bVXOSspyBp3EgHdyvyVGWlbl82cSeC0mHGEiM2USdqtiFasVvnVCG9hHcx61IGWCM
	 S4aapxvsG2oiQuHVaJ/wqXJOxY875Y7r5o9DYjyF9XxjMN6LkMNIm28YlWrJtWE1qu
	 D8wnPV0raABkFz/N21wpLVz/s1b8ZF+5e68rxx1PZyOuQWTMIwiIXvc94FJ6d4dlg1
	 gc5JURpFn5c7Fd0pq48NpO7wor7EjL3SrU++0D8Uz69B4wTjNvX2BdBhyAvU6IAc+a
	 snUY7oWaVQKOnxuz66teOHHJ7TSQ5OSav+Tj2NaGdIlygtQZ+Do6HCGfe+ZoRSoeX4
	 xdxe8AoimVaPQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D52386007E;
	Mon, 17 Aug 2026 18:08:07 +0200 (CEST)
Date: Mon, 17 Aug 2026 18:08:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: ZhilingZouzhilinz@nebusec.ai
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	horms@kernel.org, bazsi@balabit.hu, kaber@trash.net,
	hidden@balabit.hu, vega@nebusec.ai, zhilinz@nebusec.ai
Subject: Re: [PATCH nf 1/1] netfilter: xt_TPROXY: require IPv6 protocol match
Message-ID: <aoMx5TSCLinBXwNz@chamomile>
References: <cover.1786968834.git.zhilinz@nebusec.ai>
 <6ca536c61d358bfb1bdfd20aafe3cc16acfd45db.1786968834.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6ca536c61d358bfb1bdfd20aafe3cc16acfd45db.1786968834.git.zhilinz@nebusec.ai>

On Mon, Aug 17, 2026 at 08:26:37PM +0800, ZhilingZouzhilinz@nebusec.ai wrote:
> From: Zhiling Zou <zhilinz@nebusec.ai>
> 
> tproxy_tg6_check() verifies the protocol field value but does not
> require IP6T_F_PROTO. A crafted ip6tables rule can set the field to
> TCP or UDP while leaving the protocol matching flag clear.
> 
> ip6_packet_match() treats such a rule as protocol agnostic and can
> invoke tproxy_tg6_v1() for ICMPv6. nf_tproxy_get_sock_v6() warns for
> protocols other than TCP and UDP.
> 
> Reject rules without IP6T_F_PROTO so TPROXY is invoked only for the
> protocols it supports.
> 
> Fixes: 6ad7889327a5e ("tproxy: added IPv6 support to the TPROXY target")
> Cc: stable@vger.kernel.org
> Reported-by: Vega <vega@nebusec.ai>
> Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
> ---
>  net/netfilter/xt_TPROXY.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
> index 5f60e7298a1ea..13a94c9d06c0f 100644
> --- a/net/netfilter/xt_TPROXY.c
> +++ b/net/netfilter/xt_TPROXY.c
> @@ -179,7 +179,8 @@ static int tproxy_tg6_check(const struct xt_tgchk_param *par)
>  	if (err)
>  		return err;
>  
> -	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP) &&
> +	if ((i->flags & IP6T_F_PROTO) &&
> +	    (i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP) &&
>  	    !(i->invflags & IP6T_INV_PROTO))

And why not tproxy_tg4_check?

>  		return 0;
>  
> -- 
> 2.43.0
> 
