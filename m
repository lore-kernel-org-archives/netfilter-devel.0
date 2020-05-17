Return-Path: <SRS0=IYfa=67=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2CAC433E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 May 2020 14:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1994207BB
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 May 2020 14:15:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AQHNj2p1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgEQOPg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 May 2020 10:15:36 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44791 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727929AbgEQOPe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 May 2020 10:15:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589724932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZSCD2rskbMKGy3GhvSaftPT2Y5k+GJ/7kryyIprAvdw=;
        b=AQHNj2p1or6dyAi+aujwENogmex3xcdZwV0dmXUPm5UoccCKJ3jlg6ytMQHin4w+yk7IXQ
        bQCMoujz7VCdBEtyH2pCTCxeMfPlYZnNldyefKsLxbhG3UH1zbuNKJj1sHDxQU2EZU8PMY
        DuhinuHOtsCM0pGtYcIPHtgMK80bJ28=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-kdyH184UP7q8iWcgAZwJLQ-1; Sun, 17 May 2020 10:15:27 -0400
X-MC-Unique: kdyH184UP7q8iWcgAZwJLQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CEF01005510;
        Sun, 17 May 2020 14:15:25 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F316D5D9D7;
        Sun, 17 May 2020 14:15:17 +0000 (UTC)
Date:   Sun, 17 May 2020 10:15:15 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     fw@strlen.de, LKML <linux-kernel@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Subject: Re: [PATCH ghak25 v4 3/3] audit: add subj creds to NETFILTER_CFG
 record to cover async unregister
Message-ID: <20200517141515.qqx3jx5ulb2546tx@madcap2.tricolour.ca>
References: <cover.1587500467.git.rgb@redhat.com>
 <b8ba40255978a73ea15e3859d5c945ecd5fede8e.1587500467.git.rgb@redhat.com>
 <CAHC9VhR9sNB58A8uQ4FNgAXOgVJ3RaWF4y5MAo=3mcTojaym0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhR9sNB58A8uQ4FNgAXOgVJ3RaWF4y5MAo=3mcTojaym0Q@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-04-28 18:25, Paul Moore wrote:
> On Wed, Apr 22, 2020 at 5:40 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > Some table unregister actions seem to be initiated by the kernel to
> > garbage collect unused tables that are not initiated by any userspace
> > actions.  It was found to be necessary to add the subject credentials to
> > cover this case to reveal the source of these actions.  A sample record:
> >
> >   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat family=bridge entries=0 op=unregister pid=153 uid=root auid=unset tty=(none) ses=unset subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2 exe=(null)
> 
> [I'm going to comment up here instead of in the code because it is a
> bit easier for everyone to see what the actual impact might be on the
> records.]
> 
> Steve wants subject info in this case, okay, but let's try to trim out
> some of the fields which simply don't make sense in this record; I'm
> thinking of fields that are unset/empty in the kernel case and are
> duplicates of other records in the userspace/syscall case.  I think
> that means we can drop "tty", "ses", "comm", and "exe" ... yes?
> 
> While "auid" is a potential target for removal based on the
> dup-or-unset criteria, I think it falls under Steve's request for
> subject info here, even if it is garbage in this case.

Can you explain why auid falls under this criteria but ses does not if
both are unset?  If auid is unset then we know ses is unset?  If subj
contains *:kernel_t:* then uid can also be dropped even though it is
set, no?  I figure if we are going to start dropping fields, might as
well drop enough to make it worth the effort, even though this is a rare
event.

As for searchability, I have solved that easily in the parser.

> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  kernel/auditsc.c | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> >
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index d281c18d1771..d7a45b181be0 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -2557,12 +2557,30 @@ void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
> >                        enum audit_nfcfgop op)
> >  {
> >         struct audit_buffer *ab;
> > +       const struct cred *cred;
> > +       struct tty_struct *tty;
> > +       char comm[sizeof(current->comm)];
> >
> >         ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_NETFILTER_CFG);
> >         if (!ab)
> >                 return;
> >         audit_log_format(ab, "table=%s family=%u entries=%u op=%s",
> >                          name, af, nentries, audit_nfcfgs[op].s);
> > +
> > +       cred = current_cred();
> > +       tty = audit_get_tty();
> > +       audit_log_format(ab, " pid=%u uid=%u auid=%u tty=%s ses=%u",
> > +                        task_pid_nr(current),
> > +                        from_kuid(&init_user_ns, cred->uid),
> > +                        from_kuid(&init_user_ns, audit_get_loginuid(current)),
> > +                        tty ? tty_name(tty) : "(none)",
> > +                        audit_get_sessionid(current));
> > +       audit_put_tty(tty);
> > +       audit_log_task_context(ab); /* subj= */
> > +       audit_log_format(ab, " comm=");
> > +       audit_log_untrustedstring(ab, get_task_comm(comm, current));
> > +       audit_log_d_path_exe(ab, current->mm); /* exe= */
> > +
> >         audit_log_end(ab);
> >  }
> >  EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
> 
> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

