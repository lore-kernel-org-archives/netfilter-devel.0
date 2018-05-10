From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak81 RFC V1 5/5] audit: collect audit task parameters
Date: Thu, 10 May 2018 17:26:57 -0400
Message-ID: <20180510212657.qnwm3jeqjjke77yz@madcap2.tricolour.ca>
References: <cover.1525466167.git.rgb@redhat.com>
	<5b0e0eef72b5137830f9f6c67908e5252dbf48f5.1525466167.git.rgb@redhat.com>
	<CAHC9VhRugVt3g=ADwKKWLYa2NXVoL8HLRKtXsut3P2LPd3fPuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Linux NetDev Upstream Mailing List <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
	Linux Security Module list <linux-security-module@vger.kernel.org>,
	Linux-Audit Mailing List <linux-audit@redhat.com>,
	Netfilter Devel List <netfilter-devel@vger.kernel.org>,
	SElinux list <selinux@tycho.nsa.gov>,
	Integrity Measurement Architecture <linux-integrity@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>
To: Paul Moore <paul@paul-moore.com>
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHC9VhRugVt3g=ADwKKWLYa2NXVoL8HLRKtXsut3P2LPd3fPuw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
List-Id: netfilter-devel.vger.kernel.org

On 2018-05-09 11:46, Paul Moore wrote:
> On Fri, May 4, 2018 at 4:54 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > The audit-related parameters in struct task_struct should ideally be
> > collected together and accessed through a standard audit API.
> >
> > Collect the existing loginuid, sessionid and audit_context together in a
> > new struct audit_task_info pointer called "audit" in struct task_struct.
> >
> > Use kmem_cache to manage this pool of memory.
> > Un-inline audit_free() to be able to always recover that memory.
> >
> > See: https://github.com/linux-audit/audit-kernel/issues/81
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  MAINTAINERS                |  2 +-
> >  include/linux/audit.h      |  8 ++++----
> >  include/linux/audit_task.h | 31 +++++++++++++++++++++++++++++++
> >  include/linux/sched.h      |  6 ++----
> >  init/init_task.c           |  8 ++++++--
> >  kernel/auditsc.c           |  4 ++--
> >  6 files changed, 46 insertions(+), 13 deletions(-)
> >  create mode 100644 include/linux/audit_task.h
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 0a1410d..8c7992d 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -2510,7 +2510,7 @@ L:        linux-audit@redhat.com (moderated for non-subscribers)
> >  W:     https://github.com/linux-audit
> >  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/audit.git
> >  S:     Supported
> > -F:     include/linux/audit.h
> > +F:     include/linux/audit*.h
> >  F:     include/uapi/linux/audit.h
> >  F:     kernel/audit*
> >
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index dba0d45..1324969 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -237,11 +237,11 @@ extern void __audit_inode_child(struct inode *parent,
> >
> >  static inline void audit_set_context(struct task_struct *task, struct audit_context *ctx)
> >  {
> > -       task->audit_context = ctx;
> > +       task->audit.ctx = ctx;
> >  }
> >  static inline struct audit_context *audit_context(struct task_struct *task)
> >  {
> > -       return task->audit_context;
> > +       return task->audit.ctx;
> >  }
> >  static inline bool audit_dummy_context(void)
> >  {
> > @@ -330,12 +330,12 @@ extern int auditsc_get_stamp(struct audit_context *ctx,
> >
> >  static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
> >  {
> > -       return tsk->loginuid;
> > +       return tsk->audit.loginuid;
> >  }
> >
> >  static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
> >  {
> > -       return tsk->sessionid;
> > +       return tsk->audit.sessionid;
> >  }
> >
> >  extern void __audit_ipc_obj(struct kern_ipc_perm *ipcp);
> > diff --git a/include/linux/audit_task.h b/include/linux/audit_task.h
> > new file mode 100644
> > index 0000000..d4b3a20
> > --- /dev/null
> > +++ b/include/linux/audit_task.h
> > @@ -0,0 +1,31 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/* audit_task.h -- definition of audit_task_info structure
> > + *
> > + * Copyright 2018 Red Hat Inc., Raleigh, North Carolina.
> > + * All Rights Reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * Written by Richard Guy Briggs <rgb@redhat.com>
> > + *
> > + */
> > +
> > +#ifndef _LINUX_AUDIT_TASK_H_
> > +#define _LINUX_AUDIT_TASK_H_
> > +
> > +struct audit_context;
> > +struct audit_task_info {
> > +       kuid_t                  loginuid;
> > +       unsigned int            sessionid;
> > +       struct audit_context    *ctx;
> > +};
> > +
> > +#endif
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index b3d697f..b58eca0 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -27,9 +27,9 @@
> >  #include <linux/signal_types.h>
> >  #include <linux/mm_types_task.h>
> >  #include <linux/task_io_accounting.h>
> > +#include <linux/audit_task.h>
> >
> >  /* task_struct member predeclarations (sorted alphabetically): */
> > -struct audit_context;
> >  struct backing_dev_info;
> >  struct bio_list;
> >  struct blk_plug;
> > @@ -832,10 +832,8 @@ struct task_struct {
> >
> >         struct callback_head            *task_works;
> >
> > -       struct audit_context            *audit_context;
> >  #ifdef CONFIG_AUDITSYSCALL
> > -       kuid_t                          loginuid;
> > -       unsigned int                    sessionid;
> > +       struct audit_task_info          audit;
> >  #endif
> 
> Considering that the audit_context pointer is now in the
> audit_task_info struct, should the audit_task_info struct be placed
> outside the CONFIG_AUDITSYSCALL protections?  Or rather, shouldn't the
> CONFIG_AUDITSYSCALL protections be moved inside audit_task_info or
> removed entirely?

Well, I wondered about that anyways.  audit_context is only meaningful
in CONFIG_AUDIT_SYSCALL, and loginuid and sessionid were already there,
so the whole thing should be inside, but given that CONFIG_AUDIT_SYSCALL
is forced on when CONFIG_AUDIT is set I don't see that it matters.
Perhaps CONFIG_AUDIT_SYSCALL should be ripped out completely and the
code flattenned to the CONFIG_AUDIT case.

I see your point though, moving CONFIG_AUDIT_SYSCALL protections to
within the audit_task_info struct definition makes more sense than this
above.

> > diff --git a/init/init_task.c b/init/init_task.c
> > index c788f91..d33260d 100644
> > --- a/init/init_task.c
> > +++ b/init/init_task.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/init.h>
> >  #include <linux/fs.h>
> >  #include <linux/mm.h>
> > +#include <linux/audit.h>
> >
> >  #include <asm/pgtable.h>
> >  #include <linux/uaccess.h>
> > @@ -118,8 +119,11 @@ struct task_struct init_task
> >         .thread_group   = LIST_HEAD_INIT(init_task.thread_group),
> >         .thread_node    = LIST_HEAD_INIT(init_signals.thread_head),
> >  #ifdef CONFIG_AUDITSYSCALL
> > -       .loginuid       = INVALID_UID,
> > -       .sessionid      = AUDIT_SID_UNSET,
> > +       .audit          = {
> > +               .loginuid       = INVALID_UID,
> > +               .sessionid      = AUDIT_SID_UNSET,
> > +               .ctx            = NULL,
> > +       },
> >  #endif
> >  #ifdef CONFIG_PERF_EVENTS
> >         .perf_event_mutex = __MUTEX_INITIALIZER(init_task.perf_event_mutex),
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index f294e4a..b5d8bff 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -2068,8 +2068,8 @@ int audit_set_loginuid(kuid_t loginuid)
> >                         sessionid = (unsigned int)atomic_inc_return(&session_id);
> >         }
> >
> > -       task->sessionid = sessionid;
> > -       task->loginuid = loginuid;
> > +       task->audit.sessionid = sessionid;
> > +       task->audit.loginuid = loginuid;
> >  out:
> >         audit_log_set_loginuid(oldloginuid, loginuid, oldsessionid, sessionid, rc);
> >         return rc;
> > --
> > 1.8.3.1
> 
> -- 
> paul moore
> www.paul-moore.com

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
