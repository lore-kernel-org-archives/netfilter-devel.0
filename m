From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter conntrack helper: nf_ct_h323: fix bug in
 rtcp natting
Date: Wed, 6 Jun 2012 01:44:16 +0200
Message-ID: <20120605234416.GA27212@1984>
References: <4FBB2B7B.6060907@elitecore.com>
 <1337668101.3361.54.camel@edumazet-glaptop>
 <4FBB51D9.1020602@elitecore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	'Patrick McHardy' <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Jagdish Motwani <jagdish.motwani@elitecore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49651 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab2FEXoT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:44:19 -0400
Content-Disposition: inline
In-Reply-To: <4FBB51D9.1020602@elitecore.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 22, 2012 at 02:14:09PM +0530, Jagdish Motwani wrote:
[...]
> Thanks. Updating the patch

Applied, thanks.

Please, next time don't forget to include the patch description (even
if you already in the previous version of your patch).

I cannot apply this with `git am' and that's annoying.

> --
> 
> diff --git a/net/netfilter/nf_conntrack_h323_main.c
> b/net/netfilter/nf_conntrack_h323_main.c
> index 46d69d7..31f50bc 100644
> --- a/net/netfilter/nf_conntrack_h323_main.c
> +++ b/net/netfilter/nf_conntrack_h323_main.c
> @@ -270,9 +270,8 @@ static int expect_rtp_rtcp(struct sk_buff *skb,
> struct nf_conn *ct,
>                 return 0;
> 
>         /* RTP port is even */
> -       port &= htons(~1);
> -       rtp_port = port;
> -       rtcp_port = htons(ntohs(port) + 1);
> +       rtp_port = port & ~htons(1);
> +       rtcp_port = port | htons(1);
> 
>         /* Create expect for RTP */
>         if ((rtp_exp = nf_ct_expect_alloc(ct)) == NULL)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
