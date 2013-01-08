From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next V2] netfilter: remove extra timer from ecache
 extension
Date: Tue, 8 Jan 2013 23:34:47 +0100
Message-ID: <20130108223447.GA24818@1984>
References: <1357231003-1241-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49369 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700Ab3AHWev (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:34:51 -0500
Content-Disposition: inline
In-Reply-To: <1357231003-1241-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Thu, Jan 03, 2013 at 05:36:43PM +0100, Florian Westphal wrote:
> This brings the (per-conntrack) ecache extension back to 24 bytes in
> size (was 112 byte on x86_64 with lockdep on).
> 
> Instead we use a per-ns timer to re-trigger event delivery.  When we
> enqueue a ct entry into the dying list, the timer will be scheduled.
> 
> The timer will then deliver up to 20 entries.  If not all pending entries
> could be delivered, it will re-add itself to run again after 2 jiffies.
> This gives userspace consumers time to drain their sockets.
> 
> When userspace listeners don't accept events at all, re-try is done
> after 10ms.
> 
> If an event was sucessfully delivered via the normal delivery path,
> we take this as a hint that userspace has processed its backlog and
> re-try pending entries on the next timer tick.
> This speeds up re-delivery without adding too much overhead.
> 
> While at it, dying list handling is moved into ecache.c, since its only
> revlevant if ct events are enabled.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Pablo,
> 
>  it would be great if you could give this one a spin in your
>  conntrackd testsetup.
> 
>  It avoids the "perpertual-busy-retry" of the previous
>  tasklet-based approach.

#  hits  hits/s  ^h/s  ^bytes   kB/s  errs   rst  tout  mhtime
1225183 15125 19051   4019761   3116     0     0     6   0.003
1243714 15167 18531   3910041   3125     0     0     6   0.003
1253179 15098  9465   1997115   3111     0     0     6   0.001
1261138 15013  7959   1679349   3093     0     0     6   0.001
1270189 14943  9051   1909761   3079     0     0     6   3.008
1288838 14986 18649   3934939   3088     0     0     6   3.005
1306825 15020 17987   3795257   3095     0     0     6   0.003
1319849 14998 13024   2748064   3090     0     0     6   0.001
1332884 14976 13035   2750385   3085     0     0     6   0.001
1346978 14966 14094   2973834   3083     0     0     6   3.008
1365928 15010 18950   3998450   3092     0     0     6   0.003
1382430 15026 16502   3481922   3096     0     0     6   0.003
1396355 15014 13925   2938175   3093     0     0     6   0.001
1410313 15003 13958   2945138   3091     0     0     6   0.001
1426706 15017 16393   3458923   3094     0     0     6   3.005
1445630 15058 18924   3992964   3102     0     0     6   0.003
#  hits  hits/s  ^h/s  ^bytes   kB/s  errs   rst  tout  mhtime
1458656 15037 13026   2748486   3098     0     0     6   0.001
1471710 15017 13054   2754394   3094     0     0     6   0.001
1484990 14999 13280   2802080   3090     0     0     6   3.008
1504167 15041 19177   4046347   3099     0     0     6   0.004
1517647 15026 13480   2844280   3096     0     0     6   0.002
              ^^^^^
The important is the third column, that represents the real flows per
second.

Better and more stable than the previous patch, but still hitting:

[  623.309409] net_ratelimit: 11 callbacks suppressed
[  623.309470] nf_conntrack: table full, dropping packet

More thoughts:

The current approach ramdomly distributes the retries in the range
between 0 and 15 seconds. The random distribution of timers works fine
in practise to avoid re-delivery more than one event in one single
shot.

Note that the effect of this random distribution is that the busier
the dying list gets, the more frequently the routine to re-deliver of
*one conntrack* is called.

I think this can be emulated with one single timer. The point would be
to keep a counter with the number of conntracks in the dying list. That
counter can be used to implement some adaptive timer to trigger the
re-delivery routine more frequently for one single conntrack.

Regards.
