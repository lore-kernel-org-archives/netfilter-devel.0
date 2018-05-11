From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak81 RFC V1 1/5] audit: normalize loginuid read access
Date: Fri, 11 May 2018 18:17:52 -0400
Message-ID: <20180511221752.6xtcf2r4rkumrp4u@madcap2.tricolour.ca>
References: <cover.1525466167.git.rgb@redhat.com>
 <611e9c85fca8bcdb24e6fb6da412773663c007b3.1525466167.git.rgb@redhat.com>
 <CAHC9VhQKYt0PC0L65pwFRte1D98R=2tUDGxMVpc8bbJsMncGpw@mail.gmail.com>
 <20180510212114.pefeyw5cuqlmjewp@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux NetDev Upstream Mailing List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Linux Security Module list
        <linux-security-module@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Devel List <netfilter-devel@vger.kernel.org>,
        SElinux list <selinux@tycho.nsa.gov>,
        Integrity Measurement Architecture
        <linux-integrity@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
To: Paul Moore <paul@paul-moore.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180510212114.pefeyw5cuqlmjewp@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 2018-05-10 17:21, Richard Guy Briggs wrote:
> On 2018-05-09 11:13, Paul Moore wrote:
> > On Fri, May 4, 2018 at 4:54 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Recognizing that the loginuid is an internal audit value, use an access
> > > function to retrieve the audit loginuid value for the task rather than
> > > reaching directly into the task struct to get it.
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  kernel/auditsc.c | 16 ++++++++--------
> > >  1 file changed, 8 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > > index 479c031..f3817d0 100644
> > > --- a/kernel/auditsc.c
> > > +++ b/kernel/auditsc.c
> > > @@ -374,7 +374,7 @@ static int audit_field_compare(struct task_struct *tsk,
> > >         case AUDIT_COMPARE_EGID_TO_OBJ_GID:
> > >                 return audit_compare_gid(cred->egid, name, f, ctx);
> > >         case AUDIT_COMPARE_AUID_TO_OBJ_UID:
> > > -               return audit_compare_uid(tsk->loginuid, name, f, ctx);
> > > +               return audit_compare_uid(audit_get_loginuid(tsk), name, f, ctx);
> > >         case AUDIT_COMPARE_SUID_TO_OBJ_UID:
> > >                 return audit_compare_uid(cred->suid, name, f, ctx);
> > >         case AUDIT_COMPARE_SGID_TO_OBJ_GID:
> > > @@ -385,7 +385,7 @@ static int audit_field_compare(struct task_struct *tsk,
> > >                 return audit_compare_gid(cred->fsgid, name, f, ctx);
> > >         /* uid comparisons */
> > >         case AUDIT_COMPARE_UID_TO_AUID:
> > > -               return audit_uid_comparator(cred->uid, f->op, tsk->loginuid);
> > > +               return audit_uid_comparator(cred->uid, f->op, audit_get_loginuid(tsk));
> > >         case AUDIT_COMPARE_UID_TO_EUID:
> > >                 return audit_uid_comparator(cred->uid, f->op, cred->euid);
> > >         case AUDIT_COMPARE_UID_TO_SUID:
> > > @@ -394,11 +394,11 @@ static int audit_field_compare(struct task_struct *tsk,
> > >                 return audit_uid_comparator(cred->uid, f->op, cred->fsuid);
> > >         /* auid comparisons */
> > >         case AUDIT_COMPARE_AUID_TO_EUID:
> > > -               return audit_uid_comparator(tsk->loginuid, f->op, cred->euid);
> > > +               return audit_uid_comparator(audit_get_loginuid(tsk), f->op, cred->euid);
> > >         case AUDIT_COMPARE_AUID_TO_SUID:
> > > -               return audit_uid_comparator(tsk->loginuid, f->op, cred->suid);
> > > +               return audit_uid_comparator(audit_get_loginuid(tsk), f->op, cred->suid);
> > >         case AUDIT_COMPARE_AUID_TO_FSUID:
> > > -               return audit_uid_comparator(tsk->loginuid, f->op, cred->fsuid);
> > > +               return audit_uid_comparator(audit_get_loginuid(tsk), f->op, cred->fsuid);
> > >         /* euid comparisons */
> > >         case AUDIT_COMPARE_EUID_TO_SUID:
> > >                 return audit_uid_comparator(cred->euid, f->op, cred->suid);
> > > @@ -611,7 +611,7 @@ static int audit_filter_rules(struct task_struct *tsk,
> > >                                 result = match_tree_refs(ctx, rule->tree);
> > >                         break;
> > >                 case AUDIT_LOGINUID:
> > > -                       result = audit_uid_comparator(tsk->loginuid, f->op, f->uid);
> > > +                       result = audit_uid_comparator(audit_get_loginuid(tsk), f->op, f->uid);
> > >                         break;
> > >                 case AUDIT_LOGINUID_SET:
> > >                         result = audit_comparator(audit_loginuid_set(tsk), f->op, f->val);
> > > @@ -2287,8 +2287,8 @@ int audit_signal_info(int sig, struct task_struct *t)
> > >             (sig == SIGTERM || sig == SIGHUP ||
> > >              sig == SIGUSR1 || sig == SIGUSR2)) {
> > >                 audit_sig_pid = task_tgid_nr(tsk);
> > > -               if (uid_valid(tsk->loginuid))
> > > -                       audit_sig_uid = tsk->loginuid;
> > > +               if (uid_valid(audit_get_loginuid(tsk)))
> > > +                       audit_sig_uid = audit_get_loginuid(tsk);
> > 
> > I realize this comment is a little silly given the nature of loginuid,
> > but if we are going to abstract away loginuid accesses (which I think
> > is good), we should probably access it once, store it in a local
> > variable, perform the validity check on the local variable, then
> > commit the local variable to audit_sig_uid.  I realize a TOCTOU
> > problem is unlikely here, but with this new layer of abstraction it
> > seems that some additional safety might be a good thing.
> 
> Ok, I'll just assign it to where it is going and check it there, holding
> the audit_ctl_lock the whole time, since it should have been done
> anyways for all of audit_sig_{pid,uid,sid} anyways to get a consistent
> view from the AUDIT_SIGNAL_INFO fetch.

Hmmm, holding audit_ctl_lock won't work because it could sleep trying to
get the lock and the signal info is set in a context where sleeping
isn't permitted.  I'll just use a local var...

> > >                 else
> > >                         audit_sig_uid = uid;
> > >                 security_task_getsecid(tsk, &audit_sig_sid);
> 
> > paul moore
> 
> - RGB

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
