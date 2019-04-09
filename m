Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D0FC282CE
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 12:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D94342084F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 12:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfDIM6B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 08:58:01 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43105 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727367AbfDIM6B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 08:58:01 -0400
Received: by mail-ot1-f68.google.com with SMTP id u15so15395596otq.10
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Apr 2019 05:58:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BwXo0uFNihYstUH5LVz3cKdXiA5bwZ5eOv+D7iD7tJk=;
        b=YFDq99Pt+3nZ7YuwVpJiqzd+U31bS/CTqaJGs3I4hLGJKPVwjNBtX+l9+IZ10BRTaC
         92FyVBBztxIj/pzyYXMQ3fQOh2shGoCc/QxHg3sizbFwCoBxejG1uboLZ7RrxPeeFMqs
         TY7y37Pd2d5N72So5ZwX4RfD0eW8M0xn7nFIGcytZU6+PH8uV/eySQODbruyqJ8nI0Ng
         I9MP63yyVtf4AFFhFPMs6+qGSrl9ihgf6Cz5JUpo0PzzDxvtJUBubt4UkKVgY/Qcvw4Y
         BZTCRni/F5ywzu/QwJAUM1JS9Kk1kjjajV+MA0Ds+9lfPoiK7AOIXUMQDoPGTxDjbq4p
         JTXw==
X-Gm-Message-State: APjAAAX1xjoMH/EVj+jGwrjYEfNKm9LUp1jZQxW4pW5kl23n5OwVQpZO
        S5rJebzruGRen3HIrg2AHJEslWiPMgTU7Vj3GJ1c0w==
X-Google-Smtp-Source: APXvYqyVlghjm0c4DsiqmvAf5XvkBygKZ9WhfoIdhghOnk5r+nDn11yE4lT1SIIt/gib1bAaGDq8OQHsuTgjXFhWGjM=
X-Received: by 2002:a9d:6941:: with SMTP id p1mr23213980oto.64.1554814680445;
 Tue, 09 Apr 2019 05:58:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <baa5f3c6d4aa7f9fec903ebb51949f3ac743d067.1554732921.git.rgb@redhat.com>
In-Reply-To: <baa5f3c6d4aa7f9fec903ebb51949f3ac743d067.1554732921.git.rgb@redhat.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Tue, 9 Apr 2019 14:57:50 +0200
Message-ID: <CAFqZXNvZTb-OrCHugEc2TrW57EX_f_+absARpR1bUBN3_uavdQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 05/10] audit: add contid support for signalling
 the audit daemon
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

On Tue, Apr 9, 2019 at 5:40 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> Add audit container identifier support to the action of signalling the
> audit daemon.
>
> Since this would need to add an element to the audit_sig_info struct,
> a new record type AUDIT_SIGNAL_INFO2 was created with a new
> audit_sig_info2 struct.  Corresponding support is required in the
> userspace code to reflect the new record request and reply type.
> An older userspace won't break since it won't know to request this
> record type.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>

This looks good to me.

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>

Although I'm wondering if we shouldn't try to future-proof the
AUDIT_SIGNAL_INFO2 format somehow, so that we don't need to add
another AUDIT_SIGNAL_INFO3 when the need arises to add yet-another
identifier to it... The simplest solution I can come up with is to add
a "version" field at the beginning (set to 2 initially), then v<N>_len
at the beginning of data for version <N>. But maybe this is too
complicated for too little gain...

