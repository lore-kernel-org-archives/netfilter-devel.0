Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD694C4332D
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 21:48:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93DA320768
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 21:48:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="T4F+0zg1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbgCRVsC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Mar 2020 17:48:02 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44118 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbgCRVsB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 17:48:01 -0400
Received: by mail-ed1-f68.google.com with SMTP id z3so15189776edq.11
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 14:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jSbmM7deMijcGQ2Njr0obFK5q42A00wv1XC6bXtNHSs=;
        b=T4F+0zg1O4tCjiTKCeojQKo/2Vtz1Y+alVLD9/3BaXATvaIH/n9YlZXNzm44rRIYbc
         /F5yX5PPdgh6l01fK9Gc10RKTceI3FKoMamsMY7hRmF0avd+AHmIzQx36bFZmvXUv3WA
         EvoGBOAqVPPUfit4G9+GonZdu56r9uGVHxzjN4hKfT0wxiYfjbDnp6J0f3ZqDddnq+2k
         cyBGj7HLAeLnxb7lU/gUixuR6E1k3WHUyCQ/ClL6F7PlGcFYjaOKkhpgPPSb+URJI5vX
         hlLE/L/hNKSs2ia2J+nArMBJNI5rRs49r+Pxi72D9WYQ8pY6L5sMGpDq0zB1ajX5b02A
         uXHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jSbmM7deMijcGQ2Njr0obFK5q42A00wv1XC6bXtNHSs=;
        b=ImCYxF2TwM0ZaufiQEIRhOZl49wHyLWLO5FQyKOCdT9r09sWjYNiQhHl6zFVSOApmv
         UShBcmZOOAUmWBnvZlD/op22gU0Zj9gmMw8Ec287F3R0av3PLOciTYyRwym9P7knjF3P
         h8qr4GZ25YWnMrBlLTFOJQ9j128aT2R42IjFRo/FDMn2z0oQkxBYx03+D6D8nfwizmu9
         kpnkXIWUigt4zSkmJXW0CLJXnJgzE3Oz2PdkllwV6fnRCNNeUM6wIwaF15rUYmK0Mmoq
         kMmSHlYxV8iz2hMRsbBdSuefWPto2TW35ApU15Z7Cc7vXGw40v8km07Dgv2N36XLwY0N
         JYUQ==
X-Gm-Message-State: ANhLgQ3zS0ZMowYLIcdNQVzb0FTIcILLgsjMI6pUfnRj+3JoPWiqdlOJ
        H5I+AnWS2hIOtl7ZwS1IemvX47HUWCTedAgvihAm
X-Google-Smtp-Source: ADFU+vv/EY9M8GK0pcJMqD/OH+jUGrRWl+6JVHzUqMMHKF9wP/wDKGvAN8gqZuvjirieWXrnqF8sYPlcMloCLTpwSog=
X-Received: by 2002:a17:906:7a46:: with SMTP id i6mr281388ejo.95.1584568078394;
 Wed, 18 Mar 2020 14:47:58 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <20200204231454.oxa7pyvuxbj466fj@madcap2.tricolour.ca>
 <CAHC9VhQquokw+7UOU=G0SsD35UdgmfysVKCGCE87JVaoTkbisg@mail.gmail.com>
 <3142237.YMNxv0uec1@x2> <CAHC9VhTiCHQbp2SwK0Xb1QgpUZxOQ26JKKPsVGT0ZvMqx28oPQ@mail.gmail.com>
 <20200312202733.7kli64zsnqc4mrd2@madcap2.tricolour.ca> <CAHC9VhS9DtxJ4gvOfMRnzoo6ccGJVKL+uZYe6qqH+SPqD8r01Q@mail.gmail.com>
 <20200313192306.wxey3wn2h4htpccm@madcap2.tricolour.ca> <CAHC9VhQKOpVWxDg-tWuCWV22QRu8P_NpFKme==0Ot1RQKa_DWA@mail.gmail.com>
 <20200318214154.ycxy5dl4pxno6fvi@madcap2.tricolour.ca>
In-Reply-To: <20200318214154.ycxy5dl4pxno6fvi@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 18 Mar 2020 17:47:47 -0400
Message-ID: <CAHC9VhSuMnd3-ci2Bx-xJ0yscQ=X8ZqFAcNPKpbh_ZWN3FJcuQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
        nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 18, 2020 at 5:42 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-03-18 17:01, Paul Moore wrote:
> > On Fri, Mar 13, 2020 at 3:23 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2020-03-13 12:42, Paul Moore wrote:
> >
> > ...
> >
> > > > The thread has had a lot of starts/stops, so I may be repeating a
> > > > previous suggestion, but one idea would be to still emit a "death
> > > > record" when the final task in the audit container ID does die, but
> > > > block the particular audit container ID from reuse until it the
> > > > SIGNAL2 info has been reported.  This gives us the timely ACID death
> > > > notification while still preventing confusion and ambiguity caused by
> > > > potentially reusing the ACID before the SIGNAL2 record has been sent;
> > > > there is a small nit about the ACID being present in the SIGNAL2
> > > > *after* its death, but I think that can be easily explained and
> > > > understood by admins.
> > >
> > > Thinking quickly about possible technical solutions to this, maybe it
> > > makes sense to have two counters on a contobj so that we know when the
> > > last process in that container exits and can issue the death
> > > certificate, but we still block reuse of it until all further references
> > > to it have been resolved.  This will likely also make it possible to
> > > report the full contid chain in SIGNAL2 records.  This will eliminate
> > > some of the issues we are discussing with regards to passing a contobj
> > > vs a contid to the audit_log_contid function, but won't eliminate them
> > > all because there are still some contids that won't have an object
> > > associated with them to make it impossible to look them up in the
> > > contobj lists.
> >
> > I'm not sure you need a full second counter, I imagine a simple flag
> > would be okay.  I think you just something to indicate that this ACID
> > object is marked as "dead" but it still being held for sanity reasons
> > and should not be reused.
>
> Ok, I see your point.  This refcount can be changed to a flag easily
> enough without change to the api if we can be sure that more than one
> signal can't be delivered to the audit daemon *and* collected by sig2.
> I'll have a more careful look at the audit daemon code to see if I can
> determine this.

Maybe I'm not understanding your concern, but this isn't really
different than any of the other things we track for the auditd signal
sender, right?  If we are worried about multiple signals being sent
then it applies to everything, not just the audit container ID.

> Another question occurs to me is that what if the audit daemon is sent a
> signal and it cannot or will not collect the sig2 information from the
> kernel (SIGKILL?)?  Does that audit container identifier remain dead
> until reboot, or do we institute some other form of reaping, possibly
> time-based?

In order to preserve the integrity of the audit log that ACID value
would need to remain unavailable until the ACID which contains the
associated auditd is "dead" (no one can request the signal sender's
info if that container is dead).

-- 
paul moore
www.paul-moore.com
