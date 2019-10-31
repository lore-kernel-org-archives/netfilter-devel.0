Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B0DECA9ECE
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 23:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E533D20862
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 23:38:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="PBPIT77A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbfJaXiF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 19:38:05 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34516 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbfJaXiB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 19:38:01 -0400
Received: by mail-lj1-f194.google.com with SMTP id 139so8470975ljf.1
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2019 16:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BhXMszijrgAIYzZ9gxH9cFx8EddXNjy2TqQatbYc+Nk=;
        b=PBPIT77AyNqMEwQoyQaCVkLT7M8TfLPd670Drrfj3I0N9/7rXzhpyODn6ZT2yOPckv
         Qilg0l2iIs3UAOmuW8gShWyhaY4PigFiFVzalfqYDBp0oX4PNC/kLszdO9L7c4pT8Cy9
         smo0IdWRKwLl/IbLW0IV5GFldBbIePTM3ejqrwHqLwPH5t3aRPk6EcmXOUvJS6vLwl84
         AFhXYsPEGcB2PqjP4vW+wM6A7JP+eryJelp5BLL9FrnWDvkUc/1vuW51d1lWSLC8Sjjb
         DM60FyewAhh+/w4wnrPgFSBfxJW8wUjS3sROz85MqDxchJDEKZmEFzyf/2uIe0AWD17+
         GwvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BhXMszijrgAIYzZ9gxH9cFx8EddXNjy2TqQatbYc+Nk=;
        b=bCe0s7N+InAL4Agrxz9vtstLzZJImigLzIg4krGoOjKGq+xox1a8U1ednF8Ge5/8xo
         ZBIDp6IuDPIAY541xP7W4nNUOkUBw8ibAXtIoJJWkIVnDbQlRObcvkR5yzScD1+ykIe6
         ghqjGWVDJLfsjM/lhBQWEr/7Bm3Cd3eJsNaODv0qnQ1E41TWpS3aud6v80LzywtnKavx
         0pFdkPGYud/eINPSNuT8glfIWqO6rBM0PDR8EAiBHxNllM3X5nstZZrZigHirQc+7rWF
         ctQbJHDKnXvBvYjB3qjVsQNuwP8G62o8p5RljyA7Mj+a6mowRpCa56rUmCFXwBZQea2c
         KREA==
X-Gm-Message-State: APjAAAWWe8OmojEGjBFMSySapsqThcBW6IyIbDQbKcJioZgJsWhkPpPw
        VfT12EbWEELDw9WM5WYCzHXG7N7a++syco0M0XKq
X-Google-Smtp-Source: APXvYqy8BRCKDLBn26Bkj59INhzmzbXz5OoQirpWl9olE5rViDzVr+PfQj3xwew3Q+hP7oK7j+pufcBguSFvNfQncXo=
X-Received: by 2002:a2e:9249:: with SMTP id v9mr6136219ljg.184.1572565079262;
 Thu, 31 Oct 2019 16:37:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <CAHC9VhRDoX9du4XbCnBtBzsNPMGOsb-TKM1CC+sCL7HP=FuTRQ@mail.gmail.com>
 <20191030220320.tnwkaj5gbzchcn7j@madcap2.tricolour.ca> <3677995.NTHC7m0fHc@x2>
In-Reply-To: <3677995.NTHC7m0fHc@x2>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 31 Oct 2019 19:37:47 -0400
Message-ID: <CAHC9VhQ6Jq5kfrBZ21t9oFR9pYe5gxE2FxLPq27PcSCz4oFauA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid
 outside init_user_ns
To:     Steve Grubb <sgrubb@redhat.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 31, 2019 at 10:51 AM Steve Grubb <sgrubb@redhat.com> wrote:
> On Wednesday, October 30, 2019 6:03:20 PM EDT Richard Guy Briggs wrote:
> > > Also, for the record, removing the audit loginuid from procfs is not
> > > something to take lightly, if at all; like it or not, it's part of the
> > > kernel API.
>
> It can also be used by tools to iterate processes related to one user or
> session. I use this in my Intrusion Prevention System which will land in
> audit user space at some point in the future.

Let's try to stay focused on the audit container ID functionality; I
fear if we start bringing in other unrelated issues we are never going
to land these patches.

> > Oh, I'm quite aware of how important this change is and it was discussed
> > with Steve Grubb who saw the concern and value of considering such a
> > disruptive change.
>
> Actually, I advocated for syscall. I think the gist of Eric's idea was that /
> proc is the intersection of many nasty problems. By relying on it, you can't
> simplify the API to reduce the complexity.

I guess complexity is relative in a sense, but reading and writing a
number from a file in procfs seems awfully simple to me.

> Almost no program actually needs
> access to /proc. ps does. But almost everything else is happy without it. For
> example, when you setup chroot jails, you may have to add /dev/random or /
> dev/null, but almost never /proc. What does force you to add /proc is any
> entry point daemon like sshd because it needs to set the loginuid. If we
> switch away from /proc, then sshd or crond will no longer /require/ procfs to
> be available which again simplifies the system design.

It's not that simple, there are plenty of container use cases beyond
ps which require procfs:

Most LSM aware applications require procfs to view and manage some LSM
state (e.g. /proc/self/attr).

System containers, containers that run their own init/systemd/etc.,
require a working procfs.

Nested container orchestrators often run in system containers, which
require a working procfs (see above).

I'm sure there are plenty others, but these are the ones that came
immediately to mind.

-- 
paul moore
www.paul-moore.com
