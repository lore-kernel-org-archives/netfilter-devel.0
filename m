Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51310279DA9
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 07:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751615154; cv=none; b=brY6E9ToXvJHstHHXa9UOZizR1s2zqlJs7UnhBljBlsQiKrkFdDuvVlxi1kaBM1e9o5qNQg8nObELf4nk8l3eP9somjjq2F84G9VAvXblC56PnLdXvFF/ZDGqrWb2zyzZSzLo8jOYzI8NqVd3xyKIsjDPEKhNemMEJGWSyZ52+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751615154; c=relaxed/simple;
	bh=jXCFm7Qd/GR3v+lPmWqrche1e2kq9uq7qgZuuKrnzmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mJNiIjHbpsSUezclTN2iDDWQ96tf6KTTbsAxVFVA+ebvfKzSfQHUX/Zjz38aD32qA0Wpok+LPJ0oYGiyH7qZO+y1NeTY1K4k9kmiucXAYaTqr7Ee+wKU1fJYTebCkHIoE+FE9Cd4gfo+V4YfhKAUEUlHg1sITw96vG/Ck1aD6ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=E3wInYHw; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jDGMVRbp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="E3wInYHw";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jDGMVRbp"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3145060273; Fri,  4 Jul 2025 09:45:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751615149;
	bh=F/wHQOXeRgI8LyZ7aVTf550EKimuTWjTvSbRG7jWe90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E3wInYHw7h238ObvJlSBxszupJ/mc+TDYQJojCDWK8VdgyvBPS8Y4A2oGubEfMSVW
	 ZiImTGc62/dZrIQKffEV0jUblf73xys4ubGv6vpnY1tKBOWGm19qOMtBC4mWmEFtA9
	 ZzfG3faoFqL9TA0m5PDCntndWqXM/vvm5KRF5iTnKLhvssiO0suXkFRz3YpPkM5aYJ
	 tqUe+KirZtka1soeTt7uxHPlo6qpHATc8E9ukSYi+WphJNbVANIyIDBnPrDhCISoYK
	 zS7itr6e+d87KlrDOkVVxehAD2bZf52yTi+tnJW2a6K7NcWTdVWv/TG2eU1+Lh3Gte
	 eTf/B9fpeb7oA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5EA7260273;
	Fri,  4 Jul 2025 09:45:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751615148;
	bh=F/wHQOXeRgI8LyZ7aVTf550EKimuTWjTvSbRG7jWe90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jDGMVRbpmRFnwo6IxLRRq0l7JEiRE9DuehhKuExed9bT5lL3PmX8+++ZM3noi5jvf
	 n1cPbHmLdo1Lkk6ugdGDZlstmPxJLFsINHwfAeblMsxzz3Fl5dURNIi+Er3eUTOb+a
	 HYegiz8K8vwlYH4ZjjOrosS4+Gdd2VoJPuL6ZedpBPrtqo9ZFLVjCS6tM0fGstBlQT
	 cnbKO3VmExj/JkITOH7p4HF7x+qc5vOEnZJCRK8bBuBlj4ZuuAHiMwlGNgdqYQJ2dM
	 vuDzMow79ATmAJsGCzxtJp/+quT1DQz3rbFQOoGqJG244S2uAWQXEe4uYgGNJ3fQYK
	 4sFxY8k66aqDA==
Date: Fri, 4 Jul 2025 09:45:45 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: add conntrack information to trace monitor mode
Message-ID: <aGeGqWYZy-ng2Xrm@calendula>
References: <20250508153358.8015-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250508153358.8015-1-fw@strlen.de>

Hi Florian,

On Thu, May 08, 2025 at 05:33:56PM +0200, Florian Westphal wrote:
> Upcoming kernel change provides the packets conntrack state in the
> trace message data.
> 
> This allows to see if packet is seen as original or reply, the conntrack
> state (new, establieshed, related) and the status bits which show if e.g.
> NAT was applied.  Alsoi include conntrack ID so users can use conntrack
> tool to query the kernel for more information via ctnetlink.
> 
> This improves debugging when e.g. packets do not pick up the expected
> NAT mapping, which could e.g. also happen because of expectations
> following the NAT binding of the owning conntrack entry.

This feature will be present in the next kernel.

> Example output ("conntrack: " lines are new):
> 
> trace id 32 t PRE_RAW packet: iif "enp0s3" ether saddr [..]
> trace id 32 t PRE_RAW rule tcp flags syn meta nftrace set 1 (verdict continue)
> trace id 32 t PRE_RAW policy accept
> trace id 32 t PRE_MANGLE conntrack: ct direction original ct state new ct id 2641368242
> trace id 32 t PRE_MANGLE packet: iif "enp0s3" ether saddr [..]
> trace id 32 t ct_new_pre rule jump rpfilter (verdict jump rpfilter)
> trace id 32 t PRE_MANGLE policy accept
> trace id 32 t INPUT conntrack: ct direction original ct state new ct status dnat-done ct id 2641368242
> trace id 32 t INPUT packet: iif "enp0s3" [..]
> trace id 32 t public_in rule tcp dport 443 accept (verdict accept)
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Comment below.

> ---
>  src/ct.c      |   4 ++
>  src/netlink.c | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 114 insertions(+)
> 
> diff --git a/src/ct.c b/src/ct.c
> index 71ebb9483893..fc43bf63f02c 100644
> --- a/src/ct.c
> +++ b/src/ct.c
> @@ -98,7 +98,11 @@ static const struct symbol_table ct_status_tbl = {
>  		SYMBOL("confirmed",	IPS_CONFIRMED),
>  		SYMBOL("snat",		IPS_SRC_NAT),
>  		SYMBOL("dnat",		IPS_DST_NAT),
> +		SYMBOL("seq-adjust",	IPS_SEQ_ADJUST),
> +		SYMBOL("snat-done",	IPS_SRC_NAT_DONE),
> +		SYMBOL("dnat-done",	IPS_DST_NAT_DONE),

These will be now exposed through 'ct status' forever, not sure we
have a usecase to allow users to match on this.

I know these are exposed through uapi, but I don't have a usecase for
them to allow users to match on them.

Maybe it is _not_ worth, those flags have been there since the
beginning.

If we go for exposing these flags through ct status, do you think it
is possible to provide terse description of these "new flags" in the
manpage?

>  		SYMBOL("dying",		IPS_DYING),
> +		SYMBOL("fixed-timeout",	IPS_FIXED_TIMEOUT),
>  		SYMBOL_LIST_END
>  	},
>  };
> diff --git a/src/netlink.c b/src/netlink.c
> index 86ca32144f02..b1d1dc7f4bd1 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -2116,6 +2116,114 @@ next:
>  	}
>  }
>  
> +static struct expr *trace_alloc_list(const struct datatype *dtype,
> +				     enum byteorder byteorder,
> +				     unsigned int len, const void *data)

Suggestion, not deal breaker: It would be good to start a new
src/trace.c file to add this and move tracing infrastructure?
