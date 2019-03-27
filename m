Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F73C4360F
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 22:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D77A7206BA
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 22:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfC0WK2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 18:10:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbfC0WK1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 18:10:27 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1EF68CD4A8;
        Wed, 27 Mar 2019 22:10:27 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD6E8182D0;
        Wed, 27 Mar 2019 22:10:15 +0000 (UTC)
Date:   Wed, 27 Mar 2019 18:10:13 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Simo Sorce <simo@redhat.com>, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH ghak90 V5 04/10] audit: log container info of syscalls
Message-ID: <20190327221012.42vjkifdfifuaczi@madcap2.tricolour.ca>
References: <cover.1552665316.git.rgb@redhat.com>
 <85fcd0a81adef25cb60b2e479bbb380e76dbf999.1552665316.git.rgb@redhat.com>
 <CAFqZXNvM+d_MKGVykLtcHkwwZhO_UOYACJQu-92tEOvkk7uMrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFqZXNvM+d_MKGVykLtcHkwwZhO_UOYACJQu-92tEOvkk7uMrQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 27 Mar 2019 22:10:27 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2019-03-27 22:01, Ondrej Mosnacek wrote:
> On Fri, Mar 15, 2019 at 7:34 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > Create a new audit record AUDIT_CONTAINER_ID to document the audit
> > container identifier of a process if it is present.
> >
> > Called from audit_log_exit(), syscalls are covered.
> >
> > A sample raw event:
> > type=SYSCALL msg=audit(1519924845.499:257): arch=c000003e syscall=257 success=yes exit=3 a0=ffffff9c a1=56374e1cef30 a2=241 a3=1b6 items=2 ppid=606 pid=635 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=3 comm="bash" exe="/usr/bin/bash" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="tmpcontainerid"
> > type=CWD msg=audit(1519924845.499:257): cwd="/root"
> > type=PATH msg=audit(1519924845.499:257): item=0 name="/tmp/" inode=13863 dev=00:27 mode=041777 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:tmp_t:s0 nametype= PARENT cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0
> > type=PATH msg=audit(1519924845.499:257): item=1 name="/tmp/tmpcontainerid" inode=17729 dev=00:27 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:user_tmp_t:s0 nametype=CREATE cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0
> > type=PROCTITLE msg=audit(1519924845.499:257): proctitle=62617368002D6300736C65657020313B206563686F2074657374203E202F746D702F746D70636F6E7461696E65726964
> > type=CONTAINER_ID msg=audit(1519924845.499:257): contid=123458
> >
> > See: https://github.com/linux-audit/audit-kernel/issues/90
> > See: https://github.com/linux-audit/audit-userspace/issues/51
> > See: https://github.com/linux-audit/audit-testsuite/issues/64
> > See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > Acked-by: Serge Hallyn <serge@hallyn.com>
> > Acked-by: Steve Grubb <sgrubb@redhat.com>
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> 
> Barring one minor nit below,
> 
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> 
> > ---
> >  include/linux/audit.h      |  5 +++++
> >  include/uapi/linux/audit.h |  1 +
> >  kernel/audit.c             | 21 +++++++++++++++++++++
> >  kernel/auditsc.c           |  2 ++
> >  4 files changed, 29 insertions(+)
> >
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 301337776193..43438192ca2a 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -199,6 +199,8 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
> >         return tsk->audit->contid;
> >  }
> >
> > +extern void audit_log_contid(struct audit_context *context, u64 contid);
> > +
> >  extern u32 audit_enabled;
> >  #else /* CONFIG_AUDIT */
> >  static inline int audit_alloc(struct task_struct *task)
> > @@ -265,6 +267,9 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
> >         return AUDIT_CID_UNSET;
> >  }
> >
> > +static inline void audit_log_contid(struct audit_context *context, u64 contid)
> > +{ }
> > +
> >  #define audit_enabled AUDIT_OFF
> >  #endif /* CONFIG_AUDIT */
> >
> > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> > index d475cf3b4d7f..a6383e28b2c8 100644
> > --- a/include/uapi/linux/audit.h
> > +++ b/include/uapi/linux/audit.h
> > @@ -115,6 +115,7 @@
> >  #define AUDIT_REPLACE          1329    /* Replace auditd if this packet unanswerd */
> >  #define AUDIT_KERN_MODULE      1330    /* Kernel Module events */
> >  #define AUDIT_FANOTIFY         1331    /* Fanotify access decision */
> > +#define AUDIT_CONTAINER_ID     1332    /* Container ID */
> >
> >  #define AUDIT_AVC              1400    /* SE Linux avc denial or grant */
> >  #define AUDIT_SELINUX_ERR      1401    /* Internal SE Linux Errors */
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index b5c702abeb42..8cc0e88d7f2a 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -2127,6 +2127,27 @@ void audit_log_session_info(struct audit_buffer *ab)
> >         audit_log_format(ab, "auid=%u ses=%u", auid, sessionid);
> >  }
> >
> > +/*
> > + * audit_log_contid - report container info
> > + * @context: task or local context for record
> > + * @contid: container ID to report
> > + */
> > +void audit_log_contid(struct audit_context *context, u64 contid)
> > +{
> > +       struct audit_buffer *ab;
> > +
> > +       if (!audit_contid_valid(contid))
> > +               return;
> > +       /* Generate AUDIT_CONTAINER_ID record with container ID */
> > +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER_ID);
> > +       if (!ab)
> > +               return;
> > +       audit_log_format(ab, "contid=%llu", contid);
> 
> Just realized that you *might* get a compiler/static checker warning
> since u64 could technically be something else than unsigned long long
> on some arches... maybe this is not case in the kernel, but might be
> safer to cast it to unsigned long long before passing to
> audit_log_format(). Possibly there are similar occurrences in previous
> (later) patches that I didn't (won't) notice.

Ok, since it is guaranteed to be at least 64 bits, a cast won't truncate
it.

> > +       audit_log_end(ab);
> > +       return;
> > +}
> > +EXPORT_SYMBOL(audit_log_contid);
> > +
> >  void audit_log_key(struct audit_buffer *ab, char *key)
> >  {
> >         audit_log_format(ab, " key=");
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 8090eff7868d..a8c8b44b954d 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -1548,6 +1548,8 @@ static void audit_log_exit(void)
> >
> >         audit_log_proctitle();
> >
> > +       audit_log_contid(context, audit_get_contid(current));
> > +
> >         /* Send end of event record to help user space know we are finished */
> >         ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
> >         if (ab)
> 
> Ondrej Mosnacek <omosnace at redhat dot com>

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
