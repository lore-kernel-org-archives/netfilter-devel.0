Return-Path: <SRS0=paBM=CS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82385C43461
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Sep 2020 16:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 482CB2166E
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Sep 2020 16:11:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="csnRZgg0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730733AbgIIQK7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Sep 2020 12:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730885AbgIIQKf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Sep 2020 12:10:35 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C545C061756
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Sep 2020 09:10:34 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id b6so3741719iof.6
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Sep 2020 09:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5n8aQ1a5VF0LrzKn3tEHsrnNiQ5/sGuTTPZULbYhVlE=;
        b=csnRZgg0qdSt0eZ0m37mqjy/dFNGduy22GCk8KZGFATWmsuZOHelzjZRxjJI6HkreJ
         KiZNoasfu1OqDmL45V2qQCMFDVC+HrFD4tmGVtFWMACNEzYkFwD/RyNyAB5D5uUT7I4q
         isBBvL+KHndsiyv6O82F0SpVcAj1SeKsa4y8ZAOYSd38kGrUogGT4E+gGEX5d8y/7Fki
         oG+73t/RmfYmkHP+pEvNsZsu1HwTbkrgWCmMcebylZ0GHFV5rL+aHfR/S3qzwiFu7PuH
         HLCB3cqdfgPFDySABylh+VuMmmP6Iq5slNQVsv1k7pD6AAtkXHz/oIW8nAHhUGOMFgbJ
         FdtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5n8aQ1a5VF0LrzKn3tEHsrnNiQ5/sGuTTPZULbYhVlE=;
        b=DuWqmKqJD00r3zonP1u3zvzf9NC4Nrz6Wyb4KT0va7jA8CIGU+Xs2UO9eXeB4alQ1K
         WQcfwyUVxSXQUIwouxClwtVB5vwfxSYX6XN3KnkkfYEzkUYnva8oRpkWEkPBcytlFLez
         6B4+iKgInaacKWRsAJxeNXDXgFfaQC9ebOVV+IZf7T8x71QCrpc7dilTwO0xIjGXp9wW
         zAKvLYHzPbc0AOwMGWE5OgsRN5HqNxYjk3/DZI+j0JEGj79oKl4mcYE3hAEGPgTRVRZ3
         9HZZcN44OWPAWcoOoQOOEbosohr0/yVuPLH0jJRtg9jt7BCH4vZRQcFHsBGS7uOSH0mD
         ocwA==
X-Gm-Message-State: AOAM5327D7zI831htXCZlpcBLtDSzQdGWwOsEjW9cFcYOhFeRnaeg++1
        nqiQwUZaU4JIACzmNERlRNUAcxK1OvqGcP3UVjurX9nazbSReKUJ
X-Google-Smtp-Source: ABdhPJwojc8AKzqCX8v3Fye35Z7+HHJbZ8BEf8myKFpzKb4zkmE1YLEQux/mzUYYgzu6l5V1/v+91K8krf4W7TwGOBY=
X-Received: by 2002:a05:6638:3f2:: with SMTP id s18mr4820603jaq.26.1599667833710;
 Wed, 09 Sep 2020 09:10:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAAUOv8iRkeAVDn3UK8DHju+-RvWViopGajN_+9y+Rm30pTWa+A@mail.gmail.com>
 <20200909122354.GP7319@breakpoint.cc>
In-Reply-To: <20200909122354.GP7319@breakpoint.cc>
From:   Gopal Yadav <gopunop@gmail.com>
Date:   Wed, 9 Sep 2020 21:40:22 +0530
Message-ID: <CAAUOv8jy2ryt8hS3BsmgNZAyU5Kc1qFw2L1UoHrB3L_qE98AFQ@mail.gmail.com>
Subject: Re: [nftables] TODO: Replace yy_switch_to_buffer by
 yypop_buffer_state and yypush_buffer_state
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 9, 2020 at 5:53 PM Florian Westphal <fw@strlen.de> wrote:
>
> Gopal Yadav <gopunop@gmail.com> wrote:
> > Are there any beginner friendly issues to solve or any other
> > starting point?
>
> This one for example:
> https://bugzilla.netfilter.org/show_bug.cgi?id=1305
>
> Its "just" a documentation issue.  You could work from comment 4
> and improve the nft documentation to clarify 'accept' behaviour.
>
> For many other bugs it would help if we had testcases that demonstrated
> this problem in the nftables.git repo.
>
> So, if you can translate a BZ ticker to e.g. a new test case in
> tests/shell that show problem still exists in current nftables.git then
> you could submit that test case as a patch, even if the problem is not
> yet resolved.
>
> Readily available test reproducers help a lot.

Thanks for the reply. Pablo suggested to work on
https://bugzilla.netfilter.org/show_bug.cgi?id=1388
but I think his mail was not sent to the mailing list.
I am currently trying to solve that one. Will get back to look at 1305
after that.
