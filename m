Return-Path: <SRS0=RVZI=YP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC46DCA9EB9
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 00:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8170D214B2
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 00:31:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="LybOpDYC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbfJVAbx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Oct 2019 20:31:53 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34134 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730220AbfJVAbw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 20:31:52 -0400
Received: by mail-lf1-f67.google.com with SMTP id f5so3850863lfp.1
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2019 17:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h0GVt2WTy7rJoxNXkBhE5EwsIuLJIvkg3xBSTCp/DL0=;
        b=LybOpDYCwdMtqan/8IAEiTe1HU1VkckWx3ZWV8mYQLe7Zgt30h+PDbxzKfRoufCqkH
         0EkFoBwphjIuG0KBJWy3nWftmyth2CIbnXZnldK/vgeiQwWfj1mtUGK1rMfSdc8pMB51
         lf7VBdYib0UpYD8xgV9SkKXFcJ1rLAk3x3XkzcEv6UT4PjcEMrs+38xKBtDDPEr4wvaN
         nrAA2Vaw/gGZi5/X4YKB9LA2KyU558TO4p4eR/anZndtw+7ofxScQasWigX0VUym23Br
         QmnrXFogjeYF5LcAqTgL8N2dSA/8hOsDM+71jxxz4Sq9n1e2ooqBXfN+pY0XvKsWJD0b
         xxxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h0GVt2WTy7rJoxNXkBhE5EwsIuLJIvkg3xBSTCp/DL0=;
        b=rVrPHH/6UHPcg7nJaePaFdxITfucA2u7ATLy2FWAUb85f1I0OKnlqQNT8g7zgL6+Rd
         uwFBG7VyAbD0KB6nyk7hRpKEEsgbC/bTwTIAOtXsscCZfNXfMNQBlkBtGxxCviAG+coY
         gQRR9+uFUIE4471Wtnw0PKQxbncn8R/NMSIEYEjPONfvMa/mE1rRLO21R7jnCl+sOYkE
         VsyQ9tQ/5cWufF92kd6gfjHkqJ9/zyWsRbj8A2UPxF1Ouo5IOKBmr/rhYiEF9mTwuhRl
         bjmuHbAkumprh7ufbS9q83FqAVS6V1+lB5sDVQjunw6go2Wi04RO8VkyssaUWyqTs3XV
         W0iQ==
X-Gm-Message-State: APjAAAV6DmN3yNYx8Q0HvrXoh+DaOWipwrAQzJ8CDaAW2RhTq+XCLwf3
        D8DuOCWyZm+O4/EV1BYcb6Ip7HYsfH2rdcz5quYt
X-Google-Smtp-Source: APXvYqw+rC5J+Z1nzHkK5AOHTkaVF47i78jP11Oa2nYpceyzoYzjRA6z6reajMuaPiEK48mkulR0rdvsnQt6ylqdK7I=
X-Received: by 2002:ac2:51b6:: with SMTP id f22mr16411765lfk.175.1571704309449;
 Mon, 21 Oct 2019 17:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <214163d11a75126f610bcedfad67a4d89575dc77.1568834525.git.rgb@redhat.com>
 <20191019013904.uevmrzbmztsbhpnh@madcap2.tricolour.ca> <CAHC9VhRPygA=LsHLUqv+K=ouAiPFJ6fb2_As=OT-_zB7kGc_aQ@mail.gmail.com>
 <20191021213824.6zti5ndxu7sqs772@madcap2.tricolour.ca> <CAHC9VhRdNXsY4neJpSoNyJoAVEoiEc2oW5kSscF99tjmoQAxFA@mail.gmail.com>
 <20191021235734.mgcjotdqoe73e4ha@madcap2.tricolour.ca>
In-Reply-To: <20191021235734.mgcjotdqoe73e4ha@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 21 Oct 2019 20:31:37 -0400
Message-ID: <CAHC9VhSiwnY-+2awxvGeO4a0NgfVkOPd8fzzBVujp=HtjskTuQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid
 outside init_user_ns
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

