Return-Path: <SRS0=kxmZ=T6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D096C28CC3
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 13:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03401259C6
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 13:35:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="PcjCE05V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfE3Nfv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 May 2019 09:35:51 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45082 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbfE3Nfv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 May 2019 09:35:51 -0400
Received: by mail-lj1-f196.google.com with SMTP id r76so6053595lja.12
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 06:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/U1f8Fc02eyDkuGsWIDz5srojNJJU/zoTrLNm2qEEYE=;
        b=PcjCE05Vr6571Z0FZcLJcqv+cvaAJeL7YpbARuQ2LSZIHBxhkDAdsF9jD7NhDOKngU
         6X1SX5q77QkN9n3E19d4YHs9c0CtfyLSRuUuSdOXluMQYnqok+2LuhQnfV6Yvt5gokXc
         rv1Y97UwU29b5+KdfE/UeKLzGLNovyUXymuMuyGyAd1g6N0pG2/4sWOP2UBIUSzYLfHX
         V1r+bdOV/ByhYIvgWgk1An0M77FfT6aJutWDNqmHH2KjEzC70mCUzzpod9jb6FNa/AtR
         MEO9qpdFx+xNcpWYtV4mCZ49HXeovOfghdnPjt29AHlHiv/t+7uoYA1WS7kIwbDGPK1R
         tWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/U1f8Fc02eyDkuGsWIDz5srojNJJU/zoTrLNm2qEEYE=;
        b=VKlO79R50mllhS/dCkDrXzAf1kD0C2H8G0ZA6fZ1YgXC5+hZVZcTj4aECde5yHGM0M
         LHsBk3gHjUpay/AG5QDfLUIt470S7jj/4DWKPtK+8nSHOYF8R1E8i1exa3KGjYoni6W7
         YouIP2+pCqBT+q396WTetRp3u6bQWxpuiCZq9RZEJPUklgENtNzg8pUcOAkU1WQKCQx1
         dwElp08/McP9JcF+yzzr/bRpxX+sEXyCJfXwNGAz/gN1SN5rnPh1WT+N+blveR+KHSWj
         IwyG2BN5FNyRVb/HDBAl30nnHUksWG0FYGhvaDmtYEIL2ZqZFDI0IwUt/yNkcuWSLxtt
         +IKQ==
X-Gm-Message-State: APjAAAX2HiNzEEPrW6BGv3FpWHT1F6dwH1nbhC4feerCzWJDkXJRI4tN
        Jw1Wm3H/rx26TlLmdh2tURz3jojUxOdKd5dGTBzD
X-Google-Smtp-Source: APXvYqxLKiEME9EKDe015SLMtCLzjMQupiY0eTQcPEupXRnKhW/v5gEX9weuoubW+5N0jXscBR8tMiamdrFu8nfWc0w=
X-Received: by 2002:a2e:3e14:: with SMTP id l20mr2252084lja.40.1559223348494;
 Thu, 30 May 2019 06:35:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <CAHC9VhQYPF2ma_W+hySbQtfTztf=K1LTFnxnyVK0y9VYxj-K=w@mail.gmail.com>
 <CAHC9VhTQ0gDZoWUh1QB4b7h3AgbpkhS40jrPVpCfJb11GT_FzQ@mail.gmail.com> <1674888.6UpDe63hFX@x2>
In-Reply-To: <1674888.6UpDe63hFX@x2>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 30 May 2019 09:35:36 -0400
Message-ID: <CAHC9VhQqiaHRxZkOZO2c5UzMOQ_NNu1pEsc4fQDX=Hj-HnGUoQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 00/10] audit: implement container identifier
To:     Steve Grubb <sgrubb@redhat.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 30, 2019 at 9:08 AM Steve Grubb <sgrubb@redhat.com> wrote:
> On Wednesday, May 29, 2019 6:26:12 PM EDT Paul Moore wrote:
> > On Mon, Apr 22, 2019 at 9:49 AM Paul Moore <paul@paul-moore.com> wrote:
> > > On Mon, Apr 22, 2019 at 7:38 AM Neil Horman <nhorman@tuxdriver.com>
> wrote:
> > > > On Mon, Apr 08, 2019 at 11:39:07PM -0400, Richard Guy Briggs wrote:
> > > > > Implement kernel audit container identifier.
> > > >
> > > > I'm sorry, I've lost track of this, where have we landed on it? Are we
> > > > good for inclusion?
> > >
> > > I haven't finished going through this latest revision, but unless
> > > Richard made any significant changes outside of the feedback from the
> > > v5 patchset I'm guessing we are "close".
> > >
> > > Based on discussions Richard and I had some time ago, I have always
> > > envisioned the plan as being get the kernel patchset, tests, docs
> > > ready (which Richard has been doing) and then run the actual
> > > implemented API by the userland container folks, e.g. cri-o/lxc/etc.,
> > > to make sure the actual implementation is sane from their perspective.
> > > They've already seen the design, so I'm not expecting any real
> > > surprises here, but sometimes opinions change when they have actual
> > > code in front of them to play with and review.
> > >
> > > Beyond that, while the cri-o/lxc/etc. folks are looking it over,
> > > whatever additional testing we can do would be a big win.  I'm
> > > thinking I'll pull it into a separate branch in the audit tree
> > > (audit/working-container ?) and include that in my secnext kernels
> > > that I build/test on a regular basis; this is also a handy way to keep
> > > it based against the current audit/next branch.  If any changes are
> > > needed Richard can either chose to base those changes on audit/next or
> > > the separate audit container ID branch; that's up to him.  I've done
> > > this with other big changes in other trees, e.g. SELinux, and it has
> > > worked well to get some extra testing in and keep the patchset "merge
> > > ready" while others outside the subsystem look things over.
> >
> > I just sent my feedback on the v6 patchset, and it's small: basically
> > three patches with "one-liner" changes needed.
> >
> > Richard, it's your call on how you want to proceed from here.  You can
> > post a v7 incorporating the feedback, or since the tweaks are so
> > minor, you can post fixup patches; the former being more
> > comprehensive, the later being quicker to review and digest.
> > Regardless of that, while we are waiting on a prototype from the
> > container folks, I think it would be good to pull this into a working
> > branch in the audit repo (as mentioned above), unless you would prefer
> > to keep it as a patchset on the mailing list?
>
> Personally, I'd like to see this on a branch so that it's easier to build a
> kernel locally for testing.

FWIW, if Richard does prefer for me to pull it into a working branch I
plan to include it in my secnext builds both to make it easier to test
regularly and to make the changes available to people who don't want
to build their own kernel.

* http://www.paul-moore.com/blog/d/2019/04/kernel_secnext_repo.html

-- 
paul moore
www.paul-moore.com
