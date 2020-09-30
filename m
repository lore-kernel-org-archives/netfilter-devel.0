Return-Path: <SRS0=6DLs=DH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0625BC4727E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 18:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADC9820738
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 18:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgI3STx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 14:19:53 -0400
Received: from mg.ssi.bg ([178.16.128.9]:57786 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgI3STx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 14:19:53 -0400
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id C8319CCA4;
        Wed, 30 Sep 2020 21:19:50 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id 0A176CC9F;
        Wed, 30 Sep 2020 21:19:50 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 7AB1E3C09D2;
        Wed, 30 Sep 2020 21:19:46 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 08UIJhq5007185;
        Wed, 30 Sep 2020 21:19:45 +0300
Date:   Wed, 30 Sep 2020 21:19:43 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     "longguang.yue" <bigclouds@163.com>
cc:     kuba@kernel.org, yuelongguang@gmail.com,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH v3] ipvs: Add traffic statistic up even it is VS/DR or
 VS/TUN mode
In-Reply-To: <20200930012611.54859-1-bigclouds@163.com>
Message-ID: <alpine.LFD.2.23.451.2009302019180.5709@ja.home.ssi.bg>
References: <20200929074110.33d7d740@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20200930012611.54859-1-bigclouds@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Wed, 30 Sep 2020, longguang.yue wrote:

> It's ipvs's duty to do traffic statistic if packets get hit,
> no matter what mode it is.
> 
> Signed-off-by: longguang.yue <bigclouds@163.com>
> ---
>  net/netfilter/ipvs/ip_vs_conn.c | 14 ++++++++++++--
>  net/netfilter/ipvs/ip_vs_core.c |  5 ++++-
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> index a90b8eac16ac..c4d164ce8ca7 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@ -401,6 +401,8 @@ struct ip_vs_conn *ip_vs_ct_in_get(const struct ip_vs_conn_param *p)
>  struct ip_vs_conn *ip_vs_conn_out_get(const struct ip_vs_conn_param *p)
>  {
>  	unsigned int hash;
> +	__be16 cport;
> +	const union nf_inet_addr *caddr;
>  	struct ip_vs_conn *cp, *ret=NULL;

	May be we can do it in few rounds, here is a list
of some initial notes...

	caddr/cport are misleading, can be saddr/sport (source)
or laddr/lport (local).

>  	/*
> @@ -411,10 +413,18 @@ struct ip_vs_conn *ip_vs_conn_out_get(const struct ip_vs_conn_param *p)
>  	rcu_read_lock();
>  
>  	hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[hash], c_list) {

	Lets first check here for cp->cport before touching more
cache lines while traversing the list, it eliminates the cost of
next checks:

		if (p->vport != cp->cport)
			continue;

		then

		if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ) {
		...

> -		if (p->vport == cp->cport && p->cport == cp->dport &&
> +		cport = cp->dport;
> +		caddr = &cp->daddr;
> +
> +		if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ) {
> +			cport = cp->vport;
> +			caddr = &cp->vaddr;
> +		}

	Considering the issues solved by commit 3c5ab3f395d6,
such check more correctly matches the replies from DR/TUN
real server to local clients but also to remote clients
if director is used as router.

> +
> +		if (p->vport == cp->cport && p->cport == cport &&

		if (p->cport == sport &&
			...

>  		    cp->af == p->af &&
>  		    ip_vs_addr_equal(p->af, p->vaddr, &cp->caddr) &&
> -		    ip_vs_addr_equal(p->af, p->caddr, &cp->daddr) &&
> +		    ip_vs_addr_equal(p->af, p->caddr, caddr) &&
>  		    p->protocol == cp->protocol &&
>  		    cp->ipvs == p->ipvs) {
>  			if (!__ip_vs_conn_get(cp))
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index e3668a6e54e4..7ba88dab297a 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -1413,8 +1413,11 @@ ip_vs_out(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, in
>  			     ipvs, af, skb, &iph);
>  
>  	if (likely(cp)) {
> -		if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ)
> +		if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ) {
> +			ip_vs_out_stats(cp, skb);
> +			skb->ipvs_property = 1;

	We will also need:

			if (!(cp->flags & IP_VS_CONN_F_NFCT))
				ip_vs_notrack(skb);

	Similar code is needed in handle_response_icmp(),
so that we account ICMP packets, where a jump to new label
before ip_vs_out_stats() can work.

	But such jump is preferred even for handle_response()
because the (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ) check
should be moved from ip_vs_out() into handle_response().
For this to work the ip_vs_set_state() call in handle_response()
should be moved before the new label and ip_vs_out_stats() call.

>  			goto ignore_cp;
> +		}
>  		return handle_response(af, skb, pd, cp, &iph, hooknum);
>  	}

Regards

--
Julian Anastasov <ja@ssi.bg>

