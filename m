Return-Path: <SRS0=kxmZ=T6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9518C28CC3
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 14:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F78725B1F
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 14:35:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="GWJCSp8E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfE3OfI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 May 2019 10:35:08 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45093 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfE3OfD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 May 2019 10:35:03 -0400
Received: by mail-lf1-f68.google.com with SMTP id m14so5185103lfp.12
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 07:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BnDbzkkNEs3+qCAYM6PlcBSJ9muruAbc6zh0yrmMscI=;
        b=GWJCSp8Ea5nLSw4PQsmUexLPU9ilEqisyppKzq55gGe0EXTU1gK81I2OupZcNpEfBp
         FEt6cP3ID92EWi+7AOnBYGA0Ks7kMMHmIwuCOXSTnoWyt9G0QUg/qPKTyCr++U1Vj81z
         OBD9bVbRccfpHrJSutlT+QxN7HGtO6iu7CDa5SLnoPR89ac3mi2LAiNOoxPv0PDN/hp4
         l40+0DaiA/QQzBIUYu0FZHnaSsQni3VmtD1j1Ni4uJrquQC2ecy5KN+HQxdP9IoLrIqB
         NQaPK9NrzK6KSr1mQCUVyOMXunHba1wxDCzenzD+grV8InLlZw+DV7yqW3qc0uFM5f2z
         aTnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BnDbzkkNEs3+qCAYM6PlcBSJ9muruAbc6zh0yrmMscI=;
        b=cu9qWY1N8kj0MNt/kc5D/JNU5sjjm99cJkKAryM+Q8x2h2/6gfBF9uxp3BVYsu8FQE
         lQVaUDYgtwUz3tcAe9AoXID+C0U1v3RKYVSWnN59Rsy0wkAbuohM3BLjg2mnHmmZJmZ6
         vFBp/OsmjxS40OaGzqLZDw+MO1zhAq01leOvaOZrvpa/oKtasSS+C3l1GtzOKPEbRObs
         mx759nV+Vs5Wcqz3kM6XoA3iFBkuERDslVRRN1JcfZOAw9YNmk63zT4v5zseRkbFhbkW
         OVg3I3JEiZyhMExGgJ9HjxOCAkCLfOPiri3fQgu9Wg9xCzjJZOCy84Fdt/VmFElT0yNs
         Tv9w==
X-Gm-Message-State: APjAAAVCEzx0mMSzUJFyjTdONjuvox/YG6+xbr+rEqGdZh1cIbQQGWmn
        SJJqQPI2dJwXhI0N+jlE6Eq6KE/Ftv1hdq+RgH27
X-Google-Smtp-Source: APXvYqwHC8RbjMH6lxvVIhsAzDm3HE9/Eadxhwf+Gs4Sub/2cYfUPJHXYxbbG9TWyQTvzlhVlUcV6s1iN4J/NfvvlRg=
X-Received: by 2002:ac2:410a:: with SMTP id b10mr2250887lfi.175.1559226900658;
 Thu, 30 May 2019 07:35:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <0785ee2644804f3ec6af1243cc0dcf89709c1fd4.1554732921.git.rgb@redhat.com>
 <CAHC9VhRV-0LSEcRvPO1uXtKdpEQsaLZnBV3T=zcMTZPN5ugz5w@mail.gmail.com> <20190530141951.iofimovrndap4npq@madcap2.tricolour.ca>
In-Reply-To: <20190530141951.iofimovrndap4npq@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 30 May 2019 10:34:49 -0400
Message-ID: <CAHC9VhQhkzCtVOXhPL7BzaqvF0y+8gBQwhOo1EQDS2OUyZbV5g@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 08/10] audit: add containerid filtering
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 30, 2019 at 10:20 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> On 2019-05-29 18:16, Paul Moore wrote:
> > On Mon, Apr 8, 2019 at 11:41 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > Implement audit container identifier filtering using the AUDIT_CONTID
> > > field name to send an 8-character string representing a u64 since the
> > > value field is only u32.
> > >
> > > Sending it as two u32 was considered, but gathering and comparing two
> > > fields was more complex.
> > >
> > > The feature indicator is AUDIT_FEATURE_BITMAP_CONTAINERID.
> > >
> > > Please see the github audit kernel issue for the contid filter feature:
> > >   https://github.com/linux-audit/audit-kernel/issues/91
> > > Please see the github audit userspace issue for filter additions:
> > >   https://github.com/linux-audit/audit-userspace/issues/40
> > > Please see the github audit testsuiite issue for the test case:
> > >   https://github.com/linux-audit/audit-testsuite/issues/64
> > > Please see the github audit wiki for the feature overview:
> > >   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > Acked-by: Serge Hallyn <serge@hallyn.com>
> > > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > > ---
> > >  include/linux/audit.h      |  1 +
> > >  include/uapi/linux/audit.h |  5 ++++-
> > >  kernel/audit.h             |  1 +
> > >  kernel/auditfilter.c       | 47 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  kernel/auditsc.c           |  4 ++++
> > >  5 files changed, 57 insertions(+), 1 deletion(-)
> >
> > ...
> >
> > > diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> > > index 63f8b3f26fab..407b5bb3b4c6 100644
> > > --- a/kernel/auditfilter.c
> > > +++ b/kernel/auditfilter.c
> > > @@ -1206,6 +1224,31 @@ int audit_comparator(u32 left, u32 op, u32 right)
> > >         }
> > >  }
> > >
> > > +int audit_comparator64(u64 left, u32 op, u64 right)
> > > +{
> > > +       switch (op) {
> > > +       case Audit_equal:
> > > +               return (left == right);
> > > +       case Audit_not_equal:
> > > +               return (left != right);
> > > +       case Audit_lt:
> > > +               return (left < right);
> > > +       case Audit_le:
> > > +               return (left <= right);
> > > +       case Audit_gt:
> > > +               return (left > right);
> > > +       case Audit_ge:
> > > +               return (left >= right);
> > > +       case Audit_bitmask:
> > > +               return (left & right);
> > > +       case Audit_bittest:
> > > +               return ((left & right) == right);
> > > +       default:
> > > +               BUG();
> >
> > A little birdy mentioned the BUG() here as a potential issue and while
> > I had ignored it in earlier patches because this is likely a
> > cut-n-paste from another audit comparator function, I took a closer
> > look this time.  It appears as though we will never have an invalid op
> > value as audit_data_to_entry()/audit_to_op() ensure that the op value
> > is a a known good value.  Removing the BUG() from all the audit
> > comparators is a separate issue, but I think it would be good to
> > remove it from this newly added comparator; keeping it so that we
> > return "0" in the default case seems reasoanble.
>
> Fair enough.  That BUG(); can be removed.

Please send a fixup patch for this.

-- 
paul moore
www.paul-moore.com
