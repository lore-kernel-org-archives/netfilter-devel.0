Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7CBC4332B
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 22:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DAD820752
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 22:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="uJavj6m3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgCRWJt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Mar 2020 18:09:49 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42104 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgCRWJt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 18:09:49 -0400
Received: by mail-ed1-f65.google.com with SMTP id b21so64072edy.9
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 15:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JfzzU/d7+bs7S8RW80xj5NfJqnX96IweXITa93PwcGY=;
        b=uJavj6m3YaJ4njZZvPkkoXHwM7Y47+mKdHuh/KmTdTEAuJIqvcdvHnavGeq0mxKhHq
         FQf/+og8unjjRryFT1v8JempfBALvfWwTfB5QZppzzDzvZaCYDI9TZC1vDkN+5+3nHuZ
         FJw2LCwt/4fcfWLZtKC/fvuKEnrKzzRFix/IIVYKFAKA59oeuYybEcFcJxcIi4+/QSwe
         53dHRPpC7Sz01DK/Pjj55IrBCapM8oVYy+2OV3UnnjocmfcGWgLVwgVVnF2ZWAyUMLRh
         rW0iZFy1BGl/CZSTlfVlQNnAUdiOYaStXxZSH8m93VafBtO7pg4K09E92RGeTTchFYY5
         Izdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JfzzU/d7+bs7S8RW80xj5NfJqnX96IweXITa93PwcGY=;
        b=Hb+1z4gsqGRs+OjlmkBgRfy3fFiRRAYzmq0kZdp4hmQRJNUV7moe7KfirskLKuvuI8
         IC/9pZwZnivhM39qCuPCk1H/KTcpF1DZdp1Y9oP3LusbFlZ0FNwblei9WkUsoz0Sd+j8
         Wwg7+gd+oyQEf3TSFXr/ejGXrFUOIG6CjOMvwFTBo3bNuE2kg2UjbbsvSy1ewNyMNi6K
         Hd42YYyItnwaW7CmVxDQzdwWPg1watBxfTuGd5BNL4cfoDTKw2ZweGSypQas4X1BlXWb
         AH49H3Eo3SDOwr9uSvBmnIAxgmfzAYoY11VbmseTdAG2J0yq+6ReMDXq1M8xJ1Bw0Xns
         DrPQ==
X-Gm-Message-State: ANhLgQ0yIfayOG5qxLTea4X3mx/w/8ATVQR+vcMBA5mCW/lnnc3z+7Yq
        CB9rtq8gHhkKwKvY7ujUfD2RnndcynMN5TsXi0SB
X-Google-Smtp-Source: ADFU+vtv7H8q642zA3Wkxs658/ZoOMch5bUgWLX+GZ4bvwWx9WnStK5co0hnRa4gNXJW1Fh+y+4mGyf0BwiQnb6dSVs=
X-Received: by 2002:a17:906:7b8d:: with SMTP id s13mr352313ejo.77.1584569386895;
 Wed, 18 Mar 2020 15:09:46 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1584480281.git.rgb@redhat.com> <3d591dc49fcb643890b93e5b9a8169612b1c96e1.1584480281.git.rgb@redhat.com>
 <CAHC9VhTQBxzFrGn=+b9MzoapV0iiccPOLvkwemdESSb6nOFGXQ@mail.gmail.com> <20200318220012.xeeoeidz5vs6x7g4@madcap2.tricolour.ca>
In-Reply-To: <20200318220012.xeeoeidz5vs6x7g4@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 18 Mar 2020 18:09:36 -0400
Message-ID: <CAHC9VhTFSNhedSmJA38zdq3gXira9FQ6D-bFUFxnwWKcJOfpUQ@mail.gmail.com>
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

On Wed, Mar 18, 2020 at 6:00 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-03-18 17:54, Paul Moore wrote:
> > On Tue, Mar 17, 2020 at 5:31 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > NETFILTER_CFG record generation was inconsistent for x_tables and
> > > ebtables configuration changes.  The call was needlessly messy and there
> > > were supporting records missing at times while they were produced when
> > > not requested.  Simplify the logging call into a new audit_log_nfcfg
> > > call.  Honour the audit_enabled setting while more consistently
> > > recording information including supporting records by tidying up dummy
> > > checks.
> > >
> > > Add an op= field that indicates the operation being performed (register
> > > or replace).
> > >
> > > Here is the enhanced sample record:
> > >   type=NETFILTER_CFG msg=audit(1580905834.919:82970): table=filter family=2 entries=83 op=replace
> > >
> > > Generate audit NETFILTER_CFG records on ebtables table registration.
> > > Previously this was being done for x_tables registration and replacement
> > > operations and ebtables table replacement only.
> > >
> > > See: https://github.com/linux-audit/audit-kernel/issues/25
> > > See: https://github.com/linux-audit/audit-kernel/issues/35
> > > See: https://github.com/linux-audit/audit-kernel/issues/43
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  include/linux/audit.h           | 19 +++++++++++++++++++
> > >  kernel/auditsc.c                | 24 ++++++++++++++++++++++++
> > >  net/bridge/netfilter/ebtables.c | 12 ++++--------
> > >  net/netfilter/x_tables.c        | 12 +++---------
> > >  4 files changed, 50 insertions(+), 17 deletions(-)
> > >
> > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > index f9ceae57ca8d..f4aed2b9be8d 100644
> > > --- a/include/linux/audit.h
> > > +++ b/include/linux/audit.h
> > > @@ -94,6 +94,11 @@ struct audit_ntp_data {
> > >  struct audit_ntp_data {};
> > >  #endif
> > >
> > > +enum audit_nfcfgop {
> > > +       AUDIT_XT_OP_REGISTER,
> > > +       AUDIT_XT_OP_REPLACE,
> > > +};
> > > +
> > >  extern int is_audit_feature_set(int which);
> > >
> > >  extern int __init audit_register_class(int class, unsigned *list);
> > > @@ -379,6 +384,8 @@ extern int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
> > >  extern void __audit_fanotify(unsigned int response);
> > >  extern void __audit_tk_injoffset(struct timespec64 offset);
> > >  extern void __audit_ntp_log(const struct audit_ntp_data *ad);
> > > +extern void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
> > > +                             enum audit_nfcfgop op);
> > >
> > >  static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
> > >  {
> > > @@ -514,6 +521,13 @@ static inline void audit_ntp_log(const struct audit_ntp_data *ad)
> > >                 __audit_ntp_log(ad);
> > >  }
> > >
> > > +static inline void audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
> > > +                                  enum audit_nfcfgop op)
> > > +{
> > > +       if (audit_enabled)
> > > +               __audit_log_nfcfg(name, af, nentries, op);
> >
> > Do we want a dummy check here too?  Or do we always want to generate
> > this record (assuming audit is enabled) because it is a configuration
> > related record?
>
> This is an audit configuration change, so it is mandatory unless there
> is a rule that excludes it.  I talked about this in the cover letter,
> but perhaps my wording wasn't as clear as it could have been.

Yes, it wasn't clear to me what your goals were.

In general I think this patchset looks okay, but it's -rc6 so this
should wait for the next cycle; it will also give the netdev/netfilter
folks a chance to comment on this latest revision.

-- 
paul moore
www.paul-moore.com
