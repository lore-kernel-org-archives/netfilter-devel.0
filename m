From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8] [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign
 a non-clashing value
Date: Wed, 09 Apr 2008 14:52:52 +0200
Message-ID: <47FCBC24.4020209@trash.net>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <2a75525ff0d60f2e71df2c9c3d040d3a76451713.1207668694.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44969 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbYDIMwy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 08:52:54 -0400
In-Reply-To: <2a75525ff0d60f2e71df2c9c3d040d3a76451713.1207668694.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> For coming Xtables patches, we want to use PF_UNSPEC, but NF_ARP
> currently evaluates to the same value so it gets changed. The
> constant is renamed to NFPROTO_ARP, in the naming spirit of
> IPPROTO_*.
> 
> +enum {
> +	__NFPROTO_MIN = AF_MAX,
> +	NFPROTO_ARP,
> +	__NFPROTO_MAX,
> +};
> +
>  
> -extern struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS];
> +extern struct list_head nf_hooks[][NF_MAX_HOOKS];
>  
> [...]
> -	xt = kmalloc(sizeof(struct xt_af) * NPROTO, GFP_KERNEL);
> +	xt = kmalloc(sizeof(struct xt_af) * __NFPROTO_MAX, GFP_KERNEL);

Thats quite ugly. I'd also prefer to keep the size in
the nf_hooks declaration and elsewhere.

How about:

enum {
	__NFPROTO_MIN = AF_MAX - 1,   (AF_MAX is actually max + 1)
	NFPROTO_ARP,
	__NFPROTO_MAX
};
#define NFPROTO_MAX	(__NFPROTO_MAX - 1)

The array declarations should then use NFPROTO_MAX + 1.
