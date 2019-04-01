Return-Path: <SRS0=mHk2=SD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163BFC43381
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Apr 2019 14:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8D9920856
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Apr 2019 14:50:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="KLO26Izz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbfDAOuZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Apr 2019 10:50:25 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40791 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbfDAOuY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Apr 2019 10:50:24 -0400
Received: by mail-lf1-f65.google.com with SMTP id a28so6506744lfo.7
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Apr 2019 07:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F4fiz+REIk+4P/IuLXa3dMzfEJ9FOhjUzzuCqicW/i4=;
        b=KLO26IzzCHrHLWIIWEtJHs3ptBi1V63skFbqWeHdha5vN3ccQsPVlMk/eoDHMt0ZoJ
         n/8ANSJ4DBRRr26WhFRmV2RjtU67G/n3qseg14omb2vULab+YP0KmvmiNJJDRgXQr4pC
         jSc74eq4X+xrfxrBIKIdCDiRRWPPmnQFZXDS2Fwrz/x9Sxp8RCb2B6SMk2kQWXIqNVgV
         NkkE3LuFmFHSGKdNO3y3RYM3CLUa2sA+cP5Op54PVV1su2MI3idoB8nGAhyL/siWBJBl
         sSE9CQsGhZiYkgtM37jCS5AHx+ghfFxxoasq29cTjggVux0MnrXy/hA367bzn7nx6rto
         dwwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F4fiz+REIk+4P/IuLXa3dMzfEJ9FOhjUzzuCqicW/i4=;
        b=gNm4NW9zIq5jNTllFdC+k5IOhsSWqeLg4cWys8MdiybabOn26yhW3U1fYraOAx+AYg
         h8b2WeFBHASI6UouaABPbgRoKac6C4RF87kGu9k/m/Y/ITsAt0Bu2dKXBmJvsw3cJsBJ
         lC5T7VxfUT6x1YvrtoXQKM37lAipf9Yolo3j9zBQrsiRop/1FqLLHY9gM6QrQ3sNzqvD
         5TJKHsyiZNl0ZCGgMTIwo16re8YiJetqnBPVQJDf1x0PtlblJxNX1Y/p7noOQ00aUDB4
         pTLk+IL035Uq/xXnJS+yccYh1BFKFauJWRqHfjjcckqQ4y2Slc4GuUmZreUO+Zk3kr0t
         xyqA==
X-Gm-Message-State: APjAAAVg5oruEIJEuJfaIhrX4o8TyBNt5+CWnZL0k5t+RRkJdNo/mwDu
        lWdKijxs8c5XKIjDxVW2h7WGIkKb+hO7+ciGEoqo
X-Google-Smtp-Source: APXvYqycEhCk/RLnRKBt1+1tOQq70T4c4J9YHX6qPjYV4tGhlDhtgDUXZ2NUYqiBVnZ6MhvQm4LoiSG9PyslerMiSWI=
X-Received: by 2002:a19:7613:: with SMTP id c19mr31904156lff.105.1554130222709;
 Mon, 01 Apr 2019 07:50:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1552665316.git.rgb@redhat.com> <56127b2a5b82f15cb0d0f040502c2e3bb6945f30.1552665316.git.rgb@redhat.com>
In-Reply-To: <56127b2a5b82f15cb0d0f040502c2e3bb6945f30.1552665316.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 1 Apr 2019 10:50:11 -0400
Message-ID: <CAHC9VhQpNGaWeb7dY4ooPKXRoGBd9Ri_Z_ZPpoKun4gUhXDOGA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V5 10/10] audit: NETFILTER_PKT: record each
 container ID associated with a netNS
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 15, 2019 at 2:35 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Add audit container identifier auxiliary record(s) to NETFILTER_PKT
> event standalone records.  Iterate through all potential audit container
> identifiers associated with a network namespace.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h    |  5 +++++
>  kernel/audit.c           | 41 +++++++++++++++++++++++++++++++++++++++++
>  net/netfilter/nft_log.c  | 11 +++++++++--
>  net/netfilter/xt_AUDIT.c | 11 +++++++++--
>  4 files changed, 64 insertions(+), 4 deletions(-)

...

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

This is borderline nit-picky, but it seems like we could get rid of
"first" and just check to see if "ab" is still NULL.

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

-- 
paul moore
www.paul-moore.com
