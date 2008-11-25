From: BORBELY Zoltan <bozo@andrews.hu>
Subject: Re: crash in death_by_timeout()
Date: Tue, 25 Nov 2008 23:48:53 +0100
Message-ID: <20081125224853.GL3195@zebra.home>
References: <20081117221855.GD3271@zebra.home> <4922A1E8.7080405@trash.net> <20081118123830.GD3201@zebra.home> <4922C0F7.3050604@trash.net> <4922C2D0.9060207@trash.net> <20081125080903.GA3195@zebra.home> <492BDD51.2020306@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx6.datanet.hu ([194.149.13.165]:56471 "EHLO mx6.datanet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbYKYWti (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2008 17:49:38 -0500
Received: from dolphin (tng660dvmi.adsl.datanet.hu [195.56.206.203])
	by mx6.datanet.hu (DataNet) with ESMTP id 31D91130D84
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Nov 2008 23:49:36 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <492BDD51.2020306@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, Nov 25, 2008 at 12:11:13PM +0100, Patrick McHardy wrote:
> Crap, I missed a spot. Does this patch help?
>
>

> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 3b009a3..5f4a651 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1138,7 +1138,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
>  		}
>  	}
>  
> -	nf_ct_acct_ext_add(ct, GFP_KERNEL);
> +	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
>  
>  #if defined(CONFIG_NF_CONNTRACK_MARK)
>  	if (cda[CTA_MARK])

Thanks, the BUG messages have disappeared.

Bye,
Zoltan
