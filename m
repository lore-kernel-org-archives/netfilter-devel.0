From: Matthew Helsley <matthltc@us.ibm.com>
Subject: [PATCH] ebtables match inverted in 2.6.28? (Was: Re: ebtables
	match inverted in 2.6.28?)
Date: Wed, 31 Dec 2008 19:16:12 -0800
Message-ID: <1230779772.29793.31.camel@localhost>
References: <84ee33570812311400m5492af64n45c645a13fe91c2c@mail.gmail.com>
Reply-To: matthltc@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Matt Cross <matt.cross@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:47362 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbZAADQL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Dec 2008 22:16:11 -0500
In-Reply-To: <84ee33570812311400m5492af64n45c645a13fe91c2c@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2008-12-31 at 17:00 -0500, Matt Cross wrote:
> I think the work to move ebtables to use xtables broke ebtables.
> Specifically, in commit 8cc784eec6676b58e7f60419c88179aaa97bf71c the
> return value of the match functions was inverted so that they return 1
> (true) on matches instead of EBT_MATCH (0), and vice versa (look in
> ebt_ip.c).  The logic in ebtables.c (ebt_do_table() and
> EBT_MATCH_ITERATE()) expect match functions to return 0 for matches.
> 
> The patch at the end of this message fixes the problem, but seems a
> little hacky to me.  Who's the right person to address this?
> 
>     -Matt

I suspect the right place to send this is:
netfilter-devel@vger.kernel.org

The subject line should indicate that you've contributed a patch
otherwise you may not get a quick response (I've modified it
accordingly).

For more on submitting patches you can read
Documentation/SubmittingPatches and Documentation/SubmitChecklist

Cheers,
	-Matt Helsley

> 
> --- linux-2.6.28.orig/net/bridge/netfilter/ebtables.c   2008-12-24
> 18:26:37.000000000 -0500
> +++ linux-2.6.28/net/bridge/netfilter/ebtables.c        2008-12-31
> 16:17:44.000000000 -0500
> @@ -80,7 +80,7 @@
>  {
>         par->match     = m->u.match;
>         par->matchinfo = m->data;
> -       return m->u.match->match(skb, par);
> +       return !m->u.match->match(skb, par);
>  }
> 
>  static inline int ebt_dev_check(char *entry, const struct net_device *device)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

