Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 654B1C4360F
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 21:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C5C02082F
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 21:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbfC0Va6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 17:30:58 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38541 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfC0Va6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 17:30:58 -0400
Received: by mail-oi1-f195.google.com with SMTP id w137so14123172oiw.5
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Mar 2019 14:30:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JCxnMapnujBLhv3W4a2O/ybJVO1nPLBLzENy+BoBkzI=;
        b=Az2paOxdUIfKV1J8QOWwLh05GS8lrq9y84Mlg03Z6KenPr+IVfDv8Lj9F+/p+nhIv7
         CEm9FlObnQn1hC+KLnAwr/f3Q2rbn54ajnB2ygp+O9rfRBut0L2u8iukgk1xiwTbTzGb
         nrlNg+0XhaveE4I4/trvslVH3Ks7A+7qYISImi0xZvtE/bZAV+djJEG1xSMjNhv7eOp7
         UB+TqK5kb3C3RMKWloXrvOopQo5MD6hvBPDmvSV2w+gryXjTCONdo4AjHY6VkOWuf6TB
         K4QTlPkkAXA053nlE8Wo2t6018loIoOZ07wXBJ8BmTYZQRoUGVG1wA8ccY3hIdWYBFXV
         1lrw==
X-Gm-Message-State: APjAAAX7FTd9BnJEyHfmsiSU284IAAnoH0T4B5BZIx4cpuM/AwvfKuPN
        mHjXEgQWPAjscq++RYt4omW879hxWGa9Px3I6+3Oiw==
X-Google-Smtp-Source: APXvYqzpOsg5/ddMOVD6tkFIZoG8HsMUEk6pRb/r/uF6W8zIIVx6JNflvK9lq1O5TOVwuTtQRCo+bN1aBWuoR+W7Pa8=
X-Received: by 2002:aca:5747:: with SMTP id l68mr21554750oib.103.1553722257766;
 Wed, 27 Mar 2019 14:30:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1552665316.git.rgb@redhat.com> <e724de2037db0fd72fef7154c83615a742417d31.1552665316.git.rgb@redhat.com>
In-Reply-To: <e724de2037db0fd72fef7154c83615a742417d31.1552665316.git.rgb@redhat.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Wed, 27 Mar 2019 22:30:46 +0100
Message-ID: <CAFqZXNu2NRJg-cy_b=ig4o7v6+3dV1kGp8QtKRcVbtBxrapDMQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V5 07/10] audit: add containerid support for user records
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

On Fri, Mar 15, 2019 at 7:34 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Add audit container identifier auxiliary record to user event standalone
> records.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>

> ---
>  kernel/audit.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/audit.c b/kernel/audit.c
> index cfa659b3f6c4..cf448599ef34 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1142,12 +1142,6 @@ static void audit_log_common_recv_msg(struct audit_context *context,
>         audit_log_task_context(*ab);
>  }
>
> -static inline void audit_log_user_recv_msg(struct audit_buffer **ab,
> -                                          u16 msg_type)
> -{
> -       audit_log_common_recv_msg(NULL, ab, msg_type);
> -}
> -
>  int is_audit_feature_set(int i)
>  {
>         return af.features & AUDIT_FEATURE_TO_MASK(i);
> @@ -1409,13 +1403,16 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>
>                 err = audit_filter(msg_type, AUDIT_FILTER_USER);
>                 if (err == 1) { /* match or error */
> +                       struct audit_context *context;
> +
>                         err = 0;
>                         if (msg_type == AUDIT_USER_TTY) {
>                                 err = tty_audit_push();
>                                 if (err)
>                                         break;
>                         }
> -                       audit_log_user_recv_msg(&ab, msg_type);
> +                       context = audit_alloc_local(GFP_KERNEL);
> +                       audit_log_common_recv_msg(context, &ab, msg_type);
>                         if (msg_type != AUDIT_USER_TTY)
>                                 audit_log_format(ab, " msg='%.*s'",
>                                                  AUDIT_MESSAGE_TEXT_MAX,
> @@ -1431,6 +1428,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>                                 audit_log_n_untrustedstring(ab, data, size);
>                         }
>                         audit_log_end(ab);
> +                       audit_log_contid(context, audit_get_contid(current));
> +                       audit_free_context(context);
>                 }
>                 break;
>         case AUDIT_ADD_RULE:
> --
> 1.8.3.1
>


-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
