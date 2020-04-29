Return-Path: <SRS0=4AXv=6N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BEE0C83004
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 18:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59DBB2064C
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 18:48:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CrAtCqm3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgD2SsF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Apr 2020 14:48:05 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22183 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2SsE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Apr 2020 14:48:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588186082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9c/8llqBZkCeNlra1PyT1QmApy4gucK27prTzV0bdxM=;
        b=CrAtCqm307/pP62AtJ4BSbiYI30vIZyvcZWL+3+f7v8PpU7uoNXgkuEhFZ1v8ubqPgHYf2
        fm91AMQaeb0gUrgEXBYeiXlVSXd2judJZn4rTchTf1PnlevCKFRZP4uuOWX24wKYlQp5iR
        ppGMx7VVDkuljy2BBXkwSNSAUC2h37I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-knXWLH00MVG2roC0QEQWvQ-1; Wed, 29 Apr 2020 14:47:58 -0400
X-MC-Unique: knXWLH00MVG2roC0QEQWvQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5456C107ACF7;
        Wed, 29 Apr 2020 18:47:56 +0000 (UTC)
Received: from x2.localnet (ovpn-114-53.phx2.redhat.com [10.3.114.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 415D54D6F1;
        Wed, 29 Apr 2020 18:47:49 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, omosnace@redhat.com, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        ebiederm@xmission.com, tgraf@infradead.org
Subject: Re: [PATCH ghak25 v4 3/3] audit: add subj creds to NETFILTER_CFG record to cover async unregister
Date:   Wed, 29 Apr 2020 14:47:48 -0400
Message-ID: <3348737.k9gCtgYObn@x2>
Organization: Red Hat
In-Reply-To: <20200429143146.3vlcmwvljo74ydb4@madcap2.tricolour.ca>
References: <cover.1587500467.git.rgb@redhat.com> <CAHC9VhR9sNB58A8uQ4FNgAXOgVJ3RaWF4y5MAo=3mcTojaym0Q@mail.gmail.com> <20200429143146.3vlcmwvljo74ydb4@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wednesday, April 29, 2020 10:31:46 AM EDT Richard Guy Briggs wrote:
> On 2020-04-28 18:25, Paul Moore wrote:
> > On Wed, Apr 22, 2020 at 5:40 PM Richard Guy Briggs <rgb@redhat.com> 
wrote:
> > > Some table unregister actions seem to be initiated by the kernel to
> > > garbage collect unused tables that are not initiated by any userspace
> > > actions.  It was found to be necessary to add the subject credentials
> > > to  cover this case to reveal the source of these actions.  A sample
> > > record:
> > >   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat
> > >   family=bridge entries=0 op=unregister pid=153 uid=root auid=unset
> > >   tty=(none) ses=unset subj=system_u:system_r:kernel_t:s0
> > >   comm=kworker/u4:2 exe=(null)> 
> > [I'm going to comment up here instead of in the code because it is a
> > bit easier for everyone to see what the actual impact might be on the
> > records.]
> > 
> > Steve wants subject info in this case, okay, but let's try to trim out
> > some of the fields which simply don't make sense in this record; I'm
> > thinking of fields that are unset/empty in the kernel case and are
> > duplicates of other records in the userspace/syscall case.  I think
> > that means we can drop "tty", "ses", "comm", and "exe" ... yes?
> 
> From the ghak28 discussion, this list and order was selected due to
> Steve's preference for the "kernel" record convention, so deviating from
> this will create yet a new field list.  I'll defer to Steve on this.  It
> also has to do with the searchability of fields if they are missing.
> 
> I do agree that some fields will be superfluous in the kernel case.
> The most important field would be "subj", but then "pid" and "comm", I
> would think.  Based on this contents of the "subj" field, I'd think that
> "uid", "auid", "tty", "ses" and "exe" are not needed.

We can't be adding deleting fields based on how its triggered. If they are 
unset, that is fine. The main issue is they have to behave the same.

> > While "auid" is a potential target for removal based on the
> > dup-or-unset criteria, I think it falls under Steve's request for
> > subject info here, even if it is garbage in this case.

auid is always unset for daemons. We do not throw it away because of that.

-Steve

> If we keep auid, I'd say keep ses, since they usually go together,
> though they are separated by another field in this "kernel" record field
> ordering.
> 
> I expect this orphan record to occur so infrequently that I don't think
> bandwidth or space are a serious concern.
> 
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > > 
> > >  kernel/auditsc.c | 18 ++++++++++++++++++
> > >  1 file changed, 18 insertions(+)
> > > 
> > > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > > index d281c18d1771..d7a45b181be0 100644
> > > --- a/kernel/auditsc.c
> > > +++ b/kernel/auditsc.c
> > > @@ -2557,12 +2557,30 @@ void __audit_log_nfcfg(const char *name, u8 af,
> > > unsigned int nentries,> > 
> > >                        enum audit_nfcfgop op)
> > >  
> > >  {
> > >  
> > >         struct audit_buffer *ab;
> > > 
> > > +       const struct cred *cred;
> > > +       struct tty_struct *tty;
> > > +       char comm[sizeof(current->comm)];
> > > 
> > >         ab = audit_log_start(audit_context(), GFP_KERNEL,
> > >         AUDIT_NETFILTER_CFG);
> > >         if (!ab)
> > >         
> > >                 return;
> > >         
> > >         audit_log_format(ab, "table=%s family=%u entries=%u op=%s",
> > >         
> > >                          name, af, nentries, audit_nfcfgs[op].s);
> > > 
> > > +
> > > +       cred = current_cred();
> > > +       tty = audit_get_tty();
> > > +       audit_log_format(ab, " pid=%u uid=%u auid=%u tty=%s ses=%u",
> > > +                        task_pid_nr(current),
> > > +                        from_kuid(&init_user_ns, cred->uid),
> > > +                        from_kuid(&init_user_ns,
> > > audit_get_loginuid(current)), +                        tty ?
> > > tty_name(tty) : "(none)",
> > > +                        audit_get_sessionid(current));
> > > +       audit_put_tty(tty);
> > > +       audit_log_task_context(ab); /* subj= */
> > > +       audit_log_format(ab, " comm=");
> > > +       audit_log_untrustedstring(ab, get_task_comm(comm, current));
> > > +       audit_log_d_path_exe(ab, current->mm); /* exe= */
> > > +
> > > 
> > >         audit_log_end(ab);
> > >  
> > >  }
> > >  EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
> 
> - RGB
> 
> --
> Richard Guy Briggs <rgb@redhat.com>
> Sr. S/W Engineer, Kernel Security, Base Operating Systems
> Remote, Ottawa, Red Hat Canada
> IRC: rgb, SunRaycer
> Voice: +1.647.777.2635, Internal: (81) 32635




