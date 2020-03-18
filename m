Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BDDC4332B
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 21:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02D852076C
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 21:54:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="i0OAlQWb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgCRVyk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Mar 2020 17:54:40 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45422 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgCRVyj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 17:54:39 -0400
Received: by mail-ed1-f65.google.com with SMTP id u59so4432699edc.12
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 14:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=au4UNn3QqNUChn3BLHtwX07oVBM4ryrMaWKZ7Y+L8CU=;
        b=i0OAlQWb7N4fH+cATuHJJ3gHnCkllsUQZSxU/0N+JaZCg3q5a0REk7fN04Hg0BynOQ
         fl0Zn6Fe/Ej7gV8cu0p/yfUiZD2zGlfhfnkIrTooHRW/6zbBqNjGSXpOhZ46bS3WF2d9
         WPn0MwSm57hi09nyfpE8yyv1CvLqgv701gczo+pN8OuYjr4XqTgRgGV9GbpMTMbq9n9e
         rw2IpMwgvMsHE2JjEbuR1ukxdWqn6oG5guRwl8cq3xxmlCYLGsVCrmRIFNF04ZX2BqWO
         ryH2G5P2fDx+V0e87adNDb9A2ktzB2Iu6L14rhxCLJXC2STv3LiWSlpYYBvmSI1Jv9aO
         M9LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=au4UNn3QqNUChn3BLHtwX07oVBM4ryrMaWKZ7Y+L8CU=;
        b=F8SNkihLtqAQ/DB8i3gAyyN+HVdm+bwyFHlG5p376UXH3VolnRKXJYkW3no0OX1EPl
         xlb+b3pp1DrfZvYohwVavKqLdTU5Lhc81cU5q0hruwAhf3cbwS7JSmZrNy7HyLNj+Q3b
         o9NEDwDJqFKHWt4Cc9N5UpUAVsTcjl6TxVQYgkhbN11G5BX+gUYpmYmsNBf3H+5FpGd1
         jiIvA/8F1b72e9olW2c4iSFdTUkA/XTnMEYs1pN/Gl9XIJoS30H5eXcDCUf9f+dpv/K0
         8zG0kb5VGEgXoShGk3StGfhEyIdsljWnGK4wDq9jjysB4lq8hyYe4eDHAOplgyhL5pe2
         zyTQ==
X-Gm-Message-State: ANhLgQ3HSghKAsPstGy/zgcw+iHxvFimKOX5XBt1czG6n++TukVFXPrr
        T/cRMULs0aNxEZH0YfUz3xPWtDx2xvVMGZ1EJ3xj
X-Google-Smtp-Source: ADFU+vutjASI3AztJGUCiHQ3hTXDBoQauisEgUSQ6bO954EQ6P7ghZ239siSSVuKzPqcgls4Wr6aYY1bVrErMIkhK3I=
X-Received: by 2002:a17:906:7a46:: with SMTP id i6mr303161ejo.95.1584568475949;
 Wed, 18 Mar 2020 14:54:35 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1584480281.git.rgb@redhat.com> <3d591dc49fcb643890b93e5b9a8169612b1c96e1.1584480281.git.rgb@redhat.com>
In-Reply-To: <3d591dc49fcb643890b93e5b9a8169612b1c96e1.1584480281.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 18 Mar 2020 17:54:25 -0400
Message-ID: <CAHC9VhTQBxzFrGn=+b9MzoapV0iiccPOLvkwemdESSb6nOFGXQ@mail.gmail.com>
Subject: Re: [PATCH ghak25 v3 1/3] audit: tidy and extend netfilter_cfg
 x_tables and ebtables logging
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

On Tue, Mar 17, 2020 at 5:31 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> NETFILTER_CFG record generation was inconsistent for x_tables and
> ebtables configuration changes.  The call was needlessly messy and there
> were supporting records missing at times while they were produced when
> not requested.  Simplify the logging call into a new audit_log_nfcfg
> call.  Honour the audit_enabled setting while more consistently
> recording information including supporting records by tidying up dummy
> checks.
>
> Add an op= field that indicates the operation being performed (register
> or replace).
>
> Here is the enhanced sample record:
>   type=NETFILTER_CFG msg=audit(1580905834.919:82970): table=filter family=2 entries=83 op=replace
>
> Generate audit NETFILTER_CFG records on ebtables table registration.
> Previously this was being done for x_tables registration and replacement
> operations and ebtables table replacement only.
>
> See: https://github.com/linux-audit/audit-kernel/issues/25
> See: https://github.com/linux-audit/audit-kernel/issues/35
> See: https://github.com/linux-audit/audit-kernel/issues/43
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h           | 19 +++++++++++++++++++
>  kernel/auditsc.c                | 24 ++++++++++++++++++++++++
>  net/bridge/netfilter/ebtables.c | 12 ++++--------
>  net/netfilter/x_tables.c        | 12 +++---------
>  4 files changed, 50 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index f9ceae57ca8d..f4aed2b9be8d 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -94,6 +94,11 @@ struct audit_ntp_data {
>  struct audit_ntp_data {};
>  #endif
>
> +enum audit_nfcfgop {
> +       AUDIT_XT_OP_REGISTER,
> +       AUDIT_XT_OP_REPLACE,
> +};
> +
>  extern int is_audit_feature_set(int which);
>
>  extern int __init audit_register_class(int class, unsigned *list);
> @@ -379,6 +384,8 @@ extern int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
>  extern void __audit_fanotify(unsigned int response);
>  extern void __audit_tk_injoffset(struct timespec64 offset);
>  extern void __audit_ntp_log(const struct audit_ntp_data *ad);
> +extern void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
> +                             enum audit_nfcfgop op);
>
>  static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
>  {
> @@ -514,6 +521,13 @@ static inline void audit_ntp_log(const struct audit_ntp_data *ad)
>                 __audit_ntp_log(ad);
>  }
>
> +static inline void audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
> +                                  enum audit_nfcfgop op)
> +{
> +       if (audit_enabled)
> +               __audit_log_nfcfg(name, af, nentries, op);

Do we want a dummy check here too?  Or do we always want to generate
this record (assuming audit is enabled) because it is a configuration
related record?

-- 
paul moore
www.paul-moore.com
