From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak81 RFC V2 2/5] audit: convert sessionid unset to a macro
Date: Mon, 14 May 2018 16:15:26 -0400
Message-ID: <CAHC9VhSfrmQ=-LhC-1QZGkMTUf2u971tE0k7sg5Tebx=2tRzpA@mail.gmail.com>
References: <cover.1526173613.git.rgb@redhat.com> <d9b6713caf339af2346eacc1324280b180a519e1.1526173613.git.rgb@redhat.com>
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
In-Reply-To: <d9b6713caf339af2346eacc1324280b180a519e1.1526173613.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, May 12, 2018 at 9:58 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> Use a macro, "AUDIT_SID_UNSET", to replace each instance of
> initialization and comparison to an audit session ID.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h      | 2 +-
>  include/net/xfrm.h         | 2 +-
>  include/uapi/linux/audit.h | 1 +
>  init/init_task.c           | 3 ++-
>  kernel/auditsc.c           | 4 ++--
>  5 files changed, 7 insertions(+), 5 deletions(-)

Merged, thanks.

> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 75d5b03..5f86f7c 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -513,7 +513,7 @@ static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
>  }
>  static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
>  {
> -       return -1;
> +       return AUDIT_SID_UNSET;
>  }
>  static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
>  { }
> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> index a872379..fcce8ee 100644
> --- a/include/net/xfrm.h
> +++ b/include/net/xfrm.h
> @@ -751,7 +751,7 @@ static inline void xfrm_audit_helper_usrinfo(bool task_valid,
>                                             audit_get_loginuid(current) :
>                                             INVALID_UID);
>         const unsigned int ses = task_valid ? audit_get_sessionid(current) :
> -               (unsigned int) -1;
> +               AUDIT_SID_UNSET;
>
>         audit_log_format(audit_buf, " auid=%u ses=%u", auid, ses);
>         audit_log_task_context(audit_buf);
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index 4e61a9e..04f9bd2 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -465,6 +465,7 @@ struct audit_tty_status {
>  };
>
>  #define AUDIT_UID_UNSET (unsigned int)-1
> +#define AUDIT_SID_UNSET ((unsigned int)-1)
>
>  /* audit_rule_data supports filter rules with both integer and string
>   * fields.  It corresponds with AUDIT_ADD_RULE, AUDIT_DEL_RULE and
> diff --git a/init/init_task.c b/init/init_task.c
> index 3ac6e75..74f60ba 100644
> --- a/init/init_task.c
> +++ b/init/init_task.c
> @@ -9,6 +9,7 @@
>  #include <linux/init.h>
>  #include <linux/fs.h>
>  #include <linux/mm.h>
> +#include <linux/audit.h>
>
>  #include <asm/pgtable.h>
>  #include <linux/uaccess.h>
> @@ -119,7 +120,7 @@ struct task_struct init_task
>         .thread_node    = LIST_HEAD_INIT(init_signals.thread_head),
>  #ifdef CONFIG_AUDITSYSCALL
>         .loginuid       = INVALID_UID,
> -       .sessionid      = (unsigned int)-1,
> +       .sessionid      = AUDIT_SID_UNSET,
>  #endif
>  #ifdef CONFIG_PERF_EVENTS
>         .perf_event_mutex = __MUTEX_INITIALIZER(init_task.perf_event_mutex),
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 0d4e269..e157595 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2050,7 +2050,7 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
>  int audit_set_loginuid(kuid_t loginuid)
>  {
>         struct task_struct *task = current;
> -       unsigned int oldsessionid, sessionid = (unsigned int)-1;
> +       unsigned int oldsessionid, sessionid = AUDIT_SID_UNSET;
>         kuid_t oldloginuid;
>         int rc;
>
> @@ -2064,7 +2064,7 @@ int audit_set_loginuid(kuid_t loginuid)
>         /* are we setting or clearing? */
>         if (uid_valid(loginuid)) {
>                 sessionid = (unsigned int)atomic_inc_return(&session_id);
> -               if (unlikely(sessionid == (unsigned int)-1))
> +               if (unlikely(sessionid == AUDIT_SID_UNSET))
>                         sessionid = (unsigned int)atomic_inc_return(&session_id);
>         }
>
> --
> 1.8.3.1
>



-- 
paul moore
www.paul-moore.com
