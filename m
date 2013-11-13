From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Fix the format of
 /proc/net/nf_conntrack_expect
Date: Wed, 13 Nov 2013 23:50:44 +0100
Message-ID: <20131113225044.GA4383@localhost>
References: <1384268886-6991-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42288 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab3KMWuy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Nov 2013 17:50:54 -0500
Content-Disposition: inline
In-Reply-To: <1384268886-6991-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 12, 2013 at 11:08:06PM +0800, Changli Gao wrote:
> There should not be any white space around `='.
>
> ---
>  net/netfilter/nf_conntrack_expect.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> index 4fd1ca9..151af72 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -517,7 +517,7 @@ static int exp_seq_show(struct seq_file *s, void *v)
>  			   ? (long)(expect->timeout.expires - jiffies)/HZ : 0);
>  	else
>  		seq_printf(s, "- ");
> -	seq_printf(s, "l3proto = %u proto=%u ",
> +	seq_printf(s, "l3proto=%u proto=%u ",

Yes, that doesn't look nice, but that output format is there since
2006 (introduced in 77ab9cff).

This is a legacy interface (we have ctnetlink and the conntrack
utility these days) and I don't want to break backward for
applications parsing that output. I'm not taking this.
