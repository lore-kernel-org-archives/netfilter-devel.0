From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_ecn: Add missing hotdrop mark.
Date: Mon, 31 Jul 2017 20:20:15 +0200
Message-ID: <20170731182015.GA15201@salvia>
References: <20170729103300.30447-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38972 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750940AbdGaSUU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2017 14:20:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D50A33025A5
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 20:20:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C61DFD1D96
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 20:20:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A2C6DDA81E
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 20:20:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170729103300.30447-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 29, 2017 at 07:33:00PM +0900, Taehee Yoo wrote:
> If the netfilter can't get L4 header, the netfilter
> marks hotdrop value. then {ip, ip6, arp, eb}t_do_table() drops
> that packet immediately. but xt_ecn doesn't mark hotdrop value.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  net/netfilter/xt_ecn.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/xt_ecn.c b/net/netfilter/xt_ecn.c
> index 3c831a8..c58db1d 100644
> --- a/net/netfilter/xt_ecn.c
> +++ b/net/netfilter/xt_ecn.c
> @@ -37,8 +37,10 @@ static bool match_tcp(const struct sk_buff *skb, struct xt_action_param *par)
>  	 * be good citizens.
>  	 */
>  	th = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);
> -	if (th == NULL)
> +	if (!th) {
> +		par->hotdrop = true;
>  		return false;
> +	}

Is it that we always - consistenly - drop packets that has no
information that we need.

I would say it's better to do this via policy, it's more flexible,
rather than assuming that accessing a packet that doesn't contain the
information that we need means a drop.

Another concern for me regarding this is the fact that probably this
has been the default behaviour for long time, if that's the case, I
would be reluctant to change this at this point.

Let me know, thanks!
