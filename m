Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43DADC10F00
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 22:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A9F62082F
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 22:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbfC0Ww4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 18:52:56 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42986 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728119AbfC0Ww4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 18:52:56 -0400
Received: by mail-ot1-f66.google.com with SMTP id 103so16522117otd.9
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Mar 2019 15:52:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j4D7t/jfnJReTiEUplqMUiF45/wNeOE9/UkpzPNclWw=;
        b=en16oKLLBiqRWrfRgLQOXZyH39IhB3SEnwQlGRfhDJ7W+ovN3R7dionU7mMqAgc8se
         9rBTen/bXhp8WaKOUtG/1VPk5gKuO03Wymse9ogMQkepyEA7E6mJwliZ582Mo4wrgmOM
         zWcJopfHUmQGHSqIjPdRvxRpktcrz5J9x9lxYjDaaHCxO5ZnfDSfHuiGJPf5h87F+L2Y
         cCR3d6Ftm6XKP+cKynr+M8ZQZwMu8RzLrzhcinHtl0yWhFuThwNu7zcTMBDF4MCvEMLx
         KQoS7u4asAUhhu5ICIAWqhbRHtwfoFaqDd5XVH2aArIQuRybYqVSvtfF8VpS/CpKOuaw
         aG0g==
X-Gm-Message-State: APjAAAVxUDkawPovI0LAZL88qNvBLiy5WUJBgKo539kDmfKWImmeaWAl
        Vfs7+ZWaiX0FoROjWyg4xS562TRsKA0T25Q1aCAsug==
X-Google-Smtp-Source: APXvYqzVTNyb5pmkvTvALcQQW2qrk3BoqtjPrCYfd4/RaOC1TkMa2aIEkW/n8TG0pO7QqEfXt4EtC6dbTY60/febJYE=
X-Received: by 2002:a9d:6306:: with SMTP id q6mr27266770otk.86.1553727175725;
 Wed, 27 Mar 2019 15:52:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1552665316.git.rgb@redhat.com> <56127b2a5b82f15cb0d0f040502c2e3bb6945f30.1552665316.git.rgb@redhat.com>
In-Reply-To: <56127b2a5b82f15cb0d0f040502c2e3bb6945f30.1552665316.git.rgb@redhat.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Wed, 27 Mar 2019 23:52:44 +0100
Message-ID: <CAFqZXNsV=XFRRqKnkwQqwuVuJ3rtrbS-88__6hKo=igwxE8+vg@mail.gmail.com>
Subject: Re: [PATCH ghak90 V5 10/10] audit: NETFILTER_PKT: record each
 container ID associated with a netNS
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Simo Sorce <simo@redhat.com>,
        Eric Paris <eparis@parisplace.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>, nhorman@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 15, 2019 at 7:35 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Add audit container identifier auxiliary record(s) to NETFILTER_PKT
> event standalone records.  Iterate through all potential audit container
> identifiers associated with a network namespace.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>

(Just note another "%llu"/u64 occurence, in case you plan to add the casts.)

