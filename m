From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 021/103] netfilter: xtables: consolidate table hook functions
Date: Mon, 10 Aug 2009 10:58:25 +0200
Message-ID: <4A7FE131.5040901@trash.net>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de> <1249370787-17583-22-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59316 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbZHJI63 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:58:29 -0400
In-Reply-To: <1249370787-17583-22-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> For a following patch in this series, we will be requiring that a
> single hook function per table does the processing.

Which one?

> diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
> index 87ecd3e..e46123e 100644
> --- a/net/ipv4/netfilter/arptable_filter.c
> +++ b/net/ipv4/netfilter/arptable_filter.c
> @@ -53,43 +53,38 @@ static struct xt_table packet_filter = {
>  };
>  
>  /* The work comes in here from netfilter.c */
> -static unsigned int arpt_in_hook(unsigned int hook,
> +static unsigned int arptable_filter_hook(unsigned int hook,
>  				 struct sk_buff *skb,
>  				 const struct net_device *in,
>  				 const struct net_device *out,
>  				 int (*okfn)(struct sk_buff *))
>  {
> -	return arpt_do_table(skb, hook, in, out,
> -			     dev_net(in)->ipv4.arptable_filter);
> -}
> +	if (hook == NF_ARP_OUT)
> +		return arpt_do_table(skb, hook, in, out,
> +		       dev_net(out)->ipv4.arptable_filter);

I have to say, I really dislike this strange formatting style (I
think its an emacs thing, you're not the only one doing this).
The arguments are all neatly aligned so far, please keep it that
way.
