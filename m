Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554B0C10DCE
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 13:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 276FA20724
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 13:11:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ct3E1Jrp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCRNLs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Mar 2020 09:11:48 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:31455 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726821AbgCRNLr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 09:11:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584537106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xlChmMy4SLafuKQTGlyJ3sDvLZdWy+MYwHrLdWFHRXE=;
        b=ct3E1JrpVeU83HhSrYOjoUNJUC/NG0yYojWR/bNPBNEXpsiZ8FPNou+z9sjtjz1vPqu4a4
        cAJz9kHtrFBKtJDbsV2B+6N7doyvIL9a4GvQjKZdU5pMw4v5dliPYGZlYPD21f6x4XyZM/
        n9+kYDtdZnHMQ/fL2bmFoO3NoKlpAyk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-5utA3yAaM5-5gQspvcypOg-1; Wed, 18 Mar 2020 09:11:44 -0400
X-MC-Unique: 5utA3yAaM5-5gQspvcypOg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26F7218A5502;
        Wed, 18 Mar 2020 13:11:43 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E94AC19C6A;
        Wed, 18 Mar 2020 13:11:33 +0000 (UTC)
Date:   Wed, 18 Mar 2020 09:11:28 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, ebiederm@xmission.com, twoerner@redhat.com,
        eparis@parisplace.org, tgraf@infradead.org
Subject: Re: [PATCH ghak25 v3 3/3] audit: add subj creds to NETFILTER_CFG
 record to cover async unregister
Message-ID: <20200318131128.axyddgotzck7cit2@madcap2.tricolour.ca>
References: <cover.1584480281.git.rgb@redhat.com>
 <13ef49b2f111723106d71c1bdeedae09d9b300d8.1584480281.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13ef49b2f111723106d71c1bdeedae09d9b300d8.1584480281.git.rgb@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-03-17 17:30, Richard Guy Briggs wrote:
> Some table unregister actions seem to be initiated by the kernel to
> garbage collect unused tables that are not initiated by any userspace
> actions.  It was found to be necessary to add the subject credentials to
> cover this case to reveal the source of these actions.  A sample record:
> 
>   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat family=bridge entries=0 op=unregister pid=153 uid=root auid=unset tty=(none) ses=unset subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2 exe=(null)

Given the precedent set by bpf unload, I'd really rather drop this patch
that adds subject credentials.

Similarly with ghak25's subject credentials, but they were already
present and that would change an existing record format, so it isn't
quite as justifiable in that case.

> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/auditsc.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index dbb056feccb9..6c233076dfb7 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2557,12 +2557,30 @@ void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
>  		       enum audit_nfcfgop op)
>  {
>  	struct audit_buffer *ab;
> +	const struct cred *cred;
> +	struct tty_struct *tty;
> +	char comm[sizeof(current->comm)];
>  
>  	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_NETFILTER_CFG);
>  	if (!ab)
>  		return;
>  	audit_log_format(ab, "table=%s family=%u entries=%u op=%s",
>  			 name, af, nentries, audit_nfcfgs[op].s);
> +
> +	cred = current_cred();
> +	tty = audit_get_tty();
> +	audit_log_format(ab, " pid=%u uid=%u auid=%u tty=%s ses=%u",
> +			 task_pid_nr(current),
> +			 from_kuid(&init_user_ns, cred->uid),
> +			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
> +			 tty ? tty_name(tty) : "(none)",
> +			 audit_get_sessionid(current));
> +	audit_put_tty(tty);
> +	audit_log_task_context(ab); /* subj= */
> +	audit_log_format(ab, " comm=");
> +	audit_log_untrustedstring(ab, get_task_comm(comm, current));
> +	audit_log_d_path_exe(ab, current->mm); /* exe= */
> +
>  	audit_log_end(ab);
>  }
>  EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
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

