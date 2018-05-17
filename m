From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak81 V3 2/3] audit: normalize loginuid read access
Date: Thu, 17 May 2018 19:02:39 -0400
Message-ID: <CAHC9VhTU9q2c_3jCg5JLmuQbvFO03xLDiTi5NADDsadRv+p2Vw@mail.gmail.com>
References: <cover.1526430313.git.rgb@redhat.com> <a50926963f4527a5273e0688275d1e9361e8d02e.1526430313.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
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
        Steve Grubb <sgrubb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Howells <dhowells@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a50926963f4527a5273e0688275d1e9361e8d02e.1526430313.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, May 16, 2018 at 7:55 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> Recognizing that the loginuid is an internal audit value, use an access
> function to retrieve the audit loginuid value for the task rather than
> reaching directly into the task struct to get it.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/auditsc.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)

Also merged into audit/next.

> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index f3d3dc6..ef3e189 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -374,7 +374,7 @@ static int audit_field_compare(struct task_struct *tsk,
>         case AUDIT_COMPARE_EGID_TO_OBJ_GID:
>                 return audit_compare_gid(cred->egid, name, f, ctx);
>         case AUDIT_COMPARE_AUID_TO_OBJ_UID:
> -               return audit_compare_uid(tsk->loginuid, name, f, ctx);
> +               return audit_compare_uid(audit_get_loginuid(tsk), name, f, ctx);
>         case AUDIT_COMPARE_SUID_TO_OBJ_UID:
>                 return audit_compare_uid(cred->suid, name, f, ctx);
>         case AUDIT_COMPARE_SGID_TO_OBJ_GID:
> @@ -385,7 +385,8 @@ static int audit_field_compare(struct task_struct *tsk,
>                 return audit_compare_gid(cred->fsgid, name, f, ctx);
>         /* uid comparisons */
>         case AUDIT_COMPARE_UID_TO_AUID:
> -               return audit_uid_comparator(cred->uid, f->op, tsk->loginuid);
> +               return audit_uid_comparator(cred->uid, f->op,
> +                                           audit_get_loginuid(tsk));
>         case AUDIT_COMPARE_UID_TO_EUID:
>                 return audit_uid_comparator(cred->uid, f->op, cred->euid);
>         case AUDIT_COMPARE_UID_TO_SUID:
> @@ -394,11 +395,14 @@ static int audit_field_compare(struct task_struct *tsk,
>                 return audit_uid_comparator(cred->uid, f->op, cred->fsuid);
>         /* auid comparisons */
>         case AUDIT_COMPARE_AUID_TO_EUID:
> -               return audit_uid_comparator(tsk->loginuid, f->op, cred->euid);
> +               return audit_uid_comparator(audit_get_loginuid(tsk), f->op,
> +                                           cred->euid);
>         case AUDIT_COMPARE_AUID_TO_SUID:
> -               return audit_uid_comparator(tsk->loginuid, f->op, cred->suid);
> +               return audit_uid_comparator(audit_get_loginuid(tsk), f->op,
> +                                           cred->suid);
>         case AUDIT_COMPARE_AUID_TO_FSUID:
> -               return audit_uid_comparator(tsk->loginuid, f->op, cred->fsuid);
> +               return audit_uid_comparator(audit_get_loginuid(tsk), f->op,
> +                                           cred->fsuid);
>         /* euid comparisons */
>         case AUDIT_COMPARE_EUID_TO_SUID:
>                 return audit_uid_comparator(cred->euid, f->op, cred->suid);
> @@ -611,7 +615,8 @@ static int audit_filter_rules(struct task_struct *tsk,
>                                 result = match_tree_refs(ctx, rule->tree);
>                         break;
>                 case AUDIT_LOGINUID:
> -                       result = audit_uid_comparator(tsk->loginuid, f->op, f->uid);
> +                       result = audit_uid_comparator(audit_get_loginuid(tsk),
> +                                                     f->op, f->uid);
>                         break;
>                 case AUDIT_LOGINUID_SET:
>                         result = audit_comparator(audit_loginuid_set(tsk), f->op, f->val);
> @@ -2278,14 +2283,15 @@ int audit_signal_info(int sig, struct task_struct *t)
>  {
>         struct audit_aux_data_pids *axp;
>         struct audit_context *ctx = audit_context();
> -       kuid_t uid = current_uid(), t_uid = task_uid(t);
> +       kuid_t uid = current_uid(), auid, t_uid = task_uid(t);
>
>         if (auditd_test_task(t) &&
>             (sig == SIGTERM || sig == SIGHUP ||
>              sig == SIGUSR1 || sig == SIGUSR2)) {
>                 audit_sig_pid = task_tgid_nr(current);
> -               if (uid_valid(current->loginuid))
> -                       audit_sig_uid = current->loginuid;
> +               auid = audit_get_loginuid(current);
> +               if (uid_valid(auid))
> +                       audit_sig_uid = auid;
>                 else
>                         audit_sig_uid = uid;
>                 security_task_getsecid(current, &audit_sig_sid);
> --
> 1.8.3.1
>



-- 
paul moore
www.paul-moore.com
