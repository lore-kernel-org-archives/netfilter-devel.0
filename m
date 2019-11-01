Return-Path: <SRS0=Gx1r=YZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A25CA9ED0
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 16:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B163D20656
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 16:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="jPDkkCiV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfKAQWa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Nov 2019 12:22:30 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45762 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbfKAQWZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Nov 2019 12:22:25 -0400
Received: by mail-lf1-f68.google.com with SMTP id v8so7591237lfa.12
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Nov 2019 09:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P52uQ/03xxtLBhBJNHvX72kCEGcrZADr6ibMXyDJZUc=;
        b=jPDkkCiVQPhHdoqN3gETpPamjcSd0LaHORCRp24yq4o03d+MD9DpVGn/wq9II2U9Nk
         F3ZajoXsjiQ+TdEtY2Bez94BYUoVZ2Ob7wuMmMcKvjVBc1yts+OjP0vbSJcZRGtg6omT
         YCemZmox+cA9hxNDd/Y/Y8TMEssNiNI1lNDU1HfEkMYm7lrbQSIWBhRYL20eF3eXLaYB
         WMTxbN36cLWM60qesLy3Tn/AQ2PcPx+t9f3gzhWCvtPyWd+tP6kcAsulQfN2GFd/Xtqt
         WCCxWkMry213UO6vCKH9/7zUOLnXitsgv+cyTZe7wSQHdShLxWcJJIYMEpfpyafMdkns
         iHGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P52uQ/03xxtLBhBJNHvX72kCEGcrZADr6ibMXyDJZUc=;
        b=THEevCZek4sxnkOEZo/XxrfiU5EJFrcHf6dhzcWikYybBU4WHanUpScR0b2wFryTTo
         ht8/ynajVVthBvImGPu+/E8tEDjBCi5phPuNVP2An973u8hxxxehgu0CI/7lk874pVIG
         uyBY4G1oYZVpyW91UeSFUsZEWvZExRuFoZT8+4UBg5LZqw4UN+t1cYgyZs+1amaBNiEn
         Yu9TrAJ3SCpxI3CfEQzO2cVtkGVT2P2HOY9i3HSkPLsxV74GMNnS/0dyHe3ts8hq1GcK
         m+ODY0MOQU2bEUWYadRb7/J8NTCLXRDM3Sd8Xf3X8cAKhA3yWCHfE7gk4qZKmTI68vuy
         Cejw==
X-Gm-Message-State: APjAAAWzTAJzv3E2iud/sehKF9PmF85dNiEWYagE4ZWWF7coedTc2zGp
        B8m9RCK5GMa3yPOYBi4dUMqZd0Fn17uHp3QBFEWE
X-Google-Smtp-Source: APXvYqztnAP0ljp8NWIFMkniILElW3dB/q2AiVhtC69W6ZNYYpkmiK7cEliPHB6I2lTRJzaI5MaVEqHJZTKTjHz3SGs=
X-Received: by 2002:ac2:5967:: with SMTP id h7mr7585007lfp.119.1572625342721;
 Fri, 01 Nov 2019 09:22:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <CAHC9VhRDoX9du4XbCnBtBzsNPMGOsb-TKM1CC+sCL7HP=FuTRQ@mail.gmail.com>
 <20191030220320.tnwkaj5gbzchcn7j@madcap2.tricolour.ca> <3677995.NTHC7m0fHc@x2>
 <20191101150927.c5sf3n5ezfg2eano@madcap2.tricolour.ca>
In-Reply-To: <20191101150927.c5sf3n5ezfg2eano@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 1 Nov 2019 12:22:11 -0400
Message-ID: <CAHC9VhT6ggLxSKV2hM6ZfNcifzJAi_fCSXpTGtyK0nthGk_sWQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid
 outside init_user_ns
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Steve Grubb <sgrubb@redhat.com>, nhorman@tuxdriver.com,
        linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 1, 2019 at 11:10 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-10-31 10:50, Steve Grubb wrote:
> > Hello,
> >
> > TLDR;  I see a lot of benefit to switching away from procfs for setting auid &
> > sessionid.
> >
> > On Wednesday, October 30, 2019 6:03:20 PM EDT Richard Guy Briggs wrote:
> > > > Also, for the record, removing the audit loginuid from procfs is not
> > > > something to take lightly, if at all; like it or not, it's part of the
> > > > kernel API.
> >
> > It can also be used by tools to iterate processes related to one user or
> > session. I use this in my Intrusion Prevention System which will land in
> > audit user space at some point in the future.
> >
> > > Oh, I'm quite aware of how important this change is and it was discussed
> > > with Steve Grubb who saw the concern and value of considering such a
> > > disruptive change.
> >
> > Actually, I advocated for syscall. I think the gist of Eric's idea was that /
> > proc is the intersection of many nasty problems. By relying on it, you can't
> > simplify the API to reduce the complexity. Almost no program actually needs
> > access to /proc. ps does. But almost everything else is happy without it. For
> > example, when you setup chroot jails, you may have to add /dev/random or /
> > dev/null, but almost never /proc. What does force you to add /proc is any
> > entry point daemon like sshd because it needs to set the loginuid. If we
> > switch away from /proc, then sshd or crond will no longer /require/ procfs to
> > be available which again simplifies the system design.
> >
> > > Removing proc support for auid/ses would be a
> > > long-term deprecation if accepted.
> >
> > It might need to just be turned into readonly for a while. But then again,
> > perhaps auid and session should be part of /proc/<pid>/status? Maybe this can
> > be done independently and ahead of the container work so there is a migration
> > path for things that read auid or session. TBH, maybe this should have been
> > done from the beginning.
>
> How about making loginuid/contid/capcontid writable only via netlink but
> still provide the /proc interface for reading?  Deprecation of proc can
> be left as a decision for later.  This way sshd/crond/getty don't need
> /proc, but the info is still there for tools that want to read it.

Just so there is no confusion for the next patchset: I think it would
be a mistake to include any changes to loginuid in your next patchset,
even as a "RFC" at the end.  Also, barring some shocking comments from
Eric relating to the imminent death of /proc in containers, I think it
would also be a mistake to include the netlink API.

Let's keep it small and focused :)

-- 
paul moore
www.paul-moore.com
