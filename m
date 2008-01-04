From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 12/27] xt_hashlimit match, revision 1
Date: Fri, 04 Jan 2008 15:59:38 +0100
Message-ID: <477E49DA.40207@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022128370.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48870 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYADPCk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:02:40 -0500
In-Reply-To: <Pine.LNX.4.64.0801022128370.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 98815424093ca5426885218bc0afa5aa18f3e86e
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 17:58:05 2008 +0100
> 
>     [NETFILTER]: xt_hashlimit match, revision 1
>     
>     Introduces the xt_hashlimit match revision 1. It adds support for
>     kernel-level inversion and grouping source and/or destination IP
>     addresses, allowing to limit on a per-subnet basis. While this would
>     technically obsolete xt_limit, xt_hashlimit is a more expensive due to
>     the hashbucketing.
>     
>     Kernel-level inversion: Previously you had to do user-level inversion:
>     	iptables -N foo
>     	iptables -A foo -m hashlimit --hashlimit 5/s -j RETURN
>     	iptables -A foo -j DROP
>     	iptables -A INPUT -j foo
>     now it is simpler:
>     	iptables -A INPUT -m hashlimit --hashlimit-over 5/s -j DROP
>     
>     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
>  include/linux/netfilter/xt_hashlimit.h |   37 +++-
>  net/netfilter/xt_hashlimit.c           |  311 +++++++++++++++++++++---
>  2 files changed, 315 insertions(+), 33 deletions(-)
> 
> diff --git a/include/linux/netfilter/xt_hashlimit.h b/include/linux/netfilter/xt_hashlimit.h
> index c19972e..f15b104 100644
> --- a/include/linux/netfilter/xt_hashlimit.h
> +++ b/include/linux/netfilter/xt_hashlimit.h
> @@ -9,13 +9,16 @@
>  /* details of this structure hidden by the implementation */
>  struct xt_hashlimit_htable;
>  
> -#define XT_HASHLIMIT_HASH_DIP	0x0001
> -#define XT_HASHLIMIT_HASH_DPT	0x0002
> -#define XT_HASHLIMIT_HASH_SIP	0x0004
> -#define XT_HASHLIMIT_HASH_SPT	0x0008
> +enum {
> +	XT_HASHLIMIT_HASH_DIP = 1 << 0,
> +	XT_HASHLIMIT_HASH_DPT = 1 << 1,
> +	XT_HASHLIMIT_HASH_SIP = 1 << 2,
> +	XT_HASHLIMIT_HASH_SPT = 1 << 3,
> +	XT_HASHLIMIT_INVERT   = 1 << 4,
> +};


Do we really need a full new revision for this? It seems simply adding
the inversion flag would work fine, old userspace code will always
have it set to zero.
