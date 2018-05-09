From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak81 RFC V1 2/5] audit: convert sessionid unset to a
	macro
Date: Tue, 8 May 2018 21:34:15 -0400
Message-ID: <20180509013415.sohoc2jbofdqqw5v@madcap2.tricolour.ca>
References: <cover.1525466167.git.rgb@redhat.com>
	<91fd13c7a66718dc827d299fa101883e5d0a864f.1525466167.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@redhat.com>
To: Linux-Audit Mailing List <linux-audit@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux NetDev Upstream Mailing List <netdev@vger.kernel.org>,
	Netfilter Devel List <netfilter-devel@vger.kernel.org>,
	Linux Security Module list <linux-security-module@vger.kernel.org>,
	Integrity Measurement Architecture <linux-integrity@vger.kernel.org>,
	SElinux list <selinux@tycho.nsa.gov>
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <91fd13c7a66718dc827d299fa101883e5d0a864f.1525466167.git.rgb@redhat.com>
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

On 2018-05-04 16:54, Richard Guy Briggs wrote:
> Use a macro, "AUDIT_SID_UNSET", to replace each instance of
> initialization and comparison to an audit session ID.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>

There's a minor issue with this patch, adding a header include to
init/init_task.c in this patch and removing it from patch 5.  That'll be
in the next revision.

I have dynamic allocation working, so that has a good chance of
appearing  too.

> ---
>  include/linux/audit.h      | 2 +-
>  include/net/xfrm.h         | 2 +-
>  include/uapi/linux/audit.h | 1 +
>  init/init_task.c           | 2 +-
>  kernel/auditsc.c           | 4 ++--
>  5 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 75d5b03..5f86f7c 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -513,7 +513,7 @@ static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
>  }
>  static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
>  {
> -	return -1;
> +	return AUDIT_SID_UNSET;
>  }
>  static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
>  { }
> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> index a872379..fcce8ee 100644
> --- a/include/net/xfrm.h
> +++ b/include/net/xfrm.h
> @@ -751,7 +751,7 @@ static inline void xfrm_audit_helper_usrinfo(bool task_valid,
>  					    audit_get_loginuid(current) :
>  					    INVALID_UID);
>  	const unsigned int ses = task_valid ? audit_get_sessionid(current) :
> -		(unsigned int) -1;
> +		AUDIT_SID_UNSET;
>  
>  	audit_log_format(audit_buf, " auid=%u ses=%u", auid, ses);
>  	audit_log_task_context(audit_buf);
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
> index 3ac6e75..c788f91 100644
> --- a/init/init_task.c
> +++ b/init/init_task.c
> @@ -119,7 +119,7 @@ struct task_struct init_task
>  	.thread_node	= LIST_HEAD_INIT(init_signals.thread_head),
>  #ifdef CONFIG_AUDITSYSCALL
>  	.loginuid	= INVALID_UID,
> -	.sessionid	= (unsigned int)-1,
> +	.sessionid	= AUDIT_SID_UNSET,
>  #endif
>  #ifdef CONFIG_PERF_EVENTS
>  	.perf_event_mutex = __MUTEX_INITIALIZER(init_task.perf_event_mutex),
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index f3817d0..6e3ceb9 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2050,7 +2050,7 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
>  int audit_set_loginuid(kuid_t loginuid)
>  {
>  	struct task_struct *task = current;
> -	unsigned int oldsessionid, sessionid = (unsigned int)-1;
> +	unsigned int oldsessionid, sessionid = AUDIT_SID_UNSET;
>  	kuid_t oldloginuid;
>  	int rc;
>  
> @@ -2064,7 +2064,7 @@ int audit_set_loginuid(kuid_t loginuid)
>  	/* are we setting or clearing? */
>  	if (uid_valid(loginuid)) {
>  		sessionid = (unsigned int)atomic_inc_return(&session_id);
> -		if (unlikely(sessionid == (unsigned int)-1))
> +		if (unlikely(sessionid == AUDIT_SID_UNSET))
>  			sessionid = (unsigned int)atomic_inc_return(&session_id);
>  	}
>  
> -- 
> 1.8.3.1
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
