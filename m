Return-Path: <SRS0=kOBD=7V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD358C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 17:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB5E4206C3
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 17:29:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ytz87AfN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387543AbgFHR3O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jun 2020 13:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387555AbgFHR3N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jun 2020 13:29:13 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AA9C08C5C3
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2020 10:29:13 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id f7so19247674ejq.6
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jun 2020 10:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=Mlp4HqUELPH6tw+uXAq0JHWV4MU63AE1pRSBNQXqBfo=;
        b=Ytz87AfN24xF6BUmUXHB35tA01CsFSSMdB2YEqEte9ftp+rQRh4m59px0RrzmO69ho
         GkCkflVchgclb1KknN4iK81ZPi4ZP1gHZ6q3dshzoRqdTnG8hpdMZCIbPJfc5IN7i07I
         SqohqY8NiL0XuyGh2ZsImIU8oJqpcjtE1ToNFB1Ykx7gbKdbIw0yXAaoUaS+qXb8Yvkb
         CfsOTVkuicmjDevd9p6nNdrl1MYGBPLdmWW0XVQd0hKcv2c3p9Vf2Lr+48/0/Spc5s82
         czWv73FudIWcWvJdFNJMKSzfpCr3Av7Mu8ueB+LLsiFpT1WuW/mnBOeE+4PXouxR+tSx
         53DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=Mlp4HqUELPH6tw+uXAq0JHWV4MU63AE1pRSBNQXqBfo=;
        b=m+TT0OFzUH2saftPXnt7jT7JHy0sImxdw7gPirge9EVA6D4ZsXFAyB0Rzac8FfMJs7
         ryzIUX9ovOOGLS64dalfRmuov5b2HrQUHyHFM8j1adpg+xNZNrjFupKST5mTB9pGlniv
         7nzh6K56kvT1Y1jKlItWrX8iN6AlJEYQZOf/IYOdyKJA2kKn708CspS3dALv1O8iBZL9
         Oloz31ja9GgxG4bmhhPBeHauKhWfesn9uJXwZxa0kwXr2OiVzENYrd9XPxSWHkf9YYkK
         h2u8MZgIkz38WBlqobRnq0SDb/w4FL5E5o1wLt82OXrffN6kwikOlaohQwJcLA0A1R53
         j7pQ==
X-Gm-Message-State: AOAM530UUzeBzF8rRF3Bno/Tt017XWrh01v6P1utriM0Nq0bp53KyzhQ
        KQNiQOkxRuZYZnpBQunurWhko8cNcM2DcG50L8X7fb0x
X-Received: by 2002:a17:906:f6c2:: with SMTP id jo2mt18927687ejb.424.1591637351505;
 Mon, 08 Jun 2020 10:29:11 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LFD.2.22.394.2005281954380.4045@ja.home.ssi.bg> <20200608172204.19825-1-kim.andrewsy@gmail.com>
In-Reply-To: <20200608172204.19825-1-kim.andrewsy@gmail.com>
From:   Andrew Kim <kim.andrewsy@gmail.com>
Date:   Mon, 8 Jun 2020 13:29:00 -0400
Message-ID: <CABc050EAYrj+ymDbSc0CfSCkmpcZRM2O_RumUhOYxpzWDYD7XA@mail.gmail.com>
Subject: Re: [PATCH] netfilter/ipvs: queue delayed work to expire no
 destination connections if expire_nodest_conn=1
Cc:     Julian Anastasov <ja@ssi.bg>, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Missed a few changes in the patch I just sent, will send an updated one shortly.


