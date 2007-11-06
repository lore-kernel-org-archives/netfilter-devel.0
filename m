From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] fix the number of bytes cleaned by clean_nat() in net/ipv4/netfilter/nf_nat_core.c
Date: Wed, 07 Nov 2007 00:58:35 +0100
Message-ID: <4730FFAB.4070000@trash.net>
References: <4730D58E.2080107@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Roel Kluin <12o3l@tiscali.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45264 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbXKFX6p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:58:45 -0500
In-Reply-To: <4730D58E.2080107@tiscali.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Roel Kluin wrote:
> Zero out 'sizeof(*nat)' rather than 'sizeof(nat)' bytes of the struct 
> nf_conn_nat pointer 'nat'
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
> index 56e93f6..70e7997 100644
> --- a/net/ipv4/netfilter/nf_nat_core.c
> +++ b/net/ipv4/netfilter/nf_nat_core.c
> @@ -681,7 +681,7 @@ static int clean_nat(struct nf_conn *i, void *data)
>  
>  	if (!nat)
>  		return 0;
> -	memset(nat, 0, sizeof(nat));
> +	memset(nat, 0, sizeof(*nat));
>  	i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
>  	return 0;
>  }


I already have the same patch queued from Li Zefan. Good catch anyway :)
