From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/27] Annotate start of kernel fields in NF headers
Date: Fri, 04 Jan 2008 15:33:43 +0100
Message-ID: <477E43C7.9000206@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022126110.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48256 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbYADOgq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:36:46 -0500
In-Reply-To: <Pine.LNX.4.64.0801022126110.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit fbfa586f668945368dcaac07c5587bb6f0979e59
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 17:38:47 2008 +0100
> 
>     [NETFILTER]: Annotate start of kernel fields in NF headers

> diff --git a/include/linux/netfilter/xt_statistic.h b/include/linux/netfilter/xt_statistic.h
> index c344e99..24969af 100644
> --- a/include/linux/netfilter/xt_statistic.h
> +++ b/include/linux/netfilter/xt_statistic.h
> @@ -23,6 +23,7 @@ struct xt_statistic_info {
>  		struct {
>  			u_int32_t	every;
>  			u_int32_t	packet;
> +	/* Used internally by the kernel */
>  			u_int32_t	count;

Applied and fixed the indentation above.