On Mon, Jun 8, 2020 at 1:22 PM Andrew Sy Kim <kim.andrewsy@gmail.com> wrote:
>
> When expire_nodest_conn=1 and a destination is deleted, IPVS does not
> expire the existing connections until the next matching incoming packet.
> If there are many connection entries from a single client to a single
> destination, many packets may get dropped before all the connections are
> expired (more likely with lots of UDP traffic). An optimization can be
> made where upon deletion of a destination, IPVS queues up delayed work
> to immediately expire any connections with a deleted destination. This
> ensures any reused source ports from a client (within the IPVS timeouts)
> are scheduled to new real servers instead of silently dropped.
>
> Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>
> ---
>  include/net/ip_vs.h             | 28 ++++++++++++++++++++
>  net/netfilter/ipvs/ip_vs_conn.c | 44 ++++++++++++++++++++++++++++++++
>  net/netfilter/ipvs/ip_vs_core.c | 45 +++++++++++++--------------------
>  net/netfilter/ipvs/ip_vs_ctl.c  | 22 ++++++++++++++++
>  4 files changed, 112 insertions(+), 27 deletions(-)
>
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 83be2d93b407..3eb03d9440ce 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -885,6 +885,8 @@ struct netns_ipvs {
>         atomic_t                conn_out_counter;
>
>  #ifdef CONFIG_SYSCTL
> +       /* delayed work for expiring no dest connections */
> +       struct delayed_work     expire_nodest_conn_work;
>         /* 1/rate drop and drop-entry variables */
>         struct delayed_work     defense_work;   /* Work handler */
>         int                     drop_rate;
> @@ -1049,6 +1051,11 @@ static inline int sysctl_conn_reuse_mode(struct netns_ipvs *ipvs)
>         return ipvs->sysctl_conn_reuse_mode;
>  }
>
> +static inline int sysctl_expire_nodest_conn(struct netns_ipvs *ipvs)
> +{
> +       return ipvs->sysctl_expire_nodest_conn;
> +}
> +
>  static inline int sysctl_schedule_icmp(struct netns_ipvs *ipvs)
>  {
>         return ipvs->sysctl_schedule_icmp;
> @@ -1136,6 +1143,11 @@ static inline int sysctl_conn_reuse_mode(struct netns_ipvs *ipvs)
>         return 1;
>  }
>
> +static inline int sysctl_expire_nodest_conn(struct netns_ipvs *ipvs)
> +{
> +       return 0;
> +}
> +
>  static inline int sysctl_schedule_icmp(struct netns_ipvs *ipvs)
>  {
>         return 0;
> @@ -1505,6 +1517,22 @@ static inline int ip_vs_todrop(struct netns_ipvs *ipvs)
>  static inline int ip_vs_todrop(struct netns_ipvs *ipvs) { return 0; }
>  #endif
>
> +#ifdef CONFIG_SYSCTL
> +/* Enqueue delayed work for expiring no dest connections
> + * Only run when sysctl_expire_nodest=1
> + */
> +static inline void ip_vs_enqueue_expire_nodest_conns(struct netns_ipvs *ipvs)
> +{
> +       if (sysctl_expire_nodest_conn(ipvs))
> +               queue_delayed_work(system_long_wq,
> +                                  &ipvs->expire_nodest_conn_work, 1);
> +}
> +
> +void ip_vs_expire_nodest_conn_flush(struct netns_ipvs *ipvs);
> +#else
> +static inline void ip_vs_enqueue_expire_nodest_conns(struct netns_ipvs) {}
> +#endif
> +
>  #define IP_VS_DFWD_METHOD(dest) (atomic_read(&(dest)->conn_flags) & \
>                                  IP_VS_CONN_F_FWD_MASK)
>
> diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> index 02f2f636798d..88eb7c2433aa 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@ -28,6 +28,7 @@
>  #include <linux/module.h>
>  #include <linux/vmalloc.h>
>  #include <linux/proc_fs.h>             /* for proc_net_* */
> +#include <linux/workqueue.h>
>  #include <linux/slab.h>
>  #include <linux/seq_file.h>
>  #include <linux/jhash.h>
> @@ -1366,6 +1367,49 @@ static void ip_vs_conn_flush(struct netns_ipvs *ipvs)
>                 goto flush_again;
>         }
>  }
> +
> +#ifdef CONFIG_SYSCTL
> +void ip_vs_expire_nodest_conn_flush(struct netns_ipvs *ipvs)
> +{
> +       int idx;
> +       struct ip_vs_conn *cp, *cp_c;
> +       struct ip_vs_dest *dest;
> +
> +       rcu_read_lock();
> +       for (idx = 0; idx < ip_vs_conn_tab_size; idx++) {
> +               hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[idx], c_list) {
> +                       if (cp->ipvs != ipvs)
> +                               continue;
> +
> +                       dest = cp->dest;
> +                       if (!dest || (dest->flags & IP_VS_DEST_F_AVAILABLE))
> +                               continue;
> +
> +                       /* As timers are expired in LIFO order, restart
> +                        * the timer of controlling connection first, so
> +                        * that it is expired after us.
> +                        */
> +                       cp_c = cp->control;
> +                       /* cp->control is valid only with reference to cp */
> +                       if (cp_c && __ip_vs_conn_get(cp)) {
> +                               IP_VS_DBG(4, "del controlling connection\n");
> +                               ip_vs_conn_expire_now(cp_c);
> +                               __ip_vs_conn_put(cp);
> +                       }
> +
> +                       IP_VS_DBG(4, "del connection\n");
> +                       ip_vs_conn_expire_now(cp);
> +               }
> +               cond_resched_rcu();
> +
> +               /* netns clean up started, aborted delayed work */
> +               if (!ipvs->enable)
> +                       return;
> +       }
> +       rcu_read_unlock();
> +}
> +#endif
> +
>  /*
>   * per netns init and exit
>   */
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index aa6a603a2425..2508a9caeae8 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -694,16 +694,10 @@ static int sysctl_nat_icmp_send(struct netns_ipvs *ipvs)
>         return ipvs->sysctl_nat_icmp_send;
>  }
>
> -static int sysctl_expire_nodest_conn(struct netns_ipvs *ipvs)
> -{
> -       return ipvs->sysctl_expire_nodest_conn;
> -}
> -
>  #else
>
>  static int sysctl_snat_reroute(struct netns_ipvs *ipvs) { return 0; }
>  static int sysctl_nat_icmp_send(struct netns_ipvs *ipvs) { return 0; }
> -static int sysctl_expire_nodest_conn(struct netns_ipvs *ipvs) { return 0; }
>
>  #endif
>
> @@ -2095,36 +2089,33 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
>                 }
>         }
>
> -       if (unlikely(!cp)) {
> -               int v;
> -
> -               if (!ip_vs_try_to_schedule(ipvs, af, skb, pd, &v, &cp, &iph))
> -                       return v;
> -       }
> -
> -       IP_VS_DBG_PKT(11, af, pp, skb, iph.off, "Incoming packet");
> -
>         /* Check the server status */
> -       if (cp->dest && !(cp->dest->flags & IP_VS_DEST_F_AVAILABLE)) {
> +       if (cp && cp->dest && !(cp->dest->flags & IP_VS_DEST_F_AVAILABLE)) {
>                 /* the destination server is not available */
>
> -               __u32 flags = cp->flags;
> -
> -               /* when timer already started, silently drop the packet.*/
> -               if (timer_pending(&cp->timer))
> -                       __ip_vs_conn_put(cp);
> -               else
> -                       ip_vs_conn_put(cp);
> +               if (sysctl_expire_nodest_conn(ipvs)) {
> +                       bool uses_ct = ip_vs_conn_uses_conntrack(cp, skb);
>
> -               if (sysctl_expire_nodest_conn(ipvs) &&
> -                   !(flags & IP_VS_CONN_F_ONE_PACKET)) {
> -                       /* try to expire the connection immediately */
>                         ip_vs_conn_expire_now(cp);
> +                       __ip_vs_conn_put(cp);
> +                       if (uses_ct)
> +                               return NF_DROP;
> +                       cp = NULL;
> +               } else {
> +                       __ip_vs_conn_put(cp);
> +                       return NF_DROP;
>                 }
> +       }
>
> -               return NF_DROP;
> +       if (unlikely(!cp)) {
> +               int v;
> +
> +               if (!ip_vs_try_to_schedule(ipvs, af, skb, pd, &v, &cp, &iph))
> +                       return v;
>         }
>
> +       IP_VS_DBG_PKT(11, af, pp, skb, iph.off, "Incoming packet");
> +
>         ip_vs_in_stats(cp, skb);
>         ip_vs_set_state(cp, IP_VS_DIR_INPUT, skb, pd);
>         if (cp->packet_xmit)
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 8d14a1acbc37..24736efac85c 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -210,6 +210,17 @@ static void update_defense_level(struct netns_ipvs *ipvs)
>         local_bh_enable();
>  }
>
> +/*     Handler for delayed work for expiring no
> + *     destination connections
> + */
> +static void expire_nodest_conn_handler(struct work_struct *work)
> +{
> +       struct netns_ipvs *ipvs;
> +
> +       ipvs = container_of(work, struct netns_ipvs,
> +                           expire_nodest_conn_work.work);
> +       ip_vs_expire_nodest_conn_flush(ipvs);
> +}
>
>  /*
>   *     Timer for checking the defense
> @@ -1163,6 +1174,12 @@ static void __ip_vs_del_dest(struct netns_ipvs *ipvs, struct ip_vs_dest *dest,
>         list_add(&dest->t_list, &ipvs->dest_trash);
>         dest->idle_start = 0;
>         spin_unlock_bh(&ipvs->dest_trash_lock);
> +
> +       /*      Queue up delayed work to expire all no estination connections.
> +        *      No-op when CONFIG_SYSCTL is disabled.
> +        */
> +       if (!cleanup)
> +               ip_vs_enqueue_expire_nodest_conns(ipvs);
>  }
>
>
> @@ -4065,6 +4082,10 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
>         INIT_DELAYED_WORK(&ipvs->defense_work, defense_work_handler);
>         schedule_delayed_work(&ipvs->defense_work, DEFENSE_TIMER_PERIOD);
>
> +       /* Init delayed work for expiring no dest conn */
> +       INIT_DELAYED_WORK(&ipvs->expire_nodest_conn_work,
> +                         expire_nodest_conn_handler);
> +
>         return 0;
>  }
>
> @@ -4072,6 +4093,7 @@ static void __net_exit ip_vs_control_net_cleanup_sysctl(struct netns_ipvs *ipvs)
>  {
>         struct net *net = ipvs->net;
>
> +       cancel_delayed_work_sync(&ipvs->expire_nodest_conn_work);
>         cancel_delayed_work_sync(&ipvs->defense_work);
>         cancel_work_sync(&ipvs->defense_work.work);
>         unregister_net_sysctl_table(ipvs->sysctl_hdr);
> --
> 2.20.1
>