> ---
>  include/linux/audit.h    |  5 +++++
>  kernel/audit.c           | 41 +++++++++++++++++++++++++++++++++++++++++
>  net/netfilter/nft_log.c  | 11 +++++++++--
>  net/netfilter/xt_AUDIT.c | 11 +++++++++--
>  4 files changed, 64 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 70255c2dfb9f..723e2d020228 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -214,6 +214,8 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
>  extern void audit_netns_contid_del(struct net *net, u64 contid);
>  extern void audit_switch_task_namespaces(struct nsproxy *ns,
>                                          struct task_struct *p);
> +extern void audit_log_netns_contid_list(struct net *net,
> +                                       struct audit_context *context);
>
>  extern u32 audit_enabled;
>  #else /* CONFIG_AUDIT */
> @@ -290,6 +292,9 @@ static inline void audit_netns_contid_del(struct net *net, u64 contid)
>  static inline void audit_switch_task_namespaces(struct nsproxy *ns,
>                                                 struct task_struct *p)
>  { }
> +static inline void audit_log_netns_contid_list(struct net *net,
> +                                              struct audit_context *context)
> +{ }
>
>  #define audit_enabled AUDIT_OFF
>  #endif /* CONFIG_AUDIT */
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 7fa3194f5342..80ed323feeb5 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -451,6 +451,47 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
>                 audit_netns_contid_add(new->net_ns, contid);
>  }
>
> +/**
> + * audit_log_netns_contid_list - List contids for the given network namespace
> + * @net: the network namespace of interest
> + * @context: the audit context to use
> + *
> + * Description:
> + * Issues a CONTAINER_ID record with a CSV list of contids associated
> + * with a network namespace to accompany a NETFILTER_PKT record.
> + */
> +void audit_log_netns_contid_list(struct net *net, struct audit_context *context)
> +{
> +       struct audit_buffer *ab = NULL;
> +       struct audit_contid *cont;
> +       bool first = true;
> +       struct audit_net *aunet;
> +
> +       /* Generate AUDIT_CONTAINER_ID record with container ID CSV list */
> +       rcu_read_lock();
> +       aunet = net_generic(net, audit_net_id);
> +       if (!aunet)
> +               goto out;
> +       list_for_each_entry_rcu(cont, &aunet->contid_list, list) {
> +               if (first) {
> +                       ab = audit_log_start(context, GFP_ATOMIC,
> +                                            AUDIT_CONTAINER_ID);
> +                       if (!ab) {
> +                               audit_log_lost("out of memory in audit_log_netns_contid_list");
> +                               goto out;
> +                       }
> +                       audit_log_format(ab, "contid=");
> +               } else
> +                       audit_log_format(ab, ",");
> +               audit_log_format(ab, "%llu", cont->id);
> +               first = false;
> +       }
> +       audit_log_end(ab);
> +out:
> +       rcu_read_unlock();
> +}
> +EXPORT_SYMBOL(audit_log_netns_contid_list);
> +
>  void audit_panic(const char *message)
>  {
>         switch (audit_failure) {
> diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
> index 655187bed5d8..bdb1ec2368a7 100644
> --- a/net/netfilter/nft_log.c
> +++ b/net/netfilter/nft_log.c
> @@ -69,13 +69,16 @@ static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
>         struct sk_buff *skb = pkt->skb;
>         struct audit_buffer *ab;
>         int fam = -1;
> +       struct audit_context *context;
> +       struct net *net;
>
>         if (!audit_enabled)
>                 return;
>
> -       ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
> +       context = audit_alloc_local(GFP_ATOMIC);
> +       ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
>         if (!ab)
> -               return;
> +               goto errout;
>
>         audit_log_format(ab, "mark=%#x", skb->mark);
>
> @@ -102,6 +105,10 @@ static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
>                 audit_log_format(ab, " saddr=? daddr=? proto=-1");
>
>         audit_log_end(ab);
> +       net = xt_net(&pkt->xt);
> +       audit_log_netns_contid_list(net, context);
> +errout:
> +       audit_free_context(context);
>  }
>
>  static void nft_log_eval(const struct nft_expr *expr,
> diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
> index af883f1b64f9..a3e547435f13 100644
> --- a/net/netfilter/xt_AUDIT.c
> +++ b/net/netfilter/xt_AUDIT.c
> @@ -71,10 +71,13 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
>  {
>         struct audit_buffer *ab;
>         int fam = -1;
> +       struct audit_context *context;
> +       struct net *net;
>
>         if (audit_enabled == AUDIT_OFF)
> -               goto errout;
> -       ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
> +               goto out;
> +       context = audit_alloc_local(GFP_ATOMIC);
> +       ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
>         if (ab == NULL)
>                 goto errout;
>
> @@ -104,7 +107,11 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
>
>         audit_log_end(ab);
>
> +       net = xt_net(par);
> +       audit_log_netns_contid_list(net, context);
>  errout:
> +       audit_free_context(context);
> +out:
>         return XT_CONTINUE;
>  }
>
> --
> 1.8.3.1
>


-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
