Return-Path: <SRS0=aYEw=4G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5192EC34031
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 22:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26B3922B48
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 22:47:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IEOSkXEf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgBRWrj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Feb 2020 17:47:39 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46222 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726461AbgBRWri (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 17:47:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582066056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UdLjC4QY0dRRlMObceUJJ6AgKC0QDK6iC3rlvBmMiGI=;
        b=IEOSkXEfmCZbtOxcfsZsdQXe9xOK4E6MfJlFJMoFSLPV4wZwF6GLQNhCw8GhhhmqUss+5F
        iPKjcGXVIhy7P932ZZIsZIL6qUPOgS29q4wGHnPeDYUODX/LrATal4jr0YTxNChCW92VCR
        uc7C+/+7zt9MabhTF3IGbNbG7mwYESM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-bqp_KELENdqb7_5NzKddPw-1; Tue, 18 Feb 2020 17:47:32 -0500
X-MC-Unique: bqp_KELENdqb7_5NzKddPw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B51C61005512;
        Tue, 18 Feb 2020 22:47:30 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD69460BE1;
        Tue, 18 Feb 2020 22:47:22 +0000 (UTC)
Date:   Tue, 18 Feb 2020 17:47:20 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, ebiederm@xmission.com,
        tgraf@infradead.org
Subject: Re: [PATCH ghak25 v2 4/9] audit: record nfcfg params
Message-ID: <20200218224720.dwe4ibxxca3mesha@madcap2.tricolour.ca>
References: <cover.1577830902.git.rgb@redhat.com>
 <b1b2e6f917816c4ae85b53d7f93c10c3d1df4a53.1577830902.git.rgb@redhat.com>
 <CAHC9VhRSRggBD9QgXD7-YEx=qY7Ym_1D12y3anAihE=9P7r-6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRSRggBD9QgXD7-YEx=qY7Ym_1D12y3anAihE=9P7r-6w@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-01-30 22:18, Paul Moore wrote:
> On Mon, Jan 6, 2020 at 1:55 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > Record the auditable parameters of any non-empty netfilter table
> > configuration change.
> >
> > See: https://github.com/linux-audit/audit-kernel/issues/25
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/audit.h | 11 +++++++++++
> >  kernel/auditsc.c      | 16 ++++++++++++++++
> >  2 files changed, 27 insertions(+)
> 
> I can not see a good reason why this patch is separate from patches 5
> and 6, please squash them down into one patch.  As it currently stands
> the logging function introduced here has no caller so it is pointless
> by itself.  Strive to make an individual patch have some significance
> on its own whenever possible.
> 
> This will also help you write a better commit description, right now
> the commit description tells me nothing, but if you bring in the other
> patches you can talk about consolidating similar code into a common
> function.

Fair enough.  I could see squashing some of these, but there are a
number of issues being addressed and would like to see some granularity,
but as you point out, each patch should stand on its own...

> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index f9ceae57ca8d..96cabb095eed 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -379,6 +379,7 @@ extern int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
> >  extern void __audit_fanotify(unsigned int response);
> >  extern void __audit_tk_injoffset(struct timespec64 offset);
> >  extern void __audit_ntp_log(const struct audit_ntp_data *ad);
> > +extern void __audit_nf_cfg(const char *name, u8 af, int nentries);
> >
> >  static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
> >  {
> > @@ -514,6 +515,12 @@ static inline void audit_ntp_log(const struct audit_ntp_data *ad)
> >                 __audit_ntp_log(ad);
> >  }
> >
> > +static inline void audit_nf_cfg(const char *name, u8 af, int nentries)
> > +{
> > +       if (!audit_dummy_context())
> > +               __audit_nf_cfg(name, af, nentries);
> 
> See my comments below about audit_enabled.

I've cleaned up audit_enabled and removed dummy due to ghak120.

> > +}
> > +
> >  extern int audit_n_rules;
> >  extern int audit_signals;
> >  #else /* CONFIG_AUDITSYSCALL */
> > @@ -646,6 +653,10 @@ static inline void audit_ntp_log(const struct audit_ntp_data *ad)
> >
> >  static inline void audit_ptrace(struct task_struct *t)
> >  { }
> > +
> > +static inline void audit_nf_cfg(const char *name, u8 af, int nentries)
> > +{ }
> > +
> >  #define audit_n_rules 0
> >  #define audit_signals 0
> >  #endif /* CONFIG_AUDITSYSCALL */
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 4effe01ebbe2..4e1df4233cd3 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -2545,6 +2545,22 @@ void __audit_ntp_log(const struct audit_ntp_data *ad)
> >         audit_log_ntp_val(ad, "adjust", AUDIT_NTP_ADJUST);
> >  }
> >
> > +void __audit_nf_cfg(const char *name, u8 af, int nentries)
> 
> Should nentries be an unsigned int?

Yes, it should, thank you.

> > +{
> > +       struct audit_buffer *ab;
> > +       struct audit_context *context = audit_context();
> 
> This is a good example of why the context of a caller matters; taken
> alone I would say that we need a check for audit_enabled here, but if
> we look at the latter patches we can see that the caller already has
> the audit_enabled check.
> 
> Considering that the caller is already doing an audit_enabled check,
> we might want to consider moving the audit_enabled check into
> audit_nf_cfg() where we do the dummy context check.  It's a static
> inline so there shouldn't be a performance impact and it makes the
> caller's code cleaner.
> 
> > +       if (!nentries)
> > +               return;
> > +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_NETFILTER_CFG);
> 
> Why do we need the context variable, why not just call audit_context()
> here directly?

Context has been cleaned up.

> > +       if (!ab)
> > +               return; /* audit_panic or being filtered */
> 
> We generally don't add comments when audit_log_start() fails
> elsewhere, please don't do it here.

Ok.

> > +       audit_log_format(ab, "table=%s family=%u entries=%u",
> > +                        name, af, nentries);
> > +       audit_log_end(ab);
> > +}
> > +EXPORT_SYMBOL_GPL(__audit_nf_cfg);
> > +
> >  static void audit_log_task(struct audit_buffer *ab)
> >  {
> >         kuid_t auid, uid;
> > --
> > 1.8.3.1
> 
> --
> paul moore
> www.paul-moore.com
> 

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

