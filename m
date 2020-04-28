Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04BAC83004
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 22:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C6522072A
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 22:26:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="WRrM+aH1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgD1W0G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 18:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726042AbgD1W0F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 18:26:05 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABE4C03C1AC
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 15:26:05 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id a8so270823edv.2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 15:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o5g+0q4i4NXpQKVni4wkZ3eUg4bn6IsxJhsN8wcx+ak=;
        b=WRrM+aH1PLLyNr7wFOi3+bCocCitOvbc0DiM8A52L04uR+hAWCFOQELO+cLK3d2ARe
         3fnoaqKW2ZykE2NgKVl3lLwgtBpGf/qrj0xtHF5bdG9kyFPB32X9v3qdNMSWuoDH4eAd
         P/qeU+BVQ30YADghRTV6I4/0jQ2AHy4p6xZ6OG4UmNFAMI5fsxzQASmA7052i7CKJa5G
         BQj6HQfbLpIFikiQT9JlifLO5YOTILZpQLGoWS7Sjzdz2TahCbEQM2QNeoNZvj/ot+lP
         hC6YKzmpd/k2trvrC1FyIOeiLG3HskoHMJPIUfCDKaV8xQYX01n1MGcWYRqFYJcIBTRD
         Dizw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o5g+0q4i4NXpQKVni4wkZ3eUg4bn6IsxJhsN8wcx+ak=;
        b=BzQyyOaR7KYA2Cwyf7S1AzZUwwxVWfYy/M3QHoZ0r/Y1DLrH7T10qij7J1c174chtY
         BDBipdAhhUcRQ2Nc3DvoXo9pXB1De5DCnBg6YQo6yWsF8Yes2JnvfASVuGxaHdAYUpZv
         G6WbB5EKYvZb29UNWdCbKoJSX2YYSXG5SV5mqoeXq+P1Wlw8JEUqmGMurPs050EUpZrK
         NuFQcMK0mYycQgzayoQ7m1hngcZXiY9x/e6OOCMALBrEq0qa+Rn7IhHXFQO5SmviN7Nq
         NksAb5SfTyH6ldkQ+KLqT+5jF/WgzDOh4KGQ4MUoa3t6WPJ+z9P7KrhNe48rb4XzQmrl
         +nZA==
X-Gm-Message-State: AGi0PuaxCgEmZCX08DYhzK1WPo1hInM8aG1TSmSc2AW32Gw+NP9J8w1h
        wCbgL1mM3cM5wdh77z2Eh2UX09wlNIu1JoIRr2hz
X-Google-Smtp-Source: APiQypJdnPD8twnR2I4zFq1PmUsD3icty6Rtrg9MeAig7VH1vYYfF/k1ac08nAwqqrcf6W3VkkknzI+1g9Lre2mmLyY=
X-Received: by 2002:aa7:cd59:: with SMTP id v25mr22787222edw.135.1588112764208;
 Tue, 28 Apr 2020 15:26:04 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587500467.git.rgb@redhat.com> <b8ba40255978a73ea15e3859d5c945ecd5fede8e.1587500467.git.rgb@redhat.com>
In-Reply-To: <b8ba40255978a73ea15e3859d5c945ecd5fede8e.1587500467.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 28 Apr 2020 18:25:53 -0400
Message-ID: <CAHC9VhR9sNB58A8uQ4FNgAXOgVJ3RaWF4y5MAo=3mcTojaym0Q@mail.gmail.com>
Subject: Re: [PATCH ghak25 v4 3/3] audit: add subj creds to NETFILTER_CFG
 record to cover async unregister
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, ebiederm@xmission.com,
        tgraf@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 22, 2020 at 5:40 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Some table unregister actions seem to be initiated by the kernel to
> garbage collect unused tables that are not initiated by any userspace
> actions.  It was found to be necessary to add the subject credentials to
> cover this case to reveal the source of these actions.  A sample record:
>
>   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat family=bridge entries=0 op=unregister pid=153 uid=root auid=unset tty=(none) ses=unset subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2 exe=(null)

[I'm going to comment up here instead of in the code because it is a
bit easier for everyone to see what the actual impact might be on the
records.]

Steve wants subject info in this case, okay, but let's try to trim out
some of the fields which simply don't make sense in this record; I'm
thinking of fields that are unset/empty in the kernel case and are
duplicates of other records in the userspace/syscall case.  I think
that means we can drop "tty", "ses", "comm", and "exe" ... yes?

While "auid" is a potential target for removal based on the
dup-or-unset criteria, I think it falls under Steve's request for
subject info here, even if it is garbage in this case.

> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/auditsc.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index d281c18d1771..d7a45b181be0 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2557,12 +2557,30 @@ void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
>                        enum audit_nfcfgop op)
>  {
>         struct audit_buffer *ab;
> +       const struct cred *cred;
> +       struct tty_struct *tty;
> +       char comm[sizeof(current->comm)];
>
>         ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_NETFILTER_CFG);
>         if (!ab)
>                 return;
>         audit_log_format(ab, "table=%s family=%u entries=%u op=%s",
>                          name, af, nentries, audit_nfcfgs[op].s);
> +
> +       cred = current_cred();
> +       tty = audit_get_tty();
> +       audit_log_format(ab, " pid=%u uid=%u auid=%u tty=%s ses=%u",
> +                        task_pid_nr(current),
> +                        from_kuid(&init_user_ns, cred->uid),
> +                        from_kuid(&init_user_ns, audit_get_loginuid(current)),
> +                        tty ? tty_name(tty) : "(none)",
> +                        audit_get_sessionid(current));
> +       audit_put_tty(tty);
> +       audit_log_task_context(ab); /* subj= */
> +       audit_log_format(ab, " comm=");
> +       audit_log_untrustedstring(ab, get_task_comm(comm, current));
> +       audit_log_d_path_exe(ab, current->mm); /* exe= */
> +
>         audit_log_end(ab);
>  }
>  EXPORT_SYMBOL_GPL(__audit_log_nfcfg);

-- 
paul moore
www.paul-moore.com
