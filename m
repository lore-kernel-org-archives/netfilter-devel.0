From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 19/27] xt_policy: use the new unoin nf_inet_addr
Date: Tue, 08 Jan 2008 16:48:21 +0100
Message-ID: <47839B45.30005@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022130340.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63178 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759834AbYAHPwT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2008 10:52:19 -0500
In-Reply-To: <Pine.LNX.4.64.0801022130340.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 3ee575c6ed06528d7bde3c59b8f8898de1eafd4e
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 18:25:38 2008 +0100
> 
>     [NETFILTER]: xt_policy: use the new unoin nf_inet_addr


>  struct xt_policy_elem
>  {
> -	union xt_policy_addr	saddr;
> -	union xt_policy_addr	smask;
> -	union xt_policy_addr	daddr;
> -	union xt_policy_addr	dmask;
> +	union {
> +#ifdef __KERNEL__
> +		struct {
> +			union nf_inet_addr saddr;
> +			union nf_inet_addr smask;
> +			union nf_inet_addr daddr;
> +			union nf_inet_addr dmask;
> +		};
> +#else
> +		struct {
> +			union xt_policy_addr saddr;
> +			union xt_policy_addr smask;
> +			union xt_policy_addr daddr;
> +			union xt_policy_addr dmask;
> +		};
> +#endif


I really dislike this uglyness, but I've applied it since
there it also doesn't make much sense to leave single files
using their own address definition.
