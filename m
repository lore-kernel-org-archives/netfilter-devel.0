From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak81 RFC V1 4/5] audit: use inline function to set
 audit context
Date: Wed, 9 May 2018 08:09:17 -0400
Message-ID: <20180509120917.xz3ggtloq523wqzh@madcap2.tricolour.ca>
References: <cover.1525466167.git.rgb@redhat.com>
 <2f0566af8ccafdaf400a3d002cb4aef9b80e44cf.1525466167.git.rgb@redhat.com>
 <20180509020700.GE7517@eros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NetDev Upstream Mailing List <netdev@vger.kernel.org>,
        Netfilter Devel List <netfilter-devel@vger.kernel.org>,
        Linux Security Module list
        <linux-security-module@vger.kernel.org>,
        Integrity Measurement Architecture
        <linux-integrity@vger.kernel.org>,
        SElinux list <selinux@tycho.nsa.gov>,
        Eric Paris <eparis@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Steve Grubb <sgrubb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Howells <dhowells@redhat.com>
To: "Tobin C. Harding" <tobin@apporbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180509020700.GE7517@eros>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 2018-05-09 12:07, Tobin C. Harding wrote:
> On Fri, May 04, 2018 at 04:54:37PM -0400, Richard Guy Briggs wrote:
> > Recognizing that the audit context is an internal audit value, use an
> > access function to set the audit context pointer for the task
> > rather than reaching directly into the task struct to set it.
> > 
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/audit.h | 8 ++++++++
> >  kernel/auditsc.c      | 6 +++---
> >  kernel/fork.c         | 2 +-
> >  3 files changed, 12 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 93e4c61..dba0d45 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -235,6 +235,10 @@ extern void __audit_inode_child(struct inode *parent,
> >  extern void __audit_seccomp(unsigned long syscall, long signr, int code);
> >  extern void __audit_ptrace(struct task_struct *t);
> >  
> > +static inline void audit_set_context(struct task_struct *task, struct audit_context *ctx)
> > +{
> > +	task->audit_context = ctx;
> > +}
> >  static inline struct audit_context *audit_context(struct task_struct *task)
> >  {
> >  	return task->audit_context;
> > @@ -472,6 +476,10 @@ static inline bool audit_dummy_context(void)
> >  {
> >  	return true;
> >  }
> > +static inline void audit_set_context(struct task_struct *task, struct audit_context *ctx)
> > +{
> > +	task->audit_context = ctx;
> > +}
> 
> If audit_context is an internal audit value why do we set it when
> CONFIG_AUDITSYSCALL is not set?

Agreed, that is unnecessary, but harmless since it won't be called, or
will be called with a value of NULL.  That has been fixed in my dynamic
allocation patchset since not even the audit_task_info struct is
available to assign the value.  It is now an empty function like the
rest.

> Tobin.

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
