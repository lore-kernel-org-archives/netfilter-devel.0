Return-Path: <SRS0=kxmZ=T6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1111BC28CC2
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 14:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD62225AFA
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 14:32:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="XTIIueYD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfE3Ocj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 May 2019 10:32:39 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36018 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfE3Oci (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 May 2019 10:32:38 -0400
Received: by mail-lf1-f68.google.com with SMTP id q26so5222515lfc.3
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 07:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vPRuBME96qBkv2+pdKHmfYwrxMsHLYg2XjuDskufNdA=;
        b=XTIIueYDuIgusp3aH/O/Ki3sag5Wo0nfFBfQ5a1MquEch+jZpd5CxLU9S/Vcl1vcBP
         +e/cbimawwKO5T7z6axW+B8doqpZbxx+w4JqnZ1W4X0pNfaJsiS6UNFI9ppHs0yLg8jA
         MJZ1u1tJuNQZIt4PnlrR7EOBDumvSxEOcENCwrOeR4qPt82fOdeBPxdvUPRN3VzBm2zs
         5jc3A6uBDJ0mhFfHdcm3oAtkX645YiV0lWSAfOFzGSySLJV6dm/2IM67xOOsUGKcQE4F
         uUDgJNZPQukOMWkZfVyK5chCylXVcH6Ovs78CXXT6oZrsvd2YVkdsa1SS8uvVOuJDPIW
         Q3Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vPRuBME96qBkv2+pdKHmfYwrxMsHLYg2XjuDskufNdA=;
        b=NgMRCA7lI2ynZPDZVvdVChkI8Jmwd7p7aSKog1lTHelt2wf53O1G+yLypAK2nKU6SE
         ncpBperirH1XnSy4Y0kyfGLF4fp8K1GFPx6DrtNi2bfzyuGcsXudJFp8BTuBId31nssv
         xj95yYfdW+gYldmGpw2+WgnRswEYw0/pRul4p1dz/bfBKEffLPEnHchLnugm1irbVY0o
         qua2ka3x5VldpVxZ7QwgCc2L4csRwp/GFFIyetvdD9Do1oKbgkfzMs/5sh3Lb0IMlZrv
         UuQ2KZAcCRBQOmxvog0ZpyF6kd7chqnfqTawGaSd9zolM59ggleZQiTaZTBbSMwDUwUs
         hiVg==
X-Gm-Message-State: APjAAAWyhSB7mYSVtMCXyJGKgv29wnICC5wPtxBua5Ly+2FJY2qSSbJg
        NQ2ohW9EkTRPj6xRVdZEnVgFXDw4PYTFnkKz68Bc
X-Google-Smtp-Source: APXvYqwqhEkdksMPTeb2g5KCjCxj8n1bQStwL7p4+8Wc9za8dt2GnyEk0aqQIiknzks4C0Ggoh9fezHY+u9LtZClqqc=
X-Received: by 2002:ac2:4358:: with SMTP id o24mr2301162lfl.13.1559226755674;
 Thu, 30 May 2019 07:32:35 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <423ed5e5c5e4ed7c3e26ac7d2bd7c267aaae777c.1554732921.git.rgb@redhat.com>
 <CAHC9VhQ9t-mvJGNCzArjg+MTGNXcZbVrWV4=RUD5ML_bHqua1Q@mail.gmail.com> <20190530141555.qqcbasvyp7eokwjz@madcap2.tricolour.ca>
In-Reply-To: <20190530141555.qqcbasvyp7eokwjz@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 30 May 2019 10:32:24 -0400
Message-ID: <CAHC9VhQ0miKFDegG-FTF6_y1nfOPpf69L8ONd3xgCZZxRrmo1w@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 09/10] audit: add support for containerid to
 network namespaces
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

On Thu, May 30, 2019 at 10:16 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> On 2019-05-29 18:17, Paul Moore wrote:
> > On Mon, Apr 8, 2019 at 11:41 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > Audit events could happen in a network namespace outside of a task
> > > context due to packets received from the net that trigger an auditing
> > > rule prior to being associated with a running task.  The network
> > > namespace could be in use by multiple containers by association to the
> > > tasks in that network namespace.  We still want a way to attribute
> > > these events to any potential containers.  Keep a list per network
> > > namespace to track these audit container identifiiers.
> > >
> > > Add/increment the audit container identifier on:
> > > - initial setting of the audit container identifier via /proc
> > > - clone/fork call that inherits an audit container identifier
> > > - unshare call that inherits an audit container identifier
> > > - setns call that inherits an audit container identifier
> > > Delete/decrement the audit container identifier on:
> > > - an inherited audit container identifier dropped when child set
> > > - process exit
> > > - unshare call that drops a net namespace
> > > - setns call that drops a net namespace
> > >
> > > Please see the github audit kernel issue for contid net support:
> > >   https://github.com/linux-audit/audit-kernel/issues/92
> > > Please see the github audit testsuiite issue for the test case:
> > >   https://github.com/linux-audit/audit-testsuite/issues/64
> > > Please see the github audit wiki for the feature overview:
> > >   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > > ---
> > >  include/linux/audit.h | 19 +++++++++++
> > >  kernel/audit.c        | 88 +++++++++++++++++++++++++++++++++++++++++++++++++--
> > >  kernel/nsproxy.c      |  4 +++
> > >  3 files changed, 108 insertions(+), 3 deletions(-)
> >
> > ...
> >
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index 6c742da66b32..996213591617 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > @@ -376,6 +384,75 @@ static struct sock *audit_get_sk(const struct net *net)
> > >         return aunet->sk;
> > >  }
> > >
> > > +void audit_netns_contid_add(struct net *net, u64 contid)
> > > +{
> > > +       struct audit_net *aunet;
> > > +       struct list_head *contid_list;
> > > +       struct audit_contid *cont;
> > > +
> > > +       if (!net)
> > > +               return;
> > > +       if (!audit_contid_valid(contid))
> > > +               return;
> > > +       aunet = net_generic(net, audit_net_id);
> > > +       if (!aunet)
> > > +               return;
> > > +       contid_list = &aunet->contid_list;
> > > +       spin_lock(&aunet->contid_list_lock);
> > > +       list_for_each_entry_rcu(cont, contid_list, list)
> > > +               if (cont->id == contid) {
> > > +                       refcount_inc(&cont->refcount);
> > > +                       goto out;
> > > +               }
> > > +       cont = kmalloc(sizeof(struct audit_contid), GFP_ATOMIC);
> > > +       if (cont) {
> > > +               INIT_LIST_HEAD(&cont->list);
> >
> > I thought you were going to get rid of this INIT_LIST_HEAD() call?
>
> I was intending to, and then Neil weighed in with this opinion:
>
>         https://www.redhat.com/archives/linux-audit/2019-April/msg00014.html
>
> If you feel that isn't important, please remove it.

Okay, I missed/forgot that, it seems like the right thing to do is to
leave it as-is.

-- 
paul moore
www.paul-moore.com
