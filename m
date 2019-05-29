Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DC5C28CC3
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 22:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D447124298
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 22:26:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="Ro1lwjJV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfE2W00 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 18:26:26 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46949 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfE2W0Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 18:26:25 -0400
Received: by mail-lj1-f193.google.com with SMTP id m15so4068716ljg.13
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 15:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t49dJmETs8La1f+MwRhpaeRXNs8pwfNjtCbfGrPUmGI=;
        b=Ro1lwjJVVG+qfv2hVkkiiCmqyVjNxXb0ZoITXQy+P1f2GZdZ9qhO4d3e/bDxnsB4zf
         VG6lk1pc3YIXT+6MuBmXXRlQuiBjsm+UOieluWIzA1MVSrAXdvoECvq7uk6Ub9GjZF0B
         tVGRBNgcuJHEDdGzb+K4IrF0euqoyMFEdmTrJ2Q1yuusoIvJmvk9lwEm+0zz5SIuXOku
         jMMynjoocJl0WscdyzinFI3DjKPXAUNduIc5aIEfzMKre4ttNj5pz1w0j7LuWT9yXexH
         bwP0U65ZujtqZ8lmY/Xslf1D4oCvvWTWj42wkFXwRNsxqua0u6w+SRvpcMroFwi3QrQa
         JRjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t49dJmETs8La1f+MwRhpaeRXNs8pwfNjtCbfGrPUmGI=;
        b=ZfAO4wHbCBC+45S/NXdnZHpJP4629FLMWEb3gaCKQk+fj0esDE24ZoSRUnN0L7z3n4
         t5FRt6RX5t+sdhL4SliQ9LQwNRmHFPP1MtG+TVZggMYW4RWuHgnCAv050ZabouyRglfT
         wfI+3KbkTWe9miGcQlV8Krl5CBBCpz/wv5sBB6S/F61lUc9xqMqix7CYhWTO3i/QyFCM
         7h0sQ8/3YWgcxySKHwb9jq9OOq61Sfx4WOL4NBZqknf53loIwDGtmoBJccQzkDGHHMXp
         EwWnpHkK2luyuBY9q79lhIlilHbjKOX+IP7Lg5wXc9Sz8BqEL+q1JgEqd48bTPDlc9u4
         J/9w==
X-Gm-Message-State: APjAAAWcNab2aJbV0/80gbWtsJi+FpwLPDzt4BxK4BRypSuUEbQCcWO8
        9NskLWuXLCSm7ubaqCj8F8xuOsKZc9OAzA29ZK2H
X-Google-Smtp-Source: APXvYqzXoX5W/MSRe7ZM1UFVUXZ7hVlI4/qUTd+yNc10f5h38uBnQFKctQEahIj0puMuN+Akyog1+YJ/gUbmGgqoReo=
X-Received: by 2002:a2e:9106:: with SMTP id m6mr145593ljg.164.1559168783453;
 Wed, 29 May 2019 15:26:23 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <20190422113810.GA27747@hmswarspite.think-freely.org>
 <CAHC9VhQYPF2ma_W+hySbQtfTztf=K1LTFnxnyVK0y9VYxj-K=w@mail.gmail.com>
In-Reply-To: <CAHC9VhQYPF2ma_W+hySbQtfTztf=K1LTFnxnyVK0y9VYxj-K=w@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 29 May 2019 18:26:12 -0400
Message-ID: <CAHC9VhTQ0gDZoWUh1QB4b7h3AgbpkhS40jrPVpCfJb11GT_FzQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 00/10] audit: implement container identifier
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 22, 2019 at 9:49 AM Paul Moore <paul@paul-moore.com> wrote:
> On Mon, Apr 22, 2019 at 7:38 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> > On Mon, Apr 08, 2019 at 11:39:07PM -0400, Richard Guy Briggs wrote:
> > > Implement kernel audit container identifier.
> >
> > I'm sorry, I've lost track of this, where have we landed on it? Are we good for
> > inclusion?
>
> I haven't finished going through this latest revision, but unless
> Richard made any significant changes outside of the feedback from the
> v5 patchset I'm guessing we are "close".
>
> Based on discussions Richard and I had some time ago, I have always
> envisioned the plan as being get the kernel patchset, tests, docs
> ready (which Richard has been doing) and then run the actual
> implemented API by the userland container folks, e.g. cri-o/lxc/etc.,
> to make sure the actual implementation is sane from their perspective.
> They've already seen the design, so I'm not expecting any real
> surprises here, but sometimes opinions change when they have actual
> code in front of them to play with and review.
>
> Beyond that, while the cri-o/lxc/etc. folks are looking it over,
> whatever additional testing we can do would be a big win.  I'm
> thinking I'll pull it into a separate branch in the audit tree
> (audit/working-container ?) and include that in my secnext kernels
> that I build/test on a regular basis; this is also a handy way to keep
> it based against the current audit/next branch.  If any changes are
> needed Richard can either chose to base those changes on audit/next or
> the separate audit container ID branch; that's up to him.  I've done
> this with other big changes in other trees, e.g. SELinux, and it has
> worked well to get some extra testing in and keep the patchset "merge
> ready" while others outside the subsystem look things over.

I just sent my feedback on the v6 patchset, and it's small: basically
three patches with "one-liner" changes needed.

Richard, it's your call on how you want to proceed from here.  You can
post a v7 incorporating the feedback, or since the tweaks are so
minor, you can post fixup patches; the former being more
comprehensive, the later being quicker to review and digest.
Regardless of that, while we are waiting on a prototype from the
container folks, I think it would be good to pull this into a working
branch in the audit repo (as mentioned above), unless you would prefer
to keep it as a patchset on the mailing list?  If you want to go with
the working branch approach, I'll keep the branch fresh and (re)based
against audit/next and if we notice any problems you can just submit
fixes against that branch (depending on the issue they can be fixup
patches, or proper patches).  My hope is that this will enable the
process to move quicker as we get near the finish line.

-- 
paul moore
www.paul-moore.com
