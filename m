Return-Path: <SRS0=CJVJ=AL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84193C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jun 2020 16:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60D9A20656
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jun 2020 16:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbgF3QKT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jun 2020 12:10:19 -0400
Received: from ja.ssi.bg ([178.16.129.10]:49252 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726117AbgF3QKT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jun 2020 12:10:19 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 05UGA6iG004657;
        Tue, 30 Jun 2020 19:10:06 +0300
Date:   Tue, 30 Jun 2020 19:10:06 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Andrew Sy Kim <kim.andrewsy@gmail.com>
Subject: Re: [PATCH net-next] ipvs: avoid expiring many connections from
 timer
In-Reply-To: <20200630151922.GA12560@vergenet.net>
Message-ID: <alpine.LFD.2.22.394.2006301851400.4282@ja.home.ssi.bg>
References: <20200620100355.4364-1-ja@ssi.bg> <20200630151922.GA12560@vergenet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Tue, 30 Jun 2020, Simon Horman wrote:

> > diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> > index 02f2f636798d..b3921ae92740 100644
> > --- a/net/netfilter/ipvs/ip_vs_conn.c
> > +++ b/net/netfilter/ipvs/ip_vs_conn.c

> > @@ -827,14 +852,17 @@ static void ip_vs_conn_expire(struct timer_list *t)
> >  
> >  		/* does anybody control me? */
> >  		if (ct) {
> > +			bool has_ref = !cp->timeout && __ip_vs_conn_get(ct);
> > +
> >  			ip_vs_control_del(cp);
> >  			/* Drop CTL or non-assured TPL if not used anymore */
> > -			if (!cp->timeout && !atomic_read(&ct->n_control) &&
> > +			if (has_ref && !atomic_read(&ct->n_control) &&
> >  			    (!(ct->flags & IP_VS_CONN_F_TEMPLATE) ||
> >  			     !(ct->state & IP_VS_CTPL_S_ASSURED))) {
> >  				IP_VS_DBG(4, "drop controlling connection\n");
> > -				ct->timeout = 0;
> > -				ip_vs_conn_expire_now(ct);
> > +				ip_vs_conn_del_put(ct);
> 
> Previously this code did not put the ct, now it does.
> Is that intentional.

	Yes, as ip_vs_conn_expire() now can be called both in
timer and process context we need a reference for ct while
calling del_timer() in ip_vs_conn_del_put(). As ct->n_control
is 0 after our ip_vs_control_del(), ct can be expired by
timer while we are trying to del it here.

> > @@ -1341,19 +1368,15 @@ static void ip_vs_conn_flush(struct netns_ipvs *ipvs)
> >  		hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[idx], c_list) {
> >  			if (cp->ipvs != ipvs)
> >  				continue;
> > -			/* As timers are expired in LIFO order, restart
> > -			 * the timer of controlling connection first, so
> > -			 * that it is expired after us.
> > -			 */
> > +			if (atomic_read(&cp->n_control))
> > +				continue;
> >  			cp_c = cp->control;
> > -			/* cp->control is valid only with reference to cp */
> > -			if (cp_c && __ip_vs_conn_get(cp)) {
> > +			IP_VS_DBG(4, "del connection\n");
> > +			ip_vs_conn_del(cp);
> > +			if (cp_c && !atomic_read(&cp_c->n_control)) {
> >  				IP_VS_DBG(4, "del controlling connection\n");
> > -				ip_vs_conn_expire_now(cp_c);
> > -				__ip_vs_conn_put(cp);
> > +				ip_vs_conn_del(cp_c);
> 
> Conversely, previously this code put the ct, now it doesn't.
> Is that also intentional?

	Now we do not get reference to cp because in RCU
section the cp structure can not go away. So, we have an
implicit reference to cp. Same for its cp->control (ct).
The conn structures are freed later in RCU callback.

	In this case we may run del_timer() after
another CPU, eg. after ip_vs_conn_expire() was already
called after timer expire or after ip_vs_conn_del*(). But
for us del_timer will not succeed.

Regards

--
Julian Anastasov <ja@ssi.bg>
