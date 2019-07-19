Return-Path: <SRS0=2jko=VQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61E6C76196
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BF462186A
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbfGSQDy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 12:03:54 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:53669 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfGSQDx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 12:03:53 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hoVMN-000653-Rm; Fri, 19 Jul 2019 10:03:51 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hoVMM-0002r7-VQ; Fri, 19 Jul 2019 10:03:51 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, nhorman@tuxdriver.com
References: <cover.1554732921.git.rgb@redhat.com>
        <cover.1554732921.git.rgb@redhat.com>
        <846df5e5bf5a49094fede082a2ace135ab6f5772.1554732921.git.rgb@redhat.com>
Date:   Fri, 19 Jul 2019 11:03:35 -0500
In-Reply-To: <846df5e5bf5a49094fede082a2ace135ab6f5772.1554732921.git.rgb@redhat.com>
        (Richard Guy Briggs's message of "Mon, 8 Apr 2019 23:39:10 -0400")
Message-ID: <87d0i6dnag.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hoVMM-0002r7-VQ;;;mid=<87d0i6dnag.fsf@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+ZObZxtYj3Ingkk2j6NVLV9B+vGA99pls=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH ghak90 V6 03/10] audit: read container ID of a process
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> writes:

> Add support for reading the audit container identifier from the proc
> filesystem.
>
> This is a read from the proc entry of the form
> /proc/PID/audit_containerid where PID is the process ID of the task
> whose audit container identifier is sought.
>
> The read expects up to a u64 value (unset: 18446744073709551615).
>
> This read requires CAP_AUDIT_CONTROL.

This scares me.    As this seems to make it easy to reuse an audit
containerid for non-audit purporses.

I would think it would be safer and easier to poke audit and ask it to
log a message with your audit container id.

Eric


> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  fs/proc/base.c | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 43fd0c4b87de..acc70239d0cb 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1211,7 +1211,7 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
>  };
>  
>  #ifdef CONFIG_AUDIT
> -#define TMPBUFLEN 11
> +#define TMPBUFLEN 21
>  static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
>  				  size_t count, loff_t *ppos)
>  {
> @@ -1295,6 +1295,24 @@ static ssize_t proc_sessionid_read(struct file * file, char __user * buf,
>  	.llseek		= generic_file_llseek,
>  };
>  
> +static ssize_t proc_contid_read(struct file *file, char __user *buf,
> +				  size_t count, loff_t *ppos)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct task_struct *task = get_proc_task(inode);
> +	ssize_t length;
> +	char tmpbuf[TMPBUFLEN];
> +
> +	if (!task)
> +		return -ESRCH;
> +	/* if we don't have caps, reject */
> +	if (!capable(CAP_AUDIT_CONTROL))
> +		return -EPERM;
> +	length = scnprintf(tmpbuf, TMPBUFLEN, "%llu", audit_get_contid(task));
> +	put_task_struct(task);
> +	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
> +}
> +
>  static ssize_t proc_contid_write(struct file *file, const char __user *buf,
>  				   size_t count, loff_t *ppos)
>  {
> @@ -1325,6 +1343,7 @@ static ssize_t proc_contid_write(struct file *file, const char __user *buf,
>  }
>  
>  static const struct file_operations proc_contid_operations = {
> +	.read		= proc_contid_read,
>  	.write		= proc_contid_write,
>  	.llseek		= generic_file_llseek,
>  };
> @@ -3067,7 +3086,7 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
>  #ifdef CONFIG_AUDIT
>  	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
>  	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> -	REG("audit_containerid", S_IWUSR, proc_contid_operations),
> +	REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> @@ -3466,7 +3485,7 @@ static int proc_tid_comm_permission(struct inode *inode, int mask)
>  #ifdef CONFIG_AUDIT
>  	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
>  	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> -	REG("audit_containerid", S_IWUSR, proc_contid_operations),
> +	REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
