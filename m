From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH 11/11] Reduce timer updates in __nf_ct_refresh_acct()
Date: Fri, 3 Nov 2006 14:27:35 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0611031424520.2974@tux.rsn.bth.se>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210914.886519886@wlug.westbo.se>
	<454B3867.5070004@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <454B3867.5070004@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 3 Nov 2006, Patrick McHardy wrote:

> > --- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_core.c	2006-11-01 21:40:13.000000000 +0100
> > +++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c	2006-11-01 21:40:21.000000000 +0100
> > @@ -865,9 +865,14 @@ void __nf_ct_refresh_acct(struct nf_conn
> >  		ct->timeout.expires = extra_jiffies;
> >  		event = IPCT_REFRESH;
> >  	} else {
> > -		/* Need del_timer for race avoidance (may already be dying). */
> > -		if (del_timer(&ct->timeout)) {
> > -			ct->timeout.expires = jiffies + extra_jiffies;
> > +		unsigned long newtime = jiffies + extra_jiffies;
> > +
> > +		/* Only update the timeout if the new timeout is at least
> > +		   HZ jiffies from the old timeout. Need del_timer for race
> > +		   avoidance (may already be dying). */
> > +		if (newtime - ct->timeout.expires >= HZ
> > +		    && del_timer(&ct->timeout)) {
> > +			ct->timeout.expires = newtime;
> >  			add_timer(&ct->timeout);
> >  			event = IPCT_REFRESH;
> >  		}
>
> Applied, thanks. BTW, the "race avoidance" strikes me as racy,
> there are multiple locations where we simply do
>
> if (del_timer(...))
>    ct->timeout.function(...)
>
> and expect the conntrack to be either destroyed by the
> ct->timeout.function call or by the expiring timer.
> But without taking ip_conntrack_lock we could have:
>
> CPU1 (refresh)			CPU2
>
> if (del_timer) [success]
> 				if (del_timer) [no success]
> 	add_timer()
>
> which means the conntrack won't be destroyed. Did I miss
> something?

You are absolutely correct. I discussed this with Rusty some time ago and
he thought it was fine since we mostly aim for "best effort", but I don't
like it either. I have a patch that adds another variant of mod_timer()
that doesn't activate an inactive timer, and use this instead of
del_timer()/add_timer(). This avoids this race and reduces the number of
locks taken. I'll send this patch to you after this weekend I think.

/Martin