On Mon, Oct 21, 2019 at 7:58 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-10-21 17:43, Paul Moore wrote:
> > On Mon, Oct 21, 2019 at 5:38 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2019-10-21 15:53, Paul Moore wrote:
> > > > On Fri, Oct 18, 2019 at 9:39 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > On 2019-09-18 21:22, Richard Guy Briggs wrote:
> > > > > > Provide a mechanism similar to CAP_AUDIT_CONTROL to explicitly give a
> > > > > > process in a non-init user namespace the capability to set audit
> > > > > > container identifiers.
> > > > > >
> > > > > > Use audit netlink message types AUDIT_GET_CAPCONTID 1027 and
> > > > > > AUDIT_SET_CAPCONTID 1028.  The message format includes the data
> > > > > > structure:
> > > > > > struct audit_capcontid_status {
> > > > > >         pid_t   pid;
> > > > > >         u32     enable;
> > > > > > };
> > > > >
> > > > > Paul, can I get a review of the general idea here to see if you're ok
> > > > > with this way of effectively extending CAP_AUDIT_CONTROL for the sake of
> > > > > setting contid from beyond the init user namespace where capable() can't
> > > > > reach and ns_capable() is meaningless for these purposes?
> > > >
> > > > I think my previous comment about having both the procfs and netlink
> > > > interfaces apply here.  I don't see why we need two different APIs at
> > > > the start; explain to me why procfs isn't sufficient.  If the argument
> > > > is simply the desire to avoid mounting procfs in the container, how
> > > > many container orchestrators can function today without a valid /proc?
> > >
> > > Ok, sorry, I meant to address that question from a previous patch
> > > comment at the same time.
> > >
> > > It was raised by Eric Biederman that the proc filesystem interface for
> > > audit had its limitations and he had suggested an audit netlink
> > > interface made more sense.
> >
> > I'm sure you've got it handy, so I'm going to be lazy and ask: archive
> > pointer to Eric's comments?  Just a heads-up, I'm really *not* a fan
> > of using the netlink interface for this, so unless Eric presents a
> > super compelling reason for why we shouldn't use procfs I'm inclined
> > to stick with /proc.
>
> It was actually a video call with Eric and Steve where that was
> recommended, so I can't provide you with any first-hand communication
> about it.  I'll get more details...

Yeah, that sort of information really needs to be on the list.

> So, with that out of the way, could you please comment on the general
> idea of what was intended to be the central idea of this mechanism to be
> able to nest containers beyond the initial user namespace (knowing that
> a /proc interface is available and the audit netlink interface isn't
> necessary for it to work and the latter can be easily removed)?

I'm not entirely clear what you are asking about, are you asking why I
care about nesting container orchestrators?  Simply put, it is not
uncommon for the LXC/LXD folks to see nested container orchestrators,
so I felt it was important to support that use case.  When we
originally started this effort we probably should have done a better
job reaching out to the LXC/LXD folks, we may have caught this
earlier.  Regardless, we caught it, and it looks like we are on our
way to supporting it (that's good).

Are you asking why I prefer the procfs approach to setting/getting the
audit container ID?  For one, it makes it easier for a LSM to enforce
the audit container ID operations independent of the other audit
control APIs.  It also provides a simpler interface for container
orchestrators.  Both seem like desirable traits as far as I'm
concerned.

> > > The intent was to switch to the audit netlink interface for contid,
> > > capcontid and to add the audit netlink interface for loginuid and
> > > sessionid while deprecating the proc interface for loginuid and
> > > sessionid.  This was alluded to in the cover letter, but not very clear,
> > > I'm afraid.  I have patches to remove the contid and loginuid/sessionid
> > > interfaces in another tree which is why I had forgotten to outline that
> > > plan more explicitly in the cover letter.

-- 
paul moore
www.paul-moore.com
