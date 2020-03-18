Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98675C4332D
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 22:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 671F820752
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 22:00:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dVMh+Pfw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgCRWAq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Mar 2020 18:00:46 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:41682 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726663AbgCRWAp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 18:00:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584568844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qG7boIVK6OX8dp/ludWC81+XEBL3Mxw2bGuQhTDae7o=;
        b=dVMh+PfwrzKeZhJHQahJvKZ7Y6RfVIQWpR3dhsYRMCXDXC3T6DISd7hbuzyd8jsaNMKRj1
        p8JRcL5RmYWLRPEv+Z0hg9VZkNi3vGOHQ1dE+TkZnIH91qal88mdBwgv0z3oACyQAlzXvl
        eu1/NQrwUTRIWLRrXFwPCvNWmb0loc8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-fC-cl_zrMReDbm8tqbN0mQ-1; Wed, 18 Mar 2020 18:00:43 -0400
X-MC-Unique: fC-cl_zrMReDbm8tqbN0mQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67CAF8014CC;
        Wed, 18 Mar 2020 22:00:41 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D979C5D9E5;
        Wed, 18 Mar 2020 22:00:16 +0000 (UTC)
Date:   Wed, 18 Mar 2020 18:00:12 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, ebiederm@xmission.com,
        tgraf@infradead.org
Subject: Re: [PATCH ghak25 v3 1/3] audit: tidy and extend netfilter_cfg
 x_tables and ebtables logging
Message-ID: <20200318220012.xeeoeidz5vs6x7g4@madcap2.tricolour.ca>
References: <cover.1584480281.git.rgb@redhat.com>
 <3d591dc49fcb643890b93e5b9a8169612b1c96e1.1584480281.git.rgb@redhat.com>
 <CAHC9VhTQBxzFrGn=+b9MzoapV0iiccPOLvkwemdESSb6nOFGXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTQBxzFrGn=+b9MzoapV0iiccPOLvkwemdESSb6nOFGXQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-03-18 17:54, Paul Moore wrote:
> On Tue, Mar 17, 2020 at 5:31 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > NETFILTER_CFG record generation was inconsistent for x_tables and
> > ebtables configuration changes.  The call was needlessly messy and there
> > were supporting records missing at times while they were produced when
> > not requested.  Simplify the logging call into a new audit_log_nfcfg
> > call.  Honour the audit_enabled setting while more consistently
> > recording information including supporting records by tidying up dummy
> > checks.
> >
> > Add an op= field that indicates the operation being performed (register
> > or replace).
> >
> > Here is the enhanced sample record:
> >   type=NETFILTER_CFG msg=audit(1580905834.919:82970): table=filter family=2 entries=83 op=replace
> >
> > Generate audit NETFILTER_CFG records on ebtables table registration.
> > Previously this was being done for x_tables registration and replacement
> > operations and ebtables table replacement only.
> >
> > See: https://github.com/linux-audit/audit-kernel/issues/25
> > See: https://github.com/linux-audit/audit-kernel/issues/35
> > See: https://github.com/linux-audit/audit-kernel/issues/43
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/audit.h           | 19 +++++++++++++++++++
> >  kernel/auditsc.c                | 24 ++++++++++++++++++++++++
> >  net/bridge/netfilter/ebtables.c | 12 ++++--------
> >  net/netfilter/x_tables.c        | 12 +++---------
> >  4 files changed, 50 insertions(+), 17 deletions(-)
> >
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index f9ceae57ca8d..f4aed2b9be8d 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -94,6 +94,11 @@ struct audit_ntp_data {
> >  struct audit_ntp_data {};
> >  #endif
> >
> > +enum audit_nfcfgop {
> > +       AUDIT_XT_OP_REGISTER,
> > +       AUDIT_XT_OP_REPLACE,
> > +};
> > +
> >  extern int is_audit_feature_set(int which);
> >
> >  extern int __init audit_register_class(int class, unsigned *list);
> > @@ -379,6 +384,8 @@ extern int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
> >  extern void __audit_fanotify(unsigned int response);
> >  extern void __audit_tk_injoffset(struct timespec64 offset);
> >  extern void __audit_ntp_log(const struct audit_ntp_data *ad);
> > +extern void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
> > +                             enum audit_nfcfgop op);
> >
> >  static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
> >  {
> > @@ -514,6 +521,13 @@ static inline void audit_ntp_log(const struct audit_ntp_data *ad)
> >                 __audit_ntp_log(ad);
> >  }
> >
> > +static inline void audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
> > +                                  enum audit_nfcfgop op)
> > +{
> > +       if (audit_enabled)
> > +               __audit_log_nfcfg(name, af, nentries, op);
> 
> Do we want a dummy check here too?  Or do we always want to generate
> this record (assuming audit is enabled) because it is a configuration
> related record?

This is an audit configuration change, so it is mandatory unless there
is a rule that excludes it.  I talked about this in the cover letter,
but perhaps my wording wasn't as clear as it could have been.

audit_dummy_context was deliberately removed to make this record
delivered by default.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

