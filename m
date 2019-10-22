Return-Path: <SRS0=RVZI=YP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C5DCA9EB9
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 14:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A87AB21872
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 14:04:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="I8+QlSF0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388921AbfJVOE7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 10:04:59 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39319 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388953AbfJVOE5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 10:04:57 -0400
Received: by mail-lj1-f193.google.com with SMTP id y3so17358176ljj.6
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2019 07:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ipC7lKranNQEvA5XU+w8tItfggky3gdViyHT7vnw0C0=;
        b=I8+QlSF0lxmX0g20D5f6hffb4H1b5cXETQLd3PtzlXXy4xyNf8DAEyiZWVoxMSqRLw
         iDvRDyyYtDsiNAe1n8bxbcFJSrMrS6PEyXGSfFsB7r2+trykXDFMwNJnymuy83wBV/WZ
         uHqXm7n3Q9KjDbpDacHFb2O7Pq1J0zzUCxa2B+VmmRHUZ28ejHg9QanR8/7UoJQIcDJ9
         vT/L1vTegygSBWqnJqr3Uxx5bJGWdZFbxlTcP30/JBlyR+0XFi2LTNp1nzk1GWcOw8gv
         2X9EhHOrB5a7GF+KRnOPMDHhEwngYEapQT6m2KRH5s2da89+D6MYXYSbcS+679cVI1CT
         9wWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ipC7lKranNQEvA5XU+w8tItfggky3gdViyHT7vnw0C0=;
        b=imti2HWDJhGRSrazD7Zk1keoP+2eNgoszWYZOQVpTv96iwX91GcKF2YIVYkXEOw6bM
         fer7XCJ1ywkO2AoVD+0pDuBgRiL6d9Wf9MX70ABfkZg1oB/ytuSnf8QPudRf23OISgvG
         XnyT792IuHgShcpZTURURyv+KI9hnGcsqbHhJ8Omcve+yEOdJReMLmTmBNLW0tfUjfmx
         96Xf/SzuYSiFCOwQ2F1XiG/yKHoeQhRR9mwALYjKttO069a8OzNicOIktCFfd3JU2FTR
         tuv5cWG2JXq52nvWIOMVo4jXcEDkFvAqmqIPOf0+vid25CdWN5JTssLPWsvWu87ysnHk
         Dw9A==
X-Gm-Message-State: APjAAAWb/lA7czWE2x2946OQn/0ke1QmhgcJxeRcMUsF3FgljOm25gc6
        4Iu1E2bZNnIaFg7DQIC1c5Ko2Gp7FYe+WVUKpWRR
X-Google-Smtp-Source: APXvYqwFBZDUQ0/QjLsJo0IeE0Yc9upPM94hvttzaBBAf7xgaQ3dTK8YpaN75qrFnlhAnGP25Lx4f2CFRdTTFtYlyHM=
X-Received: by 2002:a2e:58d:: with SMTP id 135mr3093698ljf.57.1571753093369;
 Tue, 22 Oct 2019 07:04:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <214163d11a75126f610bcedfad67a4d89575dc77.1568834525.git.rgb@redhat.com>
 <20191019013904.uevmrzbmztsbhpnh@madcap2.tricolour.ca> <CAHC9VhRPygA=LsHLUqv+K=ouAiPFJ6fb2_As=OT-_zB7kGc_aQ@mail.gmail.com>
 <20191021213824.6zti5ndxu7sqs772@madcap2.tricolour.ca> <CAHC9VhRdNXsY4neJpSoNyJoAVEoiEc2oW5kSscF99tjmoQAxFA@mail.gmail.com>
 <20191021235734.mgcjotdqoe73e4ha@madcap2.tricolour.ca> <CAHC9VhSiwnY-+2awxvGeO4a0NgfVkOPd8fzzBVujp=HtjskTuQ@mail.gmail.com>
 <20191022121302.GA9397@hmswarspite.think-freely.org>
