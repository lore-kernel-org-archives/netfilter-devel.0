Return-Path: <SRS0=YYk6=R7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D07C4360F
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Mar 2019 02:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F2AA2146F
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Mar 2019 02:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbfC1CEZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 22:04:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbfC1CEZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 22:04:25 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EB60E307D987;
        Thu, 28 Mar 2019 02:04:24 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B58EA1001DC0;
        Thu, 28 Mar 2019 02:04:13 +0000 (UTC)
Date:   Wed, 27 Mar 2019 22:04:10 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Ondrej Mosnacek <omosnace@redhat.com>
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
Subject: Re: [PATCH ghak90 V5 05/10] audit: add containerid support for
 ptrace and signals
Message-ID: <20190328020410.pl7odjknw7robdk3@madcap2.tricolour.ca>
References: <cover.1552665316.git.rgb@redhat.com>
 <a5a612bff629574cf4b678e7c7a9315e0e60a27c.1552665316.git.rgb@redhat.com>
 <CAFqZXNuMjvds9OKoj--zgn5j8CGuW55ZGhTPHtKGb+ZOR6B2-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFqZXNuMjvds9OKoj--zgn5j8CGuW55ZGhTPHtKGb+ZOR6B2-A@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 28 Mar 2019 02:04:25 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2019-03-27 22:17, Ondrej Mosnacek wrote:
> On Fri, Mar 15, 2019 at 7:34 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > Add audit container identifier support to ptrace and signals.  In
> > particular, the "ref" field provides a way to label the auxiliary record
> > to which it is associated.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > Acked-by: Serge Hallyn <serge@hallyn.com>
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/audit.h |  1 +
> >  kernel/audit.c        |  2 ++
> >  kernel/audit.h        |  2 ++
> >  kernel/auditsc.c      | 23 +++++++++++++++++------
> >  4 files changed, 22 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 43438192ca2a..ebd6625ca80e 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -35,6 +35,7 @@ struct audit_sig_info {
> >         uid_t           uid;
> >         pid_t           pid;
> >         char            ctx[0];
> > +       u64             cid;
> >  };
> 
> It seems like this structure implicitly defines the format of some
> message that is sent to userspace... If so, how will userspace detect
> that a new format (including the cid) is being used? Even assuming the
> fixed order as pointed out by Neil, the message still seems to be
> variable-sized so userspace cannot even use the length to infer that.
> Am I missing something here? (I hope I am :)

How humble of you again.  No, you're not missing something.  This ends
up being an api change...  That can be fixed in userspace by checking
for AUDIT_FEATURE_BITMAP_CONTAINERID, but how do we make a newer kernel
not break an older userspace...  I think this was the original rationale
for adding it after the ctx but totally missing the fact that the latter
is a variable-length field.

This patch really should be split into audit_sig_cid changes in a patch
by itself and target_cid changes which could go with the second and
fourth patches.

