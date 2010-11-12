From: Shan Wei <shanwei@cn.fujitsu.com>
Subject: Re: [PATCH] netfilter: ipv6: fix overlap check for fragments
Date: Fri, 12 Nov 2010 15:47:24 +0800
Message-ID: <4CDCF10C.5060602@cn.fujitsu.com>
References: <4CD3F0F8.5030205@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>
To: nicolas.dichtel@6wind.com,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55634 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752389Ab0KLHsY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Nov 2010 02:48:24 -0500
In-Reply-To: <4CD3F0F8.5030205@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick:
 Would you apply this to your tree. The similar patch for ipv6 has been
applied by David . 
See http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=f46421416fb6b91513fb687d6503142cd99034a5

Shan Wei wrote, at 11/05/2010 07:56 PM:
> The type of FRAG6_CB(prev)->offset is int, skb->len is *unsigned* int,
> and offset is int.
> 
> Without this patch, type conversion occurred to this expression, when
> (FRAG6_CB(prev)->offset + prev->len) is less than offset.
> 
> 
> Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
> ---
>  net/ipv6/netfilter/nf_conntrack_reasm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
> index 3a3f129..79d43aa 100644
> --- a/net/ipv6/netfilter/nf_conntrack_reasm.c
> +++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
> @@ -286,7 +286,7 @@ found:
>  
>  	/* Check for overlap with preceding fragment. */
>  	if (prev &&
> -	    (NFCT_FRAG6_CB(prev)->offset + prev->len) - offset > 0)
> +	    (NFCT_FRAG6_CB(prev)->offset + prev->len) > offset)
>  		goto discard_fq;
>  
>  	/* Look for overlap with succeeding segment. */


-- 

Best Regards
-----
Shan Wei
