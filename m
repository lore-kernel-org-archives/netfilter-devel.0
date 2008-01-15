From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 27/27] Update feature-removal-schedule.txt
Date: Tue, 15 Jan 2008 17:16:44 +0100
Message-ID: <478CDC6C.5050308@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022134290.14900@fbirervta.pbzchgretzou.qr> <4783A5CD.4050705@trash.net> <Pine.LNX.4.64.0801081753430.3032@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43747 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYAOQQ4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:16:56 -0500
In-Reply-To: <Pine.LNX.4.64.0801081753430.3032@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Could you take care of this one and let it sift through ->dave->linus->;
> what do you think, or same verdict as for the previous patch changing
> int->int32_t?
> 
> A few xtable modules use aligned_u64, which is how I found this one.
> 
> commit 35f2e577e432b28969710bc1fd4d9a4c0875f81b
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 17:30:18 2008 +0100
> 
>     linux/types.h: Use __u64 for aligned_u64
>     
>     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> diff --git a/include/linux/types.h b/include/linux/types.h
> index f4f8d19..b94c0e4 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -126,7 +126,7 @@ typedef		__s64		int64_t;
>  #endif
>  
>  /* this is a special 64bit data type that is 8-byte aligned */
> -#define aligned_u64 unsigned long long __attribute__((aligned(8)))
> +#define aligned_u64 __u64 __attribute__((aligned(8)))
>  #define aligned_be64 __be64 __attribute__((aligned(8)))
>  #define aligned_le64 __le64 __attribute__((aligned(8)))


Looks good to me, applied.
