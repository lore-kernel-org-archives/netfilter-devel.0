From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 nf-next 7/9] netfilter: conntrack: make netns address
 part of hash
Date: Mon, 02 May 2016 09:51:25 -0700
Message-ID: <1462207885.5535.258.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1461863628-23350-1-git-send-email-fw@strlen.de>
	 <1462207174-24561-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34669 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbcEBQv1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 May 2016 12:51:27 -0400
Received: by mail-pa0-f54.google.com with SMTP id r5so77911346pag.1
        for <netfilter-devel@vger.kernel.org>; Mon, 02 May 2016 09:51:27 -0700 (PDT)
In-Reply-To: <1462207174-24561-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2016-05-02 at 18:39 +0200, Florian Westphal wrote:
> Once we place all conntracks into a global hash table we want them to be
> spread across entire hash table, even if namespaces have overlapping ip
> addresses.
>  
> +static inline u32 nf_conntrack_netns_hash(const struct net *net)
> +{
> +#ifdef CONFIG_NET_NS
> +	return hash32_ptr(net);
> +#else
> +	return 0;
> +#endif
> +}
> +

Are you reinventing net_hash_mix() ?

If net_hash_mix() is not good enough, please fix it ;)

hash_ptr() is not that good, as ongoing thread in lkml shows.

Thanks.


