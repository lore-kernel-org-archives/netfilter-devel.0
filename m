From: Philip Craig <philipc@snapgear.com>
Subject: Re: [LIBNL 08/09]: Support conntrack add/delete/query requests
Date: Mon, 21 Jan 2008 18:39:58 +1000
Message-ID: <47945A5E.2070201@snapgear.com>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain> <20080118165525.13385.47304.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:55413 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758036AbYAUIdc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 03:33:32 -0500
In-Reply-To: <20080118165525.13385.47304.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> commit 5d2b826674d411f99e571fd35ad5722fed077e5e
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Fri Jan 18 17:53:14 2008 +0100
> 
>     [LIBNL]: Support conntrack add/delete/query requests
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> diff --git a/include/netlink/netfilter/ct.h b/include/netlink/netfilter/ct.h
> index 965b869..f554017 100644
> --- a/include/netlink/netfilter/ct.h
> +++ b/include/netlink/netfilter/ct.h
> @@ -39,6 +39,15 @@ extern void		nfnl_ct_put(struct nfnl_ct *);
>  
>  extern int		nfnl_ct_dump_request(struct nl_handle *);

This was just a quick and dirty dump request.  nfnl_ct_query covers this now,
so we can delete it.

> +extern struct nl_msg *	nfnl_ct_build_add_request(const struct nfnl_ct *, int);
> +extern int		nfnl_ct_add(struct nl_handle *, const struct nfnl_ct *, int);
> +
> +extern struct nl_msg *	nfnl_ct_build_delete_request(const struct nfnl_ct *, int);
> +extern int		nfnl_ct_delete(struct nl_handle *, const struct nfnl_ct *, int);
> +
> +extern struct nl_msg *	nfnl_ct_build_query_request(const struct nfnl_ct *, int);
> +extern int		nfnl_ct_query(struct nl_handle *, const struct nfnl_ct *, int);
> +
>  extern void		nfnl_ct_set_family(struct nfnl_ct *, uint8_t);
>  extern uint8_t		nfnl_ct_get_family(const struct nfnl_ct *);