> ---
>  include/linux/audit.h       |  7 +++++++
>  include/uapi/linux/audit.h  |  1 +
>  kernel/audit.c              | 27 +++++++++++++++++++++++++++
>  kernel/audit.h              |  1 +
>  kernel/auditsc.c            |  1 +
>  security/selinux/nlmsgtab.c |  1 +
>  6 files changed, 38 insertions(+)
>
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 43438192ca2a..c2dec9157463 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -37,6 +37,13 @@ struct audit_sig_info {
>         char            ctx[0];
>  };
>
> +struct audit_sig_info2 {
> +       uid_t           uid;
> +       pid_t           pid;
> +       u64             cid;
> +       char            ctx[0];
> +};
> +
>  struct audit_buffer;
>  struct audit_context;
>  struct inode;
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index 55fde9970762..10cc67926cf1 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -72,6 +72,7 @@
>  #define AUDIT_SET_FEATURE      1018    /* Turn an audit feature on or off */
>  #define AUDIT_GET_FEATURE      1019    /* Get which features are enabled */
>  #define AUDIT_CONTAINER_OP     1020    /* Define the container id and info */
> +#define AUDIT_SIGNAL_INFO2     1021    /* Get info auditd signal sender */
>
>  #define AUDIT_FIRST_USER_MSG   1100    /* Userspace messages mostly uninteresting to kernel */
>  #define AUDIT_USER_AVC         1107    /* We filter this differently */
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 3e0af53f3c4d..87e1d367f98c 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -138,6 +138,7 @@ struct audit_net {
>  kuid_t         audit_sig_uid = INVALID_UID;
>  pid_t          audit_sig_pid = -1;
>  u32            audit_sig_sid = 0;
> +u64            audit_sig_cid = AUDIT_CID_UNSET;
>
>  /* Records can be lost in several ways:
>     0) [suppressed in audit_alloc]
> @@ -1097,6 +1098,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
>         case AUDIT_ADD_RULE:
>         case AUDIT_DEL_RULE:
>         case AUDIT_SIGNAL_INFO:
> +       case AUDIT_SIGNAL_INFO2:
>         case AUDIT_TTY_GET:
>         case AUDIT_TTY_SET:
>         case AUDIT_TRIM:
> @@ -1260,6 +1262,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>         struct audit_buffer     *ab;
>         u16                     msg_type = nlh->nlmsg_type;
>         struct audit_sig_info   *sig_data;
> +       struct audit_sig_info2  *sig_data2;
>         char                    *ctx = NULL;
>         u32                     len;
>
> @@ -1519,6 +1522,30 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>                                  sig_data, sizeof(*sig_data) + len);
>                 kfree(sig_data);
>                 break;
> +       case AUDIT_SIGNAL_INFO2:
> +               len = 0;
> +               if (audit_sig_sid) {
> +                       err = security_secid_to_secctx(audit_sig_sid, &ctx, &len);
> +                       if (err)
> +                               return err;
> +               }
> +               sig_data2 = kmalloc(sizeof(*sig_data2) + len, GFP_KERNEL);
> +               if (!sig_data2) {
> +                       if (audit_sig_sid)
> +                               security_release_secctx(ctx, len);
> +                       return -ENOMEM;
> +               }
> +               sig_data2->uid = from_kuid(&init_user_ns, audit_sig_uid);
> +               sig_data2->pid = audit_sig_pid;
> +               if (audit_sig_sid) {
> +                       memcpy(sig_data2->ctx, ctx, len);
> +                       security_release_secctx(ctx, len);
> +               }
> +               sig_data2->cid = audit_sig_cid;
> +               audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO2, 0, 0,
> +                                sig_data2, sizeof(*sig_data2) + len);
> +               kfree(sig_data2);
> +               break;
>         case AUDIT_TTY_GET: {
>                 struct audit_tty_status s;
>                 unsigned int t;
> diff --git a/kernel/audit.h b/kernel/audit.h
> index e2912924af0d..c5ac6436317e 100644
> --- a/kernel/audit.h
> +++ b/kernel/audit.h
> @@ -345,6 +345,7 @@ extern void audit_filter_inodes(struct task_struct *tsk,
>  extern pid_t audit_sig_pid;
>  extern kuid_t audit_sig_uid;
>  extern u32 audit_sig_sid;
> +extern u64 audit_sig_cid;
>
>  extern int audit_filter(int msgtype, unsigned int listtype);
>
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index eea445b7a181..0a29a00feaf1 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2405,6 +2405,7 @@ int audit_signal_info(int sig, struct task_struct *t)
>                 else
>                         audit_sig_uid = uid;
>                 security_task_getsecid(current, &audit_sig_sid);
> +               audit_sig_cid = audit_get_contid(current);
>         }
>
>         if (!audit_signals || audit_dummy_context())
> diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
> index 9cec81209617..682fe7397762 100644
> --- a/security/selinux/nlmsgtab.c
> +++ b/security/selinux/nlmsgtab.c
> @@ -132,6 +132,7 @@ struct nlmsg_perm {
>         { AUDIT_DEL_RULE,       NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
>         { AUDIT_USER,           NETLINK_AUDIT_SOCKET__NLMSG_RELAY    },
>         { AUDIT_SIGNAL_INFO,    NETLINK_AUDIT_SOCKET__NLMSG_READ     },
> +       { AUDIT_SIGNAL_INFO2,   NETLINK_AUDIT_SOCKET__NLMSG_READ     },
>         { AUDIT_TRIM,           NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
>         { AUDIT_MAKE_EQUIV,     NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
>         { AUDIT_TTY_GET,        NETLINK_AUDIT_SOCKET__NLMSG_READ     },
> --
> 1.8.3.1
>


--
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
