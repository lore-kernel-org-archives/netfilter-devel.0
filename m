Return-Path: <SRS0=7yxH=7C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A965AC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 16:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8921520671
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 16:55:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YtPIdvlx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgETQza (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 May 2020 12:55:30 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26304 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbgETQz2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 May 2020 12:55:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589993726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zwa0MajcbgkU5nITVNmkMZzy8QDk2TJnCFI7ljAY5W0=;
        b=YtPIdvlxQcsKpgvyke6pR2dlAE1A+rxhulS/M7ZBrBpi1YmZwtO6tGqzBWgA6Ytdo5Sof6
        t9LS6gyLlZdbfFxVZb+uSH6TzLvrjAcgPI39IRzeLenLI9EdyoKClK/YiS3oEogKa7Z7sL
        gj/LEhBYS09SWvfT1CRwJgy/sSkVtH4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-7V8LUDUJOuyvUyRsJiWNBg-1; Wed, 20 May 2020 12:55:22 -0400
X-MC-Unique: 7V8LUDUJOuyvUyRsJiWNBg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC61E835B41;
        Wed, 20 May 2020 16:55:20 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E64C60554;
        Wed, 20 May 2020 16:55:13 +0000 (UTC)
Date:   Wed, 20 May 2020 12:55:10 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, twoerner@redhat.com, eparis@parisplace.org,
        tgraf@infradead.org
Subject: Re: [PATCH ghak25 v6] audit: add subj creds to NETFILTER_CFG record
 to cover async unregister
Message-ID: <20200520165510.4l4q47vq6fyx7hh6@madcap2.tricolour.ca>
References: <a585b9933896bc542347d8f3f26b08005344dd84.1589920939.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a585b9933896bc542347d8f3f26b08005344dd84.1589920939.git.rgb@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-05-20 12:51, Richard Guy Briggs wrote:
> Some table unregister actions seem to be initiated by the kernel to
> garbage collect unused tables that are not initiated by any userspace
> actions.  It was found to be necessary to add the subject credentials to
> cover this case to reveal the source of these actions.  A sample record:
> 
> The uid, auid, tty, ses and exe fields have not been included since they
> are in the SYSCALL record and contain nothing useful in the non-user
> context.
> 
>   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat family=bridge entries=0 op=unregister pid=153 subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>

Self-NACK.  I forgot to remove cred and tty declarations.

> ---
> Changelog:
> v6
> - remove uid, auid fields as duplicates or unset
> 
> v5
> - rebase on upstreamed ghak28 on audit/next v5.7-rc1
> - remove tty, ses and exe fields as duplicates or unset
> - drop upstreamed patches 1&2 from set
> 
> v4
> - rebase on audit/next v5.7-rc1
> - fix checkpatch.pl errors/warnings in 1/3 and 2/3
> 
> v3
> - rebase on v5.6-rc1 audit/next
> - change audit_nf_cfg to audit_log_nfcfg
> - squash 2,3,4,5 to 1 and update patch descriptions
> - add subject credentials to cover garbage collecting kernel threads
> 
> v2
> - Rebase (audit/next 5.5-rc1) to get audit_context access and ebt_register_table ret code
> - Split x_tables and ebtables updates
> - Check audit_dummy_context
> - Store struct audit_nfcfg params in audit_context, abstract to audit_nf_cfg() call
> - Restore back to "table, family, entries" from "family, table, entries"
> - Log unregistration of tables
> - Add "op=" at the end of the AUDIT_NETFILTER_CFG record
> - Defer nsid patch (ghak79) to once nsid patchset upstreamed (ghak32)
> - Add ghak refs
> - Ditch NETFILTER_CFGSOLO record
> 
>  kernel/auditsc.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index cfe3486e5f31..e646055adb0b 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2557,12 +2557,21 @@ void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
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
> +	audit_log_format(ab, " pid=%u", task_pid_nr(current));
> +	audit_log_task_context(ab); /* subj= */
> +	audit_log_format(ab, " comm=");
> +	audit_log_untrustedstring(ab, get_task_comm(comm, current));
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

