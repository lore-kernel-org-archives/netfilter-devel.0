Return-Path: <SRS0=Vl9M=3M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D00C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 17:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78CB8206D4
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 17:09:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="fVFhxuuC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgAWRJS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jan 2020 12:09:18 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36964 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729262AbgAWRJS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 12:09:18 -0500
Received: by mail-lj1-f196.google.com with SMTP id o13so4380436ljg.4
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jan 2020 09:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EoI0l4kaWTQec4tn5Ld9ZCvI5RqFAqp9PrVGXBLYlGE=;
        b=fVFhxuuC85CKWEXjWPZjUwe+E2ZvU24vSAIadJBa+Ft9IRArNmW35Swl+jhyL4SbSw
         Q9y1gY0sctni33PC0OvsTEp15m3qeF+Ox4KoeaR1j1bfiGK/un6S52NDn4Mmp7JZyTWN
         T4+GcR/uluwB+tQB+fNDYzVWf25RKz6Wf9cz/hgquK9Jxf67xA/gq61Jlji6pBo0BW1h
         pphNci+Itjc9Hy6EK728qegKSUWTqi4toMGOqpiG4FTi4ZVSa3Pyo+WL4giv/emjl4KZ
         N+8QV2duNaLjezM2vWW4tbJ2IqC9/1zcehqsTVQU1Cz0GaYOg/ae7LEcFoRy5LtZ74Xo
         fKgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EoI0l4kaWTQec4tn5Ld9ZCvI5RqFAqp9PrVGXBLYlGE=;
        b=M55rWpzfW1vBS1zV9Zbfy7PzeRxLh8rGr0J94gbmxVGj3Mt0Xuin0ALwK+LYprENA7
         y4SlxfqN6+/6EciXDdtEKEZdh1aM0JOZ2KgSZa372UyI1/oYX2vOCtBwNj9wSfQusHEx
         LBrDiPyl3EUAf0EaCWCsaEea5P5sAUNmW4hxHEOYbanAe6JiyWcFVqADwiHmZ2ApzKeO
         8MhsyM9jdA5qkKtGOctNLXtPJ6XstJZvwM2lbbWoXGZH/m2oEgtO6+a4H4QNbLewjjQE
         jTIMp3q7B3IZNF0Rx5Iu8vKUJZtWOCckABmTx59CFE3SGJ36dXbdM2HAmASJ5jTVwlb+
         SeBg==
X-Gm-Message-State: APjAAAWDM1Tg8KGl32hF+QporVbAOcmZFexIsSzhdMEuQ6EJyPI4fuPB
        GjcZRjiV1oWSk2sYrypa/Tc1OL8F+qqFW8RQSJow
X-Google-Smtp-Source: APXvYqw/G8F1wO9xDPIULnMv336Q7Ztb/ejMkG/Wfe5XISfozmjQXVeq7xRRyREbIKTpRE6MgbiXKL2eAyaswTaX414=
X-Received: by 2002:a2e:9f52:: with SMTP id v18mr23988656ljk.30.1579799355718;
 Thu, 23 Jan 2020 09:09:15 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <7d7933d742fdf4a94c84b791906a450b16f2e81f.1577736799.git.rgb@redhat.com>
 <CAHC9VhSuwJGryfrBfzxG01zwb-O_7dbjS0x0a3w-XjcNuYSAcg@mail.gmail.com> <20200123162918.b3jbed7tbvr2sf2p@madcap2.tricolour.ca>
In-Reply-To: <20200123162918.b3jbed7tbvr2sf2p@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 23 Jan 2020 12:09:04 -0500
Message-ID: <CAHC9VhTusiQoudB8G5jjDFyM9WxBUAjZ6_X35ywJ063Jb75dQA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 23, 2020 at 11:29 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-01-22 16:28, Paul Moore wrote:
> > On Tue, Dec 31, 2019 at 2:50 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > Add audit container identifier support to the action of signalling the
> > > audit daemon.
> > >
> > > Since this would need to add an element to the audit_sig_info struct,
> > > a new record type AUDIT_SIGNAL_INFO2 was created with a new
> > > audit_sig_info2 struct.  Corresponding support is required in the
> > > userspace code to reflect the new record request and reply type.
> > > An older userspace won't break since it won't know to request this
> > > record type.
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  include/linux/audit.h       |  7 +++++++
> > >  include/uapi/linux/audit.h  |  1 +
> > >  kernel/audit.c              | 35 +++++++++++++++++++++++++++++++++++
> > >  kernel/audit.h              |  1 +
> > >  security/selinux/nlmsgtab.c |  1 +
> > >  5 files changed, 45 insertions(+)
> >
> > ...
> >
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index 0871c3e5d6df..51159c94041c 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > @@ -126,6 +126,14 @@ struct auditd_connection {
> > >  kuid_t         audit_sig_uid = INVALID_UID;
> > >  pid_t          audit_sig_pid = -1;
> > >  u32            audit_sig_sid = 0;
> > > +/* Since the signal information is stored in the record buffer at the
> > > + * time of the signal, but not retrieved until later, there is a chance
> > > + * that the last process in the container could terminate before the
> > > + * signal record is delivered.  In this circumstance, there is a chance
> > > + * the orchestrator could reuse the audit container identifier, causing
> > > + * an overlap of audit records that refer to the same audit container
> > > + * identifier, but a different container instance.  */
> > > +u64            audit_sig_cid = AUDIT_CID_UNSET;
> >
> > I believe we could prevent the case mentioned above by taking an
> > additional reference to the audit container ID object when the signal
> > information is collected, dropping it only after the signal
> > information is collected by userspace or another process signals the
> > audit daemon.  Yes, it would block that audit container ID from being
> > reused immediately, but since we are talking about one number out of
> > 2^64 that seems like a reasonable tradeoff.
>
> I had thought that through and should have been more explicit about that
> situation when I documented it.  We could do that, but then the syscall
> records would be connected with the call from auditd on shutdown to
> request that signal information, rather than the exit of that last
> process that was using that container.  This strikes me as misleading.
> Is that really what we want?

 ???

I think one of us is not understanding the other; maybe it's me, maybe
it's you, maybe it's both of us.

Anyway, here is what I was trying to convey with my original comment
... When we record the audit container ID in audit_signal_info() we
take an extra reference to the audit container ID object so that it
will not disappear (and get reused) until after we respond with an
AUDIT_SIGNAL_INFO2.  In audit_receive_msg() when we do the
AUDIT_SIGNAL_INFO2 processing we drop the extra reference we took in
audit_signal_info().  Unless I'm missing some other change you made,
this *shouldn't* affect the syscall records, all it does is preserve
the audit container ID object in the kernel's ACID store so it doesn't
get reused.

(We do need to do some extra housekeeping in audit_signal_info() to
deal with the case where nobody asks for AUDIT_SIGNAL_INFO2 -
basically if audit_sig_cid is not NULL we should drop a reference
before assigning it a new object pointer, and of course we would need
to set audit_sig_cid to NULL in audit_receive_msg() after sending it
up to userspace and dropping the extra ref.)

-- 
paul moore
www.paul-moore.com
