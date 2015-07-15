From: subashab@codeaurora.org
Subject: Re: [PATCH] netfilter: nf_nat: Fix possible null dereference
Date: Wed, 15 Jul 2015 01:10:09 -0000
Message-ID: <f29890b70a328a20b8be169f2a357790.squirrel@www.codeaurora.org>
References: <fea9df65d6768053838fb1eca1846ef7.squirrel@www.codeaurora.org>
    <20150709222456.GA4111@salvia>
    <4acf7f20a629dd133bf5924886c0c4d0.squirrel@www.codeaurora.org>
    <20150713155003.GA7062@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55188 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbGOBKK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jul 2015 21:10:10 -0400
In-Reply-To: <20150713155003.GA7062@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> I see, but if you look nf_nat_ipv4_fn() then you can confirm that we
> always have a nat extension in place by when the iptables NAT
> targets / nft NAT expressions:
>
> nf_nat_ipv4_fn(...)
> {
>         [...]
>
>         ct = nf_ct_get(skb, &ctinfo);
>         /* Can't track?  It's not due to stress, or conntrack would
>          * have dropped it.  Hence it's the user's responsibilty to
>          * packet filter it out, or implement conntrack/NAT for that
>          * protocol. 8) --RR
>          */
>         if (!ct)
>                 return NF_ACCEPT;
>
>         /* Don't try to NAT if this packet is not conntracked */
>         if (nf_ct_is_untracked(ct))
>                 return NF_ACCEPT;
>
>         nat = nf_ct_nat_ext_add(ct);
>         if (nat == NULL)
>                 return NF_ACCEPT;
>
>         ...
>
> If we fail to create the nat extension, then this accepts the packet,
> so no chances we can reach this NULL dereference.
>
> I wonder if this is a false positive. Would you please have a closer
> look and confirm this? Thanks.
>
This report is indeed a false positive. Thanks for reviewing.

