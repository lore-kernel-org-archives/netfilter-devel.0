Return-Path: <SRS0=ickv=7I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10BC6C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 21:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF7532065F
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 21:47:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MeXCanTk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbgEZVra (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 May 2020 17:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbgEZVr3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 May 2020 17:47:29 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9958C061A0F;
        Tue, 26 May 2020 14:47:28 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id d7so25493721eja.7;
        Tue, 26 May 2020 14:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M7KLDbtf3FzSybhaQU61haRtQgSeGbOqqtaEF0CGZyA=;
        b=MeXCanTk2Daf4LgZMe4wvlJeq3zL8MzceHkHgZfCjXm2Kgoq6dgarESd/sZcVROJNJ
         Lj7lSoT7SvQnuX8sIrjs6w3dJaQxf+k83sR/KQ+5DWsn6rh7rM1z+5gsL13BkVpXveW7
         LUfEWz0t0z8/Ga62Yo0SLAbACcFYikZDMwjPjyiAUDX1T0QZmryz0XigOn+My34Vvpt3
         XXIUQXBXVoHXTbdnxLkfTWd1yny1gi/mljcexvkj8VnwNE+5rRzRiCbtVp/VjW92nR9D
         lj4ZA9zHdOnELuhyqw4uHhzgd4dDCaPZoTqWQY/29xfgEwmPv5WMr4JItDOU683zQxAC
         a66g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M7KLDbtf3FzSybhaQU61haRtQgSeGbOqqtaEF0CGZyA=;
        b=lH/m3yCW/GdbImYwbE/Zc8q3lB+UHVwtTfeh/DuErW4maEdzKgio1yTb+YHNhGodv1
         GyhJfumfpDoJWfCxR07A9FgElErrYh/iov8AA328LXHJiTFqGCj08bN+B+uBhrw4hM/Z
         fEot+2f0+CT+0/0xS4pgpEpKR1PGRiFNgMcNGFU3z8jM3Vm7ee6qXeRsD6/+MuGSj//o
         ZQJVmx5F9TInJ+EGTJdeIGeTJt6ks59OviQW0Wqw8on+g6XhWWn7xGrm+8jrD6GnWWuP
         2oZl+8DIx4pjCb9eQS+UKC7+6YeR3nokXELBl3aCBADalqhh/7Rv7crgg1bGl2RsETMf
         J98w==
X-Gm-Message-State: AOAM532Mc0NeWkBQtxKDovpOsel2jAJdaR+Z7Z+b8Rbk+gvcu50/mKaU
        zYrzwGfQHTJWGxS7SXsCuwUKz/++768qcc3qk9U=
X-Google-Smtp-Source: ABdhPJwAJNRVIt/p5g7kA3ZNRV5C1MH1tX5j/O6Q6ytHCv1hp93T+p2ZY/tfNb3nWrk+4o/u5fazN52ag/V8EEHp1xY=
X-Received: by 2002:a17:906:2e03:: with SMTP id n3mr2930232eji.424.1590529647282;
 Tue, 26 May 2020 14:47:27 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LFD.2.21.2005192139500.3504@ja.home.ssi.bg>
 <20200524213105.14805-1-kim.andrewsy@gmail.com> <alpine.LFD.2.22.394.2005262008500.3853@ja.home.ssi.bg>
In-Reply-To: <alpine.LFD.2.22.394.2005262008500.3853@ja.home.ssi.bg>
From:   Andrew Kim <kim.andrewsy@gmail.com>
Date:   Tue, 26 May 2020 17:47:15 -0400
Message-ID: <CABc050Hq9hKRHqAM2oNp9e756ASiEHNyU7g3TFqwi2VCmSGB2A@mail.gmail.com>
Subject: Re: [PATCH] netfilter/ipvs: immediately expire no destination
 connections in kthread if expire_nodest_conn=1
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Julian,

Thanks for getting back to me. This is my first patch to the kernel so
I really appreciate your patience reviewing it.

I will update the patch based on your comments shortly.

Regards,

Andrew Sy Kim


On Tue, May 26, 2020 at 5:25 PM Julian Anastasov <ja@ssi.bg> wrote:
>
>
>         Hello,
>
>         Long CC list trimmed...
>
> On Sun, 24 May 2020, Andrew Sy Kim wrote:
>
> > If expire_nodest_conn=1 and a destination is deleted, IPVS should
> > also expire all matching connections immiediately instead of waiting for
> > the next matching packet. This is particulary useful when there are a
> > lot of packets coming from a few number of clients. Those clients are
> > likely to match against existing entries if a source port in the
> > connection hash is reused. When the number of entries in the connection
> > tracker is large, we can significantly reduce the number of dropped
> > packets by expiring all connections upon deletion in a kthread.
> >
> > Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>
> > ---
> >  include/net/ip_vs.h             | 12 +++++++++
> >  net/netfilter/ipvs/ip_vs_conn.c | 48 +++++++++++++++++++++++++++++++++
> >  net/netfilter/ipvs/ip_vs_core.c | 45 +++++++++++++------------------
> >  net/netfilter/ipvs/ip_vs_ctl.c  | 16 +++++++++++
> >  4 files changed, 95 insertions(+), 26 deletions(-)
> >
>
> >  /* Get reference to gain full access to conn.
> >   * By default, RCU read-side critical sections have access only to
> >   * conn fields and its PE data, see ip_vs_conn_rcu_free() for reference.
> > diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> > index 02f2f636798d..111fa0e287a2 100644
> > --- a/net/netfilter/ipvs/ip_vs_conn.c
> > +++ b/net/netfilter/ipvs/ip_vs_conn.c
> > @@ -1366,6 +1366,54 @@ static void ip_vs_conn_flush(struct netns_ipvs *ipvs)
> >               goto flush_again;
> >       }
> >  }
> > +
> > +/*   Thread function to flush all the connection entries in the
> > + *   ip_vs_conn_tab with a matching destination.
> > + */
> > +int ip_vs_conn_flush_dest(void *data)
> > +{
> > +     struct ip_vs_conn_flush_dest_tinfo *tinfo = data;
> > +     struct netns_ipvs *ipvs = tinfo->ipvs;
> > +     struct ip_vs_dest *dest = tinfo->dest;
>
>         Starting a kthread just for single dest can cause storms
> when many dests are used. IMHO, we should work this way:
>
> - do not use kthreads: they are hard to manage, start only from
> process context (we can not retry from timer if creating a kthread
> fails for some reason).
>
> - use delayed_work, similar to our defense_work but this time
> we should use queue_delayed_work(system_long_wq,...) instead of
> schedule_delayed_work(). Just cancel_delayed_work_sync() is needed
> to stop the work. The callback function will not start the
> work timer.
>
> - we will use one work for the netns (struct netns_ipvs *ipvs):
> __ip_vs_del_dest() will start it for next jiffie (delay=1) to
> catch more dests for flusing. As result, the first destination
> will start the work timer, other dests will do nothing while timer
> is pending. When timer expires, the work is queued to worker,
> so next dests will start the timer again, even while the work
> is executing the callback function.
>
> > +
> > +     int idx;
> > +     struct ip_vs_conn *cp, *cp_c;
> > +
> > +     IP_VS_DBG_BUF(4, "flushing all connections with destination %s:%d",
> > +                   IP_VS_DBG_ADDR(dest->af, &dest->addr), ntohs(dest->port));
>
>         We will not provide current dest. Still, above was not
> safe because we do not hold reference to dest.
>
> > +
> > +     rcu_read_lock();
> > +     for (idx = 0; idx < ip_vs_conn_tab_size; idx++) {
> > +             hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[idx], c_list) {
> > +                     if (cp->ipvs != ipvs)
> > +                             continue;
> > +
> > +                     if (cp->dest != dest)
> > +                             continue;
>
>                         struct ip_vs_dest *dest = cp->dest;
>
>                         if (!dest || (dest->flags & IP_VS_DEST_F_AVAILABLE))
>                                 continue;
>
>                         We can access dest because under RCU grace period
>                         we have access to the cp->dest fields. But we
>                         should read cp->dest once as done above.
>
> > +
> > +                     /* As timers are expired in LIFO order, restart
> > +                      * the timer of controlling connection first, so
> > +                      * that it is expired after us.
> > +                      */
> > +                     cp_c = cp->control;
> > +                     /* cp->control is valid only with reference to cp */
> > +                     if (cp_c && __ip_vs_conn_get(cp)) {
> > +                             IP_VS_DBG(4, "del controlling connection\n");
> > +                             ip_vs_conn_expire_now(cp_c);
> > +                             __ip_vs_conn_put(cp);
> > +                     }
> > +
> > +                     IP_VS_DBG(4, "del connection\n");
> > +                     ip_vs_conn_expire_now(cp);
> > +             }
> > +             cond_resched_rcu();
>
>                 if (!ipvs->enable)
>                         break;
>
>                 Abort immediately if netns cleanup is started.
>
> > +     }
> > +     rcu_read_unlock();
> > +
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(ip_vs_conn_flush_dest);
> > +
> >  /*
> >   * per netns init and exit
> >   */
> > diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> > index aa6a603a2425..ff052e57e054 100644
> > --- a/net/netfilter/ipvs/ip_vs_core.c
> > +++ b/net/netfilter/ipvs/ip_vs_core.c
> > @@ -24,6 +24,7 @@
> >
> >  #include <linux/module.h>
> >  #include <linux/kernel.h>
> > +#include <linux/kthread.h>
> >  #include <linux/ip.h>
> >  #include <linux/tcp.h>
> >  #include <linux/sctp.h>
> > @@ -694,11 +695,6 @@ static int sysctl_nat_icmp_send(struct netns_ipvs *ipvs)
> >       return ipvs->sysctl_nat_icmp_send;
> >  }
> >
> > -static int sysctl_expire_nodest_conn(struct netns_ipvs *ipvs)
> > -{
> > -     return ipvs->sysctl_expire_nodest_conn;
> > -}
> > -
> >  #else
> >
> >  static int sysctl_snat_reroute(struct netns_ipvs *ipvs) { return 0; }
> > @@ -2095,36 +2091,33 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
> >               }
> >       }
> >
> > -     if (unlikely(!cp)) {
> > -             int v;
> > -
> > -             if (!ip_vs_try_to_schedule(ipvs, af, skb, pd, &v, &cp, &iph))
> > -                     return v;
> > -     }
> > -
> > -     IP_VS_DBG_PKT(11, af, pp, skb, iph.off, "Incoming packet");
> > -
> >       /* Check the server status */
> > -     if (cp->dest && !(cp->dest->flags & IP_VS_DEST_F_AVAILABLE)) {
> > +     if (cp && cp->dest && !(cp->dest->flags & IP_VS_DEST_F_AVAILABLE)) {
> >               /* the destination server is not available */
> >
> > -             __u32 flags = cp->flags;
> > -
> > -             /* when timer already started, silently drop the packet.*/
> > -             if (timer_pending(&cp->timer))
> > -                     __ip_vs_conn_put(cp);
> > -             else
> > -                     ip_vs_conn_put(cp);
> > +             if (sysctl_expire_nodest_conn(ipvs)) {
> > +                     bool uses_ct = ip_vs_conn_uses_conntrack(cp, skb);
> >
> > -             if (sysctl_expire_nodest_conn(ipvs) &&
> > -                 !(flags & IP_VS_CONN_F_ONE_PACKET)) {
> > -                     /* try to expire the connection immediately */
> >                       ip_vs_conn_expire_now(cp);
> > +                     __ip_vs_conn_put(cp);
> > +                     if (uses_ct)
> > +                             return NF_DROP;
> > +                     cp = NULL;
> > +             } else {
> > +                     __ip_vs_conn_put(cp);
> > +                     return NF_DROP;
> >               }
> > +     }
> >
> > -             return NF_DROP;
> > +     if (unlikely(!cp)) {
> > +             int v;
> > +
> > +             if (!ip_vs_try_to_schedule(ipvs, af, skb, pd, &v, &cp, &iph))
> > +                     return v;
> >       }
> >
> > +     IP_VS_DBG_PKT(11, af, pp, skb, iph.off, "Incoming packet");
> > +
>
>         The above code in ip_vs_in() is correct.
>
> >       ip_vs_in_stats(cp, skb);
> >       ip_vs_set_state(cp, IP_VS_DIR_INPUT, skb, pd);
> >       if (cp->packet_xmit)
> > diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> > index 8d14a1acbc37..fa48268368fc 100644
> > --- a/net/netfilter/ipvs/ip_vs_ctl.c
> > +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> > @@ -1163,6 +1163,22 @@ static void __ip_vs_del_dest(struct netns_ipvs *ipvs, struct ip_vs_dest *dest,
> >       list_add(&dest->t_list, &ipvs->dest_trash);
> >       dest->idle_start = 0;
> >       spin_unlock_bh(&ipvs->dest_trash_lock);
> > +
> > +     /*      If expire_nodest_conn is enabled, expire all connections
> > +      *      immediately in a kthread.
> > +      */
> > +     if (sysctl_expire_nodest_conn(ipvs)) {
>
>         Looks like we should not start work when 'cleanup' is true, it
> indicates that we are doing final release of all resources.
>
>         if (sysctl_expire_nodest_conn(ipvs) && !cleanup)
>                 queue_delayed_work(system_long_wq, &ipvs->expire_nodest_work, 1);
>
> > +             struct ip_vs_conn_flush_dest_tinfo *tinfo = NULL;
> > +
> > +             tinfo = kcalloc(1, sizeof(struct ip_vs_conn_flush_dest_tinfo),
> > +                             GFP_KERNEL);
> > +             tinfo->ipvs = ipvs;
> > +             tinfo->dest = dest;
> > +
> > +             IP_VS_DBG(3, "flushing connections in kthread\n");
> > +             kthread_run(ip_vs_conn_flush_dest,
> > +                         tinfo, "ipvs-flush-dest-conn");
> > +     }
> >  }
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
