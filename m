From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 5/8] [PATCH] Helper modules load-on-demand support for
	ctnetlink
Date: Mon, 17 Nov 2008 11:55:43 +0300
Message-ID: <20081117085543.GA24019@x200.localdomain>
References: <20081117083924.11368.38741.stgit@Decadence> <20081117084055.11368.51948.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:37579 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbYKQIwJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:52:09 -0500
Received: by ug-out-1314.google.com with SMTP id 39so341277ugf.37
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Nov 2008 00:52:06 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20081117084055.11368.51948.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 17, 2008 at 09:40:55AM +0100, Pablo Neira Ayuso wrote:
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -917,8 +917,22 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nlattr *cda[])
>  	}
>  
>  	helper = __nf_conntrack_helper_find_byname(helpname);
> -	if (helper == NULL)
> +	if (helper == NULL) {
> +#ifdef CONFIG_KMOD

CONFIG_KMOD is on the way to always on, no need for ifdef.