In-Reply-To: <20191022121302.GA9397@hmswarspite.think-freely.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 22 Oct 2019 10:04:42 -0400
Message-ID: <CAHC9VhRs-1FOu_QpW5OCATjrPpCFwSzUr+Lk81t-C_wfRGWLBA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid
 outside init_user_ns
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 22, 2019 at 8:13 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> On Mon, Oct 21, 2019 at 08:31:37PM -0400, Paul Moore wrote:
> > On Mon, Oct 21, 2019 at 7:58 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2019-10-21 17:43, Paul Moore wrote:
> > > > On Mon, Oct 21, 2019 at 5:38 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > On 2019-10-21 15:53, Paul Moore wrote:
> > > > > > On Fri, Oct 18, 2019 at 9:39 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > > > On 2019-09-18 21:22, Richard Guy Briggs wrote:
> > > > > > > > Provide a mechanism similar to CAP_AUDIT_CONTROL to explicitly give a
> > > > > > > > process in a non-init user namespace the capability to set audit
> > > > > > > > container identifiers.
> > > > > > > >
> > > > > > > > Use audit netlink message types AUDIT_GET_CAPCONTID 1027 and
> > > > > > > > AUDIT_SET_CAPCONTID 1028.  The message format includes the data
> > > > > > > > structure:
> > > > > > > > struct audit_capcontid_status {
> > > > > > > >         pid_t   pid;
> > > > > > > >         u32     enable;
> > > > > > > > };
> > > > > > >
> > > > > > > Paul, can I get a review of the general idea here to see if you're ok
> > > > > > > with this way of effectively extending CAP_AUDIT_CONTROL for the sake of
> > > > > > > setting contid from beyond the init user namespace where capable() can't
> > > > > > > reach and ns_capable() is meaningless for these purposes?
> > > > > >
> > > > > > I think my previous comment about having both the procfs and netlink
> > > > > > interfaces apply here.  I don't see why we need two different APIs at
> > > > > > the start; explain to me why procfs isn't sufficient.  If the argument
> > > > > > is simply the desire to avoid mounting procfs in the container, how
> > > > > > many container orchestrators can function today without a valid /proc?
> > > > >
> > > > > Ok, sorry, I meant to address that question from a previous patch
> > > > > comment at the same time.
> > > > >
> > > > > It was raised by Eric Biederman that the proc filesystem interface for
> > > > > audit had its limitations and he had suggested an audit netlink
> > > > > interface made more sense.
> > > >
> > > > I'm sure you've got it handy, so I'm going to be lazy and ask: archive
> > > > pointer to Eric's comments?  Just a heads-up, I'm really *not* a fan
> > > > of using the netlink interface for this, so unless Eric presents a
> > > > super compelling reason for why we shouldn't use procfs I'm inclined
> > > > to stick with /proc.
> > >
> > > It was actually a video call with Eric and Steve where that was
> > > recommended, so I can't provide you with any first-hand communication
> > > about it.  I'll get more details...
> >
> > Yeah, that sort of information really needs to be on the list.
> >
> > > So, with that out of the way, could you please comment on the general
> > > idea of what was intended to be the central idea of this mechanism to be
> > > able to nest containers beyond the initial user namespace (knowing that
> > > a /proc interface is available and the audit netlink interface isn't
> > > necessary for it to work and the latter can be easily removed)?
> >
> > I'm not entirely clear what you are asking about, are you asking why I
> > care about nesting container orchestrators?  Simply put, it is not
> > uncommon for the LXC/LXD folks to see nested container orchestrators,
> > so I felt it was important to support that use case.  When we
> > originally started this effort we probably should have done a better
> > job reaching out to the LXC/LXD folks, we may have caught this
> > earlier.  Regardless, we caught it, and it looks like we are on our
> > way to supporting it (that's good).
> >
> > Are you asking why I prefer the procfs approach to setting/getting the
> > audit container ID?  For one, it makes it easier for a LSM to enforce
> > the audit container ID operations independent of the other audit
> > control APIs.  It also provides a simpler interface for container
> > orchestrators.  Both seem like desirable traits as far as I'm
> > concerned.
> >
> I agree that one api is probably the best approach here, but I actually
> think that the netlink interface is the more flexible approach.  Its a
> little more work for userspace (you have to marshal your data into a
> netlink message before sending it, and wait for an async response), but
> thats a well known pattern, and it provides significantly more
> flexibility for the kernel.  LSM already has a hook to audit netlink
> messages in sock_sendmsg, so thats not a problem ...

Look closely at how the LSM controls for netlink work and you'll see a
number of problems; basically command level granularity it hard.  On
the other hand, per-file granularity it easy.

> ... and if you use
> netlink, you get the advantage of being able to broadcast messages
> within your network namespaces, facilitating any needed orchestrator
> co-ordination.

Please don't read this comment as support of the netlink approach, but
I don't think we want to use the multicast netlink; we would want it
to be more of client/server model so that we could enforce access
controls a bit easier.  Besides, is this even a use case?

> To do the same thing with a filesystem api, you need to
> use the fanotify api, which IIRC doesn't work on proc.

Once again, I'm not sure this is a problem we are trying to solve
(broadcasting audit container ID across multiple tasks), is it?
Access to the audit container ID in userspace is something I've always
thought needs to be tightly controlled to prevent abuse.

-- 
paul moore
www.paul-moore.com