> >  struct audit_buffer;
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 8cc0e88d7f2a..cfa659b3f6c4 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -138,6 +138,7 @@ struct audit_net {
> >  kuid_t         audit_sig_uid = INVALID_UID;
> >  pid_t          audit_sig_pid = -1;
> >  u32            audit_sig_sid = 0;
> > +u64            audit_sig_cid = AUDIT_CID_UNSET;
> >
> >  /* Records can be lost in several ways:
> >     0) [suppressed in audit_alloc]
> > @@ -1515,6 +1516,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >                         memcpy(sig_data->ctx, ctx, len);
> >                         security_release_secctx(ctx, len);
> >                 }
> > +               sig_data->cid = audit_sig_cid;
> >                 audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO, 0, 0,
> >                                  sig_data, sizeof(*sig_data) + len);
> >                 kfree(sig_data);
> > diff --git a/kernel/audit.h b/kernel/audit.h
> > index c00e2ee3c6b3..c5ac6436317e 100644
> > --- a/kernel/audit.h
> > +++ b/kernel/audit.h
> > @@ -148,6 +148,7 @@ struct audit_context {
> >         kuid_t              target_uid;
> >         unsigned int        target_sessionid;
> >         u32                 target_sid;
> > +       u64                 target_cid;
> >         char                target_comm[TASK_COMM_LEN];
> >
> >         struct audit_tree_refs *trees, *first_trees;
> > @@ -344,6 +345,7 @@ extern void audit_filter_inodes(struct task_struct *tsk,
> >  extern pid_t audit_sig_pid;
> >  extern kuid_t audit_sig_uid;
> >  extern u32 audit_sig_sid;
> > +extern u64 audit_sig_cid;
> >
> >  extern int audit_filter(int msgtype, unsigned int listtype);
> >
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index a8c8b44b954d..f04e115df5dc 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -113,6 +113,7 @@ struct audit_aux_data_pids {
> >         kuid_t                  target_uid[AUDIT_AUX_PIDS];
> >         unsigned int            target_sessionid[AUDIT_AUX_PIDS];
> >         u32                     target_sid[AUDIT_AUX_PIDS];
> > +       u64                     target_cid[AUDIT_AUX_PIDS];
> >         char                    target_comm[AUDIT_AUX_PIDS][TASK_COMM_LEN];
> >         int                     pid_count;
> >  };
> > @@ -1514,7 +1515,7 @@ static void audit_log_exit(void)
> >         for (aux = context->aux_pids; aux; aux = aux->next) {
> >                 struct audit_aux_data_pids *axs = (void *)aux;
> >
> > -               for (i = 0; i < axs->pid_count; i++)
> > +               for (i = 0; i < axs->pid_count; i++) {
> >                         if (audit_log_pid_context(context, axs->target_pid[i],
> >                                                   axs->target_auid[i],
> >                                                   axs->target_uid[i],
> > @@ -1522,14 +1523,20 @@ static void audit_log_exit(void)
> >                                                   axs->target_sid[i],
> >                                                   axs->target_comm[i]))
> >                                 call_panic = 1;
> > +                       audit_log_contid(context, axs->target_cid[i]);
> > +               }
> >         }
> >
> > -       if (context->target_pid &&
> > -           audit_log_pid_context(context, context->target_pid,
> > -                                 context->target_auid, context->target_uid,
> > -                                 context->target_sessionid,
> > -                                 context->target_sid, context->target_comm))
> > +       if (context->target_pid) {
> > +               if (audit_log_pid_context(context, context->target_pid,
> > +                                         context->target_auid,
> > +                                         context->target_uid,
> > +                                         context->target_sessionid,
> > +                                         context->target_sid,
> > +                                         context->target_comm))
> >                         call_panic = 1;
> > +               audit_log_contid(context, context->target_cid);
> > +       }
> >
> >         if (context->pwd.dentry && context->pwd.mnt) {
> >                 ab = audit_log_start(context, GFP_KERNEL, AUDIT_CWD);
> > @@ -2360,6 +2367,7 @@ void __audit_ptrace(struct task_struct *t)
> >         context->target_uid = task_uid(t);
> >         context->target_sessionid = audit_get_sessionid(t);
> >         security_task_getsecid(t, &context->target_sid);
> > +       context->target_cid = audit_get_contid(t);
> >         memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
> >  }
> >
> > @@ -2387,6 +2395,7 @@ int audit_signal_info(int sig, struct task_struct *t)
> >                 else
> >                         audit_sig_uid = uid;
> >                 security_task_getsecid(current, &audit_sig_sid);
> > +               audit_sig_cid = audit_get_contid(current);
> >         }
> >
> >         if (!audit_signals || audit_dummy_context())
> > @@ -2400,6 +2409,7 @@ int audit_signal_info(int sig, struct task_struct *t)
> >                 ctx->target_uid = t_uid;
> >                 ctx->target_sessionid = audit_get_sessionid(t);
> >                 security_task_getsecid(t, &ctx->target_sid);
> > +               ctx->target_cid = audit_get_contid(t);
> >                 memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
> >                 return 0;
> >         }
> > @@ -2421,6 +2431,7 @@ int audit_signal_info(int sig, struct task_struct *t)
> >         axp->target_uid[axp->pid_count] = t_uid;
> >         axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
> >         security_task_getsecid(t, &axp->target_sid[axp->pid_count]);
> > +       axp->target_cid[axp->pid_count] = audit_get_contid(t);
> >         memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
> >         axp->pid_count++;
> >
> > --
> > 1.8.3.1
> >
> 
> 
> -- 
> Ondrej Mosnacek <omosnace at redhat dot com>
> Software Engineer, Security Technologies
> Red Hat, Inc.

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
