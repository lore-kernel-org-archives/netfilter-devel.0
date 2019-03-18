Return-Path: <SRS0=5Ubq=RV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 211FCC10F00
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 19:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F03EC20828
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 19:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfCRTez (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 15:34:55 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59107 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfCRTez (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 15:34:55 -0400
Received: from cpe-2606-a000-111b-405a-9816-2c85-c514-8f7a.dyn6.twc.com ([2606:a000:111b:405a:9816:2c85:c514:8f7a] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1h5y21-0000im-U6; Mon, 18 Mar 2019 15:34:49 -0400
Date:   Mon, 18 Mar 2019 15:34:18 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com
Subject: Re: [PATCH ghak90 V5 06/10] audit: add support for non-syscall
 auxiliary records
Message-ID: <20190318193417.GC4111@hmswarspite.think-freely.org>
References: <cover.1552665316.git.rgb@redhat.com>
 <700e4313571f86cc0cdcb7310fbe060f02c7c2db.1552665316.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <700e4313571f86cc0cdcb7310fbe060f02c7c2db.1552665316.git.rgb@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 15, 2019 at 02:29:54PM -0400, Richard Guy Briggs wrote:
> Standalone audit records have the timestamp and serial number generated
> on the fly and as such are unique, making them standalone.  This new
> function audit_alloc_local() generates a local audit context that will
> be used only for a standalone record and its auxiliary record(s).  The
> context is discarded immediately after the local associated records are
> produced.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> ---
>  include/linux/audit.h |  8 ++++++++
>  kernel/audit.h        |  1 +
>  kernel/auditsc.c      | 35 ++++++++++++++++++++++++++++++-----
>  3 files changed, 39 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index ebd6625ca80e..6db5aba7cc01 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -285,6 +285,8 @@ static inline void audit_log_contid(struct audit_context *context, u64 contid)
>  
>  /* These are defined in auditsc.c */
>  				/* Public API */
> +extern struct audit_context *audit_alloc_local(gfp_t gfpflags);
> +extern void audit_free_context(struct audit_context *context);
>  extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
>  				  unsigned long a2, unsigned long a3);
>  extern void __audit_syscall_exit(int ret_success, long ret_value);
> @@ -512,6 +514,12 @@ static inline void audit_fanotify(unsigned int response)
>  extern int audit_n_rules;
>  extern int audit_signals;
>  #else /* CONFIG_AUDITSYSCALL */
> +static inline struct audit_context *audit_alloc_local(gfp_t gfpflags)
> +{
> +	return NULL;
> +}
> +static inline void audit_free_context(struct audit_context *context)
> +{ }
>  static inline void audit_syscall_entry(int major, unsigned long a0,
>  				       unsigned long a1, unsigned long a2,
>  				       unsigned long a3)
> diff --git a/kernel/audit.h b/kernel/audit.h
> index c5ac6436317e..2a1a8b8a8019 100644
> --- a/kernel/audit.h
> +++ b/kernel/audit.h
> @@ -111,6 +111,7 @@ struct audit_proctitle {
>  struct audit_context {
>  	int		    dummy;	/* must be the first element */
>  	int		    in_syscall;	/* 1 if task is in a syscall */
> +	bool		    local;	/* local context needed */
>  	enum audit_state    state, current_state;
>  	unsigned int	    serial;     /* serial number for record */
>  	int		    major;      /* syscall number */
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index f04e115df5dc..aa5d13b4fbbb 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -872,11 +872,13 @@ static inline void audit_free_aux(struct audit_context *context)
>  	}
>  }
>  
> -static inline struct audit_context *audit_alloc_context(enum audit_state state)
> +static inline struct audit_context *audit_alloc_context(enum audit_state state,
> +							gfp_t gfpflags)
>  {
>  	struct audit_context *context;
>  
> -	context = kzalloc(sizeof(*context), GFP_KERNEL);
> +	/* We can be called in atomic context via audit_tg() */
> +	context = kzalloc(sizeof(*context), gfpflags);
>  	if (!context)
>  		return NULL;
>  	context->state = state;
> @@ -912,7 +914,8 @@ int audit_alloc_syscall(struct task_struct *tsk)
>  		return 0;
>  	}
>  
> -	if (!(context = audit_alloc_context(state))) {
> +	context = audit_alloc_context(state, GFP_KERNEL);
> +	if (!context) {
>  		kfree(key);
>  		audit_log_lost("out of memory in audit_alloc_syscall");
>  		return -ENOMEM;
> @@ -924,8 +927,29 @@ int audit_alloc_syscall(struct task_struct *tsk)
>  	return 0;
>  }
>  
> -static inline void audit_free_context(struct audit_context *context)
> +struct audit_context *audit_alloc_local(gfp_t gfpflags)
>  {
> +	struct audit_context *context = NULL;
> +
> +	if (!audit_ever_enabled)
> +		goto out; /* Return if not auditing. */
> +	context = audit_alloc_context(AUDIT_RECORD_CONTEXT, gfpflags);
> +	if (!context) {
> +		audit_log_lost("out of memory in audit_alloc_local");
> +		goto out;
> +	}
> +	context->serial = audit_serial();
> +	ktime_get_coarse_real_ts64(&context->ctime);
> +	context->local = true;
> +out:
> +	return context;
> +}
> +EXPORT_SYMBOL(audit_alloc_local);
> +
> +void audit_free_context(struct audit_context *context)
> +{
> +	if (!context)
> +		return;
>  	audit_free_names(context);
>  	unroll_tree_refs(context, NULL, 0);
>  	free_tree_refs(context);
> @@ -935,6 +959,7 @@ static inline void audit_free_context(struct audit_context *context)
>  	audit_proctitle_free(context);
>  	kfree(context);
>  }
> +EXPORT_SYMBOL(audit_free_context);
>  
>  static int audit_log_pid_context(struct audit_context *context, pid_t pid,
>  				 kuid_t auid, kuid_t uid, unsigned int sessionid,
> @@ -2163,7 +2188,7 @@ void __audit_inode_child(struct inode *parent,
>  int auditsc_get_stamp(struct audit_context *ctx,
>  		       struct timespec64 *t, unsigned int *serial)
>  {
> -	if (!ctx->in_syscall)
> +	if (!ctx->in_syscall && !ctx->local)
>  		return 0;
>  	if (!ctx->serial)
>  		ctx->serial = audit_serial();
> -- 
> 1.8.3.1
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
